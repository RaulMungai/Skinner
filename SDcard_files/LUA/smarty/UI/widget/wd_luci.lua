-------------------------------------------------------------------
---------------------------  widget:luci  -------------------------
-------------------------------------------------------------------
--[[
  Luci Widget
  
  Elements:
    wd_luci.status (desc, on, busy)      -- set Luce status
    
  internals:
    
  date: 24/11/2018 
  by: Raul Mungai
--]]


-- Load artworks
----------------
css.load_btn_img ("\\buttons\\lightbulb.png",  "luci")   -- app icon button
css.load_img ("\\icons\\lightbulb.png", "luci-i", "icon") -- app icon (small)

-- widget
--css.load_img ("\\img\\interrOn.bmp", "intOn", "IMG")
css.load_img ("\\img\\interrOff.bmp", "intOff", "IMG")
css.load_img ("\\icons\\occupied.png", "occupied", "icon")
css.load_btn_img ("\\buttons\\BlampOn.png",  "interrOn")
css.load_btn_img ("\\buttons\\BlampOff.png",  "interrOff")
  
-- Global Object
wd_luci = {}

  local wLuciColl = {}      -- all Luci widgets
      
  local maxZone = 20    -- max number of zone
    
  local luceBox_font = "F16B"
  local luceBox_H = 80
  local luceBox_W = 120
  local fname = thema.getDir() .. "cfg\\wd_luci.cfg"
  local wradix = "luci"
  
  -- store configuration
  local function wd_luci_storeCfg() 
    --hourglass.show ()
    utils.table_save(wLuciColl, fname)
    --hourglass.hide ()
  end
 
  -- restore configuration
  local function wd_luci_restoreCfg()
    wLuciColl = utils.table_load(fname)
    if wLuciColl ~= nil then
      -- set pointers
      for i=1, #wLuciColl do
        wLuciColl[i].f_reg=wd_luci.reg
        wLuciColl[i].f_unreg=wd_luci.unreg
        wLuciColl[i].f_move=wd_luci.pos
        wLuciColl[i].f_store=wd_luci_storeCfg
        wd_manager.widget_add (wLuciColl[i])      -- add to widget list
      end
    else
      wLuciColl = {}
    end
  end  
  
  -- delete luce Box (return the list index deleted)
  local function wd_luci_del (name)
    sknLbl.delete(name)
    sknIbtn.delete("$pb" .. name)
    sknImg.delete("$o" .. name)
  end
  
  -- create luci widget
  local function wd_luci_widget_new (wd, name , winName, x, y)
    -- get description
    local desc= wd.desc
    if sknLbl.create(name, winName, x, y, luceBox_W, luceBox_H, "HorCenter_VertBot", desc) == 0 then
      return
    end
    sknLbl.font(name, luceBox_font)
    sknLbl.colors(name, "white", "blue")
    sknLbl.auxStr(name, name)
    sknLbl.longTouchCB(name, "wd_manager.moveClone")    -- moving support
    sknLbl.show(name)    
        
    -- Set push button + light
    local iX, iY = sknColl.imgSize("btn", "interrOff")
    css.button_new ("$pb" .. name, name, (luceBox_W//2) - (iX//2), 3, "interrOff", "wd_luci.onoff", true)
    sknIbtn.auxStr("$pb" .. name, name)    
    sknIbtn.longTouchCB("$pb" .. name, "wd_manager.moveClone")    -- moving support
    
    -- occupied icon
    local occI = "$o" .. name
    iX, iY = sknColl.imgSize("icon", "occupied")
    if sknImg.create (occI, name, 3, 3, iX, iY) == 0 then
      return
    end
    sknImg.longTouchCB(occI, "wd_manager.moveClone")    -- moving support
    sknImg.image(occI, "icon", "occupied")
    sknImg.auxStr(occI, name)    
    --sknImg.show(occI)    
  end
  
  -- widget reg to new parent
  function wd_luci.reg (wd, name, parent, x, y)
    wd_luci_widget_new (wd, name, parent, x, y)
    wd_luci_storeCfg()
  end
  
  -- unreg parent instance
  function wd_luci.unreg (name)
    wd_luci_del (name)
  end
  
  -- widget move
  function wd_luci.pos (name, x,y)
    sknWin.pos (name, x,y)
  end    
  
  -- module startUp
  local function wd_luci_startUp ()
    wd_luci_restoreCfg()
    -- synth creation of already active devices
    wd_luci.demodata ()   -- demo data
  end

  -- add new instance
  function wd_luci.add (UID, desc)
    -- check for already present
    local idx
    local alreadyP = false
    for ii=1, #wLuciColl do
      if wLuciColl[ii].UID == UID and wLuciColl[ii].desc == desc then
        alreadyP = true
        idx = ii
        break
      end
    end
    
    if alreadyP == false then
      table.insert (wLuciColl,  {radix=wradix, UID=UID, tipo="D", icon=wradix .. "-i", zone="", desc=desc, help=sknColl.dictGetPhrase("HELP", 30), size_H=luceBox_H, size_W=luceBox_W, f_reg=wd_luci.reg, f_unreg=wd_luci.unreg, f_move=wd_luci.pos, f_store=wd_luci_storeCfg, on=false, busy=false, parents={}})
      idx = #wLuciColl
    end
    wd_manager.widget_add (wLuciColl[idx])      -- add to widget list
  end
  
  -- remove instance
  function wd_luci.remove (UID, desc)
    for ii=1, #wLuciColl do
      if wLuciColl[ii].UID == UID and wLuciColl[ii].desc == desc then
        table.remove (wLuciColl,  ii)
        return
      end
    end
  end
  
  -- return the widget index from obj name or -1 
  local function wd_luci_getIndex_name (oname)
    for i=1, #wLuciColl do
      for p=1, #wLuciColl[i].parents do
        if wLuciColl[i].parents[p].name == oname then
            return i
        end
      end
    end
    return -1
  end
  
  -- return the widget index from widget desc or -1 
  local function wd_luci_getIndex_desc (desc)
    for i=1, #wLuciColl do
      if wLuciColl[i].desc == desc then
        return i
      end
    end
    return -1
  end
  
  -- update all widget parents states
  local function wd_luci_updParents(idx)
    if idx == -1 then return end
    local icon = "interrOff"
    if wLuciColl[idx].on == true then
      icon = "interrOn" 
    end

    -- all widget parents
    for p=1, #wLuciColl[idx].parents do
      local name = wLuciColl[idx].parents[p].name
      css.button_icon_set ("$pb" .. name, icon)
      
      if wLuciColl[idx].busy == true then
        sknImg.show("$o" .. name)    
      else
        sknImg.hide("$o" .. name)    
      end
    end
  end
  
  -- set Luce status
  function wd_luci.status (desc, on, busy)
    local idx = wd_luci_getIndex_desc (desc)
    if idx == -1 then return end
    
    -- change status
    wLuciColl[idx].on = on
    wLuciColl[idx].busy = busy
    wd_luci_updParents(idx)
  end
  
  -- On-Off event
  function wd_luci.onoff (oname)
    local name = sknIbtn.auxStr(oname)
    local idx = wd_luci_getIndex_name (name)
    if idx == -1 then return end
    -- change status
    wLuciColl[idx].on = not wLuciColl[idx].on
    wd_luci_updParents(idx)
  end

  ------- DEMO DATA ------
  function wd_luci.demodata ()
    wd_luci.add (1234, "sala")
    wd_luci.add (2345, "cucina")
    wd_luci.add (3456, "camerona")
  end
    
  
wd_luci_startUp ()   -- Window creation
