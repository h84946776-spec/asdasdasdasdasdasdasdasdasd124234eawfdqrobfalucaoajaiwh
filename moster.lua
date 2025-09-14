-- LocalScript: StipiFHub (v3 - Premium)
-- Pegar como LocalScript en StarterPlayerScripts

-- Check if GUI already exists and destroy it
local existingGui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("StipiFHub")
if existingGui then
    existingGui:Destroy()
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer

-- Wait for player to load
if not player.Character then
    player.CharacterAdded:Wait()
end

-- State variables
local isFlying = false
local flyConnection = nil
local noclipEnabled = false
local noclipConnection = nil
local espEnabled = false
local espConnections = {}
local speedEnabled = false
local jumpEnabled = false
local godModeEnabled = false
local noFallDamageEnabled = false
local clickTPConnection = nil
local walkSpeedSlider = nil

-- Default values
local defaultWalkSpeed = player.Character.Humanoid.WalkSpeed
local defaultJumpPower = player.Character.Humanoid.JumpPower
local defaultGravity = Workspace.Gravity

-- Notification function
local function notify(msg)
    pcall(function()
        game.StarterGui:SetCore("SendNotification", {
            Title = "Stipi F Hub",
            Text = msg,
            Duration = 3
        })
    end)
end

-- Utility Functions
local function getCharacter()
    return player.Character or player.CharacterAdded:Wait()
end

local function getHumanoid()
    local char = getCharacter()
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function getHRP()
    local char = getCharacter()
    return char and char:FindFirstChild("HumanoidRootPart")
end

-- Core Functionality
local function enableFly()
    local char = getCharacter()
    local hrp = getHRP()
    local humanoid = getHumanoid()
    if not char or not hrp or not humanoid then return end

    humanoid.PlatformStand = true
    isFlying = true

    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = hrp

    flyConnection = RunService.RenderStepped:Connect(function()
        local camera = Workspace.CurrentCamera
        local velocity = Vector3.new(0, 0, 0)
        local flySpeed = 50 -- default speed

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            velocity = velocity + (camera.CFrame.LookVector * flySpeed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            velocity = velocity - (camera.CFrame.LookVector * flySpeed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            velocity = velocity - (camera.CFrame.RightVector * flySpeed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            velocity = velocity + (camera.CFrame.RightVector * flySpeed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            velocity = velocity + Vector3.new(0, flySpeed, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            velocity = velocity - Vector3.new(0, flySpeed, 0)
        end
        
        bodyVelocity.Velocity = velocity
    end)
    notify("✈️ Fly activado!")
end

local function disableFly()
    isFlying = false
    if flyConnection then flyConnection:Disconnect() end
    local hrp = getHRP()
    if hrp then
        local bodyVelocity = hrp:FindFirstChildOfClass("BodyVelocity")
        if bodyVelocity then bodyVelocity:Destroy() end
    end
    local humanoid = getHumanoid()
    if humanoid then humanoid.PlatformStand = false end
    notify("🛬 Fly desactivado!")
end

local function enableNoclip()
    noclipEnabled = true
    noclipConnection = RunService.Heartbeat:Connect(function()
        local char = getCharacter()
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    pcall(function() part.CanCollide = false end)
                end
            end
        end
    end)
    notify("👻 Noclip activado!")
end

local function disableNoclip()
    noclipEnabled = false
    if noclipConnection then noclipConnection:Disconnect() end
    local char = getCharacter()
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                pcall(function() part.CanCollide = true end)
            end
        end
    end
    notify("👻 Noclip desactivado!")
end

local function enableESP()
    espEnabled = true
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player then
            local function addESP(character)
                local hrp = character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "StipiFESP"
                    highlight.Adornee = character
                    highlight.FillColor = Color3.fromRGB(255, 100, 100)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.5
                    highlight.OutlineTransparency = 0
                    highlight.Parent = character
                    
                    local billboard = Instance.new("BillboardGui")
                    billboard.Name = "StipiFNameTag"
                    billboard.Size = UDim2.new(0, 200, 0, 50)
                    billboard.StudsOffset = Vector3.new(0, 3, 0)
                    billboard.Parent = hrp
                    
                    local nameLabel = Instance.new("TextLabel")
                    nameLabel.Size = UDim2.new(1, 0, 1, 0)
                    nameLabel.BackgroundTransparency = 1
                    nameLabel.Text = otherPlayer.Name
                    nameLabel.Font = Enum.Font.GothamBold
                    nameLabel.TextColor3 = Color3.new(1, 1, 1)
                    nameLabel.TextStrokeTransparency = 0
                    nameLabel.TextScaled = true
                    nameLabel.Parent = billboard
                end
            end
            
            if otherPlayer.Character then
                addESP(otherPlayer.Character)
            end
            
            espConnections[otherPlayer] = otherPlayer.CharacterAdded:Connect(addESP)
        end
    end
    notify("👁️ ESP activado!")
end

local function disableESP()
    espEnabled = false
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer.Character then
            local highlight = otherPlayer.Character:FindFirstChild("StipiFESP")
            if highlight then highlight:Destroy() end
        end
        if espConnections[otherPlayer] then
            espConnections[otherPlayer]:Disconnect()
            espConnections[otherPlayer] = nil
        end
    end
    notify("👁️ ESP desactivado!")
end

local function enableClickTP()
    clickTPConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            local ray = Workspace.CurrentCamera:ScreenPointToRay(input.Position.X, input.Position.Y)
            local raycastResult = Workspace:Raycast(ray.Origin, ray.Direction * 1000)
            if raycastResult then
                local hrp = getHRP()
                if hrp then
                    hrp.CFrame = CFrame.new(raycastResult.Position)
                    notify("🖱️ Teleport successful!")
                end
            end
        end
    end)
    notify("🖱️ Click TP activado!")
end

local function disableClickTP()
    if clickTPConnection then clickTPConnection:Disconnect() end
    notify("🖱️ Click TP desactivado!")
end

-- GUI Elements
local gui = Instance.new("ScreenGui")
gui.Name = "StipiFHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local backgroundFrame = Instance.new("Frame")
backgroundFrame.Size = UDim2.new(0, 400, 0, 500)
backgroundFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
backgroundFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
backgroundFrame.BorderSizePixel = 0
backgroundFrame.Active = true
backgroundFrame.Draggable = true
backgroundFrame.Parent = gui
Instance.new("UICorner", backgroundFrame).CornerRadius = UDim.new(0, 15)

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 50)
header.BackgroundColor3 = Color3.fromRGB(36, 36, 42)
header.Parent = backgroundFrame
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 15)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "🌟 Stipi F Hub"
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Parent = header

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -40, 0.5, -15)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.BorderSizePixel = 0
closeButton.Text = "✕"
closeButton.Font = Enum.Font.GothamBold
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 16
closeButton.Parent = header
Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0, 15)

