local MistsOfTimaScithe = EffusionRaidAssistBossMod:NewDungeonModule("Mists of Tima Scithe (Default)", 2290)

function MistsOfTimaScithe:GetSpellInfo()
    return {
        [324914] = {}, -- Nourish the Forest
        [324776] = {}, -- Bramblethorn Coat
        [322938] = {}, -- Harvest Essence
        [321968] = { -- Bewildering Pollen
            castStart = {
                frontal = true,
            },
        },
        [3224869] = { -- Overgrowth
            castSuccess = {
                focus = true
            },
        },
        [324923] = { -- Bramble Burst
            castSuccess = {
                move = true
            },
        },
        [340189] = { -- Pool of Radiance
            castSuccess = {
                pullout = true,
            },
        },
        [340160] = { -- Radiant Breath
            castStart = {
                dodge = true,
            }
        },
        [326046] = {}, -- Stimulate Resistance
        [340544] = {}, -- Stimulate Regeneration
        [325418] = { -- Volatile Acid
            castStart = {
                spread = true,
            }
        }
    }
end