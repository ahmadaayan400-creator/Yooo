-- AAYAN V3 ⛩️ | Roblox Studio LocalScript
-- Place in StarterPlayer > StarterPlayerScripts.
-- Compact premium UI, animated 3-step setup, draggable window/toggle.
-- Uses only local character controls and one-click chat messages.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TextChatService = game:GetService("TextChatService")
local player = Players.LocalPlayer
local pg = player:WaitForChild("PlayerGui")

local old = pg:FindFirstChild("AAYAN_V3")
if old then old:Destroy() end

local C = {
    yellow = Color3.fromRGB(255, 230, 0),
    black = Color3.fromRGB(5, 5, 7),
    panel = Color3.fromRGB(15, 15, 17),
    white = Color3.fromRGB(240, 240, 244),
    muted = Color3.fromRGB(145, 149, 158)
}
local gui = Instance.new("ScreenGui")
gui.Name = "AAYAN_V3"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = pg

local function corner(o, n)
    local x = Instance.new("UICorner")
    x.CornerRadius = UDim.new(0, n)
    x.Parent = o
    return x
end
local function outline(o, color, thickness)
    local x = Instance.new("UIStroke")
    x.Color = color
    x.Thickness = thickness or 1
    x.Parent = o
    return x
end
local function tw(o, duration, props, style)
    local x = TweenService:Create(o, TweenInfo.new(duration, style or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
    x:Play()
    return x
end
local function drag(handle, target)
    local active, origin, initial
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            active, origin, initial = true, input.Position, target.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then active = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if active and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - origin
            target.Position = UDim2.new(initial.X.Scale, initial.X.Offset + d.X, initial.Y.Scale, initial.Y.Offset + d.Y)
        end
    end)
end
local function chatOnce(message)
    local channels = TextChatService:FindFirstChild("TextChannels")
    local ch = channels and (channels:FindFirstChild("RBXGeneral") or channels:GetChildren()[1])
    if ch and ch:IsA("TextChannel") then
        local ok, err = pcall(function() ch:SendAsync(message) end)
        if not ok then warn("AAYAN V3 chat failed: " .. tostring(err)) end
    else
        warn("No TextChatService channel available. Check this experience's chat settings.")
    end
end

-- Animated setup card
local card = Instance.new("Frame")
card.Name = "SetupCard"
card.AnchorPoint = Vector2.new(.5, .5)
card.Position = UDim2.fromScale(.5, .5)
card.Size = UDim2.fromOffset(300, 178)
card.BackgroundColor3 = C.black
card.BorderSizePixel = 0
card.Parent = gui
corner(card, 14)
outline(card, C.yellow, 2)

local topLine = Instance.new("Frame")
topLine.Size = UDim2.new(1, 0, 0, 4)
topLine.BackgroundColor3 = C.yellow
topLine.BorderSizePixel = 0
topLine.Parent = card
corner(topLine, 4)

local setupTitle = Instance.new("TextLabel")
setupTitle.BackgroundTransparency = 1
setupTitle.Position = UDim2.fromOffset(12, 14)
setupTitle.Size = UDim2.new(1, -24, 0, 30)
setupTitle.Text = "AAYAN V3 ⛩️"
setupTitle.TextColor3 = C.yellow
setupTitle.Font = Enum.Font.GothamBlack
setupTitle.TextSize = 21
setupTitle.Parent = card

local prompt = Instance.new("TextLabel")
prompt.BackgroundTransparency = 1
prompt.Position = UDim2.fromOffset(12, 48)
prompt.Size = UDim2.new(1, -24, 0, 23)
prompt.Text = "ENTER YOUR NAME"
prompt.TextColor3 = C.white
prompt.Font = Enum.Font.GothamBold
prompt.TextSize = 13
prompt.Parent = card

local entry = Instance.new("TextBox")
entry.Position = UDim2.fromOffset(14, 78)
entry.Size = UDim2.new(1, -28, 0, 37)
entry.BackgroundColor3 = C.panel
entry.BorderSizePixel = 0
entry.PlaceholderText = "Enter your name..."
entry.PlaceholderColor3 = C.muted
entry.Text = ""
entry.TextColor3 = C.white
entry.Font = Enum.Font.Gotham
entry.TextSize = 14
entry.ClearTextOnFocus = false
entry.Parent = card
corner(entry, 8)
outline(entry, Color3.fromRGB(76, 76, 80), 1)

local nextButton = Instance.new("TextButton")
nextButton.Position = UDim2.new(0, 14, 1, -45)
nextButton.Size = UDim2.new(1, -28, 0, 32)
nextButton.BackgroundColor3 = C.yellow
nextButton.BorderSizePixel = 0
nextButton.Text = "CONTINUE  →"
nextButton.TextColor3 = C.black
nextButton.Font = Enum.Font.GothamBold
nextButton.TextSize = 13
nextButton.Parent = card
corner(nextButton, 8)

-- Main window, styled after the reference image
local main = Instance.new("Frame")
main.Name = "Main"
main.AnchorPoint = Vector2.new(.5, .5)
main.Position = UDim2.fromScale(.5, .5)
main.Size = UDim2.fromOffset(760, 470)
main.BackgroundColor3 = C.black
main.BorderSizePixel = 0
main.Visible = false
main.ClipsDescendants = true
main.Parent = gui
corner(main, 14)
local mainBorder = outline(main, C.yellow, 2)

local uiScale = Instance.new("UIScale")
uiScale.Parent = main
local function fit()
    local cam = workspace.CurrentCamera
    local v = cam and cam.ViewportSize or Vector2.new(900, 600)
    uiScale.Scale = math.clamp(math.min(v.X / 790, v.Y / 500), .55, 1)
end
fit()
if workspace.CurrentCamera then workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fit) end

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 72)
header.BackgroundColor3 = Color3.fromRGB(9, 9, 11)
header.BorderSizePixel = 0
header.Parent = main

