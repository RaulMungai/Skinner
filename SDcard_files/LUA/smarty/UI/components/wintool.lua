-------------------------------------------------------------------
---------------------------  window:tool  -------------------------
-------------------------------------------------------------------
--[[
  Tools 4 window
  
  components:
    win_wintool.win_add (winradix, winBGImage, shortDescr
            [,x,y,w,h])                                           -- add window to list (,x,y,w,h Optionals user zone)
    win_wintool.win_remove (winname)                              -- remove window to list
    win_wintool.win_upd (winName, winBGImage, bgColorN)           -- update window properties (and apply to window) 
                                                                        set nil unwanted param (winBGImage, bgColorN)

    win_wintool.win_exists (winName)                              -- check for window exists
    win_wintool.win_workingDesc_idx (idx)                         -- get working window description from index 
                                                                            ("" == end of list)
    win_wintool.win_workingIcon_idx (idx)                         -- get working window icon from index 
                                                                            ("" == end of list)
                                                                            
  window preview:
    win_wintool.winpreview_disp (winname, winBGimage, 
              winBGcolor, title, icon, shortDesc, x,y)            -- display window summary (preview)  to parent area
    win_wintool.winpreview_hide (winname)                         -- remove window preview parent parent area

  winow properties display:
    win_wintool.prop_title (winname[, title, changeEvent, x, y])  -- create / delete property: Title (display-remove)
                                                                              return the widget block size w,h
                                                                              event="" or event=nil do not display button
                                                                              only winname param remove all objects to parent
  
    win_wintool.prop_bg (winname[, changeEventImg, changeEventColor, x, y]) -- create / delete property: BG image-color
                                                                              return the widget block size w,h
                                                                              event="" or event=nil do not display button
                                                                              only winname param remove all objects to parent
  
    win_wintool.prop_bg_showBtn (winname, enImgBtn, enColorBtn)    -- make visible image and color modify buttons
    win_wintool.prop_bg_updImg (winname, image)                    -- update property: BG image
    win_wintool.prop_bg_updColor (winname, color)                  -- update property: BG color
    
    win_wintool.prop_icon (winname, defIcon, changeEventIcon, x, y)-- create / delete property: icon
                                                                              return the widget block size w,h
                                                                              event="" or event=nil do not display button
                                                                              only winname param remove all objects to parent
    
    
    win_wintool.prop_iconDesc (winname, desc, changeEvent, x, y)    -- create / delete property: Icon desc
                                                                              return the widget block size w,h
                                                                              event="" or event=nil do not display button
                                                                              only winname param remove all objects to parent

    win_wintool.prop_iconDesc_upd (winname, desc)                   -- update property: Icon desc
  
  utilities:
    win_wintool.win_workingNameI (winName)        -- get working window name (parent win)
    win_wintool.win_workingDesc (winName)         -- get working window description
    win_wintool.win_workingBGimage (winName)      -- get working window background image
    win_wintool.win_workingName (desc)            -- get working window name from description
    win_wintool.win_workingISuserDef (winName)    -- check working window User defined
    win_wintool.win_addTitle_buttons (winname)    -- add user title buttons
  
    win_wintool.usrWinUpd ()                      -- Update user window buttons
    
  Buttons:
    win_wintool.nextBtn_coords (wx, wy)           -- -- set new button coords (wx == nil init the button coords)
    
  date: 13/11/2018 
  by: Raul Mungai
--]]


-- Load artworks
----------------
css.load_btn_img ("\\buttons\\refresh.png",  "refresh")
css.load_btn_img ("\\buttons\\image.png",    "image")
css.load_btn_img ("\\buttons\\colors.png",   "colors")

-- title buttonbar
css.load_btn_img ("\\buttons\\settings.png",  "settings") 
css.load_btn_img ("\\buttons\\modify.png",  "wmodify") 
css.load_btn_img ("\\buttons\\back.png",  "back") 
css.load_btn_img ("\\buttons\\swin.png",    "usrwins")
--css.load_btn_img ("\\buttons\\move.png", "move")

css.font_mount (thema.workDisk .. "res\\font\\F08_1_S.txt", "F8")
css.font_mount (thema.workDisk .. "res\\font\\F16B_1_S.txt", "F16B")
css.font_mount (thema.workDisk .. "res\\font\\F16_1_S.txt", "F16")
  
