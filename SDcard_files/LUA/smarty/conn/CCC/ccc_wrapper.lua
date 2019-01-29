-------------------------------------------------------------------
---------------------------  CCC:wrapper  -------------------------
-------------------------------------------------------------------
--[[
  UI side:
    cccwrp.widget_register(supportedList, f_register, f_setValue)   -- Register Widget
    cccwrp.joinRequest(UID, desc)                       -- UID join request
    cccwrp.CCCremoveObj (UID)                           -- remove CCC object from UID 
    
    cccwrp.measureAdjScale (measure, precision, decimals) -- Conversion native CCC measure to number

    cccwrp.reloadActiveObj ()                           -- reload active objects (CCC active objects)
   
  CCC side:
    cccwrp.newObj(objID)            -- New Object event
    cccwrp.setvalue(objID)          -- Set Object values (Called from CCC-cb during remote data update process)
  
  internals:
    
  date: 18/12/2018 
  by: Raul Mungai
--]]

cccwrp = {}

  local cccwrp_wdList = {}         -- widget list (VOLATILE)
  local cccwrp_wdActiveLst = {}    -- widget active list (PERSISTENT)  -- {UID=0, desc="", active=false}
  
  local fname = thema.getDir() .. "cfg\\wd_ccc.cfg"

-- Conversion native CCC measure to number
function cccwrp.measureAdjScale (measure, precision, decimals)
  if decimals == nil then
    decimals = false
  end
  
  if decimals == false then
    if precision == 1 then
      measure = measure // 10
    elseif precision == 2 then
      measure = measure // 100
    elseif precision == 3 then
      measure = measure // 1000
    end
  else
    if precision == 1 then
      measure = measure / 10
    elseif precision == 2 then
      measure = measure / 100
    elseif precision == 3 then
      measure = measure / 1000
    end    
  end
  return measure
end

-- store configuration
  local function cccwrp_storeCfg() 
    --hourglass.show ()
    utils.table_save(cccwrp_wdActiveLst, fname)
    --hourglass.hide ()
  end
 
  -- restore configuration
  local function cccwrp_restoreCfg()
    cccwrp_wdActiveLst = utils.table_load(fname)
    if cccwrp_wdActiveLst == nil then
      cccwrp_wdActiveLst = {}
    end
  end  

-- Get active widget index from UID (0 == not found)
local function cccwrp_widgetAct_getIndex_UID(UID)

  for i=1, #cccwrp_wdActiveLst do
    if cccwrp_wdActiveLst[i].UID ~= nil then
      if cccwrp_wdActiveLst[i].UID == UID then
        return i
      end
    end    
  end
  return 0
end


-- Get widget index from name (0 == not found)
local function cccwrp_widget_getIndex_name(name)

  for i=1, #cccwrp_wdList do
    if cccwrp_wdList[i].name ~= nil then
      if cccwrp_wdList[i].name == name then
        return i
      end
    end    
  end
  return 0
end

-- Get widget index from device name (0 == not found)
local function cccwrp_widget_getIndex_devname(devname)

  for i=1, #cccwrp_wdList do
    if cccwrp_wdList[i].name ~= nil then
      for s=1, #cccwrp_wdList[i].supported do
        if cccwrp_wdList[i].supported[s] == devname then
          return i
        end
      end  
    end    
  end
  return 0
end

-- UI side ---------
--------------------

-- Register Widget
function cccwrp.widget_register(name, supportedList, f_register, f_unregister, f_setValue)

  if cccwrp_widget_getIndex_name(name) ~= 0 then
    return  -- already registered
  end
  table.insert (cccwrp_wdList,  {name=name, supported=supportedList, f_reg=f_register, f_unreg=f_unregister, f_setval=f_setValue, active=false})
end

-- UID join request
function cccwrp.joinRequest(UID, desc)
  if cccwrp_widgetAct_getIndex_UID(UID) ~= 0 then
    return --already exists
  end
  table.insert (cccwrp_wdActiveLst,  {UID=UID, desc=desc, active=false})
  cccwrp_storeCfg()  -- table store
end


-- CCC side --------
--------------------

-- New Object event (Called from CCC-cb and end of CCC startUp)
function cccwrp.newObj(objID, noVerbose)
  if noVerbose == nil then
    noVerbose = false
  end
  
  local UID = CCC.getnum(objID, "BASE", "uniqueID")
  if UID == nil then return end
  if UID == 0 then return end
  
  local devname = CCC.getstr(objID, "PLATFORM", "prodType")
  if devname == nil then return end
  if devname == "" then return end
  --print ("cccwrp.newObj(ID, UID, devname)", objID, UID, devname)

  -- scan regisgter widgets
  local i = cccwrp_widget_getIndex_devname(devname)
  if i == 0 then return end
  
  local actIdx = cccwrp_widgetAct_getIndex_UID(UID)
  if actIdx == 0 then return end
  
  if cccwrp_wdActiveLst[actIdx].active == true then return end
  
  -- first registration
  cccwrp_wdActiveLst[actIdx].active = true
  cccwrp_wdList[i].f_reg(UID, cccwrp_wdActiveLst[actIdx].desc)  -- widget registration (notify to UI)
  
  -- PopUp ?
  if noVerbose == false then
    win_popup.text ("NUOVO DEVICE", "Si e' registrato un nuovo device "..cccwrp_wdList[i].name .. ":" .. cccwrp_wdActiveLst[actIdx].desc ..".")
  end
  
  cccwrp_storeCfg()  -- table store
