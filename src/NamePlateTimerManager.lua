BossModNamePlateTimerManager = CreateClass()

function BossModNamePlateTimerManager.new()
    local self = setmetatable({}, BossModNamePlateTimerManager)
    self.anchors = {}
    self.timers = {}
    EffusionRaidAssistBossMod:AddEventCallback(EffusionRaidAssist.CustomEvents.TimerStarted, self, self.TimerStarted)
    EffusionRaidAssistBossMod:AddEventCallback(EffusionRaidAssist.CustomEvents.TimerEnded, self, self.TimerEnded)
    EffusionRaidAssistBossMod:AddEventCallback(EffusionRaidAssist.CustomEvents.TimerAborted, self, self.TimerEnded)
    EffusionRaidAssist.EventDispatcher:AddEventCallback("NAME_PLATE_UNIT_ADDED", self, self.NamePlateAdded)
    EffusionRaidAssist.EventDispatcher:AddEventCallback("NAME_PLATE_UNIT_REMOVED", self, self.NamePlateRemoved)
    return self
end

function BossModNamePlateTimerManager:StartTimer(guid, time, text, icon, specialIcon, callback)
    local anchor = self:GetNameplateTimerAnchor(guid)
    if (anchor) then
        local timer = EffusionRaidAssist.FramePool:GetFrame("BossModTimer")
        timer:SetIcon(icon)
        timer:SetText(text)
        timer:SetEndCallback(callback)
        timer:Start(time)
        timer:SetPoint("BOTTOM", anchor, "TOP", 0, 0)
        if (not self.timers[guid]) then
            self.timers[guid] = {}
        end
        self.timers[guid][timer:GetName()] = timer
        self:UpdateTimerPositions()
        return timer
    end
    return nil
end

function BossModNamePlateTimerManager:StartTimerForSpell(guid, time, spellId, text, specialIcon, callback)
    return self:StartTimer(guid, time, text or GetSpellInfo(spellId), 1, specialIcon, callback)
end

function BossModNamePlateTimerManager:Clear()
    for _, timer in pairs(self.timers) do
        timer:Abort()
    end
end

function BossModNamePlateTimerManager:TimerStarted()
    self:UpdateTimerPositions()
end

function BossModNamePlateTimerManager:TimerEnded(timer)
    for _, timers in pairs(self.timers) do
        timers[timer:GetName()] = nil
    end
    self:UpdateTimerPositions()
end

function BossModNamePlateTimerManager:UpdateTimerPositions()
    for guid, indexedTimers in pairs(self.timers) do
        local timers = table.getvalues(indexedTimers)
        table.sort(timers, function(timer1, timer2) return timer1:GetRemainingTime() > timer2:GetRemainingTime() end)
        local previousTimer = nil
        for _, timer in pairs(timers) do
            if (previousTimer == nil) then
                timer:SetPoint("BOTTOM", self:GetNameplateTimerAnchor(guid), "TOP", 0, 1)
            else
                timer:SetPoint("BOTTOM", previousTimer.frame, "TOP", 0, 1)
            end
            previousTimer = timer
        end
    end
end

function BossModNamePlateTimerManager:AbortTimersForGuid(guid)
    for _, timer in pairs(self.timers[guid]) do
        timer:Abort()
    end
end

function BossModNamePlateTimerManager:NamePlateRemoved(nameplate)
    local guid = UnitGUID(nameplate)
    local anchor = self.anchors[guid]
    if (anchor) then
        self:AbortTimersForGuid(guid)
        EffusionRaidAssist.FramePool:Release(anchor)
    end
end

function BossModNamePlateTimerManager:GetNameplateTimerAnchor(guid)
    local nameplate = EffusionRaidAssist.NamePlateManager:GetNamePlate(guid)
    if (nameplate) then
        if (not self.anchors[guid]) then
            local anchor = EffusionRaidAssist.FramePool:GetFrame("Frame")
            anchor:SetParent(UIParent)
            anchor:SetPoint("BOTTOM", EffusionRaidAssist.NamePlateManager:GetNamePlate(guid), "TOP", 0, 0)
            anchor:SetWidth(EffusionRaidAssistBossMod:GetData("timer.width"))
            anchor:SetHeight(EffusionRaidAssistBossMod:GetData("timer.height"))
            anchor:Hide()
            self.anchors[guid] = anchor
        end
        return self.anchors[guid]
    end
    return nil
end