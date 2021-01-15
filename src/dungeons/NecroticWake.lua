local NecroticWake = EffusionRaidAssistBossMod:NewDungeonModule("The Necrotic Wake (Default)", 2286)

function NecroticWake:GetSpellInfo()
    return {
        [334748] = {}, -- Drain Fluids
        [320462] = {}, -- Necrotic Bolt
        [324293] = {}, -- Rasping Scream
        [338353] = {}, -- Goresplatter
        [320703] = { -- Seething rawget
            auraApplied = {
                soothable = true,
            }
        },
        [327399] = { -- Shared Agony
            castSuccess = {
                runaway = true,
            }
        },
        [335141] = { -- Dark Shroud
            auraApplied = {
                purgeable = true,
            },
        },
        [324372] = { -- Reaping Winds
            castStart = {
                runaway = true,
            },            
        },
        [334610] = { -- Mindless Fixation
            auraApplied = {
                runaway = true,
            }
        },
        [338606] = { -- Morbid Fixation
            auraApplied = {
                runaway = true,
            }
        }
    }
end