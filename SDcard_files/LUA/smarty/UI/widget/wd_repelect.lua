-------------------------------------------------------------------
---------------------------  Widget:Reporting Elect  --------------
-------------------------------------------------------------------
--[[
  Reporting Electric consumption Widget
  

  internals:
    
  date: 24/11/2018 
  by: Raul Mungai
--]]


-- Load artworks
----------------
css.load_img ("\\icons\\emeterr-i.png", "report-i", "icon") -- app icon (small)

  
-- Global Object
wd_repelect = {}
    
  local widget_repe = {radix="repele", UID=0, tipo="D", icon="report-i", zone="", desc="Report Electr", help=sknColl.dictGetPhrase("HELP", 29), size_H=0, size_W=0, f_reg=nil, f_unreg=nil, f_move=nil, f_store=nil, parents={}}
    
  local fname = thema.getDir() .. "cfg\\wd_repelect.cfg"
  
  local function repelect_new (name , winName, x, y)
    ballGraph.create (name, winName, x, y, 400, 220)
    ballGraph.show (name)
    return 400, 220
  end 
  
  -- store configuration
  local function wd_repelect_storeCfg() 
    --hourglass.show ()
    utils.table_save(widget_repe.parents, fname)
    --hourglass.hide ()
  end
 
  -- restore configuration
  local function wd_repelect_restoreCfg()
    local parents = utils.table_load(fname)
    if parents ~= nil then
      -- create parent objets
      for i=1, #parents do
        table.insert(widget_repe.parents, {parent=parents[i].parent, name=parents[i].name, x=parents[i].x, y=parents[i].y})
      end
    end
  end    
  
  local function repelect_delete (name)
    sknWin.delete (name)
  end 

  -- widget reg to new parent
  function wd_repelect.reg (wd, name, parent, x, y)
    repelect_new(name, parent, x, y)
    wd_repelect_storeCfg()
  end
  
  -- unreg parent instance
  function wd_repelect.unreg (name)
    repelect_delete (name)
  end
  
  -- widget move
  function wd_repelect.pos (name, x,y)
    sknWin.pos (name, x,y)
  end    
  
  -- widget startUp
  local function wd_repelect_startUp()
    -- cfg widget members
    widget_repe.f_reg = wd_repelect.reg
    widget_repe.f_unreg = wd_repelect.unreg
    widget_repe.f_move = wd_repelect.pos
    widget_repe.f_store = wd_repelect_storeCfg
    
    wd_repelect_restoreCfg()
    
    wd_manager.widget_add (widget_repe)      -- add to widget list
  end
    

-- widget startUp
wd_repelect_startUp()
