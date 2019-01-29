
-------------------------------------------------------------------
---------------------------  window:WiFi  -------------------------
-------------------------------------------------------------------
--[[
  WiFi management
  
    win_wifi.scan ()                -- rescan network
    win_wifi.show ()                -- Show
    win_wifi.hide ()                -- Hide
    win_wifi.pos (x,y)              -- Position set

  internals:
    win_wifi.help ()                -- display help text
    
  date: 11/10/2018 
  by: Raul Mungai
--]]

  
-- Load artworks
----------------
css.load_btn_img ("\\buttons\\refresh.png",    "refresh")
css.load_btn_img ("\\buttons\\wifi.png",       "wifi") 

-- top bar icons
css.load_btn_img ("\\buttons\\settings.png",  "settings") 
css.load_btn_img ("\\buttons\\back.png",  "back") 

--Wifi level icons
css.load_img ("\\wifi\\mwifi_a1.png", "wifi_a1", "icon")
css.load_img ("\\wifi\\mwifi_a2.png", "wifi_a2", "icon")
css.load_img ("\\wifi\\mwifi_a3.png", "wifi_a3", "icon")
css.load_img ("\\wifi\\mwifi_a4.png", "wifi_a4", "icon")
css.load_img ("\\wifi\\mwifi_a5.png", "wifi_a5", "icon")
css.load_img ("\\wifi\\mwifi_a5.png", "wifi_a6", "icon")

css.load_img ("\\icons\\mark.png",    "mark", "icon")
css.load_img ("\\icons\\sdelete.png", "noconn", "icon")
css.load_img ("\\icons\\progress.png", "progress", "icon")
 
