--[[\
    Coro Hub - Main Menu, Hitbox Expander, EHUI & Standalone Fly System
    Branded for: Coro Hub | made by 赤
]]--

do
    local Players = game:GetService("Players")
    local lp = Players.LocalPlayer

    local function hide(char)
        local hum = char:WaitForChild("Humanoid", 10)
        if hum then
            hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
            hum.HealthDisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
        end
    end

    local function setup(plr)
        if plr == lp then return end
        if plr.Character then task.spawn(hide, plr.Character) end
        plr.CharacterAdded:Connect(hide)
    end

    for _, p in ipairs(Players:GetPlayers()) do
        setup(p)
    end
    Players.PlayerAdded:Connect(setup)
end

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

if CoreGui:FindFirstChild("CoroScriptHub") then CoreGui.CoroScriptHub:Destroy() end
if CoreGui:FindFirstChild("CoroFlyStandaloneGui") then CoreGui.CoroFlyStandaloneGui:Destroy() end

local ConfigFileName = "CoroHub_Config.json"
local HubConfig = { HitboxEnabled = false, EHUIEnabled = false, FlyEnabled = false }

local function SaveConfig()
    pcall(function()
        if writefile then writefile(ConfigFileName, HttpService:JSONEncode(HubConfig)) end
    end)
end

local function LoadConfig()
    pcall(function()
        if readfile and isfile and isfile(ConfigFileName) then
            local data = HttpService:JSONDecode(readfile(ConfigFileName))
            if type(data) == "table" then HubConfig = data end
        end
    end)
end
LoadConfig()

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CoroScriptHub"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local rgbColors = {
    Color3.fromRGB(220, 20, 20),
    Color3.fromRGB(30, 30, 35),
    Color3.fromRGB(230, 230, 230)
}

