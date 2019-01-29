-------------------------------------------------------------------
---------------------------  window:dev services  -----------------
-------------------------------------------------------------------
--[[
  dev services window
  
    win_devserv.show ()            -- Show
    win_devserv.hide ()            -- Hide
    win_devserv.pos (x,y)          -- Position set
    
  internals:
    win_devserv.help ()            -- display help text
    
  date: 17/10/2018 
  by: Raul Mungai
--]]


-- Load artworks
----------------
css.load_btn_img ("\\buttons\\moddev.png",    "devserv")   -- app icon
css.load_img ("\\icons\\moddev-i.png", "devserv-i", "icon") -- app icon (small)

css.load_btn_img ("\\buttons\\setCode.png", "setDevID")
css.load_btn_img ("\\buttons\\cancel.png",    "cancel")
css.load_btn_img ("\\buttons\\devices.png",    "devices")   -- app icon button

css.font_mount (thema.workDisk .. "res\\font\\F16B_1_S.txt", "F16B")
css.font_mount (thema.workDisk .. "res\\font\\F16_1_S.txt", "F24B")


-- Global Object
win_devserv = {}

  local winname = "win&devserv"
  local winnameI = ""
  editdevsIDVar = ""
  
  local function win_devserv_create ()
    winnameI = css.window_new (winname, false, "win_devserv.help")
    
    -- add title and related buttons
    css.window_title_new (winnameI, sknColl.dictGetPhrase("WIN", 33), nil, true)
    css.window_title_btnSlected (winnameI, 3, true)

    -- ID
    local labID_w = 120
    local labID_h = 20
    
    -- UID
    sknLbl.create("l_devsID", winnameI, 30, 60, labID_w, labID_h, "HorCenter_VertCenter", "Device ID")
    sknLbl.font("l_devsID", "F16B")
    sknLbl.colors("l_devsID", thema.win_color, "transparent")
    sknLbl.show("l_devsID")
    
    sknLbl.create("l_devsIDv", winnameI, 30, 80, labID_w, labID_h, "HorCenter_VertCenter", "")
    sknLbl.font("l_devsIDv", "F24B")
    sknLbl.colors("l_devsIDv", thema.win_color, "transparent")
    sknLbl.show("l_devsIDv")
    css.button_new ("setdevsIDb", winnameI, 200, 55, "setDevID", "win_devserv.setID", true, false, "Set devID", thema.win_color)
    
    css.button_new ("dlstb", winnameI, 280, 55, "devices", "win_devserv.devlst", true, false, "Sel device", thema.win_color)

    css.button_new ("uidrem", winnameI, 380, 55, "cancel", "win_devserv.uidremove", true, false, "UID Remove", thema.win_color)
  end
  
  -- device selection:OK
  function win_devserv.selOK()
  local si = o_list.selectedItem()
  sknLbl.text("l_devsIDv", tostring(si.UID))
  end
  
  -- device selection:Canc
  function win_devserv.selCanc()
    
  end
  
  -- find device
  function win_devserv.devlst ()
    local idx = 1
    local wd = {}
    o_list.init()  -- clr list
    repeat
      wd = wd_manager.item_get (idx)
      if wd ~= nil then
        if wd.UID ~= 0 then
          local widget = wd.wdptr
          o_list.addItem(widget.icon, widget.desc, widget.radix ,widget.UID, wd.wdptr)
        end
      end
      idx = idx + 1
    until (wd == nil)
    o_list.options("txt", false, true)
    o_list.show(sknColl.dictGetPhrase("WIN", 30), win_devserv.selOK, win_devserv.seCanc, thema.btn_size)       
  end
  
  -- change ID confirmation
  function win_devserv.changeIDOK ()
    sknLbl.text("l_devsIDv", editdevsIDVar)
  end
  
  -- set device ID
  function win_devserv.setID ()
    editdevsIDVar = sknLbl.text("l_devsIDv")
    win_kbrd.set ("numbers", "editdevsIDVar", 10, winname, "win_devserv.changeIDOK", "Device UID")
  end
  
  -- Delete confirmation: OK
  function win_devserv.decConf_OK ()
    cccwrp.CCCremoveObj(uid)
    win_devserv.hide ()    
  end
  
  -- Delete confirmation: OK
  function win_devserv.decConf_Canc ()
    
  end

  -- remove UID
  function win_devserv.uidremove ()
    local suid = sknLbl.text("l_devsIDv")
    if suid == "" then return end
    local uid = tonumber(suid)
    if uid == 0 then return end
    
    win_popupyn.text (win_devserv.decConf_OK, win_devserv.decConf_Canc, "RIMOZIONE DEVICE", "La rimozione e' definitiva, sei sicuro di voler rimuovere il Device:" .. suid .. " ?")
  end
  
  
  function win_devserv.show ()
    sknWin.showRestorable (winname)
  end

  function win_devserv.hide ()
    sknWin.hide (winname)
  end

  function win_devserv.pos (x,y)
    sknWin.pos (winname, x,y)
  end
  
  -- display help text
  function win_devserv.help (name)
    win_helper.help (38, name)
  end
  
win_devserv_create ()   -- Window creation
