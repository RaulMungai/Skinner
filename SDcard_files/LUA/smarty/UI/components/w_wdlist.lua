
-------------------------------------------------------------------
---------------------------  window:widget list  ------------------
-------------------------------------------------------------------
--[[
  current widget list window
  
    win_wdlist.show ()              -- Show
    win_wdlist.hide ()              -- Hide
    
  internals:
    win_wdlist.help ()              -- display help text
    
  date: 31/12/2018 
  by: Raul Mungai
--]]


-- Load artworks
----------------
--css.load_btn_img ("\\buttons\\plugin_add.png",  "wdadd") 
--css.load_btn_img ("\\buttons\\plugin_delete.png",  "wddelete") 
  
  
-- Global Object
win_wdlist = {}
  
  local wWinName = ""   -- current edit window 
  
  function win_wdlist.add ()
    win_wdadd.show()
  end
  
  function win_wdlist.delete ()
    local wd = o_list.selectedItem()
    if wd == nil then return end
    local ww = wd.wdptr
    if ww == nil then return end
    ----------------------------------css.button_hide ("wddelete")
    -- remove parent to widget
    wd_manager.removeParentFromWidget (ww, wd_manager.workingParent)   
    -- reload list ad show
    wd_manager.wdWinRelated_lst_show(sknColl.dictGetPhrase("WIN", 22) .. ":" .. win_wintool.win_workingDesc(wWinName), win_wdlist.add, win_wdlist.ok, win_wdlist.delete, win_wdlist.edit, win_wdlist.hide)
  end

  -- return from child window
  function win_wdlist.showReturn ()
    wd_manager.wdWinRelated_lst_show(sknColl.dictGetPhrase("WIN", 22) .. ":" .. win_wintool.win_workingDesc(wWinName), win_wdlist.add, win_wdlist.ok, win_wdlist.delete, win_wdlist.edit, win_wdlist.hide)
    --sknWin.show (winname)
  end
  
  -- only from parent
  function win_wdlist.show ()
    wWinName = sknWin.currwin()
    wd_manager.workingParent = win_wintool.win_workingNameI (wWinName)
    -- load current wd list
    wd_manager.wdWinRelated_lst_show(sknColl.dictGetPhrase("WIN", 22) .. ":" .. win_wintool.win_workingDesc(wWinName), win_wdlist.add, win_wdlist.ok, win_wdlist.delete, win_wdlist.edit, win_wdlist.hide)
    --wd_manager.wdWinRelated_lst_show("win_wdlist.add", "win_wdlist.ok", "win_wdlist.delete", "win_wdlist.edit", "win_wdlist.hide", "win_wdlist.ok_help", "win_wdlist.delete_help","win_wdlist.add_help","win_wdlist.edit_help", "win_wdlist.canc_help", "win_wdlist.help")
    --sknWin.show (winname)
  end

  function win_wdlist.hide ()
    o_list.hide()
    --sknWin.hide (winname)
    sknWin.showCaller()
  end
  
  -- display help text
  function win_wdlist.help (name)
    win_helper.help (26, name)
  end  

