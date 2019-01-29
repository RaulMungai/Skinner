-- smarty Application 
---------------------

  
-- Config ALL
appcfg_MQTT_active = false     -- true=Enable MQTT layer
appcfg_MQTT_objID = "102GW-1"  -- object ID

appcfg_CCC_dat_logging = true  -- enable CCC logging data

-- Load User Interface
dofile ("\\LUA\\smarty\\UI\\UI.lua")
--print ("DISABILITATA LA UI")

-- Config and start CCC
dofile ("\\LUA\\smarty\\conn\\CCC\\ccc.lua")

-- Table testing
-- dofile ("ttt.lua")

-- nut.cmdline("servSetNum CCC sys\\debugLevel 0")
-- nut.cmdline("servSetNum CCC sys\\debugMover 1")

--os.sleep (3000)       -- temporary wait (Ram disk is too fast)
win_splash.destroy()    -- close splash screen

-- Show Home window
win_home.show ()

-- display general help
-- win_popup.text (sknColl.dictGetPhrase("HELP", 10), sknColl.dictGetPhrase("HELP", 11))

-- Start network interface
if appcfg_MQTT_active == true then
  hourglass.show ()
  mqtt_module.init ()

  -- config WiFi (temporary)
  --[[
  win_wifi.credentials ("Vodafone-23614068", "y4kfwkcwf5jxy66")
  wifi.passkey ("y4kfwkcwf5jxy66")
  wifi.ssid ("Vodafone-23614068")
  --]]
  
  win_wifi.credentials ("CedacHw-Dev", "WorkStreetPswHw18")
  wifi.passkey ("WorkStreetPswHw18")
  wifi.ssid ("CedacHw-Dev")
  

  if win_wifi.connect () ~= 1 then
    print ("WIFI NON CONNESSA, apro il centro connessioni ?")
  end
  hourglass.hide ()

  -- Open AWS connection
  win_home.AWSconn ("?")
  if mqtt_module.AWSconnect () ==  1 then
    win_home.AWSconn ("C")
  else
    win_home.AWSconn ("N")
  end
end


-- win_home.demo ()      -- Demo data

-- dofile ("\\LUA\\app\\sql1.lua")

-- dofile ("\\LUA\\app\\order.lua")

-- test keyboard

--[[
varRAUL = "ABCD"

function closeKey ()
  print ("Exit value=[" .. varRAUL .. "]")
end

win_kbrd.set ("alpha_ita", "varRAUL", 13, "winHome", "closeKey")   -- use specific keyboard

print ("ASPETTO")
--]]

--[[
-- prova ballgraph

ballGraph.create ("bg", "homeBgimage", 5, 30, 400, 220)
ballGraph.show ("bg")

os.sleep(10000)
print ("VAI PURE")
--]]

-- Dempo list
--[[
function lstOK()
  print ("List confirm:")
  local si = o_list.selectedItem()
  print ("item desc:", si.desc)
  print ("item val:", si.val)
  print ("item icon:", si.icon)
end

function lstCanc()
  print ("List Cancel")
end
--]]

--[[
-- Image

  
o_list.init()
o_list.options("icon", false, true, "BG")
o_list.show("PROVA LIST IMAGES", lstOK, lstCanc, 150, true)
--]]

--[[
-- text
o_list.init()
o_list.addItem("", "uno", "", 0, nil, 0)
o_list.addItem("", "due", "", 0, nil, 0)
o_list.addItem("", "tre", "", 0, nil, 0)
o_list.addItem("", "quatro", "", 0, nil, 0)
o_list.addItem("", "cinque", "", 0, nil, 0)
o_list.addItem("", "6", "", 0, nil, 0)
o_list.addItem("", "7 ggfff", "", 0, nil, 0)
o_list.addItem("", "8 ggffff", "", 0, nil, 0)
o_list.addItem("", "9 ffffff", "", 0, nil, 0)
o_list.addItem("", "10 ffff", "", 0, nil, 0)
o_list.addItem("", "11 ffreee", "", 0, nil, 0)
o_list.addItem("", "12ggggg", "", 0, nil, 0)
o_list.addItem("", "13fffff", "", 0, nil, 0)
o_list.addItem("", "14xxxx", "", 0, nil, 0)
o_list.options("txt", false, false)
o_list.show("PROVA LIST TXT", lstOK, lstCanc)
--]]

--[[
-- icon (buttons)
o_list.init()
o_list.options("icon",true, false, "btn")
o_list.show("PROVA LIST ICONS-def", lstOK, lstCanc, 32, true)
--]]

--[[
-- Colors
o_list.init()
o_list.addItem("", "", "", 0, nil, 555555)
o_list.options("color", false, false)
o_list.show("PROVA LIST COLORS-def", lstOK, lstCanc, 22, true)
--]]

--[[
-- Windows
o_list.init()
o_list.options("win", true, false, "btn")
o_list.show("PROVA LIST WINDOWS", lstOK, lstCanc, nil, true)
--]]

cccwrp.reloadActiveObj()    -- reload CCC object into UI

os.sleep (4000)

