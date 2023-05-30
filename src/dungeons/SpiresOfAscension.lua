local SpiresOfAscension = EffusionRaidAssistBossMod:NewDungeonModule("Spires of Ascension (Default)", 2285)

function SpiresOfAscension:GetSpellInfo()
    return {
        [317936] = {}, -- Forsworn Doctrine
        [327413] = {}, -- Rebellious Fist
        --[317661] = { -- Insidious Venom
        --    cooldown = 4
        --},
        [328295] = {}, -- Greater Mending
        [317963] = {}, -- Burden of Knowledge
        [328137] = {}, -- Dark Pulse
        [328331] = {}, -- Forced Confession
    }
end