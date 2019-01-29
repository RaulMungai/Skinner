-- Load User Interface

-- Config package resources
-- Button images (Collection bundle)
sknColl.addImgColl ("btn", 100, 2000000)      -- button: unpress
sknColl.addImgColl ("btnP", 100, 2000000)     -- button: press
sknColl.addImgColl ("btnD", 100, 2000000)     -- button: disabled

-- Button images
sknColl.addImgColl ("icon", 50, 1000000)    -- icons

-- Large images
sknColl.addImgColl ("BG", 10, 2000000)      -- background
sknColl.addImgColl ("IMG", 30, 1500000)     -- middle images
sknColl.addImgColl ("LAYOUT", 30, 1000000)  -- Layout images

-- Load thema support
dofile ("\\LUA\\smarty\\UI\\thema.lua")     -- Thema management

-- Load UI basics modules
dofile (thema.workDisk .. "\\skncfg.lua")    -- Skinner Config
dofile (thema.workDisk .. "\\skncss.lua")    -- CSS functions
  
-- Splash Form
dofile (thema.workDisk .. "\\boot\\splash.lua")

-- Load artworks
----------------

-- Mount base fonts (used in Thema)
css.font_mount (thema.workDisk .. "res\\font\\F08_1_S.txt", "F8")
css.font_mount (thema.workDisk .. "res\\font\\F16B_1_S.txt", "F16B")
css.font_mount (thema.workDisk .. "res\\font\\F24B_1_S.txt", "F24B")
css.font_mount (thema.workDisk .. "res\\font\\F32B_1_S.txt", "F32B")
  
-- Load all UI components

-- Load plugins
--[[
dofile ("\\LUA\\app\\skn\\plugin\\meteo.lua")
win_splash.loadProgress (5)
--]]

thema.loadDict()
win_splash.loadProgress (5)


dofile ("\\LUA\\utils\\serpent.lua")   -- persistence module
win_splash.loadProgress (6)

dofile ("\\LUA\\smarty\\UI\\utils.lua")   -- utilities
win_splash.loadProgress (7)

dofile ("\\LUA\\smarty\\UI\\components\\hrglass.lua")   -- hourglass
win_splash.loadProgress (8)

dofile ("\\LUA\\smarty\\UI\\components\\helper.lua")   -- helper module
win_splash.loadProgress (12)

dofile ("\\LUA\\smarty\\UI\\components\\popup.lua")    -- PopUp module
win_splash.loadProgress (13)

dofile ("\\LUA\\smarty\\UI\\components\\popupYN.lua")    -- PopUp Y-N module

dofile ("\\LUA\\smarty\\UI\\components\\wintool.lua")    -- Windows tool
win_splash.loadProgress (14)

dofile ("\\LUA\\smarty\\UI\\components\\keyboard.lua") -- Keyboard module
win_splash.loadProgress (18)

dofile ("\\LUA\\smarty\\conn\\CCC\\ccc_wrapper.lua")    -- CCC wrapper
--win_splash.loadProgress (22)

dofile ("\\LUA\\smarty\\UI\\components\\bgraph.lua")  -- Ball Graph drawer
win_splash.loadProgress (22)

dofile ("\\LUA\\smarty\\UI\\components\\w_dynwin.lua")  -- Dynamic window manager
win_splash.loadProgress (25)

dofile (thema.workDisk .. "support\\w_selector.lua")   -- ShortCut Window selector and Window slide show
win_splash.loadProgress (27)

dofile (thema.workDisk .. "support\\w_floatbar.lua")   -- Float bar
win_splash.loadProgress (28)

dofile (thema.workDisk .. "components\\o_list.lua")   -- list
win_splash.loadProgress (29)

dofile (thema.workDisk .. "components\\wd_manager.lua")   -- Widgets manager
win_splash.loadProgress (30)

dofile (thema.workDisk .. "components\\w_wdlist.lua")   -- Widget list (current win)

dofile (thema.workDisk .. "components\\w_wdadd.lua")   -- Add Widget to list (current win)
win_splash.loadProgress (31)

dofile (thema.workDisk .. "components\\w_wmodify.lua")   -- Window modify
win_splash.loadProgress (32)

dofile (thema.workDisk .. "widget\\wd_meteo.lua")   -- Widget: Meteo
win_splash.loadProgress (33)

dofile (thema.workDisk .. "widget\\wd_repelect.lua")   -- Widget: Report Electricity
win_splash.loadProgress (34)

dofile (thema.workDisk .. "widget\\wd_luci.lua")   -- Widget: Luci control
win_splash.loadProgress (35)

dofile (thema.workDisk .. "widget\\wd_vocco2e.lua")   -- Widget: VOC e CO2e sensor

