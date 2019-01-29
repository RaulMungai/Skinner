function CCCobjcreation (UID, swVer)

	objID = CCC.addObj(UID, "JOIN,WIRELESSNET,PLATFORM,TIME,MOVER,RCONSOLE,EI,EVENTS,OPEN,DEBUG,OPENCOM", 1)	-- Obj creation
	if objID == nil then
		return 0
	end
	if objID < 0 then
		return 0
	end

	-- Set object property
	-- base
	if CCC.setstr(0, "BASE", "type", "G", true) == 0 then return 0 end
	if CCC.setnum(0, "BASE", "permitJoin", 1, true) == 0 then return 0 end
	if CCC.setnum(0, "BASE", "replyAuto", 0, true) == 0 then return 0 end

	-- reporting
	if CCC.setnum(0, "BASE", "meetingTime", 300, true) == 0 then return 0 end
	if CCC.setnum(0, "BASE", "meetingPeriod", 10, true) == 0 then return 0 end
	if CCC.setnums(0, "BASE", "wakeUpTime", -1, true) == 0 then return 0 end

	-- deep offLine
	if CCC.setnum(0, "BASE", "deepOLtime", 1000, true) == 0 then return 0 end
	if CCC.setnum(0, "BASE", "deepOLrescanTime", 3000, true) == 0 then return 0 end
	if CCC.setnum(0, "BASE", "deepOLmaxMul", 0, true) == 0 then return 0 end

	-- Platform
	if CCC.setstr(0, "PLATFORM", "mediaType", "LORA", true) == 0 then return 0 end
	if CCC.setnum(0, "PLATFORM", "SwVer_App", swVer, true) == 0 then return 0 end
	if CCC.setstr(0, "PLATFORM", "manufacturer", "Cedac Software", true) == 0 then return 0 end
	if CCC.setstr(0, "PLATFORM", "prodType", "Bridge", true) == 0 then return 0 end
	if CCC.setstr(0, "PLATFORM", "HwType", "2394", true) == 0 then return 0 end
	if CCC.setstr(0, "PLATFORM", "HwRev", "0102", true) == 0 then return 0 end
	if CCC.setnum(0, "PLATFORM", "powerType", 2, true) == 0 then return 0 end

	-- Wirelessnet
--	if CCC.setnums(0, "WIRELESSNET", "antennaGain", -2, true) == 0 then return 0 end
	if CCC.setnum(0, "WIRELESSNET", "bpsMin", 4800, true) == 0 then return 0 end
	if CCC.setnum(0, "WIRELESSNET", "bpsMax", 19200, true) == 0 then return 0 end
	if CCC.setstr(0, "WIRELESSNET", "zone", "SC10", true) == 0 then return 0 end

	-- Open com
	-- 	if CCC.setnum(0, "OPENCOM", "timeout", 150, true) == 0 then return 0 end	  
	-- Set Bridge address
	if CCC.setnum(0, "BASE", "bridgeAdd", UID, true) == 0 then return 0 end
	return 1			
end
