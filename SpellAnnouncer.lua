-- Initialize addon frame
local frame = CreateFrame("Frame")
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

-- Define spells to announce
local spellsToAnnounce = {
    ["Soulstone Resurrection"] = true,
    ["Demon Armor"] = true,
    ["Blood Fury"] = true,
    ["Corruption"] = true,
    ["Shadow Bolt"] = true,
    ["Unholy Frenzy"] = true,
    -- Add other spells here as needed
}

-- Function to announce spell usage
local function AnnounceSpell(casterName, spellName, targetName)
    print("casterName", casterName)
    print("spellName", spellName)
    print("targetName", targetName)
    local spellLink = GetSpellLink(spellName) or spellName
    SendChatMessage("Used " .. spellLink .. " on " .. targetName, "INSTANCE_CHAT")
    SendChatMessage("Used " .. spellLink .. " on " .. targetName, "WHISPER", nil, "Krókette")

end

-- Event handler for combat log events
frame:SetScript("OnEvent", function(self, event, ...)
    local timestamp, eventType, _, sourceGUID, sourceName, _, _, destGUID, destName, _, _, spellID, spellName = CombatLogGetCurrentEventInfo()

    if eventType == "SPELL_CAST_SUCCESS" then
        if sourceName == UnitName("player") and spellsToAnnounce[spellName] then
            AnnounceSpell(sourceName, spellName, destName or "no target")
        end
    end
end)
