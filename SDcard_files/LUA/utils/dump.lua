 
-- Dump Lua objects
    
local seen={}    

function dump(t,i)

  if t == nil then 
    print ("No object : " .. i) 
    return 
  end

  seen[t]=true
  local s={}
  local n=0
  for k in pairs(t) do
      n=n+1 s[n]=k
  end
  table.sort(s)
  for k,v in ipairs(s) do
          
    if type(t[v]) == "function" then
      print(i .. "." .. v .. "()")
    elseif type(t[v]) == "string" then
      print(i .. "." .. v .. " = \"" .. t[v] .. "\"")
    elseif type(t[v]) == "number" then
      print(i .. "." .. v .. " = " .. t[v] )
    elseif type(t[v]) == "userdata" then
      print(i .. "." .. v .. " UserData")

    elseif type(t[v]) == "boolean" then
      if t[v] == false then
         print(i .. "." .. v .. " = false")
      else
         print(i .. "." .. v .. " = true")
      end
    elseif type(t[v]) == "nil" then
      print(i .. "." .. v .. " = nil" )

    elseif type(t[v]) == "table" then
      print(i .. "." .. v .."\t[table]")
    else
      -- print(i .. "." .. v)
      print(i .. "." .. v , type(t[v]))
    end
            -- print(i,v)
    v=t[v]
    if type(v)=="table" and not seen[v] then
      --dump(v,i.."\t")
      dump(v,i)
    end
  end
end

    --dump(string,"string")
    --dump(_G,"_G")
    ---- END
    
    
    