-- Global Object
win_wifi = {}

  local winname = "winWiFi"     -- window name
  local numNetDisc = 0          -- number of escovered networks
  local currNet = ""            -- current network name
  local maxNetItems = 7         -- max network items
  local htxt = 24
  local tspace = 3
  local leftSpace = 40
  local rightSpace = 10
  local yStartList = 30
  local usrPasskey = ""
  local usrSSID = ""
    
  local function win_wifi_get_levelIcon (RSSI)
    if RSSI > -50 then
      return "wifi_a6"
    elseif RSSI > -60 then
      return "wifi_a5"
    elseif RSSI > -70 then
      return "wifi_a4"
    elseif RSSI > -80 then
      return "wifi_a3"
    elseif RSSI > -90 then
      return "wifi_a2"
    else
      return "wifi_a1"
    end
  end
  
  -- Clean the network list
  local function win_wifi_netListClr()
    for i=1,maxNetItems do
      local lname = "$wifiN" .. tostring(i)
      local iname = "$wifiNi" .. tostring(i)
      
      sknIbtn.text (lname, "")
      sknIbtn.hide (lname)
      sknImg.hide(iname)
    end
  end

  -- assign network list item
  local function win_wifi_netList(item, SSID, RSSI)
    if item > maxNetItems then return end
    
    local lname = "$wifiN" .. tostring(item)
    local iname = "$wifiNi" .. tostring(item)
    
    sknIbtn.text (lname, SSID)
    sknIbtn.show (lname)
    sknIbtn.auxStr (lname, SSID)
    
    sknImg.image(iname, "icon",  win_wifi_get_levelIcon(RSSI))
    sknImg.show(iname)    
  end
  
  
  -- execute the networkk rescan
  function win_wifi.scan ()
    hourglass.show ()
    local nets = wifi.wlanScan ()
    win_wifi_netListClr()
   
    --print ("Found " .. tostring(#nets) .. " networks\r\n")
    
    local nnum = #nets
    local skipitem = false
    local cn = 1
    for i=1, nnum do
      skipitem = false
      --print("Wifi:", i, nets[i]["SSID"], nets[i]["RSSI"])      
      if nnum > maxNetItems then
        -- strip low level network (list too big)
        if nets[i]["RSSI"] < -80 then
          skipitem = true
        end
      end
      
      if skipitem == false then    
        win_wifi_netList(cn, nets[i]["SSID"], nets[i]["RSSI"])
        --print("Wifi Reg:", cn, nets[i]["SSID"], nets[i]["RSSI"])
        numNetDisc = cn
        cn = cn + 1
        --print ("  Sec  "..  nets[i]["Sec"])
      end
    end
    hourglass.hide ()
  end
  
  -- set marker position 
  local function wifi_markerPos_set (idx)
    if idx > maxNetItems then return end
    
  local iX, iY = sknColl.imgSize("icon", "mark")
    sknImg.pos("$wifiNsel", (leftSpace - iX) // 2, (( htxt + tspace) * (idx-1)) + yStartList)
    sknImg.show("$wifiNsel")
  end

  -- refresh the list and selection
  local function wifi_refresh_list ()
    for i=1,maxNetItems do
      if sknBtn.auxStr ("$wifiN" .. tostring(i)) == currNet then
        wifi_markerPos_set (i)
        sknImg.image("$wifiNsel", "icon",  "mark")
        return
      end
    end
  end
  
  -- select SSID list item
  local function win_wifi_setMark(SSID)
    for i=1,maxNetItems do
      if sknBtn.auxStr ("$wifiN" .. tostring(i)) == SSID then
        wifi_markerPos_set (i)

        --Apply changes
        sknImg.image("$wifiNsel", "icon",  "progress")
        hourglass.show () 
        if mqtt_module.joinToWiFi (SSID, usrPasskey) == 1 then
          sknImg.image("$wifiNsel", "icon",  "mark")
        else
          sknImg.image("$wifiNsel", "icon",  "noconn")
        end
        hourglass.hide ()
        currNet = SSID
        return
      end
    end
  end
  
  local function win_wifi_create ()
    winnameI = css.window_new (winname, false, "win_wifi.help")
    sknWin.bgcolor (winname, sknSys.getColor("gray"))
    
    -- add title and related buttons
    css.window_title_new (winnameI, sknColl.dictGetPhrase("WIN", 4))
    css.window_title_btnCfg (winnameI, 1, "back", "sknWin.showCaller")
    
    --Wifi List
    local ys = yStartList
    local iX, iY = sknColl.imgSize("icon", win_wifi_get_levelIcon(-60))
    local btnW = sknSys.screenXsize() - ((leftSpace + rightSpace + rightSpace) + iX)
    for i=1,maxNetItems do
      local lname = "$wifiN" .. tostring(i)
      local iname = "$wifiNi" .. tostring(i)
    
      css.button_txt_new (lname, winname, leftSpace, ys, btnW, htxt, "", "F24B", sknSys.getColor("blue"), sknSys.getColor("red")
        , "Left_Vert", sknSys.getColor("gray"), "win_wifi.selNet", false)
      
      sknBtn.auxStr (name, "")
      
      --align Rf level indicator
      local yi
      if iY < htxt then
        yi = ys + (htxt - iY) // 2
      else
        yi = ys - (htxt - iY) // 2
      end
      
      sknImg.create(iname, winname, btnW + leftSpace + 10, yi, iX, iY)
      sknImg.image(iname, "icon",  win_wifi_get_levelIcon(-100))
  
      ys = ys + htxt + tspace
    end
    
    sknImg.create("$wifiNsel", winname, 10, yi, 0, 0)
    sknImg.image("$wifiNsel", "icon",  "mark")

    -- buttons
    css.button_new ("wifiref", winname, 50, 210, "refresh", "win_wifi.scan", true)
    css.button_new ("wifiexit", winname, 382, 210, "back", "sknWin.showCaller", true)
  end

  -- wifi network selection
  function win_wifi.selNet (objname)
      print ("Event from:", sknIbtn.auxStr (objname))
      win_wifi_setMark(sknIbtn.auxStr (objname))
      
      -- apply WiFi settings
  end
  
  -- set Net credentials
  function win_wifi.credentials (SSID, passk)
    usrPasskey = passk
    usrSSID = SSID
  end

  -- execute the connect action (ret 1: success)
  function win_wifi.connect ()
    --[[
    if currNet == "" then
      win_wifi.scan ()          -- first scan operation
    end
    --]]
      
    wifi.networkup ()
    for i=0,20 do
      if wifi.netStat() == "IP_CONN" then        
        currNet = wifi.ssid ()
        -- upd list
        wifi_refresh_list()     -- refresh list
        return 1
      end
      os.sleep(1000)
    end  
    return 0
  end
  
  -- execute the recconect action
  function win_wifi.reconnect ()
    wifi.networkdown ()
    -- wait for down
    for i=0,20 do
      if wifi.netStat() == "DOWN" then     
        break
      end
      os.sleep(1000)
    end  
    return win_wifi.connect ()
  end
  
  function win_wifi.show ()
    sknWin.showRestorable (winname)
    if numNetDisc == 0 or currNet == "" then
      -- first discovery operations
      win_wifi.scan ()
      wifi_refresh_list ()
    end
  end

  function win_wifi.hide ()
    sknWin.hide (winname)
  end

  function win_wifi.pos (x,y)
    sknWin.pos (winname, x,y)
  end
  
  -- display help text
  function win_wifi.help (name)
    win_helper.help (4, name)
  end
  
win_wifi_create ()   -- Window creation
