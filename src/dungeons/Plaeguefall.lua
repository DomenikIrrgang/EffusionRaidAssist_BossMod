local Plaeguefall = EffusionRaidAssistBossMod:NewDungeonModule("Plaguefall (Default)", 2289)

function Plaeguefall:GetSpellInfo()
    return {
        [319070] = {}, -- Corrosive Gunk
        [328177] = { -- Fungistorm
            cooldown = 8,
            ccable = true,
        },
        [318949] = { -- Festering Belch
            frontal = true,
        },
        [336451] = { -- Bulwark of Maldraxxus
            cooldown = 7,
            ccable = true,
        },
        [328395] = { -- Venompiercer
            frontal = true
        },
        [329163] = { -- Ambush
            ccable = true,
            cooldown = 15,
        }
    }
end