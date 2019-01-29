-------------------------------------------------------------------
---------------------------  widget:TU sensor  --------------
-------------------------------------------------------------------
--[[
  TU sensor Widget
    
  Elements:
    wd_sensTU.setval (zona, on, busy)      -- set Sensor status
    
  internals:
    
  date: 10/01/2019 
  by: Raul Mungai
--]]


-- Load artworks
----------------
css.load_btn_img ("\\buttons\\TU.png",  "sensTU")   -- app icon button
css.load_img ("\\icons\\TU-i.png", "sensTU-i", "icon") -- app icon (small)

-- meter widget
css.load_img ("\\img\\TU.bmp", "bgtu", "IMG") -- back image
css.font_mount (thema.workDisk .. "res\\font\\F16B_1_S.txt", "F16B")
css.font_mount (thema.workDisk .. "res\\font\\F13B_1_S.txt", "F13B")

-- icons
css.load_img ("\\icons\\temp-i.png", "temp-i", "icon")
css.load_img ("\\icons\\hum-i.png", "hum-i", "icon")

  
-- Global Object
wd_sensTU = {}

  local wsensTUColl = {}      -- all Luci widgets
  local deviceSupported = {"SensTU"}
  local maxZone = 20    -- max number of zone
    
  local wdgtName = "$sensTU"
  local wdgtBox_font = "F16B"
  local fname = thema.getDir() .. "cfg\\wd_sensTU.cfg"
  local wradix = "sensTU"
  
  -- store configuration
  function wd_sensTU.storeCfg() 
    --hourglass.show ()
    utils.table_save(wsensTUColl , fname)
    --hourglass.hide ()
  end
 
  -- restore configuration
  local function wd_sensTU_restoreCfg()
    wsensTUColl = utils.table_load(fname)
    if wsensTUColl ~= nil then
      -- set pointers
      for i=1, #wsensTUColl do
        wsensTUColl[i].f_reg=wd_sensTU.reg
        wsensTUColl[i].f_unreg=wd_sensTU.unreg
        wsensTUColl[i].f_move=wd_sensTU.pos
        wsensTUColl[i].f_store=wd_sensTU.storeCfg
        wsensTUColl[i].temp = 0
        wsensTUColl[i].hum = 0
        wd_manager.widget_add (wsensTUColl[i])      -- add to widget list
      end
    else
      wsensTUColl = {}
    end
  end  
  
  -- delete Emeter (return the list index deleted)
  local function wd_sensTU_del (name)
    sknImg.delete ("$ti" .. name)
    sknLbl.delete("$tv" .. name)
    sknImg.delete ("$hi" .. name)
    sknLbl.delete("$hv" .. name)
    sknLbl.delete("$D" .. name)
    sknImg.delete (name)
  end
  
  -- return the widget index from widget desc or -1 
  local function wd_sensTU_getIndex_desc (desc)
    for i=1, #wsensTUColl do
      if wsensTUColl[i].desc == desc then
        return i
      end
    end
    return -1
  end

  -- create luci widget
  local function wd_sensTU_widget_new (wd, name , winName, x, y)
    local desc=wd.desc
    local idx = wd_sensTU_getIndex_desc (desc)
    if idx == -1 then return end
    
    -- background image (container)
    sknImg.create (name, winName, x, y, 0, 0)
    sknImg.longTouchCB(name, "wd_manager.moveClone")    -- moving support
    sknImg.image(name, "IMG", "bgtu")
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
    sknLbl.create(tvalue, name, 28, 2, 48, 20, "HorLeft_VertCenter", tostring(wsensTUColl[idx].temp) .. " \xb0C")
    sknLbl.font(tvalue, wdgtBox_font)
    sknLbl.colors(tvalue, "black", "transparent")
    sknLbl.auxStr(tvalue, name)
    sknLbl.longTouchCB(tvalue, "wd_manager.moveClone")    -- moving support
    sknLbl.show(tvalue)
 
    -- Hum: icon
    ticon = "$hi" .. name
    sknImg.create (ticon, name, 2, 26, 0, 0)
    sknImg.longTouchCB(ticon, "wd_manager.moveClone")    -- moving support
    sknImg.image(ticon, "icon", "hum-i")
    sknImg.auxStr(ticon, name)    
    sknImg.show(ticon)
    -- Hum: value
    tvalue = "$hv" .. name
    sknLbl.create(tvalue, name, 28, 26, 48, 20, "HorLeft_VertCenter", tostring(wsensTUColl[idx].hum) .. " %")
    sknLbl.font(tvalue, wdgtBox_font)
    sknLbl.colors(tvalue, "black", "transparent")
    sknLbl.auxStr(tvalue, name)
    sknLbl.longTouchCB(tvalue, "wd_manager.moveClone")    -- moving support
    sknLbl.show(tvalue)

    -- desc
    tvalue = "$D" .. name
    sknLbl.create(tvalue, name, 0, 60, 75, 20, "HorCenter_VertCenter", wd.desc)
    sknLbl.font(tvalue, "F13B")
    sknLbl.colors(tvalue, "black", "transparent")
    sknLbl.auxStr(tvalue, name)
    sknLbl.longTouchCB(tvalue, "wd_manager.moveClone")    -- moving support
    sknLbl.keyReleaseCB(tvalue, "win_devinfo.dispinfo")   -- dev infos
    sknLbl.show(tvalue)
  end
  
  -- widget reg to new parent
  function wd_sensTU.reg (wd, name, parent, x, y)
    wd_sensTU_widget_new (wd, name, parent, x, y)
    wd_sensTU.storeCfg()
  end
  
  -- unreg parent instance
  function wd_sensTU.unreg (name)
    wd_sensTU_del (name)
  end
  
  -- widget move
  function wd_sensTU.pos (name, x,y)
    sknWin.pos (name, x,y)
  end    
  
  -- add new instance
  function wd_sensTU.add (UID, desc)
    -- check for already present
    local idx
    local alreadyP = false
    for ii=1, #wsensTUColl do
      if wsensTUColl[ii].UID == UID and wsensTUColl[ii].desc == desc then
        alreadyP = true
        idx = ii
        break
      end
    end
    
    if alreadyP == false then
      table.insert (wsensTUColl,  {radix=wradix, UID=UID, tipo="D", icon=wradix .. "-i", zone="", desc=desc, help=sknColl.dictGetPhrase("HELP", 31), size_H=luceBox_H, size_W=luceBox_W, f_reg=wd_sensTU.reg, f_unreg=wd_sensTU.unreg, f_move=wd_sensTU.pos, f_store=wd_sensTU.storeCfg, f_setval=wd_sensTU.setval,temp=0, hum=0, parents={}})
      idx = #wsensTUColl
    end
    wd_manager.widget_add (wsensTUColl[idx])      -- add to widget list
  end
  
  -- remove instance
  function wd_sensTU.remove (UID, desc)
    for ii=1, #wsensTUColl do
      if wsensTUColl[ii].UID == UID and wsensTUColl[ii].desc == desc then
        -- all widget parents
        for p=1, #wsensTUColl[ii].parents do
          local name = wsensTUColl[ii].parents[p].name
          wd_sensTU_del(name)
        end
        
        table.remove (wsensTUColl,ii)
        return
      end
    end
  end
  
  -- module startUp
  local function wd_sensTU_startUp ()
    wd_sensTU_restoreCfg()
    -- synth creation of already active devices
    cccwrp.widget_register("sensTU", deviceSupported, wd_sensTU.add, wd_sensTU.remove, wd_sensTU.setval)  -- register CCC widget
    wd_sensTU.demodata ()   -- demo data
  end
  
  -- return the widget index from obj name or -1 
  local function wd_sensTU_getIndex_name (oname)
    for i=1, #wsensTUColl do
      for p=1, #wsensTUColl[i].parents do
        if wsensTUColl[i].parents[p].name == oname then
            return i
        end
      end
    end
    return -1
  end
    
  -- update all widget parents states
  local function wd_sensTU_updParents(idx)
    if idx == -1 then return end

    -- all widget parents
    for p=1, #wsensTUColl[idx].parents do
      local name = wsensTUColl[idx].parents[p].name
      sknLbl.text("$tv" .. name, tostring(wsensTUColl[idx].temp) .. " \xb0C")
      sknLbl.text("$hv" .. name, tostring(wsensTUColl[idx].hum) .. " %")
      sknLbl.text("$D" .. name, tostring(wsensTUColl[idx].desc))
    end
  end
  
  -- set Sensor status
  function wd_sensTU.setval (desc, temp, hum)
    local idx = wd_sensTU_getIndex_desc (desc)
    if idx == -1 then return end
    
    -- change status
    wsensTUColl[idx].temp = temp
    wsensTUColl[idx].hum = hum
    wd_sensTU_updParents(idx)
  end

  ------- DEMO DATA ------
  function wd_sensTU.demodata ()
    --wd_sensTU.add (2222, "ripostiglio")
    --wd_sensTU.setval ("cucina", 233, 180)
  end
    
  
wd_sensTU_startUp ()   -- Window creation
