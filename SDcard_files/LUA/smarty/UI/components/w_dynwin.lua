-------------------------------------------------------------------
---------------------------  Dynamic windows  ---------------------
-------------------------------------------------------------------
--[[
  win_dynwin
  
    win_dynwin.show ()                     -- Show
    win_dynwin.hide ()                     -- Hide
    win_dynwin.pos (x,y)                   -- Position set
    
  internals:
    win_dynwin.help ()            -- display help text
  
  date: 10/11/2018 
  by: Raul Mungai
--]]


-- Load artworks
----------------
css.load_btn_img ("\\buttons\\wins.png",    "dynwin")   -- app icon

css.load_btn_img ("\\buttons\\photo.png",    "image")
css.load_btn_img ("\\buttons\\palette.png",   "colors")

-- top bar icons
css.load_btn_img ("\\buttons\\settings.png",  "settings") 
css.load_btn_img ("\\buttons\\back.png",  "back") 

css.load_btn_img ("\\buttons\\back.png",    "back") 
css.load_btn_img ("\\buttons\\accept.png",  "ok") 
css.load_btn_img ("\\buttons\\helper.png",  "helper") 
css.load_btn_img ("\\buttons\\preview.png",  "preview") 

  
-- Global Object
win_dynwin = {}
  
  -- wname="", title="", icon="", bgimage="", bgcolor="", ronly=false
  
  local winList =  {}    -- window list

  local winname = "win&dynwin"
  local winnameI = ""
  
  local c_radix = ""
  local c_winname = ""
  local c_winnameI = ""
  local c_descr = ""
  local c_icon = ""
  local c_shortDesc = ""
  local c_bgImage = ""
  local c_bgColor = ""
  local c_usrzoneX = 0
  local c_usrzoneY = 20
  local c_usrzoneW = sknSys.screenXsize()
  local c_usrzoneH = sknSys.screenYsize() - c_usrzoneY
  
  local previewOn = false
  
  editExcangeVar = ""

  -- window creartion
  function win_dynwin.winCreateNow ()
 
    -- add window to list
    -- generate unique winname
    local wnr = "win&wusr"
    local i = 1
    local nwn = ""
    while true do
      local xx,yy = sknWin.size(wnr .. tostring(i))
      if xx == nil then      
        nwn = wnr .. tostring(i)
        c_radix = "wusr" .. tostring(i)
        break;
      end
      i = i+1  
    end
    if nwn == "" then return end
    
    c_winname = nwn
    c_winnameI = css.window_new (c_winname, false, "win_" .. c_radix .. ".help", c_bgImage, c_bgColor)
    
    -- add title and related buttons
    css.window_title_new (c_winnameI, c_descr, nil, true, true) -- custom toolbar

    -- add to persistant list
    win_wintool.win_add (c_radix, c_bgImage, c_shortDesc, c_icon, c_usrzoneX, c_usrzoneY, c_usrzoneW, c_usrzoneH)
    --c_icon = ""
    
    -- Vuoi aggiungere dei plugin ? (popUp (YES-NO))
    
    win_wintool.winpreview_hide (winnameI)
    win_dynwin.hide ()
    
    -- jump to new window
    sknWin.show(c_winname)
  end
  
  -- window creation abort
  function win_dynwin.winCreateCanc()
    win_wintool.winpreview_hide (winnameI)
    win_dynwin.hide ()
  end

  -- short description change confirmation
  function win_dynwin.changeSDescOK ()
    if editExcangeVar ~= "" then
      c_shortDesc = editExcangeVar
      win_wintool.prop_iconDesc_upd (winnameI, c_shortDesc)
    end
  end

  -- Icon selection confirmation
  function win_dynwin.cbOKicon ()
    local si = o_list.selectedItem()
    c_icon = si.icon
    win_wintool.prop_icon_upd (winnameI, c_icon)
  end

  -- icon selection abort
  function win_dynwin.cbCancIcon ()
    win_dynwin.hide ()
  end

  -- end list operation event
  function win_dynwin.edit_cb (changed)
    local si = o_list.selectedItem()
       
    if si.desc ~= "" then
      -- new window description
      c_descr = si.desc
      c_shortDesc = c_descr
      win_wintool.prop_iconDesc_upd (winnameI, c_shortDesc)
      win_wintool.prop_title_updTxt (winnameI, c_descr)
    
    --[[
    else
      -- no change, selection ?
      if win_list.selectedItemIdx() > 0 then
          -- jump to window
          local wjump = win_wintool.win_workingName (win_list.selectedItem())
          if wjump ~= "" then
            win_dynwin.hide ()
            sknWin.showRestorable (wjump)   --Returnable window
          end
      end
      --]]
    end
  end
  
  -- edit window title
