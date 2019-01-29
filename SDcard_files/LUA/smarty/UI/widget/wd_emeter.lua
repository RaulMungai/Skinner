-------------------------------------------------------------------
---------------------------  widget:Electric Meter  ---------------
-------------------------------------------------------------------
--[[
  Electric Meter Widget
    
  Elements:
    wd_emeter.setval (zona, on, busy)      -- set Emeter status
    
  internals:
    
  date: 28/11/2018 
  by: Raul Mungai
--]]


-- Load artworks
----------------
css.load_btn_img ("\\buttons\\emeter.png",  "emeter")   -- app icon button
css.load_img ("\\icons\\emeter-i.png", "emeter-i", "icon") -- app icon (small)

-- meter widget
css.load_img ("\\img\\elmeter.png", "elmeterb", "IMG") -- back image
css.font_mount (thema.workDisk .. "res\\font\\F08_1_S.txt", "F8")
  
-- Global Object
wd_emeter = {}

  local wEmeterColl = {}      -- all Luci widgets
  local deviceSupported = {"Meter DIN"}
    
  local wdgtName = "$emtr"
  local wdgtBox_font = "F16B"
  local fname = thema.getDir() .. "cfg\\wd_emeter.cfg"
  local wradix = "emeter"
  
    -- pwr meter specific
  local wdgtBox_maxpwr = 8000   -- 8.000 Watt
  
  -- store configuration
  local function wd_emeter_storeCfg() 
    --hourglass.show ()
    utils.table_save(wEmeterColl , fname)
    --hourglass.hide ()
  end
 
  -- restore configuration
  local function wd_emeter_restoreCfg()
    wEmeterColl = utils.table_load(fname)
    if wEmeterColl ~= nil then
      -- set pointers
      for i=1, #wEmeterColl do
        wEmeterColl[i].f_reg=wd_emeter.reg
        wEmeterColl[i].f_unreg=wd_emeter.unreg
        wEmeterColl[i].f_move=wd_emeter.pos
        wEmeterColl[i].f_store=wd_emeter_storeCfg
        wEmeterColl[i].totalPwr = 0
        wEmeterColl[i].instantPwr = 0        
        wd_manager.widget_add (wEmeterColl[i])      -- add to widget list
      end
    else
      wEmeterColl = {}
    end
  end  
  
  -- delete Emeter (return the list index deleted)
  local function wd_emeter_del (name)
    sknLbl.delete("$v" .. name)
    sknProgbar.delete("$p" .. name)
    sknLbl.delete("$z" .. name)
    sknImg.delete (name)
  end
  
  -- create luci widget
  local function wd_emeter_widget_new (wd, name , winName, x, y)
    -- get description
    local desc=wd.desc
    -- background image
    -- background image (container)
    local iX, iY = sknColl.imgSize("IMG", "elmeterb")
    if sknImg.create (name, winName, x, y, iX, iY) == 0 then
      return
    end
    sknImg.longTouchCB(name, "wd_manager.moveClone")    -- moving support
    sknImg.image(name, "IMG", "elmeterb")
    sknImg.auxStr(name, name)    
    sknImg.show(name)
    
    -- Power value
    local pwrValue = "$v" .. name
    sknLbl.create(pwrValue, name, 25, 14, 71, 20, "HorCenter_VertCenter", "0")
    sknLbl.font(pwrValue, wdgtBox_font)
    sknLbl.colors(pwrValue, "black", "transparent")
    sknLbl.auxStr(pwrValue, name)
    sknLbl.longTouchCB(pwrValue, "wd_manager.moveClone")    -- moving support
    sknLbl.show(pwrValue)
    
    -- Bar value
    local pwrValueP = "$p" .. name
    sknProgbar.create(pwrValueP, name, 25, 40, 71, 8)
    sknProgbar.setlimits(pwrValueP, 0, wdgtBox_maxpwr, 0)
    sknProgbar.auxStr(pwrValueP, name)
    sknProgbar.show(pwrValueP)
    
    local pwrZone = "$z" .. name
    sknLbl.create(pwrZone, name, 25, 66, 71, 20, "HorCenter_VertCenter", desc)
    sknLbl.font(pwrZone, wdgtBox_font)
    sknLbl.colors(pwrZone, "black", "transparent")
    sknImg.auxStr(pwrZone, name) 
    sknLbl.longTouchCB(pwrZone, "wd_manager.moveClone")    -- moving support
    sknLbl.keyReleaseCB(pwrZone, "win_devinfo.dispinfo")   -- dev infos
    sknLbl.show(pwrZone)
  end
  
  -- widget reg to new parent
  function wd_emeter.reg (wd, name, parent, x, y)
    wd_emeter_widget_new (wd, name, parent, x, y)
    wd_emeter_storeCfg()
  end
  
  -- unreg parent instance
  function wd_emeter.unreg (name)
    wd_emeter_del (name)
  end
  
  -- widget move
  function wd_emeter.pos (name, x,y)
    sknWin.pos (name, x,y)
  end    
  
  -- add new instance
  function wd_emeter.add (UID, desc)
    -- check for already present
    local idx
    local alreadyP = false
    for ii=1, #wEmeterColl do
      if wEmeterColl[ii].UID == UID and wEmeterColl[ii].desc == desc then
        alreadyP = true
        idx = ii
        break
      end
    end
    
    if alreadyP == false then
      table.insert (wEmeterColl,  {radix=wradix, UID=UID, tipo="D", icon=wradix .. "-i", zone="", desc=desc, help=sknColl.dictGetPhrase("HELP", 31), size_H=luceBox_H, size_W=luceBox_W, f_reg=wd_emeter.reg, f_unreg=wd_emeter.unreg, f_move=wd_emeter.pos, f_store=wd_emeter_storeCfg, f_setval=wd_emeter.setval,totalPwr=0, instantPwr=0, parents={}})
      idx = #wEmeterColl
    end
    wd_manager.widget_add (wEmeterColl[idx])      -- add to widget list
  end
  
  -- remove instance
  function wd_emeter.remove (UID, desc)
    for ii=1, #wEmeterColl do
      if wEmeterColl[ii].UID == UID and wEmeterColl[ii].desc == desc then
        -- all widget parents
        for p=1, #wEmeterColl[ii].parents do
          local name = wEmeterColl[ii].parents[p].name
          wd_emeter_del(name)
        end
        
        table.remove (wEmeterColl, ii)
        return
      end
    end
  end
  
  -- module startUp
  local function wd_emeter_startUp ()
    wd_emeter_restoreCfg()
    -- synth creation of already active devices
    cccwrp.widget_register("emeter", deviceSupported, wd_emeter.add, wd_emeter.remove, wd_emeter.setval)  -- register CCC widget
    wd_emeter.demodata ()   -- demo data
  end
  
  -- return the widget index from obj name or -1 
  local function wd_emeter_getIndex_name (oname)
    for i=1, #wEmeterColl do
      for p=1, #wEmeterColl[i].parents do
        if wEmeterColl[i].parents[p].name == oname then
            return i
        end
      end
    end
    return -1
  end
  
  -- return the widget index from widget desc or -1 
  local function wd_emeter_getIndex_desc (desc)
    for i=1, #wEmeterColl do
      if wEmeterColl[i].desc == desc then
        return i
      end
    end
    return -1
  end
  
  -- update all widget parents states
  local function wd_emeter_updParents(idx)
    if idx == -1 then return end

    -- all widget parents
    for p=1, #wEmeterColl[idx].parents do
      local name = wEmeterColl[idx].parents[p].name
      sknLbl.text("$v" .. name, tostring(wEmeterColl[idx].totalPwr))
      sknProgbar.setvalue("$p" .. name, wEmeterColl[idx].instantPwr)
    end
  end
  
  -- set Luce status
  function wd_emeter.setval (desc, instantPwr, totalPwr)
    local idx = wd_emeter_getIndex_desc (desc)
    if idx == -1 then return end
    
    -- change status
    wEmeterColl[idx].totalPwr = totalPwr
    wEmeterColl[idx].instantPwr = instantPwr
    wd_emeter_updParents(idx)
  end

  ------- DEMO DATA ------
  function wd_emeter.demodata ()
    wd_emeter.add (9993, "generale")
    wd_emeter.add (6662, "luci")
    wd_emeter.add (2221, "prese")
    
    wd_emeter.setval ("generale", 1250, 34567)
    wd_emeter.setval ("luci", 2200, 8910)    
    wd_emeter.setval ("prese", 2200, 8910)
  end
    
  
wd_emeter_startUp ()   -- Window creation