local function applyRgbShift(element, isText)
    task.spawn(function()
        local idx = 1
        while element and element.Parent do
            local nextColor = rgbColors[idx]
            idx = (idx % #rgbColors) + 1
            local tween = TweenService:Create(element, TweenInfo.new(2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                [isText and "TextColor3" or "BackgroundColor3"] = nextColor
            })
            tween:Play()
            tween.Completed:Wait()
        end
    end)
end

local function applyRgbStrokeShift(strokeElement)
    task.spawn(function()
        local idx = 1
        while strokeElement and strokeElement.Parent do
            local nextColor = rgbColors[idx]
            idx = (idx % #rgbColors) + 1
            local tween = TweenService:Create(strokeElement, TweenInfo.new(2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { Color = nextColor })
            tween:Play()
            tween.Completed:Wait()
        end
    end)
end

local IntroLine = Instance.new("Frame", ScreenGui)
IntroLine.Name = "IntroLine"
IntroLine.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
IntroLine.AnchorPoint = Vector2.new(0.5, 0)
IntroLine.Position = UDim2.new(0.5, 0, 0, 15)
IntroLine.Size = UDim2.new(0, 0, 0, 3)
IntroLine.BorderSizePixel = 0
IntroLine.ZIndex = 10
Instance.new("UICorner", IntroLine).CornerRadius = UDim.new(1, 0)

local LineGlow = Instance.new("UIStroke", IntroLine)
LineGlow.Color = Color3.fromRGB(255, 50, 50)
LineGlow.Thickness = 2

local MicroIcon = Instance.new("Frame", ScreenGui)
MicroIcon.Name = "MicroIcon"
MicroIcon.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MicroIcon.AnchorPoint = Vector2.new(0.5, 0.5)
MicroIcon.Position = UDim2.new(0.5, 0, 0, 16)
MicroIcon.Size = UDim2.new(0, 0, 0, 0)
MicroIcon.Visible = false
MicroIcon.ZIndex = 5
Instance.new("UICorner", MicroIcon).CornerRadius = UDim.new(1, 0)

local MicroStroke = Instance.new("UIStroke", MicroIcon)
MicroStroke.Color = Color3.fromRGB(220, 0, 0)
MicroStroke.Thickness = 1.5
applyRgbStrokeShift(MicroStroke)

task.spawn(function()
    local idx = 1
    while MicroIcon and MicroIcon.Parent do
        local nextColor = rgbColors[idx]
        idx = (idx % #rgbColors) + 1
        local tween = TweenService:Create(MicroIcon, TweenInfo.new(2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            BackgroundColor3 = nextColor
        })
        tween:Play()
        tween.Completed:Wait()
    end
end)

local CenterText = Instance.new("TextLabel", MicroIcon)
CenterText.BackgroundTransparency = 1
CenterText.Size = UDim2.new(1, 0, 1, 0)
CenterText.Font = Enum.Font.GothamBlack
CenterText.Text = "赤"
CenterText.TextColor3 = Color3.fromRGB(255, 255, 255)
CenterText.TextSize = 16
CenterText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
CenterText.TextStrokeTransparency = 0.3
CenterText.ZIndex = 6

task.spawn(function()
    local idx = 1
    while CenterText and CenterText.Parent do
        local nextColor = rgbColors[idx]
        idx = (idx % #rgbColors) + 1
        local textColor = (nextColor == Color3.fromRGB(230, 230, 230)) and Color3.fromRGB(20, 20, 20) or Color3.fromRGB(255, 255, 255)
        local tween = TweenService:Create(CenterText, TweenInfo.new(2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            TextColor3 = textColor
        })
        tween:Play()
        tween.Completed:Wait()
    end
end)

task.spawn(function()
    local expandLine = TweenService:Create(IntroLine, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(0, 80, 0, 3) })
    expandLine:Play()
    expandLine.Completed:Wait()
    IntroLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    task.wait(0.05)
    IntroLine:Destroy()
    MicroIcon.Visible = true
    TweenService:Create(MicroIcon, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Size = UDim2.new(0, 30, 0, 30), Position = UDim2.new(0.5, 0, 0, 30) }):Play()
end)

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 10, 12)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.ClipsDescendants = true
MainFrame.ZIndex = 50

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(220, 0, 0)
MainStroke.Thickness = 1.5
applyRgbStrokeShift(MainStroke)

local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Name = "Sidebar"
Sidebar.BackgroundColor3 = Color3.fromRGB(10, 8, 10)
Sidebar.Size = UDim2.new(0, 130, 1, 0)
Sidebar.ZIndex = 51
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)

local SidebarStroke = Instance.new("UIStroke", Sidebar)
SidebarStroke.Color = Color3.fromRGB(40, 15, 20)
SidebarStroke.Thickness = 1

local HubLogo = Instance.new("TextLabel", Sidebar)
HubLogo.BackgroundTransparency = 1
HubLogo.Position = UDim2.new(0, 12, 0, 12)
HubLogo.Size = UDim2.new(1, -16, 0, 22)
HubLogo.Font = Enum.Font.GothamBold
HubLogo.Text = "Coro Hub <font size='10' color='#AAAAAA'>| made by 赤</font>"
HubLogo.RichText = true
HubLogo.TextColor3 = Color3.fromRGB(255, 255, 255)
HubLogo.TextSize = 13
HubLogo.TextXAlignment = Enum.TextXAlignment.Left
HubLogo.ZIndex = 52
applyRgbShift(HubLogo, true)

local TabContainer = Instance.new("Frame", Sidebar)
TabContainer.BackgroundTransparency = 1
TabContainer.Position = UDim2.new(0, 8, 0, 44)
TabContainer.Size = UDim2.new(1, -16, 1, -50)
TabContainer.ZIndex = 52

local TabList = Instance.new("UIListLayout", TabContainer)
TabList.SortOrder = Enum.SortOrder.LayoutOrder
TabList.Padding = UDim.new(0, 4)

local tabs = {}
local currentTab = nil

local function CreateTab(name, icon)
    local TabBtn = Instance.new("TextButton", TabContainer)
    TabBtn.Name = name .. "Tab"
    TabBtn.BackgroundColor3 = Color3.fromRGB(25, 12, 14)
    TabBtn.BackgroundTransparency = 1
    TabBtn.Size = UDim2.new(1, 0, 0, 30)
    TabBtn.Font = Enum.Font.GothamMedium
    TabBtn.Text = "   " .. icon .. "  " .. name
    TabBtn.TextColor3 = Color3.fromRGB(160, 140, 145)
    TabBtn.TextSize = 11
    TabBtn.TextXAlignment = Enum.TextXAlignment.Left
    TabBtn.AutoButtonColor = false
    TabBtn.ZIndex = 53
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

    local Page = Instance.new("ScrollingFrame", MainFrame)
    Page.Name = name .. "Page"
    Page.BackgroundTransparency = 1
    Page.Position = UDim2.new(0, 138, 0, 12)
    Page.Size = UDim2.new(1, -146, 1, -24)
    Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    Page.ScrollBarThickness = 0
    Page.Visible = false
    Page.ZIndex = 52

    local PageLayout = Instance.new("UIListLayout", Page)
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.Padding = UDim.new(0, 6)

    TabBtn.MouseButton1Click:Connect(function()
        for _, t in ipairs(tabs) do
            t.Btn.BackgroundTransparency = 1
            t.Btn.TextColor3 = Color3.fromRGB(160, 140, 145)
            t.Page.Visible = false
        end
        TabBtn.BackgroundTransparency = 0
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        Page.Visible = true
        currentTab = name
    end)

    table.insert(tabs, { Btn = TabBtn, Page = Page })
    return Page
end

local FeaturesPage = CreateTab("Features", "⚔️")
local InfoPage = CreateTab("Info", "📌")

tabs[1].Btn.BackgroundTransparency = 0
tabs[1].Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
FeaturesPage.Visible = true

local MinimizeBtn = Instance.new("TextButton", MainFrame)
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.Position = UDim2.new(1, -26, 0, 2)
MinimizeBtn.Size = UDim2.new(0, 22, 0, 22)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 20
MinimizeBtn.ZIndex = 55
applyRgbShift(MinimizeBtn, true)

local function CreateSettingRow(parent, titleText, infoType)
    local Row = Instance.new("Frame", parent)
    Row.BackgroundColor3 = Color3.fromRGB(22, 12, 14)
    Row.Size = UDim2.new(1, 0, 0, 36)
    Row.ZIndex = 53
    Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 6)

    local RowStroke = Instance.new("UIStroke", Row)
    RowStroke.Color = Color3.fromRGB(60, 20, 25)
    RowStroke.Thickness = 1

    local Title = Instance.new("TextLabel", Row)
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.Size = UDim2.new(0.6, 0, 1, 0)
    Title.Font = Enum.Font.GothamMedium
    Title.Text = titleText
    Title.TextColor3 = Color3.fromRGB(240, 230, 232)
    Title.TextSize = 11
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.ZIndex = 54

    local SwitchTrack = Instance.new("TextButton", Row)
    SwitchTrack.BackgroundColor3 = Color3.fromRGB(15, 10, 12)
    SwitchTrack.AnchorPoint = Vector2.new(1, 0.5)
    SwitchTrack.Position = UDim2.new(1, -8, 0.5, 0)
    SwitchTrack.Size = UDim2.new(0, 38, 0, 20)
    SwitchTrack.Text = ""
    SwitchTrack.AutoButtonColor = false
    SwitchTrack.ZIndex = 54
    Instance.new("UICorner", SwitchTrack).CornerRadius = UDim.new(1, 0)

    local TrackStroke = Instance.new("UIStroke", SwitchTrack)
    TrackStroke.Color = Color3.fromRGB(120, 0, 0)
    TrackStroke.Thickness = 1

    local SwitchKnob = Instance.new("Frame", SwitchTrack)
    SwitchKnob.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    SwitchKnob.AnchorPoint = Vector2.new(0, 0.5)
    SwitchKnob.Position = UDim2.new(0, 2, 0.5, 0)
    SwitchKnob.Size = UDim2.new(0, 16, 0, 16)
    SwitchKnob.ZIndex = 55
    Instance.new("UICorner", SwitchKnob).CornerRadius = UDim.new(1, 0)

    if infoType then
        local InfoIcon = Instance.new("TextButton", Row)
        InfoIcon.BackgroundTransparency = 1
        InfoIcon.Position = UDim2.new(1, -68, 0.5, -9)
        InfoIcon.Size = UDim2.new(0, 18, 0, 18)
        InfoIcon.Font = Enum.Font.GothamBold
        InfoIcon.Text = "?"
        InfoIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
        InfoIcon.TextSize = 11
        InfoIcon.ZIndex = 54
        applyRgbShift(InfoIcon, true)
        return Row, SwitchTrack, SwitchKnob, TrackStroke, InfoIcon
    end

    return Row, SwitchTrack, SwitchKnob, TrackStroke
