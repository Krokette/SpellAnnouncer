-- Initialize addon frame
local frame = CreateFrame("Frame")
local spellsToAnnounce = {
    ["Soulstone Resurrection"] = true,
    ["Mana Tide Totem"] = true,
    ["Mana Spring Totem"] = true,
    ["Bloodlust"] = true,
    ["Water Walking"] = true,
    ["Unholy Frenzy"] = true,
    -- Add other spells here as needed
}

local CREATE_SOULSTONE_SPELL_ID = 20707
-- GetSpellInfo to retrieve the name of the spell
local _, SOULSTONE_RESURRECTION = GetSpellInfo(CREATE_SOULSTONE_SPELL_ID)

-- Function to check if a unit has the Soulstone Resurrection buff
local function UnitHasSoulstoneResurrectionBuff(unit)
    return UnitAura(unit, SOULSTONE_RESURRECTION) ~= nil
end

-- Function to announce spell usage
function AnnounceSpell(casterName, spellName, targetName)
    local spellLink = GetSpellLink(spellName) or spellName

    -- Check if the spell used is "Create Soulstone" and the target has the "Soulstone Resurrection" buff
    if spellName == SOULSTONE_RESURRECTION and UnitHasSoulstoneResurrectionBuff(targetName) then
        SendChatMessage("Used " .. spellLink .. " on " .. targetName .. " successfully.", "PARTY")
    end

    if targetName == '' then
        SendChatMessage("Used " .. spellLink, "INSTANCE_CHAT")
        print("used" .. spellLink)
    else
        SendChatMessage("Used " .. spellLink .. " on " .. targetName, "INSTANCE_CHAT")
        print("Used " .. spellLink .. " on " .. targetName)
    end
end

function OnEvent(event, ...)
    -- Event handler for combat log events

    if event == "COMBAT_LOG_EVENT_UNFILTERED" then
        local timestamp, eventType, _, sourceGUID, sourceName, _, _, destGUID, destName, _, _, spellID, spellName = CombatLogGetCurrentEventInfo()

        if eventType == "SPELL_CAST_SUCCESS" then
            if sourceName == UnitName("player") and spellsToAnnounce[spellName] then
                AnnounceSpell(sourceName, spellName, destName or '')
            end
        end
    end
end

frame:SetScript("OnEvent", function(self, event, ...)
    OnEvent(event, ...)
end)

frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")


