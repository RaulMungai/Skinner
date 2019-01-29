-------------------------------------------------------------------
---------------------------  window:add widget to list  -----------
-------------------------------------------------------------------
--[[
  current widget list window
  
    win_wdadd.show ()              -- Show
    win_wdadd.hide ()              -- Hide
    win_wdadd.pos (x,y)            -- Position set
    
  internals:
    win_wdadd.help ()              -- display help text
    
  date: 17/10/2018 
  by: Raul Mungai
--]]


-- Load artworks
----------------
-- top bar icons
css.load_btn_img ("\\buttons\\plugin_add.png",  "wdlist") 
css.load_btn_img ("\\buttons\\back.png",  "back") 
  
  
-- Global Object
win_wdadd = {}
  
  local wdWinList_tmp = {}
  local wWinName = ""   -- current edit window 
  
  -- add widget
  function win_wdadd.ok ()
    local wd = o_list.selectedItem()
    if wd == nil then return end
    local ww = wd.wdptr
    if ww == nil then return end
    -- add parent to widget
    wd_manager.addParent (ww, wd_manager.workingParent)
    win_wdadd.hide ()
  end
  

  function win_wdadd.show ()
    wWinName = sknWin.currwin()
    wd_manager.wdWinFree_lst_show(sknColl.dictGetPhrase("WIN", 24), win_wdadd.ok, win_wdadd.hide)
  end

  function win_wdadd.hide ()
    o_list.hide()
    sknSys.asyncFunct ("win_wdlist.shoR", "")
    -- win_wdlist.showReturn ()
  end
  
  function win_wdlist.shoR()
    win_wdlist.showReturn()
  end

  -- display help text
  function win_wdadd.help (name)
    win_helper.help (26, name)
  end  
  
-- win_wdadd_create ()   -- Window creation
