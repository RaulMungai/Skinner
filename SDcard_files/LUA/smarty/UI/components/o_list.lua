-------------------------------------------------------------------
---------------------------  list  --------------------------------
-------------------------------------------------------------------
--[[
  Show and list:
    o_list.init()                                                        --init list (before use)
    o_list.extern_cb(cb_Del, cb_add, cb_edit)                    --list external callback
    o_list.options(selType, noDuplicate, readOnly[,collName[, help] ])   --list option set  
                                                                (selType = "txt", "icon", "img", "color", "win", "wdlist", "wdadd")
    o_list.show(title, ev_ok, ev_canc[ [, icoSize],listLoadAuto] ])      -- show and manage the list 
                                                                            (set icoSize for fixed size management or -1 for all)
    o_list.addItem(Licon, Ldesc, Lradix, LUID, wptr, valGen)             -- add item to list 
    o_list.hide()                                                        -- list hide 
  
  Buttons:
    o_list.btn_add(icon, help)      --list button management: add
    o_list.btn_edit(icon[, help])   -- list button management: edit (icon == nil no icon change)
    o_list.btn_del(icon[, help])    -- list button management: delete (icon == nil no icon change)
    o_list.btn_ok(icon[, help])     -- list button management: ok (icon == nil no icon change)
    o_list.btn_back(icon[, help])   -- list button management: back (icon == nil no icon change)
  
  General:
    
    o_list.help(help)                                        --list help set
    o_list.list_get()        -- get complete list
    
  Selection:
    o_list.selectedItem()    -- get seleted item
    
  Internal use:
    o_list.add()             -- elment add
    o_list_editEnd ()        -- End edit operations
    o_list.edit (name)       -- list edit   
    o_list.delete (name)     -- delete line
    o_list.ok (name)         -- list confirmation
    o_list.canc (name)       -- list cancel
    
    o_list.color_help (name) -- display color help text
    o_list.win_help (name)   -- display win help text
    o_list.icon_help (name)  -- display icon help text
    
  date: 28/12/2018 
  by: Raul Mungai
--]]


-- Load artworks
----------------
-- css.load_btn_img ("\\buttons\\list.png",    "list")   -- app icon

-- buttons
css.load_btn_img ("\\buttons\\back.png",    "back") 
css.load_btn_img ("\\buttons\\accept.png",  "ok")
css.load_btn_img ("\\buttons\\plugin_add.png",  "wdadd") 
css.load_btn_img ("\\buttons\\t_edit.png",  "wdedit") 
css.load_btn_img ("\\buttons\\t_delete.png","tdelete")


