
-------------------------------------------------------------------
---------------------------  window:floatbar  ---------------------
--[[
  Floating control bar fully customizable

    win_floatBar.create (name, color, barHeight, barWidth, barPos, gridSize, TO)                          -- create float bar
    win_floatBar.delete (name)                                                                            -- delete float bar
    win_floatBar.addIcon (name, iname, event, img, gridPos)                                               -- set new icon
    win_floatBar.addIconText (name, iname, txt, txtColor, font, txtOffsX, txtOffsY, event, img, gridPos)  -- set new icon and text
    win_floatBar.delIcon (name, iname)                      -- delete icon from floatbar
    win_floatBar.changePos (name, newPos)                   -- change floatBar position ("U","D","L","R")
    win_floatBar.iconCfg_txt (name, iconname, text)         -- change icon text (icon and text only)
    win_floatBar.iconCfg_img (name, iconname, img)          -- set icon image
    win_floatBar.iconCfg_blink (name, iconname, blinkOn)    -- Set blink option
    win_floatBar.show (name)                                -- Show float bar
    win_floatBar.hide (name)                                -- Hide float bar
  
  date: 08/10/2018 
  by: Raul Mungai
--]]

-- Load artworks
----------------
--css.loadImgSlide_bmp ("\\modeIcons\\buy.bmp", "selIcon_1")  

-- Global Object
win_floatBar = {}

