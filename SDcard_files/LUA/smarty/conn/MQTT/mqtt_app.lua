-------------------------------------------------------------------
---------------------------  MQTT:application  --------------------------------
-------------------------------------------------------------------
--[[
  MQTT comunication module
  
    mqtt_module.XXX ()                         -- XXX


  date: 17/10/2018 
  by: Raul Mungai
--]]

-- Global Object
mqtt_app = {}  


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
  
  

