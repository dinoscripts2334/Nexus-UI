-- NexusUI Main Library
-- Version: 1.0.0
-- Created by: YourName

local NexusUI = {
    Version = "1.0.0",
    Themes = {},
    Icons = {},
    Windows = {}
}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

-- Get CoreGui or PlayerGui
local function GetParent()
    if RunService:IsStudio() then
        return game.Players.LocalPlayer:WaitForChild("PlayerGui")
    else
        return game:GetService("CoreGui")
    end
end

-- Utility Functions
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
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Utilities:Tween(frame, {
                Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            }, 0.1)
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
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = ripple
    
    local mousePos = UserInputService:GetMouseLocation()
    local buttonPos = button.AbsolutePosition
    local relativePos = mousePos - buttonPos
    
    ripple.Position = UDim2.new(0, relativePos.X, 0, relativePos.Y)
    
    local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
    
    Utilities:Tween(ripple, {
        Size = UDim2.new(0, maxSize, 0, maxSize),
        BackgroundTransparency = 1
    }, 0.5)
    
    task.delay(0.5, function()
        ripple:Destroy()
    end)
end

NexusUI.Utilities = Utilities

-- Theme System
NexusUI.Themes = {
    Dark = {
        Background = Color3.fromRGB(18, 18, 22),
        Secondary = Color3.fromRGB(22, 22, 27),
        Tertiary = Color3.fromRGB(28, 28, 33),
        Accent = Color3.fromRGB(138, 43, 226),
        AccentDark = Color3.fromRGB(108, 13, 196),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(180, 180, 180),
        Border = Color3.fromRGB(40, 40, 50),
        Success = Color3.fromRGB(40, 167, 69),
        Warning = Color3.fromRGB(255, 193, 7),
        Danger = Color3.fromRGB(220, 53, 69),
        Info = Color3.fromRGB(23, 162, 184)
    },
    Light = {
        Background = Color3.fromRGB(240, 240, 245),
        Secondary = Color3.fromRGB(250, 250, 255),
        Tertiary = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(138, 43, 226),
        AccentDark = Color3.fromRGB(108, 13, 196),
        Text = Color3.fromRGB(20, 20, 20),
        TextDark = Color3.fromRGB(100, 100, 100),
        Border = Color3.fromRGB(200, 200, 210),
        Success = Color3.fromRGB(40, 167, 69),
        Warning = Color3.fromRGB(255, 193, 7),
        Danger = Color3.fromRGB(220, 53, 69),
        Info = Color3.fromRGB(23, 162, 184)
    },
    Ocean = {
        Background = Color3.fromRGB(15, 23, 42),
        Secondary = Color3.fromRGB(30, 41, 59),
        Tertiary = Color3.fromRGB(51, 65, 85),
        Accent = Color3.fromRGB(14, 165, 233),
        AccentDark = Color3.fromRGB(2, 132, 199),
        Text = Color3.fromRGB(248, 250, 252),
        TextDark = Color3.fromRGB(148, 163, 184),
        Border = Color3.fromRGB(71, 85, 105),
        Success = Color3.fromRGB(34, 197, 94),
        Warning = Color3.fromRGB(234, 179, 8),
        Danger = Color3.fromRGB(239, 68, 68),
        Info = Color3.fromRGB(59, 130, 246)
    }
}

