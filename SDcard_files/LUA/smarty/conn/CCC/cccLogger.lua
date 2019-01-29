-------------------------------------------------------------------
---------------------------  CCC:logger  --------------------------
-------------------------------------------------------------------
--[[
  Log:
    ccclog.log(UID, mtype, mscale, mprecision, mvalue)   -- Log Device Data (single)
    
  Persistance:
    ccclog.storeCfg()    -- store configuration
    ccclog.restoreCfg()  -- restore configuration
     
  internals:
    
  date: 18/01/2019
  by: Raul Mungai
--]]

ccclog = {}

  local ccclog_log = {}         -- Log for all devices (VOLATILE)
  
  local fname = thema.getDir() .. "cfg\\wd_cccLog.log"

  -- store configuration
  function ccclog.storeCfg() 
    utils.table_save(ccclog_log, fname)
  end
 
  -- restore configuration
  function ccclog.restoreCfg()
    ccclog_log = utils.table_load(fname)
    if ccclog_log == nil then
      ccclog_log = {}
    end
  end  
  
  
  -- Log Device Data (single)
  function ccclog.log(UID, mtype, mscale, mprecision, mvalue)
    if appcfg_CCC_dat_logging == false then return end
    mtime = os.time()
    table.insert (ccclog_log,  {mtime=mtime, UID=UID, mtype=mtype, mscale=mscale, mprecision=mprecision, mvalue=mvalue})
  end
  
  -- display log
  function ccclog.dump(uniqueID, csv)
    local lastUID = 0
    local lastTime = 0
    if uniqueID == nil then
      uniqueID = 0
    end
    
    if csv == nil then
      csv = false
    end
    
    print ("CCC data log dump of " .. tostring(#ccclog_log) .. " elements")
    if cvs == true then
      print (" + CSV Format")
    end
    
    if uniqueID == 0 then
      print (" + UID = " .. tostring(uniqueID))
    end
    print ("\r\n\r\n")
    for i=1, #ccclog_log do
      local mtime=ccclog_log[i].mtime // 1000
      local UID=ccclog_log[i].UID
      local mtype=ccclog_log[i].mtype
      local mscale=ccclog_log[i].mscale
      local mprecision=ccclog_log[i].mprecision
      local mvalue=ccclog_log[i].mvalue
      local dst
      
      local fildID = false
      if uniqueID ~= 0 then
        if uniqueID ~= UID then
          fildID = true
        end
      end
      
      if fildID == false then
        local vv
        if mtype == "Temperature" then
            vv = cccwrp.measureAdjScale (mvalue, mprecision, true)
        else
            vv = cccwrp.measureAdjScale (mvalue, mprecision)
        end
        
        if csv == false then
          -- Uman readable
          if lastTime ~= mtime then
            dst = "T: " .. tostring(mtime) .. "\r\n"
            lastTime = mtime
          else
            dst = ""
          end
          
          if lastUID ~= UID then
            dst = dst .. "  UID:" .. tostring(UID) .. "\t"
            lastUID = UID
          else
            dst = dst .. "\t\t"
          end

          dst = dst .. mtype .. ": " .. tostring(vv)
        else
          -- CSV
          dst = tostring(mtime) .. ";" .. UID .. ";" .. mtype .. ";" .. tostring(vv)
        end
        print (dst)
      end
    end
    print ("\r\n")
  end
  