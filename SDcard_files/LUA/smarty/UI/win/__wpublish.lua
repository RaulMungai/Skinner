-------------------------------------------------------------------
---------------------------  window:xyz  ---------------
-------------------------------------------------------------------
--[[
  xyz window
  
    win_xyz.show ()                  -- Show
    win_xyz.hide ()                  -- Hide
    win_xyz.pos (x,y)                -- Position set
    
  Elements:
    win_xyz.addElement (zona[, publish])      -- add Widget to  window
    win_xyz.status (zona, instantPwr, totPwr) -- set Luce status
    
  Zone:
    win_xyz.zoneInUse (zone)   -- check for zone in use
    
  internals:
    win_xyz.help ()            -- display help text
    
  date: 23/10/2018 
  by: Raul Mungai
--]]


-- Load artworks
----------------
css.load_btn_img ("\\buttons\\xyz.png",  "xyz")   -- app icon button
css.load_img ("\\icons\\xyz-i.png", "xyz-i", "icon") -- app icon (small)
css.load_btn_img ("\\buttons\\back.png",       "back")

-- meter widget
--css.load_img ("\\img\\elmeter.png", "elmeterb", "IMG") -- back image
--css.font_mount (thema.workDisk .. "res\\font\\F08_1_S.txt", "F8")
--css.load_img ("\\icons\\hand.png", "hand", "icon") -- move icon

