-------------------------------------------------------------------
---------------------------  widget:manager  ----------------------
-------------------------------------------------------------------
--[[
  Application
    
    wd_manager.reloadParents()      -- reload all dynamic widgets
    
    
  Internal use:
    
  date: 26/11/2018 
  by: Raul Mungai
--]]


-- Load artworks
----------------
css.load_btn_img ("\\buttons\\plugin_add.png",  "wdadd") 
css.load_btn_img ("\\buttons\\plugin_delete.png",  "wddelete") 

css.load_img ("\\icons\\move.png", "move", "icon")    -- move icon
  
-- Global Object
wd_manager = {}

  local wdList = {}   -- {radix=iradix, UID=iUID, wdptr=wdItem_t}
    
  workingParent = ""
  
  -- widget win related list
  local elmentH = 20
  local elmentW = 290
  local zoneLbl_space = 1    -- items spacyng
  local elementStartY = 25
  local elementStartX = 10
  
  --local list_addOnly = false        -- add only
  --local last_scrollIndex = -1
  local _scrollIndex = 1
  
  local currWidgetSelected = nil
  local currParentSelected = nil
  local moveInProgress = false
  
  local wd_cfg_fname = "widgetslst.cfg"
    
  -- check for in list area coords
  local function wd_manager_is_listArea(x,y)    
    if x < elementStartX or x > elementStartX + elmentW then return false end
    if y < elementStartY then return false end
    return true
  end

  -- get widget index (return -1 if not exeists)
  local function wd_manager_item_get_index (radix, UID)
    for i=1, #wdList do
      if wdList[i].radix ~= "" then
        if wdList[i].radix == radix and wdList[i].UID == UID then
          return i
        end
      end
    end
    return -1
  end
  
  -- widget add
  function wd_manager.widget_add (wdItem_t)
    local iradix = wdItem_t.radix
    local iUID = wdItem_t.UID
    if iradix == nil or iUID == nil then return 0 end
    if wd_manager_item_get_index (iradix, iUID) ~= -1 then return 0 end
    -- add items
    table.insert(wdList, {radix=iradix, UID=iUID, wdptr=wdItem_t})
    return 1
  end
  
  -- widget remove
  function wd_manager.widget_remove (wdItem_t)
    local iradix = wdItem_t.radix
    local iUID = wdItem_t.UID
    if iradix == nil or iUID == nil then return 0 end
    local idx wd_manager_item_get_index (iradix, iUID)
    if idx == -1 then return 0 end
    table.remove (wdList, idx)
    return 1
  end
  
  -- get widget prperties from index
  function wd_manager.item_get (idx)
    if idx < 1 or idx > #wdList then return nil end
    return wdList[idx]
  end
  
  
  -- get widget data from object name (return widget and parent instance)
  function wd_manager.wd_get (oname)
    for i=1, #wdList do
      if wdList[i].radix ~= "" then
        local wd = wdList[i].wdptr
        if wd ~= nil then
          if wd.parents ~= nil then
            for i=1, #wd.parents do
              if wd.parents[i].name == oname then
                return wd, wd.parents[i]
              end
            end
          end
        end
      end
    end
    return nil
  end
  
  
  -- ** widget list: window related **
  
  --load widget list (windw related)
  function wd_manager.wdWinRelated_lst_show(winTitle, btnAdd, btnOK, btnDel, btnCanc)
    -- Load related widget
    local idx = 1
    local wd = {}
    o_list.init()  -- clr list
    repeat
      wd = wd_manager.item_get (idx)
      if wd ~= nil then
        local widget = wd.wdptr
        -- scan parents
        if widget.parents ~= nil then
          for i=1, #widget.parents do
            if widget.parents[i].parent == wd_manager.workingParent then
              -- register widget
              o_list.addItem(widget.icon, widget.desc, widget.radix ,widget.UID, wd.wdptr)
              break
            end
          end
        end
      end
      idx = idx + 1
    until (wd == nil)
    
    -- config button events
    o_list.btn_add("wdadd")     -- custom button icons
    o_list.btn_del("wddelete")        
    o_list.options("wdlist", false, false,"icon")
    o_list.extern_cb(btnDel, btnAdd, nil)
    o_list.show(winTitle, btnOK, btnCanc, 20)    
  end
  
  --load free widget list ()
  function wd_manager.wdWinFree_lst_show(winTitle, cb_OK, cb_Canc)
    -- Load related widget
    local idx = 1
    local wd = {}
    local addi = false
    o_list.init()  -- clr list
    repeat
      wd = wd_manager.item_get (idx)
      if wd ~= nil then
        local widget = wd.wdptr
        -- scan parents
        addi = true
        if widget.parents ~= nil then
          for i=1, #widget.parents do
            if widget.parents[i].parent == wd_manager.workingParent then
              addi = false
              break
            end
          end
        end
        if addi == true then
          o_list.addItem(widget.icon, widget.desc, widget.radix ,widget.UID, wd.wdptr)    -- register widget
        end
      end
      idx = idx + 1
    until (wd == nil)
    
    -- config button events
    o_list.options("wdadd", false, false)
    o_list.show(winTitle, cb_OK, cb_Canc, 20)
  end
  
  -- add parent to widget
  function wd_manager.addParent (wd, nparent)
    local wnr = "ww&"
    local i = 1
    local nwn = ""
    while true do
      local xx,yy = sknWin.size(wnr .. tostring(i))
      if xx == nil then
        nwn = wnr .. tostring(i)
        break;
      end
      i = i+1  
    end
    if nwn == "" then return end
    -- Auto place
    local x = 50
    local y = 50
    table.insert(wd.parents, {parent=nparent, name=nwn, x=x, y=y})
    
    -- create instance for new parent
    wd.f_reg (wd, nwn, nparent, x, y)
    
    -- activate the long touch moving event
    sknWin.longTouchCB(nwn, "wd_manager.moveClone")
  end
  
  -- remove parent from widget
  function wd_manager.removeParentFromWidget (wd, nparent)
    -- find object
    for i=1, #wd.parents do
      if wd.parents[i].parent == nparent then
        wd.f_unreg (wd.parents[i].name)
        table.remove(wd.parents, i)
        if wd.f_store ~= nil then
          wd.f_store(wd)
        end
        return
      end
    end
  end
  
   -- External referenced --------------
  
  -- set selection icon for clone istance
  local function wd_manager_set_sel_icon (winname)
    local pwrMove = "$move" .. winname
    local iX, iY = sknColl.imgSize("icon", "move")
    sknImg.delete (pwrMove)   -- delete previous instance
    sknImg.create (pwrMove, winname, 0, 0, iX, iY)
    sknImg.longTouchCB(pwrMove, "wd_manager.moveClone")    -- moving support
    sknImg.image(pwrMove, "icon", "move")
    sknImg.auxData(pwrMove, lidx)
    sknImg.auxStr(pwrMove, winname)    
    sknImg.show(pwrMove)
  end
  
  -- show selection mode
  local function wd_manager_select_end (winname)
    local pwrMove = "$move" .. winname
    sknImg.delete (pwrMove) -- remove
  end

  -- live moving of Clone
  function wd_manager.moveLive (vals)
    if currWidgetSelected == nil or currParentSelected == nil then return end
    local  x, y = string.match(vals, "(.*),(.*)")
    local mm = currWidgetSelected.f_move
    if mm == nil then 
      print ("Unexpected move fmove == nil")
      return
    end
    x = x-liveMoveO_x
    y = y-liveMoveO_y
    currParentSelected.x = x
    currParentSelected.y = y
    mm (currParentSelected.name, x, y)
  end
      
  -- enable the clone move action
  function wd_manager.moveClone (oname)
    local name = sknIbtn.auxStr(oname)   -- get obj reference name
    
    if moveInProgress == false then
      -- move now
      -- find related widget
      currWidgetSelected, currParentSelected = wd_manager.wd_get (name)
      if currWidgetSelected == nil then 
        print ("Unexpected Sel obj:" ..name)
        return
      end

      sknSys.tpLivemove ("wd_manager.moveLive")
      
      -- set evidence
      local xx, yy = sknWin.pos(name)   -- get object origin
      liveMoveO_x, liveMoveO_y = sknDesk.currCoords()
      liveMoveO_x = liveMoveO_x - xx
      liveMoveO_y = liveMoveO_y - yy
 
      wd_manager_set_sel_icon (name) -- activate selection
      moveInProgress = true
    else
      -- end move
      moveInProgress = false
      currWidgetSelected, currParentSelected = wd_manager.wd_get (name)
      sknSys.tpLivemove ("")
      
      --[[
      if currWidgetSelected ~= nil and currParentSelected ~= nil then 
        currParentSelected.x, currParentSelected.y = sknWin.pos(currParentSelected.name)
        --currWidgetSelected, 
      end
      --]]
      
      wd_manager_select_end (name)-- clr evidence
      
      if currWidgetSelected ~= nil then
        if currWidgetSelected.f_store ~= nil then
          currWidgetSelected.f_store(currWidgetSelected)
        end
      end
    end
  end

  -- reload all dynamic widgets
  function wd_manager.reloadParents()
    for i=1, #wdList do
      if wdList[i].wdptr ~= nil then
        for p=1, #wdList[i].wdptr.parents do
          if wdList[i].wdptr.f_reg ~= nil then
            wdList[i].wdptr.f_reg (wdList[i].wdptr, wdList[i].wdptr.parents[p].name, wdList[i].wdptr.parents[p].parent, 
                  wdList[i].wdptr.parents[p].x, wdList[i].wdptr.parents[p].y)
            sknWin.longTouchCB(wdList[i].wdptr.parents[p].name, "wd_manager.moveClone")
          end
        end
      end
    end
  end
  
  -- Remove all widgets from selected parent
  function wd_manager.removeParents(parent)
    for i=1, #wdList do
      if wdList[i].wdptr ~= nil then
        for p=1, #wdList[i].wdptr.parents do
          if wdList[i].wdptr.parents[p].parent == parent then
            wdList[i].wdptr.f_unreg (wdList[i].wdptr.parents[p].name)
          end
        end
      end
    end
  end
    
