BossModEncounterModule = CreateClass()

function BossModEncounterModule.new(name, encounterId)
    local self = setmetatable({}, BossModEncounterModule)
    self.encounterId = encounterId
    self.name = name
    self.enabled = false
    self.combatLogEventDispatcher = EffusionRaidAssistCombatLogEventDispatcher()
    return self
end