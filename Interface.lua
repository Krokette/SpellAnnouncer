-- Settings Menu
----------------------------------------------------------------
-- Create a main scroll frame for the interface options
of = CreateFrame("ScrollFrame", "MainScrollFrame", InterfaceOptionsFramePanelContainer, "UIPanelScrollFrameTemplate")
of:SetPoint("TOPLEFT", InterfaceOptionsFramePanelContainer, "TOPLEFT")
of:SetPoint("BOTTOMRIGHT", InterfaceOptionsFramePanelContainer, "BOTTOMRIGHT")
of.name = "SpellAnnouncer"
InterfaceOptions_AddCategory(of)

-- Adjust the scroll bar position by setting the right inset
local scrollbarWidth = 16
of:SetWidth(InterfaceOptionsFramePanelContainer:GetWidth() - scrollbarWidth)
of.ScrollBar:ClearAllPoints()
of.ScrollBar:SetPoint("TOPLEFT", of, "TOPRIGHT", -scrollbarWidth, -16)
of.ScrollBar:SetPoint("BOTTOMLEFT", of, "BOTTOMRIGHT", -scrollbarWidth, 16)

-- Create a content frame for the main scroll frame
of.content = CreateFrame("Frame", "MainContentFrame", of)
of.content:SetSize(InterfaceOptionsFramePanelContainer:GetWidth(), InterfaceOptionsFramePanelContainer:GetHeight())
of:SetScrollChild(of.content)
----------------------------------------------------------------



-- Main Title in settings --
----------------------------------------------------------------
-- Add a simple text label
of.content.title = of.content:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
of.content.title:SetPoint("TOPLEFT", 16, -16)
of.content.title:SetText("Spell Announcer - Chat announcer")
----------------------------------------------------------------



-- Manual Input box for new spells
----------------------------------------------------------------
-- Add an edit box
of.content.newSpell = CreateFrame("EditBox", nil, of.content, "InputBoxTemplate")
of.content.newSpell:SetPoint("TOPLEFT", 16, -32)
of.content.newSpell:SetSize(200, 20)

-- Add a button for adding the new spell
of.content.addSpell = CreateFrame("Button", nil, of, "GameMenuButtonTemplate")
of.content.addSpell:SetPoint("LEFT", of.content.newSpell, "RIGHT")
of.content.addSpell:SetText("Add Spell")
of.content.addSpell:SetScript("OnClick", function()
    local spellName = of.content.newSpell:GetText()
    -- Add the spell to the saved variables and update the spell list
    SpellAnnouncerDB.spells[spellName] = true
    of:UpdateSpellList()
end)
----------------------------------------------------------------



-- Added spells list --
----------------------------------------------------------------
---- Add a title
of.content.spellListTitle = of.content:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
of.content.spellListTitle:SetPoint("TOPLEFT", of.content.newSpell, "BOTTOMLEFT", 0, -16)
of.content.spellListTitle:SetText("Spells to announce")

-- Create a scroll frame
of.content.spellList = CreateFrame("ScrollFrame", "SelectedSpellsScrollFrame", of.content, "UIPanelScrollFrameTemplate")
of.content.spellList:SetPoint("TOPLEFT", of.content.spellListTitle, "BOTTOMLEFT", 0, -16)
of.content.spellList:SetSize(400, 200)

-- Create a content frame
of.content.spellList.content = CreateFrame("Frame", "SelectedSpellsFrame", of.content.spellList)
of.content.spellList.content:SetSize(400, 200)
of.content.spellList:SetScrollChild(of.content.spellList.content)
----------------------------------------------------------------



-- Available spells list --
----------------------------------------------------------------
------ Add a title
of.content.availableSpellsTitle = of.content:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
of.content.availableSpellsTitle:SetPoint("TOPLEFT", of.content.spellList, "BOTTOMLEFT", 0, -16)
of.content.availableSpellsTitle:SetText("Available spells detected")

-- Create a scroll frame
of.content.availableSpells = CreateFrame("ScrollFrame", "AvailableSpellsScrollFrame", of.content, "UIPanelScrollFrameTemplate")
of.content.availableSpells:SetPoint("TOPLEFT", of.content.availableSpellsTitle, "BOTTOMLEFT", 0, -16)
of.content.availableSpells:SetSize(400, 300)

-- Create a content frame
of.content.availableSpells.content = CreateFrame("Frame", "AvailableSpellsFrame", of.content.availableSpells)
of.content.availableSpells.content:SetSize(400, 300)
of.content.availableSpells:SetScrollChild(of.content.availableSpells.content)
----------------------------------------------------------------



-- Update the selected spells list
----------------------------------------------------------------
function of:UpdateSpellList()
    -- Remove all existing spell frames
    for _, spellFrame in ipairs(self.content.spellList.content.spells or {}) do
        spellFrame:Hide()
    end

    self.content.spellList.content.spells = {}

    -- Create a new frame for each spell
    local i = 0
    for spellName, enabled in pairs(SpellAnnouncerDB.spells) do
        local spellFrame = CreateFrame("Frame", nil, self.content.spellList.content)
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

        table.insert(self.content.spellList.content.spells, spellFrame)
        i = i + 1
    end
end
----------------------------------------------------------------



-- Update the available spells list --
----------------------------------------------------------------
function of:UpdateAvailableSpells()
    -- Remove all existing spell frames
    for _, spellFrame in ipairs(self.content.availableSpells.content.spells or {}) do
        spellFrame:Hide()
    end

    self.content.availableSpells.content.spells = {}

    -- Get the list of spells available to the player
    for i = 1, GetNumSpellTabs() do
        local _, _, offset, numEntries = GetSpellTabInfo(i)
        for j = offset + 1, offset + numEntries do
            local spellName, _, spellIcon = GetSpellInfo(j, "player")

            -- Create a new frame for each spell
            local spellFrame = CreateFrame("Button", nil, self.content.availableSpells.content)
            spellFrame:SetPoint("TOPLEFT", 0, -(#self.content.availableSpells.content.spells) * 20)
            spellFrame:SetSize(200, 20)

            -- Add an icon for the spell
            spellFrame.icon = spellFrame:CreateTexture(nil, "ARTWORK")
            spellFrame.icon:SetSize(18, 18)
            spellFrame.icon:SetPoint("LEFT")
            spellFrame.icon:SetTexture(spellIcon)

            -- Add a text label for the spell name
            spellFrame.text = spellFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
            spellFrame.text:SetPoint("LEFT", spellFrame.icon, "RIGHT")
            spellFrame.text:SetText(spellName)

            spellFrame:SetScript("OnDoubleClick", function()
                -- Add the spell to the saved variables and update the spell list
                SpellAnnouncerDB.spells[spellName] = true
                of:UpdateSpellList()
            end)

            table.insert(self.content.availableSpells.content.spells, spellFrame)
        end
    end
end
----------------------------------------------------------------



-- View update/refresh --
----------------------------------------------------------------
-- Show the options frame when the addon is loaded
function of:refresh()
    self:UpdateSpellList()
    self:UpdateAvailableSpells()
    InterfaceOptionsFrame_OpenToCategory(self)
end

of:SetScript("OnShow", function(self)
    self:refresh()
end)
----------------------------------------------------------------
