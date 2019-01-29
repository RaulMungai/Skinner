
-------------------------------------------------------------------
---------------------------  window:Calc  -------------------------
-------------------------------------------------------------------
--[[
  Sample Basic Calculator
  
    win_calc.show ()                  -- Show
    win_calc.hide ()                  -- Hide
    win_calc.pos (x,y)                -- Position set

  date: 11/10/2018 
  by: Raul Mungai
--]]

-- Load artworks
----------------
css.load_btn_img ("\\calc\\specKey.bmp",    "specKey") 
css.load_btn_img ("\\calc\\digitKey.bmp",   "digitKey") 
--css.load_btn_img ("\\calc\\digitKey0.bmp",  "digitKey0") 
css.load_btn_img ("\\calc\\operKey.bmp",    "operKey") 
css.load_btn_img ("\\calc\\EKey.bmp",       "EKey") 

css.load_btn_img ("\\buttons\\calc.png",    "calc")  -- App icon
css.load_img ("\\icons\\calc-i.png",    "calc-i", "icon")  -- App small icon

css.load_img ("\\layout\\lay_calc.bmp", "lay_calc", "LAYOUT")    -- selection icon


-- Global Object
win_calc = {}

  local winname = "winCalc"     -- window name
  local clcvalname = "calc_val"
  local waitClr = true
  
  -- binary
  local pendOper = ""
  local pendValue = 0

  -- crete calc key 
  local function calc_btn_key_new (text, x, y)
    local btnDigitName = "calcDigit" .. text
    
    sknIbtn.create(btnDigitName, winname, x, y, 0, 0)
    sknIbtn.txtalign (btnDigitName, "Center_Vert") 
    sknIbtn.txtcolors(btnDigitName, 0xecebec, 0xecebec)
    sknIbtn.text (btnDigitName, text)
    sknIbtn.font (btnDigitName, "F24B")
    local keyimg = ""
    --if text == "0" then
    --  keyimg = "digitKey0"
    if text == "C" or text == "+/-" or text == "%" then
      keyimg = "specKey"
    elseif text == "/" or text == "X" or text == "-" or text == "+" or text == "=" then
      keyimg = "operKey"
    else
      keyimg = "digitKey"
    end
    
    -- exclude empty keys
    if text == "d2" then
      sknIbtn.enable (btnDigitName, false)    -- disable empty key
      sknIbtn.text (btnDigitName, "")
      sknIbtn.imgdisabled (btnDigitName, 0, "btn", keyimg)   -- same background of unpressed keys
      sknIbtn.keyReleaseCB (btnDigitName, "win_calc.digitCb")
    elseif text == "!" then
      sknIbtn.imgpress (btnDigitName, 0, "btnP", "EKey")
      sknIbtn.imgunpress (btnDigitName, 0, "btn", "EKey")
      sknIbtn.imgdisabled (btnDigitName, 0, "btnD", "EKey")
      sknIbtn.text (btnDigitName, "")
      sknIbtn.keyReleaseCB (btnDigitName, "sknWin.showCaller")
    else
      sknIbtn.imgpress (btnDigitName, 0, "btnP", keyimg)
      sknIbtn.imgunpress (btnDigitName, 0, "btn", keyimg)
      sknIbtn.imgdisabled (btnDigitName, 0, "btnD", keyimg)
      sknIbtn.keyReleaseCB (btnDigitName, "win_calc.digitCb")
    end
    
    sknIbtn.auxStr (btnDigitName, text)
    sknIbtn.show (btnDigitName)	
  end

  local function win_calc_create ()

    sknWin.create (winname, 65, 54, 349, 163)
    sknWin.bgcolor (winname, "darkgray")

    -- Digit area
    sknLbl.create (clcvalname, winname, 3, 0, 343, 40, "HorRight_VertCenter", "0") 
    sknLbl.colors (clcvalname, sknSys.getColor("white"), sknSys.getColor("transparent"))
    sknLbl.font(clcvalname, "F32B")
    sknLbl.transp(clcvalname, true) 
    sknLbl.show(clcvalname)
  
    -- Calc Keys
    calc_btn_key_new ("C", 0, 41)
    calc_btn_key_new ("+/-", 50, 41)
    calc_btn_key_new ("%", 100, 41)
    calc_btn_key_new ("!", 150, 41)
    calc_btn_key_new (",", 200, 41)
    calc_btn_key_new ("/", 250, 41)
    calc_btn_key_new ("+", 300, 41)
    
    calc_btn_key_new ("6", 0, 82)
    calc_btn_key_new ("7", 50, 82)
    calc_btn_key_new ("8", 100, 82)
    calc_btn_key_new ("9", 150, 82)
    calc_btn_key_new ("0", 200, 82)
    calc_btn_key_new ("X", 250, 82)
    calc_btn_key_new ("-", 300, 82)
    
    calc_btn_key_new ("1", 0, 123)
    calc_btn_key_new ("2", 50, 123)
    calc_btn_key_new ("3", 100, 123)
    calc_btn_key_new ("4", 150, 123)
    calc_btn_key_new ("5", 200, 123)
    calc_btn_key_new ("d2", 250, 123)
    calc_btn_key_new ("=", 300, 123)
    
    -- enable selection bar
    win_selector.add ("calc", win_calc.show, win_calc.hide, win_calc.pos, true)
    
    widget_calc = wd_btn.new ("calc", "Calculator", "Calc")    -- add to widget list
    
  end

  -- key callbacks
  function win_calc.digitCb (objName)
    local keyStr = sknIbtn.auxStr (objName)
    local valStr = sknLbl.text(clcvalname)      -- get digit text
    local val
    if keyStr == "0" or keyStr == "1" or keyStr == "2" or keyStr == "3" or keyStr == "4" or keyStr == "5" or keyStr == "6" 
        or keyStr == "7" or keyStr == "8" or keyStr == "9" or keyStr == "," then
      
      if keyStr == "," then 
        if string.find(valStr, "%.") == nil then
          keyStr = "." 
        else
          keyStr = ""
        end
      end
      if keyStr == "" then return end
      
      if valStr == "0" or waitClr == true then
        valStr = keyStr
        waitClr = false
      else
        valStr = valStr .. keyStr
      end
      sknLbl.text(clcvalname, valStr)      
      
    elseif keyStr == "C" then
      waitClr = true
      valStr = "0"
      sknLbl.text(clcvalname, "0")
      
    elseif keyStr == "%" then
      waitClr = true
      val = tonumber (valStr)
      val = val / 100
      valStr = tostring(val)
      sknLbl.text(clcvalname, valStr)
      
    elseif keyStr == "+/-" then
      val = tonumber (valStr)
      val = val * -1
      valStr = tostring(val)
      sknLbl.text(clcvalname, valStr)
      
    elseif keyStr == "+" or keyStr == "-" or keyStr == "/" or keyStr == "X" then
      if pendOper ~= "" then return end
      
      val = tonumber (sknLbl.text(clcvalname))
      pendOper = keyStr
      pendValue = val
      waitClr = true

    elseif keyStr == "=" then
      if pendOper == "" then return end
      
      val = tonumber (sknLbl.text(clcvalname))
      if pendOper == "-" then
        sknLbl.text(clcvalname, tostring(pendValue - val))
      elseif pendOper == "+" then
        sknLbl.text(clcvalname, tostring(pendValue + val))
      elseif pendOper == "/" then
        if val == 0 then
          sknLbl.text(clcvalname, "ERRORE")
        else
          sknLbl.text(clcvalname, tostring(pendValue / val))
        end
      elseif pendOper == "X" then
        sknLbl.text(clcvalname, tostring(pendValue * val))
      end
    
      pendValue = 0
      pendOper = ""
      waitClr = true

    end
  end  

  function win_calc.show ()
    sknWin.showRestorable (winname)
    sknWin.bringTop(winname)
  end

  function win_calc.hide ()
    sknWin.hide (winname)
  end

  function win_calc.pos (x,y)
    sknWin.pos (winname, x,y)
  end

  
win_calc_create ()   -- Window creation