end

local _, HitboxTrack, HitboxKnob, HitboxStroke, HitboxInfoBtn = CreateSettingRow(FeaturesPage, "Hitbox Expander", "hitbox")
local _, EHUITrack, EHUIKnob, EHUIStroke, EHUIInfoBtn = CreateSettingRow(FeaturesPage, "EHUI", "ehui")
local _, FlyTrack, FlyKnob, FlyStroke = CreateSettingRow(FeaturesPage, "Fly GUI", nil)

local function CreateInfoCard(parent, label, value)
    local Card = Instance.new("Frame", parent)
    Card.BackgroundColor3 = Color3.fromRGB(22, 12, 14)
    Card.Size = UDim2.new(1, 0, 0, 32)
    Card.ZIndex = 53
    Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 6)

    local CardStroke = Instance.new("UIStroke", Card)
    CardStroke.Color = Color3.fromRGB(60, 20, 25)
    CardStroke.Thickness = 1

    local Lbl = Instance.new("TextLabel", Card)
    Lbl.BackgroundTransparency = 1
    Lbl.Position = UDim2.new(0, 10, 0, 0)
    Lbl.Size = UDim2.new(0.4, 0, 1, 0)
    Lbl.Font = Enum.Font.GothamMedium
    Lbl.Text = label
    Lbl.TextColor3 = Color3.fromRGB(160, 140, 145)
    Lbl.TextSize = 10
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.ZIndex = 54

    local Val = Instance.new("TextLabel", Card)
    Val.BackgroundTransparency = 1
    Val.Position = UDim2.new(0.4, 0, 0, 0)
    Val.Size = UDim2.new(0.6, -10, 1, 0)
    Val.Font = Enum.Font.GothamBold
    Val.Text = value
    Val.TextColor3 = Color3.fromRGB(240, 230, 232)
    Val.TextSize = 11
    Val.TextXAlignment = Enum.TextXAlignment.Right
    Val.ZIndex = 54
end

CreateInfoCard(InfoPage, "Developer", "赤")
CreateInfoCard(InfoPage, "Display Name", "赤")
CreateInfoCard(InfoPage, "Discord User", "3ajz")

local CopyCard = Instance.new("Frame", InfoPage)
CopyCard.BackgroundColor3 = Color3.fromRGB(22, 12, 14)
CopyCard.Size = UDim2.new(1, 0, 0, 34)
CopyCard.ZIndex = 53
Instance.new("UICorner", CopyCard).CornerRadius = UDim.new(0, 6)

local CopyCardStroke = Instance.new("UIStroke", CopyCard)
CopyCardStroke.Color = Color3.fromRGB(60, 20, 25)
CopyCardStroke.Thickness = 1

local CopyBtn = Instance.new("TextButton", CopyCard)
CopyBtn.BackgroundTransparency = 1
CopyBtn.Size = UDim2.new(1, 0, 1, 0)
CopyBtn.Font = Enum.Font.GothamBold
CopyBtn.Text = "📋  Copy Discord Link"
CopyBtn.TextColor3 = Color3.fromRGB(240, 230, 232)
CopyBtn.TextSize = 11
CopyBtn.ZIndex = 54

local DiscordLink = "https://discord.gg/BUYGSzVSN"
local ScriptLinkHolder = ""

CopyBtn.MouseButton1Click:Connect(function()
    pcall(function()
        if setclipboard then
            setclipboard(DiscordLink)
        elseif toClipboard then
            toClipboard(DiscordLink)
        end
    end)
    CopyBtn.Text = "✓ Copied Link!"
    task.delay(1.5, function()
        CopyBtn.Text = "📋  Copy Discord Link"
    end)
end)

local InfoFrame = Instance.new("Frame", ScreenGui)
InfoFrame.Name = "InfoFrame"
InfoFrame.BackgroundColor3 = Color3.fromRGB(15, 10, 12)
InfoFrame.AnchorPoint = Vector2.new(0.5, 0.5)
InfoFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
InfoFrame.Size = UDim2.new(0, 0, 0, 0)
InfoFrame.Visible = false
InfoFrame.Active = true
InfoFrame.ZIndex = 100
Instance.new("UICorner", InfoFrame).CornerRadius = UDim.new(0, 10)

local InfoFrameStroke = Instance.new("UIStroke", InfoFrame)
InfoFrameStroke.Color = Color3.fromRGB(220, 0, 0)
InfoFrameStroke.Thickness = 1.5
applyRgbStrokeShift(InfoFrameStroke)

local InfoHeader = Instance.new("Frame", InfoFrame)
InfoHeader.BackgroundTransparency = 1
InfoHeader.Position = UDim2.new(0, 12, 0, 10)
InfoHeader.Size = UDim2.new(1, -24, 0, 24)
InfoHeader.ZIndex = 101

local InfoTitle = Instance.new("TextLabel", InfoHeader)
InfoTitle.BackgroundTransparency = 1
InfoTitle.Size = UDim2.new(0.85, 0, 1, 0)
InfoTitle.Font = Enum.Font.GothamBold
InfoTitle.Text = "Info"
InfoTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
InfoTitle.TextSize = 12
InfoTitle.TextXAlignment = Enum.TextXAlignment.Left
InfoTitle.ZIndex = 102

local InfoCloseBtn = Instance.new("TextButton", InfoHeader)
InfoCloseBtn.BackgroundTransparency = 1
InfoCloseBtn.Position = UDim2.new(1, -20, 0, 0)
InfoCloseBtn.Size = UDim2.new(0, 20, 0, 20)
InfoCloseBtn.Font = Enum.Font.GothamBold
InfoCloseBtn.Text = "X"
InfoCloseBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
InfoCloseBtn.TextSize = 12
InfoCloseBtn.ZIndex = 102