local logo = Instance.new("ImageLabel")
logo.BackgroundTransparency = 1
logo.Position = UDim2.fromOffset(14, 10)
logo.Size = UDim2.fromOffset(48, 48)
logo.Image = "rbxassetid://83877589941594"
logo.ScaleType = Enum.ScaleType.Fit
logo.Parent = header

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Position = UDim2.fromOffset(70, 9)
title.Size = UDim2.fromOffset(240, 30)
title.Text = "AAYAN V3"
title.TextColor3 = C.yellow
title.Font = Enum.Font.GothamBlack
title.TextSize = 25
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local sub = Instance.new("TextLabel")
sub.BackgroundTransparency = 1
sub.Position = UDim2.fromOffset(72, 38)
sub.Size = UDim2.fromOffset(260, 18)
sub.Text = "PREMIUM GAME PANEL  •  NEVER LOSE"
sub.TextColor3 = C.muted
sub.Font = Enum.Font.Gotham
sub.TextSize = 9
sub.TextXAlignment = Enum.TextXAlignment.Left
sub.Parent = header

local userTag = Instance.new("TextLabel")
userTag.BackgroundTransparency = 1
userTag.AnchorPoint = Vector2.new(1, 0)
userTag.Position = UDim2.new(1, -87, 0, 18)
userTag.Size = UDim2.fromOffset(220, 22)
userTag.Text = player.DisplayName .. "  @" .. player.Name
userTag.TextColor3 = C.white
userTag.Font = Enum.Font.GothamBold
userTag.TextSize = 11
userTag.TextXAlignment = Enum.TextXAlignment.Right
userTag.TextTruncate = Enum.TextTruncate.AtEnd
userTag.Parent = header

local function headerButton(text, x, width)
    local b = Instance.new("TextButton")
    b.AnchorPoint = Vector2.new(1, 0)
    b.Position = UDim2.new(1, x, 0, 13)
    b.Size = UDim2.fromOffset(width, 29)
    b.BackgroundColor3 = Color3.fromRGB(31, 31, 34)
    b.BorderSizePixel = 0
    b.Text = text
    b.TextColor3 = C.white
    b.Font = Enum.Font.GothamBold
    b.TextSize = 18
    b.Parent = header
    corner(b, 7)
    return b
end
local close = headerButton("×", -10, 30)
local minimize = headerButton("—", -47, 30)
drag(header, main)

local sidebar = Instance.new("ScrollingFrame")
sidebar.Position = UDim2.fromOffset(10, 82)
sidebar.Size = UDim2.new(0, 156, 1, -94)
sidebar.BackgroundColor3 = C.panel
sidebar.BorderSizePixel = 0
sidebar.ScrollBarThickness = 2
sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
sidebar.CanvasSize = UDim2.new()
sidebar.Parent = main
corner(sidebar, 10)
outline(sidebar, Color3.fromRGB(68, 62, 20), 1)
local sideLayout = Instance.new("UIListLayout")
sideLayout.Padding = UDim.new(0, 5)
sideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
sideLayout.Parent = sidebar
local sidePad = Instance.new("UIPadding")
sidePad.PaddingTop = UDim.new(0, 8)
sidePad.PaddingBottom = UDim.new(0, 8)
sidePad.Parent = sidebar

