-------------------------------------------------------------------
---------------------------  window:APPs  -------------------------
-------------------------------------------------------------------
--[[
  Apps window
  
    win_apps.show ()            -- Show
    win_apps.hide ()            -- Hide
    win_apps.pos (x,y)          -- Position set
    
  internals:
    win_apps.help ()            -- display help text
    
  date: 17/10/2018 
  by: Raul Mungai
--]]


-- Load artworks
----------------
css.load_btn_img ("\\buttons\\apps.png",    "apps")   -- app icon
css.load_img ("\\icons\\apps-i.png", "apps-i", "icon") -- app icon (small)

-- Background image
css.load_img ("\\imgB\\comfort.bmp", "BGapps", "BG")

  
-- Global Object
win_apps = {}

  widget_apps = {}
  local winname = "win&apps"
  local winnameI = ""
  
  local function win_apps_create ()
    winnameI = css.window_new (winname, false, "win_apps.help", "BGapps")
    
    -- add title and related buttons
    css.window_title_new (winnameI, sknColl.dictGetPhrase("WIN", 0), nil, true)
    css.window_title_btnSlected (winnameI, 3, true)

    -- buttons
    local wx, wy = win_wintool.nextBtn_coords ()
    
    css.appButton_new ("usrwins", winnameI, wx, wy, "My Win", thema.win_color)
    wx, wy = win_wintool.nextBtn_coords (wx, wy)    
    
    css.appButton_new ("calc", winnameI, wx, wy, "Calc", thema.win_color)
    wx, wy = win_wintool.nextBtn_coords (wx, wy)    
    
    css.appButton_new ("debug", winnameI, wx, wy, "Debug", thema.win_color)
    wx, wy = win_wintool.nextBtn_coords (wx, wy)    
    
    if appcfg_MQTT_active == true then
      css.appButton_new ("aws", winnameI, wx, wy, "AWS", thema.win_color)
      wx, wy = win_wintool.nextBtn_coords (wx, wy)    
    end
    
    css.appButton_new ("settings", winnameI, wx, wy, "Settings", thema.win_color)
    wx, wy = win_wintool.nextBtn_coords (wx, wy)    
    
    css.appButton_new ("devices", winnameI, wx, wy, "Device", thema.win_color)
    wx, wy = win_wintool.nextBtn_coords (wx, wy)    
    
    widget_apps = wd_btn.new ("apps", "Applications", "Apps")    -- add to widget list
    
    --win_wintool.win_add ("apps", "BGapps", "apps") -- add win to user list
  end

  function win_apps.show ()
    sknWin.showRestorable (winname)
  end

  function win_apps.hide ()
    sknWin.hide (winname)
  end

  function win_apps.pos (x,y)
    sknWin.pos (winname, x,y)
  end
  
  -- display help text
  function win_apps.help (name)
    win_helper.help (1, name)
  end
  
win_apps_create ()   -- Window creation
