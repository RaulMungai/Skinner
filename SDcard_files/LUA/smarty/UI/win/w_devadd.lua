-------------------------------------------------------------------
---------------------------  window:devAdd  -----------------------
-------------------------------------------------------------------
--[[
  dev add window
  
    win_devadd.show ()            -- Show
    win_devadd.hide ()            -- Hide
    win_devadd.pos (x,y)          -- Position set
    
  internals:
    win_devadd.help ()            -- display help text
    
  date: 17/10/2018 
  by: Raul Mungai
--]]


-- Load artworks
----------------
css.load_btn_img ("\\buttons\\adddev.png",    "devadd")   -- app icon
css.load_img ("\\icons\\adddev-i.png", "devadd-i", "icon") -- app icon (small)

css.load_btn_img ("\\buttons\\setCode.png", "setDevID")
css.load_btn_img ("\\buttons\\textfield.png","textEdit")
css.load_btn_img ("\\buttons\\join.png",    "join")

css.font_mount (thema.workDisk .. "res\\font\\F16B_1_S.txt", "F16B")
css.font_mount (thema.workDisk .. "res\\font\\F16_1_S.txt", "F24B")


-- Global Object
win_devadd = {}

  widget_devadd = {}
  local winname = "win&devadd"
  local winnameI = ""
  editdevIDVar = ""
  
  local function win_devadd_create ()
    winnameI = css.window_new (winname, false, "win_devadd.help")
    
    -- add title and related buttons
    css.window_title_new (winnameI, sknColl.dictGetPhrase("WIN", 28), nil, true)
    css.window_title_btnSlected (winnameI, 3, true)

    -- ID
    local labID_w = 120
    local labID_h = 20
    
    -- UID
    sknLbl.create("l_devID", winnameI, 30, 60, labID_w, labID_h, "HorCenter_VertCenter", "Device ID")
    sknLbl.font("l_devID", "F16B")
    sknLbl.colors("l_devID", thema.win_color, "transparent")
    sknLbl.show("l_devID")
    
    sknLbl.create("l_devIDv", winnameI, 30, 80, labID_w, labID_h, "HorCenter_VertCenter", "")
    sknLbl.font("l_devIDv", "F24B")
    sknLbl.colors("l_devIDv", thema.win_color, "transparent")
    sknLbl.show("l_devIDv")
    css.button_new ("setdevIDb", winnameI, 200, 55, "setDevID", "win_devadd.setID", true, false, "Set devID", thema.win_color)

    -- Description
    sknLbl.create("l_devDes", winnameI, 30, 120, labID_w, labID_h, "HorCenter_VertCenter", "Descrizione")
    sknLbl.font("l_devDes", "F16B")
    sknLbl.colors("l_devDes", thema.win_color, "transparent")
    sknLbl.show("l_devDes")
    
    sknLbl.create("l_devDesv", winnameI, 30, 140, labID_w, labID_h, "HorCenter_VertCenter", "")
    sknLbl.font("l_devDesv", "F24B")
    sknLbl.colors("l_devDesv", thema.win_color, "transparent")
    sknLbl.show("l_devDesv")
    css.button_new ("l_devDesb", winnameI, 200, 115, "textEdit", "win_devadd.setDesc", true, false, "Set Desc", thema.win_color)
    
    css.button_new ("joinexeca", winnameI, 115, 190, "join", "win_devadd.autoJoin", true, false, "Join Auto", thema.win_color)
    css.button_new ("joinexecm", winnameI, 210, 190, "join", "win_devadd.mnualJoin", true, false, "Join Manuale", thema.win_color)
    
    -- Widget registration
    widget_devadd = wd_btn.new ("devadd", "Device Add", "dev Add")    -- add to widget list
  end
  
  -- change ID confirmation
  function win_devadd.changeIDOK ()
    sknLbl.text("l_devIDv", editdevIDVar)
  end
  
  -- set device ID
  function win_devadd.setID ()
    editdevIDVar = sknLbl.text("l_devIDv")
    win_kbrd.set ("numbers", "editdevIDVar", 10, winname, "win_devadd.changeIDOK", "Device UID")
  end
  
  -- change Desc confirmation
  function win_devadd.changeDescOK ()
    sknLbl.text("l_devDesv", editdevIDVar)
  end
  
  -- set device desc
  function win_devadd.setDesc()
    editdevIDVar = sknLbl.text("l_devDesv")
    win_kbrd.set ("alpha_ita", "editdevIDVar", 10, winname, "win_devadd.changeDescOK", "Descrizione")    
  end
  
  -- Join after
  function win_devadd.joinAfter ()
    -- store UID on authlist
    
  end
  
  -- join Abort
  function win_devadd.joinAbort ()
    win_devadd.hide ()
  end
  
  -- delete user window
  function win_devadd.joinAfter ()
    --[[
    local wd = win_wintool.win_workingDesc (wWinName)
    if wd ~= nil then
      win_popupyn.text (win_wmodify.deleteYes, win_wmodify.deleteNo, "ELINAZIONE WINDOW", "Vuoi eliminare la finestra " .. wd .. " Definitivamente ?")
    end
    --]]
  end
  
  -- Join event
  function win_devadd.joinEvent (UID)
    local UIDj = tonumber(sknLbl.text("l_devIDv"))
    if UIDj == UID then
      print ("JOIN ESEGUITO !!!!")
    else
      print ("JOIN DA UN ALTRO UID !!!!")
    end
    
    hourglass.hide ()
  end
  
  -- Join Abort
  function win_devadd.joinAbort (UID)
    hourglass.hide ()
    print ("JOIN ANDATO MALEEEEE !!!!")
    win_popup.text ("JOIN ERROR", "Non è stato possibile aggiungere il nuovo dispositivo. Verifica che sia attivo e riprova.")
  end
  
  
  -- try Manual Join
  function win_devadd.manualJoin()
    local UID = tonumber(sknLbl.text("l_devIDv"))
    if UID == 0 then return end
    
    hourglass.show ()
    local isPresent = CCC.setnum (0, "WIRELESSNET", "devIsPresent",UID)
  
    if isPresent == 0 then
      hourglass.hide ()
      win_popupyn.text (win_devadd.joinAfter, win_devadd.joinAbort, "DEVICE NON TROVATO", "Vuoi ricordare l'ID " .. tostring(UID) .. " per consentire il Join automatico in seguito ? ")
    else 
      -- store UID on authlist
      
      -- Exec the Join request
      
      newObj_event = win_devadd.joinEvent
      joinAbort_event = win_devadd.joinAbort
      
      if CCC.setnum (0, "JOIn", "joinToMe",UID) == 0 then
        hourglass.hide ()
        win_popup.text ("JOIN ERROR", "Non e' stato possibile aggiungere il nuovo dispositivo. Verifica che sia attivo e riprova.")
      end

      hourglass.hide ()
      win_popup.text ("AGGIUNTO DISPOSITIVO", "E' stato aggiunto un nuovo dispositivo ...")
      win_devadd.hide ()
    end
  end
  
  -- register ID for AUtomatic Join
  function win_devadd.autoJoin()
    local UID = tonumber(sknLbl.text("l_devIDv"))
    if UID == 0 then return end
    
    local descr = sknLbl.text("l_devDesv")
    if descr == "" then return end
    
    if CCC.getObjID(UID) >= 0 then
      win_popup.text ("GIA' ATTIVO", "Il dispositivo e' gia' attivo.")
      return
    end
    
    --if CCC.setnum (0, "WIRELESSNET", "authAddChk",UID) == 1 then
    --  win_popup.text ("GIA' CENSITO", "Il dispositivo e' gia' censito.")
    --  return
    --end
    
    -- register UID into Filesystem
    if CCC.setnum (0, "WIRELESSNET", "authListAdd",UID) == 1 then
      win_popup.text ("AGGIUNTO NUOVO ID", "E' stato aggiunto l'ID " .. tostring(UID) .. " relativo a " .. descr .. " alla lista. Il nuovo dispositivo verra' aggiunto automaticamente appena si presentera' in rete.")
      win_devadd.hide ()
    else
      win_popup.text ("ERRORE IMPREVISTO", "Non e' stato possibile aggiungere il nuovo dispositivo alla lista.")
    end
    cccwrp.joinRequest(UID, descr)
  end
  
  function win_devadd.show ()
    sknWin.showRestorable (winname)
  end

  function win_devadd.hide ()
    sknWin.hide (winname)
  end

  function win_devadd.pos (x,y)
    sknWin.pos (winname, x,y)
  end
  
  -- display help text
  function win_devadd.help (name)
    win_helper.help (37, name)
  end
  
win_devadd_create ()   -- Window creation