dofile (thema.workDisk .. "widget\\wd_sensTU.lua")   -- Widget: TU sensor
win_splash.loadProgress (36)

dofile (thema.workDisk .. "widget\\wd_sensT.lua")    -- Widget: T sensor
win_splash.loadProgress (37)

dofile (thema.workDisk .. "widget\\wd_emeter.lua")   -- Widget: Electric Meter
win_splash.loadProgress (38)

dofile (thema.workDisk .. "widget\\wd_switch.lua")   -- Widget: Switch
win_splash.loadProgress (39)

dofile (thema.workDisk .. "widget\\wd_btn.lua")   -- Widget: App buttons
win_splash.loadProgress (40)

dofile (thema.workDisk .. "win\\w_devadd.lua")    -- device add window
win_splash.loadProgress (41)

dofile (thema.workDisk .. "win\\w_devserv.lua")   -- device services window
win_splash.loadProgress (42)

dofile (thema.workDisk .. "win\\w_devinfo.lua")    -- device info window
win_splash.loadProgress (43)

dofile (thema.workDisk .. "win\\w_usrwins.lua")   -- Usr Window selection
win_splash.loadProgress (44)

-- Load all windows
dofile (thema.workDisk .. "win\\w_home.lua")
win_splash.loadProgress (45)

dofile (thema.workDisk .. "app\\w_calc.lua")
win_splash.loadProgress (50)

dofile (thema.workDisk .. "plugin\\w_wifi.lua")
win_splash.loadProgress (52)

--dofile (thema.workDisk .. "plugin\\XXXXX.lua")
--win_splash.loadProgress (53)

dofile (thema.workDisk .. "win\\w_devices.lua")
win_splash.loadProgress (55)

dofile (thema.workDisk .. "win\\w_debug.lua")
win_splash.loadProgress (58)

dofile (thema.workDisk .. "win\\w_settings.lua")
win_splash.loadProgress (62)




if appcfg_MQTT_active == true then
  dofile ("\\LUA\\smarty\\conn\\MQTT\\mqtt.lua")
  win_splash.loadProgress (75)

  dofile (thema.workDisk .. "win\\w_aws.lua")
  win_splash.loadProgress (78)
end

-- after all available windows
dofile (thema.workDisk .. "win\\w_apps.lua")
win_splash.loadProgress (92)

	-- Sound
	-- sknColl.soundNew ("Sound1")
	-- sknColl.soundAddsample ("Sound1", "SOL", 0, 12) 