local body = Instance.new("Frame")
body.Position = UDim2.fromOffset(177, 82)
body.Size = UDim2.new(1, -188, 1, -94)
body.BackgroundTransparency = 1
body.Parent = main

local names = {"PANEL 💀","SPAMMER 🌀","OTHER ☣","SHIELD 🤖","VOIDOUT 🗿","DJ SYSTEM 🎶","BANGS 💥","ALPHA EMPIRE ⛩️","MINI GAMES 🎮","OWNER 🚩","NOTE 🔷","SPECIAL 💖"}
local pages, tabs, selected = {}, {}, nil

for i, name in ipairs(names) do
    local page = Instance.new("ScrollingFrame")
    page.Name = "Page" .. i
    page.Size = UDim2.fromScale(1, 1)
    page.BackgroundColor3 = C.panel
    page.BorderSizePixel = 0
    page.Visible = false
    page.ScrollBarThickness = 3
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.CanvasSize = UDim2.new()
    page.Parent = body
    corner(page, 10)
    outline(page, Color3.fromRGB(58, 55, 23), 1)
    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 10)
    pad.PaddingLeft = UDim.new(0, 10)
    pad.PaddingRight = UDim.new(0, 10)
    pad.PaddingBottom = UDim.new(0, 10)
    pad.Parent = page
    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 7)
    list.Parent = page
    pages[i] = page

    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -12, 0, 34)
    b.BackgroundColor3 = C.black
    b.BorderSizePixel = 0
    b.Text = name
    b.TextColor3 = C.white
    b.Font = Enum.Font.GothamSemibold
    b.TextSize = 11
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.Parent = sidebar
    corner(b, 7)
    outline(b, Color3.fromRGB(45, 45, 48), 1)
    local bp = Instance.new("UIPadding")
    bp.PaddingLeft = UDim.new(0, 9)
    bp.Parent = b
    tabs[i] = b
    b.Activated:Connect(function()
        if selected then
            pages[selected].Visible = false
            tabs[selected].BackgroundColor3 = C.black
            tabs[selected].TextColor3 = C.white
        end
        selected = i
        pages[i].Visible = true
        b.BackgroundColor3 = C.yellow
        b.TextColor3 = C.black
    end)
end

local function section(i, titleText, detail)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -2, 0, 45)
    f.BackgroundColor3 = Color3.fromRGB(24, 24, 26)
    f.BorderSizePixel = 0
    f.Parent = pages[i]
    corner(f, 8)
    local bar = Instance.new("Frame")
    bar.Position = UDim2.fromOffset(7, 6)
    bar.Size = UDim2.new(0, 3, 1, -12)
    bar.BackgroundColor3 = C.yellow
    bar.BorderSizePixel = 0
    bar.Parent = f
    corner(bar, 2)
    local t = Instance.new("TextLabel")
    t.BackgroundTransparency = 1
    t.Position = UDim2.fromOffset(17, 4)
    t.Size = UDim2.new(1, -23, 0, 20)
    t.Text = titleText
    t.TextColor3 = C.yellow
    t.Font = Enum.Font.GothamBold
    t.TextSize = 13
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.Parent = f
    local d = Instance.new("TextLabel")
    d.BackgroundTransparency = 1
    d.Position = UDim2.fromOffset(17, 23)
    d.Size = UDim2.new(1, -23, 0, 15)
    d.Text = detail or ""
    d.TextColor3 = C.muted
    d.Font = Enum.Font.Gotham
    d.TextSize = 10
    d.TextXAlignment = Enum.TextXAlignment.Left
    d.Parent = f
end

local function button(i, label, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -2, 0, 34)
    b.BackgroundColor3 = Color3.fromRGB(22, 22, 24)
    b.BorderSizePixel = 0
    b.Text = label
    b.TextColor3 = C.white
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 12
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.Parent = pages[i]
    corner(b, 7)
    outline(b, Color3.fromRGB(57, 57, 60), 1)
    local p = Instance.new("UIPadding")
    p.PaddingLeft = UDim.new(0, 10)
    p.Parent = b
    b.Activated:Connect(function() if callback then callback(b) end end)
    return b
