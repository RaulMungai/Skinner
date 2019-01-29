-------------------------------------------------------------------
---------------------------  widget:VOC CO2e sensor  --------------
-------------------------------------------------------------------
--[[
  VOC CO2e sensor Widget
    
  Elements:
    wd_vocco2e.setval (zona, on, busy)      -- set Sensor status
    
  internals:
    
  date: 03/01/2019 
  by: Raul Mungai
--]]


-- Load artworks
----------------
css.load_btn_img ("\\buttons\\chemical.png",  "vocco2e")   -- app icon button
css.load_img ("\\icons\\vocs-i.png", "vocco2e-i", "icon") -- app icon (small)

-- meter widget
css.load_img ("\\img\\aria.bmp", "bgaria", "IMG") -- back image
css.font_mount (thema.workDisk .. "res\\font\\F16B_1_S.txt", "F16B")
css.font_mount (thema.workDisk .. "res\\font\\F13B_1_S.txt", "F13B")

-- icons
css.load_img ("\\icons\\temp-i.png", "temp-i", "icon")
css.load_img ("\\icons\\voc-i.png", "voc-i", "icon")
css.load_img ("\\icons\\co2-i.png", "co2-i", "icon")
css.load_img ("\\icons\\hum-i.png", "hum-i", "icon")

  
-- Global Object
wd_vocco2e = {}

  local wVocco2eColl = {}      -- all Luci widgets
  local deviceSupported = {"VOC CO2e", "VOC CO2eLT"}
    
  local wdgtName = "$vocco2e"
  local wdgtBox_font = "F16B"
  local fname = thema.getDir() .. "cfg\\wd_vocco2e.cfg"
  local wradix = "vocco2e"
  
  -- store configuration
  function wd_vocco2e.storeCfg() 
    --hourglass.show ()
    utils.table_save(wVocco2eColl , fname)
    --hourglass.hide ()
  end
 
  -- restore configuration
  local function wd_vocco2e_restoreCfg()
    wVocco2eColl = utils.table_load(fname)
    if wVocco2eColl ~= nil then
      -- set pointers
      for i=1, #wVocco2eColl do
        wVocco2eColl[i].f_reg=wd_vocco2e.reg
        wVocco2eColl[i].f_unreg=wd_vocco2e.unreg
        wVocco2eColl[i].f_move=wd_vocco2e.pos
        wVocco2eColl[i].f_store=wd_vocco2e.storeCfg
        wVocco2eColl[i].temp = 0
        wVocco2eColl[i].hum = 0
        wVocco2eColl[i].VOC = 0
        wVocco2eColl[i].CO2e = 0        
        wd_manager.widget_add (wVocco2eColl[i])      -- add to widget list
      end
    else
      wVocco2eColl = {}
    end
  end  
  
  -- delete Emeter (return the list index deleted)
  local function wd_vocco2e_del (name)
    sknImg.delete ("$ti" .. name)
    sknLbl.delete("$tv" .. name)
    sknImg.delete ("$hi" .. name)
    sknLbl.delete("$hv" .. name)
    sknImg.delete ("$Vi" .. name)
    sknLbl.delete("$Vv" .. name)
    sknImg.delete ("$Ci" .. name)
    sknLbl.delete("$Cv" .. name)
    sknLbl.delete("$D" .. name)
    sknImg.delete (name)
  end
  
  -- return the widget index from widget desc or -1 
  local function wd_vocco2e_getIndex_desc (desc)
    for i=1, #wVocco2eColl do
      if wVocco2eColl[i].desc == desc then
        return i
      end
    end
    return -1
  end
  
  -- create luci widget
  local function wd_vocco2e_widget_new (wd, name , winName, x, y)
    local desc=wd.desc
    local idx = wd_vocco2e_getIndex_desc (desc)
    if idx == -1 then return end
    
    -- background image (container)
    sknImg.create (name, winName, x, y, 0, 0)
    sknImg.longTouchCB(name, "wd_manager.moveClone")    -- moving support
    sknImg.image(name, "IMG", "bgaria")
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
    sknLbl.create(tvalue, name, 28, 2, 48, 20, "HorLeft_VertCenter", tostring(wVocco2eColl[idx].temp) .. " \xb0C")
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
    sknLbl.create(tvalue, name, 28, 26, 48, 20, "HorLeft_VertCenter", tostring(wVocco2eColl[idx].hum) .. " %")
    sknLbl.font(tvalue, wdgtBox_font)
    sknLbl.colors(tvalue, "black", "transparent")
    sknLbl.auxStr(tvalue, name)
    sknLbl.longTouchCB(tvalue, "wd_manager.moveClone")    -- moving support
    sknLbl.show(tvalue)

    -- VOC: icon
    ticon = "$Vi" .. name
    sknImg.create (ticon, name, 2, 48, 0, 0)
    sknImg.longTouchCB(ticon, "wd_manager.moveClone")    -- moving support
    sknImg.image(ticon, "icon", "voc-i")
    sknImg.auxStr(ticon, name)    
    sknImg.show(ticon)
    -- Hum: value
    tvalue = "$Vv" .. name
    sknLbl.create(tvalue, name, 28, 48, 48, 20, "HorLeft_VertCenter", tostring(wVocco2eColl[idx].VOC))
    sknLbl.font(tvalue, wdgtBox_font)
    sknLbl.colors(tvalue, "black", "transparent")
    sknLbl.auxStr(tvalue, name)
    sknLbl.longTouchCB(tvalue, "wd_manager.moveClone")    -- moving support
    sknLbl.show(tvalue)

    -- CO2: icon
    ticon = "$Ci" .. name
    sknImg.create (ticon, name, 2, 70, 0, 0)
    sknImg.longTouchCB(ticon, "wd_manager.moveClone")    -- moving support
    sknImg.image(ticon, "icon", "co2-i")
    sknImg.auxStr(ticon, name)    
    sknImg.show(ticon)
    -- Hum: value
    tvalue = "$Cv" .. name
    sknLbl.create(tvalue, name, 28, 70, 48, 20, "HorLeft_VertCenter", tostring(wVocco2eColl[idx].CO2e))
    sknLbl.font(tvalue, wdgtBox_font)
    sknLbl.colors(tvalue, "black", "transparent")
    sknLbl.auxStr(tvalue, name)
    sknLbl.longTouchCB(tvalue, "wd_manager.moveClone")    -- moving support
    sknLbl.show(tvalue)

    -- desc
    tvalue = "$D" .. name
    sknLbl.create(tvalue, name, 0, 97, 75, 20, "HorCenter_VertCenter", wd.desc)
    sknLbl.font(tvalue, "F13B")
    sknLbl.colors(tvalue, "black", "transparent")
    sknLbl.auxStr(tvalue, name)
    sknLbl.longTouchCB(tvalue, "wd_manager.moveClone")    -- moving support
    sknLbl.keyReleaseCB(tvalue, "win_devinfo.dispinfo")   -- dev infos
    sknLbl.show(tvalue)
  end
  
  -- widget reg to new parent
  function wd_vocco2e.reg (wd, name, parent, x, y)
    wd_vocco2e_widget_new (wd, name, parent, x, y)
    wd_vocco2e.storeCfg()
  end
  
  -- unreg parent instance
  function wd_vocco2e.unreg (name)
    wd_vocco2e_del (name)
  end
  
  -- widget move
  function wd_vocco2e.pos (name, x,y)
    sknWin.pos (name, x,y)
  end    
  
  -- add new instance
  function wd_vocco2e.add (UID, desc)
    -- check for already present
    local idx
    local alreadyP = false
    for ii=1, #wVocco2eColl do
      if wVocco2eColl[ii].UID == UID and wVocco2eColl[ii].desc == desc then
        alreadyP = true
        idx = ii
        break
      end
    end
    
    if alreadyP == false then
      table.insert (wVocco2eColl,  {radix=wradix, UID=UID, tipo="D", icon=wradix .. "-i", zone="", desc=desc, help=sknColl.dictGetPhrase("HELP", 31), size_H=luceBox_H, size_W=luceBox_W, f_reg=wd_vocco2e.reg, f_unreg=wd_vocco2e.unreg, f_move=wd_vocco2e.pos, f_store=wd_vocco2e.storeCfg, f_setval=wd_vocco2e.setval,temp=0, hum=0, VOC=0, CO2e=0, parents={}})
      idx = #wVocco2eColl
    end
    wd_manager.widget_add (wVocco2eColl[idx])      -- add to widget list
  end
  
  -- remove instance
  function wd_vocco2e.remove (UID, desc)
    for ii=1, #wVocco2eColl do
      if wVocco2eColl[ii].UID == UID and wVocco2eColl[ii].desc == desc then        
        -- all widget parents
        for p=1, #wVocco2eColl[ii].parents do
          local name = wVocco2eColl[ii].parents[p].name
          wd_vocco2e_del(name)
        end
      
        table.remove (wVocco2eColl, ii)
        return
      end
    end
  end
  
  -- module startUp
  local function wd_vocco2e_startUp ()
    wd_vocco2e_restoreCfg()
    -- synth creation of already active devices
    cccwrp.widget_register("vocco2e", deviceSupported, wd_vocco2e.add, wd_vocco2e.remove, wd_vocco2e.setval)  -- register CCC widget
    wd_vocco2e.demodata ()   -- demo data
  end
  
  -- return the widget index from obj name or -1 
  local function wd_vocco2e_getIndex_name (oname)
    for i=1, #wVocco2eColl do
      for p=1, #wVocco2eColl[i].parents do
        if wVocco2eColl[i].parents[p].name == oname then
            return i
        end
      end
    end
    return -1
  end
  
  -- update all widget parents states
  local function wd_vocco2e_updParents(idx)
    if idx == -1 then return end

    -- all widget parents
    for p=1, #wVocco2eColl[idx].parents do
      local name = wVocco2eColl[idx].parents[p].name
      sknLbl.text("$tv" .. name, tostring(wVocco2eColl[idx].temp) .. " \xb0C")
      sknLbl.text("$hv" .. name, tostring(wVocco2eColl[idx].hum) .. " %")
      sknLbl.text("$Vv" .. name, tostring(wVocco2eColl[idx].VOC))
      sknLbl.text("$Cv" .. name, tostring(wVocco2eColl[idx].CO2e))
      sknLbl.text("$D" .. name, tostring(wVocco2eColl[idx].desc))
    end
  end
  
  -- set Sensor status
  function wd_vocco2e.setval (desc, temp, hum, VOC, CO2e)
    local idx = wd_vocco2e_getIndex_desc (desc)
    if idx == -1 then return end
    
    -- change status
    wVocco2eColl[idx].temp = temp
    wVocco2eColl[idx].hum = hum
    wVocco2eColl[idx].VOC = VOC
    wVocco2eColl[idx].CO2e = CO2e
    wd_vocco2e_updParents(idx)
  end

  ------- DEMO DATA ------
  function wd_vocco2e.demodata ()
    --wd_vocco2e.add (2222, "ripostiglio")
    --wd_vocco2e.setval ("cucina", 233, 180)
  end
    
  
wd_vocco2e_startUp ()   -- Window creation
