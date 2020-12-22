BossModDungeonModule = CreateClass()

function BossModDungeonModule.new(name, instanceId)
    local self = setmetatable({}, BossModDungeonModule)
    self.instanceId = instanceId
    self.name = name
    self.active = false
    return self
end

function BossModDungeonModule:Activate()
    self.active = true
    if (self.OnActivate) then
        self:OnActivate()
    end
end

function BossModDungeonModule:Deactivate()
    self.active = false
    if (self.OnDeactivate) then
        self:OnDeactivate()
    end
end