-------------------------------------------------------------------
---------------------------  widget:T sensor  --------------
-------------------------------------------------------------------
--[[
  T sensor Widget
    
  Elements:
    wd_sensT.setval (zona, on, busy)      -- set Sensor status
    
  internals:
    
  date: 10/01/2019 
  by: Raul Mungai
--]]


-- Load artworks
----------------
css.load_btn_img ("\\buttons\\sensT.png",  "sensT")   -- app icon button
css.load_img ("\\icons\\sensT-i.png", "sensT-i", "icon") -- app icon (small)

-- meter widget
css.load_img ("\\img\\T.bmp", "bgt", "IMG") -- back image
css.font_mount (thema.workDisk .. "res\\font\\F16B_1_S.txt", "F16B")
css.font_mount (thema.workDisk .. "res\\font\\F13B_1_S.txt", "F13B")

-- icons
css.load_img ("\\icons\\temp-i.png", "temp-i", "icon")
  
-- Global Object
wd_sensT = {}

  local wsensTColl = {}      -- all Luci widgets
  local deviceSupported = {"SensT"}
  local maxZone = 20    -- max number of zone
    
  local wdgtName = "$sensT"
  local wdgtBox_font = "F16B"
  local fname = thema.getDir() .. "cfg\\wd_sensT.cfg"
  local wradix = "sensT"
  
  -- store configuration
  function wd_sensT.storeCfg() 
    --hourglass.show ()
    utils.table_save(wsensTColl , fname)
    --hourglass.hide ()
  end
 
  -- restore configuration
  local function wd_sensT_restoreCfg()
    wsensTColl = utils.table_load(fname)
    if wsensTColl ~= nil then
      -- set pointers
      for i=1, #wsensTColl do
        wsensTColl[i].f_reg=wd_sensT.reg
        wsensTColl[i].f_unreg=wd_sensT.unreg
        wsensTColl[i].f_move=wd_sensT.pos
        wsensTColl[i].f_store=wd_sensT.storeCfg
        wsensTColl[i].temp = 0
        wd_manager.widget_add (wsensTColl[i])      -- add to widget list
      end
    else
      wsensTColl = {}
    end
  end  
  
  -- delete Emeter (return the list index deleted)
  local function wd_sensT_del (name)
    sknImg.delete ("$ti" .. name)
    sknLbl.delete("$tv" .. name)
    sknLbl.delete("$D" .. name)
    sknImg.delete (name)
  end
  
  -- return the widget index from widget desc or -1 
  local function wd_sensT_getIndex_desc (desc)
    for i=1, #wsensTColl do
      if wsensTColl[i].desc == desc then
        return i
      end
    end
    return -1
  end
  
  -- create luci widget
  local function wd_sensT_widget_new (wd, name , winName, x, y)
    local desc=wd.desc
    local idx = wd_sensT_getIndex_desc (desc)
    if idx == -1 then return end
    
    -- background image (container)
    sknImg.create (name, winName, x, y, 0, 0)
    sknImg.longTouchCB(name, "wd_manager.moveClone")    -- moving support
    sknImg.image(name, "IMG", "bgt")
    sknImg.auxStr(name, name)    
    sknImg.show(name)
    
    -- Temp: icon
    local ticon = "$ti" .. name
    sknImg.create (ticon, name, 2, 2, 0, 0)
    sknImg.longTouchCB(ticon, "wd_manager.moveClone")    -- moving support
    sknImg.image(ticon, "icon", "temp-i")
    sknImg.auxStr(ticon, name)    
    sknImg.show(ticon)
    -- Temp: value
    local tvalue = "$tv" .. name
    sknLbl.create(tvalue, name, 28, 2, 48, 20, "HorLeft_VertCenter", tostring(wsensTColl[idx].temp) .. " \xb0C")
    sknLbl.font(tvalue, wdgtBox_font)
    sknLbl.colors(tvalue, "black", "transparent")
    sknLbl.auxStr(tvalue, name)
    sknLbl.longTouchCB(tvalue, "wd_manager.moveClone")    -- moving support
    sknLbl.show(tvalue)

    -- desc
    tvalue = "$D" .. name
    sknLbl.create(tvalue, name, 0, 30, 75, 20, "HorCenter_VertCenter", wd.desc)
    sknLbl.font(tvalue, "F13B")
    sknLbl.colors(tvalue, "black", "transparent")
    sknLbl.auxStr(tvalue, name)
    sknLbl.longTouchCB(tvalue, "wd_manager.moveClone")    -- moving support
    sknLbl.keyReleaseCB(tvalue, "win_devinfo.dispinfo")   -- dev infos
    sknLbl.show(tvalue)
  end
  
  -- widget reg to new parent
  function wd_sensT.reg (wd, name, parent, x, y)
    wd_sensT_widget_new (wd, name, parent, x, y)
    wd_sensT.storeCfg()
  end
  
  -- unreg parent instance
  function wd_sensT.unreg (name)
    wd_sensT_del (name)
  end
  
  -- widget move
  function wd_sensT.pos (name, x,y)
    sknWin.pos (name, x,y)
  end    
  
  -- add new instance
  function wd_sensT.add (UID, desc)
    -- check for already present
    local idx
    local alreadyP = false
    for ii=1, #wsensTColl do
      if wsensTColl[ii].UID == UID and wsensTColl[ii].desc == desc then
        alreadyP = true
        idx = ii
        break
      end
    end
    
    if alreadyP == false then
      table.insert (wsensTColl,  {radix=wradix, UID=UID, tipo="D", icon=wradix .. "-i", zone="", desc=desc, help=sknColl.dictGetPhrase("HELP", 31), size_H=luceBox_H, size_W=luceBox_W, f_reg=wd_sensT.reg, f_unreg=wd_sensT.unreg, f_move=wd_sensT.pos, f_store=wd_sensT.storeCfg, f_setval=wd_sensT.setval,temp=0, parents={}})
      idx = #wsensTColl
    end
    wd_manager.widget_add (wsensTColl[idx])      -- add to widget list
  end
  
  -- remove instance
  function wd_sensT.remove (UID, desc)
    for ii=1, #wsensTColl do
      if wsensTColl[ii].UID == UID and wsensTColl[ii].desc == desc then
        -- all widget parents
        for p=1, #wsensTColl[ii].parents do
          local name = wsensTColl[ii].parents[p].name
          wd_sensT_del(name)
        end
        
        table.remove (wsensTColl, ii)
        return
      end
    end
  end
  
  -- module startUp
  local function wd_sensT_startUp ()
    wd_sensT_restoreCfg()
    -- synth creation of already active devices
    cccwrp.widget_register("sensT", deviceSupported, wd_sensT.add,wd_sensT.remove, wd_sensT.setval)  -- register CCC widget
    wd_sensT.demodata ()   -- demo data
  end
  
  -- return the widget index from obj name or -1 
  local function wd_sensT_getIndex_name (oname)
    for i=1, #wsensTColl do
      for p=1, #wsensTColl[i].parents do
        if wsensTColl[i].parents[p].name == oname then
            return i
        end
      end
    end
    return -1
  end
  
  -- update all widget parents states
  local function wd_sensT_updParents(idx)
    if idx == -1 then return end

    -- all widget parents
    for p=1, #wsensTColl[idx].parents do
      local name = wsensTColl[idx].parents[p].name
      sknLbl.text("$tv" .. name, tostring(wsensTColl[idx].temp) .. " \xb0C")
      sknLbl.text("$D" .. name, tostring(wsensTColl[idx].desc))
    end
  end
  
  -- set Sensor status
  function wd_sensT.setval (desc, temp, hum)
    local idx = wd_sensT_getIndex_desc (desc)
    if idx == -1 then return end
    
    -- change status
    wsensTColl[idx].temp = temp
    wd_sensT_updParents(idx)
  end

  ------- DEMO DATA ------
  function wd_sensT.demodata ()
    --wd_sensT.add (2222, "ripostiglio")
    --wd_sensT.setval ("cucina", 233, 180)
  end
    
  
wd_sensT_startUp ()   -- Window creation
