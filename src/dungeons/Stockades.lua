local Stockades = EffusionRaidAssistBossMod:NewDungeonModule("De Other Side (Default)", 34)

function Stockades:GetSpellInfo()
    return {
        [6713] = {
            castSuccess = {
                move = true
            },
        },
    }
end