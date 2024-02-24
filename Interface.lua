-- Create a frame for the interface options
optionsFrame = CreateFrame("Frame", "MenuOptionFrame", InterfaceOptionsFramePanelContainer)
optionsFrame.name = "SpellAnnouncer"
InterfaceOptions_AddCategory(optionsFrame)

-- Add a simple text label
optionsFrame.title = optionsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
optionsFrame.title:SetPoint("TOPLEFT", 16, -16)
optionsFrame.title:SetText("Spell Announcer - World First Edition ! ")

-- Add an edit box for adding new spells
optionsFrame.newSpell = CreateFrame("EditBox", nil, optionsFrame, "InputBoxTemplate")
optionsFrame.newSpell:SetPoint("TOPLEFT", 16, -32)
optionsFrame.newSpell:SetSize(200, 20)


-- Add a button for adding the new spell
optionsFrame.addSpell = CreateFrame("Button", nil, optionsFrame, "GameMenuButtonTemplate")
optionsFrame.addSpell:SetPoint("LEFT", optionsFrame.newSpell, "RIGHT")
optionsFrame.addSpell:SetText("Add Spell")
optionsFrame.addSpell:SetScript("OnClick", function()
    local spellName = optionsFrame.newSpell:GetText()
    -- Add the spell to the saved variables and update the spell list
    SpellAnnouncerDB.spells[spellName] = true
    optionsFrame:UpdateSpellList()
end)


-- Create a scroll frame for the spell list
optionsFrame.spellList = CreateFrame("ScrollFrame", nil, optionsFrame, "UIPanelScrollFrameTemplate")
optionsFrame.spellList:SetPoint("TOPLEFT", optionsFrame.newSpell, "BOTTOMLEFT", 0, -16)
optionsFrame.spellList:SetSize(400, 200)

-- Create a content frame for the scroll frame
optionsFrame.spellList.content = CreateFrame("Frame", nil, optionsFrame.spellList)
optionsFrame.spellList.content:SetSize(400, 200)
optionsFrame.spellList:SetScrollChild(optionsFrame.spellList.content)


-- Function to update the spell list
function optionsFrame:UpdateSpellList()
    -- Remove all existing spell frames
    for _, spellFrame in ipairs(self.spellList.content.spells or {}) do
        spellFrame:Hide()
    end

    self.spellList.content.spells = {}

    -- Create a new frame for each spell
    local i = 0
    for spellName, enabled in pairs(SpellAnnouncerDB.spells) do
        local spellFrame = CreateFrame("Frame", nil, self.spellList.content)
        spellFrame:SetPoint("TOPLEFT", 0, -i * 20)
        spellFrame:SetSize(200, 20)

        -- Add a check button for enabling/disabling the spell
        spellFrame.checkButton = CreateFrame("CheckButton", nil, spellFrame, "UICheckButtonTemplate")
        spellFrame.checkButton:SetPoint("LEFT")
        spellFrame.checkButton:SetChecked(enabled)
        spellFrame.checkButton:SetScript("OnClick", function(self)
            SpellAnnouncerDB.spells[spellName] = self:GetChecked()
        end)

        -- Add a text label for the spell name
        spellFrame.textSpellName = spellFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        spellFrame.textSpellName:SetPoint("LEFT", spellFrame.checkButton, "RIGHT")
        spellFrame.textSpellName:SetText(spellName)

        -- Add a button for removing the spell
        spellFrame.removeButton = CreateFrame("Button", nil, spellFrame, "GameMenuButtonTemplate")
        spellFrame.removeButton:SetPoint("LEFT", spellFrame.textSpellName, "RIGHT")
        spellFrame.removeButton:SetText("Remove")
        spellFrame.removeButton:SetScript("OnClick", function()
            SpellAnnouncerDB.spells[spellName] = nil
            self:UpdateSpellList()
        end)

        table.insert(self.spellList.content.spells, spellFrame)

        i = i + 1
    end
end

-- Update the spell list when the options frame is shown
optionsFrame:SetScript("OnShow", function(self)
    self:UpdateSpellList()
end)

-- Show the options frame when the addon is loaded
function optionsFrame:refresh()
    self:UpdateSpellList()
    InterfaceOptionsFrame_OpenToCategory(self)
end

optionsFrame:SetScript("OnShow", function(self)
    self:refresh()
end)