closeButton.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

local tabButtons = Instance.new("Frame")
tabButtons.Size = UDim2.new(1, 0, 0, 30)
tabButtons.Position = UDim2.new(0, 0, 0, 50)
tabButtons.BackgroundTransparency = 1
tabButtons.Parent = backgroundFrame
local tabList = Instance.new("UIListLayout", tabButtons)
tabList.FillDirection = Enum.FillDirection.Horizontal
tabList.Padding = UDim.new(0, 5)
tabList.SortOrder = Enum.SortOrder.LayoutOrder
Instance.new("UIPadding", tabButtons).PaddingLeft = UDim.new(0, 10)

local pages = Instance.new("Frame")
pages.Size = UDim2.new(1, -20, 1, -90)
pages.Position = UDim2.new(0, 10, 0, 80)
pages.BackgroundTransparency = 1
pages.Parent = backgroundFrame

local function createPage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Parent = pages
    page.Visible = false
    page.ScrollBarThickness = 6
    Instance.new("UIListLayout", page).Padding = UDim.new(0, 8)
    return page
end

local function createTabButton(name, page)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 80, 1, 0)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(36, 36, 42)
    btn.BorderSizePixel = 0
    btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = tabButtons
    
    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(pages:GetChildren()) do p.Visible = false end
        page.Visible = true
        for _, b in pairs(tabButtons:GetChildren()) do
            if b:IsA("TextButton") then b.TextColor3 = Color3.fromRGB(150, 150, 150) end
        end
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    return btn
end

local function createToggleButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    btn.Text = text .. ": OFF"
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.TextColor3 = Color3.fromRGB(240, 240, 240)
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        callback(enabled)
        btn.Text = text .. (enabled and ": ON" or ": OFF")
        btn.BackgroundColor3 = enabled and Color3.fromRGB(70, 150, 255) or Color3.fromRGB(45, 45, 50)
    end)
end

