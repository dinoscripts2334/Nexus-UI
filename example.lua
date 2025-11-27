-- NexusUI Example Script
-- Shows how to use all components

-- Load the library (WICHTIG: Korrigierte, stabile URL verwenden!)
local NEXUS_UI_URL = "https://raw.githubusercontent.com/dinoscripts2334/Nexus-UI/main/main.lua"
local NexusUI
local success, result = pcall(function()
    NexusUI = loadstring(game:HttpGet(NEXUS_UI_URL))()
end)

if not success or not NexusUI then
    return warn("NexusUI LADEFEHLER! Bitte überprüfe die URL. Fehler: " .. tostring(result))
end

-- Create Window
local Window = NexusUI:CreateWindow({
    Name = "NexusUI Example",
    Author = "Cheffe", -- Persönlicher Touch
    Size = UDim2.new(0, 650, 0, 500),
    Theme = "Dark", 
    Accent = Color3.fromRGB(138, 43, 226), 
    MinimizeKey = Enum.KeyCode.RightControl
})

-- Notification Example
NexusUI:Notify({
    Title = "Welcome!",
    Content = "NexusUI loaded successfully!",
    Duration = 5,
    Type = "Success" 
})

-- Create Tabs
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

-- HOME TAB
HomeTab:Section({
    Title = "Welcome Section"
})

HomeTab:Paragraph({
    Title = "About NexusUI",
    Content = "This is a clean, modern UI library built on Roblox Luau. Now featuring persistence and robust component configuration."
})

-- COMPONENTS TAB
ComponentsTab:Section({
    Title = "Controls"
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

-- SETTINGS TAB
SettingsTab:Section({
    Title = "Persistence"
})

SettingsTab:Button({
    Title = "Save Configuration",
    Desc = "Copies current state (toggles, sliders, position) to clipboard.",
    Callback = function()
        Window.Save("UserConfig")
    end
})

SettingsTab:Button({
    Title = "Load Configuration",
    Desc = "Loads state from clipboard.",
    Callback = function()
        local jsonString = pcall(getclipboard)
        if jsonString and jsonString ~= "" then
            Window.Load(jsonString)
        else
            NexusUI:Notify({Title = "Load Error", Content = "Clipboard is empty.", Type = "Warning", Duration = 3})
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
            Title = "Alert!",
            Content = "Something went wrong!",
            Duration = 3,
            Type = "Danger"
        })
    end
})

SettingsTab:Button({
    Title = "Info Notification",
    Callback = function()
        NexusUI:Notify({
            Title = "Information",
            Content = "This is an info notification",
            Duration = 3,
            Type = "Info"
        })
    end
})
