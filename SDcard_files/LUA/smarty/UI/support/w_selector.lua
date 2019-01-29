
-------------------------------------------------------------------
---------------------------  window:selector  ---------------------
-------------------------------------------------------------------
--[[
  Special Window shortcut display bar
  Allow to add or remove dinamically selector buttons
  Show Slide Windows (Horizontal and Vertical)
  
  Selector:
    win_selector.setWinHeight (winH)                                     -- selection bar height
    win_selector.add (name, fShow, fHide, fPos, slideEn)                 -- Add icon (needed "lay_" .. name image, coll: "LAYOUT"
    win_selector.remove (name)                                           -- remove icon
  
  Window slider:
    win_selector.showNext ()                                             -- Show next Slide Window
    
    -- internal Use (not Only)
    win_selector.left (val)                                              -- move Bar : left (used by gesture callback)
    win_selector.right (val)                                             -- move Bar : right (used by gesture callback)
    win_selector.cbSel (objName)                                         -- Selection event (used by icon keyRelease event)

  date: 04/10/2018 
  by: Raul Mungai
--]]

-- Load artworks
----------------
css.load_btn_img ("\\buttons\\slidewin.png",    "selector")     -- app icon


-- Global Object
win_selector = {}

  local selector =  {
      {show, hide, pos, img="", collImg="", name="", slideEn=false};
      {show, hide, pos, img="", collImg="", name="", slideEn=false};
      {show, hide, pos, img="", collImg="", name="", slideEn=false};
      {show, hide, pos, img="", collImg="", name="", slideEn=false};
      {show, hide, pos, img="", collImg="", name="", slideEn=false};
      {show, hide, pos, img="", collImg="", name="", slideEn=false};
      {show, hide, pos, img="", collImg="", name="", slideEn=false};
      {show, hide, pos, img="", collImg="", name="", slideEn=false};
      {show, hide, pos, img="", collImg="", name="", slideEn=false};
      {show, hide, pos, img="", collImg="", name="", slideEn=false};
      {show, hide, pos, img="", collImg="", name="", slideEn=false};
      {show, hide, pos, img="", collImg="", name="", slideEn=false};
      {show, hide, pos, img="", collImg="", name="", slideEn=false};
      {show, hide, pos, img="", collImg="", name="", slideEn=false};
      {show, hide, pos, img="", collImg="", name="", slideEn=false};
      {show, hide, pos, img="", collImg="", name="", slideEn=false};
      {show, hide, pos, img="", collImg="", name="", slideEn=false};
      {show, hide, pos, img="", collImg="", name="", slideEn=false};
      {show, hide, pos, img="", collImg="", name="", slideEn=false};
      {show, hide, pos, img="", collImg="", name="", slideEn=false};
      {show, hide, pos, img="", collImg="", name="", slideEn=false};
      {show, hide, pos, img="", collImg="", name="", slideEn=false};
      {show, hide, pos, img="", collImg="", name="", slideEn=false};
      {show, hide, pos, img="", collImg="", name="", slideEn=false};
      {show, hide, pos, img="", collImg="", name="", slideEn=false};
      {show, hide, pos, img="", collImg="", name="", slideEn=false};
      {show, hide, pos, img="", collImg="", name="", slideEn=false};
      {show, hide, pos, img="", collImg="", name="", slideEn=false};
      {show, hide, pos, img="", collImg="", name="", slideEn=false};
      {show, hide, pos, img="", collImg="", name="", slideEn=false};
      {show, hide, pos, img="", collImg="", name="", slideEn=false};
      }
  
  local slideHor = true
  local selWinH = 55
  
  -- reorder bar icons
  --function win_selector.reorder ()
  local function reorder ()
    -- find start and end icon index
    idx = -1
    idxS = -1
    for i=1, 30 do
      if selector[i].name ~= "" then 
        idx = i 
        if idxS == -1 then idxS = i end
      end
    end
  
    imgXsize = 0
    imgYsize = 0
    xCurr = 0
    for i=idxS, idx do
      if selector[i].name ~= "" then 
        xCurr = xCurr + imgXsize
        sknIbtn.pos("btn_sel_" .. tostring (i), xCurr, 0)
        imgXsize, imgYsize = sknColl.imgSize (selector[i].collImg, selector[i].img)  
      end    
    end
  end
  
  function win_selector.add (name, fShow, fHide, fPos, slideEn)
    if name == "" or fShow == nil or fHide == nil or fPos == nil then return end
  
    local img = "lay_" .. name
    local collImg = "LAYOUT"
    local imgXsize, imgYsize = sknColl.imgSize (collImg, img)
    if imgXsize == 0 then 
      print ("win_selector.add ERROR : unable to find image " .. img .. " from LAYOUT collection")
      return 
    end
  
    -- check for already exists
    for i=1, 30 do
      if selector[i].name == name then 
        print ("win_selector.add ERROR : the name " .. namne .. " already exists")
        return 
      end
    end

    -- find free selector index
    idx = -1
    for i=1, 30 do
      if selector[i].name == "" then 
        idx = i
        break
      end
    end
    
    if idx == -1 then return end
    
    selector[idx].name = name
    selector[idx].hide = fHide
    selector[idx].show = fShow
    selector[idx].img = img
    selector[idx].collImg = collImg
    selector[idx].pos = fPos
    if slideEn ~= nil then 
      selector[idx].sliden = slideEn
    else
      selector[idx].sliden = false
    end
    
    sknIbtn.create ("btn_sel_" .. tostring (idx), "winSelMode", 0, 0, 0, 0)
    sknIbtn.imgpress ("btn_sel_" .. tostring (idx), 0, collImg, img)
    sknIbtn.imgunpress ("btn_sel_" .. tostring (idx), 0, collImg, img)
    --sknIbtn.imgdisabled ("btn_sel_" .. tostring (idx), 0, collImg, img)
  
    sknIbtn.auxData("btn_sel_" .. tostring (idx), idx)
    
    sknIbtn.keyReleaseCB("btn_sel_" .. tostring (idx), "win_selector.cbSel")
    sknIbtn.show("btn_sel_" .. tostring (idx))
    --win_selector.reorder ()
    reorder ()
  end
  
  
  function win_selector.remove (name)
    if name == "" then return end
  
    for i=1, 30 do
      if selector[i].name == name then 
        selector[i].name = ""
        --selector[i].hide = nil
        --selector[i].show = nil
        selector[i].img = ""
        selector[i].collImg = "" 
        sknIbtn.delete("btn_sel_" .. tostring (i))
        --win_selector.reorder ()
        reorder ()
        return 
      end
    end
  end
  
  local function moveBtns (side, val)
    -- find start and end icon index
    idx = -1
    idxS = -1
    for i=1, 30 do
      if selector[i].name ~= "" then 
        idx = i 
        if idxS == -1 then idxS = i end
      end
    end
    
    if idx == -1 or idxS == -1 then return end
    
    local imgXsize, imgYsize = sknColl.imgSize (selector[idxS].collImg, selector[idxS].img)

    -- check for end of move
    if side == "left" then
      local  xe,ye = sknIbtn.pos("btn_sel_" .. tostring(idx))
      if xe + imgXsize <= sknSys.screenXsize() then return end
    else
      local  xe,ye = sknIbtn.pos("btn_sel_" .. tostring(idxS))
      if xe >= 0 then return end
    end

    for i=1, idx do
      if selector[i].name ~= "" and selector[i].sliden == true then 
        local x,y = sknIbtn.pos("btn_sel_" .. tostring (i))
        if side == "left" then
          sknIbtn.pos("btn_sel_" .. tostring (i), x-30, y)
        else
          sknIbtn.pos("btn_sel_" .. tostring (i), x+30, y)
        end
      end
    end
  end
  
  -- Gesture callbacks
  function win_selector.left (val)
    moveBtns ("left", val)
  end
  
  function win_selector.right (val)
    moveBtns ("right", val)
  end
  
  -- Selection event
  function win_selector.cbSel (objName)
    ii = sknIbtn.auxData (objName)
    win_selector.hide ()
    if selector[ii].name ~= "" then 
      selector[ii].show()
    end
  end

  local function selmode_create ()
    sknWin.create ("winSelMode", 0, sknSys.screenYsize()-selWinH, sknSys.screenXsize(), selWinH)
    
    --sknWin.bgcolor ("winSelMode", thema.bg_color)
    sknWin.bgcolor("winSelMode", sknSys.getColor("white"))

    --Auto hide
    sknWin.autoHide("winSelMode", true)
    sknWin.autoHideMode ("winSelMode", "down")
    sknWin.autoHideTO ("winSelMode", 20000)
  end

  -- set Window height
  function win_selector.setWinHeight (winH)
    if winH == nil then
      return selWinH
    end
    
    if winH > 0 and selWinH <= sknSys.screenYsize() then
      selWinH = winH
      sknWin.size ("winSelMode", sknSys.screenXsize(), selWinH)
      sknWin.pos ("winSelMode", 0, sknSys.screenYsize() - selWinH)
    end
    
  end
  
  function win_selector.show ()
    sknWin.show ("winSelMode")
    sknWin.bringTop("winSelMode")
    sknSys.tpFinemove("", "", "win_selector.left", "win_selector.right")
  end

  function win_selector.hide ()
    sknSys.tpFinemove("", "", "", "")
    sknWin.hide ("winSelMode")
  end

  -- Windopw Show
  local currWinID = -1
  local maxWinID = 1
  local moveStep = 30
  local moveDelay = 100
  

  function win_selector.showNext ()
    -- find start and end icon index
    idx = -1
    idxS = -1
    for i=1, 30 do
      if selector[i].name ~= "" and selector[i].sliden == true then 
        idx = i 
        if idxS == -1 then idxS = i end
      end
    end
    
    if idx == -1 or idxS == -1 then return end
    maxWinID = idx
    
    local newwID
    if currWinID == -1 then
      newwID = idxS
    else
      newwID = currWinID + 1
    end
    
    if newwID > maxWinID then newwID = 1 end
    if currWinID == -1 then newwID = 1 end
    
    for i=newwID, idx do
      if selector[i].name ~= "" and selector[i].sliden == true then 
        if currWinID == -1 then
          -- First run
          selector[i].show()
          currWinID = i
          return
        else
          newwID = i
          fo = selector[currWinID].pos
          foh = selector[currWinID].hide
          fn = selector[newwID].pos
          fns = selector[newwID].show
          break
        end
      end
    end
    
    -- Move action
    if slideHor == true then
      -- Slide Horizontal
      xn = moveStep - sknSys.screenXsize()
      fn(xn,0)
      fns()
      for x=moveStep, sknSys.screenXsize(), moveStep do
        fo(x,0)
        fn(xn,0)
        xn = xn + moveStep
        os.sleep(moveDelay)
      end
      fn(0,0)     -- fit to window 
      foh()       -- hide old window
      fo(0,0)     -- restore default position
      
    else
      -- Slide Vertical
      yn = moveStep - sknSys.screenYsize()
      fn(xn,0)
      fns()
      for y=moveStep, sknSys.screenYsize(), moveStep do
        fo(0,y)
        fn(0,yn)
        yn = yn + moveStep
        os.sleep(moveDelay)
      end
      fn(0,0)     -- fit to window 
      foh()       -- hide old window
      fo(0,0)     -- restore default position       
    end
    
    currWinID = newwID
  end
  
  -- Select slide direction (Horizontal or Vertical)
  function win_selector.slideHor (slideHorDir)
      slideHor = slideHorDir
  end
  
  
  
  function win_selector.demo ()
    for i=0,20 do
      win_selector.showNext ()
      os.sleep(1000)
    end
  end
  
  
selmode_create ()   -- Window creation
