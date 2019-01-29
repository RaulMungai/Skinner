-------------------------------------------------------------------
---------------------------  window:Win modify  -------------------
-------------------------------------------------------------------
--[[
  Apps window
  
    win_wmodify.show ()            -- Show
    win_wmodify.hide ()            -- Hide
    win_wmodify.pos (x,y)          -- Position set
    
  internals:
    win_wmodify.help ()            -- display help text
    
    win_wmodify.changeBGimg ()     -- change BG image
    win_wmodify.changeBGcolor ()   -- change BG color event
    
    win_wmodify.cbOK_color ()        -- cb color change confirm
    win_wmodify.cbOK_img ()          -- cb image change confirm
    win_wmodify.cbCanc ()            -- cb color change abort
  
    win_wmodify.changeCaption ()     -- change Caption event
    win_wmodify.changeCaptionOK ()   -- change Caption confirmation
  date: 17/10/2018 
  by: Raul Mungai
--]]


-- Load artworks
----------------
css.load_btn_img ("\\buttons\\modify.png",    "wmodify")   -- app icon
css.load_btn_img ("\\buttons\\refresh.png",    "refresh")
css.load_btn_img ("\\buttons\\delwin.png",    "delwin")
css.load_btn_img ("\\buttons\\wins.png",    "editwins")

-- top bar icons
--css.load_btn_img ("\\buttons\\settings.png",  "settings") 
css.load_btn_img ("\\buttons\\back.png",  "back") 
--css.load_btn_img ("\\buttons\\winadd.png", "winadd")


css.font_mount (thema.workDisk .. "res\\font\\F16B_1_S.txt", "F16B")
css.font_mount (thema.workDisk .. "res\\font\\F16_1_S.txt", "F16")
  
-- Global Object
win_wmodify = {}

  editCaptionVar = ""
  local winname = "win&wmodify"
  local winnameI = ""
  local wWinName = ""   -- working window name
  
  local bgWW = 150   -- image and color size W
  local bgHH = 60    -- image and color size H
  
  -- cb color change confirm
  function win_wmodify.cbOK_color ()
    local si = o_list.selectedItem()
    win_wintool.prop_bg_updColor (winname, si.val)
    win_wintool.win_upd (wWinName, nil, si.val) 
  end

  -- cb image change confirm
  function win_wmodify.cbOK_img ()
    local si = o_list.selectedItem()
    win_wintool.prop_bg_updImg (winname, si.icon)
    win_wintool.win_upd (wWinName, si.icon, nil) 
  end

  -- cb color change abort
  function win_wmodify.cbCanc ()
  
  end

  -- change BG image event
  function win_wmodify.changeBGimg ()
    o_list.init()
    o_list.options("icon",true, true, "BG")
    o_list.show("Seleziona immagine di sfondo",  win_wmodify.cbOK_img, win_wmodify.cbCanc, sknSys.screenXsize(), true)    
  end
  
  -- change BG color event
  function win_wmodify.changeBGcolor ()
    o_list.init()
    o_list.options("color", false, false)
    o_list.show(sknColl.dictGetPhrase("WIN", 19), win_wmodify.cbOK_color, win_wmodify.cbCanc, 22, true)    
  end
  
  -- change Caption confirmation
  function win_wmodify.changeCaptionOK ()
    win_wintool.prop_title_updTxt (winname, editCaptionVar)
    win_wintool.win_upd (wWinName, nil, nil, editCaptionVar) 
    css.window_title (winname, sknColl.dictGetPhrase("WIN", 22) .. ":" .. win_wintool.win_workingDesc(wWinName))
  end
  
  -- change Caption event
  function win_wmodify.changeCaption ()
    editCaptionVar = win_wintool.win_workingDesc(wWinName)
    win_kbrd.set ("alpha_ita", "editCaptionVar", 25, winname, "win_wmodify.changeCaptionOK", "Nome sensore")
  end
  
  -- window delete confirmation
  function win_wmodify.deleteYes ()
    wd_manager.removeParents(wWinName)    -- remove from dynamic windows
    win_wintool.win_remove (wWinName)
    win_wmodify.hide()
    win_home.show()
  end
  
  -- window delete Abort
  function win_wmodify.deleteNo ()
    
  end
  
  -- delete user window
  function win_wmodify.deleteUwin ()
    local wd = win_wintool.win_workingDesc (wWinName)
    if wd ~= nil then
      win_popupyn.text (win_wmodify.deleteYes, win_wmodify.deleteNo, "ELINAZIONE WINDOW", "Vuoi eliminare la finestra " .. wd .. " Definitivamente ?")
    end
  end
  
  -- move objects help
  function win_wmodify.help_move(name)
    win_helper.help (27, name)
  end
  
  local function win_wmodify_create ()
    winnameI = css.window_new (winname, false, "win_wmodify.help")
    
    -- add title and related buttons
    css.window_title_new (winnameI, sknColl.dictGetPhrase("WIN", 21))
    css.window_title_btnCfg (winnameI, 1, "back", "sknWin.showCaller")
    --css.window_title_btnCfg (winnameI, 4, "winadd", "win_dynwin.show", "win_dynwin.help")
    --css.window_title_btnCfg (winnameI, 4, "settings", "win_settings.show", "win_settings.help")

    -- Window properties
    local w = 0
    local h = 0
    local y = 40
    w,h = win_wintool.prop_title (winnameI, "", "win_wmodify.changeCaption", 5, y)
    y = y + h + 3
    w,h = win_wintool.prop_bg (winnameI, "win_wmodify.changeBGimg", "win_wmodify.changeBGcolor", 5, y)
    
    css.button_new ("wmEuwin", winnameI, 420, 40, "editwins", "win_dynwin.show", true, false, "Edit Win","black")
    css.button_new ("wmDuwin", winnameI, 420, 100, "delwin", "win_wmodify.deleteUwin", false, false, "Delete","black")
  end

  function win_wmodify.show ()
    wWinName = sknWin.currwin()
    css.window_title (winname, sknColl.dictGetPhrase("WIN", 22) .. ":" .. win_wintool.win_workingDesc(wWinName))
    
    -- config properties
    local bgimg = win_wintool.win_workingBGimage (wWinName)
    if bgimg ~= "" then
      win_wintool.prop_bg_updImg (winname, bgimg)
      win_wintool.prop_bg_showBtn (winname, true, false)
    else
      win_wintool.prop_bg_updColor (winname, sknWin.bgcolor(wWinName))
      win_wintool.prop_bg_showBtn (winname, false, true)
    end
    local wincaption = win_wintool.win_workingDesc(wWinName)
    win_wintool.prop_title_updTxt (winname, wincaption)
    
    -- show delete only for user defined windows
    if win_wintool.win_workingISuserDef (wWinName) == true then
      css.button_show ("wmDuwin")
    else
      css.button_hide ("wmDuwin")
    end
    
    sknWin.showRestorable (winname)
  end

  function win_wmodify.hide ()
    sknWin.hide (winname)
  end

  function win_wmodify.pos (x,y)
    sknWin.pos (winname, x,y)
  end

  -- display help text
  function win_wmodify.help (name)
    win_helper.help (25, name)
  end
  
win_wmodify_create ()   -- Window creation
