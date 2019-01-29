    -- Select Virtual device
   -- nut.setVdev ("ser", 1, 115200)
    
    --[[
    -- Wait for USB connect
    for t=1, 4 do
      io.write ("*")
      os.sleep(1000)
    end
    --]]
  
-- Load specific application
-- dofile ("\\LUA\\smarty\\smarty.lua")

-- MQTT


-- Subscribe callback
function subscrCb (data)
  
  print ("Subscribe-cb:", data)
  
end


print ("Initialization ...")
wifi.phycfg ("WiFie", "COM1")
mqtt.init (4096, 4096, 10000)

--[[
--Store certificate
print ("registration:2ac3ffbdfa-certificate.pem.crt")
wifi.tls_cert_store ("2ac3ffbdfa-pem.crt", "2ac3ffbdfa-certificate.pem.crt")
print ("registration:2ac3ffbdfa-private.pem.key")
wifi.tls_cert_store ("2ac3ffbdfa-pem.key", "2ac3ffbdfa-private.pem.key")
print ("registration:x509.cer")
wifi.tls_cert_store ("x509.cer", "x509.cer")
--]]


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

--print ("Scan execute")
print ("Scan = ", wifi.wlanScan ())

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
    --print ("try: ping(cedac.com)")
    --print (wifi.ping("cedac.com", 3))    
    
    print ("TEST COMPLETE.")
    
    --mqtt.publish ("$aws/things/102GW-1/update", "{\"state\":{\"desired\":{\"message\":\"Time now: 171717\"}}}")
    
    --mqtt.suscribe ("$aws/things/102GW-1/update/accepted")
    mqtt.suscribe ("$aws/things/102GW-1/shadow/update/accepted", "subscrCb")
    --[[
    mqtt.bg()
    os.sleep(50)
    mqtt.bg()
    os.sleep(50)
    mqtt.bg()
    --]]
    
    for i=0,3 do
      --print ("Try publish...")
      mqtt.publish ("$aws/things/102GW-1/shadow/update", "{\"state\":{\"desired\":{\"message\":\"Time now: 171717\"}}}")
      os.sleep(10000)
      --[[
      for ii=0, 20 do
        mqtt.bg()
        os.sleep(100)
      end
      --]]
    end
    
    print ("END publish.")
    print ("STOP ALL")
    
    if mqtt.unsuscribe ("$aws/things/102GW-1/shadow/update/accepted") == 1 then
      print("mqtt.unsuscribe: OK") 
      if mqtt.disconnect () == 1 then
        print("mqtt.disconnect: OK")
        if mqtt.netdisconnect () == 0 then
          print("NET disconnect: ERROR") 
        else
          print("MQTT down") 
        end
      else
        print ("netdisconnect: ERROR")
      end
    else
      print ("unsuscribe: ERROR")
    end
    
    --mqtt.stop ()

    
  else
    print ("CONNECT: ERROR")
  end
else
  print ("NET CONNECT: ERROR")
end



os.sleep(1000)
print ("try: netConnect(): 2nd ROUND")
if mqtt.netconnect ("a2e0fhddoenifh.iot.us-east-2.amazonaws.com", 8883) == 1 then
  print ("NET CONNECT: Success")
  
  print ("try: connect()")
  if mqtt.connect ("102GW-1") == 1 then
    print ("CONNECT: Success")
    mqtt.suscribe ("$aws/things/102GW-1/shadow/update/accepted")
    
    for i=0,4 do
      --print ("Try publish...")
      mqtt.publish ("$aws/things/102GW-1/shadow/update", "{\"state\":{\"desired\":{\"message\":\"Time now: 222222\"}}}")
      os.sleep(10000)
    end
    
    if mqtt.unsuscribe ("$aws/things/102GW-1/shadow/update/accepted") == 1 then
      if mqtt.disconnect () == 1 then
        if mqtt.netdisconnect () == 0 then
          print("NET disconnect: ERROR") 
        else
          print("MQTT down") 
        end
      end
    end
    --mqtt.stop ()
  end
end






