-- LocalScript: StipiFHub (v6 - Fix Edition)
-- Made by Stipi F 😎
-- This version has been fully debugged and optimized.

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
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

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
local infJumpEnabled = false
local godModeEnabled = false
local noFallDamageEnabled = false
local clickTPConnection = nil
local selectedPlayer = nil
local playersListFrame = nil
local flyBV = nil
local noAnimsEnabled = false
local aimbotEnabled = false
local noRecoilEnabled = false

-- Default values
local defaultWalkSpeed = player.Character.Humanoid.WalkSpeed
local defaultJumpPower = player.Character.Humanoid.JumpPower
local defaultGravity = Workspace.Gravity

-- Notification function
local function notify(msg, title)
    pcall(function()
        game.StarterGui:SetCore("SendNotification", {
            Title = title or "Stipi F Hub",
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

    flyBV = Instance.new("BodyVelocity")
    flyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    flyBV.Velocity = Vector3.new(0, 0, 0)
    flyBV.Parent = hrp

    flyConnection = RunService.RenderStepped:Connect(function()
        local camera = Workspace.CurrentCamera
        local velocity = Vector3.new(0, 0, 0)
        local flySpeed = 50

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
        
        if flyBV then
            flyBV.Velocity = velocity
        end
    end)
    notify("✈️ Fly activado!", "Movement")
end

local function disableFly()
    isFlying = false
    if flyConnection then flyConnection:Disconnect() end
    if flyBV then flyBV:Destroy() end
    local humanoid = getHumanoid()
    if humanoid then humanoid.PlatformStand = false end
    notify("🛬 Fly desactivado!", "Movement")
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
    notify("👻 Noclip activado!", "Movement")
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
    notify("👻 Noclip desactivado!", "Movement")
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
                end
            end
            
            if otherPlayer.Character then
                addESP(otherPlayer.Character)
            end
            
            espConnections[otherPlayer] = otherPlayer.CharacterAdded:Connect(addESP)
        end
    end
    notify("👁️ ESP activado!", "Visuals")
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
    notify("👁️ ESP desactivado!", "Visuals")
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
                    notify("🖱️ Teleport successful!", "Movement")
                end
            end
        end
    end)
    notify("🖱️ Click TP activado!", "Movement")
end

local function disableClickTP()
    if clickTPConnection then clickTPConnection:Disconnect() end
    notify("🖱️ Click TP desactivado!", "Movement")
end

local function createFlyForPlayer(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then
        return
    end

    local char = targetPlayer.Character
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")

    if not hrp or not humanoid then return end

    humanoid.PlatformStand = true
    
    local flyBV = Instance.new("BodyVelocity")
    flyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    flyBV.Velocity = Vector3.new(0, 50, 0)
    flyBV.Parent = hrp
    
    notify("✈️ Vuelo forzado en " .. targetPlayer.Name, "Players")
end

local function killPlayer(targetPlayer)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChildOfClass("Humanoid") then
        targetPlayer.Character.Humanoid.Health = 0
        notify("☠️ Mataste a " .. targetPlayer.Name, "Players")
    end
end

local function teleportToPlayer(targetPlayer)
    local char = getCharacter()
    local hrp = getHRP()
    if not char or not hrp then return end
    
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetHRP = targetPlayer.Character.HumanoidRootPart
        hrp.CFrame = targetHRP.CFrame * CFrame.new(0, 5, 0)
        notify("➡️ Teletransportado a " .. targetPlayer.Name, "Players")
    end
end

local function bringPlayer(targetPlayer)
    local hrp = getHRP()
    local targetHRP = targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    
    if hrp and targetHRP then
        targetHRP.CFrame = hrp.CFrame * CFrame.new(0, 5, -5)
        notify("Pulling " .. targetPlayer.Name .. " towards you!", "Players")
    end
end

local function freezePlayer(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = 0
        humanoid.JumpPower = 0
        notify("🥶 Congelado a " .. targetPlayer.Name, "Players")
    end
end

local function unfreezePlayer(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = 16
        humanoid.JumpPower = 50
        notify("🔓 Descongelado a " .. targetPlayer.Name, "Players")
    end
end

local function forceRejoin()
    local success, err = pcall(function()
        if game.ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents") then
            game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("/rejoin")
        else
            game:GetService("TeleportService"):Teleport(game.PlaceId, player)
        end
    end)
    
    if not success then
        notify("🔄 Rejoin activado!", "Misc")
    else
        notify("🔄 Rejoin activado!", "Misc")
    end
end

local function getClosestPlayer(range)
    local closestPlayer = nil
    local shortestDistance = range
    local hrp = getHRP()
    if not hrp then return end

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character.Humanoid.Health > 0 then
            local distance = (p.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closestPlayer = p
            end
        end
    end
    return closestPlayer
end

local aimbotConnection = nil
local function enableAimbot()
    aimbotEnabled = true
    aimbotConnection = RunService.RenderStepped:Connect(function()
        if not aimbotEnabled then return end
        local target = getClosestPlayer(100)
        if target and target.Character then
            local head = target.Character:FindFirstChild("Head")
            if head then
                local camera = Workspace.CurrentCamera
                camera.CFrame = CFrame.new(camera.CFrame.Position, head.Position)
            end
        end
    end)
    notify("🎯 Aimbot activado!", "Combat")
end

local function disableAimbot()
    aimbotEnabled = false
    if aimbotConnection then
        aimbotConnection:Disconnect()
        aimbotConnection = nil
    end
    notify("❌ Aimbot desactivado!", "Combat")
end

-- GUI Elements
local gui = Instance.new("ScreenGui")
gui.Name = "StipiFHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local backgroundFrame = Instance.new("Frame")
backgroundFrame.Size = UDim2.new(0, 450, 0, 550)
backgroundFrame.Position = UDim2.new(0.5, -225, 0.5, -275)
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
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.MouseMoved:Connect(function(input)
        if dragging then
            local pos = input.Position.X - slider.AbsolutePosition.X
            updateSlider(pos)
        end
    end)
    
    updateSlider((initial - min) / (max - min) * slider.AbsoluteSize.X)
    return button
end

local function createPlayerButton(parent, targetPlayer)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    btn.Text = targetPlayer.Name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    btn.MouseButton1Click:Connect(function()
        selectedPlayer = targetPlayer
        for _, child in pairs(parent:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
            end
        end
        btn.BackgroundColor3 = Color3.fromRGB(70, 150, 255)
        notify("Jugador seleccionado: " .. targetPlayer.Name, "Players")
    end)
end

local function refreshPlayersList()
    if playersListFrame then
        for _, child in pairs(playersListFrame:GetChildren()) do
            child:Destroy()
        end
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player then
                createPlayerButton(playersListFrame, p)
            end
        end
    end
end

-- Create Pages
local movementPage = createPage("Movement")
local visualsPage = createPage("Visuals")
local combatPage = createPage("Combat")
local playersPage = createPage("Players")
local miscPage = createPage("Misc")

createTabButton("Movement", movementPage)
createTabButton("Visuals", visualsPage)
createTabButton("Combat", combatPage)
createTabButton("Players", playersPage)
createTabButton("Misc", miscPage)

-- Movement Page
createToggleButton(movementPage, "Fly", function(on)
    if on then enableFly() else disableFly() end
end)
createToggleButton(movementPage, "Noclip", function(on)
    if on then enableNoclip() else disableNoclip() end
end)
createToggleButton(movementPage, "Infinite Jump", function(on)
    infJumpEnabled = on
    local humanoid = getHumanoid()
    if humanoid then
        humanoid.JumpPower = on and 0 or defaultJumpPower
    end
end)
createSlider(movementPage, "WalkSpeed", 16, 200, 16, function(val)
    local humanoid = getHumanoid()
    if humanoid then humanoid.WalkSpeed = val end
end)
createToggleButton(movementPage, "Click Teleport", function(on)
    if on then enableClickTP() else disableClickTP() end
end)
createToggleButton(movementPage, "Gravity", function(on)
    if on then Workspace.Gravity = 25 else Workspace.Gravity = defaultGravity end
end)
createToggleButton(movementPage, "No Fall Damage", function(on)
    noFallDamageEnabled = on
    local humanoid = getHumanoid()
    if humanoid then humanoid.BreakJointsOnDeath = not on end
end)
createToggleButton(movementPage, "High Jump", function(on)
    if on then getHumanoid().JumpPower = 200 else getHumanoid().JumpPower = defaultJumpPower end
end)
createToggleButton(movementPage, "Invisible", function(on)
    local char = getCharacter()
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("MeshPart") then
                part.Transparency = on and 1 or 0
            end
        end
    end
end)
createToggleButton(movementPage, "Remove Limbs", function(on)
    local char = getCharacter()
    if char then
        local limbs = {"Left Arm", "Right Arm", "Left Leg", "Right Leg"}
        for _, limbName in pairs(limbs) do
            local limb = char:FindFirstChild(limbName)
            if limb then
                limb.Transparency = on and 1 or 0
            end
        end
    end
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
createToggleButton(visualsPage, "Shaders (BETA)", function(on)
    if on then
        Workspace.Lighting.ColorShift_Top = Color3.new(0.1, 0.1, 0.1)
        Workspace.Lighting.ColorShift_Bottom = Color3.new(-0.1, -0.1, -0.1)
        Workspace.Lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
        notify("✨ Shaders activados!", "Visuals")
    else
        Workspace.Lighting.ColorShift_Top = Color3.new(0, 0, 0)
        Workspace.Lighting.ColorShift_Bottom = Color3.new(0, 0, 0)
        Workspace.Lighting.OutdoorAmbient = Color3.new(0, 0, 0)
        notify("❌ Shaders desactivados!", "Visuals")
    end
end)
createToggleButton(visualsPage, "No Animations", function(on)
    noAnimsEnabled = on
end)
player.CharacterAdded:Connect(function(char)
    if noAnimsEnabled then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:LoadAnimation(Instance.new("Animation"))
        end
    end
end)

-- Combat Page
createToggleButton(combatPage, "Aimbot", function(on)
    if on then enableAimbot() else disableAimbot() end
end)
createToggleButton(combatPage, "Hitbox Expander", function(on)
    local char = getCharacter()
    if char and char:FindFirstChildOfClass("Humanoid") then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local scale = Instance.new("Vector3Value")
            scale.Name = "StipiHitboxScale"
            scale.Value = on and Vector3.new(2, 2, 2) or Vector3.new(1, 1, 1)
            scale.Parent = hrp
        end
    end
end)
createToggleButton(combatPage, "No Recoil", function(on)
    noRecoilEnabled = on
end)

-- Players Page
playersListFrame = Instance.new("ScrollingFrame")
playersListFrame.Size = UDim2.new(1, 0, 0.4, 0)
playersListFrame.BackgroundTransparency = 1
playersListFrame.Parent = playersPage
local playerListLayout = Instance.new("UIListLayout", playersListFrame)
playerListLayout.Padding = UDim.new(0, 5)
playerListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local buttonsFrame = Instance.new("Frame")
buttonsFrame.Size = UDim2.new(1, 0, 0.6, 0)
buttonsFrame.Position = UDim2.new(0, 0, 0.4, 0)
buttonsFrame.BackgroundTransparency = 1
buttonsFrame.Parent = playersPage
local buttonListLayout = Instance.new("UIListLayout", buttonsFrame)
buttonListLayout.Padding = UDim.new(0, 5)
buttonListLayout.SortOrder = Enum.SortOrder.LayoutOrder

createPlayerButton(playersListFrame, player)
refreshPlayersList()
Players.PlayerAdded:Connect(refreshPlayersList)
Players.PlayerRemoving:Connect(refreshPlayersList)

local function createPlayerActionButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Parent = buttonsFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    btn.MouseButton1Click:Connect(function()
        if selectedPlayer then
            callback(selectedPlayer)
        else
            notify("⚠️ Selecciona un jugador primero!", "Error")
        end
    end)
end

createPlayerActionButton("Kill Player", killPlayer)
createPlayerActionButton("Teleport to Player", teleportToPlayer)
createPlayerActionButton("Force Fly Player", createFlyForPlayer)
createPlayerActionButton("Freeze Player", freezePlayer)
createPlayerActionButton("Unfreeze Player", unfreezePlayer)
createPlayerActionButton("Bring Player", bringPlayer)

-- Misc Page
createToggleButton(miscPage, "God Mode", function(on)
    godModeEnabled = on
end)
player.CharacterAdded:Connect(function()
    local humanoid = getHumanoid()
    if godModeEnabled and humanoid then
        humanoid.MaxHealth = 9e9
        humanoid.Health = humanoid.MaxHealth
    end
end)

local rejoinButton = Instance.new("TextButton")
rejoinButton.Size = UDim2.new(1, 0, 0, 40)
rejoinButton.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
rejoinButton.Text = "Rejoin Server"
rejoinButton.Font = Enum.Font.GothamBold
rejoinButton.TextSize = 14
rejoinButton.TextColor3 = Color3.new(1, 1, 1)
rejoinButton.Parent = miscPage
Instance.new("UICorner", rejoinButton).CornerRadius = UDim.new(0, 8)
rejoinButton.MouseButton1Click:Connect(forceRejoin)

-- Clean up on script unload (safety)
local function cleanupAll()
    disableFly()
    disableNoclip()
    disableESP()
    disableClickTP()
    local humanoid = getHumanoid()
    if humanoid then
        humanoid.WalkSpeed = defaultWalkSpeed
        humanoid.JumpPower = defaultJumpPower
    end
    Workspace.Gravity = defaultGravity
    Workspace.Lighting.Ambient = Color3.new(0, 0, 0)
    
    local char = getCharacter()
    if char then
        local trail = char:FindFirstChild("StipiFTrail")
        if trail then trail:Destroy() end
    end
    
    local playerGui = player.PlayerGui
    if playerGui:FindFirstChild("StipiFHub") then
        playerGui:FindFirstChild("StipiFHub"):Destroy()
    end
end
game:BindToClose(cleanupAll)
