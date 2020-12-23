EffusionRaidAssistBossMod = EffusionRaidAssist.ModuleManager:NewModule("BossMod")

EffusionRaidAssistBossMod.DungeonModuleManager = BossModDungeonModuleManager()

EffusionRaidAssist.CustomEvents["TimerStarted"] = "BOSSMOD_TIMER_STARTED" -- (timer)
EffusionRaidAssist.CustomEvents["TimerEnded"] = "BOSSMOD_TIMER_ENDED" -- (timer)
EffusionRaidAssist.CustomEvents["TimerAborted"] = "BOSSMOD_TIMER_ABORTED" -- (timer)


function EffusionRaidAssistBossMod:OnModuleInitialize()
    EffusionRaidAssist.FramePool:RegisterCustomType("BossModTimer", EffusionRaidAssistBossModTimer)
    self.TimerManager = BossModTimerManager()
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
    self.TimerManager:Clear()
end

function EffusionRaidAssistBossMod:NewDungeonModule(name, instanceId)
    return self.DungeonModuleManager:NewModule(name, instanceId)
end

function EffusionRaidAssistBossMod:GetOptions()
    return {
        toggle_anchor = {
            order = 1,
            type = "execute",
            name = "Toggle Anchor",
            func = BindCallback(self.TimerManager, self.TimerManager.ToggleAnchor),
            width = "full"
        }
    }
end
