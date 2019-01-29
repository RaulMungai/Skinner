 
-- Dump Lua objects
    
local seen={}    

function dumptab(t,i)

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
          
    if type(t[v]) == "table" then
      print(i .. "." .. v .."\t\t\t[table]")
    end

    v=t[v]
    if type(v)=="table" and not seen[v] then
      dumptab(v,i)
    end
  end
end

    --dumptab(string,"string")
    --dumptab(_G,"_G")
    ---- END
    
    
    