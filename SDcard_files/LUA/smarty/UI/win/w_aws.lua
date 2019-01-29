-------------------------------------------------------------------
---------------------------  window:AWS  --------------------------
-------------------------------------------------------------------
--[[
  AWS window
  
    win_aws.show ()            -- Show
    win_aws.hide ()            -- Hide
    win_aws.pos (x,y)          -- Position set
  
  internals:
    win_aws.help ()            -- display help text
    
  date: 19/10/2018 
  by: Raul Mungai
--]]


-- Load artworks
----------------
css.load_btn_img ("\\buttons\\aws.png",    "aws")   -- app icon

-- top bar icons
css.load_btn_img ("\\buttons\\settings.png",  "settings") 
css.load_btn_img ("\\buttons\\back.png",  "back") 

css.load_btn_img ("\\buttons\\publish.png",   "publish")
css.load_btn_img ("\\buttons\\subscribe.png", "subscribe")

-- Global Object
win_aws = {}

  local winname = "winaws"
  
  local function win_aws_create ()

    winnameI = css.window_new (winname, false, "win_aws.help")
    
    -- add title and related buttons
    css.window_title_new (winnameI, sknColl.dictGetPhrase("WIN", 3))

    -- buttons
    css.button_new ("awsPub", winname, 50, 50, "publish", "win_aws.publish", true)
    css.button_new ("awsSus", winname, 110, 50, "subscribe", "win_aws.subscribe", true)
  end

  function win_aws.show ()
    sknWin.showRestorable (winname)
  end

  function win_aws.hide ()
    sknWin.hide (winname)
  end

  function win_aws.pos (x,y)
    sknWin.pos (winname, x,y)
  end

  -- display help text
  function win_aws.help (name)
    win_helper.help (5, name)
  end
  

  -- test code  --
  
  -- Test Publish
  function win_aws.publish ()
    --mqtt.publish ("$aws/things/" .. appcfg_MQTT_objID .. "/shadow/update", "{\"state\":{\"desired\":{\"message\":\"Time now: " .. tostring(os.time()) .. "\"}}}")
    
    mqtt.publish ("$aws/things/" .. appcfg_MQTT_objID .. "/shadow/update", "{\"state\":{\"desired\":{\"temp\":\"21,4\",\"hum\":\"58\" }}}")
    
  end
  
  -- Test suscribe
  function win_aws.subscribe ()
    mqtt.suscribe ("$aws/things/" .. appcfg_MQTT_objID .. "/shadow/update/accepted", "win_aws_subscrCb")
  end
  
  -- subscribe callaback
  function win_aws_subscrCb (data)
    print ("Subscribe-cb:", data)
  end
  
  
win_aws_create ()   -- Window creation
