local SpiresOfAscension = EffusionRaidAssistBossMod:NewDungeonModule("Spires of Ascension (Default)", 2285)

function SpiresOfAscension:GetSpellInfo()
    return {
        [317936] = { -- Forsworn Doctrine
            cooldown = 10,
        },
        [327413] = {}, -- Rebellious Fist
        [317661] = { -- Insidious Venom
            cooldown = 4
        },
        [328295] = { -- Greater Mending
            cooldown = 10,
        },
        [317963] = { -- Burden of Knowledge
            cooldown = 10,
        },
        [328137] = {} -- Dark Pulse
    }
end