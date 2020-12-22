EffusionRaidAssistColor = CreateClass()

function EffusionRaidAssistColor.new(red, green, blue, alpha)
    local self = setmetatable({}, EffusionRaidAssistColor)
    self.red = red
    self.green = green
    self.blue = blue
    self.alpha = alpha
    return self
end

function EffusionRaidAssistColor:ToObject()
    return { red = self.red, green = self.green, blue = self.blue, alpha = self.alpha }
end

function EffusionRaidAssistColor:Interpolate(color, percentage)
    return EffusionRaidAssistColor(
        InterpolateValue(self.red, color.red, percentage),
        InterpolateValue(self.green, color.green, percentage),
        InterpolateValue(self.blue, color.blue, percentage),
        InterpolateValue(self.alpha, color.alpha, percentage)
    )
end