EffusionRaidAssistBossModTimer = CreateClass()

function EffusionRaidAssistBossModTimer.new(name, parent)
    local self = setmetatable({}, EffusionRaidAssistBossModTimer)
    self.frame = EffusionRaidAssist.FramePool:GetFrame("StatusBar")
    self.frame:SetParent(parent)
    self.frame:SetWidth(250)
    self.frame:SetHeight(20)
    self.frame:SetStatusBarTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
    self:SetMaximumValue(100)
    self.name = name
    self.colorFull = EffusionRaidAssistColor(0, 0.7, 1, 1)
    self.colorEmpty = EffusionRaidAssistColor(1, 0, 0, 1)

    self.background = EffusionRaidAssist.FramePool:GetTexture("BACKGROUND")
    self.background:SetParent(self.frame)
    self.background:SetTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
    self.background:SetAllPoints(true)
    self.background:SetVertexColor(1, 1, 1, 0.2)

    self.icon = EffusionRaidAssist.FramePool:GetTexture("BACKGROUND")
    self.icon:SetParent(self.frame)
    self.icon:SetWidth(20)
    self.icon:SetHeight(20)
    self.icon:SetPoint("RIGHT", self.frame, "LEFT", 0, 0)

    self.text = self.frame:CreateFontString(nil, "OVERLAY")
    self.text:SetPoint("LEFT", self.frame, "LEFT", 2, 0)
    self.text:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
    self.text:SetJustifyH("LEFT")
    self.text:SetShadowOffset(1, -1)
    self.text:SetTextColor(1, 1, 1)

    self.time = self.frame:CreateFontString(nil, "OVERLAY")
    self.time:SetPoint("RIGHT", self.frame, "RIGHT", 0, 0)
    self.time:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
    self.time:SetJustifyH("RIGHT")
    self.time:SetShadowOffset(1, -1)
    self.time:SetTextColor(1, 1, 1)

    return self
end

function EffusionRaidAssistBossModTimer:UpdateTime()
    if (self:GetRemainingTime() <= 0) then
        self:End()
    else
        self:SetRemainingTime(self:GetPercentage() * 100)
        if (self.updateCallback) then
            self.updateCallback()
        end
    end
end

function EffusionRaidAssistBossModTimer:Stop()
    self.frame:SetScript("OnUpdate", nil)
end

function EffusionRaidAssistBossModTimer:End()
    self:Stop()
    EffusionRaidAssist.EventDispatcher:DispatchEvent(EffusionRaidAssist.CustomEvents["TimerEnded"], self)
    if (self.endCallback) then
        self.endCallback()
    end
    EffusionRaidAssist.FramePool:Release(self)
end

function EffusionRaidAssistBossModTimer:Abort()
    self:Stop()
    EffusionRaidAssist.EventDispatcher:DispatchEvent(EffusionRaidAssist.CustomEvents["TimerAborted"], self)
    EffusionRaidAssist.FramePool:Release(self)
end

function EffusionRaidAssistBossModTimer:Hide()
    self.frame:Hide()
end

function EffusionRaidAssistBossModTimer:Show()
    self.frame:Show()
end

function EffusionRaidAssistBossModTimer:Release()
    self.frame:ClearAllPoints()
    self.updateCallback = nil
    self.endCallback = nil
    self.startTime = nil
    self.endTime = nil
    self.duration = nil
end

function EffusionRaidAssistBossModTimer:GetName()
    return self.name
end

function EffusionRaidAssistBossModTimer:GetObjectType()
    return "BossModTimer"
end

function EffusionRaidAssistBossModTimer:Start(time)
    self.startTime = GetTime()
    self.endTime = GetTime() + time
    self.duration = time
    self:UpdateTime()
    self.frame:SetScript("OnUpdate", BindCallback(self, self.UpdateTime))
    EffusionRaidAssist.EventDispatcher:DispatchEvent(EffusionRaidAssist.CustomEvents["TimerStarted"], self)
end

function EffusionRaidAssistBossModTimer:ResetTime()
    self.startTime = GetTime()
    self.endTime = GetTime() + self.duration
    self:UpdateTime()
end

function EffusionRaidAssistBossModTimer:SetBarColor(color)
    self.frame:SetStatusBarColor(color.red, color.green, color.blue, color.alpha)
end

function EffusionRaidAssistBossModTimer:SetMaximumValue(value)
    self.frame:SetMinMaxValues(0, value)
end

function EffusionRaidAssistBossModTimer:GetStartTime()
    return self.startTime
end

function EffusionRaidAssistBossModTimer:SetRemainingTime(value)
    self.frame:SetValue(value)
    self:SetBarColor(self.colorEmpty:Interpolate(self.colorFull, self:GetPercentage()))
    self:SetTimeText(self:GetRemainingTime())
end

function EffusionRaidAssistBossModTimer:GetRemainingTime()
    return self:GetEndTime() - GetTime()
end

function EffusionRaidAssistBossModTimer:GetTotalDuration()
    return self:GetEndTime() - self:GetStartTime()
end


function EffusionRaidAssistBossModTimer:GetEndTime()
    return self.endTime
end

function EffusionRaidAssistBossModTimer:GetPercentage()
    return self:GetRemainingTime() / self:GetTotalDuration()
end

function EffusionRaidAssistBossModTimer:SetPoint(anchor, relativeFrame, relativeAnchor, xOffset, yOffset)
    self.frame:SetPoint(anchor, relativeFrame, relativeAnchor, xOffset, yOffset)
end

function EffusionRaidAssistBossModTimer:SetText(text)
    self.text:SetText(text)
end

function EffusionRaidAssistBossModTimer:SetTimeText(time)
    if (self:GetRemainingTime() < 10) then
        self.time:SetText(string.format("%.1f", time))
    else
        self.time:SetText(string.format("%.0f", time))
    end
end

function EffusionRaidAssistBossModTimer:SetEndCallback(callback)
    self.endCallback = callback
end

function EffusionRaidAssistBossModTimer:SetUpdateCallback(callback)
    self.updateCallback = callback
end

function EffusionRaidAssistBossModTimer:SetIcon(texture)
    self.icon:SetTexture(texture)
end

