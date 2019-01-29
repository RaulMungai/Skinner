-- Skinner config
sknSys.start(false)

sknColl.addDict ("DATE", 50, 5000)
sknColl.addDict ("WIN", 200, 30000)
sknColl.addDict ("HELP", 200, 300000)

-- Set language, working disk and Thema
--sknColl.dictLoad ("GEN", "ITA", "mmc:\\skn\\DApp.txt")	
thema.workDisk = "\\LUA\\smarty\\UI\\"                  -- working disk
thema.thema = "res\\"                                   -- thema (resources)
thema.language="ITA"

sknSys.tplongTouch (true, 1500, 8000)   -- Long touch enabled

-- Animation
sknDesk.anicfg(10, 150, "shift")
sknDesk.autohidecfg(10, 150)
sknSys.tpMove ("", "", "", "")      -- callback to be configured
sknSys.tpSens(10, 5)    -- Hi sensitivity
