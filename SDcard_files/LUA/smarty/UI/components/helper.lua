-------------------------------------------------------------------
---------------------------  window:helper  ---------------------
-------------------------------------------------------------------
--[[
  Helper window
  
    win_helper.show ()                -- Show
    win_helper.hide ()                -- Hide
    win_helper.pos (x,y)              -- Position set
    win_helper.help (helpID, objname) -- show specific help
    
  internals:
    win_helper.close ()           -- close helper event
    
  date: 21/10/2018 
  by: Raul Mungai
--]]


-- Load artworks
----------------
css.load_btn_img ("\\buttons\\helper.png",    "helper")   -- app icon

-- icon
css.load_img ("\\icons\\info.png", thema.helper_iconPtr, "icon")
  
-- Global Object
win_helper = {}

  local winname = "winhlp"
  local txth = "$wth" .. winname
  local ipointer = "$wthp" .. winname
  
  local function win_helper_create ()

    css.window_new (winname, false)
    sknWin.transp (winname, true)
    sknWin.keyReleaseCB(winname, "win_helper.hide")
    
    -- text
    sknLbl.create(txth, winname, 0, 0, 200, 150, thema.helper_txtalign, "")
    sknLbl.font(txth, thema.helper_font)
    sknLbl.colors(txth, thema.helper_txtcolor, thema.helper_txtbgcolor)
    sknLbl.wrapmode(txth, "word")
    sknLbl.keyReleaseCB(txth, "win_helper.hide")
    sknLbl.show(txth)

    --pointer image
    sknImg.create (ipointer, winname, 0, 0, 0, 0) 
    sknImg.image(ipointer, "icon", thema.helper_iconPtr)
    -- Unsupported sknImg.keyReleaseCB(ipointer, "win_helper.hide")
    sknImg.show(ipointer)
  end

  function win_helper.show ()
    sknWin.modal(winname, true)
    sknWin.show (winname)
  end

  function win_helper.hide ()
    sknWin.modal(winname, false)
    sknWin.hide (winname)
  end

  function win_helper.pos (x,y)
    sknWin.pos (winname, x,y)
  end
  
  function win_helper.help (helpID, objname)
    sknLbl.text(txth, sknColl.dictGetPhrase("HELP", helpID))
    local ix = 0
    local iy = 0
    local xw, yw = sknWin.size (objname)
    if xw < sknSys.screenXsize() or yw < sknSys.screenYsize() then
      -- move help out of specific object
      local x,y = sknWin.pos (objname)
      local labX = 0
      local labY = 0
      local labW = 100
      local labH = 100
      
      if x+xw > sknSys.screenXsize() // 2 then
        -- Left side help
        labX = 0
        labY = 0
        labW = sknSys.screenXsize() // 2
        labH = sknSys.screenYsize()
        ix = x + xw // 2
        iy = y + yw // 2         
      elseif x < sknSys.screenXsize() // 2 then
        -- right side help
        labX = sknSys.screenXsize() // 2
        labY = 0
        labW = sknSys.screenXsize() // 2
        labH = sknSys.screenYsize()      
        ix = x + xw // 2
        iy = y + yw // 2           
      elseif y > sknSys.screenYsize() // 2 then
        -- Top side help
        labX = 0
        labY = 0
        labW = sknSys.screenXsize()
        labH = sknSys.screenYsize() // 2   
        ix = x + xw // 2
        iy = y + yw // 2           
      elseif y < sknSys.screenYsize() // 2 then
        -- Bot side  help
        labX = 0
        labY = sknSys.screenYsize() // 2
        labW = sknSys.screenXsize()
        labH = sknSys.screenYsize() // 2   
        ix = x + xw // 2
        iy = y - yw // 2           
      else
        -- mixed position
        labX = (sknSys.screenXsize() // 2) + (sknSys.screenXsize() // 4)
        labY = sknSys.screenYsize() // 2
        labW = sknSys.screenXsize() // 3
        labH = sknSys.screenYsize() // 2      
      end
      sknLbl.size(txth, labW, labH)
      sknLbl.pos(txth, labX, labY)
    
    else
      -- help for full window object
      sknLbl.size(txth, sknSys.screenXsize() // 2, sknSys.screenYsize())
      sknLbl.pos(txth, sknSys.screenXsize() // 2, 0)
        
      ix = 100
      iy = 100        
    end
    sknImg.pos (ipointer, ix, iy)
    
    win_helper.show ()
  end

  
win_helper_create ()   -- Window creation
