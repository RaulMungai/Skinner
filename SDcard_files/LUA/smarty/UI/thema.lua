-------------------------------------------------------------------
---------------------------  Thema management  --------------------
-------------------------------------------------------------------


-- Global Object
thema = {}

  -- Thema management (configured by skncfg.lua)
  thema.language = "ITA"
  thema.workDisk = "\\LUA\\smarty\\UI\\"  -- working disk
  thema.thema = ""                        -- thema of application (resources)

  -- generic
  thema.ico_size = 20
  thema.btn_size = 32
  thema.btn_spacyng = 80
  
  --Windows
  thema.win_bg_color = "white"
  thema.win_color = "black"
  thema.win_small_font = "F8"
  thema.win_std_font = "F16B"
  thema.win_big_font = "F24B"
  
  --Windows: title
  thema.win_title_height = 20
  thema.win_title_heightB = 35
  thema.win_title_font = "F24B"
  thema.win_title_align = "HorCenter_VertCenter"
  thema.win_title_color = "white"
  thema.win_title_bgcolor = "darkgray"
  thema.win_title_btnSelected = "yellow"
  thema.win_title_def_showBtn = true      -- default title expanded/standard
  
  --Buttons: text
  thema.btn_font = "F16B"
  thema.btn_lbl_height = 16
  thema.btn_txtalign = "HorCenter_VertCenter"
  thema.btn_txtcolor = "white"
  thema.btn_txtbgcolor = "transparent"
  
  -- Helper
  thema.helper_font = "F16B"
  thema.helper_txtcolor = "white"
  thema.helper_txtbgcolor = "lightblue"
  thema.helper_iconPtr = "hlparrow"
  thema.helper_txtalign = "HorCenter_VertCenter"
  
  -- PopUp
  thema.popup_title_height = 20
  thema.popup_font = "F16B"
  thema.popup_txtcolor = "black"
  thema.popup_bg_color = "lightblue"
  thema.popup_txtcolor = "black"
  thema.popup_title_bg_color = "gray"
  thema.popup_title_color = "white"
  thema.popup_title_font = "F24B"
  thema.popup_title_align = "HorCenter_VertCenter"  
  
  -- list
  thema.list_font = "F16B"
  thema.list_txtcolor = "white"
  thema.list_txtbgcolor = "lightblue"
  thema.list_txtcolorSel = "black"
  thema.list_txtbgcolorSel = "yellow"
  
  function thema.getDir()
    return thema.workDisk .. thema.thema
  end


  function thema.loadDict()
    if sknColl.dictLoad ("DATE", thema.language, thema.getDir() .. "dict\\DATEdict.txt") == 0 then
      print ("Failed dict:DATE lang:" .. thema.language .. " load:" .. thema.getDir() .. "dict\\DATEdict.txt")
    end
    
    if sknColl.dictLoad ("WIN", thema.language, thema.getDir() .. "dict\\WINdict.txt") == 0 then
      print ("Failed dict:WIN lang:" .. thema.language .. " load:" .. thema.getDir() .. "dict\\WINdict.txt")
    end
    
    if sknColl.dictLoad ("HELP", thema.language, thema.getDir() .. "dict\\HELPdict.txt") == 0 then
      print ("Failed dict:HELP lang:" .. thema.language .. " load:" .. thema.getDir() .. "dict\\HELPdict.txt")
    end
  end