end


-- Set Object values (Called from CCC-cb during remote data update process)
function cccwrp.setvalue(objID) 
  local UID = CCC.getnum(objID, "BASE", "uniqueID")
  if UID == nil then return end
  if UID == 0 then return end
  
  local devname = CCC.getstr(objID, "PLATFORM", "prodType")
  if devname == nil then return end
  if devname == "" then return end

  -- scan regisgter widgets
  local i = cccwrp_widget_getIndex_devname(devname)
  if i == 0 then return end
  
  local actIdx = cccwrp_widgetAct_getIndex_UID(UID)
  if actIdx == 0 then return end  
  if cccwrp_wdActiveLst[actIdx].active == false then return end
  
  -- data extraction (by device)
  if devname == "Meter DIN" then
    local instantPwr = -1
    local totalPwr = -1
    local act = 1
    local ii = 0
    repeat
      local mtype = CCC.measureType2str(CCC.getnum(objID, "METER", "type." .. tostring(ii)))
      local mscale = CCC.measureScale2str(CCC.getnum(objID, "METER", "scale." .. tostring(ii)))
      local mprecision = CCC.getnum(objID, "METER", "precision." .. tostring(ii))
      local mvalue = CCC.getnum(objID, "METER", "measure." .. tostring(ii))
      act = CCC.getnum(objID, "METER", "active." .. tostring(ii))
      if act == 1 then
        if mtype == "Energy" then
          totalPwr = cccwrp.measureAdjScale (mvalue, mprecision)
        
        elseif mtype == "Power" then
          instantPwr = cccwrp.measureAdjScale (mvalue, mprecision)
        end
        
        ccclog.log(UID, mtype, mscale, mprecision, mvalue) -- Logging
      end
      ii = ii +1
    until( act == 0 )
    
    if instantPwr == -1 or totalPwr == -1 then return end -- missing param
   
    instantPwr = 1234
    --print ("Data from " .. cccwrp_wdActiveLst[actIdx].desc .. " (tot, instant)", totalPwr, instantPwr)
    if cccwrp_wdList[i].f_setval ~= nil then
      cccwrp_wdList[i].f_setval(cccwrp_wdActiveLst[actIdx].desc, instantPwr, totalPwr) 
    end
    
  elseif devname == "switch" then
    local swstat =  CCC.getnum(objID, "SWITCH", "switchStat")
    if swstat ~= nil then
      cccwrp_wdList[i].f_setval(cccwrp_wdActiveLst[actIdx].desc, swstat)
    end
  
elseif devname == "VOC CO2e" or devname == "VOC CO2eLT" then
    local temp = -1
    local hum = -1
    local voc = -1
    local co2 = -1
    local burin = -1
    local ii = 0
    repeat
      local mtype = CCC.measureType2str(CCC.getnum(objID, "SENSOR", "type." .. tostring(ii)))
      local mscale = CCC.measureScale2str(CCC.getnum(objID, "SENSOR", "scale." .. tostring(ii)))
      local mprecision = CCC.getnum(objID, "SENSOR", "precision." .. tostring(ii))
      local mvalue = CCC.getnum(objID, "SENSOR", "measure." .. tostring(ii))
      act = CCC.getnum(objID, "SENSOR", "active." .. tostring(ii))
      --print ("mesure(i, act, type, scale, precision, value)", ii, act, mtype,mscale,mprecision,mvalue)
      if act == 1 then
        if mtype == "Temperature" then
          temp = cccwrp.measureAdjScale (mvalue, mprecision, true)
        
        elseif mtype == "Humidity" then
          hum = cccwrp.measureAdjScale (mvalue, mprecision)
        
        elseif mtype == "VOC" then
          voc = cccwrp.measureAdjScale (mvalue, mprecision)
        
        elseif mtype == "CO2e" then
          co2 = cccwrp.measureAdjScale (mvalue, mprecision)
        
        elseif mtype == "Calib" then
          burin = cccwrp.measureAdjScale (mvalue, mprecision)
        end
        ccclog.log(UID, mtype, mscale, mprecision, mvalue) -- Logging
      end
      ii = ii +1
    until( act == 0 )
    
    if temp == -1 or hum == -1 or voc == -1 or co2 == -1 or burin == -1 then return end -- missing param
    if cccwrp_wdList[i].f_setval ~= nil then
      cccwrp_wdList[i].f_setval(cccwrp_wdActiveLst[actIdx].desc, temp, hum, voc, co2) 
    end
    