--[[
function load_sImg_all()
  sknColl.addImgColl ("simg", 100, 500000)
  sknColl.imgAdd ("simg", thema.workDisk .. "res\\simg\\WiLSW-.bmp", "slevelS", false, false)
  sknColl.imgAdd ("simg", thema.workDisk .. "res\\simg\\WiLSWX.bmp", "slevelX", false, false)
	sknColl.imgAdd ("simg", thema.workDisk .. "res\\simg\\WiLSW0.bmp", "slevel0", false, false)
  sknColl.imgAdd ("simg", thema.workDisk .. "res\\simg\\WiLSW1.bmp", "slevel1", false, false)
  sknColl.imgAdd ("simg", thema.workDisk .. "res\\simg\\WiLSW2.bmp", "slevel2", false, false)
  sknColl.imgAdd ("simg", thema.workDisk .. "res\\simg\\WiLSW3.bmp", "slevel3", false, false)
  sknColl.imgAdd ("simg", thema.workDisk .. "res\\simg\\WiLSW4.bmp", "slevel4", false, false)
  
  sknColl.imgAdd ("simg", thema.getDir() .. "\\simg\\tachOK.bmp", "pwrInd", true, false)
  sknColl.imgAdd ("simg", thema.getDir() .. "\\simg\\_tmetn.bmp", "_pwrInd", true, false)
  
  sknColl.imgAdd ("simg", thema.getDir() .. "\\simg\\top_bar.bmp", "topBar", true, false)
end


function load_animationImages_all()
  sknColl.addImgColl ("ani", 50, 500000) 
  
  -- Wait icon
	sknColl.imgAdd ("ani", thema.getDir() .. "\\anim\\wait\\wait1.png", "wait1t", false, true)
  sknColl.imgAdd ("ani", thema.getDir() .. "\\anim\\wait\\wait2.png", "wait2t", false, true)
  sknColl.imgAdd ("ani", thema.getDir() .. "\\anim\\wait\\wait3.png", "wait3t", false, true)
  sknColl.imgAdd ("ani", thema.getDir() .. "\\anim\\wait\\wait4.png", "wait4t", false, true)
  sknColl.imgAdd ("ani", thema.getDir() .. "\\anim\\wait\\wait5.png", "wait5t", false, true)
  sknColl.imgAdd ("ani", thema.getDir() .. "\\anim\\wait\\wait6.png", "wait6t", false, true)
  sknColl.imgAdd ("ani", thema.getDir() .. "\\anim\\wait\\wait7.png", "wait7t", false, true)
  sknColl.imgAdd ("ani", thema.getDir() .. "\\anim\\wait\\wait8.png", "wait8t", false, true)

  -- wait icon whell
  sknColl.imgAdd ("ani", thema.workDisk .. "res\\anim\\whell\\wheel1.bmp", "wait1", false, false)
  sknColl.imgAdd ("ani", thema.workDisk .. "res\\anim\\whell\\wheel2.bmp", "wait2", false, false)
  sknColl.imgAdd ("ani", thema.workDisk .. "res\\anim\\whell\\wheel3.bmp", "wait3", false, false)
  sknColl.imgAdd ("ani", thema.workDisk .. "res\\anim\\whell\\wheel4.bmp", "wait4", false, false)
  sknColl.imgAdd ("ani", thema.workDisk .. "res\\anim\\whell\\wheel5.bmp", "wait5", false, false)
  sknColl.imgAdd ("ani", thema.workDisk .. "res\\anim\\whell\\wheel6.bmp", "wait6", false, false)
  sknColl.imgAdd ("ani", thema.workDisk .. "res\\anim\\whell\\wheel7.bmp", "wait7", false, false)
  sknColl.imgAdd ("ani", thema.workDisk .. "res\\anim\\whell\\wheel8.bmp", "wait8", false, false)

  --swoff
  sknColl.imgAdd ("ani", thema.getDir() .. "\\anim\\cnt\\swoff0.bmp", "swoff1", false, false)
  sknColl.imgAdd ("ani", thema.getDir() .. "\\anim\\cnt\\swoff1.bmp", "swoff2", false, false)
  sknColl.imgAdd ("ani", thema.getDir() .. "\\anim\\cnt\\swoff2.bmp", "swoff3", false, false)
  sknColl.imgAdd ("ani", thema.getDir() .. "\\anim\\cnt\\swoff3.bmp", "swoff4", false, false)
  
  --Testing
  sknColl.imgAdd ("ani", thema.getDir() .. "\\anim\\x\\ad.bmp", "x1", false, false)
  sknColl.imgAdd ("ani", thema.getDir() .. "\\anim\\x\\ad_.bmp", "x2", false, false)

end


function load_imageList_all()
  sknMimage.new ("waitDev_mimg") 
	sknMimage.addimage ("waitDev_mimg", "ani", "wait1")
  sknMimage.addimage ("waitDev_mimg", "ani", "wait2")
  sknMimage.addimage ("waitDev_mimg", "ani", "wait3")
  sknMimage.addimage ("waitDev_mimg", "ani", "wait4")
  sknMimage.addimage ("waitDev_mimg", "ani", "wait5")
  sknMimage.addimage ("waitDev_mimg", "ani", "wait6")
  sknMimage.addimage ("waitDev_mimg", "ani", "wait7")
  sknMimage.addimage ("waitDev_mimg", "ani", "wait8")
  
  sknMimage.addimage ("waitDev_mimg", "ani", "swoff1")
  sknMimage.addimage ("waitDev_mimg", "ani", "swoff2")
  sknMimage.addimage ("waitDev_mimg", "ani", "swoff3")
  sknMimage.addimage ("waitDev_mimg", "ani", "swoff4")

  sknMimage.addimage ("waitDev_mimg", "ani", "x1")
  sknMimage.addimage ("waitDev_mimg", "ani", "x2")

	sknMimage.showtime ("waitDev_mimg", 500)
end
--]]

-- load btn free images
css.load_btn_img ("\\buttons\\vocs.png",  "vocs")
css.load_btn_img ("\\buttons\\colors.png",   "color")
css.load_btn_img ("\\buttons\\controller.png",   "controller")
css.load_btn_img ("\\buttons\\calendar.png",   "calendar")
css.load_btn_img ("\\buttons\\chart_bar.png",   "chart_bar")
css.load_btn_img ("\\buttons\\chart_curve.png",   "chart_curve")
css.load_btn_img ("\\buttons\\chart_line.png",   "chart_line")
css.load_btn_img ("\\buttons\\chart_pie.png",   "chart_pie")
css.load_btn_img ("\\buttons\\textEdit.png","textwrite")

win_splash.loadProgress (95)

win_wintool.win_mount ()    -- mount dynamic windows

win_splash.loadProgress (98)
wd_manager.reloadParents ()   -- windget activation to parent (after ALL widgets On)
win_splash.loadProgress (100)

-- END of Application loading

