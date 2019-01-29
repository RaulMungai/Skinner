-------------------------------------------------------------------
---------------------------  component:ballGraph  ------------------
-------------------------------------------------------------------
--[[
  Bar Graph
  
    ballGraph.create (name, win, x, y, w, h)   -- create ball graph
    ballGraph.show ()                          -- Show
    ballGraph.hide ()                          -- Hide
    ballGraph.pos (x,y)                        -- Position set
    
  internals:
    ballGraph.redraw (name)                    -- Redraw callback
    
  date: 27/10/2018 
  by: Raul Mungai
--]]

-- Load artworks
----------------
--css.load_btn_img ("\\buttons\\back.png",            "back") 
--css.load_img ("\\icons\\hand.png", "hand", "icon")    -- move icon

css.font_mount (thema.workDisk .. "res\\font\\F16B_1_S.txt", "F16B")

  
-- Global Object
ballGraph = {}
 
  local gData = {
    {val=230, txt="Forno", color="red"};
    {val=100, txt="Lavatrice", color="green"};
    {val=96, txt="Asciug.", color="lightblue"};
    {val=91, txt="TV", color="magenta"};
    {val=25, txt="Luci", color="yellow"};
    {val=10, txt="Charger", color="blue"};
    {val=10, txt="Caldaia", color="black"};
    {val=5, txt="Altro", color="gray"};
  }
  

function ballGraph.Xredraw (name)
  print ("LUA Callback:ballGraph_redraw, param="..name)
  
sknDraw.clear ("yellow")
  
  
  sknDraw.line (10, 50, 110, 90, "red", 2)
end

-- redraw callback
function ballGraph.redraw (name)
  local w,h = sknLbl.size(name)

  -- total area calculation
  local maxval = 0
  for i=1, #gData do
    maxval = maxval + gData[i].val
  end
  --maxval = maxval * 2 -- radius * 2
  if #gData < 5 then
    maxval = maxval * 1.3 -- radiud * 2
  end
  
  local scale
  if w > h then
    scale = h / maxval
  else
    scale = w / maxval
  end
  
  --print ("Scale=", scale)
  sknDraw.clear ("black")

  local vv
  local vv2
  local ix = 0
  local iy = 0
  local lastvv = 0
  local baseY = 0
  local maxxH = 0
  for i=1, #gData do
    vv = math.floor(gData[i].val * scale)
    vv2 = vv + vv
    --print ("vv,lastvv" , vv, lastvv)
    if i == 1 then
      -- 1st element (biggest)
      ix = vv
      iy = vv
    else
      ix = ix + lastvv + vv
      --iy = baseY + vv
    end
    
    if ix + vv > w then
      -- X overflow
      iy = maxxH
      baseY = iy 
      ix = vv
      maxxH = 0
    end
    
    --print ("ix,iy" , ix, iy)
    sknDraw.fillcircle (ix, iy, vv, gData[i].color, 1)
    local tw = 120
    local th = 16
    if vv2 > tw then
      tw = vv2
    end
    
    if vv > th then
      th = vv
    end

    sknDraw.text (ix-vv, iy-(th//2), tw, th, "white", "transparent", "F16B", gData[i].txt, "HorCenter_VertCenter", "word")
    lastvv = vv
    if maxxH < iy + vv then
      maxxH = iy + vv
    end
    
  end
end



function ballGraph.create (name, win, x, y, w, h)
  if sknLbl.create(name, win, x, y, w, h, "HorCenter_VertCenter", "") == 0 then
    return 0
  end
  sknLbl.paintCB(name, "ballGraph.redraw")
  return 1
end

function ballGraph.show (name)
  sknLbl.show(name)
  --sknWin.refresh(name)
end

