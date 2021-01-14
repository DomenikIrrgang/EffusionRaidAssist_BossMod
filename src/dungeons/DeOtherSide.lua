local DeOtherSide = EffusionRaidAssistBossMod:NewDungeonModule("De Other Side (Default)", 2291)

function DeOtherSide:GetSpellInfo()
    return {
        [328740] = {}, -- Dark Lotus
        [332706] = {}, -- Heal
        [332666] = {}, -- Renew
        [332612] = {}, -- Healing Wave
        [332605] = {}, -- Hex
    }
end