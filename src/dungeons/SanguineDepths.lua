local SanguineDepths = EffusionRaidAssistBossMod:NewDungeonModule("Sanguine Depths (Default)", 2284)

function SanguineDepths:GetSpellInfo()
    return {
        [334558] = { -- Volatile Trap
            castStart = {
                dodge = true,
            }
        },
        [320991] = { -- Echoing Thrust
            castStart = {
                frontal = true,
            }
        },
        [322433] = {}, -- Stoneskin
        [328170] = { -- Craggy Fracture
            castStart = {
                move = true,
            }
        },
        [321038] = {}, -- Wrack Soul
    }
end