end

local function toggle(i, label, default, callback)
    local on = default or false
    local b = button(i, label, nil)
    local track = Instance.new("Frame")
    track.AnchorPoint = Vector2.new(1, .5)
    track.Position = UDim2.new(1, -8, .5, 0)
    track.Size = UDim2.fromOffset(34, 18)
    track.BackgroundColor3 = on and C.yellow or Color3.fromRGB(65, 68, 75)
    track.Parent = b
    corner(track, 9)
    local dot = Instance.new("Frame")
    dot.Size = UDim2.fromOffset(12, 12)
    dot.Position = on and UDim2.new(1, -15, .5, -6) or UDim2.new(0, 3, .5, -6)
    dot.BackgroundColor3 = on and C.black or C.white
    dot.Parent = track
    corner(dot, 6)
    local function refresh()
        tw(track, .12, {BackgroundColor3 = on and C.yellow or Color3.fromRGB(65, 68, 75)})
        tw(dot, .12, {Position = on and UDim2.new(1, -15, .5, -6) or UDim2.new(0, 3, .5, -6)})
        dot.BackgroundColor3 = on and C.black or C.white
    end
    b.Activated:Connect(function()
        on = not on
        refresh()
        if callback then callback(on) end
    end)
    return function(value)
        on = value
        refresh()
        if callback then callback(on) end
    end
end

local function info(i, text, height)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -2, 0, height or 85)
    l.BackgroundColor3 = Color3.fromRGB(22, 22, 24)
    l.BorderSizePixel = 0
    l.Text = text
    l.TextColor3 = C.white
    l.Font = Enum.Font.Gotham
    l.TextSize = 12
    l.TextWrapped = true
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.TextYAlignment = Enum.TextYAlignment.Top
    l.Parent = pages[i]
    corner(l, 8)
    local p = Instance.new("UIPadding")
    p.PaddingTop = UDim.new(0, 9)
    p.PaddingLeft = UDim.new(0, 10)
    p.PaddingRight = UDim.new(0, 8)
    p.Parent = l
    return l
end

-- PANEL
section(1, "PLAYER OVERVIEW", "Your current character information")
local overview = info(1, "", 112)
task.spawn(function()
    while gui.Parent do
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        overview.Text = string.format("Display: %s\nUsername: @%s\nUserId: %d\nHealth: %s\nWalkSpeed: %s\nTime: %s",
            player.DisplayName, player.Name, player.UserId,
            hum and math.floor(hum.Health) or "Respawning",
            hum and tostring(hum.WalkSpeed) or "—", os.date("%H:%M:%S"))
        task.wait(1)
    end
end)
section(1, "LOCAL MOVEMENT", "Only local character controls")
local speedSet = toggle(1, "Speed Boost (local)", false, function(on)
    local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if h then h.WalkSpeed = on and 32 or 16 end
end)
local infJumpSet = toggle(1, "Infinite Jump (local)", false, function(on) _G.AAYANV3_INFJUMP = on end)
local spinSet = toggle(1, "Spin (local)", false, function(on) _G.AAYANV3_SPIN = on end)
button(1, "RESET MOVEMENT", function()
    _G.AAYANV3_INFJUMP, _G.AAYANV3_SPIN = false, false
    local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if h then h.WalkSpeed = 16 end
    speedSet(false); infJumpSet(false); spinSet(false)
end)

-- SPAMMER: one user-triggered message, not an automated spam loop
section(2, "CHAT MESSAGE", "One message per click; Roblox chat rules apply")
local messageBox = Instance.new("TextBox")
messageBox.Size = UDim2.new(1, -2, 0, 40)
messageBox.BackgroundColor3 = Color3.fromRGB(22, 22, 24)
messageBox.BorderSizePixel = 0
messageBox.PlaceholderText = "Type a message..."
messageBox.PlaceholderColor3 = C.muted
messageBox.Text = ""
messageBox.TextColor3 = C.white
messageBox.Font = Enum.Font.Gotham
messageBox.TextSize = 12
messageBox.ClearTextOnFocus = false
messageBox.Parent = pages[2]
corner(messageBox, 7); outline(messageBox, C.yellow, 1)
button(2, "SEND ONE MESSAGE", function()
    if messageBox.Text:gsub("%s+", "") ~= "" then chatOnce(messageBox.Text) end
end)
info(2, "Automatic repeated chat spam is not included. Send a single message manually.", 52)

