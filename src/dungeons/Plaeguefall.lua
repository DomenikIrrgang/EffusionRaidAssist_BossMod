local Plaeguefall = EffusionRaidAssistBossMod:NewDungeonModule("Plaguefall (Default)", 2289)

function Plaeguefall:GetSpellInfo()
    return {
        [319070] = {}, -- Corrosive Gunk
        [328177] = { -- Fungistorm
            cooldown = 8,
            channelStart = {
                ccable = true,
            },
        },
        [318949] = { -- Festering Belch
            castStart = {
                frontal = true,
            },
        },
        [336451] = { -- Bulwark of Maldraxxus
            cooldown = 7,
            castStart = {
                ccable = true,
            },
            channelStart = {
                ccable = true,
            },
        },
        [328395] = { -- Venompiercer
            castStart = {
                frontal = true
            },
        },
        [329163] = { -- Ambush
            cooldown = 15,
            castStart = {
                ccable = true,
            },
        },
        -- Wonder Grow
    }
end