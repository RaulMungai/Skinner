-------------------------------------------------------------------
---------------------------  window:DEBUG  ------------------------
-------------------------------------------------------------------
--[[
  Debug window
  
    win_debug.show ()            -- Show
    win_debug.hide ()            -- Hide
    win_debug.pos (x,y)          -- Position set

  
  internals:
    win_debug.help ()            -- display help text
    
  date: 19/10/2018 
  by: Raul Mungai
--]]


-- Load artworks
----------------
css.load_btn_img ("\\buttons\\debug.png",    "debug")   -- app icon
css.load_btn_img ("\\buttons\\back.png",     "back") 
css.load_btn_img ("\\buttons\\screen.png",   "slideDemo") 

-- slide support
css.load_img ("\\layout\\lay_debug.bmp", "lay_debug", "LAYOUT")

  
-- Global Object
win_debug = {}

  local winname = "windebug"
  
  local function win_debug_create ()
    winnameI = css.window_new (winname, false, "win_debug.help")
    
    -- add title and related buttons
    css.window_title_new (winnameI, sknColl.dictGetPhrase("WIN", 2), nil, true)

    -- buttons
    local wx, wy = win_wintool.nextBtn_coords ()
    css.button_new ("wd_slide", winname, wx, wy, "slideDemo", "win_debug.demoSlide", true, false, "Slide Demo", thema.win_color)
    wx, wy = win_wintool.nextBtn_coords (wx, wy)
    
    -- add window to slide module
    win_selector.add ("debug", win_debug.show, win_debug.hide, win_debug.pos, true)
    sknWin.longTouchCB(winname, "win_debug.help")    -- help
  end

  function win_debug.show ()
    sknWin.showRestorable (winname)
  end

  function win_debug.hide ()
    sknWin.hide (winname)
  end

  function win_debug.pos (x,y)
    sknWin.pos (winname, x,y)
  end

  -- display help text
  function win_debug.help (name)
    win_helper.help (6, name)
  end
  
  -- APPLICATION 
   function win_debug.demoSlide ()
    for i=0,4 do
      win_selector.showNext ()
      os.sleep(3000)
    end
    win_home.show ()
  end     
  
  
win_debug_create ()   -- Window creation
