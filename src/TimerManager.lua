BossModTimerManager = CreateClass()

function BossModTimerManager.new()
    local self = setmetatable({}, BossModTimerManager)
    return self
end

function BossModTimerManager:StartTimer(icon, specialIcon, text, time, callback)
    local timer = EffusionRaidAssist.FramePool:GetFrame("BossModTimer")
    timer:SetText("TestTimer")
    timer:SetPoint("CENTER", UIParent, "CENTER", math.random(300), math.random(300))
    timer:Start(20)
end