-- NexusUI Example Script
-- Shows how to use all components

-- Load the library (replace with your loadstring URL)
local NexusUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/dinoscripts2334/Nexus-UI/refs/heads/main/main.lua"))()

-- Create Window
local Window = NexusUI:CreateWindow({
    Name = "NexusUI Example",
    Author = "YourName",
    Size = UDim2.new(0, 650, 0, 500),
    Theme = "Dark", -- Dark, Light, Ocean
    Accent = Color3.fromRGB(138, 43, 226), -- Custom accent color
    MinimizeKey = Enum.KeyCode.RightControl
})

-- Notification Example
NexusUI:Notify({
    Title = "Welcome!",
    Content = "NexusUI loaded successfully!",
    Duration = 5,
    Type = "Success" -- Success, Warning, Danger, Info
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
    Content = "NexusUI is a modern, feature-rich UI library for Roblox scripts. It includes buttons, toggles, sliders, dropdowns, inputs, keybinds and more!"
})

HomeTab:Label({
    Text = "Version: 1.0.0",
    Color = Color3.fromRGB(138, 43, 226)
})

HomeTab:Section({
    Title = "Quick Actions"
})

HomeTab:Button({
    Title = "Click Me!",
    Desc = "This is a button example",
    Callback = function()
        NexusUI:Notify({
            Title = "Button Clicked",
            Content = "You clicked the button!",
            Duration = 3,
            Type = "Info"
        })
    end
})

HomeTab:Button({
    Title = "Destroy UI",
    Desc = "Close the entire UI",
    Callback = function()
        Window.ScreenGui:Destroy()
    end
})

-- COMPONENTS TAB
ComponentsTab:Section({
    Title = "Toggle Examples"
})

ComponentsTab:Toggle({
    Title = "Simple Toggle",
    Desc = "This is a basic toggle",
    Default = false,
    Callback = function(value)
        print("Toggle state:", value)
    end
})

ComponentsTab:Toggle({
    Title = "ESP Toggle",
    Desc = "Enable/disable ESP",
    Default = true,
    Callback = function(value)
        if value then
            NexusUI:Notify({
                Title = "ESP Enabled",
                Content = "ESP is now active",
                Duration = 2,
                Type = "Success"
            })
        else
            NexusUI:Notify({
                Title = "ESP Disabled",
                Content = "ESP is now inactive",
                Duration = 2,
                Type = "Warning"
            })
        end
    end
})

ComponentsTab:Section({
    Title = "Slider Examples"
})

ComponentsTab:Slider({
    Title = "Speed",
    Desc = "Adjust your speed",
    Min = 16,
    Max = 200,
    Default = 16,
    Increment = 1,
    Callback = function(value)
        print("Speed set to:", value)
        -- game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
})

ComponentsTab:Slider({
    Title = "Jump Power",
    Desc = "Change jump height",
    Min = 50,
    Max = 300,
    Default = 50,
    Increment = 5,
    Callback = function(value)
        print("Jump Power set to:", value)
    end
})

ComponentsTab:Slider({
    Title = "FOV",
    Desc = "Field of View adjustment",
    Min = 70,
    Max = 120,
    Default = 90,
    Increment = 1,
    Callback = function(value)
        -- workspace.CurrentCamera.FieldOfView = value
        print("FOV:", value)
    end
})

ComponentsTab:Section({
    Title = "Dropdown Examples"
})

ComponentsTab:Dropdown({
    Title = "Select Weapon",
    Values = {"Sword", "Gun", "Bow", "Staff", "Axe"},
    Default = "Sword",
    Callback = function(selected)
        NexusUI:Notify({
            Title = "Weapon Selected",
            Content = "You selected: " .. selected,
            Duration = 2,
            Type = "Info"
        })
    end
})

ComponentsTab:Dropdown({
    Title = "Select Team",
    Values = {"Red Team", "Blue Team", "Green Team", "Yellow Team"},
    Default = "Red Team",
    Callback = function(selected)
        print("Team selected:", selected)
    end
})