elseif devname == "SensTU" then
    local temp = -1
    local hum = -1
    local ii = 0
    repeat
      local mtype = CCC.measureType2str(CCC.getnum(objID, "SENSOR", "type." .. tostring(ii)))
      local mscale = CCC.measureScale2str(CCC.getnum(objID, "SENSOR", "scale." .. tostring(ii)))
      local mprecision = CCC.getnum(objID, "SENSOR", "precision." .. tostring(ii))
      local mvalue = CCC.getnum(objID, "SENSOR", "measure." .. tostring(ii))
      act = CCC.getnum(objID, "SENSOR", "active." .. tostring(ii))
      --print ("mesure(i, act, type, scale, precision, value)", ii, act, mtype,mscale,mprecision,mvalue)
      if act == 1 then
        if mtype == "Temperature" then
          temp = cccwrp.measureAdjScale (mvalue, mprecision, true)
        
        elseif mtype == "Humidity" then
          hum = cccwrp.measureAdjScale (mvalue, mprecision)
        end
        ccclog.log(UID, mtype, mscale, mprecision, mvalue) -- Logging
      end
      ii = ii +1
    until( act == 0 )
    
    if temp == -1 or hum == -1 then return end -- missing param
    if cccwrp_wdList[i].f_setval ~= nil then
      cccwrp_wdList[i].f_setval(cccwrp_wdActiveLst[actIdx].desc, temp, hum) 
    end  
    
elseif devname == "SensT" then
    local temp = -1
    local ii = 0
    repeat
      local mtype = CCC.measureType2str(CCC.getnum(objID, "SENSOR", "type." .. tostring(ii)))
      local mscale = CCC.measureScale2str(CCC.getnum(objID, "SENSOR", "scale." .. tostring(ii)))
      local mprecision = CCC.getnum(objID, "SENSOR", "precision." .. tostring(ii))
      local mvalue = CCC.getnum(objID, "SENSOR", "measure." .. tostring(ii))
      act = CCC.getnum(objID, "SENSOR", "active." .. tostring(ii))
      --print ("mesure(i, act, type, scale, precision, value)", ii, act, mtype,mscale,mprecision,mvalue)
      if act == 1 then
        if mtype == "Temperature" then
          temp = cccwrp.measureAdjScale (mvalue, mprecision, true)
        end
        ccclog.log(UID, mtype, mscale, mprecision, mvalue) -- Logging
      end
      ii = ii +1
    until( act == 0 )
    
    if temp == -1 then return end -- missing param
    
    if cccwrp_wdList[i].f_setval ~= nil then
      cccwrp_wdList[i].f_setval(cccwrp_wdActiveLst[actIdx].desc, temp) 
    end  
        
  end
  
end

-- reload active objects (CCC active objects)
function cccwrp.reloadActiveObj ()
  cccwrp_restoreCfg()
  
  -- reload Auth list Dynamic)
  for i=1, #cccwrp_wdActiveLst do
    local UID = cccwrp_wdActiveLst[i].UID
    if UID ~= nil then
      CCC.setnum (0, "WIRELESSNET", "authListAdd",UID) -- add to Auth list
    end
  end
  
  for i=1, CCC.getMaxIdx() do
    local UID = CCC.getnum(i, "BASE", "uniqueID")
    if CCC.isJoined(i) == true then
      local actIdx = cccwrp_widgetAct_getIndex_UID(UID)
      if actIdx ~= nil then
        if actIdx > 0 then
          cccwrp_wdActiveLst[actIdx].active = false   -- force register always
          cccwrp.newObj (i, true)     -- try to add to available widgets
        end
      end
    end
  end
end

-- remove CCC object from UID 
function cccwrp.CCCremoveObj (UID)
    local oidx = CCC.getObjID(UID)
    if oidx >= 0 then
      -- remove CCC instance
      CCC.removeObj(oidx)
    end    
    
    CCC.setnum (0, "WIRELESSNET", "authListDel",UID)
    
    -- remove from widget realtion list and all parents
    local widxI = cccwrp_widgetAct_getIndex_UID(UID)
    if widxI ~= nil then
      if widxI > 0 then
        print ("widxI", widxI)
        for i=1, #cccwrp_wdList do
          if cccwrp_wdList[i].f_unreg ~= nil then
            cccwrp_wdList[i].f_unreg (UID, cccwrp_wdActiveLst[widxI].desc)
            if cccwrp_wdList[i].f_store ~= nil then
              cccwrp_wdList[i].f_store()
            end
          end
        end
        table.remove (cccwrp_wdActiveLst, widxI)
        cccwrp_storeCfg()
      end
    end
  end
  
  -- Remote Switch setting
  function cccwrp.set_switch (UID, val)
    print ("cccwrp.set_switch (UID, val)", UID, val)
    local idx = CCC.getObjID(UID)
    if idx < 0 then return end
    CCC.setnum(idx,"SWITCH", "switchCmd", val)
  end
  
