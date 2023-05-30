EffusionRaidAssistColor = CreateClass()

function EffusionRaidAssistColor.new(red, green, blue, alpha)
    local self = setmetatable({}, EffusionRaidAssistColor)
    if (type(red) ~= "table") then
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    else
        self.red = red.red
        self.green = red.green
        self.blue = red.blue
        self.alpha = red.alpha
    end
    return self
end

function EffusionRaidAssistColor:ToObject()
    return { red = self.red, green = self.green, blue = self.blue, alpha = self.alpha }
end

function EffusionRaidAssistColor:Interpolate(color1, color2, percentage)
    self.red = InterpolateValue(color1.red, color2.red, percentage)
    self.green = InterpolateValue(color1.green, color2.green, percentage)
    self.blue = InterpolateValue(color1.blue, color2.blue, percentage)
    self.alpha = InterpolateValue(color1.alpha, color2.alpha, percentage)
end