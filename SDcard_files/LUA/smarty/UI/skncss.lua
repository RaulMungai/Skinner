-------------------------------------------------------------------
---------------------------  CSS management  ----------------------
-------------------------------------------------------------------

--[[
  CSS
  
  windows:
    css.window_new (winName[, show[, help[,bgImage[,bgColor] ] ] ])      -- Window new, [image fron "BG" coll] 
                                                                                (return the win parent)

    css.window_delete (winName,bgImageActive)                 -- Window : remove 
    css.window_set_bgImage (winName, bgImage)                 -- Window : set background image fron "BG" coll
  
  Window Title:
    css.window_title_new (winname, text[, color[, enDefButtons[, userwin] ] ]) -- window title create: return label name
     
    css.window_title_delete (winname, enDefButtons)                -- css: window-caption delete
    css.window_title (winname[, text])                             -- window-caption set/get
    css.window_title_colorset (winname, color)                     -- window-caption set color

    css.window_title_btnCfg (winname, btnID, image, event[, help]) -- window-caption set buttons (btnID = 1,2,3,4)
                                                                         new or reconfigure
  
    css.window_title_btnSlected (winname, btnID, btnSelected)   -- css: window-caption set button selection state
    css.window_title_defButtons (winname)                       -- css: window-title default buttons
                                                                          (btnID = 1,2,3,4)
    css.window_title_expand (winname, expanded)                    -- window-caption expand - reduce
    
    internals:
      css.titleResize ()                                      -- window title resize request event
  
  icon buttons:
    css.button_new (name, winName, x, y, image, 
      event, show, autoHide [, text [,textColor] ])           -- button create: return button size or 0,0
    css.button_icon_set (name, icon)                          -- button set icon: return icon size or 0,0
    css.button_help_set (name, help)                          -- set button help
    css.button_move (name, x, y)                              -- move button
    css.button_show (name)                                    -- button show
    css.button_hide (name)                                    -- button hide
    css.button_set_autoHide (name, timeout, mode)             -- auto hide button configuration
    css.button_remove (name)                                  -- remove button
    
  text buttons:
    css.button_txt_new (name, winName, x, y, Wsize, Hsize, 
      text, font, color, pressColor, txtAlign, 
      bgcolor, event, show)                                           -- text button create: return button size or 0,0
      
  application:
    css.appButton_new (winRadix, winname, x, y
      [, text [,textColor] ])                                        -- Create app button (winRadix example [win_home] = "home" 
  
  tools:
    css.load_btn_img (fname, name)                                   -- load button images to "btn", "btnP", "btnD" collections
    
  images:
    css.load_img (fname, name, collection)                           -- load image to collection
    
  font:
    css.font_mount (fontFile, name)                                     -- mount font

  date: 18/10/2018 
  by: Raul Mungai
--]]


-- Global Object
css = {}

  -- Get filename and extension
  local function GetFileName(url)
    return url:match("^.+\\(.+)$")
  end

  -- Get file extension
  local function GetFileExtension(url)
    return url:match("^.+(%..+)$")
  end
  
  -- Get complete filename without extension
  local function GetFileNoExtension(url)
    return url:match("(.+)%..+")
  end
  
  
  -- Window : new
  function css.window_new (winName, show, help, bgImage, bgColor)
    sknWin.create (winName, 0, 0, sknSys.screenXsize(), sknSys.screenYsize())
    if bgColor == nil then
      sknWin.bgcolor (winName, thema.win_bg_color)
    else
      sknWin.bgcolor (winName, bgColor)
    end
    
    local winnameI = "$bg$" .. winName
    if bgImage ~= nil then
      -- background image
      sknImg.create (winnameI, winName, 0, 0, sknSys.screenXsize(), sknSys.screenYsize()) 
      sknImg.image(winnameI, "BG", bgImage)
      sknImg.show(winnameI)
      imgBG = true
    end

    if show ~= nil then
      if show == true then
        sknWin.show (winName)	
      end
    end
        
    local parent = winName
    if bgImage ~= nil then
      if bgImage ~= "" then
        parent = winnameI
      end
    end
    
    if help ~= nil then
      sknWin.longTouchCB(parent, help)
    end
    
    return parent
  end
  
  -- Window : remove 
  function css.window_delete (winName,bgImageActive)
    if bgImageActive == true then
      local winnameI = "$bg$" .. winName
      sknImg.delete (winnameI)
    end
    sknWin.delete (winName)
  end
  
  -- Window : set background image
  function css.window_set_bgImage (winName, bgImage)
    local winnameI = "$bg$" .. winName
    sknImg.image(winnameI, "BG", bgImage)
  end
  
  
  ------------ BUTTONS -------------
--[[
  -- set button images (supported type: "itbtn", ibtn")
  local function css_btn_set_imgs(wname, imgName, btnType, imgIdx)
    if imgIdx == nil then
      imgIdx = 0
    end
    if btnType == "itbtn" then
      sknITbtn.imgpress (wname, imgIdx, "btnP", imgName)
      sknITbtn.imgunpress (wname, imgIdx, "btn", imgName)
      sknITbtn.imgdisabled (wname, imgIdx, "btnD", imgName)
    elseif btnType == "ibtn" then
      sknIbtn.imgpress (wname, imgIdx, "btnP", imgName)
      sknIbtn.imgunpress (wname, imgIdx, "btn", imgName)
      sknIbtn.imgdisabled (wname, imgIdx, "btnD", imgName)
    end
    
    local imgXsize, imgYsize = sknColl.imgSize ("btn", imgName)
    return imgXsize, imgYsize
  end
  --]]
  
  
  -- Button : new (optional text, textColor) : return button size or 0,0
  function css.button_new (btnname, winName, x, y, image, event, show, autoHide, text, textColor)
    local iX, iY = sknColl.imgSize("btn", image)
    if iX == 0 then 
      print ("missing icon on css.button_new:" .. " window:" .. winName .. " image:" .. image .. " button:" .. btnname)
      return 0,0
    end
    
    if sknIbtn.create (btnname, winName, x, y, 0, 0) == 0 then 
      print ("Unable to create button:" .. btnname .. " window:" .. winName)
      return 0,0
    end
    
    -- option text
    if text ~= nil then
      -- create botom text
      sknLbl.create(btnname .. "$t", winName, x-iX, y + iY + 1, iX*3,  thema.btn_lbl_height, thema.btn_txtalign, text)
      sknLbl.font(btnname .. "$t", thema.btn_txtalign)
      local tcolor = thema.btn_txtcolor
      if textColor ~= nil then
        tcolor = textColor
      end
      
      sknLbl.colors(btnname .. "$t", tcolor, thema.btn_txtbgcolor)
    end
    
    css.button_icon_set (btnname, image)
    sknIbtn.keyReleaseCB (btnname, event)
    if show ~= nil then
      if show == true then
        sknIbtn.show (btnname)	
        sknLbl.show(btnname .. "$t")
      end
    end
    return iX, iY
  end
  
  -- set button help
  function css.button_help_set (name, help)
    sknWin.longTouchCB(name, help)
  end
  
  -- set button icon: return icon size or 0,0
  function css.button_icon_set (name, icon)
    local iX, iY = sknColl.imgSize("btn", icon)
    if iX == nil then
      print ("missing icon on css.button_icon_set:" .. " name:" .. name .. " icon:" .. icon)
      return 0,0
    end
    
    if iX == 0 then 
      print ("missing icon on css.button_icon_set:" .. " name:" .. name .. " icon:" .. icon)
      return 0,0
    end
    
    sknIbtn.imgpress (name, 0, "btnP", icon)
    sknIbtn.imgunpress (name, 0, "btn", icon)
    sknIbtn.imgdisabled (name, 0, "btnD", icon)
    return iX, iY
  end

  -- show button
  function css.button_show (name)
    sknIbtn.show (name)
    sknLbl.show(name .. "$t")
  end
  
  -- move button
  function css.button_move (name, x, y)
    local iX, iY = sknWin.size(name)

    sknIbtn.pos (name, x, y)
    sknLbl.pos(name .. "$t", x-iX, y + iY + 1)
  end

  -- hide button
  function css.button_hide (name)
    sknIbtn.hide (name)
    sknLbl.hide(name .. "$t")
  end
  
  -- remove button
  function css.button_remove (name)
    sknIbtn.delete (name)
    sknLbl.delete(name .. "$t")
  end


  -- Auto hide button configuration
  function css.button_set_autoHide (name, timeout, mode)
    sknIbtn.autoHide(name, true)
    --sknIbtn.autoHideMode (name, "up")
    sknIbtn.autoHideMode (name, mode)
    --sknIbtn.aniEn (name, false)
    --sknIbtn.aniMode (name, "shift")
    sknIbtn.autoHideTO (name, timeout)
    --sknIbtn.autoHideCBhide(name, "mycCBshow")    
  end

-- text Buttons: new
  function css.button_txt_new (name, winName, x, y, Wsize, Hsize, text, font, color, pressColor, txtAlign, bgcolor, event, show)
    if sknBtn.create(name, winName, x, y, Wsize, Hsize) == 0 then
      print ("Unable to create button:" .. name .. " window:" .. winName)
      return 0,0
    end
    
    sknBtn.keyReleaseCB (name, event)
    sknBtn.txtcolors(name, color, pressColor)
    sknBtn.txtBGcolors(name, bgcolor, bgcolor)
    sknBtn.txtalign(name, txtAlign)
    sknBtn.font(name, font)
    sknBtn.text(name, text)
    
    if show ~= nil then
      if show == true then
        sknBtn.show (name)
      end
    end
    return x, y
  end
  
  -- set button images multi format (store on "btn", "btnP", "btnD" image collections)
  function css.load_btn_img (fname, name)
    fnameNoExt = GetFileNoExtension(fname)
    ext = GetFileExtension(fname)
    if fnameNoExt == nil or ext == nil then
      print ("css.load_btn_img ERROR on: " .. fname)
      return
    end
    
    if sknColl.imgSize("btn", name) == 0 then
      local transp = false
      if ext == ".png" then
        transp = true
      else
        transp = false
      end
      
      sknColl.imgAdd ("btn", thema.getDir() .. fnameNoExt  .. ext, name, false, transp)
      sknColl.imgAdd ("btnP", thema.getDir() .. fnameNoExt .. "_" .. ext, name, false, transp)
      sknColl.imgAdd ("btnD", thema.getDir() .. fnameNoExt .. "-" .. ext, name, false, transp)
    end
  end

  -- set icon image multi format
  function css.load_img (fname, name, collection)
    fnameNoExt = GetFileNoExtension(fname)
    ext = GetFileExtension(fname)
    if fnameNoExt == nil or ext == nil then
      print ("css.load_img ERROR on: " .. fname)
      return
    end
      
    if sknColl.imgSize(collection, name) == 0 then
      if ext == ".png" then
        transp = true
      else
        transp = false
      end
      
      sknColl.imgAdd (collection, thema.getDir() .. fnameNoExt  .. ext, name, false, transp)
    end
  end

  -- font mount
  function css.font_mount (fontFile, name)
    if sknColl.font_exists(name) == false then  
      if sknColl.font_mount (fontFile, name) == 0 then
        print ("css.font_mount ERROR on fontFile:" .. fontFile .. " name:" .. name)
      end
    end
  end

  --------- Make application buton (for any window)
  
  -- create button for show operation - return button size or 0,0
  function css.appButton_new (winRadix, winname, x, y, text ,textColor)
    if winRadix == nil then
      print ("css.appButton_new: winRadix = nil")
      return 0,0
    end
    
    if winname == nil then
      print ("css.appButton_new: winname = nil")
      return 0,0
    end

    local bn = "$wi" .. winRadix .. "&" .. winname
    local xx, yy = css.button_new (bn, winname, x, y, winRadix, 
        "win_" .. winRadix .. ".show", true, false, text, textColor)
    if xx == 0 and yy == 0 then
      return xx,yy
    else
      sknWin.longTouchCB(bn, "win_" .. winRadix .. ".help")     -- help callback
      return xx,yy
    end
  end
  
  -- css: window-caption expand - reduce
  function css.window_title_expand (winname, expanded)
    local ttlname = "$wt$" .. winname .. "$t"
    local wx, wy = sknWin.size(winname)
    if expanded == true then    
      sknLbl.size(ttlname, wx, thema.win_title_heightB)
      css.button_show (ttlname .. "$b1b")
      css.button_show (ttlname .. "$b2b")
      css.button_show (ttlname .. "$b3b")
      css.button_show (ttlname .. "$b4b")   
      sknImg.auxData (ttlname, 1)
    else
      sknLbl.size(ttlname, wx, thema.win_title_height)
      css.button_hide (ttlname .. "$b1b")
      css.button_hide (ttlname .. "$b2b")
      css.button_hide (ttlname .. "$b3b")
      css.button_hide (ttlname .. "$b4b")
      sknLbl.auxData (ttlname, 0)
    end
  end
  
  -- css: window-caption : return object name
  function css.window_title_new (winname, text, color, enDefButtons, userwin)
    local wx, wy = sknWin.size(winname)
    local ttlname = "$wt$" .. winname .. "$t"
    sknLbl.create(ttlname, winname, 0, 0, wx, thema.win_title_height, thema.win_title_align, text)
    sknLbl.font(ttlname, thema.win_title_font)
    if color == nil then
      sknLbl.colors(ttlname, thema.win_title_color, thema.win_title_bgcolor)
    else
      sknLbl.colors(ttlname, color, thema.win_title_bgcolor)
    end
    -- set expanded status
    if thema.win_title_def_showBtn == false then
      sknLbl.auxData (ttlname, 0)  
    else
      sknLbl.auxData (ttlname, 1)
    end
    sknLbl.auxStr(ttlname, winname)       -- set expanded status
    sknLbl.keyReleaseCB(ttlname, "css.titleResize")  
    local usetTbar = false
    if userwin ~= nil then 
      usetTbar = userwin
    end
    
    if enDefButtons ~= nil then
      if enDefButtons == true then  
        if usetTbar == false then
          css.window_title_defButtons (winname)
        else
          win_wintool.win_addTitle_buttons (winname)
        end
      end
    end
    
    sknLbl.show(ttlname)
    
    if thema.win_title_def_showBtn == true then
      css.window_title_expand (winname, thema.win_title_def_showBtn)
    end
    
    return ttlname
  end
  
  -- css: window-title default buttons
  function css.window_title_defButtons (winname)
    css.window_title_btnCfg (winname, 1, "back", "sknWin.showCaller")
    css.window_title_btnCfg (winname, 2, "usrwins", "win_usrwins.show", "win_usrwins.help")
    --css.window_title_btnCfg (winname, 3, "wmodify", "win_wmodify.show", "win_wmodifyXXX.help")
    css.window_title_btnCfg (winname, 4, "settings", "win_settings.show", "win_wmodify.help")
  end
  
  -- css: window-caption delete
  function css.window_title_delete (winname)
    local ttlname = "$wt$" .. winname .. "$t"
    local btnName = ttlname .. "$b"
    css.button_remove (btnName .. "1" .. "b")
    css.button_remove (btnName .. "1")
    css.button_remove (btnName .. "2" .. "b")
    css.button_remove (btnName .. "2")
    css.button_remove (btnName .. "3" .. "b")
    css.button_remove (btnName .. "3")
    css.button_remove (btnName .. "4" .. "b")
    css.button_remove (btnName .. "4")
    sknLbl.delete(ttlname)
  end
  
  -- css: window-caption set/get
  function css.window_title (winname, text)
    local ttlname = "$wt$" .. winname .. "$t"
    if text == nil then
      return sknLbl.text(ttlname)
    else
      sknLbl.text(ttlname, text)
    end
  end
  
  -- css: window-caption set color
  function css.window_title_colorset (winname, color)
    local ttlname = "$wt$" .. winname .. "$t"
    sknLbl.colors(ttlname, color, thema.win_title_bgcolor)
  end

  -- css: window-caption set buttons (btnID = 1,2,3,4) new or reconfigure
  function css.window_title_btnCfg (winname, btnID, image, event, help)
    if btnID < 1 or btnID > 4 then return end
    local ttlname = "$wt$" .. winname .. "$t"
    local expT = sknLbl.auxData (ttlname)
    
    local wx, wy = sknWin.size(winname)
    wy = thema.win_title_heightB
    local bwx, bwy = sknColl.imgSize("btn", image)
    local btnName = ttlname .. "$b" .. tostring (btnID)
    local x = 0
    if btnID == 1 then
      x = 0
    elseif btnID == 2 then
      x = bwx
    elseif btnID == 3 then
      x = wx - (bwx * 2)
    else
      x = wx - bwx
    end
    local yy = 0
    if bwy < wy then
      yy = (wy - bwy) // 2
    end
    local tx,ty = sknLbl.size(btnName .. "b")   -- check button alrady present
    if tx == nil then
      sknLbl.create(btnName .. "b", ttlname, x, yy, bwx, bwy, thema.win_title_align, "")
    end
    
    sknLbl.colors(btnName .. "b", thema.win_title_color, "transparent")
    if expT == 1 then
      sknLbl.show(btnName .. "b")
    end
    
    if tx == nil then
      css.button_new (btnName, btnName .. "b", 0, 0, image, event, false)
    end
    
    if help ~= nil then
      sknBtn.longTouchCB(btnName, help)
    end
    css.button_show (btnName)
    
  end
  
  -- css: window-caption set button selection state (btnID = 1,2,3,4)
  function css.window_title_btnSlected (winname, btnID, btnSelected)
    if btnID < 1 or btnID > 4 then return end
    local ttlname = "$wt$" .. winname .. "$t"
    local btnName = ttlname .. "$b" .. tostring (btnID)
    
    local btnBG = "transparent"
    if btnSelected == true then
      btnBG = thema.win_title_btnSelected
    end
    sknLbl.colors(btnName .. "b", thema.win_title_color, btnBG)

  end

  -- window title resize request  event
  function css.titleResize (name)
    local winname = sknLbl.auxStr(name)
    if sknLbl.auxData (name) == 0 then
      css.window_title_expand (winname, true)
    else
      css.window_title_expand (winname, false)
    end
  end
  
-- Load artworks
----------------
-- css Class not visible !!!!

-- Background image
--css.load_img ("\\img\\hbar480x20.bmp", "topbar", "IMG")
-- top bar buttons
css.load_btn_img ("\\buttons\\settings.png",  "settings") 
css.load_btn_img ("\\buttons\\modify.png",  "wmodify") 
css.load_btn_img ("\\buttons\\back.png",  "back") 
css.load_btn_img ("\\buttons\\swin.png",    "usrwins")

