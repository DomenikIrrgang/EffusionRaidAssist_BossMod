local SpiresOfAscension = EffusionRaidAssistBossMod:NewDungeonModule("Spires of Ascension (Default)", 2285)

function SpiresOfAscension:OnInit()

end

function SpiresOfAscension:GetUnitData()
    return {
        ["Forsworn Mender"] = { 
            id = 163459,
            spells = {
                ["Forsworn Doctrine"] = {
                    id = 317936,
                    interuptable = true,
                    cooldown = 10,
                }
            }
        },
        ["Forsworn Vanguard"] = {
            id = 163457,
        },
        ["Forsworn Goliath"] = {
            id = 168318,
            spells = {
                ["Rebellious Fist"] = {
                    id = 327413,
                    interuptable = true,
                }
            }
        },
        ["Forsworn Castigator"] = {
            id = 163458,
            spells = {
                ["Burden of Knowledge"] = {
                    id = 317963,
                    interuptable = true,
                    cooldown = 10
                }
            }
        }
    }
end