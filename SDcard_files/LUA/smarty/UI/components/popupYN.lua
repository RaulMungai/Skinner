-------------------------------------------------------------------
---------------------------  window:popup Yes-No ------------------
-------------------------------------------------------------------
--[[
  PopUp Y-N window
  
    win_popupyn.show ()                                     -- Show
    win_popupyn.hide ()                                     -- Hide
    win_popupyn.pos (x,y)                                   -- Position set
    win_popupyn.text (cbOK, cbCancel, title, text[, color]) -- display pop informations
  
  date: 21/10/2018 
  by: Raul Mungai
--]]


-- Load artworks
----------------
css.load_btn_img ("\\buttons\\accept.png",    "ok") 
css.load_btn_img ("\\buttons\\cancel.png",    "cancel")

  
-- Global Object
win_popupyn = {}

  local winname = "win&popupyn"
  local titleName = "popupyn-Title"
  local msgName = "$popynmsg"
  local popup_cbOK = nil
  local popup_cbCancel = nil
  
  -- popUp selection OK event
  function win_popupyn.ok()
    win_popupyn.hide()
    popup_cbOK()
  end
  
  -- popUp selection Cancel event
  function win_popupyn.canc ()
    win_popupyn.hide()
    popup_cbCancel()
  end
  
  local function win_popupyn_create ()
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
    sknLbl.colors(msgName, thema.popup_txtcolor, sknSys.getColor("transparent"))
    sknLbl.wrapmode(msgName, "word")
    sknLbl.show(msgName)

    -- buttons
    css.button_new ("popupokk", winname, 64 , wwy - 41, "ok", "win_popupyn.ok", true, false)
    css.button_new ("popupcanc", winname, (wwx - 96), wwy - 41, "cancel", "win_popupyn.canc", true, false)
  end

  function win_popupyn.show ()
    sknWin.modal(winname, true)
    sknWin.show (winname)
  end

  function win_popupyn.hide ()
    sknWin.modal(winname, false)
    sknWin.hide (winname)
  end

  function win_popupyn.pos (x,y)
    sknWin.pos (winname, x,y)
  end
  
  -- display pop informations
  function win_popupyn.text (cbOK, cbCancel, title, text, color)
    if cbOK == nil or cbCancel == nil then return end
    popup_cbOK = cbOK
    popup_cbCancel = cbCancel
    if color ~= nil then
      sknLbl.colors(msgName, color, "transparent")
    else
      sknLbl.colors(msgName, thema.popup_txtcolor, "transparent")
    end
    
    sknLbl.text(msgName, text)    -- msg
    sknLbl.text(titleName, title)  -- title
    win_popupyn.show ()
  end
  
win_popupyn_create ()   -- Window creation

-- win_popupyn.text ("TITOLO POPUP", "PROVA DI UN MESSAGGIO LUNGO ABBASTANZA DA VEDERE COSA SUCCEDE\r\nSe il word wrap funziona.\r\nEND.")