-- MQTT module


-- Subscribe callback
function subscrCb (data)
  
  print ("Subscribe-cb:", data)
  
end


print ("MQTT Initialization ...")
wifi.phycfg ("WiFie", "COM1")
mqtt.init (4096, 4096, 10000)

--[[
--Store certificate
print ("registration:2ac3ffbdfa-certificate.pem.crt")
wifi.tls_cert_store ("2ac3ffbdfa-pem.crt", "\\LUA\\smarty\\conn\\MQTT\\2ac3ffbdfa-certificate.pem.crt")
print ("registration:2ac3ffbdfa-private.pem.key")
wifi.tls_cert_store ("2ac3ffbdfa-pem.key", "\\LUA\\smarty\\conn\\MQTT\\2ac3ffbdfa-private.pem.key")
print ("registration:x509.cer")
wifi.tls_cert_store ("x509.cer", "\\LUA\\smarty\\conn\\MQTT\\x509.cer")
--]]

-- Koin to WiFi AP
wifi.passkey ("y4kfwkcwf5jxy66")
wifi.ssid ("Vodafone-23614068")
wifi.networkup ()


--  [[
wifi.tls_cacert ("x509.cer")
wifi.tls_clicert ("2ac3ffbdfa-pem.crt")
wifi.tls_clikey ("2ac3ffbdfa-pem.key")
--  ]]

--[[
print ("cacert", wifi.tls_cacert ())
print ("clicert", wifi.tls_clicert ())
print ("clikey", wifi.tls_clikey ())

print ("END cert reg")
--]]

nets = wifi.wlanScan ()

print ("\r\nWlan Scan result:\r\n")

print ("Found " .. tostring(#nets) .. " networks\r\n")
for i=1, 22 do
  print (i)
  if nets[i] ~= nil then
    print ("  RSSI ".. nets[i]["RSSI"])
    print ("  Sec  "..  nets[i]["Sec"])
    print ("  SSID "..  nets[i]["SSID"])
  else
    break   -- table end
  end
end
print ("FINE TABELLA")



--[[
print ("Wait WiFi connection...")
while (true)
do
  if wifi.netStat ~= "IP_CONN" then
    io.write (".")
    os.sleep (2000)
  else
    break
  end
end
--]]

print ("WiFi CONNECTED")

--print ("RSSI get execute")
--print ("RSSI = ", wifi.rssi ())

-- print ("INFO:", wifi.info())
--[[
print ("_")
print ("Net MAC:", wifi.mac())
print ("Net DNS:", wifi.netDns())
print ("Net Gw :", wifi.netGw())
print ("Net IP :", wifi.netIp())
--print ("Net Mask :", wifi.netMask())
print ("Net Stat :", wifi.netStat())
print ("Net SSID :", wifi.netSSID())
--]]

os.sleep(1000)
print ("try: netConnect()")
if mqtt.netconnect ("a2e0fhddoenifh.iot.us-east-2.amazonaws.com", 8883) == 1 then
  print ("NET CONNECT: Success")
  
  print ("try: connect()")
  if mqtt.connect ("102GW-1") == 1 then
    print ("CONNECT: Success")
    
    --mqtt.suscribe ("$aws/things/102GW-1/update/accepted")
    mqtt.suscribe ("$aws/things/102GW-1/shadow/update/accepted", "subscrCb")
    
    for i=0,3 do
      mqtt.publish ("$aws/things/102GW-1/shadow/update", "{\"state\":{\"desired\":{\"message\":\"Time now: IMY\"}}}")
      os.sleep(10000)
    end
  else
    print ("CONNECT: ERROR")
  end
else
  print ("NET CONNECT: ERROR")
end




--print ("RSSI get execute")
--print ("RSSI = ", wifi.rssi ())

-- print ("INFO:", wifi.info())
--[[
print ("_")
print ("Net MAC:", wifi.mac())
print ("Net DNS:", wifi.netDns())
print ("Net Gw :", wifi.netGw())
print ("Net IP :", wifi.netIp())
--print ("Net Mask :", wifi.netMask())
print ("Net Stat :", wifi.netStat())
print ("Net SSID :", wifi.netSSID())
--]]

os.sleep(1000)
print ("try: netConnect()")
if mqtt.netconnect ("a2e0fhddoenifh.iot.us-east-2.amazonaws.com", 8883) == 1 then
  print ("NET CONNECT: Success")
  
  print ("try: connect()")
  if mqtt.connect ("102GW-1") == 1 then
    print ("CONNECT: Success")
    
    --mqtt.suscribe ("$aws/things/102GW-1/update/accepted")
    mqtt.suscribe ("$aws/things/102GW-1/shadow/update/accepted", "subscrCb")
    
    --[[
    for i=0,3 do
      mqtt.publish ("$aws/things/102GW-1/shadow/update", "{\"state\":{\"desired\":{\"message\":\"Time now: IMY\"}}}")
      os.sleep(10000)
    end
    --]]
  else
    print ("CONNECT: ERROR")
  end
else
  print ("NET CONNECT: ERROR")
end