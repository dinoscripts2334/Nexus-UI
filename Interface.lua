return function(NexusUI)
    
    local Window = NexusUI:CreateWindow({
        Name = "NexusUI Example",
        Author = "Cheffe",
        Size = UDim2.new(0, 650, 0, 500),
        Theme = "Dark", 
        Accent = Color3.fromRGB(138, 43, 226), 
        MinimizeKey = Enum.KeyCode.RightControl
    })

    NexusUI:Notify({
        Title = "Welcome!",
        Content = "NexusUI loaded successfully!",
        Duration = 5,
        Type = "Success"
    })

    local HomeTab = Window:CreateTab({
        Name = "Home",
        Color = Color3.fromRGB(138, 43, 226)
    })

    local ComponentsTab = Window:CreateTab({
        Name = "Components",
        Color = Color3.fromRGB(0, 149, 255)
    })

    local SettingsTab = Window:CreateTab({
        Name = "Settings",
        Color = Color3.fromRGB(255, 85, 127)
    })

    HomeTab:Section({
        Title = "Welcome Section"
    })

    HomeTab:Paragraph({
        Title = "About NexusUI",
        Content = "This is a clean, modern UI library built on Roblox Luau. Now featuring persistence and robust component configuration like Rayfield/Wind UI."
    })

    HomeTab:Button({
        Title = "Execute Fun Script",
        Desc = "This button executes a sample function.",
        Callback = function()
            NexusUI:Notify({Title = "Executed", Content = "The callback function was run!", Type = "Success", Duration = 2})
        end
    })

    ComponentsTab:Section({
        Title = "Toggle & Slider"
    })

    local ToggleExample = ComponentsTab:Toggle({
        Title = "Feature Toggle",
        Desc = "Toggles a specific script function.",
        Default = false,
        Callback = function(state)
            print("Feature state:", state)
        end
    })
    
    local SliderExample = ComponentsTab:Slider({
        Title = "Speed Multiplier",
        Desc = "Adjusts game speed between 1x and 10x.",
        Min = 1,
        Max = 10,
        Default = 5,
        Increment = 0.1,
        Callback = function(value)
            print("Speed set to:", value)
        end
    })
    
    ComponentsTab:Section({
        Title = "Buttons & Labels"
    })

    ComponentsTab:Button({
        Title = "Blue Custom Button",
        Desc = "This button has a custom color.",
        Color = Color3.fromRGB(0, 120, 255),
        HoverColor = Color3.fromRGB(0, 80, 200),
        Callback = function()
            ToggleExample.Set(not ToggleExample.Get()) -- Example control
        end
    })

    local ValueLabel = ComponentsTab:Label({
        Text = "Current Value: " .. SliderExample.Get()
    })

    SliderExample.Config.Callback = function(value)
        ValueLabel.SetText("Current Value: " .. math.floor(value * 10) / 10)
    end
    
    SettingsTab:Section({
        Title = "Persistenz (Save/Load)"
    })

    local SaveStringLabel = SettingsTab:Label({
        Text = "Speicherstring:",
        Color = Window.Theme.TextDark 
    })
    
    SettingsTab:Button({
        Title = "Einstellungen speichern (Kopieren)",
        Desc = "Kopiert die Konfiguration (Toggle/Slider/Position) in die Zwischenablage.",
        Callback = function()
            Window.Save("Default")
        end
    })
    
    SettingsTab:Button({
        Title = "Einstellungen laden (Aus Zwischenablage)",
        Desc = "Versucht, den gespeicherten String aus der Zwischenablage zu laden.",
        Callback = function()
            local jsonString = pcall(getclipboard)
            if jsonString and jsonString ~= "" then
                Window.Load(jsonString)
            else
                NexusUI:Notify({Title = "Laden fehlgeschlagen", Content = "Zwischenablage ist leer.", Type = "Warning", Duration = 3})
            end
        end
    })
    
    SettingsTab:Section({
        Title = "Notifications"
    })

    SettingsTab:Button({
        Title = "Danger Notification",
        Callback = function()
            NexusUI:Notify({
                Title = "Error",
                Content = "This is a danger notification",
                Duration = 3,
                Type = "Danger"
            })
        end
    })
    
end
