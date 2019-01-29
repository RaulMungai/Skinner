
-------------------------------------------------------------------
---------------------------  window:HOME  -------------------------
-------------------------------------------------------------------
--[[
  Home window
  
    win_home.show ()           -- Show
    win_home.hide ()           -- Hide
    win_home.pos (x,y)         -- Position set
  
  internals:
    win_home.help ()           -- display help text
    
  Top bar:
    win_home.AWSconn (mode)    -- set AWS icon ("C"=connected, "?"=connetting, "N"=not connected)

  date: 21/10/2018 
  by: Raul Mungai
--]]

-- Load artworks
----------------
css.load_btn_img ("\\buttons\\home.png",    "home")     -- app icon
css.load_btn_img ("\\buttons\\apps.png",    "apps") 

css.load_img ("\\layout\\lay_home.bmp", "lay_home", "LAYOUT")

-- Background image
css.load_img ("\\imgB\\piumi.bmp", "BGscreen", "BG")

-- top bar image
css.load_img ("\\img\\hbar480x20.bmp", "tbari", "IMG")   -- bar
css.load_img ("\\icons\\AWS32.png", "AWSyes", "icon")
css.load_img ("\\icons\\NOAWS32.png", "AWSno", "icon")
css.load_img ("\\icons\\xAWS32.png", "AWSx", "icon")

-- Global Object
win_home = {}

  local winname = "winHome"
  local winnameI = ""
  local tbarH = "tbarHome"
  
  local function win_home_create ()
    winnameI = css.window_new (winname, false, "win_home.help", "BGscreen")
        
    -- top bar
    sknImg.create (tbarH, winnameI, 0, 0, sknSys.screenXsize(), 20) 
    sknImg.image(tbarH, "IMG", "tbari")
    
    -- topbar:AWS connection
    sknImg.create (tbarH .. "aws", tbarH, 5, 0,0,0) 
    sknImg.image(tbarH .. "aws", "icon", "AWSno")
    sknImg.show(tbarH .. "aws")
    
    sknImg.show(tbarH)
    
    -- buttons    
    css.appButton_new ("apps", winnameI, 420, 30, "Apps", thema.win_color)
    css.appButton_new ("selector", winnameI, 420, 92, "Windows", thema.win_color)
    
    css.appButton_new ("devadd", winnameI, 420, 154, "Dev Add", thema.win_color)
    
    -- add window to slide module
    win_selector.add ("home", win_home.show, win_home.hide, win_home.pos, true)
        
    -- register information manager home params
    --win_infoman.setHomeLimits (winnameI, 5, 30 , 410 , 200)
  end

  function win_home.show ()
    sknWin.showRestorable (winname)
  end

  function win_home.hide ()
    sknWin.hide (winname)
  end

  function win_home.pos (x,y)
    sknWin.pos (winname, x,y)
  end
  
  -- Toolbar icon AWS control
  function win_home.AWSconn (mode)
    if mode == "C" then
      sknImg.image(tbarH .. "aws", "icon", "AWSyes")
    elseif mode == "?" then
      sknImg.image(tbarH .. "aws", "icon", "AWSx")
    else
      sknImg.image(tbarH .. "aws", "icon", "AWSno")
    end
  end
  
  -- display help text
  function win_home.help (name)
    win_helper.help (0, name)
  end
  
win_home_create ()   -- Window creation
