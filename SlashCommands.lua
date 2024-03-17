-- Register slash command handler
SLASH_SPELLANNOUNCER1 = "/sa"
SLASH_SPELLANNOUNCER2 = "/spellannouncer"
SlashCmdList["SPELLANNOUNCER"] = function(msg)
    if msg == "" then
        -- Open settings window
        InterfaceOptionsFrame_OpenToCategory("SpellAnnouncer")
    else
        print("Unknown command. Usage: /sa or /spellannouncer to open the settings")
    end
end
