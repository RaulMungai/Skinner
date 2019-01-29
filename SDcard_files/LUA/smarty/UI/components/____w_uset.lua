
-------------------------------------------------------------------
---------------------------  window:User SETTINGS  ----------------
-------------------------------------------------------------------
--[[
  Setting of User window
  
    win_uset.show ()              -- Show
    win_uset.hide ()              -- Hide
    win_uset.pos (x,y)            -- Position set
    
  internals:
    win_uset.help ()              -- display help text
    
  date: 17/10/2018 
  by: Raul Mungai
--]]


-- Load artworks
----------------
-- top bar icons
css.load_btn_img ("\\buttons\\settings.png",  "settings") 
css.load_btn_img ("\\buttons\\back.png",  "back") 
  
  
-- Global Object
win_uset = {}

  local winname = "win&uset"
  local winnameI = ""
  local wWinName = ""   -- current edit window 
  
  local function win_settings_create ()
    winnameI = css.window_new (winname, false, "win_uset.help")
    
    -- add title and related buttons
    css.window_title_new (winnameI, sknColl.dictGetPhrase("WIN", 22))
    css.window_title_btnCfg (winnameI, 1, "back", "sknWin.showCaller")
    

    -- buttons
  
  end

  function win_uset.show ()
    wWinName = sknWin.currwin()
    css.window_title (winname, sknColl.dictGetPhrase("WIN", 22) .. ":" .. win_wintool.win_workingDesc(wWinName))    
    sknWin.showRestorable (winname)
  end

  function win_uset.hide ()
    sknWin.hide (winname)
  end

  function win_uset.pos (x,y)
    sknWin.pos (winname, x,y)
  end
  
  -- display help text
  function win_uset.help (name)
    win_helper.help (26, name)
  end  
  
win_settings_create ()   -- Window creation
