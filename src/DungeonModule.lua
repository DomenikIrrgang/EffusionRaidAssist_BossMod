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
    self:CombatLogEvent("SPELL_AURA_APPLIED", {}, self.SpellAuraApplied)
    self:AddEventCallback("UNIT_SPELLCAST_CHANNEL_START", self.SpellCastChannelStart)
    self:AddEventCallback("UNIT_SPELLCAST_CHANNEL_STOP", self.SpellCastChannelStop)
    return self
end

function BossModDungeonModule:CombatLogEvent(event, data, callback)
    self.combatLogEventDispatcher:AddEventCallback(event, data, self, callback)
end

function BossModDungeonModule:AddEventCallback(event, callback)
    EffusionRaidAssist.EventDispatcher:AddEventCallback(event, self, callback)
end

function BossModDungeonModule:SpellCastChannelStart(unitTarget, _, spellId)
    local spell = self:GetSpellInfo()[spellId]
    if (spell) then
        local _, _, texture, startTime, endTime, _, notInterruptible, spellId = UnitChannelInfo(unitTarget)
        local castTime = (endTime - startTime) / 1000
        local guid = UnitGUID(unitTarget)
        if (not notInterruptible) then
            EffusionRaidAssistBossMod.NamePlateTimerManager:StartTimer(guid, castTime, "Interupt", texture)
        end
        if (spell.channelStart) then
            self:AnnounceWarning(spell.channelStart, guid, castTime, texture)
        end
    end
end

function BossModDungeonModule:SpellCastChannelStop(unitTarget, _, spellId)

end

function BossModDungeonModule:SpellAuraApplied(event)
    local spell = self:GetSpellInfo()[event.spellId]
    if (spell and spell.auraApplied) then
        local name, icon, stacks, _, duration, expirationTime = nil
        if (event:IsTargetCreature()) then
            if (EffusionRaidAssist.NamePlateManager:GetUnitId(event.targetGuid)) then
                name, icon, stacks, _, duration, expirationTime = UnitAuraByName(EffusionRaidAssist.NamePlateManager:GetUnitId(event.targetGuid), event.spellId)
            end
        else
            name, icon, stacks, _, duration, expirationTime = UnitAuraByName(event.targetName, event.spellId)
        end
        if (name) then
            self:AnnounceWarning(spell.auraApplied, event.targetGuid, expirationTime - GetTime(), icon)
        end
    end
end

function BossModDungeonModule:SpellCastStart(event)
    local unitId = EffusionRaidAssist.NamePlateManager:GetUnitId(event.sourceGuid)
    if (unitId) then
        local spell = self:GetSpellInfo()[event.spellId]
        if (spell) then
            local _, _, texture, startTime, endTime, _, _, notInterruptible, spellId = UnitCastingInfo(unitId)
            local castTime = (endTime - startTime) / 1000
            if (not notInterruptible) then
                EffusionRaidAssistBossMod.NamePlateTimerManager:StartTimer(event.sourceGuid, castTime, "Interupt", texture)
                EffusionRaidAssist.EventDispatcher:DispatchEvent(EffusionRaidAssist.CustomEvents.InterupableSpellCast, event, { id = spellId, castTime = castTime, texture = texture, cooldown = self:GetSpellInfo()[spellId].cooldown })
            end
            if (spell.castStart) then
                self:AnnounceWarning(spell.castStart, event.sourceGuid, castTime, texture)
            end
        end
    end
end

function BossModDungeonModule:SpellCastSuccess(event)
    local spell = self:GetSpellInfo()[event.spellId]
    if (spell) then
        local texture = GetSpellTexture(event.spellId)
        if (spell.cooldown) then
            EffusionRaidAssistBossMod.NamePlateTimerManager:StartTimer(event.sourceGuid, spell.cooldown, event.spellName, texture)
        end
        if (spell.castSuccess) then
            self:AnnounceWarning(spell.castSuccess, event.sourceGuid, 3, texture)
        end
    end
end

function BossModDungeonModule:AnnounceWarning(spell, guid, time, texture)
    if (spell.ccable) then
        EffusionRaidAssistBossMod.NamePlateTimerManager:StartTimer(guid, time, "CC", texture)
    end
    if (spell.frontal) then
        EffusionRaidAssistBossMod.NamePlateTimerManager:StartTimer(guid, time, "Frontal", texture)
    end
    if (spell.dodge) then
        EffusionRaidAssistBossMod.NamePlateTimerManager:StartTimer(guid, time, "Dodge", texture)
    end
    if (spell.spread) then
        EffusionRaidAssistBossMod.NamePlateTimerManager:StartTimer(guid, time, "Spread", texture)
    end
    if (spell.runaway) then
        EffusionRaidAssistBossMod.NamePlateTimerManager:StartTimer(guid, time, "Runaway", texture)
    end
    if (spell.soothable) then
        EffusionRaidAssistBossMod.NamePlateTimerManager:StartTimer(guid, time, "Sooth", texture)
    end
    if (spell.purgeable) then
        EffusionRaidAssistBossMod.NamePlateTimerManager:StartTimer(guid, time, "Purge", texture)
    end
    if (spell.hide) then
        EffusionRaidAssistBossMod.NamePlateTimerManager:StartTimer(guid, time, "Hide", texture)
    end
    if (spell.pullout) then
        EffusionRaidAssistBossMod.NamePlateTimerManager:StartTimer(guid, time, "Pullout", texture)
    end
    if (spell.move) then
        EffusionRaidAssistBossMod.NamePlateTimerManager:StartTimer(guid, time, "Move", texture)
    end
    if (spell.hide) then
        EffusionRaidAssistBossMod.NamePlateTimerManager:StartTimer(guid, time, "Hide", texture)
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