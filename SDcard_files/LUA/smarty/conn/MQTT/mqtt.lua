-------------------------------------------------------------------
---------------------------  MQTT  --------------------------------
-------------------------------------------------------------------
--[[
  MQTT comunication module
  
    mqtt_module.init ()                         -- init MQTT env
    mqtt_module.cert_install ()                 -- certificate installation (save on WiFi device)
    mqtt_module.joinToWiFi (netWiFi, passKey)   -- Join to WiFi network
    
  AWS
    function mqtt_module.AWSconnect ()          -- connect to AWS (default paramenters)
    function mqtt_module.AWSunconnect ()        -- connect to AWS (after unsuscribe operations)

  date: 16/10/2018 
  by: Raul Mungai
--]]

-- Global Object
mqtt_module = {}  

  -- AWS settings
  AWSurl = "a2e0fhddoenifh.iot.us-east-2.amazonaws.com"
  AWSsecurePort = 8883
  AWSdeviceID = appcfg_MQTT_objID

  -- init MQTT env
  function mqtt_module.init ()
    wifi.phycfg ("WiFie", "COM1")
    mqtt.init (4096, 4096, 10000)
    
    -- set certificate path
    wifi.tls_cacert ("x509.cer")
    wifi.tls_clicert ("2ac3ffbdfa-pem.crt")
    wifi.tls_clikey ("2ac3ffbdfa-pem.key")
  end
  
  --certificate installation 
  function mqtt_module.cert_install ()
    wifi.tls_cert_store ("2ac3ffbdfa-pem.crt", "\\LUA\\smarty\\conn\\MQTT\\2ac3ffbdfa-certificate.pem.crt")
    wifi.tls_cert_store ("2ac3ffbdfa-pem.key", "\\LUA\\smarty\\conn\\MQTT\\2ac3ffbdfa-private.pem.key")
    wifi.tls_cert_store ("x509.cer", "\\LUA\\smarty\\conn\\MQTT\\x509.cer")
  end
  
  -- Join to WiFi network
  function mqtt_module.joinToWiFi (netWiFi, passKey)
    -- Join to WiFi AP
    wifi.passkey (passKey)
    wifi.ssid (netWiFi)
    return win_wifi.reconnect ()
  end
  
  -- connect to AWS
  function mqtt_module.AWSconnect ()
    --print ("try: netConnect()")
    if mqtt.netconnect (AWSurl, AWSsecurePort) == 0 then
      --print ("NET CONNECT: ERROR")
      return 0  
    end
    
    --print ("NET CONNECT: Success")
    if mqtt.connect (AWSdeviceID) == 1 then
      --print ("CONNECT: Success")
      return 1
    else
      --print ("CONNECT: ERROR")
      return 0
    end
  end

  -- connect to AWS (after unsuscribe operations)
  function mqtt_module.AWSunconnect ()
    if mqtt.disconnect () == 1 then
      --print("mqtt.disconnect: OK")
      if mqtt.netdisconnect () == 0 then
        --print("NET disconnect: ERROR") 
        return 0
      else
        --print("MQTT down") 
        return 0
      end
    else
      --print ("netdisconnect: ERROR")
      return 0
    end
  end
    
  
  
  

