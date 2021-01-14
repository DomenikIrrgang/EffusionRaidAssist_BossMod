local SanguineDepths = EffusionRaidAssistBossMod:NewDungeonModule("Sanguine Depths (Default)", 2284)

function SanguineDepths:GetSpellInfo()
    return {
        [334558] = { -- Corrosive Gunk
            dodge = true,
        },
        [320991] = { -- Echoing Thrust
            frontal = true,
        },
        [322433] = {}, -- Stoneskin
        [328170] = { -- Craggy Fracture
            dodge = true,
        },
        [321038] = {}, -- Wrack Soul
    }
end