-- Global Object
win_wintool = {}

  local win_activeList = {}
  
  -- {radix="", winname="", winnameI="", descr="", icon="", shrtDesc="", bgImage="", bgColor="", usrzoneX=0, usrzoneY=0, usrzoneW=0, usrzoneH=0}

  local fname = thema.getDir() .. "cfg\\win.cfg"
  local winprop_caption_w = 60
  local winprop_std_w = 180
  local winprop_txt_h = 20
  local winprop_img_h = 50
  
-- store configuration
  local function wintool_storeCfg() 
    --hourglass.show ()
    utils.table_save(win_activeList, fname)
    --hourglass.hide ()
  end
 
  -- restore configuration
  local function wintool_restoreCfg()
    win_activeList = utils.table_load(fname)
    if win_activeList == nil then
      win_activeList = {}
    end
  end
  
  -- get working window name (parent win)
  function win_wintool.win_workingNameI (winName)
    if #win_activeList > 0 then
      for i=1, #win_activeList do
        if win_activeList[i].winname == winName then
          return win_activeList[i].winnameI
        end
      end
    end
    return winName
  end
  
  -- check working window User defined
  function win_wintool.win_workingISuserDef (winName)
    if #win_activeList > 0 then
      for i=1, #win_activeList do
        if win_activeList[i].winname == winName then
          if win_activeList[i].usrzoneX == -1 then
            return false
          else
            return true
          end
        end
      end
    end
    return winName
  end
  
  -- get working window description
  function win_wintool.win_workingDesc (winName)
    if #win_activeList > 0 then
      for i=1, #win_activeList do
        if win_activeList[i].winname == winName then
          return win_activeList[i].descr
        end
      end
    end
    return ""
  end
  
  -- get working window name from description
  function win_wintool.win_workingName (desc)
    if #win_activeList > 0 then
      for i=1, #win_activeList do
        if win_activeList[i].descr == desc then
          return win_activeList[i].winname
        end
      end
    end
    return ""
  end
  
  -- get working window background image
  function win_wintool.win_workingBGimage (winName)
    if #win_activeList > 0 then
      for i=1, #win_activeList do
        if win_activeList[i].winname == winName then
          return win_activeList[i].bgImage
        end
      end
    end
    return ""
  end
  
  -- get working window description from index ("" == end of list)
  function win_wintool.win_workingDesc_idx (idx)
    if idx > #win_activeList then return "" end
    return win_activeList[idx].descr
  end
  
  -- get working window icon from index ("" == end of list)
  function win_wintool.win_workingIcon_idx (idx)
    if idx > #win_activeList then return "" end
    return win_activeList[idx].icon
  end
  
  -- add user title buttons
  function win_wintool.win_addTitle_buttons (winname)
    css.window_title_btnCfg (winname, 1, "back", "sknWin.showCaller")
    --css.window_title_btnCfg (winname, 2, "move", "win_wmodify.enMove", "win_wmodify.help_move")
    css.window_title_btnCfg (winname, 2, "usrwins", "win_usrwins.show", "win_usrwins.help")
    css.window_title_btnCfg (winname, 3, "wmodify", "win_wdlist.show", "win_uedit.help")
    css.window_title_btnCfg (winname, 4, "settings", "win_wmodify.show", "win_wmodify.help")
  end
  
  -- add window to list
  function win_wintool.win_add (winradix, winBGImage, shortDescr, icon,x,y,w,h)
    local ix = -1
    local iy = -1
    local iw = -1
    local ih = -1    
    if x ~= nil then
      ix = x
      iy = y
      iw = w
      ih = h
    end
    
    local winName = "win&" .. winradix
    if icon == nil then
      icon = winradix
    end
    
    local winIcon = icon
    local winNameI =  winName
    if winBGImage ~= "" then
      winNameI = "$bg$" .. winNameI
    end
    
    local winBGColor = sknWin.bgcolor(winName)
    local winDesc = css.window_title(winNameI)
    -- check for already exists (avoid overwrite from hard coded windows)
    if #win_activeList > 0 then
      for i=1, #win_activeList do
        if win_activeList[i].winname == winName then
          return
        end
      end
    end

    table.insert(win_activeList, {radix=winradix, winname=winName, winnameI=winNameI, descr=winDesc, icon=winIcon, shrtDesc=shortDescr, bgImage=winBGImage, bgColor=winBGColor, usrzoneX=ix, usrzoneY=iy, usrzoneW=iw, usrzoneH=ih})
    wintool_storeCfg()
    win_wintool.usrWinUpd ()
  end
  
  -- update window properties (and apply to window)
  function win_wintool.win_upd (winName, winBGImage, bgColorN, caption)
    -- find record
    if #win_activeList > 0 then
      for i=1, #win_activeList do
        if win_activeList[i].winname == winName then
          if winBGImage ~= nil then
            win_activeList[i].bgImage = winBGImage
          end
          if bgColorN ~= nil then
            win_activeList[i].bgColor = bgColorN
          end
          
          if caption ~= nil then
            win_activeList[i].descr = caption
          end
          
          -- apply change to window
          if winBGImage ~= nil then
            css.window_set_bgImage (win_activeList[i].winname, win_activeList[i].bgImage)
          end
          if bgColorN ~= nil then
            sknWin.bgcolor (win_activeList[i].winname,  win_activeList[i].bgColor)
          end
          
          if caption ~= nil then
            css.window_title (win_activeList[i].winnameI, win_activeList[i].descr)
          end
          
          wintool_storeCfg()
          return
        end
      end
    end
  end
  
  -- remove window from Gui and list
  function win_wintool.win_remove (winname)
    
    -- find related index
    local wi = -1
    if #win_activeList > 0 then
      for i=1, #win_activeList do
        if win_activeList[i].winname == winname then
          wi = i
          break
        end
      end
    end    
    
    if wi == -1 then return end
    
    -- remove childs ?????
    
    -- remove real window
    css.window_title_delete ( win_activeList[wi].winnameI)  -- title and buttons
    css.window_delete (winname, bgImageActive) -- win and [BG image]
    
    -- remove user win button
    css.button_remove (win_activeList[wi].winname .. "-ws")
    
    -- remove from list
    table.remove(win_activeList, wi)
    wintool_storeCfg()
  end
  
  --[[
  -- remove window to list
  function win_wintool.win_remove (winName)
    local LS=#win_activeList
    if LS == 0 then return 0 end
    
    for i=1, LS do
      if win_activeList[i].winname == winName then
        table.remove(win_activeList, i)
        wintool_storeCfg()
        return 1
      end
    end
    return 0
  end
  --]]
  
  
  -- check for window exists
  function win_wintool.win_exists (winName)
    local LS=#win_activeList
    if LS == 0 then return false end
    
    for i=1, LS do
      if win_activeList[i].winname == winName then
        return true
      end
    end
    return false
  end
  
  -- show user window
  function win_wintool.showUwin (name)
    local wname = sknIbtn.auxStr(name)
    if wname ~= nil then
      sknWin.showRestorable (wname)
    end
  end

  -- Update user window buttons
  function win_wintool.usrWinUpd ()
    local LS=#win_activeList
    if LS == 0 then return 0 end
    
    local btnX, btnY = win_wintool.nextBtn_coords ()
    for i=1, LS do
      if win_activeList[i].winname ~= "" then
        -- Add btn to Usr win selection
        local bname = win_activeList[i].winname .. "-ws"
        local x,y = sknIbtn.pos(bname)
        if x == nil then
          local iicon = win_activeList[i].radix
          if win_activeList[i].icon ~= nil then
            iicon = win_activeList[i].icon
          end
          
          css.load_btn_img ("\\buttons\\"..iicon..".png",    iicon)
          css.button_new (bname, win_usrwins.getWinName(), btnX, btnY, iicon, 
              "win_" .. win_activeList[i].radix .. ".show", true, false, win_activeList[i].shrtDesc,"black")
          sknIbtn.keyReleaseCB (bname, "win_wintool.showUwin")
          sknIbtn.auxStr (bname, win_activeList[i].winname)
        else
          css.button_move (bname, btnX, btnY)
        end
        
        btnX, btnY = win_wintool.nextBtn_coords (btnX, btnY)    
      end
    end
  end
  
  -- mount user windows and set hard wired windows
  function win_wintool.win_mount ()
    local LS=#win_activeList
    if LS == 0 then return 0 end

    for i=1, LS do
      if win_activeList[i].winname ~= "" then
        -- check already exists
        local x,y = sknWin.size(win_activeList[i].winname)
        if x == nil then
          -- window creation
          local winnameI = css.window_new (win_activeList[i].winname, false, 
            "win_" .. win_activeList[i].radix .. ".help", win_activeList[i].bgImage, win_activeList[i].bgColor)
          if win_activeList[i].usrzoneX == -1 then
            css.window_title_new (winnameI, win_activeList[i].descr, nil, true)
          else
            css.window_title_new (winnameI, win_activeList[i].descr, nil, true, true)
          end
        end
        if win_activeList[i].bgImage ~= "" then
          css.window_set_bgImage (win_activeList[i].winname, win_activeList[i].bgImage)
        end
        if win_activeList[i].bgColor ~= "" then
          sknWin.bgcolor (win_activeList[i].winname,  win_activeList[i].bgColor)
        end
        css.window_title (win_activeList[i].winnameI, win_activeList[i].descr)
      end
    end
    win_wintool.usrWinUpd ()
  end
  
  -- display window summary (preview)  to parent area
  function win_wintool.winpreview_disp (winname, winBGimage, winBGcolor, title, icon, shortDesc, x,y)
    -- title
    local winPreTtitle = winname .. "!T"
    sknLbl.create(winPreTtitle, winname, x, y, 360, 12, "HorCenter_VertCenter", title)
    sknLbl.font(winPreTtitle, "F8")
    sknLbl.colors(winPreTtitle, thema.win_title_color, thema.win_title_bgcolor)
    sknLbl.show(winPreTtitle)
    
    -- bg color
    local iconParent = ""
    if winBGimage == "" then
      local winPreBGcolor = winname .. "!c"
      sknLbl.create(winPreBGcolor, winname, x, y + 12, 360, 192, "HorCenter_VertCenter", " ")
      sknLbl.colors(winPreBGcolor, "black", winBGcolor)
      sknLbl.show(winPreBGcolor)
      iconParent = winPreBGcolor
    else
      local winPreBGimage = winname .. "!i"
      sknImg.create (winPreBGimage, winname, x, y + 12, 360, 192) 
      sknImg.image(winPreBGimage, "BG", winBGimage)
      sknImg.size (winPreBGimage, 360, 192) 
      sknImg.show (winPreBGimage)
      iconParent = winPreBGimage
    end
    
    -- icon
    local winPreIcon = winname .. "!ic"
    css.button_new (winPreIcon, iconParent, 164, 80, icon, "", true, false, shortDesc, thema.btn_txtcolor)
  end
  
  -- remove window preview parent parent area
  function win_wintool.winpreview_hide (winname)
    local winPreTtitle = winname .. "!T"
    sknLbl.delete(winPreTtitle)
    
    local winPreIcon = winname .. "!ic"
     css.button_remove(winPreIcon)
     
    local winPreBGcolor = winname .. "!c"
    sknLbl.delete(winPreBGcolor)

    local winPreBGimage = winname .. "!i"
    sknImg.delete (winPreBGimage) 
  end
  
  -- create / delete property: Title
  function win_wintool.prop_title (winname, title, changeEvent, x, y)
    local xo = x
    local onameC = winname .. "!p!c"
    local onameT = winname .. "!p!t"
    local onameB = winname .. "!p!b"
    local hdisplace = 0
    local bwx, bwy = sknColl.imgSize("btn", "refresh")
    if changeEvent ~= nil then
      if changeEvent ~= "" then
        hdisplace = (bwy - winprop_txt_h) // 2
      end
    end
    
    if title ~= nil then
      -- caption
      sknLbl.create(onameC, winname, x, y + hdisplace, winprop_caption_w, winprop_txt_h, "HorRight_VertCenter", "Titolo:")
      sknLbl.font(onameC, "F16B")
      sknLbl.colors(onameC, thema.win_color, "transparent")
      sknLbl.show(onameC)
      x = x + winprop_caption_w + 2
      
      -- Title
      sknLbl.create(onameT, winname, x, y + hdisplace, winprop_std_w, winprop_txt_h, "HorCenter_VertCenter", title)
      sknLbl.font(onameT, "F16B")
      sknLbl.colors(onameT, thema.win_title_color, thema.win_title_bgcolor)
      sknLbl.show(onameT)
      x = x + winprop_std_w
      
      -- Change button
      if changeEvent ~= "" then
        x = x + 10
        css.button_new (onameB, winname, x, y, "refresh", changeEvent, true, false)
        x = x + bwx        
      end
      if changeEvent ~= "" then
        return x - xo,bwy
      else
        return x - xo,winprop_txt_h
      end
    else
      -- unregister
      sknLbl.delete(onameC)
      sknLbl.delete(onameT)
      css.button_remove (onameB)
      return
    end
  end
  
  -- update text of property: Title
  function win_wintool.prop_title_updTxt (winname, title)
    local onameT = winname .. "!p!t"
    sknLbl.text(onameT, title)
  end
 
  -- create / delete property: BG image-color
  function win_wintool.prop_bg (winname, changeEventImg, changeEventColor, x, y)
    local xo = x
    local onameC = winname .. "!p!bt"
    local onameCO = winname .. "!p!bc"
    local onameCOC = winname .. "!p!bcc"
    local onameIM = winname .. "!p!bi"
    local onameBI = winname .. "!p!BI"
    local onameBC = winname .. "!p!BC"
    local hdisplace = (winprop_img_h - winprop_txt_h) // 2
    
    if changeEventImg ~= nil then
      -- caption
      sknLbl.create(onameC, winname, x, y + hdisplace, winprop_caption_w, winprop_txt_h, "HorRight_VertCenter", "Sfondo:")
      sknLbl.font(onameC, "F16B")
      sknLbl.colors(onameC, thema.win_color, "transparent")
      sknLbl.show(onameC)
      x = x + winprop_caption_w + 2

      -- BG color: back
      sknLbl.create(onameCO, winname, x, y, winprop_std_w, winprop_img_h, "HorCenter_VertCenter", " ")
      sknLbl.colors(onameCO, "black", "gray")
      --sknLbl.show(onameCO)
      -- BG color: fore
      sknLbl.create(onameCOC, onameCO, 5, 5, winprop_std_w-10, winprop_img_h-10, "HorCenter_VertCenter", " ")
      sknLbl.colors(onameCOC, "black", "black")
      sknLbl.show(onameCOC)
      --x = x + winprop_img_h
      
      -- BG image
      sknImg.create (onameIM, winname, x, y, winprop_std_w, winprop_img_h) 
      sknImg.image(onameIM, "BG", image)
      sknImg.size (onameIM, winprop_std_w, winprop_img_h) 
      --sknImg.show(onameIM)
      x = x + winprop_std_w

      local bwx, bwy = sknColl.imgSize("btn", "refresh")
      hdisplace = (winprop_img_h - bwy) // 2
      if changeEventImg ~= "" then
        x = x + 10
        css.button_new (onameBI, winname, x, y + hdisplace, "image", changeEventImg, true, false)
        x = x + bwx
      end
      if changeEventColor ~= "" then
        x = x + 10
        css.button_new (onameBC, winname, x, y + hdisplace, "colors", changeEventColor, true, false)
        x = x + bwx
      end
      return x - xo,winprop_img_h
    else
      -- unregister
      sknLbl.delete(onameC)
      sknLbl.delete(onameCOC)
      sknLbl.delete(onameCO)
      sknImg.delete(onameIM)
      css.button_remove(onameBI)
      css.button_remove(onameBC)
    end
  end
  
  -- make visible image and color modify buttons
  function win_wintool.prop_bg_showBtn (winname, enImgBtn, enColorBtn)
    local onameBI = winname .. "!p!BI"
    local onameBC = winname .. "!p!BC"
    if enImgBtn == true then
      css.button_show(onameBI)
    else
      css.button_hide(onameBI)
    end

    if enColorBtn == true then
      css.button_show(onameBC)
    else
      css.button_hide(onameBC)
    end   
  end
  

  -- update property: BG image
  function win_wintool.prop_bg_updImg (winname, image)
    local onameIM = winname .. "!p!bi"
    local onameCO = winname .. "!p!bc"    
    sknImg.image(onameIM, "BG", image)
    sknImg.size (onameIM, winprop_std_w, winprop_img_h) 
    sknImg.show (onameIM)
    sknLbl.hide(onameCO)
  end
  
    -- update property: BG color
  function win_wintool.prop_bg_updColor (winname, color)
    local onameCOC = winname .. "!p!bcc"
    local onameIM = winname .. "!p!bi"
    local onameCO = winname .. "!p!bc"    
    sknLbl.colors(onameCOC, "black", color)
    sknLbl.show(onameCO)
    sknImg.hide (onameIM)
  end
  
  -- create / delete property: icon
  function win_wintool.prop_icon (winname, defIcon, changeEventIcon, x, y)
    local xo = x
    local onameC = winname .. "!p!ict"
    local onameIM = winname .. "!p!ici"
    local onameBI = winname .. "!p!iBI"
    local bwx, bwy = sknColl.imgSize("btn", defIcon)
    
    if defIcon ~= nil then
      
      local hdisplace = (bwy - winprop_txt_h) // 2
      -- caption
      sknLbl.create(onameC, winname, x, y + hdisplace, winprop_caption_w, winprop_txt_h, "HorRight_VertCenter", "Icona:")
      sknLbl.font(onameC, "F16B")
      sknLbl.colors(onameC, thema.win_color, "transparent")
      sknLbl.show(onameC)
      x = x + winprop_caption_w + 2
      
      -- icon
      local idisp = (winprop_std_w - bwx) // 2
      sknImg.create (onameIM, winname, x + idisp, y, bwx, bwy) 
      sknImg.image(onameIM, "btn", defIcon)
      sknImg.show(onameIM)
      x = x + winprop_std_w

      --bwx, bwy = sknColl.imgSize("btn", "refresh")
      --hdisplace = (winprop_img_h - bwy) // 2
      if changeEventIcon ~= "" then
        x = x + 10
        css.button_new (onameBI, winname, x, y + hdisplace, "refresh", changeEventIcon, true, false)
        x = x + bwx
      end
      return x - xo,bwy
    else
      -- unregister
      sknLbl.delete(onameC)
      sknImg.delete(onameIM)
      css.button_remove(onameBI)
    end
  end

  -- update property: icon
  function win_wintool.prop_icon_upd (winname, icon)
    local onameIM = winname .. "!p!ici"
    sknImg.image(onameIM, "btn", icon)
  end
 
  -- create / delete property: Icon desc
  function win_wintool.prop_iconDesc (winname, desc, changeEvent, x, y)
    local xo = x
    local onameC = winname .. "!p!idc"
    local onameT = winname .. "!p!idt"
    local onameB = winname .. "!p!idb"
    local hdisplace = 0
    local bwx, bwy = sknColl.imgSize("btn", "refresh")
    if changeEvent ~= nil then
      if changeEvent ~= "" then
        hdisplace = (bwy - winprop_txt_h) // 2
      end
    end
    
    if desc ~= nil then
      -- caption
      sknLbl.create(onameC, winname, x, y + hdisplace, winprop_caption_w, winprop_txt_h, "HorRight_VertCenter", "Desc:")
      sknLbl.font(onameC, "F16B")
      sknLbl.colors(onameC, thema.win_color, "transparent")
      sknLbl.show(onameC)
      x = x + winprop_caption_w + 2
      
      -- Desc
      sknLbl.create(onameT, winname, x, y + hdisplace, winprop_std_w, winprop_txt_h, "HorCenter_VertCenter", desc)
      sknLbl.font(onameT, "F16B")
      sknLbl.colors(onameT, thema.win_color, "transparent")
      sknLbl.show(onameT)
      x = x + winprop_std_w
      
      -- Change button
      if changeEvent ~= "" then
        x = x + 10
        css.button_new (onameB, winname, x, y, "refresh", changeEvent, true, false)
        x = x + bwx        
      end
      
      if changeEvent ~= "" then
        return x - xo,bwy
      else
        return x - xo,winprop_txt_h
      end
    else
      -- unregister
      sknLbl.delete(onameC)
      sknLbl.delete(onameT)
      css.button_remove (onameB)
      return
    end
  end
  
  -- update property: Icon desc
  function win_wintool.prop_iconDesc_upd (winname, desc)
    local onameT = winname .. "!p!idt"
    sknLbl.text(onameT, desc)
  end  
  
  -- set new button coords (wx == nil init the button coords)
  function win_wintool.nextBtn_coords (wx, wy)
    if wx == nil then
      return thema.btn_spacyng // 2, 50
    end

    wx = wx + thema.btn_spacyng
    if wx + thema.btn_spacyng > sknSys.screenXsize() then
      wy = wy + thema.btn_spacyng
      wx = thema.btn_spacyng
    end
    return wx,wy
  end
  

  
  wintool_restoreCfg()  -- restore win configuration