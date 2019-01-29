-------------------------------------------------------------------
---------------------------  window:device info  ------------------
-------------------------------------------------------------------
--[[
  Dev infos window:
    win_devinfo.show ()            -- Show
    win_devinfo.hide ()            -- Hide
    win_devinfo.pos (x,y)          -- Position set
    
  Callback:
    win_devinfo.dispinfo (oname)   -- display device informations
    
  internals:
    win_devinfo.help ()            -- display help text
    
  date: 08/01/2019 
  by: Raul Mungai
--]]


-- Load artworks
----------------
css.load_btn_img ("\\buttons\\info.png",    "devinfo")   -- app icon button
css.load_btn_img ("\\icons\\devinfo-i.png",    "devinfo-i")   -- app icon (small)

-- Global Object
win_devinfo = {}

  local winname = "win&devinfo"
  local winnameI = ""
  
  -- fields
  local devinfow_uid = ""
  local devinfow_lqi = ""
  local devinfow_batt = ""
  local devinfow_stato = ""
  
  local function win_devinfo_create ()

    winnameI = css.window_new (winname, false, "win_devinfo.help")
    
    -- add title and related buttons
    css.window_title_new (winnameI, sknColl.dictGetPhrase("WIN", 32), nil)
    css.window_title_btnCfg (winnameI, 1, "back", "sknWin.showCaller")
    
    -- UID
    local tlbl = winnameI .. "$lu"
    sknLbl.create(tlbl, winnameI, 10, 50, 150, 20, "HorLeft_VertCenter", "UID")
    sknLbl.font(tlbl, thema.win_std_font)
    sknLbl.colors(tlbl, thema.win_color, "transparent")
    sknLbl.show(tlbl)

    devinfow_uid = winnameI .. "$uu"
    sknLbl.create(devinfow_uid, winnameI, 170, 50, 150, 20, "HorLeft_VertCenter", "-")
    sknLbl.font(devinfow_uid, thema.win_std_font)
    sknLbl.colors(devinfow_uid, thema.win_color, "transparent")
    sknLbl.show(devinfow_uid)
    
    -- LQI
    tlbl = winnameI .. "$lL"
    sknLbl.create(tlbl, winnameI, 10, 80, 150, 20, "HorLeft_VertCenter", "LQI")
    sknLbl.font(tlbl, thema.win_std_font)
    sknLbl.colors(tlbl, thema.win_color, "transparent")
    sknLbl.show(tlbl)

    devinfow_lqi = winnameI .. "$LL"
    sknLbl.create(devinfow_lqi, winnameI, 170, 80, 150, 20, "HorLeft_VertCenter", "-")
    sknLbl.font(devinfow_lqi, thema.win_std_font)
    sknLbl.colors(devinfow_lqi, thema.win_color, "transparent")
    sknLbl.show(devinfow_lqi)

    -- BATT
    tlbl = winnameI .. "$lB"
    sknLbl.create(tlbl, winnameI, 10, 110, 150, 20, "HorLeft_VertCenter", "Batteria")
    sknLbl.font(tlbl, thema.win_std_font)
    sknLbl.colors(tlbl, thema.win_color, "transparent")
    sknLbl.show(tlbl)

    devinfow_batt = winnameI .. "$BB"
    sknLbl.create(devinfow_batt, winnameI, 170, 110, 150, 20, "HorLeft_VertCenter", "-")
    sknLbl.font(devinfow_batt, thema.win_std_font)
    sknLbl.colors(devinfow_batt, thema.win_color, "transparent")
    sknLbl.show(devinfow_batt)

    -- STATO
    tlbl = winnameI .. "$lS"
    sknLbl.create(tlbl, winnameI, 10, 140, 150, 20, "HorLeft_VertCenter", "Stato")
    sknLbl.font(tlbl, thema.win_std_font)
    sknLbl.colors(tlbl, thema.win_color, "transparent")
    sknLbl.show(tlbl)

    devinfow_stato = winnameI .. "$SS"
    sknLbl.create(devinfow_stato, winnameI, 170, 140, 150, 20, "HorLeft_VertCenter", "-")
    sknLbl.font(devinfow_stato, thema.win_std_font)
    sknLbl.colors(devinfow_stato, thema.win_color, "transparent")
    sknLbl.show(devinfow_stato)


    -- buttons
    --local wx, wy = win_wintool.nextBtn_coords ()
    
    --css.appButton_new ("xyxw", winnameI, wx, wy, "My Win","black")
    --wx, wy = win_wintool.nextBtn_coords (wx, wy)    
        
    --css.appButton_new ("home", winnameI, 350, 200)
    
    -- add window to slide module
     --win_selector.add ("devinfo", win_devinfo.show, win_devinfo.hide, win_devinfo.pos, true)
  end
  
  function win_devinfo.show ()
    sknWin.showRestorable (winname)
  end

  function win_devinfo.hide ()
    sknWin.hide (winname)
  end

  function win_devinfo.pos (x,y)
    sknWin.pos (winname, x,y)
  end

  -- help : return help text
  function win_devinfo.help (name)
    win_helper.help (36, name)
  end
  
  -- display device informations
  function win_devinfo.dispinfo (oname)
    local name = sknIbtn.auxStr(oname)   -- get obj reference name
      
    -- find related widget
    local wd, wdParent = wd_manager.wd_get (name)
    if wd == nil then 
      print ("Unexpected Sel obj:" ..name)
      return
    end

    local devinfo_desc = wd.desc
    local devinfo_UID = wd.UID
    local devinfo_idx = CCC.getObjID(devinfo_UID)
    if devinfo_idx == nil then return end
    
    -- field filling
    local lqi, lqidv = CCC.getnums(devinfo_idx, "BASE", "LQI")
    local stato = CCC.getstr(devinfo_idx, "BASE", "status")
    local deepOL = CCC.getnum(devinfo_idx, "BASE", "deepOffline")
    local batt, battdv = CCC.getnums(devinfo_idx, "BATTERY", "batteryLevel")

    sknLbl.text(devinfow_uid, tostring(devinfo_UID))
    if lqidv == true then
      sknLbl.text(devinfow_lqi, tostring(lqi))
    else
      sknLbl.text(devinfow_lqi, "in attesa") 
    end

    if batt ~= nil then
      if battdv == true then
        sknLbl.text(devinfow_batt, tostring(batt))
      else
        sknLbl.text(devinfow_batt, "in attesa")
      end
    else
      sknLbl.text(devinfow_batt, "NO")
    end

    if deepOL == 1 then
      sknLbl.text(devinfow_stato, "DEEP Off Line")
    else
      if stato == "A" or stato == "S" then
        sknLbl.text(devinfow_stato, "Attivo")
      elseif stato == "U" then
        sknLbl.text(devinfow_stato, "in attesa")
      elseif stato == "O" then
        sknLbl.text(devinfow_stato, "OFF line")
      else
        sknLbl.text(devinfow_stato, "???")
      end
    end

    css.window_title (winname, sknColl.dictGetPhrase("WIN", 32) .. devinfo_desc)
    win_devinfo.show ()
  end
  
  
win_devinfo_create ()   -- Window creation
