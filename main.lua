local NexusUI = {
    Version = "1.1.0",
    Windows = {}
}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local function GetParent()
    if RunService:IsStudio() then
        return game.Players.LocalPlayer:WaitForChild("PlayerGui")
    else
        return game:GetService("CoreGui")
    end
end

local Utilities = {}

function Utilities:Tween(object, properties, duration, easingStyle, easingDirection)
    local tweenInfo = TweenInfo.new(
        duration or 0.3,
        easingStyle or Enum.EasingStyle.Quad,
        easingDirection or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

function Utilities:MakeDraggable(frame, dragFrame)
    dragFrame = dragFrame or frame
    local dragging, dragInput, dragStart, startPos
    
    dragFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    dragFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                local delta = input.Position - dragStart
                local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                
                frame.Position = newPos
            end
        end
    end)
    
    dragFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

function Utilities:RippleEffect(button, color)
    local ripple = Instance.new("Frame")
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.BackgroundColor3 = color or Color3.fromRGB(255, 255, 255)
    ripple.BackgroundTransparency = 0.5
    ripple.BorderSizePixel = 0
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.ZIndex = button.ZIndex + 1
    ripple.Parent = button
    Instance.new("UICorner", ripple).CornerRadius = UDim.new(1, 0)
    
    local mousePos = UserInputService:GetMouseLocation()
    local buttonPos = button.AbsolutePosition
    local relativePos = mousePos - buttonPos
    ripple.Position = UDim2.new(0, relativePos.X, 0, relativePos.Y)
    
    local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
    Utilities:Tween(ripple, {Size = UDim2.new(0, maxSize, 0, maxSize), BackgroundTransparency = 1}, 0.5)
    task.delay(0.5, function() ripple:Destroy() end)
end

function NexusUI:Notify(config)
    config = config or {}
    local parent = GetParent()
    
    local notifFrame = Instance.new("Frame")
    notifFrame.Size = UDim2.new(0, 250, 0, 60)
    notifFrame.Position = UDim2.new(1, -260, 1, 10)
    notifFrame.AnchorPoint = Vector2.new(1, 1)
    notifFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    notifFrame.BorderSizePixel = 0
    notifFrame.ZIndex = 100
    notifFrame.Parent = parent
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 5)
    Corner.Parent = notifFrame
    
    local TypeColor = Color3.fromRGB(0, 0, 0)
    if config.Type == "Success" then
        TypeColor = Color3.fromRGB(56, 179, 117)
    elseif config.Type == "Warning" then
        TypeColor = Color3.fromRGB(240, 173, 78)
    elseif config.Type == "Danger" then
        TypeColor = Color3.fromRGB(217, 83, 79)
    elseif config.Type == "Info" then
        TypeColor = Color3.fromRGB(91, 192, 222)
    end
    
    local ColorBar = Instance.new("Frame")
    ColorBar.Size = UDim2.new(0, 5, 1, 0)
    ColorBar.BackgroundColor3 = TypeColor
    ColorBar.BorderSizePixel = 0
    ColorBar.Parent = notifFrame
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -15, 0, 20)
    TitleLabel.Position = UDim2.new(0, 10, 0, 5)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = config.Title or "Notification"
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 15
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = notifFrame
    
    local ContentLabel = Instance.new("TextLabel")
    ContentLabel.Size = UDim2.new(1, -15, 0, 20)
    ContentLabel.Position = UDim2.new(0, 10, 0, 25)
    ContentLabel.BackgroundTransparency = 1
    ContentLabel.Text = config.Content or ""
    ContentLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    ContentLabel.TextSize = 13
    ContentLabel.Font = Enum.Font.Gotham
    ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
    ContentLabel.Parent = notifFrame
    
    Utilities:Tween(notifFrame, {Position = UDim2.new(1, -260, 1, -10)}, 0.3)
    
    if config.Duration and config.Duration > 0 then
        delay(config.Duration, function()
            Utilities:Tween(notifFrame, {Position = UDim2.new(1, -260, 1, 10)}, 0.3)
            delay(0.3, function()
                notifFrame:Destroy()
            end)
        end)
    end
end

NexusUI.Styles = {
    CornerRadius = UDim.new(0, 8),
    StrokeThickness = 1.5,
    TabContainerWidth = 160,
    TopBarHeight = 50,
    ComponentSpacing = UDim.new(0, 10),
    Font = Enum.Font.GothamMedium,
    TitleSize = 17,
    TextSize = 14,
}

