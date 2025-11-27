local Components = {}
local Window, Utilities

function Components.Init(window, utilities)
    Window = window
    Utilities = utilities
end

function Components.CreateTab(window, config)
    config = config or {}
    local Tab = {Name = config.Name or "Tab", Elements = {}, Active = false, Window = window}
    local color = config.Color or window.Theme.Accent
    
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(1, 0, 0, 42)
    TabButton.BackgroundColor3 = window.Theme.Tertiary
    TabButton.Text = ""
    TabButton.AutoButtonColor = false
    TabButton.Parent = window.TabContainer
    Tab.Button = TabButton
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 8)
    tabCorner.Parent = TabButton
    
    local Indicator = Instance.new("Frame")
    Indicator.Size = UDim2.new(0, 0, 1, 0)
    Indicator.BackgroundColor3 = color
    Indicator.BorderSizePixel = 0
    Indicator.Parent = TabButton
    Tab.Indicator = Indicator
    
    local indCorner = Instance.new("UICorner")
    indCorner.CornerRadius = UDim.new(0, 8)
    indCorner.Parent = Indicator
    
    local TabLabel = Instance.new("TextLabel")
    TabLabel.Size = UDim2.new(1, -45, 1, 0)
    TabLabel.Position = UDim2.new(0, 40, 0, 0)
    TabLabel.BackgroundTransparency = 1
    TabLabel.Text = Tab.Name
    TabLabel.TextColor3 = window.Theme.TextDark
    TabLabel.TextSize = 15
    TabLabel.Font = Enum.Font.GothamMedium
    TabLabel.TextXAlignment = Enum.TextXAlignment.Left
    TabLabel.Parent = TabButton
    Tab.Label = TabLabel
    
    local TabIcon = Instance.new("Frame")
    TabIcon.Size = UDim2.new(0, 8, 0, 8)
    TabIcon.Position = UDim2.new(0, 16, 0.5, -4)
    TabIcon.BackgroundColor3 = color
    TabIcon.BorderSizePixel = 0
    TabIcon.Parent = TabButton
    
    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(1, 0)
    iconCorner.Parent = TabIcon
    
    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.BackgroundTransparency = 1
    TabContent.BorderSizePixel = 0
    TabContent.ScrollBarThickness = 4
    TabContent.ScrollBarImageColor3 = color
    TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContent.Visible = false
    TabContent.Parent = window.ContentContainer
    Tab.Content = TabContent
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 10)
    layout.Parent = TabContent
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.PaddingBottom = UDim.new(0, 10)
    padding.Parent = TabContent
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContent.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
    end)
    
    local function ActivateTab()
        for _, tab in pairs(window.Tabs) do
            tab.Active = false
            Utilities:Tween(tab.Button, {BackgroundColor3 = window.Theme.Tertiary}, 0.2)
            Utilities:Tween(tab.Label, {TextColor3 = window.Theme.TextDark}, 0.2)
            Utilities:Tween(tab.Indicator, {Size = UDim2.new(0, 0, 1, 0)}, 0.3)
            tab.Content.Visible = false
        end
        Tab.Active = true
        Utilities:Tween(TabButton, {BackgroundColor3 = window.Theme.Secondary}, 0.2)
        Utilities:Tween(TabLabel, {TextColor3 = window.Theme.Text}, 0.2)
        Utilities:Tween(Indicator, {Size = UDim2.new(0, 4, 1, 0)}, 0.3)
        TabContent.Visible = true
        window.CurrentTab = Tab
    end
    
    TabButton.MouseButton1Click:Connect(function()
        Utilities:RippleEffect(TabButton, color)
        ActivateTab()
    end)
    
    if #window.Tabs == 0 then ActivateTab() end
    table.insert(window.Tabs, Tab)
    
    function Tab:Button(config)
        config = config or {}
        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(1, 0, 0, config.Desc and 70 or 45)
        Frame.BackgroundColor3 = window.Theme.Secondary
        Frame.BorderSizePixel = 0
        Frame.Parent = TabContent
        Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)
        
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, -20, 0, 35)
        Button.Position = UDim2.new(0, 10, 0, config.Desc and 28 or 5)
        Button.BackgroundColor3 = window.Theme.Accent
        Button.Text = config.Title or "Button"
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.TextSize = 14
        Button.Font = Enum.Font.GothamMedium
        Button.AutoButtonColor = false
        Button.Parent = Frame
        Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)
        
        if config.Desc then
            local Desc = Instance.new("TextLabel")
            Desc.Size = UDim2.new(1, -20, 0, 18)
            Desc.Position = UDim2.new(0, 10, 0, 5)
            Desc.BackgroundTransparency = 1
            Desc.Text = config.Desc
            Desc.TextColor3 = window.Theme.TextDark
            Desc.TextSize = 12
            Desc.Font = Enum.Font.Gotham
            Desc.TextXAlignment = Enum.TextXAlignment.Left
            Desc.Parent = Frame
        end
        
        Button.MouseButton1Click:Connect(function()
            Utilities:RippleEffect(Button, Color3.fromRGB(255, 255, 255))
            if config.Callback then config.Callback() end
        end)
        
        Button.MouseEnter:Connect(function()
            Utilities:Tween(Button, {BackgroundColor3 = window.Theme.AccentDark}, 0.2)
        end)
        Button.MouseLeave:Connect(function()
            Utilities:Tween(Button, {BackgroundColor3 = window.Theme.Accent}, 0.2)
        end)
        return Button
    end
    
    function Tab:Toggle(config)
        config = config or {}
        local toggled = config.Default or false
        
        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(1, 0, 0, config.Desc and 65 or 45)
        Frame.BackgroundColor3 = window.Theme.Secondary
        Frame.BorderSizePixel = 0
        Frame.Parent = TabContent
        Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)
        
        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1, -80, 0, 20)
        Title.Position = UDim2.new(0, 15, 0, config.Desc and 8 or 12)
        Title.BackgroundTransparency = 1
        Title.Text = config.Title or "Toggle"
        Title.TextColor3 = window.Theme.Text
        Title.TextSize = 14
        Title.Font = Enum.Font.GothamMedium
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Parent = Frame
        
        if config.Desc then
            local Desc = Instance.new("TextLabel")
            Desc.Size = UDim2.new(1, -80, 0, 30)
            Desc.Position = UDim2.new(0, 15, 0, 28)
            Desc.BackgroundTransparency = 1
            Desc.Text = config.Desc
            Desc.TextColor3 = window.Theme.TextDark
            Desc.TextSize = 12
            Desc.Font = Enum.Font.Gotham
            Desc.TextXAlignment = Enum.TextXAlignment.Left
            Desc.TextWrapped = true
            Desc.Parent = Frame
        end
        
        local ToggleBtn = Instance.new("TextButton")
        ToggleBtn.Size = UDim2.new(0, 45, 0, 25)
        ToggleBtn.Position = UDim2.new(1, -60, 0.5, -12.5)
        ToggleBtn.BackgroundColor3 = toggled and window.Theme.Accent or window.Theme.Tertiary
        ToggleBtn.Text = ""
        ToggleBtn.AutoButtonColor = false
        ToggleBtn.Parent = Frame
        Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
        
        local Circle = Instance.new("Frame")
        Circle.Size = UDim2.new(0, 19, 0, 19)
        Circle.Position = toggled and UDim2.new(1, -22, 0.5, -9.5) or UDim2.new(0, 3, 0.5, -9.5)
        Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Circle.BorderSizePixel = 0
        Circle.Parent = ToggleBtn
        Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)
        
        ToggleBtn.MouseButton1Click:Connect(function()
            toggled = not toggled
            Utilities:Tween(ToggleBtn, {BackgroundColor3 = toggled and window.Theme.Accent or window.Theme.Tertiary}, 0.3)
            Utilities:Tween(Circle, {Position = toggled and UDim2.new(1, -22, 0.5, -9.5) or UDim2.new(0, 3, 0.5, -9.5)}, 0.3)
            if config.Callback then config.Callback(toggled) end
        end)
        
        return {Set = function(v) toggled = v Utilities:Tween(ToggleBtn, {BackgroundColor3 = v and window.Theme.Accent or window.Theme.Tertiary}, 0.3) Utilities:Tween(Circle, {Position = v and UDim2.new(1, -22, 0.5, -9.5) or UDim2.new(0, 3, 0.5, -9.5)}, 0.3) end}
    end
    
    function Tab:Slider(config)
        config = config or {}
        local value = config.Default or 50
        
        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(1, 0, 0, config.Desc and 80 or 60)
        Frame.BackgroundColor3 = window.Theme.Secondary
        Frame.BorderSizePixel = 0
        Frame.Parent = TabContent
        Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)
        
        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(0.7, 0, 0, 18)
        Title.Position = UDim2.new(0, 15, 0, 10)
        Title.BackgroundTransparency = 1
        Title.Text = config.Title or "Slider"
        Title.TextColor3 = window.Theme.Text
        Title.TextSize = 14
        Title.Font = Enum.Font.GothamMedium
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Parent = Frame
        
        local ValueLabel = Instance.new("TextLabel")
        ValueLabel.Size = UDim2.new(0.3, -15, 0, 18)
        ValueLabel.Position = UDim2.new(0.7, 0, 0, 10)
        ValueLabel.BackgroundTransparency = 1
        ValueLabel.Text = tostring(value)
        ValueLabel.TextColor3 = window.Theme.Accent
        ValueLabel.TextSize = 14
        ValueLabel.Font = Enum.Font.GothamBold
        ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
        ValueLabel.Parent = Frame
        
        if config.Desc then
            local Desc = Instance.new("TextLabel")
            Desc.Size = UDim2.new(1, -30, 0, 15)
            Desc.Position = UDim2.new(0, 15, 0, 30)
            Desc.BackgroundTransparency = 1
            Desc.Text = config.Desc
            Desc.TextColor3 = window.Theme.TextDark
            Desc.TextSize = 11
            Desc.Font = Enum.Font.Gotham
            Desc.TextXAlignment = Enum.TextXAlignment.Left
            Desc.Parent = Frame
        end
        
        local SliderBack = Instance.new("Frame")
        SliderBack.Size = UDim2.new(1, -30, 0, 6)
        SliderBack.Position = UDim2.new(0, 15, 1, config.Desc and -18 or -15)
        SliderBack.BackgroundColor3 = window.Theme.Tertiary
        SliderBack.BorderSizePixel = 0
        SliderBack.Parent = Frame
        Instance.new("UICorner", SliderBack).CornerRadius = UDim.new(1, 0)
        
        local Fill = Instance.new("Frame")
        Fill.Size = UDim2.new((value - (config.Min or 0)) / ((config.Max or 100) - (config.Min or 0)), 0, 1, 0)
        Fill.BackgroundColor3 = window.Theme.Accent
        Fill.BorderSizePixel = 0
        Fill.Parent = SliderBack
        Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)
        
        local Dot = Instance.new("Frame")
        Dot.Size = UDim2.new(0, 16, 0, 16)
        Dot.Position = UDim2.new(1, -8, 0.5, -8)
        Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Dot.BorderSizePixel = 0
        Dot.Parent = Fill
        Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)
        
        local dragging = false
        local function Update(input)
            local pos = math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
            value = math.floor((config.Min or 0) + pos * ((config.Max or 100) - (config.Min or 0)) / (config.Increment or 1) + 0.5) * (config.Increment or 1)
            value = math.clamp(value, config.Min or 0, config.Max or 100)
            ValueLabel.Text = tostring(value)
            Utilities:Tween(Fill, {Size = UDim2.new((value - (config.Min or 0)) / ((config.Max or 100) - (config.Min or 0)), 0, 1, 0)}, 0.1)
            if config.Callback then config.Callback(value) end
        end
        
        SliderBack.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true Update(input) end
        end)
        SliderBack.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
        end)
        game:GetService("UserInputService").InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then Update(input) end
        end)
        
        return {Set = function(v) value = v ValueLabel.Text = tostring(v) Utilities:Tween(Fill, {Size = UDim2.new((v - (config.Min or 0)) / ((config.Max or 100) - (config.Min or 0)), 0, 1, 0)}, 0.2) end}
    end
    
    function Tab:Label(config)
        config = config or {}
        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(1, 0, 0, 40)
        Frame.BackgroundColor3 = window.Theme.Secondary
        Frame.BorderSizePixel = 0
        Frame.Parent = TabContent
        Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)
        
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -20, 1, 0)
        Label.Position = UDim2.new(0, 10, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = config.Text or "Label"
        Label.TextColor3 = config.Color or window.Theme.Text
        Label.TextSize = 14
        Label.Font = Enum.Font.Gotham
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.TextWrapped = true
        Label.Parent = Frame
        
        return {SetText = function(t) Label.Text = t end, SetColor = function(c) Label.TextColor3 = c end}
    end
    
    function Tab:Section(config)
        config = config or {}
        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(1, 0, 0, 35)
        Frame.BackgroundTransparency = 1
        Frame.Parent = TabContent
        
        local Line = Instance.new("Frame")
        Line.Size = UDim2.new(1, -30, 0, 2)
        Line.Position = UDim2.new(0, 15, 1, -2)
        Line.BackgroundColor3 = window.Theme.Border
        Line.BorderSizePixel = 0
        Line.Parent = Frame
        Instance.new("UICorner", Line).CornerRadius = UDim.new(1, 0)
        
        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(0, 200, 1, -5)
        Title.BackgroundTransparency = 1
        Title.Text = config.Title or "Section"
        Title.TextColor3 = window.Theme.Accent
        Title.TextSize = 15
        Title.Font = Enum.Font.GothamBold
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Parent = Frame
    end
    
    return Tab
end

return Components
