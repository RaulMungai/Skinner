-------------------------------------------------------------------
---------------------------  window:keyboard  ---------------------
-------------------------------------------------------------------
--[[
  Keyboard window

    win_kbrd.set (kbtype, varName, maxLen, winCaller, retFunct)   -- use new keyboard - supported:"alpha_ita"
    
  date: 21/10/2018 
  by: XXX XXXX
--]]


-- Load artworks
----------------
css.load_btn_img ("\\buttons\\keyboard.png",    "kbrd")   -- app icon


css.font_mount (thema.workDisk .. "res\\font\\clbib14.txt", "calibriB14")
  
-- Global Object
win_kbrd = {}
  
  -- layout specs
  local kbrd_bgColor = sknSys.getColor("gray")
  local kbrd_txtColor_un = sknSys.getColor("black")
  local kbrd_txtColor_press = sknSys.getColor("white")
  
  local kbrd_specKey_font = "F16B"
  local kbrd_edit_font = "F24B"
  local kbrd_edit_bgcolor = sknSys.getColor("white")
  local kbrd_edit_txtcolor = sknSys.getColor("black")
  local kbrd_edit_bordercolor = sknSys.getColor("black")
  
  local kbrd_desc = ""
  
  local kbrd_edit_cursorChar = "_"    -- keyboard cursor or "" 
  
  
  local winname = "winkbrd"

 -- alpha key ITA
 function win_kbrd_set_alpha_ita (varName, maxLen, winCaller, retFunct)
    -- 1st cfs
    sknKbrd.new(0, 0, sknSys.screenXsize(), sknSys.screenYsize(), kbrd_bgColor, kbrd_txtColor_un, kbrd_txtColor_press)
    
    -- edit area
    if sknKbrd.edittxt(16, 24, sknSys.screenXsize() - 32, 32, "HorLeft_Vert_Top",kbrd_edit_bgcolor, 
      kbrd_edit_txtcolor, kbrd_edit_bordercolor, varName, kbrd_edit_font) == 0 then
      print ("Error on win_kbrd_set_alpha_ita (" .. varName .. ", " .. tostring(maxLen))
      return 0
    end
    
    if sknKbrd.extratxt(16, 2, sknSys.screenXsize() - 32, 18,"transparent", "black", kbrd_desc, "Arial14") == 0 then
      print ("Error on win_kbrd_set_alpha_ita (desc) (" .. varName .. ", " .. tostring(maxLen))
      return 0
    end

    -- 1 row
    sknKbrd.addBtnTxt(16,100, 48, 32, "Canc", "Canc", "Canc")
    sknKbrd.addBtnEnd("exit",true, kbrd_specKey_font, "", "", false)
    
    sknKbrd.addBtnTxt(80,100, 32, 32, "1", "!", "1")
    sknKbrd.addBtnEnd("key",true, kbrd_edit_font, "", "", false)
    
    sknKbrd.addBtnTxt(112,100, 32, 32, "2", "\"", "2")
    sknKbrd.addBtnEnd("key",true, kbrd_edit_font, "", "", false)
  
    sknKbrd.addBtnTxt(144,100, 32, 32, "3", "£", "3")
    sknKbrd.addBtnEnd("key",true, kbrd_edit_font, "", "", false)  
    
    sknKbrd.addBtnTxt(176,100, 32, 32, "4", "$", "4")
    sknKbrd.addBtnEnd("key",true, kbrd_edit_font, "", "", false)   
    
    sknKbrd.addBtnTxt(208,100, 32, 32, "5", "%", "5")
    sknKbrd.addBtnEnd("key",true, kbrd_edit_font, "", "", false)
    
    sknKbrd.addBtnTxt(240,100, 32, 32, "6", "&", "6")
    sknKbrd.addBtnEnd("key",true, kbrd_edit_font, "", "", false)
    
    sknKbrd.addBtnTxt(272,100, 32, 32, "7", "/", "7")
    sknKbrd.addBtnEnd("key",true, kbrd_edit_font, "", "", false)
    
    sknKbrd.addBtnTxt(304,100, 32, 32, "8", "(", "8")
    sknKbrd.addBtnEnd("key",true, kbrd_edit_font, "", "", false)
    
    sknKbrd.addBtnTxt(336,100, 32, 32, "9", ")", "9")
    sknKbrd.addBtnEnd("key",true, kbrd_edit_font, "", "", false)
    
    sknKbrd.addBtnTxt(368,100, 32, 32, "0", "=", "0")
    sknKbrd.addBtnEnd("key",true, kbrd_edit_font, "", "", false)
    
    sknKbrd.addBtnTxt(416,100, 48, 32, "Del", "Del", "Del")
    sknKbrd.addBtnEnd("cancel",true, kbrd_specKey_font, "", "", false)
    
    -- 2 row
    sknKbrd.addBtnTxt(96,132, 32, 32, "Q", "q", "")
    sknKbrd.addBtnEnd("key",true, kbrd_edit_font, "", "", false)
    
    sknKbrd.addBtnTxt(128,132, 32, 32, "W", "w", "")
    sknKbrd.addBtnEnd("key",true, kbrd_edit_font, "", "", false)
    
    sknKbrd.addBtnTxt(160,132, 32, 32, "E", "e", "")
    sknKbrd.addBtnEnd("key",true, kbrd_edit_font, "", "", false)
    
    sknKbrd.addBtnTxt(192,132, 32, 32, "R", "r", "")
    sknKbrd.addBtnEnd("key",true, kbrd_edit_font, "", "", false)
    
    sknKbrd.addBtnTxt(224,132, 32, 32, "T", "t", "")
    sknKbrd.addBtnEnd("key",true, kbrd_edit_font, "", "", false)
    
    sknKbrd.addBtnTxt(256,132, 32, 32, "Y", "y", "")
    sknKbrd.addBtnEnd("key",true, kbrd_edit_font, "", "", false)
    
    sknKbrd.addBtnTxt(288,132, 32, 32, "U", "u", "")
    sknKbrd.addBtnEnd("key",true, kbrd_edit_font, "", "", false)
    
    sknKbrd.addBtnTxt(320,132, 32, 32, "I", "i", "")
    sknKbrd.addBtnEnd("key",true, kbrd_edit_font, "", "", false)
    
    sknKbrd.addBtnTxt(352,132, 32, 32, "O", "o", "")
    sknKbrd.addBtnEnd("key",true, kbrd_edit_font, "", "", false)
    
    sknKbrd.addBtnTxt(384,132, 32, 32, "P", "p", "")
    sknKbrd.addBtnEnd("key",true, kbrd_edit_font, "", "", false)
    
    sknKbrd.addBtnTxt(416,148, 48, 48, "Ok", "Ok", "Ok")
    sknKbrd.addBtnEnd("ok",true, kbrd_specKey_font, "", "", false)
  
    -- 3 row
    sknKbrd.addBtnTxt(112,164, 32, 32, "A", "a", "")
    sknKbrd.addBtnEnd("key",true, kbrd_edit_font, "", "", false)
    
    sknKbrd.addBtnTxt(144,164, 32, 32, "S", "s", "")
    sknKbrd.addBtnEnd("key",true, kbrd_edit_font, "", "", false)
    
    sknKbrd.addBtnTxt(176,164, 32, 32, "D", "d", "")
    sknKbrd.addBtnEnd("key",true, kbrd_edit_font, "", "", false)
    
    sknKbrd.addBtnTxt(208,164, 32, 32, "F", "f", "")
    sknKbrd.addBtnEnd("key",true, kbrd_edit_font, "", "", false)
    
    sknKbrd.addBtnTxt(240,164, 32, 32, "G", "g", "")
    sknKbrd.addBtnEnd("key",true, kbrd_edit_font, "", "", false)
    
    sknKbrd.addBtnTxt(272,164, 32, 32, "H", "h", "")
    sknKbrd.addBtnEnd("key",true, kbrd_edit_font, "", "", false)
    
    sknKbrd.addBtnTxt(304,164, 32, 32, "J", "j", "")
    sknKbrd.addBtnEnd("key",true, kbrd_edit_font, "", "", false)
    
    sknKbrd.addBtnTxt(336,164, 32, 32, "K", "k", "")
    sknKbrd.addBtnEnd("key",true, kbrd_edit_font, "", "", false)
    
    sknKbrd.addBtnTxt(368,164, 32, 32, "L", "l", "")
    sknKbrd.addBtnEnd("key",true, kbrd_edit_font, "", "", false)
   
    -- 4 row
    sknKbrd.addBtnTxt(16,196, 80, 32, "Shift", "Maiusc", "Minusc")
    sknKbrd.addBtnEnd("shift",true, kbrd_specKey_font, "", "", false)
    
    sknKbrd.addBtnTxt(128,196, 32, 32, "Z", "z", "")
    sknKbrd.addBtnEnd("key",true, kbrd_edit_font, "", "", false)

    sknKbrd.addBtnTxt(160,196, 32, 32, "X", "x", "")
    sknKbrd.addBtnEnd("key",true, kbrd_edit_font, "", "", false)

    sknKbrd.addBtnTxt(192,196, 32, 32, "C", "c", "")
    sknKbrd.addBtnEnd("key",true, kbrd_edit_font, "", "", false)

    sknKbrd.addBtnTxt(224,196, 32, 32, "V", "v", "")
    sknKbrd.addBtnEnd("key",true, kbrd_edit_font, "", "", false)

    sknKbrd.addBtnTxt(256,196, 32, 32, "B", "b", "")
    sknKbrd.addBtnEnd("key",true, kbrd_edit_font, "", "", false)

    sknKbrd.addBtnTxt(288,196, 32, 32, "N", "n", "")
    sknKbrd.addBtnEnd("key",true, kbrd_edit_font, "", "", false)

    sknKbrd.addBtnTxt(320,196, 32, 32, "M", "m", "")
    sknKbrd.addBtnEnd("key",true, kbrd_edit_font, "", "", false)

    sknKbrd.addBtnTxt(384,196, 80, 32, "A/1", "A/1", "A/1")
    sknKbrd.addBtnEnd("alphanum",true, kbrd_specKey_font, "", "", false)
    
    -- 5 row
    sknKbrd.addBtnTxt(176,228, 128, 32, " ", " ", " ")
    sknKbrd.addBtnEnd("key",true, kbrd_edit_font, "", "", false)
    
    sknKbrd.cursor(kbrd_edit_cursorChar)
    
    return 1
  end
  
  -- alpha numbers
 function win_kbrd_set_numbers (varName, maxLen)
    -- 1st cfs
    sknKbrd.new(0, 0, sknSys.screenXsize(), sknSys.screenYsize(), kbrd_bgColor, kbrd_txtColor_un, kbrd_txtColor_press)
    
    -- edit area
    if sknKbrd.edittxt(16, 24, sknSys.screenXsize() - 32, 32, "HorLeft_Vert_Top",kbrd_edit_bgcolor, 
      kbrd_edit_txtcolor, kbrd_edit_bordercolor, varName, kbrd_edit_font) == 0 then
      print ("Error on win_kbrd_set_alpha_ita (" .. varName .. ", " .. tostring(maxLen))
      return 0
    end
    
    if sknKbrd.extratxt(16, 2, sknSys.screenXsize() - 32, 18,"transparent", "black", kbrd_desc, "Arial14") == 0 then
      print ("Error on win_kbrd_set_alpha_ita (desc) (" .. varName .. ", " .. tostring(maxLen))
      return 0
    end
    
    -- 1 row
    sknKbrd.addBtnTxt(16,100, 48, 32, "Canc", "Canc", "Canc")
    sknKbrd.addBtnEnd("exit",true, kbrd_specKey_font, "", "", false)
    
    sknKbrd.addBtnTxt(80,100, 32, 32, "1", "1", "1")
    sknKbrd.addBtnEnd("key",true, kbrd_edit_font, "", "", false)
    
    sknKbrd.addBtnTxt(112,100, 32, 32, "2", "2", "2")
    sknKbrd.addBtnEnd("key",true, kbrd_edit_font, "", "", false)
  
    sknKbrd.addBtnTxt(144,100, 32, 32, "3", "3", "3")
    sknKbrd.addBtnEnd("key",true, kbrd_edit_font, "", "", false)  
    
    sknKbrd.addBtnTxt(176,100, 32, 32, "4", "4", "4")
    sknKbrd.addBtnEnd("key",true, kbrd_edit_font, "", "", false)   
    
    sknKbrd.addBtnTxt(208,100, 32, 32, "5", "5", "5")
    sknKbrd.addBtnEnd("key",true, kbrd_edit_font, "", "", false)
    
    sknKbrd.addBtnTxt(240,100, 32, 32, "6", "6", "6")
    sknKbrd.addBtnEnd("key",true, kbrd_edit_font, "", "", false)
    
    sknKbrd.addBtnTxt(272,100, 32, 32, "7", "7", "7")
    sknKbrd.addBtnEnd("key",true, kbrd_edit_font, "", "", false)
    
    sknKbrd.addBtnTxt(304,100, 32, 32, "8", "8", "8")
    sknKbrd.addBtnEnd("key",true, kbrd_edit_font, "", "", false)
    
    sknKbrd.addBtnTxt(336,100, 32, 32, "9", "9", "9")
    sknKbrd.addBtnEnd("key",true, kbrd_edit_font, "", "", false)
    
    sknKbrd.addBtnTxt(368,100, 32, 32, "0", "0", "0")
    sknKbrd.addBtnEnd("key",true, kbrd_edit_font, "", "", false)
    
    sknKbrd.addBtnTxt(416,100, 48, 32, "Del", "Del", "Del")
    sknKbrd.addBtnEnd("cancel",true, kbrd_specKey_font, "", "", false)
    
    sknKbrd.addBtnTxt(416,148, 48, 48, "Ok", "Ok", "Ok")
    sknKbrd.addBtnEnd("ok",true, kbrd_specKey_font, "", "", false)
    
    sknKbrd.cursor(kbrd_edit_cursorChar)    
    return 1
  end
  
  -- set new keyboard supported:"alpha_ita", "numbers"
  function win_kbrd.set (kbtype, varName, maxLen, winCaller, retFunct, desc)
    kbrd_desc = desc
    if kbtype == "alpha_ita" then
      if win_kbrd_set_alpha_ita (varName, maxLen) == 0 then return 0 end
    elseif kbtype == "numbers" then
      if win_kbrd_set_numbers (varName, maxLen) == 0 then return 0 end
    else
      return 0
    end
    
    sknKbrd.caller(winCaller)
    sknKbrd.exitFunction(retFunct)
    sknKbrd.show()
  end
  
  
