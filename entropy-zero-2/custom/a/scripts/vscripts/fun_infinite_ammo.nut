if (IsClient()) {
  printl("\n[Infinite Ammo] Script loaded")
}

if (IsServer()) {
  Convars.RegisterConvar("sv_infinite_ammo", "0", "\n0 - Disable Infinite Ammo\n1 - Enable Infinite Clip (No need to reload)\n2 - Enable Infinite Ammo (need reload)", (FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED))
  printl("[Infinite Ammo] Registered sv_infinite_ammo")
}

local SetupCvars = function () {
  if (FileExists("ez2_cfg/cvars/sv_infinite_ammo.txt")) {
    Convars.SetInt("sv_infinite_ammo", FileToString("ez2_cfg/cvars/sv_infinite_ammo.txt").tointeger())
    printl("[Infinite Ammo] Restored saved CVar value: " + Convars.GetInt("sv_infinite_ammo").tostring())
  }
  Convars.SetChangeCallback("sv_infinite_ammo", function (var1, var2, var3, var4, var5) {
    StringToFile("ez2_cfg/cvars/sv_infinite_ammo.txt", var5.tostring())
    printl("[Infinite Ammo] Saved CVar value: " + var5.tostring())
  })
}

local InfAmmo = function (ent) {
  if (Convars.GetBool("sv_infinite_ammo")) {
    local Weapon = ent.GetActiveWeapon()
    if (Weapon != null) {
      local PrimaryAmmoType = Weapon.GetPrimaryAmmoType()
      local SecondaryAmmoType = Weapon.GetSecondaryAmmoType()
      if (Convars.GetInt("sv_infinite_ammo") == 1 && Weapon.Clip1() != Weapon.GetMaxClip1()) {
        Weapon.SetClip1(Weapon.GetMaxClip1())
      }
      if (PrimaryAmmoType >= 0) {
        ent.SetAmmoCount(PrimaryAmmoType, AmmoDef.MaxCarry(PrimaryAmmoType))
      }
      if (SecondaryAmmoType >= 0) {
        ent.SetAmmoCount(SecondaryAmmoType, AmmoDef.MaxCarry(SecondaryAmmoType))
      }
    }
  }
  return 0
}

local ScriptInit = function (ent) {
  if (!IsServer()) {
    return
  }
  player.GetOrCreatePrivateScriptScope()
  SetupCvars()
  player.SetContextThink("Inf_Ammo_Think", InfAmmo, 0)
  printl("[Infinite Ammo] Think initialized after player spawn")
}

ListenToGameEvent("player_spawn", ScriptInit, "");

Hooks.Add(this, "OnRestore", function () {
  if (!IsServer()) {
    return
  }
  player.GetOrCreatePrivateScriptScope()
  SetupCvars()
  player.SetContextThink("Inf_Ammo_Think", InfAmmo, 0)
  printl("[Infinite Ammo] Think initialized after save restore")
}, "INF_AMMO_RESTORE");
