BossModDungeonModuleManager = CreateClass()

function BossModDungeonModuleManager.new()
    local self = setmetatable({}, BossModDungeonModuleManager)
    self.modules = {}
    self.activeModules = {}
    EffusionRaidAssistBossMod:AddEventCallback(EffusionRaidAssist.CustomEvents.DungeonEntered, self, self.EnterDungeon)
    EffusionRaidAssistBossMod:AddEventCallback(EffusionRaidAssist.CustomEvents.DungeonLeft, self, self.LeaveDungeon)
    return self
end

function BossModDungeonModuleManager:Init()
    for _, module in pairs(self.modules) do
        module:Init()
    end
end

function BossModDungeonModuleManager:EnterDungeon(dungeon)
    local modules = self:GetModulesByInstanceId(dungeon.instanceId)
    if (#modules > 0) then
        for _, module in pairs(modules) do
            module:Activate()
            self.activeModules[module.name] = module
        end
        EffusionRaidAssistBossMod:ChatMessage("Activated Module(s) for Dungeon:", dungeon.name)
    else
        EffusionRaidAssistBossMod:ChatMessage("No Module found for Dungeon:", dungeon.name, dungeon.instanceId)
    end
end

function BossModDungeonModuleManager:LeaveDungeon(dungeon)
    local modules = self:GetModulesByInstanceId(dungeon.instanceId)
    if (#modules > 0) then
        for _, module in pairs(modules) do
            module:Deactivate()
            self.activeModules[module.name] = nil
        end
        EffusionRaidAssistBossMod:ChatMessage("Deactivated Module(s) for Dungeon:", dungeon.name)
    end
end

function BossModDungeonModuleManager:GetModules()
    return self.modules
end

function BossModDungeonModuleManager:GetEnabledModules()
    local result = {}
    for _, module in pairs(self:GetModules()) do
        if (module:IsEnabled()) then
            table.insert(result, module)
        end
    end
    return result
end

function BossModDungeonModuleManager:GetModulesByInstanceId(instanceId)
    local modules = {}
    for _, module in pairs(self:GetModules()) do
        if module.instanceId == instanceId then
            table.insert(modules, module)
        end
    end
    return modules
end

function BossModDungeonModuleManager:NewModule(name, instanceId)
    local newModule = BossModDungeonModule(name, instanceId)
    self:AddModule(newModule)
    return newModule
end

function BossModDungeonModuleManager:AddModule(module)
    module.id = #self.modules
    table.insert(self.modules, module)
end
