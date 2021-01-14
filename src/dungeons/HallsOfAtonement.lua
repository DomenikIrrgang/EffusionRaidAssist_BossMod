local HallsOfAtonement = EffusionRaidAssistBossMod:NewDungeonModule("Halls of Atonement (Default)", 2287)

function HallsOfAtonement:GetSpellInfo()
    return {
        [325700] = {}, -- Collect Sins
        [326607] = {}, -- Turn to Stone
        [328322] = {}, -- Vaillainous Bolt
        [326829] = {}, -- Wicked Bolt
    }
end