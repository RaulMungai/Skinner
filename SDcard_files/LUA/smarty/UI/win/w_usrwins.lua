-------------------------------------------------------------------
---------------------------  window:Usrwin selector  --------------
-------------------------------------------------------------------
--[[
  Apps window
  
    win_usrwins.show ()            -- Show
    win_usrwins.hide ()            -- Hide
    win_usrwins.pos (x,y)          -- Position set
    win_usrwins.getWinName ()      -- get window name
    
  internals:
    win_usrwins.help ()            -- display help text
    
  date: 17/10/2018 
  by: Raul Mungai
--]]


-- Load artworks
----------------
css.load_btn_img ("\\buttons\\swin.png",    "usrwins")   -- app icon
--css.load_img ("\\icons\\swin-i.png", "usrwins-i", "icon") -- app icon (small)

-- top bar icons
css.load_btn_img ("\\buttons\\winadd.png", "winadd")
css.load_btn_img ("\\buttons\\home.png",    "home")
css.load_btn_img ("\\buttons\\back.png",  "back") 
  
-- Global Object
win_usrwins = {}

  widget_apps = {}
  local winname = "win&usrwins"
  local winnameI = ""
  
  local function win_usrwins_create ()
    winnameI = css.window_new (winname, false, "win_usrwins.help")
    
    -- add title and related buttons
    css.window_title_new (winnameI, sknColl.dictGetPhrase("WIN", 29), nil, false)
    css.window_title_btnCfg (winname, 1, "back", "sknWin.showCaller")
    css.window_title_btnCfg (winnameI, 2, "home", "win_home.show", "win_home.help")
    css.window_title_btnCfg (winnameI, 4, "winadd", "win_dynwin.show", "win_dynwin.help")
    --css.window_title_btnSlected (winnameI, 3, true)

    -- buttons (dinamically creted by usr win add)
  end

  function win_usrwins.show ()
    sknWin.showRestorable (winname)
    win_wintool.usrWinUpd ()
  end

  function win_usrwins.hide ()
    sknWin.hide (winname)
  end

  function win_usrwins.pos (x,y)
    sknWin.pos (winname, x,y)
  end
  
  -- display help text
  function win_usrwins.help (name)
    win_helper.help (32, name)
  end
  
  -- get window name
  function win_usrwins.getWinName ()
    return winnameI
  end
  
win_usrwins_create ()   -- Window creation
