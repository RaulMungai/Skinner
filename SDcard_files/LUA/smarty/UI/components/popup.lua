-------------------------------------------------------------------
---------------------------  window:popup  ---------------------
-------------------------------------------------------------------
--[[
  PopUp window
  
    win_popup.show ()                     -- Show
    win_popup.hide ()                     -- Hide
    win_popup.pos (x,y)                   -- Position set
    win_popup.text (title, text[, color]) -- display pop informations
    
  date: 21/10/2018 
  by: Raul Mungai
--]]


-- Load artworks
----------------
css.load_btn_img ("\\buttons\\accept.png",    "ok")   -- app icon

  
-- Global Object
win_popup = {}

  local winname = "win&popup"
  local titleName = "popupTtl"
  local msgName = "$popmsg"
  
  local function win_popup_create ()
    local xs = sknSys.screenXsize() - (sknSys.screenXsize() // 4)
    local ys = sknSys.screenYsize() - (sknSys.screenYsize() // 4)
    sknWin.create (winname, (sknSys.screenXsize() - xs) // 2 , (sknSys.screenYsize() - ys) // 2, xs, ys)
    sknWin.bgcolor (winname, thema.popup_bg_color)
    
    local wx,wy = sknWin.size (winname)
    sknLbl.create(titleName, winname, 0, 0, wx, thema.popup_title_height, thema.popup_title_align, "")
    sknLbl.font(titleName, thema.popup_title_font)
    sknLbl.colors(titleName, thema.popup_title_color, thema.popup_title_bg_color)
    sknLbl.show(titleName)

    -- text
    local wwx, wwy = sknWin.size(winname)
    sknLbl.create(msgName, winname, 0, 0, wwx, wwy - 50, "HorCenter_VertCenter", "")
    sknLbl.font(msgName, thema.popup_font)
    sknLbl.colors(msgName, thema.popup_txtcolor, "transparent")
    sknLbl.wrapmode(msgName, "word")
    sknLbl.show(msgName)

    -- buttons
    css.button_new ("popupok", winname, (wwx - 32) // 2, wwy - 41, "ok", "win_popup.hide", true, false)
  end

  function win_popup.show ()
    sknWin.modal(winname, true)
    sknWin.show (winname)
  end

  function win_popup.hide ()
    sknWin.modal(winname, false)
    sknWin.hide (winname)
  end

  function win_popup.pos (x,y)
    sknWin.pos (winname, x,y)
  end
  
  -- display pop informations
  function win_popup.text (title, text, color)
    if color ~= nil then
      sknLbl.colors(msgName, color, "transparent")
    else
      sknLbl.colors(msgName, thema.popup_txtcolor, "transparent")
    end
    
    sknLbl.text(msgName, text)    -- msg
    sknLbl.text(titleName, title)  -- title
    win_popup.show ()
  end
  
win_popup_create ()   -- Window creation

-- win_popup.text ("TITOLO POPUP", "PROVA DI UN MESSAGGIO LUNGO ABBASTANZA DA VEDERE COSA SUCCEDE\r\nSe il word wrap funziona.\r\nEND.")