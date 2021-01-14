local MistsOfTimaScithe = EffusionRaidAssistBossMod:NewDungeonModule("Mists of Tima Scithe (Default)", 2290)

function MistsOfTimaScithe:GetSpellInfo()
    return {
        [324914] = { -- Nourish the Forest
            cooldown = 10,
        },
        [324776] = {}, -- Bramblethorn Coat
        {
            cooldown = 10,
        },
    }
end