-- slide support
--css.load_img ("\\layout\\lay_xyz2.bmp", "lay_xyz", "LAYOUT")

  
-- Global Object
win_xyz = {}
        
  local zWidget = {
    {idx=0, instantPwr=0, totPwr=0,  oname="", cname=""};
    {idx=0, instantPwr=0, totPwr=0,  oname="", cname=""};
    {idx=0, instantPwr=0, totPwr=0,  oname="", cname=""};
    {idx=0, instantPwr=0, totPwr=0,  oname="", cname=""};
    {idx=0, instantPwr=0, totPwr=0,  oname="", cname=""};
    {idx=0, instantPwr=0, totPwr=0,  oname="", cname=""};
    {idx=0, instantPwr=0, totPwr=0,  oname="", cname=""};
    {idx=0, instantPwr=0, totPwr=0,  oname="", cname=""};
    {idx=0, instantPwr=0, totPwr=0,  oname="", cname=""};
    {idx=0, instantPwr=0, totPwr=0,  oname="", cname=""};
    {idx=0, instantPwr=0, totPwr=0,  oname="", cname=""};
    {idx=0, instantPwr=0, totPwr=0,  oname="", cname=""};
    {idx=0, instantPwr=0, totPwr=0,  oname="", cname=""};
    {idx=0, instantPwr=0, totPwr=0,  oname="", cname=""};
    {idx=0, instantPwr=0, totPwr=0,  oname="", cname=""};
    {idx=0, instantPwr=0, totPwr=0,  oname="", cname=""};
    {idx=0, instantPwr=0, totPwr=0,  oname="", cname=""};
    {idx=0, instantPwr=0, totPwr=0,  oname="", cname=""};
    {idx=0, instantPwr=0, totPwr=0,  oname="", cname=""};
    {idx=0, instantPwr=0, totPwr=0,  oname="", cname=""};
  }
      
  local maxZone = 20    -- max number of zone
    
  local winname = "winxyz"
  local wdgtName = "$emtr"
  local wdgtBox_font = "F16B"
  local wdgtBox_H = 40
  local wdgtBox_W = 120
  
  -- pwr meter specific
  local wdgtBox_maxpwr = 8000   -- 8.000 Watt
  
  
  -- get luce Box (return the list index or 0)
  local function win_xyz_idx_get (zoneID)
    if zoneID < 1 then return 0 end
    -- cehck for already present
    for i=1, maxZone do
      if zWidget[i].idx == zoneID then
        return i   -- already active
      end
    end
    return 0
  end
  
  -- update widget values
  local function win_xyz_updWidget (wdgtName, instantPwr, totalPwr)
    -- Power value
    local pwrValue = "$v" .. wdgtName
    sknLbl.text(pwrValue, tostring(totalPwr))
    
    -- Bar value
    local pwrValueP = "$p" .. wdgtName
    sknProgbar.setvalue(pwrValueP, instantPwr)
  end
  
  -- refresh luce boxes
  local function win_xyz_refreshView ()
    local cx = 10
    local cy = 50
    for i=1, maxZone do
      if zWidget[i].idx > 0 then
        local wdgtName = zWidget[i].oname
        if wdgtName ~= "" then
          win_xyz_updWidget (wdgtName, zWidget[i].instantPwr, zWidget[i].totPwr)
          sknWin.pos(wdgtName, cx, cy)
          
          if zWidget[i].cname ~= "" then 
            win_xyz_updWidget (zWidget[i].cname, zWidget[i].instantPwr, zWidget[i].totPwr)
          end

          cx = cx + wdgtBox_W + 3
          if cx + wdgtBox_W > sknSys.screenXsize() - 70 then
            cx = 10
            cy = cy + wdgtBox_H + 3
            if cy + wdgtBox_H > sknSys.screenYsize() then
              return
            end
          end
        end
      end
    end
  end
  
  -- add luce Box (return the list index or 0)
  local function win_xyzDB_add (zoneID)
    if zoneID < 1 then return 0 end
    -- cehck for already present
    for i=1, maxZone do
      if zWidget[i].idx == zoneID then
        return 0    -- already active
      end
    end
    -- now try register
    for i=1, maxZone do
      if zWidget[i].idx == 0 then
        zWidget[i].idx = zoneID
        return i
      end
    end
    return 0
  end
  
  -- delete skinner obj
  local function win_xyz_delSkn (name)
      -- background image (container)
    sknImg.delete (wdgtName)
    
    -- Power value
    local pwrValue = "$v" .. wdgtName
    sknLbl.delete(pwrValue)
    
    -- Bar value
    local pwrValueP = "$p" .. wdgtName
    sknProgbar.delete(pwrValueP)
    
    local pwrZone = "$z" .. wdgtName
    sknLbl.delete(pwrZone)
  end
  
  -- delete luce Box (return the list index deleted)
  local function win_xyz_del (oidx, clone)
    if oidx < 1 or oidx > maxZone then return 0 end
    if clone == false then
      win_xyz_delSkn(zWidget[oidx].oname)
      win_xyz_delSkn(zWidget[oidx].cname)
      zWidget[oidx].idx = 0
      zWidget[oidx].instantPwr = 0
      zWidget[oidx].totPwr = 0
      zWidget[oidx].oname = ""
      zWidget[oidx].cname = ""
    else
      win_xyz_delSkn(zWidget[oidx].cname)
      zWidget[oidx].cname = ""
    end
    win_xyz_refreshView() 
    return 1
  end
  
  -- create control Widget
  local function win_xyz_ctrl_new (zona, wname, clone)
    local zID = win_zone.zoneID (zona)
    if zID == 0 then return "",0,0 end
    local lidx = 0
    if clone == false then
      lidx = win_xyzDB_add (zID)
    else
      lidx = win_xyz_idx_get(zID)
    end
    if lidx == 0 then return "" end
    
    -- background image
    local wdgtName = "$w" .. wname .. tostring(zID)
    if clone == true then
      wdgtName = wdgtName .. "c"
    end

    -- background image (container)
    local iX, iY = sknColl.imgSize("IMG", "elmeterb")
    wdgtBox_W = iX
    wdgtBox_H = iY
    if sknImg.create (wdgtName, wname, 0, 0, iX, iY) == 0 then
      return "",0,0
    end
    if clone == true then
      sknImg.longTouchCB(wdgtName, "win_infoman.moveClone")    -- moving support
    end        
    sknImg.image(wdgtName, "IMG", "elmeterb")
    sknImg.auxData(wdgtName, lidx)
    sknImg.auxStr(wdgtName, wdgtName)    
    sknImg.show(wdgtName)
    
    if clone == true then
      win_infoman.set_sel_icon (wdgtName)  -- move icon
    end
    
    -- Power value
    local pwrValue = "$v" .. wdgtName
    sknLbl.create(pwrValue, wdgtName, 25, 14, 71, 20, "HorCenter_VertCenter", "0")
    sknLbl.font(pwrValue, wdgtBox_font)
    sknLbl.colors(pwrValue, sknSys.getColor("black"), sknSys.getColor("transparent"))
    sknLbl.auxData(pwrValue, lidx)
    sknLbl.auxStr(pwrValue, wdgtName)
    if clone == true then
      sknLbl.longTouchCB(pwrValue, "win_infoman.moveClone")    -- moving support
    end    
    sknLbl.show(pwrValue)
    
    -- Bar value
    local pwrValueP = "$p" .. wdgtName
    sknProgbar.create(pwrValueP, wdgtName, 25, 40, 71, 8)
    sknProgbar.setlimits(pwrValueP, 0, wdgtBox_maxpwr, 0)
    sknProgbar.auxData(pwrValueP, lidx)
    sknProgbar.auxStr(pwrValueP, wdgtName)
    sknProgbar.show(pwrValueP)
    
    local pwrZone = "$z" .. wdgtName
    sknLbl.create(pwrZone, wdgtName, 25, 66, 71, 20, "HorCenter_VertCenter", zona)
    sknLbl.font(pwrZone, wdgtBox_font)
    sknLbl.colors(pwrZone, sknSys.getColor("black"), sknSys.getColor("transparent"))
    sknLbl.auxData(pwrZone, lidx)
    sknImg.auxStr(pwrZone, wdgtName) 
    if clone == true then
      sknLbl.longTouchCB(pwrZone, "win_infoman.moveClone")    -- moving support
    end    
    sknLbl.show(pwrZone)

    if clone == false then
      zWidget[lidx].oname = wdgtName
    else
      zWidget[lidx].cname = wdgtName
    end
    
    win_xyz_refreshView()
    return wdgtName, wdgtBox_W, wdgtBox_H
  end
  
  --[[
  local function win_xyz_ctrl_del (zona, wname, clone)
    local zID = win_zone.zoneID (zona)
    if zID == 0 then return 0 end
    if clone == false then
      local lidx = win_xyz_del (zID, clone)
    else
      -- search related index
      for i=1, maxZone do
        if zWidget[i].idx == zID then
          zWidget[i].cname = ""
        end
        local lidx = i
      end
    end
    
    if lidx == 0 then return 0 end
    local wdgtName = Lname .. wname .. tostring(zID)
    sknLbl.delete(wdgtName)
    win_xyz_refreshView()
    +++++
    return 1
  end
  --]]
  
  -- check for zone in use n(called from zone)
  function win_xyz.zoneInUse (zoneID)
    for i=1, maxZone do
      if zWidget[i].idx == zoneID then
        return true
      end
    end
    return false
  end
  
  
  local function win_xyz_create ()

    css.window_new (winname, false)
    css.window_title_new (winname, sknColl.dictGetPhrase("WIN", 9))
    
    -- synth creation of already active devices
    win_xyz.demodata ()   -- demo data

    -- buttons
    css.button_new ("emexit", winname, 382, 210, "back", "sknWin.showCaller", true)
     
     -- register zone user function
     win_zone.addUser (win_xyz.zoneInUse)
     sknWin.longTouchCB(winname, "win_xyz.help")
  end

  function win_xyz.show ()
    sknWin.showRestorable (winname)
    win_xyz_refreshView ()
  end

  function win_xyz.hide ()
    sknWin.hide (winname)
  end

  function win_xyz.pos (x,y)
    sknWin.pos (winname, x,y)
  end
  
  -- element register function (return object name, wx, wy)
  function win_xyz.el_reg (zona, winname)
    local on, w, h = win_xyz_ctrl_new (zona, winname, true)
    if on == "" then
      print ("win_xyz.el_reg():ERROR")
    end
    return on, w, h
  end
  
    -- element unregister function
  function win_xyz.el_unreg (oname)
    local oidx = sknLbl.auxData(oname)
    if oidx == nil then return end
    if win_xyz_del (oidx, true) == 0 then
      print ("win_xyz.el_unreg():ERROR")
    end      
  end
  
  -- element move function
  function win_xyz.el_move (oname, x, y)
    local oidx = sknLbl.auxData(oname)
    if oidx < 1 or oidx > maxZone then return end
    sknLbl.pos(zWidget[oidx].cname, x, y)
  end

  function win_xyz.el_select (oname, selected)
    local oidx = sknLbl.auxData(oname)
    if oidx < 1 or oidx > maxZone then return end
    
    win_infoman.selected (oname, selected)
  end

  -- add element to window
  function win_xyz.addElement (zona, publish)
    local nn , w, h = win_xyz_ctrl_new (zona, winname, false)
    if nn == "" then
      return
    end
    
    if publish ~= nil then
      if publish == true then
        if win_infoman.add ("emeter-i", zona, win_xyz.el_reg, win_xyz.el_unreg, 
          win_xyz.el_move, win_xyz.el_select, win_xyz.el_setpos) == 0 then
          print ("Unable to add info plugin:" .. name)
          return
        end
      end
    end
  end
  
  -- set Luce status
  function win_xyz.status (zona, instantPwr, totPwr)
    local zID = win_zone.zoneID (zona)
    if zID == 0 then return 0 end
    for i=1, maxZone do
      if zWidget[i].idx == zID then
        zWidget[i].totPwr = tonumber(totPwr)
        zWidget[i].instantPwr = tonumber(instantPwr)
        print ("updstat:" .. zona .. " index:", i, "pwr" , tonumber(instantPwr), tonumber(totPwr))
        win_xyz_refreshView ()
        return 1
      end
    end
    return 0
  end

  -- help : return help text
  function win_xyz.help (name)
    win_helper.help (12, name)
  end
  
  
  ------- DEMO DATA ------
  function win_xyz.demodata ()
    win_xyz.addElement (win_zone.zoneName (1), true)
    win_xyz.addElement (win_zone.zoneName (5), true)
    
    win_xyz.status (win_zone.zoneName (1), 1250, 34567)
    win_xyz.status (win_zone.zoneName (5), 2200, 8910)
  end
    
  
win_xyz_create ()   -- Window creation
