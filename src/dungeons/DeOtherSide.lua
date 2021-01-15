local DeOtherSide = EffusionRaidAssistBossMod:NewDungeonModule("De Other Side (Default)", 2291)

function DeOtherSide:GetSpellInfo()
    return {
        [328740] = {}, -- Dark Lotus
        [332706] = {}, -- Heal
        [332666] = {}, -- Renew
        [332612] = {}, -- Healing Wave
        [332605] = {}, -- Hex
        [333227] = { -- Undying Rage
            auraApplied = {
                soothable = true,
            },
            cooldown = 30
        },
        [334051] = { -- Erupting Darkness
            castStart = {
                frontal = true,
            }
        },
        [332329] = {}, -- Devoted Sacrifice
        [332671] = { -- Bladestorm
            castStart = {
                ccable = true,
            },
            channelStart = {
                ccable = true,
            },        
        },
        [331927] = { -- Haywire
            castStart = {
                hide = true,
            },
            channelStart = {
                hide = true,
            }
        },
        [332084] = {}, -- Self-Cleaning Cycle
        [340026] = { -- Wailing Grief
            castStart = {
                runaway = true,
            }
        }
    }
end