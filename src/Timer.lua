EffusionRaidAssistBossModTimer = CreateClass()

function EffusionRaidAssistBossModTimer.new(name, parent)
    local self = setmetatable({}, EffusionRaidAssistBossModTimer)
    self.frame = EffusionRaidAssist.FramePool:GetFrame("StatusBar")
    self.frame:SetWidth(200)
    self.frame:SetHeight(20)
    self.frame:SetStatusBarTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
    self:SetMaximumValue(100)
    self.name = name
    self.colorFull = EffusionRaidAssistColor(0, 0.7, 1, 1)
    self.colorEmpty = EffusionRaidAssistColor(1, 0, 0, 1)

    if (self.frame.background == nil) then
        self.frame.background = self.frame:CreateTexture(nil, "BACKGROUND")
        self.frame.background:SetTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
        self.frame.background:SetAllPoints(true)
        self.frame.background:SetVertexColor(1, 1, 1, 0.2)
    end

    if (self.frame.icon == nil) then
        self.frame.icon = self.frame:CreateTexture(nil, "BACKGROUND")
        self.frame.icon:SetTexture(GetSpellTexture("Shield Slam"))
        self.frame.icon:SetWidth(20)
        self.frame.icon:SetHeight(20)
        self.frame.icon:SetPoint("RIGHT", self.frame, "LEFT", 0, 0)
    end

    if (self.frame.text == nil) then
        self.frame.text = self.frame:CreateFontString(nil, "OVERLAY")
        self.frame.text:SetPoint("LEFT", self.frame, "LEFT", 0, 0)
        self.frame.text:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
        self.frame.text:SetJustifyH("LEFT")
        self.frame.text:SetShadowOffset(1, -1)
        self.frame.text:SetTextColor(1, 1, 1)
    end

    if (self.frame.time == nil) then
        self.frame.time = self.frame:CreateFontString(nil, "OVERLAY")
        self.frame.time:SetPoint("RIGHT", self.frame, "RIGHT", 0, 0)
        self.frame.time:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
        self.frame.time:SetJustifyH("RIGHT")
        self.frame.time:SetShadowOffset(1, -1)
        self.frame.time:SetTextColor(1, 1, 1)
    end

    return self
end

function EffusionRaidAssistBossModTimer:UpdateTime()
    if (self:GetRemainingTime() <= 0) then
        self.frame:SetScript("OnUpdate", nil)
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
    if (self.endCallback) then
        self.endCallback()
    end
end

function EffusionRaidAssistBossModTimer:Release()
    EffusionRaidAssist.FramePool:ReleaseFrame(self.frame)
    self.updateCallback = nil
    self.endCallback = nil
    self.startTime = nil
    self.endTime = nil
    self.duration = nil
end

function EffusionRaidAssistBossModTimer:GetName()
    return self.name
end

function EffusionRaidAssistBossModTimer:Start(time)
    self.startTime = GetTime()
    self.endTime = GetTime() + time
    self.duration = time
    self:UpdateTime()
    self.frame:SetScript("OnUpdate", BindCallback(self, self.UpdateTime))
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
    if (self.frame.text) then
        self.frame.text:SetText(text)
    end
end

function EffusionRaidAssistBossModTimer:SetTimeText(time)
    if (self.frame.time) then
        self.frame.time:SetText(string.format("%.0f", time))
    end
end

function EffusionRaidAssistBossModTimer:SetEndCallback(callback)
    self.endCallback = callback
end

function EffusionRaidAssistBossModTimer:SetUpdateCallback(callback)
    self.updateCallback = callback
end

function EffusionRaidAssistBossModTimer:SetIcon(texture)
    self.frame.icon:SetTexture(texture)
end