section(3, "OTHER", "Local utilities")
button(3, "RESTORE CAMERA", function()
    local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if h and workspace.CurrentCamera then workspace.CurrentCamera.CameraSubject = h end
end)
button(3, "STOP LOCAL SPIN", function() _G.AAYANV3_SPIN = false; spinSet(false) end)
info(3, "External loadstring URLs are not run by this LocalScript. Review scripts and use supported Roblox Studio code.", 65)

section(4, "SHIELD", "Local safeguards")
local antiSitConnection
toggle(4, "Anti-Sit (local)", false, function(on)
    if antiSitConnection then antiSitConnection:Disconnect(); antiSitConnection = nil end
    if on then
        antiSitConnection = RunService.Heartbeat:Connect(function()
            local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            if h and h.Sit then h.Sit = false end
        end)
    end
end)
info(4, "Client-side code cannot grant server-side invulnerability or prevent every fling/void effect.", 60)

section(5, "VOIDOUT", "World settings depend on the game")
info(5, "Gravity and teleport permissions are usually server-owned. Add these features only in a game you own or where the developer authorizes them.", 85)
button(5, "ZERO LOCAL VELOCITY", function()
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if root then root.AssemblyLinearVelocity = Vector3.zero; root.AssemblyAngularVelocity = Vector3.zero end
end)

section(6, "DJ SYSTEM", "Audio you have permission to use")
local audioBox = Instance.new("TextBox")
audioBox.Size = UDim2.new(1, -2, 0, 36)
audioBox.BackgroundColor3 = Color3.fromRGB(22, 22, 24)
audioBox.BorderSizePixel = 0
audioBox.PlaceholderText = "Permitted audio asset ID"
audioBox.Text = ""
audioBox.TextColor3 = C.white
audioBox.Font = Enum.Font.Gotham
audioBox.TextSize = 12
audioBox.Parent = pages[6]
corner(audioBox, 7)
button(6, "PLAY AUDIO", function()
    local id = audioBox.Text:match("%d+")
    if not id then return end
    local sound = gui:FindFirstChild("AAYANV3Music") or Instance.new("Sound")
    sound.Name = "AAYANV3Music"; sound.SoundId = "rbxassetid://" .. id
    sound.Volume = .5; sound.Parent = gui; sound:Play()
end)
button(6, "STOP AUDIO", function()
    local sound = gui:FindFirstChild("AAYANV3Music")
    if sound then sound:Stop() end
end)

section(7, "BANGS", "Emote area")
info(7, "Use animation assets you own or have permission to use. Forced actions against other players are not included.", 70)
button(7, "ANIMATION SETUP NOTE", function() warn("Set up a permitted animation asset in your own experience.") end)

section(8, "ALPHA EMPIRE", "Community panel")
info(8, "AAYAN V3 ⛩️\nPremium compact interface\nCommunity details can be added here.", 75)
button(8, "COMMUNITY INFO", function() warn("Add your official community details here.") end)

section(9, "MINI GAMES", "Quick number game")
local rollInfo = info(9, "Tap below to roll a number from 1 to 6.", 55)
button(9, "ROLL DICE 🎲", function() rollInfo.Text = "🎮 You rolled: " .. math.random(1, 6) .. "\nTap again to play another round." end)

section(10, "OWNER", "Project information")
info(10, "SCRIPT OWNER: AAYAN\nPROJECT: AAYAN V3 ⛩️\nUse only in experiences where you have permission.", 80)

section(11, "NOTE", "Setup")
info(11, "Install as a LocalScript in StarterPlayerScripts. Server-side actions require authorized server code. Normal Roblox Studio LocalScripts do not support arbitrary loadstring/game:HttpGet execution.", 95)

section(12, "SPECIAL", "Personalization")
toggle(12, "Yellow Border", true, function(on)
    mainBorder.Color = on and C.yellow or Color3.fromRGB(70, 70, 75)
end)
toggle(12, "Header Tagline", true, function(on) sub.Visible = on end)
button(12, "CENTER GUI", function() main.Position = UDim2.fromScale(.5, .5) end)