local function win_dynwin_titleEdit ()
    o_list.init()
    o_list.options("win", true, false, "btn")
    o_list.show(sknColl.dictGetPhrase("WIN", 18), win_dynwin.edit_cb, lstCanc, thema.btn_size, true)   
  end

  -- edit window Title
  function win_dynwin.changeCaption()
    win_dynwin_titleEdit ()
  end
  
  -- cb color change confirm
  function win_dynwin.cbOK_color ()
    local si = o_list.selectedItem()
    win_wintool.prop_bg_updColor (winnameI, si.val)
    c_bgColor = si.val
    c_bgImage = ""
  end

  -- cb image change confirm
  function win_dynwin.cbOK_img ()
    local si = o_list.selectedItem()
    win_wintool.prop_bg_updImg (winnameI, si.icon)
    c_bgImage = si.icon
  end

  -- cb color change abort
  function win_dynwin.cbCanc ()
  
  end

  -- change BG color event
  function win_dynwin.changeBGcolor ()
    o_list.init()
    o_list.options("color", false, false)
    o_list.show(sknColl.dictGetPhrase("WIN", 19), win_dynwin.cbOK_color, win_dynwin.cbCanc, 22, true)    
  end
  
    -- change BG image event
  function win_dynwin.changeBGimg ()
    o_list.init()
    o_list.options("icon",true, false, "BG")
    o_list.show("Seleziona immagine di sfondo", win_dynwin.cbOK_img, win_dynwin.cbCanc, sknSys.screenXsize(), true)    
  end
  
  -- change Icon event
  function win_dynwin.changeIcon()
    o_list.init()
    o_list.options("icon",true, false, "btn")
    o_list.show("Seleziona Icona", win_dynwin.cbOKicon, win_dynwin.cbCancIcon, thema.btn_size, true)    
  end
  
  -- change Icon descr
  function win_dynwin.changeIconD()
    editExcangeVar = c_shortDesc
    win_kbrd.set ("alpha_ita", "editExcangeVar", 15, winname, "win_dynwin.changeSDescOK", "Descrizione")
  end  
  
  -- window preview
  function win_dynwin.winPreview ()
    if previewOn == false then
      win_wintool.winpreview_disp (winnameI, c_bgImage, c_bgColor, c_descr, c_icon, c_shortDesc, 10,40)
      previewOn = true
    else
      win_wintool.winpreview_hide (winnameI)
      previewOn = false
    end
  end
  
  -- set efault params
  local function win_dynwin_defParam()
    c_descr = "NUOVA FINESTRA"
    c_icon = "helper"
    c_shortDesc = "MyWin"
    c_bgColor = thema.win_bg_color
    previewOn = false
  end
  
  local function win_dynwin_create ()
    win_dynwin_defParam()
    winnameI = css.window_new (winname, false, "win_dynwin.help")
    
    -- add title and related buttons
    css.window_title_new (winnameI, sknColl.dictGetPhrase("WIN", 18))
    css.window_title_btnCfg (winnameI, 1, "back", "sknWin.showCaller")
    css.window_title_btnCfg (winnameI, 4, "settings", "win_settings.show", "win_settings.help")
    
    local w = 0
    local h = 0
    local y = 40
    w,h = win_wintool.prop_title (winnameI, c_descr, "win_dynwin.changeCaption", 5, y)
    y = y + h + 3
    w,h = win_wintool.prop_bg (winnameI, "win_dynwin.changeBGimg", "win_dynwin.changeBGcolor", 5, y)
    win_wintool.prop_bg_updColor (winnameI, thema.win_bg_color)
    y = y + h + 3
    w,h = win_wintool.prop_icon (winnameI, c_icon, "win_dynwin.changeIcon", 5, y)
    y = y + h + 3
    w,h = win_wintool.prop_iconDesc (winnameI, c_shortDesc, "win_dynwin.changeIconD", 5, y)
    y = y + h + 3
    
    -- creation confirm buttons
    css.button_new ("wdynCprev", winnameI, 420, 100, "preview", "win_dynwin.winPreview", true, false, "Preview","black")
    css.button_new ("wdynCnow", winnameI, 420, 160, "ok", "win_dynwin.winCreateNow", true, false, "Crea","black")
    css.button_new ("wdynCcanc", winnameI, 420, 220, "back", "win_dynwin.winCreateCanc", true, false, "Annulla","black")
  end

  function win_dynwin.show ()
    win_dynwin_defParam()
    win_wintool.prop_bg_updColor (winnameI, thema.win_bg_color)
    win_wintool.prop_iconDesc_upd (winnameI, c_shortDesc)
    win_wintool.prop_icon_upd (winnameI, c_icon)
    sknWin.show (winname)
    win_dynwin_titleEdit ()
  end

  function win_dynwin.hide ()
    sknWin.hide (winname)
    sknWin.showCaller()
  end

  function win_dynwin.pos (x,y)
    sknWin.pos (winname, x,y)
  end
  
  -- display help text
  function win_dynwin.help (name)
    win_helper.help (22, name)
  end
  
win_dynwin_create ()   -- Window creation
