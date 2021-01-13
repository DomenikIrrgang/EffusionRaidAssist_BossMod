EffusionRaidAssistBossMod = EffusionRaidAssist.ModuleManager:NewModule("BossMod")

EffusionRaidAssistBossMod.DungeonModuleManager = BossModDungeonModuleManager()

function EffusionRaidAssistBossMod:OnModuleInitialize()
    self.TimerManager = BossModTimerManager()
    self.NamePlateTimerManager = BossModNamePlateTimerManager()
    EffusionRaidAssist.FramePool:RegisterCustomType("BossModTimer", EffusionRaidAssistBossModTimer)
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
    self.NamePlateTimerManager:Clear()
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
        },
        color_full = {
            order = 3,
            type = "color",
            name = "Timer Color (Full)",
            get = function()
                local color = self:GetData("timer.colorFull")
                return color.red, color.green, color.blue, color.alpha
            end,
            set = function(_, r, g, b, a)
                self:ChangeData("timer.colorFull", EffusionRaidAssistColor(r, g, b, a))
            end,
        },
        color_empty = {
            order = 2,
            type = "color",
            name = "Timer Color (Empty)",
            get = function()
                local color = self:GetData("timer.colorEmpty")
                return color.red, color.green, color.blue, color.alpha
            end,
            set = function(_, r, g, b, a)
                self:ChangeData("timer.colorEmpty", EffusionRaidAssistColor(r, g, b, a))
             end,
        },
        timer_width = {
            order = 4,
            type = "range",
            name = "Width",
            get = self:OptionsGetter("timer.width"),
            set = self:OptionsSetter("timer.width"),
            step = 1,
            min = 100,
            max = 500,
            width = "full"
        },
        timer_height = {
            order = 5,
            type = "range",
            name = "Height",
            get = self:OptionsGetter("timer.height"),
            set = self:OptionsSetter("timer.height"),
            step = 1,
            min = 15,
            max = 50,
            width = "full"
        }
    }
end

function EffusionRaidAssistBossMod:GetDefaultSettings()
    return {
        timer = {
            colorFull = EffusionRaidAssistColor(0, 0.7, 1, 1):ToObject(),
            colorEmpty = EffusionRaidAssistColor(1, 0, 0, 1):ToObject(),
            anchor_position_offset = {
                x = 0,
                y = 0,
            },
            width = 250,
            height = 20,
        }
    }
end
