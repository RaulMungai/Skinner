    -- Select Virtual device
   -- nut.setVdev ("ser", 1, 115200)
    
    --[[
    -- Wait for USB connect
    for t=1, 4 do
      io.write ("*")
      os.sleep(1000)
    end
    --]]
  
-- Load specific application
dofile ("\\LUA\\smarty\\smarty.lua")