local InfoDesc = Instance.new("TextLabel", InfoFrame)
InfoDesc.BackgroundTransparency = 1
InfoDesc.Position = UDim2.new(0, 12, 0, 36)
InfoDesc.Size = UDim2.new(1, -24, 1, -44)
InfoDesc.Font = Enum.Font.Gotham
InfoDesc.Text = ""
InfoDesc.TextColor3 = Color3.fromRGB(220, 220, 220)
InfoDesc.TextSize = 10
InfoDesc.TextWrapped = true
InfoDesc.TextXAlignment = Enum.TextXAlignment.Left
InfoDesc.TextYAlignment = Enum.TextYAlignment.Top
InfoDesc.ZIndex = 101

local isInfoOpen = false
local function OpenInfo(titleText, descText, frameWidth, frameHeight)
    InfoTitle.Text = titleText
    InfoDesc.Text = descText
    InfoFrame.Size = UDim2.new(0, 0, 0, 0)
    InfoFrame.Visible = true
    isInfoOpen = true
    TweenService:Create(InfoFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Size = UDim2.new(0, frameWidth or 330, 0, frameHeight or 180) }):Play()
end

local function CloseInfo()
    if not isInfoOpen then return end
    isInfoOpen = false
    local closeTween = TweenService:Create(InfoFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Size = UDim2.new(0, 0, 0, 0) })
    closeTween:Play()
    closeTween.Completed:Wait()
    InfoFrame.Visible = false
end

HitboxInfoBtn.MouseButton1Click:Connect(function()
    local text = "this feature makes all your shots a guaranteed headshot\nhow to use: Aim the weapon at the person, preferably someone who is stationary or not moving much for a guaranteed Kill.\n\n[tips] ↓\n1.Equip Hypershot if you have it (you can get it from Item Reroll), put it in your inventory, activate EHUI, and wait until you see an opponent with 20 health or less then finish them off with one hit. This guarantees 5 kills if you know how to use it well.\n\n2.Spam snipers commsnd and focus on the Barrett and AWP because they are one-shot weapons. Stop time and kill with ease."
    OpenInfo("Hitbox Expander Info", text, 350, 220)
end)

EHUIInfoBtn.MouseButton1Click:Connect(function()
    local text = "This feature gives you a professional blood and ESP UI, letting you know who is about to die when you see the red color above them, so you can spot and target them with ease."
    OpenInfo("EHUI Info", text, 330, 130)
end)

InfoCloseBtn.MouseButton1Click:Connect(CloseInfo)

local isOpen = false
local updateFlyGuiVisibility

local ehuiGui = Instance.new("ScreenGui")
ehuiGui.Name = "HP_ESP_PRO"
ehuiGui.IgnoreGuiInset = true
ehuiGui.ResetOnSpawn = false
ehuiGui.DisplayOrder = 1
ehuiGui.Parent = CoreGui

local function OpenHub()
    if isOpen then return end
    isOpen = true
    MainFrame.Position = MicroIcon.Position
    MainFrame.Size = UDim2.new(0, 30, 0, 30)
    MicroIcon.Visible = false
    MainFrame.Visible = true
    ehuiGui.Enabled = false
    if updateFlyGuiVisibility then updateFlyGuiVisibility() end
    
    TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 360, 0, 210)
    }):Play()
end

local function CloseHub()
    if not isOpen then return end
    isOpen = false
    
    local closeTween = TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Position = MicroIcon.Position,
        Size = UDim2.new(0, 30, 0, 30)
    })
    closeTween:Play()
    closeTween.Completed:Wait()
    
    MainFrame.Visible = false
    MicroIcon.Visible = true
    if HubConfig.EHUIEnabled then
        ehuiGui.Enabled = true
    end
    if updateFlyGuiVisibility then updateFlyGuiVisibility() end
end

local iconDragged = false
local iconStartTouch = nil
local iconDragPos = nil

OpenClickDetector = Instance.new("TextButton", MicroIcon)
OpenClickDetector.BackgroundTransparency = 1
OpenClickDetector.Size = UDim2.new(1, 0, 1, 0)
OpenClickDetector.Text = ""
OpenClickDetector.ZIndex = 7

OpenClickDetector.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        iconDragged = false
        iconStartTouch = input.Position
        iconDragPos = MicroIcon.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and iconStartTouch then
        local delta = input.Position - iconStartTouch
        if delta.Magnitude > 6 then
            iconDragged = true
            MicroIcon.Position = UDim2.new(iconDragPos.X.Scale, iconDragPos.X.Offset + delta.X, iconDragPos.Y.Scale, iconDragPos.Y.Offset + delta.Y)
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        iconStartTouch = nil
    end
end)

OpenClickDetector.MouseButton1Click:Connect(function()
    if not iconDragged then
        OpenHub()
    end
end)

MinimizeBtn.MouseButton1Click:Connect(CloseHub)

local function UpdateSwitchVisuals(knob, stroke, enabled)
    local targetPos = enabled and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
    TweenService:Create(knob, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Position = targetPos }):Play()
    if not enabled then
        TweenService:Create(knob, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = Color3.fromRGB(200, 200, 200) }):Play()
        stroke.Color = Color3.fromRGB(120, 0, 0)
    end
end

