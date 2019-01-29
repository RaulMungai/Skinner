
-------------------------------------------------------------------
---------------------------  Hourglass  ---------------------------
-------------------------------------------------------------------
--[[
  Hourglass
  
    hourglass.show ()            -- Show
    hourglass.hide ()            -- Hide
    hourglass.pos (x,y)          -- Position set

  date: 16/10/2018 
  by: Raul Mungai
--]]


  
  
-- Load artworks
----------------

sknColl.addImgColl ("ani", 20, 100000)    -- specific image collection

-- wait icon whell
sknColl.imgAdd ("ani", thema.workDisk .. "res\\anim\\whell\\wheel1.bmp", "wait1", false, false)
sknColl.imgAdd ("ani", thema.workDisk .. "res\\anim\\whell\\wheel2.bmp", "wait2", false, false)
sknColl.imgAdd ("ani", thema.workDisk .. "res\\anim\\whell\\wheel3.bmp", "wait3", false, false)
sknColl.imgAdd ("ani", thema.workDisk .. "res\\anim\\whell\\wheel4.bmp", "wait4", false, false)
sknColl.imgAdd ("ani", thema.workDisk .. "res\\anim\\whell\\wheel5.bmp", "wait5", false, false)
sknColl.imgAdd ("ani", thema.workDisk .. "res\\anim\\whell\\wheel6.bmp", "wait6", false, false)
sknColl.imgAdd ("ani", thema.workDisk .. "res\\anim\\whell\\wheel7.bmp", "wait7", false, false)
sknColl.imgAdd ("ani", thema.workDisk .. "res\\anim\\whell\\wheel8.bmp", "wait8", false, false)
  
-- Global Object
hourglass = {}

  local winname = "winHglass"     -- window name
  local aniimg = "hglassanim"     -- animated image collection  name
  local iani = "hrglass_mimg"     -- animated image

  local function win_hourglass_create ()
    local iX, iY = sknColl.imgSize("ani", "wait8")
    sknWin.create (winname, 0, 0, iX, iY)
    sknWin.bgcolor (winname, sknSys.getColor("darkgray"))
    sknWin.pos (winname, (sknSys.screenXsize()//2)-(iX//2), (sknSys.screenYsize()//2)-(iY//2))
    

    sknMimage.new (iani) 
  
    -- cfg animated image
    sknMimage.addimage (iani, "ani", "wait1")
    sknMimage.addimage (iani, "ani", "wait2")
    sknMimage.addimage (iani, "ani", "wait3")
    sknMimage.addimage (iani, "ani", "wait4")
    sknMimage.addimage (iani, "ani", "wait5")
    sknMimage.addimage (iani, "ani", "wait6")
    sknMimage.addimage (iani, "ani", "wait7")
    sknMimage.addimage (iani, "ani", "wait8")
    sknMimage.showtime (iani, 200)
    
    sknAnimage.create(aniimg, winname, 0, 0, iX, iY)
    sknAnimage.multiimage(aniimg, iani)
    --sknAnimage.show(aniimg)  
  end

  
  function hourglass.show ()
    sknWin.modal(winname, true)
    --sknAnimage.aniEn(aniimg, true)
    sknAnimage.show(aniimg)
    sknWin.show (winname)
  end

  function hourglass.hide ()
    sknWin.modal(winname, false)
    --sknAnimage.aniEn(aniimg, false)
    sknAnimage.hide(aniimg)
    sknWin.hide (winname)
  end

  function hourglass.pos (x,y)
    sknWin.pos (winname, x,y)
  end
  
win_hourglass_create ()   -- Window creation
