EffusionRaidAssistBossMod = EffusionRaidAssist.ModuleManager:NewModule("BossMod")

EffusionRaidAssistBossMod.DungeonModuleManager = BossModDungeonModuleManager()

function EffusionRaidAssistBossMod:OnModuleInitialize()
    self.TimerManager = BossModTimerManager()
    self.NamePlateTimerManager = BossModNamePlateTimerManager()
    EffusionRaidAssist.FramePool:RegisterCustomType("BossModTimer", EffusionRaidAssistBossModTimer)
    self.DungeonModuleManager:Init()
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
            func = function()
                self.TimerManager:ToggleAnchor()
                point, _, relativePoint, xOffset, yOffset = self.TimerManager:GetAnchor():GetPoint()
                self:ChangeData("timer.anchor.point", point)
                self:ChangeData("timer.anchor.relativePoint", relativePoint)
                self:ChangeData("timer.anchor.offset.x", xOffset)
                self:ChangeData("timer.anchor.offset.y", yOffset)
            end,
            width = "full"
        },
        toggle_test = {
            order = 2,
            type = "execute",
            name = "Start Test Timers",
            func = BindCallback(self.TimerManager, self.TimerManager.CreateTestTimers),
            width = "full"
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
        growthDirection = {
            order = 4,
            name = "Growth Direction",
            width = "full",
            desc = "Direction timers are going to.",
            type = "select",
            get = function()
                local directions = { "UP", "DOWN" }
                for k, v in pairs(directions) do
                    if (v == self:GetData("timer.growthDirection")) then
                        return k
                    end
                end
            end,
            set = function(_, value)
                local directions = { "UP", "DOWN" }
                self:ChangeData("timer.growthDirection", directions[value])
            end,
            values = { "UP", "DOWN" },
        },
        timer_width = {
            order = 5,
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
            order = 6,
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
            anchor = {
                point = "CENTER",
                relativePoint = "CENTER",
                offset = {
                    x = 0,
                    y = 0,
                },
            },
            width = 250,
            height = 20,
            growthDirection = "UP",
        }
    }
end