task.spawn(function()
    local idx = 1
    while ScreenGui and ScreenGui.Parent do
        local nextColor = rgbColors[idx]
        idx = (idx % #rgbColors) + 1
        
        if HubConfig.HitboxEnabled then
            pcall(function()
                TweenService:Create(HitboxKnob, TweenInfo.new(2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { BackgroundColor3 = nextColor }):Play()
                TweenService:Create(HitboxStroke, TweenInfo.new(2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { Color = nextColor }):Play()
            end)
        end
        if HubConfig.EHUIEnabled then
            pcall(function()
                TweenService:Create(EHUIKnob, TweenInfo.new(2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { BackgroundColor3 = nextColor }):Play()
                TweenService:Create(EHUIStroke, TweenInfo.new(2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { Color = nextColor }):Play()
            end)
        end
        if HubConfig.FlyEnabled then
            pcall(function()
                TweenService:Create(FlyKnob, TweenInfo.new(2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { BackgroundColor3 = nextColor }):Play()
                TweenService:Create(FlyStroke, TweenInfo.new(2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { Color = nextColor }):Play()
            end)
        end
        task.wait(2.5)
    end
end)

UpdateSwitchVisuals(HitboxKnob, HitboxStroke, HubConfig.HitboxEnabled)
UpdateSwitchVisuals(EHUIKnob, EHUIStroke, HubConfig.EHUIEnabled)
UpdateSwitchVisuals(FlyKnob, FlyStroke, HubConfig.FlyEnabled)

HitboxTrack.MouseButton1Click:Connect(function()
    HubConfig.HitboxEnabled = not HubConfig.HitboxEnabled
    UpdateSwitchVisuals(HitboxKnob, HitboxStroke, HubConfig.HitboxEnabled)
    SaveConfig()
    if not HubConfig.HitboxEnabled then
        for _, v in ipairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character then
                pcall(function()
                    local head = v.Character:FindFirstChild("Head")
                    if head then
                        head.Size = Vector3.new(2, 1, 1)
                        head.Transparency = 0
                        head.CanCollide = true
                    end
                end)
            end
        end
    end
end)

local TEXT_SIZE = 9
local HEIGHT = 3.6
local BAR_H = 3
local BG_TRANSPARENCY = 0.35
local SMOOTHNESS = 18
local SHOW_SELF = true

local COLOR_STOPS = {
    {1.00, Color3.fromRGB(255, 255, 255)},
    {0.99, Color3.fromRGB(255, 220, 0)},
    {0.60, Color3.fromRGB(255, 180, 0)},
    {0.40, Color3.fromRGB(255, 110, 0)},
    {0.20, Color3.fromRGB(255, 40, 40)},
    {0.00, Color3.fromRGB(255, 40, 40)},
}

local function hpColor(pct)
    pct = math.clamp(pct, 0, 1)
    if pct >= 1.0 then return COLOR_STOPS[1][2] end
    for i = 2, #COLOR_STOPS - 1 do
        local hi, lo = COLOR_STOPS[i], COLOR_STOPS[i + 1]
        if pct <= hi[1] and pct >= lo[1] then
            local a = (pct - lo[1]) / (hi[1] - lo[1])
            return lo[2]:Lerp(hi[2], a)
        end
    end
    return COLOR_STOPS[#COLOR_STOPS][2]
end

local tags = {}

local function makeTag(player)
    if tags[player] then return end

    local frame = Instance.new("Frame")
    frame.Size = UDim2.fromOffset(36, 18)
    frame.AnchorPoint = Vector2.new(0.5, 1)
    frame.BackgroundColor3 = Color3.new(1, 1, 1)
    frame.BackgroundTransparency = BG_TRANSPARENCY
    frame.BorderSizePixel = 0
    frame.Visible = false
    frame.Parent = ehuiGui

    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 4)

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Color = Color3.fromRGB(220, 0, 0)
    stroke.Parent = frame
    applyRgbStrokeShift(stroke)

    local nameText = Instance.new("TextLabel")
    nameText.Size = UDim2.new(0, 0, 1, -(BAR_H + 3))
    nameText.Position = UDim2.new(0, 4, 0, 0)
    nameText.AutomaticSize = Enum.AutomaticSize.X
    nameText.BackgroundTransparency = 1
    nameText.Font = Enum.Font.GothamBold
    nameText.TextSize = TEXT_SIZE
    nameText.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameText.TextXAlignment = Enum.TextXAlignment.Left
    nameText.TextStrokeColor3 = Color3.new(0, 0, 0)
    nameText.TextStrokeTransparency = 1
    nameText.TextTransparency = 1
    nameText.ZIndex = frame.ZIndex + 2
    nameText.Parent = frame
    applyRgbShift(nameText, true)

    local hpContainer = Instance.new("Frame")
    hpContainer.Size = UDim2.new(1, 0, 1, -(BAR_H + 3))
    hpContainer.Position = UDim2.new(0, 0, 0, 0)
    hpContainer.BackgroundTransparency = 1
    hpContainer.ZIndex = frame.ZIndex + 2
    hpContainer.Parent = frame

    local hpText = Instance.new("TextLabel")
    hpText.Size = UDim2.new(1, 0, 1, 0)
    hpText.BackgroundTransparency = 1
    hpText.Font = Enum.Font.GothamBold
    hpText.TextSize = TEXT_SIZE
    hpText.TextColor3 = Color3.new(1, 1, 1)
    hpText.TextXAlignment = Enum.TextXAlignment.Center
    hpText.TextStrokeTransparency = 1
    hpText.ZIndex = frame.ZIndex + 3
    hpText.Parent = hpContainer

    local hpStroke = Instance.new("UIStroke")
    hpStroke.Thickness = 1
    hpStroke.Color = Color3.fromRGB(220, 0, 0)
    hpStroke.Parent = hpText
    applyRgbStrokeShift(hpStroke)

    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.new(1, -4, 0, BAR_H)
    barBg.Position = UDim2.new(0, 2, 1, -(BAR_H + 2))
    barBg.BackgroundColor3 = Color3.new(0, 0, 0)
    barBg.BackgroundTransparency = 0.5
    barBg.BorderSizePixel = 0
    barBg.ZIndex = frame.ZIndex + 2
    barBg.Parent = frame
    Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)

    local barBgStroke = Instance.new("UIStroke")
    barBgStroke.Thickness = 1
    barBgStroke.Color = Color3.fromRGB(220, 0, 0)
    barBgStroke.Parent = barBg
    applyRgbStrokeShift(barBgStroke)

    local bar = Instance.new("Frame")
    bar.Size = UDim2.fromScale(1, 1)
    bar.BackgroundColor3 = Color3.new(1, 1, 1)
    bar.BorderSizePixel = 0
    bar.ZIndex = frame.ZIndex + 3
    bar.Parent = barBg
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

    tags[player] = {
        frame = frame, nameText = nameText, hpContainer = hpContainer, hpText = hpText, bar = bar,
        smoothPos = nil, animProgress = 0,
        currentNameState = player.Name, lastSwitchTick = 0, nameAnim = 1
    }
end

local function removeTag(player)
    local t = tags[player]
    if t then t.frame:Destroy() tags[player] = nil end
end

for _, p in ipairs(Players:GetPlayers()) do makeTag(p) end
Players.PlayerAdded:Connect(makeTag)
Players.PlayerRemoving:Connect(removeTag)

local function setRobloxLabelsVisible(char, visible)
    if not char then return end
    for _, v in ipairs(char:GetDescendants()) do
        if v:IsA("BillboardGui") or v:IsA("SurfaceGui") then v.Enabled = visible end
    end
    local head = char:FindFirstChild("Head")
    if head then
        for _, v in ipairs(head:GetChildren()) do
            if v:IsA("BillboardGui") then v.Enabled = visible end
        end
    end
end

EHUITrack.MouseButton1Click:Connect(function()
    HubConfig.EHUIEnabled = not HubConfig.EHUIEnabled
    UpdateSwitchVisuals(EHUIKnob, EHUIStroke, HubConfig.EHUIEnabled)
    SaveConfig()
    
    ehuiGui.Enabled = HubConfig.EHUIEnabled and not isOpen

    if not HubConfig.EHUIEnabled then
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Character then setRobloxLabelsVisible(p.Character, true) end
            if tags[p] then tags[p].frame.Visible = false end
        end
    end
end)

RunService:BindToRenderStep("CoroEHUI_Render", Enum.RenderPriority.Last.Value, function(dt)
    if not HubConfig.EHUIEnabled or isOpen then 
        ehuiGui.Enabled = false
        return 
    else
        ehuiGui.Enabled = true
    end

    local cam = workspace.CurrentCamera
    local now = os.clock()
    local alpha = 1 - math.exp(-SMOOTHNESS * dt)

    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")

    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character then setRobloxLabelsVisible(p.Character, false) end
    end

    for player, t in pairs(tags) do
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
        local show = false

        if hum and root and hum.Health > 0 then
            local target = root.Position + Vector3.new(0, HEIGHT, 0)
            if not t.smoothPos or (t.smoothPos - target).Magnitude > 10 then
                t.smoothPos = target
            else
                t.smoothPos = t.smoothPos:Lerp(target, alpha)
            end

            local pos, onScreen = cam:WorldToViewportPoint(t.smoothPos)
            if onScreen and pos.Z > 0 then
                local pct = hum.Health / math.max(hum.MaxHealth, 1)
                local col = hpColor(pct)

                local dist = myRoot and (root.Position - myRoot.Position).Magnitude or 9999
                local targetProgress = (dist <= 15) and 1 or 0
                t.animProgress = t.animProgress + (targetProgress - t.animProgress) * math.clamp(dt * 12, 0, 1)

                if now - t.lastSwitchTick >= 4 then
                    t.lastSwitchTick = now
                    local targetTargetName = (t.currentNameState == player.Name) and (player.DisplayName ~= "" and player.DisplayName or player.Name) or player.Name
                    
                    task.spawn(function()
                        for f = 1, 0, -0.2 do
                            t.nameAnim = f
                            task.wait(0.02)
                        end
                        t.currentNameState = targetTargetName
                        t.nameText.Text = t.currentNameState
                        for f = 0, 1, 0.2 do
                            t.nameAnim = f
                            task.wait(0.02)
                        end
                        t.nameAnim = 1
                    end)
                end

                local nameWidth = (t.animProgress > 0.05) and (t.nameText.TextBounds.X + 8) or 0
                local baseWidth = 36
                local targetWidth = baseWidth + nameWidth
                
                local currentWidth = t.frame.AbsoluteSize.X
                t.frame.Size = UDim2.fromOffset(currentWidth + (targetWidth - currentWidth) * math.clamp(dt * 15, 0, 1), 18)

                local finalAlpha = (1 - t.animProgress) + (1 - t.nameAnim)
                t.nameText.TextTransparency = math.clamp(finalAlpha, 0, 1)

                if t.animProgress > 0.05 then
                    t.hpContainer.Size = UDim2.new(0, 44, 1, -(BAR_H + 3))
                    t.hpContainer.AnchorPoint = Vector2.new(1, 0)
                    t.hpContainer.Position = UDim2.new(1, -2, 0, 0)
                    t.hpText.TextXAlignment = Enum.TextXAlignment.Center
                else
                    t.hpContainer.Size = UDim2.new(1, 0, 1, -(BAR_H + 3))
                    t.hpContainer.AnchorPoint = Vector2.new(0, 0)
                    t.hpContainer.Position = UDim2.new(0, 0, 0, 0)
                    t.hpText.TextXAlignment = Enum.TextXAlignment.Center
                end

                t.frame.Position = UDim2.fromOffset(pos.X, pos.Y)
                
                TweenService:Create(t.frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = col }):Play()
                
                t.hpText.Text = "[" .. tostring(math.floor(hum.Health)) .. "]"
                t.bar.Size = UDim2.fromScale(math.clamp(pct, 0, 1), 1)
                show = true
            end
        else
            t.smoothPos = nil
            t.animProgress = 0
        end

        t.frame.Visible = show
    end
end)

local main = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local onof = Instance.new("TextButton")
local plus = Instance.new("TextButton")
local speed = Instance.new("TextLabel")
local mine = Instance.new("TextButton")

main.Name = "CoroFlyStandaloneGui"
main.Parent = CoreGui
main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
main.ResetOnSpawn = false
main.Enabled = false

Frame.Parent = main
Frame.BackgroundColor3 = Color3.fromRGB(15, 10, 12)
Frame.BackgroundTransparency = 0.2
Frame.Position = UDim2.new(0.1, 0, 0.38, 0)
Frame.Size = UDim2.new(0, 190, 0, 68)
Frame.Active = true
Frame.Draggable = true

Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)
local FlyFrameStroke = Instance.new("UIStroke", Frame)
FlyFrameStroke.Color = Color3.fromRGB(220, 0, 0)
FlyFrameStroke.Thickness = 1.5
applyRgbStrokeShift(FlyFrameStroke)

local FlyWm = Instance.new("TextLabel", Frame)
FlyWm.BackgroundTransparency = 1
FlyWm.Position = UDim2.new(0, 8, 0, 2)
FlyWm.Size = UDim2.new(0, 20, 0, 14)
FlyWm.Font = Enum.Font.GothamBlack
FlyWm.Text = "赤"
FlyWm.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyWm.TextSize = 10
FlyWm.TextTransparency = 0.4

speed.Name = "speed"
speed.Parent = Frame
speed.BackgroundColor3 = Color3.fromRGB(22, 12, 14)
speed.Position = UDim2.new(0.5, -28, 0, 4)
speed.Size = UDim2.new(0, 56, 0, 24)
speed.Font = Enum.Font.GothamBold
speed.Text = "1"
speed.TextColor3 = Color3.fromRGB(255, 255, 255)
speed.TextSize = 13
Instance.new("UICorner", speed).CornerRadius = UDim.new(1, 0)
local speedStroke = Instance.new("UIStroke", speed)
speedStroke.Color = Color3.fromRGB(200, 0, 0)
applyRgbStrokeShift(speedStroke)

mine.Name = "mine"
mine.Parent = Frame
mine.BackgroundColor3 = Color3.fromRGB(22, 12, 14)
mine.Position = UDim2.new(0, 6, 0, 4)
mine.Size = UDim2.new(0, 36, 0, 24)
mine.Font = Enum.Font.GothamBold
mine.Text = "-"
mine.TextColor3 = Color3.fromRGB(255, 255, 255)
mine.TextSize = 14
mine.AutoButtonColor = false
Instance.new("UICorner", mine).CornerRadius = UDim.new(1, 0)
local mineStroke = Instance.new("UIStroke", mine)
mineStroke.Color = Color3.fromRGB(200, 0, 0)
applyRgbStrokeShift(mineStroke)

plus.Name = "plus"
plus.Parent = Frame
plus.BackgroundColor3 = Color3.fromRGB(22, 12, 14)
plus.Position = UDim2.new(1, -42, 0, 4)
plus.Size = UDim2.new(0, 36, 0, 24)
plus.Font = Enum.Font.GothamBold
plus.Text = "+"
plus.TextColor3 = Color3.fromRGB(255, 255, 255)
plus.TextSize = 14
plus.AutoButtonColor = false
Instance.new("UICorner", plus).CornerRadius = UDim.new(1, 0)
local plusStroke = Instance.new("UIStroke", plus)
plusStroke.Color = Color3.fromRGB(200, 0, 0)
applyRgbStrokeShift(plusStroke)

onof.Name = "onof"
onof.Parent = Frame
onof.BackgroundColor3 = Color3.fromRGB(25, 12, 14)
onof.Position = UDim2.new(0.5, -55, 0, 34)
onof.Size = UDim2.new(0, 110, 0, 26)
onof.Font = Enum.Font.GothamBold
onof.Text = "Fly: OFF"
onof.TextColor3 = Color3.fromRGB(255, 255, 255)
onof.TextSize = 11
onof.AutoButtonColor = false
Instance.new("UICorner", onof).CornerRadius = UDim.new(1, 0)
local onofStroke = Instance.new("UIStroke", onof)
onofStroke.Color = Color3.fromRGB(180, 0, 0)
applyRgbStrokeShift(onofStroke)

local function animateClick(element)
    local origSize = element.Size
    TweenService:Create(element, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(origSize.X.Scale, origSize.X.Offset * 0.88, origSize.Y.Scale, origSize.Y.Offset * 0.88) }):Play()
    task.delay(0.08, function()
        TweenService:Create(element, TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Size = origSize }):Play()
    end)
end

speeds = 1
local speaker = game:GetService("Players").LocalPlayer
local soundConnection = nil
nowe = false

local function toggleSwimSounds(mute)
	local char = speaker.Character
	if not char then return end
	
	if mute then
		if soundConnection then soundConnection:Disconnect() end
		for _, child in ipairs(char:GetDescendants()) do
			if child:IsA("Sound") and (child.Name:lower():find("swim") or child.Name:lower():find("water") or child.SoundId:find("12222225")) then
				child.Volume = 0
			end
		end
		soundConnection = char.DescendantAdded:Connect(function(child)
			if child:IsA("Sound") and (child.Name:lower():find("swim") or child.Name:lower():find("water") or child.SoundId:find("12222225")) then
				child.Volume = 0
			end
		end)
	else
		if soundConnection then
			soundConnection:Disconnect()
			soundConnection = nil
		end
		for _, child in ipairs(char:GetDescendants()) do
			if child:IsA("Sound") and (child.Name:lower():find("swim") or child.Name:lower():find("water") or child.SoundId:find("12222225")) then
				child.Volume = 0.5
			end
		end
	end
end

onof.MouseButton1Down:connect(function()
    animateClick(onof)
	if nowe == true then
		nowe = false
		onof.Text = "Fly: OFF"
		toggleSwimSounds(false)

		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,true)
		speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
	else 
		nowe = true
		onof.Text = "Fly: ON"
		toggleSwimSounds(true)

		for i = 1, speeds do
			spawn(function()
				local hb = game:GetService("RunService").Heartbeat	
				tpwalking = true
				local chr = game.Players.LocalPlayer.Character
				local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
				while tpwalking and hb:Wait() and chr and hum and hum.Parent do
					if hum.MoveDirection.Magnitude > 0 then
						chr:TranslateBy(hum.MoveDirection)
					end
				end
			end)
		end
		game.Players.LocalPlayer.Character.Animate.Disabled = true
		local Char = game.Players.LocalPlayer.Character
		local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")

		for i,v in next, Hum:GetPlayingAnimationTracks() do
			v:AdjustSpeed(0)
		end
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,false)
		speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
	end

	if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6 then
		local plr = game.Players.LocalPlayer
		local torso = plr.Character:FindFirstChild("Torso")
		if not torso then return end
		local flying = true
		local deb = true
		local ctrl = {f = 0, b = 0, l = 0, r = 0}
		local lastctrl = {f = 0, b = 0, l = 0, r = 0}
		local maxspeed = 50
		local speedVal = 0

		local bg = Instance.new("BodyGyro", torso)
		bg.P = 9e4
		bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		bg.cframe = torso.CFrame
		local bv = Instance.new("BodyVelocity", torso)
		bv.velocity = Vector3.new(0,0,0)
		bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
		if nowe == true then
			plr.Character.Humanoid.PlatformStand = true
		end
		while nowe == true or game:GetService("Players").LocalPlayer.Character.Humanoid.Health == 0 do
			game:GetService("RunService").RenderStepped:Wait()

			if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
				speedVal = speedVal+.5+(speedVal/maxspeed)
				if speedVal > maxspeed then
					speedVal = maxspeed
				end
			elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speedVal ~= 0 then
				speedVal = speedVal-1
				if speedVal < 0 then
					speedVal = 0
				end
			end
			if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
				bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speedVal
				lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
			elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speedVal ~= 0 then
				bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speedVal
			else
				bv.velocity = Vector3.new(0,0,0)
			end
			bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speedVal/maxspeed),0,0)
		end
		ctrl = {f = 0, b = 0, l = 0, r = 0}
		lastctrl = {f = 0, b = 0, l = 0, r = 0}
		speedVal = 0
		bg:Destroy()
		bv:Destroy()
		plr.Character.Humanoid.PlatformStand = false
		game.Players.LocalPlayer.Character.Animate.Disabled = false
		tpwalking = false
	else
		local plr = game.Players.LocalPlayer
		local UpperTorso = plr.Character.UpperTorso
		local flying = true
		local deb = true
		local ctrl = {f = 0, b = 0, l = 0, r = 0}
		local lastctrl = {f = 0, b = 0, l = 0, r = 0}
		local maxspeed = 50
		local speedVal = 0

		local bg = Instance.new("BodyGyro", UpperTorso)
		bg.P = 9e4
		bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		bg.cframe = UpperTorso.CFrame
		local bv = Instance.new("BodyVelocity", UpperTorso)
		bv.velocity = Vector3.new(0,0.1,0)
		bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
		if nowe == true then
			plr.Character.Humanoid.PlatformStand = true
		end
		while nowe == true or game:GetService("Players").LocalPlayer.Character.Humanoid.Health == 0 do
			wait()

			if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
				speedVal = speedVal+.5+(speedVal/maxspeed)
				if speedVal > maxspeed then
					speedVal = maxspeed
				end
			elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speedVal ~= 0 then
				speedVal = speedVal-1
				if speedVal < 0 then
					speedVal = 0
				end
			end
			if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
				bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speedVal
				lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
			elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speedVal ~= 0 then
				bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speedVal
			else
				bv.velocity = Vector3.new(0,0,0)
			end

			bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speedVal/maxspeed),0,0)
		end
		ctrl = {f = 0, b = 0, l = 0, r = 0}
		lastctrl = {f = 0, b = 0, l = 0, r = 0}
		speedVal = 0
		bg:Destroy()
		bv:Destroy()
		plr.Character.Humanoid.PlatformStand = false
		game.Players.LocalPlayer.Character.Animate.Disabled = false
		tpwalking = false
	end