local barWindows = {
      {
        {wname="", otype, gridSize=0, barPos="", barHeight=0, barWidth=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
      };
      {
        {wname="", otype, gridSize=0, barPos="", barHeight=0, barWidth=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
      };      
      {
        {wname="", otype, gridSize=0, barPos="", barHeight=0, barWidth=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
      };      
      {
        {wname="", otype, gridSize=0, barPos="", barHeight=0, barWidth=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
      };      
      {
        {wname="", otype, gridSize=0, barPos="", barHeight=0, barWidth=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
      };      
      {
        {wname="", otype, gridSize=0, barPos="", barHeight=0, barWidth=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
      };      
      {
        {wname="", otype, gridSize=0, barPos="", barHeight=0, barWidth=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
      };      
      {
        {wname="", otype, gridSize=0, barPos="", barHeight=0, barWidth=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
      };      
      {
        {wname="", otype, gridSize=0, barPos="", barHeight=0, barWidth=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
      };      
      {
        {wname="", otype, gridSize=0, barPos="", barHeight=0, barWidth=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
        {img="", name="", event="", gridPos=-1, wsize=0},
      };      
  }
  
  local maxwin = 10
  local maxbtn = 15
  
  local function floatBar_getCoords (barHeight, barWidth, barPos)
    local wx
    local wy
    local x
    local y
    local hideMode = ""

    if barPos == "U" then
      -- Up bar
      wx = barWidth
      wy = barHeight
      x = (sknSys.screenXsize() - barWidth) // 2
      y = 0
      hideMode = "up"
    elseif barPos == "D" then
      -- Down bar
      wx = barWidth
      wy = barHeight
      x = (sknSys.screenXsize() - barWidth) // 2
      y = sknSys.screenYsize() - barHeight
      hideMode = "down"
    elseif barPos == "L" then
      -- Left bar
      wx = barHeight
      wy = barWidth
      x = 0
      y = (sknSys.screenYsize() - wy) // 2
      hideMode = "left"
    elseif barPos == "R" then
      -- Right bar
      wx = barHeight
      wy = barWidth
      x =  sknSys.screenXsize() - (wx-1)
      y = (sknSys.screenYsize() - wy) // 2
      hideMode = "right"
    else
      return 0,0,0,0,""
    end
    return x,y,wx,wy
  end
  
  -- retrieve the bar window handle (-1 if not found)
  local function getBarWin_hnd (name)
    for i=1, maxwin do
      if barWindows[i][1].wname == name then return i end
    end
    return -1
  end

  -- retrieve the icon handle (-1 if not found)
  local function getBaricon_hnd (winHnd, iname)
    for ii=2, maxwin+1 do
      if barWindows[winHnd][ii].name == iname then return ii end
    end
    return -1
  end

  -- retrieve window and icon handles
  local function getBarWin_icon_hnd (name, iconname)
    local wname = "$fbar_" .. name
    local i = getBarWin_hnd(name)
    if i == -1 then return -1,-1 end
    local ii = getBaricon_hnd (i, iconname)
    return i, ii
  end
  
  -- reorder float bar icons
  local function reorder (winHnd)  
    if winHnd < 1 then return end
    gridSize = barWindows[i][1].gridSize
    barPos = barWindows[i][1].barPos
    wx,wy = sknWin.size ("$fbar_" .. barWindows[i][1].wname)   -- get window size
    gcur = 0
    for xx=2, maxbtn do
      if barWindows[i][xx].name ~= "" then
        btnname = "$btnbar_" .. barWindows[i][xx].name
        otype = barWindows[i][xx].otype
        gpcur = gridSize * barWindows[i][xx].gridPos
        gpcur = gpcur - (barWindows[i][xx].wsize // 2)        -- center to grid
  
        if barPos == "U" or barPos == "D" then
          -- Up-Down bar
          if otype == "ibtn" or otype == "ibtnT" then
            sknIbtn.pos (btnname, gpcur, 0)
          end
        elseif barPos == "L" or barPos == "R" then
          -- Left-Right bar
          if otype == "ibtn" or otype == "ibtnT" then
            sknIbtn.pos (btnname, 0, gpcur)
          end
        else
          return    -- unsupported position bar
        end    
      end
    end
  end
  
  -- assign bar position (reassign)
  local function assignBarPos (i, barPos)
    if i < 1 or i > maxwin then return end    -- invaliud win hnd

    if barWindows[i][1].wname == "" then return end
    local x,y,wx,wy,hidemode = floatBar_getCoords (barWindows[i][1].barHeight, barWindows[i][1].barWidth, barPos)
    if wx == 0 and wy == 0 then return end
    
    local wname = "$fbar_" .. barWindows[i][1].wname
    barWindows[i][1].barPos = barPos  
    
    sknWin.pos (wname, x, y)  
    sknWin.size (wname, wx, wy)  
    reorder (i)
  end
  
  -- assign icon : return 1= success, 0=error
  local function icon_set_img (winHnd, iconHnd, img)
    if winHnd > maxwin or iconHnd > maxbtn +1 then return 0 end
    if barWindows[winHnd][1].wname == "" or barWindows[winHnd][iconHnd].name == "" then return 0 end
    
    local btnname = "$btnbar_" .. barWindows[winHnd][iconHnd].name
  
    local imgXsize, imgYsize = sknColl.imgSize ("btn", img)
    if imgXsize == 0 then return 0 end
  
    
    if idx == -1 then return end    -- end of memory
    barWindows[winHnd][iconHnd].img = img
    barWindows[winHnd][iconHnd].wsize = imgXsize 
    
    local otype = barWindows[winHnd][iconHnd].otype
    if otype == "ibtn" or otype == "ibtnT" then
      thema.ibtn_set_imgs(btnname, img)
    else
      return 0
    end
    return 1
  end
  
  -- set icon blink
  local function icon_set_blink (winHnd, iconHnd, blinkOn)
    if winHnd > maxwin or iconHnd < 1 or iconHnd > maxbtn +1 then return end
    if barWindows[winHnd][1].wname == "" or barWindows[winHnd][iconHnd].name == "" then return end
  
    local btnname = "$btnbar_" .. barWindows[winHnd][iconHnd].name
      
    local otype = barWindows[winHnd][iconHnd].otype
    if otype == "ibtn" or otype == "ibtnT" then
      sknIbtn.blinkEn(btnname, blinkOn)
    else
      return
    end
    return
  end
  
  -- get new icon handle (return winHnd, iconHnd) -1, -1 == No space or object already exists
  local function getNewIcon_hnd (name, newIconName)
    
      -- check for Window exists
    local i = getBarWin_hnd(name)
    if i == -1 then return -1, -1 end      -- invalid window name
    
    -- Check for Button already exists
    local ix
    for ix=2, maxbtn+1 do
      if barWindows[i][ix].name == newIconName then return -1, -1 end   -- button already exists
    end

    -- find free selector index
    local idx = -1
    for ix=2, maxbtn+1 do
      if barWindows[i][ix].name == "" then 
        idx = ix
        break
      end
    end
    if idx == -1 then return  -1, -1 end    -- end of memory  
    return i, idx
  end
  
    
  -- floatBar create
  -- set TO = 0 for AutoHide disable
  function win_floatBar.create (name, color, barHeight, barWidth, barPos, gridSize, TO)
    if name == nil then return end
    -- check for existing window
    local wname = "$fbar_" .. name
    local x,y,wx,wy,hidemode = floatBar_getCoords (barHeight, barWidth, barPos)
    if wx == 0 and wy == 0 then return end
    
    i = 1
    while( true )
    do
      --if barWindows[i].name == nil then break end
      if barWindows[i][1].wname == nil then return end
      if barWindows[i][1].wname == "" then break end
      if barWindows[i][1].wname == name then return end    -- name duplicate
      i = i + 1
    end
      
    -- i = current free index
    barWindows[i][1].wname = name
    barWindows[i][1].gridSize = gridSize
    barWindows[i][1].barPos = barPos 
    barWindows[i][1].barHeight = barHeight
    barWindows[i][1].barWidth = barWidth
    
    sknWin.create (wname, x, y, wx, wy)
    sknWin.bgcolor (wname, color)
    
    -- clear button structure
    for xx=2, maxbtn do
      barWindows[i][xx].name = ""
    end
    
    --Auto hide
    if TO > 0 then
      sknWin.autoHide(wname, true)
      sknWin.autoHideMode (wname, hidemode)
      sknWin.autoHideTO (wname, TO)
      sknWin.aniMode (wname, "shift")
      sknWin.aniEn (wname, false)
    end
  end
  
  -- floatBar create
  -- set TO = 0 for AutoHide disable
  function win_floatBar.delete (name)
    if name == nil then return end
    -- check for existing window
    local wname = "$fbar_" .. name
    local i = getBarWin_hnd (name)
    if i == -1 then return end
    
    barWindows[i][1].wname = ""     -- free window
    for ii=2, maxwin+1 do
      if barWindows[i][ii].name ~= "" then
        win_floatBar.delIcon (name, barWindows[i][ii].name)   -- remove icon
      end
    end
    
    sknWin.delete (wname)           -- window remove
  end

  -- Add icon to float bar
  function win_floatBar.addIcon (name, iname, event, img, gridPos)
    if name == "" or iname == nil or img == nil or gridPos == nil then return end
    local wname = "$fbar_" .. name
    local otype = "ibtn"
  
    local imgXsize, imgYsize = sknColl.imgSize ("btn", img)
    if imgXsize == 0 then return end
  
    -- get new icon handle
    local i, idx = getNewIcon_hnd (name, iname)
    if idx == -1 or i == -1 then return end    -- end of memory or icon already exists  
    
    barWindows[i][idx].name = iname
    barWindows[i][idx].otype = otype
    barWindows[i][idx].event = event
    barWindows[i][idx].gridPos = gridPos
  
    local btnname = "$btnbar_" .. iname
    sknIbtn.create (btnname, wname, 0, 0, 0, 0)
    icon_set_img (i, idx, img)
    sknIbtn.keyReleaseCB(btnname, event)
    sknIbtn.show(btnname)
    
    reorder (i)
  end
  
  -- Delete icon from float bar
  function win_floatBar.delIcon (name, iname)
    if name == "" or iname == nil then return end
    
    local i, ii = getBarWin_icon_hnd (name, iname)
    if ii == -1 or i == -1 then return end
  
    barWindows[i][ii].name = ""
    barWindows[i][ii].otype = ""
    barWindows[i][ii].event = ""
    barWindows[i][ii].gridPos = 0

    -- apply change
    sknIbtn.delete("$btnbar_" .. iname)
    reorder (i)
  end
  
  -- Add icon + text to float bar (like Email notifications)
  function win_floatBar.addIconText (name, iname, txt, txtColor, font, txtOffsX, txtOffsY, event, img, gridPos)
    if name == "" or iname == nil or img == nil or gridPos == nil then return end
    local wname = "$fbar_" .. name
    local otype = "ibtnT"
    local imgXsize, imgYsize = sknColl.imgSize ("btn", img)
    if imgXsize == 0 then return end
  
    -- get new icon handle
    local i, idx = getNewIcon_hnd (name, iname)
    if idx == -1 or i == -1 then return end    -- end of memory or icon already exists   
    
    barWindows[i][idx].name = iname
    barWindows[i][idx].otype = otype
    barWindows[i][idx].event = event
    barWindows[i][idx].gridPos = gridPos
  
    local btnname = "$btnbar_" .. iname
    sknIbtn.create (btnname, wname, 0, 0, 0, 0)
    icon_set_img (i, idx, img)
    sknIbtn.font (btnname, font)
    sknIbtn.txtcolors(btnname, txtColor, txtColor)
    sknIbtn.txtBGcolors(btnname, sknSys.getColor("transparent"), sknSys.getColor("transparent"))
    sknIbtn.txtOffset(btnname, txtOffsX, txtOffsY)
    sknIbtn.text(btnname, txt)
    sknIbtn.keyReleaseCB(btnname, event)
    sknIbtn.show(btnname)
    
    reorder (i)
  end

  function win_floatBar.changePos (name, newPos)
    if barPos ~= "U" and barPos ~= "D" and barPos ~= "L" and barPos ~= "R" then return end
    local wname = "$fbar_" .. name
    local i = getBarWin_hnd(name)
    if i == -1 then return end
    assignBarPos (i, newPos)
  end

  -- configure icon image
  function win_floatBar.iconCfg_img (name, iconname, img)
    local i, ii = getBarWin_icon_hnd (name, iconname)
    if ii == -1 or i == -1 then return end
    
    -- apply change
    icon_set_img (i, ii, img)
    reorder (i)
  end
  
  -- set icon (and text) text
  function win_floatBar.iconCfg_txt (name, iconname, text)
    local i, ii = getBarWin_icon_hnd (name, iconname)
    if ii == -1 or i == -1 then return end
    
    -- apply change
    if barWindows[i][idx].otype == "ibtnT" then
      sknIbtn.text("$btnbar_" .. iconname, text)
      reorder (i)
    end
  end

  -- configure icon blink
  function win_floatBar.iconCfg_blink (name, iconname, blinkOn)
    local i, ii = getBarWin_icon_hnd (name, iconname)
    if ii == -1 or i == -1 then return end
    -- apply change
    icon_set_blink (i, ii, blinkOn)
    reorder (i)
  end

  function win_floatBar.show (name)
    local wname = "$fbar_" .. name
    sknWin.show (wname)
    sknWin.bringTop(wname)
    --sknSys.tpFinemove("", "", "win_floatBar.left", "win_floatBar.right")
  end

  function win_floatBar.hide (name)
    local wname = "$fbar_" .. name
    --sknSys.tpFinemove("", "", "", "")
    sknWin.hide (wname)
  end
  
  
  -------- DEMO -----------------------
  function win_floatBar.demoE1 (name)
    print ("Evento1:", name)
  end
  
  function win_floatBar.demoE2 (name)
    print ("Evento2:", name)
  end

  function win_floatBar.demoE3 (name)
    print ("Evento3:", name)
  end
  
  function win_floatBar.demo ()
    
  css.loadImgMulti_png ("\\__btns\\chat",    "chat")
  css.loadImgMulti_png ("\\__btns\\home",    "home")
  css.loadImgMulti_png ("\\__btns\\back",    "back")
  css.loadImgMulti_png ("\\__btns\\usr",    "usr")
  css.font_mount (thema.workDisk .. "\\F8_1_S.txt", "F8")
  
  win_floatBar.create ("F1", sknSys.getColor("green"), 55, 250, "U", 48, 15000)
  win_floatBar.show("F1")

  win_floatBar.addIcon ("F1", "b1", "win_floatBar.demoE1", "chat", 1)
  win_floatBar.addIcon ("F1", "b2", "win_floatBar.demoE2", "home", 2)
  win_floatBar.addIconText ("F1", "bt2", "14", sknSys.getColor("white"), "F8", 30, 5, "win_floatBar.demoE3", "usr", 3)
    
  win_floatBar.iconCfg_blink ("F1", "b2", true)
  
  end
  
  function win_floatBar.demoMove ()
  
  for i=0, 2 do
      win_floatBar.changePos ("F1", "R")
      os.sleep(5000)
      win_floatBar.changePos ("F1", "L")
      os.sleep(5000)
      win_floatBar.changePos ("F1", "U")  
      os.sleep(5000)
      win_floatBar.changePos ("F1", "D")  
      os.sleep(5000)
  end
  
    
  end
  
  

