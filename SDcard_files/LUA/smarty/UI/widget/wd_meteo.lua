-------------------------------------------------------------------
---------------------------  Widget:Meteo  ------------------------
-------------------------------------------------------------------
--[[
  Meteo Widget
  
    
  Elements:
    wd_meteo.status (meteo)           -- set Meteo info (actually image only)
    
    
  internals:
    
  date: 22/11/2018 
  by: Raul Mungai
--]]


-- Load artworks
----------------
--css.load_btn_img ("\\buttons\\meteo.png",  "meteo")   -- app icon button
css.load_img ("\\icons\\meteo-i.png", "meteo-i", "icon") -- app icon (small)

-- meteo icons
css.load_img ("\\meteo\\meteo_pioggia.png", "pioggia", "icon")
css.load_img ("\\meteo\\meteo_sole.png", "sole", "icon")
css.load_img ("\\meteo\\meteo_soleggiato.png", "soleggiato", "icon")
css.load_img ("\\meteo\\meteo_temporali.png", "temporali", "icon")

  
-- Global Object
wd_meteo = {}
    
  local widget_meteo = {radix="meteo", UID=0, tipo="D", icon="meteo-i", zone="", desc="Meteo", help=sknColl.dictGetPhrase("HELP", 15), size_H=0, size_W=0, f_reg=nil, f_unreg=nil, f_move=nil, f_store=nil, p_temp=0, p_hum=0, p_meteo="", parents={}}
    
  local meteoStatus = "pioggia"
  local fname = thema.getDir() .. "cfg\\wd_meteo.cfg"
  

  -- set meteo image
  function meteo_picture (name, meteoImg)      
    sknIbtn.imgpress (name, 0, "icon", meteoImg)
    sknIbtn.imgunpress (name, 0, "icon", meteoImg)
    sknIbtn.imgdisabled (name, 0, "icon", meteoImg)
    local keyX, keyY = sknIbtn.size(name)
    return keyX, keyY
  end 

  -- Special Buttons: new (multi format)
  local function meteo_new (name , winName, x, y, event, show)
    sknIbtn.create (name, winName, x, y, 0, 0)
    sknIbtn.auxStr (name, name) -- obj name refenrence
    local keyX, keyY = meteo_picture(name, meteoStatus)
    sknIbtn.keyReleaseCB (name, event)
    if show == true then
      sknIbtn.show (name)	
    end
    return keyX, keyY
  end 
  
  -- store configuration
  local function wd_meteo_storeCfg() 
    --hourglass.show ()
    utils.table_save(widget_meteo.parents, fname)
    --hourglass.hide ()
  end
 
  -- restore configuration
  local function wd_meteo_restoreCfg()
    local parents = utils.table_load(fname)
    if parents ~= nil then
      -- create parent objets
      for i=1, #parents do
        table.insert(widget_meteo.parents, {parent=parents[i].parent, name=parents[i].name, x=parents[i].x, y=parents[i].y})
      end
    end
  end    
  
  -- Special Buttons: new (multi format)
  local function meteo_delete (name)
    sknIbtn.delete (name)
  end 

  -- widget reg to new parent
  function wd_meteo.reg (wd, name, parent, x, y)
    meteo_new (name, parent, x, y, "", true)
    wd_meteo_storeCfg()
  end
  
  -- unreg parent instance
  function wd_meteo.unreg (name)
    meteo_delete (name)
  end
  
  -- widget move
  function wd_meteo.pos (name, x,y)
    sknWin.pos (name, x,y)
  end    
  
  -- widget startUp
  local function wd_meteo_startUp()
    -- cfg widget members
    widget_meteo.f_reg = wd_meteo.reg
    widget_meteo.f_unreg = wd_meteo.unreg
    widget_meteo.f_move = wd_meteo.pos
    widget_meteo.f_store = wd_meteo_storeCfg
    
    widget_meteo.size_W, widget_meteo.size_H = sknColl.imgSize("icon", "pioggia")
    
    wd_meteo_restoreCfg()
    
    wd_manager.widget_add (widget_meteo)      -- add to widget list
  end
    
  -- set Luce status
  function wd_meteo.status (meteo)
    meteoStatus = meteo
    -- update all instances
    for i=1, #widget_meteo.parents do
      meteo_picture (widget_meteo.parents[i].name, meteo)   
    end
    return 1
  end

-- widget startUp
wd_meteo_startUp()
