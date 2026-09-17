local HIGH_HEALTH = 1000000000
local MASK_SHOT = 0x4600400B

local SetHighHealth = function (command, ...) {
  local invoker = player
  if (invoker == null || !invoker.IsPlayer()) {
    printl("[High Health] The local player is unavailable.")
    return
  }
  local start = invoker.EyePosition()
  local trace = TraceLineComplex(start, start + AngleVectors(invoker.EyeAngles()) * 56756, invoker, MASK_SHOT, COLLISION_GROUP_NONE)
  local target = trace.Entity()
  trace.Destroy()
  if (target == null || !target.IsNPC()) {
    printl("[High Health] The player is not looking at an NPC.")
    return
  }
  local classname = target.GetClassname()
  local targetname = target.GetName()
  target.SetMaxHealth(HIGH_HEALTH)
  target.SetHealth(HIGH_HEALTH)
  printl("[High Health] The health of an entity(" + classname + ", " + targetname + ") has increased.")
}

if (IsServer()) {
  Convars.RegisterCommand("set_high_health", SetHighHealth, "Set the aimed NPC's max health and health to 1,000,000,000.", 0)
  printl("[High Health] Registered set_high_health")
}
