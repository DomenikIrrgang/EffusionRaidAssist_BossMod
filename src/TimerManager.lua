BossModTimerManager = CreateClass()

function BossModTimerManager.new()
    local self = setmetatable({}, BossModTimerManager)
    self.anchor = self:CreateTimerAnchor()
    self.timers = {}
    EffusionRaidAssistBossMod:AddEventCallback(EffusionRaidAssist.CustomEvents.TimerStarted, self, self.TimerStarted)
    EffusionRaidAssistBossMod:AddEventCallback(EffusionRaidAssist.CustomEvents.TimerEnded, self, self.TimerEnded)
    EffusionRaidAssistBossMod:AddEventCallback(EffusionRaidAssist.CustomEvents.TimerAborted, self, self.TimerEnded)
    EffusionRaidAssistBossMod:AddEventCallback(EffusionRaidAssist.CustomEvents.ProfileChanged, self, self.InitAnchor)
    EffusionRaidAssistBossMod:RegisterDataCallback("timer.width", BindCallback(self, self.SetAnchorWidth))
    EffusionRaidAssistBossMod:RegisterDataCallback("timer.height", BindCallback(self, self.SetAnchorHeight))
    return self
end

function BossModTimerManager:StartTimer(time, text, icon, specialIcon, callback)
    local timer = EffusionRaidAssist.FramePool:GetFrame("BossModTimer")
    timer:SetIcon(icon)
    timer:SetText(text)
    timer:SetEndCallback(callback)
    timer:Start(time)
    self.timers[timer:GetName()] = timer
    self:UpdateTimerPositions()
    return timer
end

function BossModTimerManager:StartTimerForSpell(time, spellId, text, specialIcon, callback)
    self:StartTimer(time, text or GetSpellInfo(spellId), GetSpellTexture(spellId), specialIcon, callback)
end

function BossModTimerManager:Clear()
    for _, timer in pairs(self.timers) do
        timer:Abort()
    end
end

function BossModTimerManager:TimerStarted(timer)
    self:UpdateTimerPositions()
end

function BossModTimerManager:TimerEnded(timer)
    self.timers[timer:GetName()] = nil
    self:UpdateTimerPositions()
end

function BossModTimerManager:ToggleAnchor()
    if (self.anchor:IsShown()) then
        self.anchor:Hide()
    else
        self.anchor:Show()
    end
end

function BossModTimerManager:UpdateTimerPositions()
    local timers = table.getvalues(self.timers)
    table.sort(timers, function(timer1, timer2) return timer1:GetRemainingTime() > timer2:GetRemainingTime() end)
    local previousTimer = nil
    for _, timer in pairs(timers) do
        timer.frame:ClearAllPoints()
        if (EffusionRaidAssistBossMod:GetData("timer.growthDirection") == "DOWN") then
            if (previousTimer == nil) then
                timer:SetPoint("TOP", self.anchor, "TOP", 0, 0)
            else
                timer:SetPoint("TOP", previousTimer.frame, "BOTTOM", 0, -1)
            end
        else
            if (previousTimer == nil) then
                timer:SetPoint("BOTTOM", self.anchor, "BOTTOM", 0, 0)
            else
                timer:SetPoint("BOTTOM", previousTimer.frame, "TOP", 0, 1)
            end
        end
        previousTimer = timer
    end
end

function BossModTimerManager:InitAnchor()
    self.anchor:SetHeight(EffusionRaidAssistBossMod:GetData("timer.height"))
    self.anchor:SetWidth(EffusionRaidAssistBossMod:GetData("timer.width"))
end


function BossModTimerManager:SetAnchorWidth(width)
    self.anchor:SetWidth(width)
end

function BossModTimerManager:SetAnchorHeight(height)
    self.anchor:SetHeight(height)
end

function BossModTimerManager:CreateTimerAnchor()
    local anchor = EffusionRaidAssist.FramePool:GetFrame("Frame")
    anchor:SetParent(UIParent)
    anchor:SetPoint("CENTER", UIParent, "CENTER", EffusionRaidAssistBossMod:GetData("timer.anchor_position_offset.x"), EffusionRaidAssistBossMod:GetData("timer.anchor_position_offset.y"))
    anchor:SetWidth(EffusionRaidAssistBossMod:GetData("timer.width"))
    anchor:SetHeight(EffusionRaidAssistBossMod:GetData("timer.height"))
    anchor:SetMovable(true)
    anchor:SetScript("OnMouseDown", function()
        if (anchor:IsShown()) then
            anchor:SetMovable(true)
            anchor:StartMoving()
        end
    end)

    anchor:SetScript("OnMouseUp", function()
        anchor:StopMovingOrSizing()
        anchor:SetMovable(false)
    end)

    anchor.background = EffusionRaidAssist.FramePool:GetTexture("BACKGROUND")
    anchor.background:SetParent(anchor)
    anchor.background:SetTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
    anchor.background:SetAllPoints(true)
    anchor.background:SetVertexColor(1, 1, 1, 0.2)

    anchor.text = anchor:CreateFontString(nil, "OVERLAY")
    anchor.text:SetPoint("CENTER", anchor, "CENTER", 0, 0)
    anchor.text:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
    anchor.text:SetJustifyH("LEFT")
    anchor.text:SetShadowOffset(1, -1)
    anchor.text:SetTextColor(1, 1, 1)
    anchor.text:SetText("Anchor")
    anchor:Hide()
    return anchor
end

function BossModTimerManager:CreateTestTimers()
    for i = 1, 10 do
        self:StartTimer(i, "Test Timer", GetSpellTexture(1535))
    end
end