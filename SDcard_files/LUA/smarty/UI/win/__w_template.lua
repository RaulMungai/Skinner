-------------------------------------------------------------------
---------------------------  window:template  ---------------------
-------------------------------------------------------------------
--[[
  Apps window
  
    win_xyz.show ()            -- Show
    win_xyz.hide ()            -- Hide
    win_xyz.pos (x,y)          -- Position set
    
  internals:
    win_xyz.help ()            -- display help text
    
  date: ??/??/2019 
  by: XXX XXXX
--]]


-- Load artworks
----------------
css.load_btn_img ("\\buttons\\xyz.png",    "xyz")   -- app icon button
css.load_btn_img ("\\icons\\xyz.png",    "xyz-i")   -- app icon (small)

-- Background image
css.load_img ("\\imgB\\xxxxxx.bmp", "BGxyz", "BG")

-- slide support
css.load_img ("\\layout\\lay_xyz2.bmp", "lay_xyz", "LAYOUT")

  
-- Global Object
win_xyz = {}

  local winname = "win&xyz"
  local winnameI = ""
  
  local function win_xyz_create ()

    winnameI = css.window_new (winname, false, "win_xyz.help", "BGapps")
    
    -- add title and related buttons
    css.window_title_new (winnameI, sknColl.dictGetPhrase("WIN", xyxw), nil, true)
    css.window_title_btnSlected (winnameI, X, true)
    
    -- buttons
    local wx, wy = win_wintool.nextBtn_coords ()
    
    css.appButton_new ("xyxw", winnameI, wx, wy, "My Win","black")
    wx, wy = win_wintool.nextBtn_coords (wx, wy)    
        

    --css.appButton_new ("home", winnameI, 350, 200)
    
    -- add window to slide module
     --win_selector.add ("xyz", win_xyz.show, win_xyz.hide, win_xyz.pos, true)
  end

  function win_xyz.show ()
    sknWin.showRestorable (winname)
  end

  function win_xyz.hide ()
    sknWin.hide (winname)
  end

  function win_xyz.pos (x,y)
    sknWin.pos (winname, x,y)
  end

  -- help : return help text
  function win_xyz.help (name)
    win_helper.help (XYZID, name)
  end
  
win_xyz_create ()   -- Window creation
