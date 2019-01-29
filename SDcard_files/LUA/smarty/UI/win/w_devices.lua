-------------------------------------------------------------------
---------------------------  window:Devices  ----------------------
-------------------------------------------------------------------
--[[
  Device window
    win_devices.show ()            -- Show
    win_devices.hide ()            -- Hide
    win_devices.pos (x,y)          -- Position set
    
  internals:
    win_devices.help ()            -- display help text
    
  date: 02/01/2019 
  by: Raul Mungai
--]]


-- Load artworks
----------------
css.load_btn_img ("\\buttons\\devices.png",    "devices")   -- app icon button
css.load_btn_img ("\\icons\\devices-i.png",    "devices-i")   -- app icon (small)
  
-- Global Object
win_devices = {}

--[[
function lstOK()
  print ("List confirm:")
  local si = o_list.selectedItem()
  print ("item desc:", si.desc)
  print ("item val:", si.val)
  print ("item UID:", si.UID)
  print ("item icon:", si.icon)
end

function lstCanc()
  print ("List Cancel")
end
--]]


  function win_devices.show ()
    local idx = 1
    local wd = {}
    o_list.init()  -- clr list
    repeat
      wd = wd_manager.item_get (idx)
      if wd ~= nil then
        if wd.UID ~= 0 then
          local widget = wd.wdptr
          o_list.addItem(widget.icon, widget.desc, widget.radix ,widget.UID, wd.wdptr)
        end
      end
      idx = idx + 1
    until (wd == nil)
    o_list.options("txt", false, true)
    o_list.show(sknColl.dictGetPhrase("WIN", 30), lstOK, lstCanc, thema.btn_size)    
  end

--[[
  function win_devices.hide ()    
    sknWin.hide (winname)
  end

  function win_devices.pos (x,y)
    sknWin.pos (winname, x,y)
  end
  --]]

  -- help : return help text
  function win_devices.help (name)
    win_helper.help (34, name)
  end
  
-- win_devices_create ()   -- Window creation
