local HallsOfAtonement = EffusionRaidAssistBossMod:NewDungeonModule("Halls of Atonement (Default)", 2287)

function HallsOfAtonement:GetSpellInfo()
    return {
        [325700] = {}, -- Collect Sins
        [325701] = {}, -- Siphon Life
        [326607] = {}, -- Turn to Stone
        [328322] = {}, -- Vaillainous Bolt
        [326829] = {}, -- Wicked Bolt
        [326438] = { -- Sin Quake
            castSuccess = {
                move = true
            },
        },
        [326450] = { -- Loyal Beasts
            castStart = {
                ccable = true,
            },
            auraApplied = {
                soothable = true,
            },
        },
        [325523] = { --Deadly Thrust
            castStart = {
                frontal = true,
            }
        }
    }
end