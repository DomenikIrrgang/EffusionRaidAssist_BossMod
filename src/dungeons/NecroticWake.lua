local NecroticWake = EffusionRaidAssistBossMod:NewDungeonModule("The Necrotic Wake (Default)", 2286)

function NecroticWake:GetSpellInfo()
    return {
        [334748] = {}, -- Drain Fluids
        [320462] = {}, -- Necrotic Bolt
        [324293] = {}, -- Rasping Scream
        [338353] = {}, -- Goresplatter
    }
end