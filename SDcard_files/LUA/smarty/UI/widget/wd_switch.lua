-------------------------------------------------------------------
---------------------------  widget:Switch  -----------------------
-------------------------------------------------------------------
--[[
  Switch Widget
  
  Elements:
    wd_switch.status (desc, on, busy)      -- set Luce status
    
  internals:
    
  date: 24/11/2018 
  by: Raul Mungai
--]]

--pbtn_on.png

-- Load artworks
----------------
css.load_btn_img ("\\buttons\\pbtn_off.png",  "switch")   -- app icon button
css.load_img ("\\icons\\switch-i.png", "switch-i", "icon") -- app icon (small)
css.load_btn_img ("\\buttons\\pbtn_on.png",  "switchOn")   -- app icon button
-- widget
--css.load_img ("\\img\\interrOn.bmp", "intOn", "IMG")
css.load_img ("\\img\\switch.bmp", "bgswitch", "IMG")
--css.load_btn_img ("\\buttons\\BlampOn.png",  "interrOn")
--css.load_btn_img ("\\buttons\\BlampOff.png",  "interrOff")
  
-- Global Object
wd_switch = {}

  local wSwitchColl = {}      -- all switch widgets
  local deviceSupported = {"Small Switch"}
      
  local maxZone = 20    -- max number of zone
    
  local switchBox_font = "F16B"
  local switchBox_H = 80
  local switchBox_W = 120
  local fname = thema.getDir() .. "cfg\\wd_switch.cfg"
  local wradix = "switch"
  
  -- store configuration
  local function wd_switch_storeCfg() 
    --hourglass.show ()
    utils.table_save(wSwitchColl, fname)
    --hourglass.hide ()
  end
 
  -- restore configuration
  local function wd_switch_restoreCfg()
    wSwitchColl = utils.table_load(fname)
    if wSwitchColl ~= nil then
      -- set pointers
      for i=1, #wSwitchColl do
        wSwitchColl[i].f_reg=wd_switch.reg
        wSwitchColl[i].f_unreg=wd_switch.unreg
        wSwitchColl[i].f_move=wd_switch.pos
        wSwitchColl[i].f_store=wd_switch_storeCfg
        wd_manager.widget_add (wSwitchColl[i])      -- add to widget list
      end
    else
      wSwitchColl = {}
    end
  end  
  
  -- delete luce Box (return the list index deleted)
  local function wd_switch_del (name)
    
    sknIbtn.delete("$pb" .. name)
    sknLbl.delete("$D" .. name)
    sknImg.delete(name)
  end
  
  -- create switch widget
  local function wd_switch_widget_new (wd, name , winName, x, y)
    -- get description
    local desc= wd.desc
    -- background image (container)
    sknImg.create (name, winName, x, y, 0, 0)
    sknImg.longTouchCB(name, "wd_manager.moveClone")    -- moving support
    sknImg.image(name, "IMG", "bgswitch")
    sknImg.auxStr(name, name)    
    sknImg.show(name)
        
    -- Set push button
    
    wdname = "$pb" .. name
    css.button_new (wdname, name, 21, 5, "switch", "wd_switch.onoff", true)
    sknIbtn.auxStr(wdname, name)    
    sknIbtn.longTouchCB(wdname, "wd_manager.moveClone")    -- moving support
    
    -- desc
    local wdname = "$D" .. name
    sknLbl.create(wdname, name, 0, 50, 75, 20, "HorCenter_VertCenter", wd.desc)
    sknLbl.font(wdname, "F13B")
    sknLbl.colors(wdname, "white", "transparent")
    sknLbl.auxStr(wdname, name)
    sknLbl.longTouchCB(wdname, "wd_manager.moveClone")    -- moving support
    sknLbl.keyReleaseCB(wdname, "win_devinfo.dispinfo")   -- dev infos
    sknLbl.show(wdname)    
  end
  
  -- widget reg to new parent
  function wd_switch.reg (wd, name, parent, x, y)
    wd_switch_widget_new (wd, name, parent, x, y)
    wd_switch_storeCfg()
  end
  
  -- unreg parent instance
  function wd_switch.unreg (name)
    wd_switch_del (name)
  end
  
  -- widget move
  function wd_switch.pos (name, x,y)
    sknWin.pos (name, x,y)
  end    
  
  -- module startUp
  local function wd_switch_startUp ()
    wd_switch_restoreCfg()
    
    cccwrp.widget_register("switch", deviceSupported, wd_switch.add, wd_switch.remove, wd_vocco2e.setval)  -- register CCC widget
    -- synth creation of already active devices
    wd_switch.demodata ()   -- demo data
  end

  -- add new instance
  function wd_switch.add (UID, desc)
    -- check for already present
    local idx
    local alreadyP = false
    for ii=1, #wSwitchColl do
      if wSwitchColl[ii].UID == UID and wSwitchColl[ii].desc == desc then
        alreadyP = true
        idx = ii
        break
      end
    end
    
    if alreadyP == false then
      table.insert (wSwitchColl,  {radix=wradix, UID=UID, tipo="D", icon=wradix .. "-i", zone="", desc=desc, help=sknColl.dictGetPhrase("HELP", 30), size_H=switchBox_H, size_W=switchBox_W, f_reg=wd_switch.reg, f_unreg=wd_switch.unreg, f_move=wd_switch.pos, f_store=wd_switch_storeCfg, on=false, parents={}})
      idx = #wSwitchColl
    end
    wd_manager.widget_add (wSwitchColl[idx])      -- add to widget list
  end
  
  -- remove instance
  function wd_switch.remove (UID, desc)
    for ii=1, #wSwitchColl do
      if wSwitchColl[ii].UID == UID and wSwitchColl[ii].desc == desc then
        table.remove (wSwitchColl,  ii)
        return
      end
    end
  end
  
  -- remove instance
  function wd_switch.remove (UID, desc)
    for ii=1, #wSwitchColl do
      if wSwitchColl[ii].UID == UID and wSwitchColl[ii].desc == desc then        
        -- all widget parents
        for p=1, #wSwitchColl[ii].parents do
          local name = wSwitchColl[ii].parents[p].name
          wd_vocco2e_del(name)
        end
      
        table.remove (wSwitchColl, ii)
        return
      end
    end
  end
  
  -- return the widget index from obj name or -1 
  local function wd_switch_getIndex_name (oname)
    for i=1, #wSwitchColl do
      for p=1, #wSwitchColl[i].parents do
        if wSwitchColl[i].parents[p].name == oname then
            return i
        end
      end
    end
    return -1
  end
  
  -- return the widget index from widget desc or -1 
  local function wd_switch_getIndex_desc (desc)
    for i=1, #wSwitchColl do
      if wSwitchColl[i].desc == desc then
        return i
      end
    end
    return -1
  end
  
  -- update all widget parents states
  local function wd_switch_updParents(idx)
    if idx == -1 then return end
    local icon = "switch"
    if wSwitchColl[idx].on == true then
      icon = "switchOn" 
    end

    -- all widget parents
    for p=1, #wSwitchColl[idx].parents do
      local name = wSwitchColl[idx].parents[p].name
      css.button_icon_set ("$pb" .. name, icon)
    end
  end
  
  -- set Luce status
  function wd_switch.status (desc, on)
    local idx = wd_switch_getIndex_desc (desc)
    if idx == -1 then return end
    
    -- change status
    wSwitchColl[idx].on = on
    wd_switch_updParents(idx)
  end
  
  -- On-Off event
  function wd_switch.onoff (oname)
    local name = sknIbtn.auxStr(oname)
    local idx = wd_switch_getIndex_name (name)
    if idx == -1 then return end
    -- change status
    wSwitchColl[idx].on = not wSwitchColl[idx].on
    
    -- apply changes to Remote
    local sws = 0
    if wSwitchColl[idx].on == true then
      sws = 1
    end
    
    cccwrp.set_switch (wSwitchColl[idx].UID, sws)
    wd_switch_updParents(idx)
  end

  ------- DEMO DATA ------
  function wd_switch.demodata ()
    --wd_switch.add (1234, "faretto")
  end
    
  
wd_switch_startUp ()   -- Window creation
