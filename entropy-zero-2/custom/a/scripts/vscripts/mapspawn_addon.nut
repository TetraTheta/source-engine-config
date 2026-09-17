printl("\n[SC Loader] Loading gameplay scripts")

local InfiniteAmmoLoaded = DoIncludeScript("fun_infinite_ammo", this)
local IncreaseVitalsLoaded = DoIncludeScript("fun_increase_vitals", this)
local HighHealthLoaded = DoIncludeScript("fun_high_health", this)

printl("[SC Loader] fun_infinite_ammo: " + (InfiniteAmmoLoaded ? "loaded" : "failed"))
printl("[SC Loader] fun_increase_vitals: " + (IncreaseVitalsLoaded ? "loaded" : "failed"))
printl("[SC Loader] fun_high_health: " + (HighHealthLoaded ? "loaded" : "failed"))
