-------------------------------------------------------------------
---------------------------  Utilities  ---------------------------
-------------------------------------------------------------------
--[[
  Utils: string
  
    utils.getField (str, kwrd)     -- extract field value from line (comma separated)
    
  Utils: table
    utils.table_save (tbl, fname)  -- Save Table to File
    utils.table_load (fname)       -- Restore Table from File
    
  date: 08/11/2018 
  by: Raul Mungai
--]]

-- Global Object
utils = {}

  -- extract field value from line (comma separated)
  function utils.getField (str, kwrd)
    if str == nil then return "" end

    local toc
    local st
    local to
    st, to = string.find(str, kwrd, 1)
    if to == nil then return "" end
    to = to +1
    st, toc = string.find(str, ",", to)
    if st == nil then
      -- comma nont found, end of fields
      st, toc = string.find(str, "\r", to)
      if st == nil then
        return string.sub(str, to)
      else
        return string.sub(str, to, st-1)
      end
    else
      return string.sub(str, to, st-1)
    end
  end
  
  -- Save Table to File
  function utils.table_save (tbl, fname)
    local ss = "local obj1 =" .. serpent.block(tbl, {nocode = true, numformat="%u"}) .. "\nreturn obj1"
    --local ss = "local obj1 =" .. serpent.block(tbl, {nocode = true, numformat="%.1g"}) .. "\nreturn obj1"
    
    local file, e = io.open(fname, "w");
    if not file then return end
    file:write(ss)
    file:close()
  end
  
  -- Restore Table from File
  function utils.table_load (fname)
		local f, e = loadfile(fname)
		if f then
			return f();
		else
			return nil;
		end;
  end
  