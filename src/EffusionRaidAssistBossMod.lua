EffusionRaidAssistBossMod = EffusionRaidAssist.ModuleManager:NewModule("BossMod")

EffusionRaidAssistBossMod.DungeonModuleManager = BossModDungeonModuleManager()

function EffusionRaidAssistBossMod:OnModuleInitialize()
    EffusionRaidAssist.FramePool:RegisterCustomType("BossModTimer", EffusionRaidAssistBossModTimer)
    self.TimerManager = BossModTimerManager()
    self.TimerManager:StartTimer()
end

function EffusionRaidAssistBossMod:OnModuleUninitialize()
    if (EffusionRaidAssist.DungeonManager:IsInDungeon()) then
        self.DungeonModuleManager:LeaveDungeon(EffusionRaidAssist.DungeonManager:GetDungeonInfo())
    end
end

function EffusionRaidAssistBossMod:OnEnable()
    if (EffusionRaidAssist.DungeonManager:IsInDungeon()) then
        self.DungeonModuleManager:EnterDungeon(EffusionRaidAssist.DungeonManager:GetDungeonInfo())
    end
end

function EffusionRaidAssistBossMod:OnDisable()
    if (EffusionRaidAssist.DungeonManager:IsInDungeon()) then
        self.DungeonModuleManager:LeaveDungeon(EffusionRaidAssist.DungeonManager:GetDungeonInfo())
    end
end

function EffusionRaidAssistBossMod:NewDungeonModule(name, instanceId)
    return self.DungeonModuleManager:NewModule(name, instanceId)
end

function EffusionRaidAssistBossMod:GetOptions()
    return {
        test2 = {
            order = 1,
            type = "toggle",
            name = "Test Option",
            get = function()
                return true
            end,
            set = function(_, value)
           
            end,
        }
    }
end
