if (IsClient()) {
  printl("\n[Increase Vitals] Script loaded")
}

if (IsServer()) {
  Convars.RegisterConvar("sv_increase_vitals", "0", "\n0 - Disable increased player vitals\n1 - Increase max health to 200 and max battery to 500", (FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED))
  printl("[Increase Vitals] Registered sv_increase_vitals")
}

local SetupCvars = function () {
  if (FileExists("ez2_cfg/cvars/sv_increase_vitals.txt")) {
    Convars.SetInt("sv_increase_vitals", FileToString("ez2_cfg/cvars/sv_increase_vitals.txt").tointeger())
    printl("[Increase Vitals] Restored saved CVar value: " + Convars.GetInt("sv_increase_vitals").tostring())
  }
  Convars.SetChangeCallback("sv_increase_vitals", function (var1, var2, var3, var4, var5) {
    StringToFile("ez2_cfg/cvars/sv_increase_vitals.txt", var5.tostring())
    printl("[Increase Vitals] Saved CVar value: " + var5.tostring())
  })
}

local ApplyVitals = function (reason) {
  if (!IsServer()) {
    return
  }
  SetupCvars()
  if (!Convars.GetBool("sv_increase_vitals")) {
    Convars.SetInt("sk_suit_maxarmor", 200)
    printl("[Increase Vitals] Disabled after " + reason + "; max battery restored to 200")
    return
  }
  player.SetMaxHealth(200)
  Convars.SetInt("sk_suit_maxarmor", 500)
  printl("[Increase Vitals] Applied after " + reason + ": max health = 200, max battery = 500")
}

ListenToGameEvent("player_spawn", function (event) {
  ApplyVitals("player spawn")
}, "");

Hooks.Add(this, "OnRestore", function () {
  ApplyVitals("save restore")
}, "INCREASE_VITALS_RESTORE");