-- Notification System
function NexusUI:Notify(config)
    config = config or {}
    local title = config.Title or "Notification"
    local content = config.Content or ""
    local duration = config.Duration or 3
    local type = config.Type or "Info" -- Success, Warning, Danger, Info
    
    local notifGui = Instance.new("ScreenGui")
    notifGui.Name = "NexusNotification"
    notifGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    notifGui.Parent = GetParent()
    
    local notifFrame = Instance.new("Frame")
    notifFrame.Size = UDim2.new(0, 320, 0, 80)
    notifFrame.Position = UDim2.new(1, -340, 0, 20)
    notifFrame.BackgroundColor3 = self.Themes.Dark.Secondary
    notifFrame.BorderSizePixel = 0
    notifFrame.Parent = notifGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = notifFrame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = self.Themes.Dark[type] or self.Themes.Dark.Accent
    stroke.Thickness = 2
    stroke.Parent = notifFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0, 25)
    titleLabel.Position = UDim2.new(0, 10, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = self.Themes.Dark.Text
    titleLabel.TextSize = 16
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = notifFrame
    
    local contentLabel = Instance.new("TextLabel")
    contentLabel.Size = UDim2.new(1, -20, 0, 35)
    contentLabel.Position = UDim2.new(0, 10, 0, 35)
    contentLabel.BackgroundTransparency = 1
    contentLabel.Text = content
    contentLabel.TextColor3 = self.Themes.Dark.TextDark
    contentLabel.TextSize = 13
    contentLabel.Font = Enum.Font.Gotham
    contentLabel.TextXAlignment = Enum.TextXAlignment.Left
    contentLabel.TextWrapped = true
    contentLabel.Parent = notifFrame
    
    -- Slide in animation
    Utilities:Tween(notifFrame, {Position = UDim2.new(1, -340, 0, 20)}, 0.5, Enum.EasingStyle.Back)
    
    -- Auto close
    task.delay(duration, function()
        Utilities:Tween(notifFrame, {Position = UDim2.new(1, 20, 0, 20)}, 0.3)
        task.wait(0.3)
        notifGui:Destroy()
    end)
end

-- Create Window
function NexusUI:CreateWindow(config)
    config = config or {}
    
    local Window = {
        Config = {
            Name = config.Name or "NexusUI",
            Author = config.Author or "Unknown",
            Size = config.Size or UDim2.new(0, 650, 0, 500),
            Theme = config.Theme or "Dark",
            Accent = config.Accent or Color3.fromRGB(138, 43, 226),
            Position = config.Position,
            CloseCallback = config.CloseCallback,
            MinimizeKey = config.MinimizeKey or Enum.KeyCode.RightControl
        },
        Tabs = {},
        CurrentTab = nil,
        Minimized = false,
        Theme = nil
    }
    
    Window.Theme = self.Themes[Window.Config.Theme] or self.Themes.Dark
    
    -- Apply custom accent if provided
    if config.Accent then
        Window.Theme.Accent = config.Accent
    end
    
    -- ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NexusUI_" .. HttpService:GenerateGUID(false)
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = GetParent()
    
    Window.ScreenGui = ScreenGui
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = Window.Config.Size
    MainFrame.Position = Window.Config.Position or UDim2.new(0.5, -Window.Config.Size.X.Offset/2, 0.5, -Window.Config.Size.Y.Offset/2)
    MainFrame.BackgroundColor3 = Window.Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    Window.MainFrame = MainFrame
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = MainFrame
    
    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Window.Theme.Border
    mainStroke.Thickness = 1.5
    mainStroke.Transparency = 0.5
    mainStroke.Parent = MainFrame
    
    -- Top Bar
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 50)
    TopBar.BackgroundColor3 = Window.Theme.Secondary
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame
    
    Window.TopBar = TopBar
    
    local topCorner = Instance.new("UICorner")
    topCorner.CornerRadius = UDim.new(0, 12)
    topCorner.Parent = TopBar
    
    local topFix = Instance.new("Frame")
    topFix.Size = UDim2.new(1, 0, 0, 12)
    topFix.Position = UDim2.new(0, 0, 1, -12)
    topFix.BackgroundColor3 = Window.Theme.Secondary
    topFix.BorderSizePixel = 0
    topFix.Parent = TopBar
    
    -- Logo
    local Logo = Instance.new("Frame")
    Logo.Size = UDim2.new(0, 32, 0, 32)
    Logo.Position = UDim2.new(0, 15, 0.5, -16)
    Logo.BackgroundColor3 = Window.Theme.Accent
    Logo.BorderSizePixel = 0
    Logo.Parent = TopBar
    
    local logoCorner = Instance.new("UICorner")
    logoCorner.CornerRadius = UDim.new(0, 8)
    logoCorner.Parent = Logo
    
    local logoGradient = Instance.new("UIGradient")
    logoGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Window.Theme.Accent),
        ColorSequenceKeypoint.new(1, Window.Theme.AccentDark)
    }
    logoGradient.Rotation = 45
    logoGradient.Parent = Logo
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0, 350, 0, 20)
    Title.Position = UDim2.new(0, 55, 0, 8)
    Title.BackgroundTransparency = 1
    Title.Text = Window.Config.Name
    Title.TextColor3 = Window.Theme.Text
    Title.TextSize = 17
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar
    
    Window.TitleLabel = Title
    
    -- Author
    local Author = Instance.new("TextLabel")
    Author.Size = UDim2.new(0, 350, 0, 15)
    Author.Position = UDim2.new(0, 55, 0, 28)
    Author.BackgroundTransparency = 1
    Author.Text = "by " .. Window.Config.Author
    Author.TextColor3 = Window.Theme.TextDark
    Author.TextSize = 12
    Author.Font = Enum.Font.Gotham
    Author.TextXAlignment = Enum.TextXAlignment.Left
    Author.Parent = TopBar
    
    -- Minimize Button
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Size = UDim2.new(0, 36, 0, 36)
    MinimizeButton.Position = UDim2.new(1, -90, 0.5, -18)
    MinimizeButton.BackgroundColor3 = Window.Theme.Tertiary
    MinimizeButton.Text = "—"
    MinimizeButton.TextColor3 = Window.Theme.Text
    MinimizeButton.TextSize = 18
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.AutoButtonColor = false
    MinimizeButton.Parent = TopBar
    
    local minCorner = Instance.new("UICorner")
    minCorner.CornerRadius = UDim.new(0, 8)
    minCorner.Parent = MinimizeButton
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 36, 0, 36)
    CloseButton.Position = UDim2.new(1, -48, 0.5, -18)
    CloseButton.BackgroundColor3 = Window.Theme.Danger
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 22
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.AutoButtonColor = false
    CloseButton.Parent = TopBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = CloseButton
    
    -- Tab Container
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(0, 160, 1, -65)
    TabContainer.Position = UDim2.new(0, 10, 0, 55)
    TabContainer.BackgroundColor3 = Window.Theme.Secondary
    TabContainer.BorderSizePixel = 0
    TabContainer.ScrollBarThickness = 4
    TabContainer.ScrollBarImageColor3 = Window.Theme.Accent
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContainer.ScrollingDirection = Enum.ScrollingDirection.Y
    TabContainer.Parent = MainFrame
    
    Window.TabContainer = TabContainer
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 10)
    tabCorner.Parent = TabContainer
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 8)
    tabLayout.Parent = TabContainer
    
    local tabPadding = Instance.new("UIPadding")
    tabPadding.PaddingTop = UDim.new(0, 10)
    tabPadding.PaddingLeft = UDim.new(0, 8)
    tabPadding.PaddingRight = UDim2.new(0, 8)
    tabPadding.PaddingBottom = UDim.new(0, 10)
    tabPadding.Parent = TabContainer
    
    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -185, 1, -65)
    ContentContainer.Position = UDim2.new(0, 175, 0, 55)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = MainFrame
    
    Window.ContentContainer = ContentContainer
    
    -- Auto resize canvas
    tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContainer.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y + 20)
    end)
    
    -- Draggable
    Utilities:MakeDraggable(MainFrame, TopBar)
    
    -- Button Functionality
    CloseButton.MouseButton1Click:Connect(function()
        Utilities:RippleEffect(CloseButton, Color3.fromRGB(255, 255, 255))
        Utilities:Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.wait(0.3)
        if Window.Config.CloseCallback then
            Window.Config.CloseCallback()
        end
        ScreenGui:Destroy()
    end)
    
    CloseButton.MouseEnter:Connect(function()
        Utilities:Tween(CloseButton, {BackgroundColor3 = Color3.fromRGB(200, 40, 50)}, 0.2)
    end)
    
    CloseButton.MouseLeave:Connect(function()
        Utilities:Tween(CloseButton, {BackgroundColor3 = Window.Theme.Danger}, 0.2)
    end)
    
    MinimizeButton.MouseButton1Click:Connect(function()
        Utilities:RippleEffect(MinimizeButton, Window.Theme.Accent)
        Window.Minimized = not Window.Minimized
        if Window.Minimized then
            Utilities:Tween(MainFrame, {Size = UDim2.new(0, Window.Config.Size.X.Offset, 0, 50)}, 0.3)
            MinimizeButton.Text = "□"
        else
            Utilities:Tween(MainFrame, {Size = Window.Config.Size}, 0.3)
            MinimizeButton.Text = "—"
        end
    end)
    
    MinimizeButton.MouseEnter:Connect(function()
        Utilities:Tween(MinimizeButton, {BackgroundColor3 = Window.Theme.Accent}, 0.2)
    end)
    
    MinimizeButton.MouseLeave:Connect(function()
        Utilities:Tween(MinimizeButton, {BackgroundColor3 = Window.Theme.Tertiary}, 0.2)
    end)
    
    -- Minimize Key
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Window.Config.MinimizeKey then
            MinimizeButton.MouseButton1Click:Fire()
        end
    end)
    
    -- Load Components Module
    local Components = loadstring(game:HttpGet("YOUR_COMPONENTS_URL_HERE"))()
    Components.Init(Window, Utilities)
    Window.CreateTab = Components.CreateTab
    
    table.insert(self.Windows, Window)
    return Window
end

-- Theme Switching
function NexusUI:SetTheme(window, themeName)
    local theme = self.Themes[themeName]
    if not theme then return end
    
    window.Theme = theme
    window.MainFrame.BackgroundColor3 = theme.Background
    window.TopBar.BackgroundColor3 = theme.Secondary
    window.TabContainer.BackgroundColor3 = theme.Secondary
    window.TitleLabel.TextColor3 = theme.Text
    
    for _, tab in pairs(window.Tabs) do
        -- Update tab colors
        tab.Button.BackgroundColor3 = tab.Active and theme.Tertiary or theme.Secondary
        tab.Label.TextColor3 = tab.Active and theme.Text or theme.TextDark
    end
    
    self:Notify({
        Title = "Theme Changed",
        Content = "Theme set to " .. themeName,
        Duration = 2
    })
end

return NexusUI
