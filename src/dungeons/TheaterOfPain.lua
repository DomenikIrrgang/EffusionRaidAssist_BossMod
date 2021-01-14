local TheaterOfPain = EffusionRaidAssistBossMod:NewDungeonModule("Theater of Pain (Default)", 2293)

function TheaterOfPain:GetSpellInfo()
    return {
        [341902] = { -- Unholy Fervor
            purgeable = true,
        },
        [333241] = { -- Raging Tantrum
            soothable = true,
        },
        [341969] = {}, -- Withering Discharge
        [330614] = { -- Vile Eruption
            dodge = true,
        },
        [342139] = {}, -- Battle Trance
        [333861] = { -- Ricocheting Blade
            spread = true,
        },
        [330562] = {} -- Demoralizing Shout
    }
end