-- Footer stats
local footer = Instance.new("TextLabel")
footer.BackgroundTransparency = 1
footer.AnchorPoint = Vector2.new(0, 1)
footer.Position = UDim2.new(0, 12, 1, -3)
footer.Size = UDim2.new(1, -24, 0, 15)
footer.TextColor3 = C.muted
footer.Font = Enum.Font.Gotham
footer.TextSize = 9
footer.TextXAlignment = Enum.TextXAlignment.Left
footer.Parent = main
local frames, stamp, fps = 0, os.clock(), 0
RunService.RenderStepped:Connect(function()
    frames += 1
    local now = os.clock()
    if now - stamp >= 1 then
        fps, frames, stamp = frames, 0, now
        footer.Text = string.format("● ROBLOX  |  FPS: %d  |  %s", fps, os.date("%H:%M:%S"))
    end
    if _G.AAYANV3_SPIN then
        local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if root then root.AssemblyAngularVelocity = Vector3.new(0, 8, 0) end
    end
end)
UserInputService.JumpRequest:Connect(function()
    if _G.AAYANV3_INFJUMP then
        local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)
player.CharacterAdded:Connect(function(char)
    task.wait(.4)
    local h = char:FindFirstChildOfClass("Humanoid")
    if h then h.WalkSpeed = 16 end
end)

-- Floating image toggle, draggable
local toggle = Instance.new("ImageButton")
toggle.Name = "AAYAN_V3_Toggle"
toggle.Size = UDim2.fromOffset(50, 50)
toggle.Position = UDim2.new(0, 16, .5, -25)
toggle.BackgroundColor3 = C.black
toggle.BorderSizePixel = 0
toggle.Image = "rbxassetid://5077756676"
toggle.ScaleType = Enum.ScaleType.Fit
toggle.AutoButtonColor = false
toggle.Parent = gui
corner(toggle, 13)
local toggleStroke = outline(toggle, C.yellow, 2)
drag(toggle, toggle)
toggle.Activated:Connect(function()
    main.Visible = not main.Visible
    if main.Visible then
        main.Size = UDim2.fromOffset(700, 430)
        tw(main, .22, {Size = UDim2.fromOffset(760, 470)}, Enum.EasingStyle.Back)
    end
end)
minimize.Activated:Connect(function() main.Visible = false end)
close.Activated:Connect(function() main.Visible = false end)
task.spawn(function()
    local hue = 0
    while gui.Parent do
        hue = (hue + .006) % 1
        toggleStroke.Color = Color3.fromHSV(hue, .9, 1)
        task.wait(.03)
    end
end)

-- Three-step animated setup flow
local steps = {
    {prompt = "ENTER YOUR NAME", placeholder = "Enter your name...", key = "name"},
    {prompt = "ENTER YOUR GANG NAME", placeholder = "Enter your gang name...", key = "gang"},
    {prompt = "ENTER YOUR SON NAME", placeholder = "Enter your son name...", key = "son"}
}
local data, step, busy = {}, 1, false
local function showStep(i)
    step = i
    prompt.Text = steps[i].prompt
    entry.PlaceholderText = steps[i].placeholder
    entry.Text = ""
    card.Position = UDim2.fromScale(.5, .56)
    card.BackgroundTransparency = 1
    tw(card, .23, {Position = UDim2.fromScale(.5, .5), BackgroundTransparency = 0})
end
nextButton.Activated:Connect(function()
    if busy then return end
    local value = entry.Text:gsub("^%s+", ""):gsub("%s+$", "")
    if value == "" then
        tw(entry, .08, {BackgroundColor3 = Color3.fromRGB(75, 22, 22)})
        task.wait(.12)
        tw(entry, .15, {BackgroundColor3 = C.panel})
        return
    end
    busy = true
    data[steps[step].key] = value
    tw(card, .18, {Position = UDim2.fromScale(.5, .42), BackgroundTransparency = 1})
    task.wait(.2)
    if step < #steps then
        showStep(step + 1)
        busy = false
    else
        card:Destroy()
        main.Visible = true
        main.Size = UDim2.fromOffset(690, 420)
        tw(main, .3, {Size = UDim2.fromOffset(760, 470)}, Enum.EasingStyle.Back)
        chatOnce("SCRIPT BY " .. data.name .. " 💀💥 ______________________ \"" .. data.son .. "\" __________________________________ V3 LOADED..")
        task.wait(1.2)
        chatOnce(data.gang .. " ON TOP 😱👽 SABKA BAP " .. data.gang .. " 💀 TARGET NAME AB KYA KAREGA 😎 TERA BAP AGYA __________ V3 LOADED")
        busy = false
    end
end)
showStep(1)