NexusUI.Themes = {
    Dark = {
        Background = Color3.fromRGB(35, 35, 35),
        Secondary = Color3.fromRGB(45, 45, 45),
        Tertiary = Color3.fromRGB(55, 55, 55),
        Accent = Color3.fromRGB(138, 43, 226),
        AccentDark = Color3.fromRGB(118, 23, 206),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(180, 180, 180),
        Border = Color3.fromRGB(65, 65, 65)
    },
    Light = {
        Background = Color3.fromRGB(240, 240, 240),
        Secondary = Color3.fromRGB(255, 255, 255),
        Tertiary = Color3.fromRGB(220, 220, 220),
        Accent = Color3.fromRGB(0, 149, 255),
        AccentDark = Color3.fromRGB(0, 120, 220),
        Text = Color3.fromRGB(50, 50, 50),
        TextDark = Color3.fromRGB(100, 100, 100),
        Border = Color3.fromRGB(200, 200, 200)
    },
    Ocean = {
        Background = Color3.fromRGB(13, 22, 33),
        Secondary = Color3.fromRGB(22, 33, 49),
        Tertiary = Color3.fromRGB(33, 44, 60),
        Accent = Color3.fromRGB(52, 152, 219),
        AccentDark = Color3.fromRGB(41, 128, 185),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(180, 180, 180),
        Border = Color3.fromRGB(44, 55, 71)
    }
}

function NexusUI:Save(window, fileName)
    local data = {
        Theme = window.Config.Theme,
        Position = {
            X = window.MainFrame.Position.X.Offset, 
            Y = window.MainFrame.Position.Y.Offset
        },
        ComponentStates = {}
    }
    
    for _, tab in pairs(window.Tabs) do
        for _, comp in pairs(tab.Elements) do
            if comp.Get and comp.Config and comp.Config.Title then
                data.ComponentStates[comp.Config.Title] = comp.Get()
            end
        end
    end

    local success, json = pcall(HttpService.JSONEncode, HttpService, data)
    
    if success and pcall(setclipboard, json) then
        self:Notify({Title = "Speichern erfolgreich", Content = "Einstellungen in die Zwischenablage kopiert.", Type = "Success", Duration = 3})
    else
        self:Notify({Title = "Speicherfehler", Content = "Konfiguration konnte nicht serialisiert/kopiert werden.", Type = "Danger", Duration = 3})
    end
end

function NexusUI:Load(window, json)
    local success, data = pcall(HttpService.JSONDecode, HttpService, json)
    if not success or not data then
        self:Notify({Title = "Ladefehler", Content = "Ungültige Konfigurationsdaten.", Type = "Danger", Duration = 3})
        return
    end

    if data.Theme and self.Themes[data.Theme] then
        self:SetTheme(window, data.Theme)
        window.Config.Theme = data.Theme
    end

    if data.Position and data.Position.X and data.Position.Y then
        local pos = UDim2.new(0.5, data.Position.X, 0.5, data.Position.Y)
        Utilities:Tween(window.MainFrame, {Position = pos}, 0.3)
    end
    
    if data.ComponentStates then
        for _, tab in pairs(window.Tabs) do
            for _, comp in pairs(tab.Elements) do
                if comp.Set and comp.Config and comp.Config.Title then
                    local savedValue = data.ComponentStates[comp.Config.Title]
                    if savedValue ~= nil then
                        comp.Set(savedValue)
                    end
                end
            end
        end
    end
    
    self:Notify({Title = "Laden erfolgreich", Content = "Konfiguration geladen.", Type = "Success", Duration = 3})
end

