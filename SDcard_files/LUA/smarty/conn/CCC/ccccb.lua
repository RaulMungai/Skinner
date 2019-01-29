dispInfo = 1


-- Display verbose informations
function printInfo (msg, idx)
  if dispInfo == 1 then
    if idx == nil then
      print (msg .. ", time=" .. tostring(os.time()))
    else
      print (msg .. "  idx=" .. tostring(idx) .. ", time=" .. tostring(os.time()))
    end
  end
end

-- Display measure from Sensor or Meter (meter_sens == 1 : Meter, else Sensor)
function dispMeasure (objID, meter_sens)

	if meter_sens == 1 then
		cls = "METER"
	else
		cls = "SENSOR"
	end
	
	-- Get measure informations
	local active = 1
	local idx = 0
	while active == 1 do
		local prop = "active." .. tostring(idx)
		local active = CCC.getnum(objID, cls, prop)
		-- print ("  cb>", objID, cls, prop, " active=", active)
		
		if active == nil then break end
		
		if active == 1 then
			-- Extract all item properties
			prop = "type." .. tostring(idx)
      local ptype = CCC.getnum(objID, cls, prop)

			prop = "scale." .. tostring(idx)
			local scale = CCC.getnum(objID, cls, prop)

			prop = "precision." .. tostring(idx)
			local precision = CCC.getnum(objID, cls, prop)

			prop = "measure." .. tostring(idx)
			local measure = CCC.getnum(objID, cls, prop)
			
			local strValue = CCC.measure2str(ptype, scale, precision, measure, 1, ",")
			print ("measure:" .. tostring(idx) .. " = " .. strValue)
		end
		idx = idx + 1
	end
	return
end

-- Display Object ID infos
function cccObjDIsp (UID)

	if dispInfo == 1 then
		print ("obj:" .. UID .. " - ")
	end

end

-- Diplay Battery infos
function cccDispBattery (UID)

	print ("BATTERY")
	battPerc = CCC.getnums(UID, "BATTERY", "batteryLevel")
	battLife_h = CCC.getnums(UID, "BATTERY", "autonomy")
	battLow = CCC.getnums(UID, "BATTERY", "batteryLow")

	if battPerc >= 0 then
		print ("level=" .. battPerc .. " %")
	end

	if battLife_h >= 0 then
		print ("autonomy=" .. battLife_h .. " hrs")
	end

	if battLow >= 0 then
		if battLow == 1 then
			print ("batt Low")
		end
	end

	return
end

-- Extra callback
function cccCallbackExtra (ID, classname, resultMsg, msg)
  
  print ("extra cb: ID=" .. tostring(ID) .. " class=" .. classname .. " result=" .. resultMsg .. " msg=" .. msg)
  
end


-- CCC callback
function cccCallback (UID, class, msg)
	
  if class == "DEBUG" then
    local dmsg = CCC.getstr (UID, "DEBUG", "msg")
    if dmsg ~= nil then
        print ("Debug from " .. tostring(UID) .. " msg=" .. dmsg)
    end
    return
  end
  
  if msg == "PINGREPLY" then
	  
    testDeviceSignal(UID)       -- try to update testing window
    
    -- Print ping reply
    RSSI = CCC.getnums(UID, "BASE", "RSSI")
    LQI = CCC.getnums(UID, "BASE", "LQI")
    print ("\r\n ping Reply from:", UID .. " LQI=" .. LQI .. "  RSSI=" .. RSSI .. "\r\n");
    return
  end
  
	if msg == "OBJNEW" then
    if cccwrp.newObj ~= nil then
      cccwrp.newObj (UID)   -- send to CCC wrapper
    end
		if dispInfo == 1 then
			print ("NEW object :", UID)
			return
		end
    
	elseif msg == "REPORT" then
	
		if class == "SENSOR" then
      cccwrp.setvalue(UID)
			printInfo ("Data from SENSOR", UID)
			dispMeasure (UID, 0)
			return
		elseif class == "METER" then
      cccwrp.setvalue(UID)
			printInfo ("Data from METER", UID)
			dispMeasure (UID, 1)
			return
		elseif class == "BATTERY" then
			cccDispBattery (UID)
		elseif class == "SWITCH" then   
      cccwrp.setvalue(UID)
			return
		end
	elseif msg == "ONLINE" then
		cccObjDIsp (UID)
		printInfo ("ONLINE")
		return
	elseif msg == "OFFLINE" then
		cccObjDIsp (UID)
		printInfo ("OFFLINE")
		return
	elseif msg == "SLEEPING" then
		cccObjDIsp (UID)
		printInfo ("SLEEPING")
		return
	elseif msg == "APPROACH" then
		cccObjDIsp (UID)
		printInfo ("APPROACH")
		return
	elseif msg == "DEPARTURE" then
		cccObjDIsp (UID)
		printInfo ("DEPARTURE")
		return
	elseif msg == "JOINCOMPLETE" then
		cccObjDIsp (UID)
		printInfo ("JOIN COMPLETE")
		return
  elseif msg == "JOINABORT" or msg == "JOINDELAY" then
    if joinAbort_event ~= nil then
      joinAbort_event (UID)
    end
		printInfo ("JOIN ABORT or DELAYED")
		return
	else
		if dispInfo == 1 then
			print ("CCC callback: ", UID, class, msg)
			return
		end
	end
	
	return
end
