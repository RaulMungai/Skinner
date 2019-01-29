
-------------------------------------------------------------------
---------------------------  window:SETTINGS  ---------------------
-------------------------------------------------------------------
--[[
  Home window
  
    win_settings.show ()              -- Show
    win_settings.hide ()              -- Hide
    win_settings.pos (x,y)            -- Position set
    
  internals:
    win_settings.help ()              -- display help text
    
  date: 17/10/2018 
  by: Raul Mungai
--]]


-- Load artworks
----------------
-- top bar icons
css.load_btn_img ("\\buttons\\settings.png",  "settings") 
css.load_btn_img ("\\buttons\\back.png",  "back") 
  
  
-- Global Object
win_settings = {}

  local winname = "winSet"
  local winnameI = ""
  
  local function win_settings_create ()
    winnameI = css.window_new (winname, false, "win_settings.help")
    
    -- add title and related buttons
    css.window_title_new (winnameI, sknColl.dictGetPhrase("WIN", 1))
    css.window_title_btnCfg (winnameI, 1, "back", "sknWin.showCaller")

    local wx, wy = win_wintool.nextBtn_coords ()
    
    -- buttons
    if appcfg_MQTT_active == true then
      css.appButton_new ("wifi", winname, wx, wy, "WiFi", thema.win_color)  -- WiFi
      wx, wy = win_wintool.nextBtn_coords (wx, wy)
    end
    
    css.appButton_new ("devadd", winnameI, wx, wy, "Dev Add", thema.win_color)
    wx, wy = win_wintool.nextBtn_coords (wx, wy)    
  
    css.appButton_new ("devserv", winnameI, wx, wy, "Dev Service", thema.win_color)
    wx, wy = win_wintool.nextBtn_coords (wx, wy)    
  end

  function win_settings.show ()
    sknWin.showRestorable (winname)
  end

  function win_settings.hide ()
    sknWin.hide (winname)
  end

  function win_settings.pos (x,y)
    sknWin.pos (winname, x,y)
  end
  
  -- display help text
  function win_settings.help (name)
    win_helper.help (2, name)
  end  
  
win_settings_create ()   -- Window creation
