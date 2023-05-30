local TheaterOfPain = EffusionRaidAssistBossMod:NewDungeonModule("Theater of Pain (Default)", 2293)

function TheaterOfPain:GetSpellInfo()
    return {
        [341902] = { -- Unholy Fervor
            auraApplied = {
                purgeable = true,
            }
        },
        [333241] = { -- Raging Tantrum
            auraApplied = {
                soothable = true,
            }
        },
        [341969] = {}, -- Withering Discharge
        [330614] = { -- Vile Eruption
            castStart = {
                dodge = true,
            }
        },
        [342139] = {}, -- Battle Trance
        [333861] = { -- Ricocheting Blade
            castStart = {
                spread = true,
            }
        },
        [330562] = {} -- Demoralizing Shout
    }
end