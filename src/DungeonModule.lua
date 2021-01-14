BossModDungeonModule = CreateClass()

function BossModDungeonModule.new(name, instanceId)
    local self = setmetatable({}, BossModDungeonModule)
    self.instanceId = instanceId
    self.name = name
    self.enabled = false
    self.combatLogEventDispatcher = EffusionRaidAssistCombatLogEventDispatcher()
    self:AddEventCallback(EffusionRaidAssist.CustomEvents.InterupableSpellCast, self.InterupableSpellCast)
    self:CombatLogEvent("SPELL_CAST_START", {}, self.SpellCastStart)
    self:CombatLogEvent("SPELL_CAST_SUCCESS", {}, self.SpellCastSuccess)
    return self
end

function BossModDungeonModule:CombatLogEvent(event, data, callback)
    self.combatLogEventDispatcher:AddEventCallback(event, data, self, callback)
end

function BossModDungeonModule:AddEventCallback(event, callback)
    EffusionRaidAssist.EventDispatcher:AddEventCallback(event, self, callback)
end

function BossModDungeonModule:SpellCastStart(event)
    local unitId = EffusionRaidAssist.NamePlateManager:GetUnitId(event.sourceGuid)
    if (unitId) then
        local _, _, texture, startTime, endTime, _, _, notInterruptible, spellId = UnitCastingInfo(unitId)
        if (self:GetSpellInfo()[spellId]) then
            if (not notInterruptible) then
                local castTime = (endTime - startTime) / 1000
                EffusionRaidAssistBossMod.NamePlateTimerManager:StartTimer(event.sourceGuid, castTime, "Interupt", texture)
                EffusionRaidAssist.EventDispatcher:DispatchEvent(EffusionRaidAssist.CustomEvents.InterupableSpellCast, event, { id = spellId, castTime = castTime, texture = texture, cooldown = self:GetSpellInfo()[spellId].cooldown })
            end
        end
    end
end

function BossModDungeonModule:SpellCastSuccess(event)
    local spell = self:GetSpellInfo()[event.spellId]
    if (spell and spell.cooldown) then
        EffusionRaidAssistBossMod.NamePlateTimerManager:StartTimer(event.sourceGuid, spell.cooldown, event.spellName, GetSpellTexture(event.spellId))
    end
end

function BossModDungeonModule:IsEnabled()
    return self.enabled
end

function BossModDungeonModule:Init()
    if (self.OnInit) then
        self:OnInit()
    end
end

function BossModDungeonModule:InitDefaultTimers()
    for _, unit in pairs(self:GetUnitData()) do
        if (unit.spells) then
            for _, spell in pairs(unit.spells) do
                local data = { 
                    sourceUnitId = unit.id,
                    spellId = spell.id,
                }
                self:CombatLogEvent("SPELL_CAST_SUCCESS", data, function(_, event)
                    if (spell.cooldown) then
                        EffusionRaidAssistBossMod.NamePlateTimerManager:StartTimer(event.sourceGuid, spell.cooldown, event.spellName, GetSpellTexture(spell.id))
                    end
                end)
                self:CombatLogEvent("SPELL_CAST_START", data, function(_, event)
                    if (spell.interuptable) then
                        EffusionRaidAssist.EventDispatcher:DispatchEvent(EffusionRaidAssist.CustomEvents.InterupableSpellCast, event, spell)
                    end
                end)
            end
        end
    end
end

function BossModDungeonModule:Activate()
    self.enabled = true
    self.combatLogEventDispatcher:SetEnabled(true)
    if (self.OnActivate) then
        self:OnActivate()
    end
end

function BossModDungeonModule:Deactivate()
    self.enabled = false
    self.combatLogEventDispatcher:SetEnabled(false)
    if (self.OnDeactivate) then
        self:OnDeactivate()
    end
end