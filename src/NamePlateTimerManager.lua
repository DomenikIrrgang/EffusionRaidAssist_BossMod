BossModNamePlateTimerManager = CreateClass()

function BossModNamePlateTimerManager.new()
    local self = setmetatable({}, BossModNamePlateTimerManager)
    self.anchors = {}
    self.timers = {}
    EffusionRaidAssistBossMod:AddEventCallback(EffusionRaidAssist.CustomEvents.TimerStarted, self, self.TimerStarted)
    EffusionRaidAssistBossMod:AddEventCallback(EffusionRaidAssist.CustomEvents.TimerEnded, self, self.TimerEnded)
    EffusionRaidAssistBossMod:AddEventCallback(EffusionRaidAssist.CustomEvents.TimerAborted, self, self.TimerEnded)
    EffusionRaidAssist.EventDispatcher:AddEventCallback(EffusionRaidAssist.CustomEvents.NamePlateAdded, self, self.NamePlateAdded)
    EffusionRaidAssist.EventDispatcher:AddEventCallback(EffusionRaidAssist.CustomEvents.NamePlateRemoved, self, self.NamePlateRemoved)
    return self
end

function BossModNamePlateTimerManager:StartTimer(guid, time, text, icon, specialIcon, callback)
    if (self:GetNameplateTimerAnchor(guid)) then
        local timer = EffusionRaidAssist.FramePool:GetFrame("BossModTimer")
        timer:SetIcon(icon)
        timer:SetText(text)
        timer:SetEndCallback(callback)
        timer:Start(time)
        if (not self.timers[guid]) then
            self.timers[guid] = {}
        end
        self.timers[guid][timer:GetName()] = timer
        self:UpdateTimerPosition(guid)
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
    for guid in pairs(self.timers) do
        self:UpdateTimerPosition(guid)
    end
end

function BossModNamePlateTimerManager:UpdateTimerPosition(guid)
    if (self.timers[guid]) then
        if (self:GetNameplateTimerAnchor(guid)) then
            local timers = table.getvalues(self.timers[guid])
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
end

function BossModNamePlateTimerManager:AbortTimersForGuid(guid)
    for _, timer in pairs(self.timers[guid]) do
        timer:Abort()
    end
end

function BossModNamePlateTimerManager:HideTimersForGuid(guid)
    if (self.timers[guid]) then
        for _, timer in pairs(self.timers[guid]) do
            timer:Hide()
        end
    end
end

function BossModNamePlateTimerManager:ShowTimersForGuid(guid)
    if (self.timers[guid]) then
        for _, timer in pairs(self.timers[guid]) do
            timer:Show()
        end
    end
end

function BossModNamePlateTimerManager:NamePlateAdded(nameplate)
    local guid = UnitGUID(nameplate)
    self:UpdateTimerPosition(guid)
    self:ShowTimersForGuid(guid)
end

function BossModNamePlateTimerManager:NamePlateRemoved(nameplate)
    local guid = UnitGUID(nameplate)
    local anchor = self.anchors[guid]
    if (anchor) then
        self:HideTimersForGuid(guid)
        self.anchors[guid] = nil
        EffusionRaidAssist.FramePool:Release(anchor)
    end
end

function BossModNamePlateTimerManager:GetNameplateTimerAnchor(guid)
    local nameplate = EffusionRaidAssist.NamePlateManager:GetNamePlate(guid)
    if (nameplate) then
        if (not self.anchors[guid]) then
            local anchor = EffusionRaidAssist.FramePool:GetFrame("Frame")
            anchor:SetParent(UIParent)
            anchor:SetPoint("TOP", EffusionRaidAssist.NamePlateManager:GetNamePlate(guid), "TOP", 0, 0)
            anchor:SetWidth(EffusionRaidAssistBossMod:GetData("timer.width"))
            anchor:SetHeight(EffusionRaidAssistBossMod:GetData("timer.height"))
            anchor:Hide()
            self.anchors[guid] = anchor
        end
        return self.anchors[guid]
    end
    return nil
end