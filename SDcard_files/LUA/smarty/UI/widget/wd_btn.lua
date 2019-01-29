-------------------------------------------------------------------
---------------------------  Widget:App buttons  ------------------
-------------------------------------------------------------------
--[[
  App Button Widget
  

    wd_btn.new (radix, desc, title)       -- add new Application button
    
  date: 28/11/2018 
  by: Raul Mungai
--]]


-- Load artworks
----------------
--css.load_btn_img ("\\buttons\\meteo.png",  "meteo")   -- app icon button
--css.load_img ("\\icons\\meteo-i.png", "meteo-i", "icon") -- app icon (small)

  
-- Global Object
wd_btn = {}
    
    -- store configuration
  function wd_btn.storeCfg(wd) 
    --hourglass.show ()
    local fname = thema.getDir() .. "cfg\\wdb_" .. wd.radix .. ".cfg"
    utils.table_save(wd, fname)
    --hourglass.hide ()
  end
 
  -- restore configuration
  function wd_btn_restoreCfg(radix)
    local fname = thema.getDir() .. "cfg\\wdb_" .. radix .. ".cfg"
    local wdR = utils.table_load(fname)
    if wdR ~= nil then
      wdR.f_reg=wd_btn.reg
      wdR.f_unreg=wd_btn.unreg
      wdR.f_move=wd_btn.pos
      wdR.f_store=wd_btn.storeCfg
      --wd_manager.widget_add (wd)      -- add to widget list
      -- executed by specific howner
      return wdR
    else
      return nil
    end
    
  end  
  
  local function wd_btn_appButton_new (winRadix, name, winname, x, y, text ,textColor)
    local xx, yy = css.button_new (name, winname, x, y, winRadix, 
        "win_" .. winRadix .. ".show", true, false, text, textColor)
    sknIbtn.auxStr(name, name)
    sknWin.longTouchCB(name, "wd_manager.moveClone")     -- help callback
  end

  -- widget reg to new parent
  function wd_btn.reg (wd, name, parent, x, y)
    wd_btn_appButton_new (wd.radix, name, parent, x, y, wd.title)
    wd_btn.storeCfg(wd)
  end
  
   -- unreg parent instance
  function wd_btn.unreg (name)
    css.button_delete(name)
  end
  
  -- widget move
  function wd_btn.pos (name, x,y)
    css.button_move (name, x, y)
  end   
  
  -- add new Application button
  function wd_btn.new (radix, desc, title)
    local bwx, bwy = sknColl.imgSize("btn", radix)
    if bwx == 0 then return end
    
    wd = wd_btn_restoreCfg(radix)
    if wd == nil then
      wd = {radix=radix, UID=0, icon=radix .. "-i", desc="Button:" .. desc, help="win_" .. radix .. ".help", size_H=bwy, size_W=bwx, f_reg=wd_btn.reg, f_unreg=wd_btn.unreg, f_move=wd_btn.pos, f_store=wd_btn.storeCfg, title=title, parents={}}
    end
    wd_manager.widget_add (wd)      -- add to widget list
    return wd
  end  

