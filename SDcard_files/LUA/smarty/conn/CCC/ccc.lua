
print ("CCC starting...")
dofile ("\\LUA\\smarty\\conn\\CCC\\newobj.lua")
dofile ("\\LUA\\smarty\\conn\\CCC\\ccccb.lua")
dofile ("\\LUA\\smarty\\conn\\CCC\\cccLogger.lua")

if CCC.start (888888, "G", FALSE, "\\") == 1 then
    print ("\r\nCCC ready.\r\n")

    --nut.cmdline("servSetNum CCC sys\\debugFS 1")  -- Display FS operations
    --nut.cmdline("servSetNum CCC sys\\debugLevel 0")  -- Display All log infos

    CCC.hostStat (true)
--    if wmbusamr.start ("mmc:\\", "bimeter", true) ~= 1 then
--        print ("\r\nErorr on WMBUS driver start.\r\n")
--    end
    CCC.setnum(0, "BASE", "permitJoin", 1)
    CCC.funct(0, "WIRELESSNET", "authListLoad")
    
    --CCC.setnum(0, "WIRELESSNET", "authListAdd", 5242880)
    nut.cmdline("servMethod WNETserv jauth\\showList") 
else
    print ("\r\nCCC starting ERROR.\r\n")
end

-- Hi level ping (wait for Ping reply)
function ping(objID)
  
  if CCC.funct (objID, "JOIN", "ping") == 0 then
  
    print (" UNSUPPORTED\r\n")
    return
  end
  print (" ... ")
  
end


