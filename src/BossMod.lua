BossModBossMod = CreateClass()

function BossModBossMod.new(name, instanceId)
    local self = setmetatable({}, BossModDungeonModule)
    self.instanceId = instanceId
    self.name = name
    self.enabled = false
    return self
end