-- Global Object
o_list = {}

  local wdGenList = {}  -- widget General related list
  
  -- widget win related list
  local elmentHico = 20
  local elmentWico = 20
  local elmentH = 20
  local elmentW = 200
  local lst_fixImgSize = 32   -- fixed image size
  local zoneLbl_space = 1    -- items spacyng
  local elementStartY = 40
  local elementStartX = 10
  
  --local list_addOnly = false        -- add only
  local _scrollIndex = 1
  local lst_selItem = -1           -- selected item
  
  -- buttons name
  local lst_btn_add = "lstbtn-add"
  local lst_btn_edit = "lstbtn-edit"
  local lst_btn_del = "lstbtn-del"
  local lst_btn_ok = "lstbtn-ok"
  local lst_btn_back = "lstbtn-back"  
  local lst_bg_iconColor = "lstbtn-bgic"
  local lst_bg_iconColorSel = "lstbtn-bgicS"
  local lst_bg_iconImgSel = "lstbtn-bgiiS"
  
  
  local lst_ev_ok = nil
  local lst_ev_canc = nil
  
  local winname = "win&list"
  local winnameI = ""
  local iconBaseName = "islst"
  local maxiconslst = 0  
  local maxiconslstCreate = 0
  
  local list_noDuplicate = false
  local list_selType = "txt"   -- "txt", "icon", "img", "color"
  local list_readOnly = false;
  local lst_collName = ""
  
  -- external cb
  local list_extcb_Del = nil
  local list_extcb_add = nil
  local list_extcb_edit = nil
  
  -- edit
  listLst_curE = ""
  local listLst_isChanged = false
  
  
  --init list 
  function o_list.init()
    for i=1, #wdGenList do
      table.remove (wdGenList)
    end
    lst_selItem = -1
    _scrollIndex = 1
    listLst_isChanged = false
    
    css.button_hide (lst_btn_ok)
    css.button_hide(lst_btn_edit)
    sknWin.longTouchCB(winnameI, "")
    
    -- defauly icons
    css.button_icon_set (lst_btn_del, "tdelete")
    css.button_icon_set (lst_btn_add, "wdadd")
    css.button_icon_set (lst_btn_edit, "wdedit")

    list_extcb_Del = nil
    list_extcb_add = nil
    list_extcb_edit = nil    
  end
  
    -- List redraw
  local function o_list_redraw ()
    local si = _scrollIndex
    --if si < 1 or si > #wdGenList then return end
    --if si == -1 then
    --  si = 0           -- redraw empty list
    --end
    
    -- fill icon preview images
    local y = elementStartY
    local xx = elementStartX
    local iconActive = false
    if si > 0 then
      for i=si, #wdGenList do
        if wdGenList[i].icon ~= "" then
          iconActive = true
          break
        end
      end
    end
    
    if iconActive == true then
      xx = elementStartX + elmentWico + 2
    else
      xx = elementStartX
    end
    
    local ii = 1
    if si > 0 then
      for i=si, #wdGenList do
        local iname = iconBaseName .. tostring(ii)
        if wdGenList[i].icon ~= "" then
          sknImg.image(iname, lst_collName, wdGenList[i].icon)
          sknImg.size(iname, elmentWico, elmentHico)
          sknImg.pos(iname, elementStartX, y)
          sknImg.auxData(iname, i)
          sknImg.keyReleaseCB(iname, "o_list.itemSel")
          sknImg.show (iname) 
          xx = elementStartX + elmentWico + 2
        else
          sknImg.hide (iname)
        end
        
        if list_selType== "txt" or list_selType== "win" or list_selType == "wdlist" or list_selType == "wdadd" then
          local ttlname = iconBaseName .. "$t" .. tostring(ii)
          sknLbl.text(ttlname, wdGenList[i].desc)
          
          sknLbl.size(ttlname, elmentW, elmentH)
          sknLbl.pos(ttlname, xx, y)
          
          local cfore = thema.list_txtcolor
          local cbg = thema.list_txtbgcolor
          if lst_selItem == i then
            cfore = thema.list_txtcolorSel
            cbg = thema.list_txtbgcolorSel
          end
          sknLbl.colors(ttlname, cfore, cbg)
          sknLbl.auxData(ttlname, i)
          sknLbl.show (ttlname)    
          
        elseif list_selType== "color" then
          local ttlname = iconBaseName .. "$t" .. tostring(ii)
          sknLbl.text(ttlname, "")
          sknLbl.colors(ttlname, thema.list_txtcolor, wdGenList[i].val)
          
          sknLbl.size(ttlname, elmentW, elmentH)
          sknLbl.pos(ttlname, xx, y)
          
          sknLbl.auxData(ttlname, i)
          sknLbl.show (ttlname)   
        elseif list_selType== "icon" then
          local ttlname = iconBaseName .. "$t" .. tostring(ii)
          sknLbl.hide (ttlname)
        end      

        ii = ii +1
        if iconActive == true then
          if elmentHico < elmentH then
            y = y + elmentH
          else
            y = y + elmentHico
          end
        else
          y = y + elmentH
        end
        
        y = y + zoneLbl_space
        
      end
    end
    
    if si < 1 then
      ii = 1
    end
    
    if ii <= maxiconslstCreate then
      for i=ii, maxiconslstCreate do
        if list_selType== "txt" or list_selType == "color" or list_selType == "icon" or list_selType == "win" or list_selType == "wdlist" or list_selType == "wdadd" then
          local iname = iconBaseName .. tostring(i)
          sknImg.auxData(iname, 0)
          sknImg.keyReleaseCB(iname, "")           
          sknImg.hide (iname)   
          local ttlname = iconBaseName .. "$t" .. tostring(i)
          sknLbl.hide (ttlname)  
        end
      end
    end
    
    if list_selType== "color" and lst_selItem > 0 then
      sknLbl.colors(lst_bg_iconColorSel, thema.win_color, wdGenList[lst_selItem].val)  
      
    elseif list_selType== "icon" and lst_selItem > 0 then
      sknImg.image(lst_bg_iconImgSel, lst_collName, wdGenList[lst_selItem].icon)
      local xx, yy = sknImg.size(lst_bg_iconImgSel)
      if xx > 60 then 
        xx = 60
        yy = 60
        sknImg.size(lst_bg_iconImgSel, xx, yy)
      end
    end
  end
  
  --add item to list 
  function o_list.addItem(Licon, Ldesc, Lradix, LUID, wptr, valGen)
    table.insert(wdGenList, {icon=Licon, desc=Ldesc, radix=Lradix, UID=LUID, wdptr=wptr, val=valGen})
    --o_list_redraw()
  end
  
  -- elment add
  function o_list.add()
    if list_extcb_add ~= nil then
      list_extcb_add()
      return
    end   
    
    listLst_curE = ""
    lst_selItem = -1
    win_kbrd.set ("alpha_ita", "listLst_curE", 20, winname, "o_list_editEnd")   -- use specific keyboard    
  end
  
  -- End edit operations
  function o_list_editEnd ()
    if listLst_curE == "" then
      return
    end
    
    if list_noDuplicate == true then
      --check for duplication
      for i=1, #wdGenList do
        if i ~= lst_selItem then
          if wdGenList[i].desc == listLst_curE then    
            -- duplication found
            win_popup.text (sknColl.dictGetPhrase("WIN", 16), sknColl.dictGetPhrase("WIN", 17))
            o_list_redraw ()
            return
          end
        end
      end
    end
    
    if lst_selItem < 1 then 
      o_list.addItem("", listLst_curE, "", 0, nil, 0)   -- new
      lst_selItem = #wdGenList
    else
      wdGenList[lst_selItem].desc = listLst_curE        -- change
    end
    
    listLst_isChanged = true
    sknIbtn.show (lst_btn_ok)
    o_list_redraw ()
  end
  
  -- list edit
  function o_list.edit (name)
    if lst_selItem < 1 or lst_selItem > #wdGenList then return end
    
    if list_extcb_edit ~= nil then
      list_extcb_edit()
      return
    end   
    
    -- Edit now
    listLst_curE = wdGenList[lst_selItem].desc
    win_kbrd.set ("alpha_ita", "listLst_curE", 20, winname, "o_list_editEnd", "")   -- use specific keyboard
  end
  
  -- delete line
  function o_list.delete (name)
    -- find selected line    
    css.button_hide (lst_btn_del)
    if lst_selItem < 1 or lst_selItem > #wdGenList then return end
        
    if list_extcb_Del ~= nil then
      list_extcb_Del()
      return
    end
    
    print ("o_list.delete (UNEXPECTED)")
    table.remove (wdGenList, lst_selItem)
    listLst_isChanged = true
    css.button_show (lst_btn_ok)
    o_list_redraw ()
  end
  
  -- list confirmation
  function o_list.ok (name)
    o_list.hide()
    if lst_ev_ok ~= nil then
      lst_ev_ok()
    end
  end
  
  
  -- list cancel
  function o_list.canc (name)
    o_list.hide()
    if lst_ev_canc ~= nil then
      lst_ev_canc()
    end    
  end
  
  -- List creation
  local function o_list_create()
    winnameI = css.window_new (winname, false, "win_selicon.help")
    
    -- add title and related buttons
    css.window_title_new (winnameI, "-")

    css.button_new (lst_btn_add, winnameI, 370, 40, "wdadd", "o_list.add", true, false, "Add", "black")
    css.button_new (lst_btn_edit, winnameI, 370, 100, "wdedit", "o_list.edit", false, false, "Edit", "black")
    css.button_new (lst_btn_del, winnameI, 370, 160, "tdelete", "o_list.delete", false, false, "Delete", "black")
    css.button_new (lst_btn_ok, winnameI, 320, 220, "ok", "o_list.ok", false, false, "OK", "black")
    css.button_new (lst_btn_back, winnameI, 370, 220, "back", "o_list.canc", true)

    -- Icon list
    local y = elementStartY
    maxiconslst = (sknSys.screenYsize() - elementStartY) // elmentH
    maxiconslstCreate = maxiconslst
    for i=1, maxiconslst do
      -- icons
      local iname = iconBaseName .. tostring(i)
      sknImg.create (iname, winnameI, elementStartX, y, elmentWico, elmentHico) 
      sknImg.image(iname, lst_collName, "")
      sknImg.auxData(iname, 0)
      sknImg.keyReleaseCB(iname, "o_list.itemSel")
      
      -- Text
      local cfore = thema.list_txtcolor
      local cbg = thema.list_txtbgcolor
      if lst_selItem == i then
        cfore = thema.list_txtcolorSel
        cbg = thema.list_txtbgcolorSel
      end
      
      local ttlname = iconBaseName .. "$t" .. tostring(i)
      sknLbl.create(ttlname, winnameI, elementStartX + elmentWico + 3, y, elmentW, elmentH, "HorLeft_VertCenter", "")
      sknLbl.font(ttlname, thema.list_font)
      sknLbl.colors(ttlname, thema.list_txtcolor, thema.list_txtbgcolor)
      sknLbl.auxData (ttlname, 0)  
      sknLbl.keyReleaseCB(ttlname, "o_list.itemSel")
      
      if elmentHico < elmentH then
        y = y + elmentH
      else
        y = y + elmentHico
      end
      
      y = y + zoneLbl_space
    end
    
    -- Color and Icon
    sknLbl.create(lst_bg_iconColor, winnameI, 370, 50, elmentW+6, elmentH+6, "HorLeft_VertCenter", "")
    sknLbl.colors(lst_bg_iconColor, thema.win_color, thema.win_color)
    
    -- Color
    sknLbl.create(lst_bg_iconColorSel, lst_bg_iconColor, 3, 3, elmentW, elmentH, "HorLeft_VertCenter", "")
    sknLbl.colors(lst_bg_iconColorSel, thema.win_bg_color, thema.win_bg_color)    
    
    -- Icon / image
    sknImg.create (lst_bg_iconImgSel, lst_bg_iconColor, 3, 3, elmentW, elmentW) 
    sknImg.image(lst_bg_iconImgSel, lst_collName, "")
    
    o_list.init()
  end
  
  --list button management: add
  function o_list.btn_add(icon, help)
    if icon ~= nil then
      css.button_icon_set (lst_btn_add, icon)
    end
    if help ~= nil then
      css.button_help_set (lst_btn_add, help)
    end    
  end
  
  --list button management: edit
  function o_list.btn_edit(icon, help)
    if icon ~= nil then
      css.button_icon_set (lst_btn_edit, icon)
    end
    if help ~= nil then
      css.button_help_set (lst_btn_edit, help)
    end    
  end
  
  --list button management: del
  function o_list.btn_del(icon, help)
    if icon ~= nil then
      css.button_icon_set (lst_btn_del, icon)
    end
    if help ~= nil then
      css.button_help_set (lst_btn_del, help)
    end    
  end
    
  --list button management: ok
  function o_list.btn_ok(icon, help)
    if icon ~= nil then
      css.button_icon_set (lst_btn_ok, icon)
    end
    if help ~= nil then
      css.button_help_set (lst_btn_ok, help)
    end
  end
  
  --list button management: back
  function o_list.btn_back(icon, help)
    if icon ~= nil then
      css.button_icon_set (lst_btn_back, icon)
    end
    if help ~= nil then
      css.button_help_set (lst_btn_back, help)
    end    
  end

  --list help set
  function o_list.help(help)
    
  end
  
  --list external callback
  function o_list.extern_cb(cb_Del, cb_add, cb_edit)
    list_extcb_Del = cb_Del
    list_extcb_add = cb_add
    list_extcb_edit = cb_edit    
  end
    
  --list option set
  function o_list.options(selType, noDuplicate , readOnly, collName, help)
    if noDuplicate == nil then
      noDuplicate = false
    end
    
    list_noDuplicate = noDuplicate
    list_selType = selType
    list_readOnly = readOnly
    if help ~= nil then
      sknWin.longTouchCB(winnameI, help)
    end
    
    if collName == nil then
      if selType == "win" then
        lst_collName = "btn"
      else
        lst_collName = "icon"
      end
    else
      lst_collName = collName
    end
  end
  
  -- preload standard items for icon
  local function win_selicon_updIconLst()    
    local maxi = sknColl.maxImages (lst_collName)
    local ix = 0
    local filterNow = false
    for i=0, maxi do
      local inn = sknColl.imagename (lst_collName, i)
      if inn ~= "" then
        filterNow = false
        if lst_fixImgSize ~= -1 then
          local iX, iY = sknColl.imgSize(lst_collName, inn)
          if iX ~= lst_fixImgSize then
            filterNow = true
          end
        end
        
        if filterNow == false then
          o_list.addItem(inn, "", "", 0, nil, 0)
        end
      end 
    end
  end
  
  -- preload standard items for colors
  local function win_selicon_updColorLst() 
    o_list.addItem("", "", "", 0, nil, "blue")
    o_list.addItem("", "", "", 0, nil, "green")
    o_list.addItem("", "", "", 0, nil, "red")
    o_list.addItem("", "", "", 0, nil, "cyan")
    o_list.addItem("", "", "", 0, nil, "magenta")
    o_list.addItem("", "", "", 0, nil, "yellow")
    o_list.addItem("", "", "", 0, nil, "white")
    o_list.addItem("", "", "", 0, nil, "gray")
    o_list.addItem("", "", "", 0, nil, "black")
    o_list.addItem("", "", "", 0, nil, "brown")    
    o_list.addItem("", "", "", 0, nil, "lightblue")
    o_list.addItem("", "", "", 0, nil, "lightred")
    o_list.addItem("", "", "", 0, nil, "lightcyan")
    o_list.addItem("", "", "", 0, nil, "lightmagenta")
    o_list.addItem("", "", "", 0, nil, "lightyellow")
    o_list.addItem("", "", "", 0, nil, "lightgray")
    o_list.addItem("", "", "", 0, nil, "darkblue")
    o_list.addItem("", "", "", 0, nil, "darkgreen")
    o_list.addItem("", "", "", 0, nil, "darkcyan")
    o_list.addItem("", "", "", 0, nil, "darkmagenta")
    o_list.addItem("", "", "", 0, nil, "darkyellow")
    o_list.addItem("", "", "", 0, nil, "darkgray")
    o_list.addItem("", "", "", 0, nil, "transparent")
  end
  
  -- preload standard items for colors
  local function win_selicon_updWinLst() 
    local desc = "-"
    local idx = 1
    while desc ~= "" do
       desc = win_wintool.win_workingDesc_idx (idx)
       local icon = win_wintool.win_workingIcon_idx (idx)
       if desc ~= "" then
         o_list.addItem(icon, desc, "", 0, nil, 0)
       end
       idx = idx +1
    end
  end
    
  -- display color help text
  function o_list.color_help (name)
    win_helper.help (23, name)
  end
  
  -- display win help text
  function o_list.win_help (name)
    win_helper.help (16, name)
  end 
  
  -- display icon help text
  function o_list.icon_help (name)
    win_helper.help (24, name)
  end
  
  -- Load default values for icon,colors and windows
  function o_list_loadDefault()
    if list_selType == "color" then
      win_selicon_updColorLst()
    elseif list_selType == "icon" then
      win_selicon_updIconLst()
    elseif list_selType == "win" then
      win_selicon_updWinLst()
    end
  end
  
  --show and manage the list
  function o_list.show(title, ev_ok, ev_canc, icoSize, listLoadAuto)
    css.window_title (winnameI, title)
    lst_ev_ok = ev_ok
    lst_ev_canc = ev_canc
    
    if listLoadAuto == nil then
      listLoadAuto = false
    end
    
    if icoSize == nil or icoSize == -1 then
      icoSize = thema.ico_size
      lst_fixImgSize = -1
    else
      lst_fixImgSize = icoSize
    end

    if icoSize > 80 then
      icoSize = 80
    end
    
    -- config events
    sknSys.tpFinemove("o_list.shiftup", "o_list.shiftdown", "", "")
    listLst_isChanged = false
    
    if list_readOnly == true and list_selType== "txt" then
      css.button_hide (lst_btn_add)
      css.button_hide (lst_btn_edit)
      css.button_hide (lst_btn_del)     
      elmentHico = 20
      elmentWico = 20
      elmentH = 20
    end
    
    if list_readOnly == false then
      css.button_show (lst_btn_add)
    end
    
    if list_selType == "wdlist" then
      css.button_hide (lst_btn_edit)
      
      elmentHico = icoSize
      elmentWico = icoSize 
      elmentH = icoSize
      
      sknLbl.hide(lst_bg_iconColor)   -- hide color-icon selection

    elseif list_selType == "wdadd" then
      css.button_hide (lst_btn_add)
      css.button_hide (lst_btn_edit)
      css.button_hide (lst_btn_del)     
    
      elmentHico = icoSize
      elmentWico = icoSize 
      elmentH = icoSize
      
      sknLbl.hide(lst_bg_iconColor)   -- hide color-icon selection

    elseif list_selType == "color" then
      css.button_hide (lst_btn_add)
      css.button_hide (lst_btn_edit)
      css.button_hide (lst_btn_del)  
      
      list_readOnly = true
      elmentHico = icoSize
      elmentWico = icoSize 
      elmentH = icoSize

      sknLbl.size(lst_bg_iconColor, elmentHico+6, elmentWico + 6)
      sknLbl.show(lst_bg_iconColor)
      sknLbl.size(lst_bg_iconColorSel, elmentHico, elmentWico)
      sknLbl.show(lst_bg_iconColorSel)
      sknImg.hide(lst_bg_iconImgSel)
      
      sknWin.longTouchCB(winnameI, "o_list.color_help")   -- set help

    elseif list_selType == "icon" then
      css.button_hide (lst_btn_add)
      css.button_hide (lst_btn_edit)
      css.button_hide (lst_btn_del)  
      
      list_readOnly = true
      elmentHico = icoSize
      elmentWico = icoSize 
      elmentH = icoSize
      
      sknLbl.size(lst_bg_iconColor, elmentHico+6, elmentWico + 6)
      sknLbl.show(lst_bg_iconColor)
      sknLbl.hide(lst_bg_iconColorSel)
      sknImg.size(lst_bg_iconImgSel, elmentHico, elmentWico)
      sknImg.show(lst_bg_iconImgSel)

      sknWin.longTouchCB(winnameI, "o_list.icon_help")   -- set help
      
    elseif list_selType == "win" then
      if list_readOnly == false then
        css.button_show (lst_btn_add)
      else
        css.button_hide (lst_btn_add)
      end      
      css.button_hide (lst_btn_edit)
      css.button_hide (lst_btn_del)  
      
      elmentHico = icoSize
      elmentWico = icoSize 
      elmentH = icoSize
      sknLbl.hide(lst_bg_iconColor)   -- hide color-icon selection
      
      sknWin.longTouchCB(winnameI, "o_list.win_help")   -- set help

    end
    maxiconslst = (sknSys.screenYsize() - elementStartY) // elmentH
    
    if listLoadAuto == true then
      o_list_loadDefault()
    end
    
    
    sknWin.show(winname)
    o_list_redraw()
  end
  
  -- list hide 
  function o_list.hide()
    sknSys.tpFinemove("", "", "", "")
    sknWin.hide(winname)
  end
  
  -- execute the scroll action (up-down)
  local function o_list_listScoll (upDir)
    --local x,y = sknDesk.currCoords()
    --if  win_selicon_is_listArea(x,y) == false then return end
    
    local si = _scrollIndex
    if upDir == true then
      if (#wdGenList - si) < maxiconslst then return end
      si = si +1
      if si >= #wdGenList then
        return
      end
    else
      si = si - 1
      if si < 1 then si = 1 end
    end
    _scrollIndex = si
    o_list_redraw()
  end
  
    -- shift list Up
  function o_list.shiftup (val)
    o_list_listScoll (true)
  end
  
    -- shift list Down
  function o_list.shiftdown (val)
    o_list_listScoll (false)
  end
  
  -- item selection event (keyUp)
  function o_list.itemSel (name)
    local ii = sknImg.auxData(name)
    
    if ii == nil then return end
    if ii < 1 or ii > #wdGenList then return end
    lst_selItem = ii
    css.button_show(lst_btn_ok)
    
    if list_readOnly == false then
      if list_selType ~= "wdlist" and list_selType ~= "wdadd" then
        css.button_show(lst_btn_edit)
      end
      if list_selType ~= "wdadd" then
        css.button_show(lst_btn_del)
      end
    end
    o_list_redraw ()    
  end
  
  -- get seleted item
  function o_list.selectedItem() 
    if lst_selItem < 1 or lst_selItem > #wdGenList then return nil end
    return wdGenList[lst_selItem]
  end
  
  -- get complete list
  function o_list.list_get() 
    return wdGenList
  end
  
  
  
  o_list_create()
  