ComponentsTab:Section({
    Title = "Input Examples"
})

ComponentsTab:Input({
    Title = "Username",
    Desc = "Enter a username",
    Placeholder = "Type here...",
    Default = "",
    Callback = function(text)
        print("Username entered:", text)
        NexusUI:Notify({
            Title = "Input Received",
            Content = "Username: " .. text,
            Duration = 3,
            Type = "Success"
        })
    end
})

ComponentsTab:Input({
    Title = "Player ID",
    Desc = "Enter player ID to target",
    Placeholder = "123456789",
    Default = "",
    Callback = function(text)
        print("Player ID:", text)
    end
})

ComponentsTab:Section({
    Title = "Keybind Examples"
})

ComponentsTab:Keybind({
    Title = "Toggle UI",
    Default = Enum.KeyCode.V,
    Callback = function()
        NexusUI:Notify({
            Title = "Keybind Pressed",
            Content = "Toggle UI keybind activated!",
            Duration = 2,
            Type = "Info"
        })
    end
})

ComponentsTab:Keybind({
    Title = "Fly Toggle",
    Default = Enum.KeyCode.F,
    Callback = function()
        print("Fly keybind pressed")
    end
})

-- SETTINGS TAB
SettingsTab:Section({
    Title = "UI Settings"
})

SettingsTab:Label({
    Text = "Theme Options",
    Color = Color3.fromRGB(255, 255, 255)
})

SettingsTab:Button({
    Title = "Dark Theme",
    Desc = "Switch to dark theme",
    Callback = function()
        NexusUI:SetTheme(Window, "Dark")
    end
})

SettingsTab:Button({
    Title = "Light Theme",
    Desc = "Switch to light theme",
    Callback = function()
        NexusUI:SetTheme(Window, "Light")
    end
})

SettingsTab:Button({
    Title = "Ocean Theme",
    Desc = "Switch to ocean theme",
    Callback = function()
        NexusUI:SetTheme(Window, "Ocean")
    end
})

SettingsTab:Section({
    Title = "Notifications"
})

SettingsTab:Button({
    Title = "Success Notification",
    Callback = function()
        NexusUI:Notify({
            Title = "Success!",
            Content = "This is a success notification",
            Duration = 3,
            Type = "Success"
        })
    end
})

SettingsTab:Button({
    Title = "Warning Notification",
    Callback = function()
        NexusUI:Notify({
            Title = "Warning!",
            Content = "This is a warning notification",
            Duration = 3,
            Type = "Warning"
        })
    end
})

SettingsTab:Button({
    Title = "Danger Notification",
    Callback = function()
        NexusUI:Notify({
            Title = "Error!",
            Content = "This is a danger notification",
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

SettingsTab:Section({
    Title = "About"
})

SettingsTab:Paragraph({
    Title = "Credits",
    Content = "Created with NexusUI Library\nVersion: 1.0.0\nMade for Roblox Script Developers"
})

-- Advanced Examples
SettingsTab:Section({
    Title = "Advanced Features"
})

local speedSlider = SettingsTab:Slider({
    Title = "Controlled Slider",
    Desc = "This slider can be controlled programmatically",
    Min = 0,
    Max = 100,
    Default = 50,
    Increment = 1,
    Callback = function(value)
        print("Controlled slider value:", value)
    end
})

SettingsTab:Button({
    Title = "Set Slider to 75",
    Callback = function()
        speedSlider.Set(75)
    end
})

local controlledToggle = SettingsTab:Toggle({
    Title = "Controlled Toggle",
    Desc = "Toggle that can be controlled",
    Default = false,
    Callback = function(value)
        print("Controlled toggle:", value)
    end
})

SettingsTab:Button({
    Title = "Enable Toggle",
    Callback = function()
        controlledToggle.Set(true)
    end
})

SettingsTab:Button({
    Title = "Disable Toggle",
    Callback = function()
        controlledToggle.Set(false)
    end
})

print("NexusUI Example loaded successfully!")
