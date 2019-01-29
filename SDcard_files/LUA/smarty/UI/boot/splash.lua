-------------------------------------------------------------------
---------------------------  window:Splash screen  ----------------
-------------------------------------------------------------------

-- Load UI basics elements
-- Image Collection "btn"=unpressed, "btnP"=pressed
-- Set Language and Thema

-- Mount fonts
--css.font_mount (thema.workDisk .. "\\F32B_1_S.txt", "F32B")

-- Background image
--[[
if thema.language == "ITA" then
  sknColl.imgAdd ("BG", thema.workDisk .. "\\boot\\spl0ITA.bmp", "splash", false, false)
elseif thema.language == "ENG" then
  sknColl.imgAdd ("BG", thema.workDisk .. "\\boot\\spl0ENG.bmp", "splash", false, false)
elseif thema.language == "ESP" then
  sknColl.imgAdd ("BG", thema.workDisk .. "\\boot\\spl0ESP.bmp", "splash", false, false)
elseif thema.language == "FRA" then
  sknColl.imgAdd ("BG", thema.workDisk .. "\\boot\\spl0FRA.bmp", "splash", false, false)
elseif thema.language == "TED" then
  sknColl.imgAdd ("BG", thema.workDisk .. "\\boot\\spl0TED.bmp", "splash", false, false)
else
  -- undefined
  sknColl.imgAdd ("BG", thema.workDisk .. "\\boot\\spldef.bmp", "splash", false, false)
end
--]]

sknColl.imgAdd ("BG", thema.workDisk .. "\\boot\\bgiot.bmp", "splash", false, false)
  

-- Global Object
win_splash = {}

-- Splash screen
function win_splash.create()

  sknWin.create ("splash", 0, 0, sknSys.screenXsize(), sknSys.screenYsize())
  sknWin.bgcolor ("splash", sknSys.getColor("GUI_WHITE"))

  ix,iy = sknWin.size("splash")
  sknImg.create ("bgimage", "splash", 0, 0, ix, iy) 
  sknImg.image("bgimage", "BG", "splash")
  sknImg.show("bgimage")

  -- Label
  --[[
  sknLbl.create ("lab1", "bgimage", 20, 50, ix-40, 50, "HorCenter_VertCenter", "WAIT for Loading ...") 
  sknLbl.font("lab1", "F32B")
  sknLbl.transp("lab1", true) 
  sknLbl.show("lab1")
  --]]

  -- Progress bar
  local xwin, ywin = sknWin.size("splash")
  sknProgbar.create ("loadPb", "bgimage", 0, ywin-13, xwin, 13)
  sknProgbar.setlimits ("loadPb", 0, 100, 0) 
  sknProgbar.show("loadPb")

  sknWin.show ("splash")
end

  function win_splash.destroy()

    --sknLbl.delete("lab1")
    sknImg.delete ("bgimage")
    sknProgbar.delete ("loadPb")
    sknWin.delete ("splash")
  end


  function win_splash.loadProgress(progValue)
    sknProgbar.setvalue ("loadPb", progValue)
  end



-- Splash screen display
win_splash.create()