local function createSlider(parent, text, min, max, initial, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 45)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 15)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. initial
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextColor3 = Color3.new(1,1,1)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(1, -20, 0, 10)
    slider.Position = UDim2.new(0, 10, 0, 25)
    slider.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
    slider.BorderSizePixel = 0
    slider.Parent = frame
    Instance.new("UICorner", slider).CornerRadius = UDim.new(0, 5)

    local valueBar = Instance.new("Frame")
    valueBar.Size = UDim2.new(0, 0, 1, 0)
    valueBar.BackgroundColor3 = Color3.fromRGB(70, 150, 255)
    valueBar.BorderSizePixel = 0
    valueBar.Parent = slider
    Instance.new("UICorner", valueBar).CornerRadius = UDim.new(0, 5)

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 15, 0, 15)
    button.BackgroundColor3 = Color3.fromRGB(70, 150, 255)
    button.BorderSizePixel = 0
    button.Text = ""
    button.Position = UDim2.new(0, 0, 0.5, -7.5)
    button.Parent = slider
    Instance.new("UICorner", button).CornerRadius = UDim.new(1, 0)
    
    local dragging = false
    local function updateSlider(x)
        local pos = math.clamp(x, 0, slider.AbsoluteSize.X)
        local value = min + (pos / slider.AbsoluteSize.X) * (max - min)
        value = math.floor(value + 0.5)
        
        button.Position = UDim2.new(0, pos, 0.5, -7.5)
        valueBar.Size = UDim2.new(0, pos, 1, 0)
        label.Text = text .. ": " .. value
        callback(value)
    end
    
    button.MouseButton1Down:Connect(function()
        dragging = true
        UserInputService.MouseMoved:Connect(function(input)
            if not dragging then return end
            local pos = input.Position.X - slider.AbsolutePosition.X
            updateSlider(pos)
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
    end)
    
    updateSlider((initial - min) / (max - min) * slider.AbsoluteSize.X)
    return button
end

-- Create Pages
local movementPage = createPage("Movement")
local visualsPage = createPage("Visuals")
local playerPage = createPage("Player")

createTabButton("Movement", movementPage)
createTabButton("Visuals", visualsPage)
createTabButton("Player", playerPage)
createTabButton("Misc", otherPage)

-- Movement Page
createToggleButton(movementPage, "Fly", function(on)
    if on then enableFly() else disableFly() end
end)
createToggleButton(movementPage, "Noclip", function(on)
    if on then enableNoclip() else disableNoclip() end
end)
createToggleButton(movementPage, "Infinite Jump", function(on)
    if on then getHumanoid().JumpPower = 0 else getHumanoid().JumpPower = defaultJumpPower end
end)
createSlider(movementPage, "WalkSpeed", 16, 200, 16, function(val)
    getHumanoid().WalkSpeed = val
end)
createToggleButton(movementPage, "Click Teleport", function(on)
    if on then enableClickTP() else disableClickTP() end
end)
createToggleButton(movementPage, "Gravity", function(on)
    if on then Workspace.Gravity = 25 else Workspace.Gravity = defaultGravity end
end)
createToggleButton(movementPage, "No Fall Damage", function(on)
    if on then getHumanoid().BreakJointsOnDeath = false else getHumanoid().BreakJointsOnDeath = true end
end)

-- Visuals Page
createToggleButton(visualsPage, "ESP", function(on)
    if on then enableESP() else disableESP() end
end)
createToggleButton(visualsPage, "Fullbright", function(on)
    if on then Workspace.Lighting.Ambient = Color3.new(1, 1, 1) else Workspace.Lighting.Ambient = Color3.new(0, 0, 0) end
end)
createToggleButton(visualsPage, "No Fog", function(on)
    if on then Workspace.FogEnd = 9e9 else Workspace.FogEnd = 0 end
end)
createToggleButton(visualsPage, "Rainbow Trail", function(on)
    local char = getCharacter()
    if not char then return end
    local trail = char:FindFirstChild("StipiFTrail")
    if on then
        if not trail then
            local att0 = Instance.new("Attachment", char.HumanoidRootPart)
            local att1 = Instance.new("Attachment", char.HumanoidRootPart)
            att0.Position = Vector3.new(0, 2, 0)
            att1.Position = Vector3.new(0, -2, 0)
            local newTrail = Instance.new("Trail")
            newTrail.Name = "StipiFTrail"
            newTrail.Attachment0 = att0
            newTrail.Attachment1 = att1
            newTrail.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 165, 0)),
                ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 255, 0)),
                ColorSequenceKeypoint.new(0.6, Color3.fromRGB(0, 255, 0)),
                ColorSequenceKeypoint.new(0.8, Color3.fromRGB(0, 0, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(128, 0, 128))
            }
            newTrail.Lifetime = 2
            newTrail.Parent = char
        end
    else
        if trail then trail:Destroy() end
    end
end)

-- Player Page
createToggleButton(playerPage, "God Mode", function(on)
    godModeEnabled = on
end)
player.CharacterAdded:Connect(function()
    local humanoid = getHumanoid()
    if godModeEnabled then humanoid.MaxHealth = 9e9; humanoid.Health = humanoid.MaxHealth end
end)

createToggleButton(playerPage, "Kill All", function()
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player then
            local char = otherPlayer.Character
            if char and char:FindFirstChildOfClass("Humanoid") then
                char.Humanoid.Health = 0
            end
        end
    end
end)