end)

game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function(char)
	wait(0.7)
	game.Players.LocalPlayer.Character.Humanoid.PlatformStand = false
	game.Players.LocalPlayer.Character.Animate.Disabled = false
end)

plus.MouseButton1Down:connect(function()
    animateClick(plus)
    animateClick(speed)
	if speeds < 50 then
		speeds = speeds + 1
		speed.Text = tostring(speeds)
		if nowe == true then
			tpwalking = false
			for i = 1, speeds do
				spawn(function()
					local hb = game:GetService("RunService").Heartbeat	
					tpwalking = true
					local chr = game.Players.LocalPlayer.Character
					local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
					while tpwalking and hb:Wait() and chr and hum and hum.Parent do
						if hum.MoveDirection.Magnitude > 0 then
							chr:TranslateBy(hum.MoveDirection)
						end
					end
				end)
			end
		end
	end
end)

mine.MouseButton1Down:connect(function()
    animateClick(mine)
    animateClick(speed)
	if speeds > 1 then
		speeds = speeds - 1
		speed.Text = tostring(speeds)
		if nowe == true then
			tpwalking = false
			for i = 1, speeds do
				spawn(function()
					local hb = game:GetService("RunService").Heartbeat	
					tpwalking = true
					local chr = game.Players.LocalPlayer.Character
					local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
					while tpwalking and hb:Wait() and chr and hum and hum.Parent do
						if hum.MoveDirection.Magnitude > 0 then
							chr:TranslateBy(hum.MoveDirection)
						end
					end
				end)
			end
		end
	end
end)

updateFlyGuiVisibility = function()
    main.Enabled = (HubConfig.FlyEnabled and not isOpen)
end

FlyTrack.MouseButton1Click:Connect(function()
    HubConfig.FlyEnabled = not HubConfig.FlyEnabled
    UpdateSwitchVisuals(FlyKnob, FlyStroke, HubConfig.FlyEnabled)
    SaveConfig()
    updateFlyGuiVisibility()
end)

_G.HeadSize = 8

RunService.Heartbeat:Connect(function()
    if not HubConfig.HitboxEnabled then return end
    
    local isHoldingWeapon = false
    if Camera and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
        local camDist = (Camera.Focus.Position - Camera.CFrame.Position).Magnitude
        if camDist < 1.0 then isHoldingWeapon = true end
    end
    
    if not isHoldingWeapon then
        for _, v in ipairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character then
                pcall(function()
                    local head = v.Character:FindFirstChild("Head")
                    if head then
                        head.Size = Vector3.new(2, 1, 1)
                        head.Transparency = 0
                        head.CanCollide = true
                    end
                end)
        