function NexusUI:CreateWindow(config)
    config = config or {}
    
    local Window = {
        Config = config,
        Tabs = {},
        Theme = self.Themes[config.Theme] or self.Themes.Dark,
        ActiveTab = nil,
        ComponentRegistry = {},
        Library = NexusUI,
    }
    
    Window.Theme.Accent = config.Accent or Window.Theme.Accent
    Window.Theme.AccentDark = config.Accent or Window.Theme.AccentDark
    
    local parent = GetParent()
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = Window.Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = parent
    Window.MainFrame = MainFrame
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = self.Styles.CornerRadius
    Corner.Parent = MainFrame

    local Stroke = Instance.new("UIStroke")
    Stroke.Thickness = self.Styles.StrokeThickness
    Stroke.Color = Window.Theme.Border
    Stroke.Parent = MainFrame
    
    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, self.Styles.TopBarHeight)
    TopBar.BackgroundColor3 = Window.Theme.Secondary
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame
    Window.TopBar = TopBar
    
    Utilities:MakeDraggable(MainFrame, TopBar)
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(0, 250, 1, 0)
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = config.Name or "NexusUI"
    TitleLabel.TextColor3 = Window.Theme.Text
    TitleLabel.TextSize = self.Styles.TitleSize
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TopBar
    Window.TitleLabel = TitleLabel
    
    local AuthorLabel = Instance.new("TextLabel")
    AuthorLabel.Size = UDim2.new(0, 100, 1, 0)
    AuthorLabel.AnchorPoint = Vector2.new(1, 0)
    AuthorLabel.Position = UDim2.new(1, -10, 0, 0)
    AuthorLabel.BackgroundTransparency = 1
    AuthorLabel.Text = config.Author or "v" .. self.Version
    AuthorLabel.TextColor3 = Window.Theme.TextDark
    AuthorLabel.TextSize = 13
    AuthorLabel.Font = Enum.Font.Gotham
    AuthorLabel.TextXAlignment = Enum.TextXAlignment.Right
    AuthorLabel.Parent = TopBar
    
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 30, 1, 0)
    CloseButton.Position = UDim2.new(1, -10, 0, 0)
    CloseButton.AnchorPoint = Vector2.new(1, 0)
    CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseButton.BorderSizePixel = 0
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 18
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = TopBar
    
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Size = UDim2.new(0, 30, 1, 0)
    MinimizeButton.Position = UDim2.new(1, -40, 0, 0)
    MinimizeButton.AnchorPoint = Vector2.new(1, 0)
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 200)
    MinimizeButton.BorderSizePixel = 0
    MinimizeButton.Text = "—"
    MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeButton.TextSize = 18
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Parent = TopBar
    
    CloseButton.MouseButton1Click:Connect(function()
        Utilities:Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        delay(0.5, function()
            MainFrame:Destroy()
            for i, v in ipairs(self.Windows) do
                if v == Window then
                    table.remove(self.Windows, i)
                    break
                end
            end
        end)
    end)
    
    local minimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Utilities:Tween(MainFrame, {Size = UDim2.new(Window.Config.Size.X.Scale, Window.Config.Size.X.Offset, 0, self.Styles.TopBarHeight)}, 0.3)
            MinimizeButton.Text = "□"
        else
            Utilities:Tween(MainFrame, {Size = Window.Config.Size}, 0.3)
            MinimizeButton.Text = "—"
        end
    end)
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Window.Config.MinimizeKey then
            MinimizeButton.MouseButton1Click:Fire()
        end
    end)
    
    local TabContainer = Instance.new("Frame")
    TabContainer.Size = UDim2.new(0, self.Styles.TabContainerWidth, 1, -self.Styles.TopBarHeight)
    TabContainer.Position = UDim2.new(0, 0, 0, self.Styles.TopBarHeight)
    TabContainer.BackgroundColor3 = Window.Theme.Secondary
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = MainFrame
    Window.TabContainer = TabContainer
    
    local TabContainerLayout = Instance.new("UIListLayout")
    TabContainerLayout.Padding = UDim.new(0, 5)
    TabContainerLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    TabContainerLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    TabContainerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabContainerLayout.Parent = TabContainer
    
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Size = UDim2.new(1, -self.Styles.TabContainerWidth, 1, -self.Styles.TopBarHeight)
    ContentFrame.Position = UDim2.new(0, self.Styles.TabContainerWidth, 0, self.Styles.TopBarHeight)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.BorderSizePixel = 0
    ContentFrame.Parent = MainFrame
    Window.ContentFrame = ContentFrame
    
    Window.CreateTab = function(self, config)
        local Components = loadstring(game:HttpGet("https://raw.githubusercontent.com/dinoscripts2334/Nexus-UI/refs/heads/main/components.lua"))()
        local tab = Components.CreateTab(self, config)
        
        if not Window.ActiveTab then
            tab.Activate()
        end
        
        return tab
    end
    
    Window.Save = function(fileName) NexusUI:Save(Window, fileName) end
    Window.Load = function(json) NexusUI:Load(Window, json) end
    
    Utilities:Tween(MainFrame, {Size = Window.Config.Size}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    
    table.insert(self.Windows, Window)
    return Window
end

function NexusUI:SetTheme(window, themeName)
    local theme = self.Themes[themeName]
    if not theme then return end
    
    window.Theme = theme
    window.MainFrame.BackgroundColor3 = theme.Background
    window.TopBar.BackgroundColor3 = theme.Secondary
    window.TabContainer.BackgroundColor3 = theme.Secondary
    window.TitleLabel.TextColor3 = theme.Text
    
    for _, tab in pairs(window.Tabs) do
        tab.Button.BackgroundColor3 = tab.Active and theme.Secondary or theme.Tertiary
        tab.Label.TextColor3 = tab.Active and theme.Text or theme.TextDark
    end
    
    self:Notify({
        Title = "Theme Changed",
        Content = "The theme has been updated to: " .. themeName,
        Duration = 3,
        Type = "Info"
    })
end

return NexusUI
