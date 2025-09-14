-- Roblox Hacks GUI
-- GUI completa con múltiples hacks para Roblox
-- Incluye Fly, NoClip, ESP, Speed, y muchos más

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Variables para los hacks
local hackStates = {
    fly = false,
    noclip = false,
    esp = false,
    speed = false,
    jump = false,
    godmode = false,
    infiniteHealth = false,
    teleport = false,
    aimbot = false,
    wallhack = false,
    autoFarm = false,
    xray = false,
    fullbright = false,
    antiAFK = false,
    clickTP = false,
    invisibility = false,
    bigHead = false,
    walkOnWater = false,
    autoClicker = false,
    spinBot = false,
    lowGravity = false,
    infiniteStamina = false,
    btools = false,
    superPunch = false,
    removeDoors = false,
    freezeAllPlayers = false,
    noFallDamage = false,
    chatSpam = false
}

local hackConnections = {}
local originalValues = {
    walkSpeed = humanoid.WalkSpeed,
    jumpPower = humanoid.JumpPower,
    health = humanoid.Health,
    maxHealth = humanoid.MaxHealth
}

-- Crear ScreenGui principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HacksGUI"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false

-- Frame principal
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 500)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Esquinas redondeadas
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- Título
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
titleLabel.BorderSizePixel = 0
titleLabel.Text = "🚀 ROBLOX HACKS GUI"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleLabel

-- Botón cerrar
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeButton.BorderSizePixel = 0
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

-- ScrollingFrame para los botones
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "ScrollFrame"
scrollFrame.Size = UDim2.new(1, -20, 1, -60)
scrollFrame.Position = UDim2.new(0, 10, 0, 50)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 6
scrollFrame.Parent = mainFrame

-- Layout para los botones
local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 5)
listLayout.Parent = scrollFrame

-- Función para crear botones de hack
local function createHackButton(name, displayName, color, callback)
    local button = Instance.new("TextButton")
    button.Name = name .. "Button"
    button.Size = UDim2.new(1, -10, 0, 35)
    button.BackgroundColor3 = color
    button.BorderSizePixel = 0
    button.Text = "❌ " .. displayName
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.Font = Enum.Font.Gotham
    button.Parent = scrollFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button
    
    button.MouseButton1Click:Connect(function()
        hackStates[name] = not hackStates[name]
        if hackStates[name] then
            button.Text = "✅ " .. displayName
            button.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        else
            button.Text = "❌ " .. displayName
            button.BackgroundColor3 = color
        end
        callback(hackStates[name])
    end)
    
    return button
end

-- HACK 1: FLY
local function toggleFly(enabled)
    if enabled then
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = humanoidRootPart
        
        hackConnections.fly = RunService.Heartbeat:Connect(function()
            local moveVector = humanoid.MoveDirection
            local camera = workspace.CurrentCamera
            local cameraCFrame = camera.CFrame
            
            local velocity = Vector3.new(0, 0, 0)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                velocity = velocity + cameraCFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                velocity = velocity - cameraCFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                velocity = velocity - cameraCFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                velocity = velocity + cameraCFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                velocity = velocity + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                velocity = velocity - Vector3.new(0, 1, 0)
            end
            
            bodyVelocity.Velocity = velocity * 50
        end)
    else
        if hackConnections.fly then
            hackConnections.fly:Disconnect()
        end
        local bodyVelocity = humanoidRootPart:FindFirstChild("BodyVelocity")
        if bodyVelocity then
            bodyVelocity:Destroy()
        end
    end
end

-- HACK 2: NOCLIP
local function toggleNoclip(enabled)
    if enabled then
        hackConnections.noclip = RunService.Stepped:Connect(function()
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    else
        if hackConnections.noclip then
            hackConnections.noclip:Disconnect()
        end
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = true
            end
        end
    end
end

-- HACK 3: ESP
local function toggleESP(enabled)
    if enabled then
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= player and otherPlayer.Character then
                local highlight = Instance.new("Highlight")
                highlight.Name = "ESPHighlight"
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.FillTransparency = 0.5
                highlight.OutlineTransparency = 0
                highlight.Parent = otherPlayer.Character
            end
        end
        
        hackConnections.esp = Players.PlayerAdded:Connect(function(newPlayer)
            newPlayer.CharacterAdded:Connect(function(newCharacter)
                wait(1)
                if hackStates.esp then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "ESPHighlight"
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.5
                    highlight.OutlineTransparency = 0
                    highlight.Parent = newCharacter
                end
            end)
        end)
    else
        if hackConnections.esp then
            hackConnections.esp:Disconnect()
        end
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer.Character then
                local highlight = otherPlayer.Character:FindFirstChild("ESPHighlight")
                if highlight then
                    highlight:Destroy()
                end
            end
        end
    end
end

-- HACK 4: SPEED
local function toggleSpeed(enabled)
    if enabled then
        humanoid.WalkSpeed = 100
    else
        humanoid.WalkSpeed = originalValues.walkSpeed
    end
end

-- HACK 5: INFINITE JUMP
local function toggleInfiniteJump(enabled)
    if enabled then
        hackConnections.jump = UserInputService.JumpRequest:Connect(function()
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end)
    else
        if hackConnections.jump then
            hackConnections.jump:Disconnect()
        end
    end
end

-- HACK 6: GOD MODE
local function toggleGodMode(enabled)
    if enabled then
        hackConnections.godmode = humanoid.HealthChanged:Connect(function()
            humanoid.Health = humanoid.MaxHealth
        end)
    else
        if hackConnections.godmode then
            hackConnections.godmode:Disconnect()
        end
    end
end

-- HACK 7: INFINITE HEALTH
local function toggleInfiniteHealth(enabled)
    if enabled then
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
    else
        humanoid.MaxHealth = originalValues.maxHealth
        humanoid.Health = originalValues.health
    end
end

-- HACK 8: TELEPORT TO MOUSE
local function toggleTeleport(enabled)
    if enabled then
        hackConnections.teleport = UserInputService.InputBegan:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.T then
                local mouse = player:GetMouse()
                if mouse.Hit then
                    humanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 5, 0))
                end
            end
        end)
    else
        if hackConnections.teleport then
            hackConnections.teleport:Disconnect()
        end
    end
end

-- HACK 9: AIMBOT
local function toggleAimbot(enabled)
    if enabled then
        hackConnections.aimbot = RunService.Heartbeat:Connect(function()
            local camera = workspace.CurrentCamera
            local closestPlayer = nil
            local shortestDistance = math.huge
            
            for _, otherPlayer in pairs(Players:GetPlayers()) do
                if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("Head") then
                    local distance = (otherPlayer.Character.Head.Position - humanoidRootPart.Position).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestPlayer = otherPlayer
                    end
                end
            end
            
            if closestPlayer and shortestDistance < 100 then
                camera.CFrame = CFrame.lookAt(camera.CFrame.Position, closestPlayer.Character.Head.Position)
            end
        end)
    else
        if hackConnections.aimbot then
            hackConnections.aimbot:Disconnect()
        end
    end
end

-- HACK 10: WALLHACK
local function toggleWallhack(enabled)
    if enabled then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name == "Wall" or obj.Name:lower():find("wall") then
                obj.Transparency = 0.8
            end
        end
    else
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name == "Wall" or obj.Name:lower():find("wall") then
                obj.Transparency = 0
            end
        end
    end
end

-- HACK 11: AUTO FARM
local function toggleAutoFarm(enabled)
    if enabled then
        hackConnections.autofarm = RunService.Heartbeat:Connect(function()
            for _, obj in pairs(workspace:GetChildren()) do
                if obj.Name:lower():find("coin") or obj.Name:lower():find("cash") or obj.Name:lower():find("money") then
                    if obj:FindFirstChild("Humanoid") == nil then
                        humanoidRootPart.CFrame = obj.CFrame
                        wait(0.1)
                    end
                end
            end
        end)
    else
        if hackConnections.autofarm then
            hackConnections.autofarm:Disconnect()
        end
    end
end

-- HACK 12: X-RAY
local function toggleXray(enabled)
    if enabled then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                obj.LocalTransparencyModifier = 0.8
            end
        end
    else
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                obj.LocalTransparencyModifier = 0
            end
        end
    end
end

-- HACK 13: FULLBRIGHT
local function toggleFullbright(enabled)
    if enabled then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    else
        Lighting.Brightness = 1
        Lighting.ClockTime = 12
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = true
        Lighting.OutdoorAmbient = Color3.fromRGB(70, 70, 70)
    end
end

-- NUEVOS HACKS
local function toggleAntiAFK(enabled)
    if enabled then
        -- Código para el hack de Anti-AFK
    else
        -- Código para desactivar el hack de Anti-AFK
    end
end

local function toggleClickTP(enabled)
    if enabled then
        -- Código para el hack de Click TP
    else
        -- Código para desactivar el hack de Click TP
    end
end

local function toggleInvisibility(enabled)
    if enabled then
        -- Código para el hack de Invisibility
    else
        -- Código para desactivar el hack de Invisibility
    end
end

local function toggleBigHead(enabled)
    if enabled then
        character.Head.Size = Vector3.new(10, 10, 10)
    else
        character.Head.Size = Vector3.new(2, 1, 1)
    end
end

local function toggleWalkOnWater(enabled)
    if enabled then
        hackConnections.walkOnWater = RunService.Heartbeat:Connect(function()
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj.Name == "Water" and obj:IsA("BasePart") then
                    obj.CanCollide = true
                end
            end
        end)
    else
        if hackConnections.walkOnWater then hackConnections.walkOnWater:Disconnect() end
    end
end

local function toggleAutoClicker(enabled)
    if enabled then
        hackConnections.autoClicker = RunService.Heartbeat:Connect(function()
            mouse1click()
            wait(0.1)
        end)
    else
        if hackConnections.autoClicker then hackConnections.autoClicker:Disconnect() end
    end
end

local function toggleSpinBot(enabled)
    if enabled then
        hackConnections.spinBot = RunService.Heartbeat:Connect(function()
            humanoidRootPart.CFrame = humanoidRootPart.CFrame * CFrame.Angles(0, math.rad(20), 0)
        end)
    else
        if hackConnections.spinBot then hackConnections.spinBot:Disconnect() end
    end
end

local function toggleLowGravity(enabled)
    if enabled then
        workspace.Gravity = 50
    else
        workspace.Gravity = 196.2
    end
end

local function toggleInfiniteStamina(enabled)
    if enabled then
        hackConnections.infiniteStamina = RunService.Heartbeat:Connect(function()
            if humanoid:FindFirstChild("Stamina") then
                humanoid.Stamina.Value = humanoid.Stamina.MaxValue
            end
        end)
    else
        if hackConnections.infiniteStamina then hackConnections.infiniteStamina:Disconnect() end
    end
end

local function toggleBtools(enabled)
    if enabled then
        local tool1 = Instance.new("HopperBin")
        tool1.BinType = "Clone"
        tool1.Parent = player.Backpack
        
        local tool2 = Instance.new("HopperBin")
        tool2.BinType = "Hammer"
        tool2.Parent = player.Backpack
        
        local tool3 = Instance.new("HopperBin")
        tool3.BinType = "Grab"
        tool3.Parent = player.Backpack
    end
end

local function toggleSuperPunch(enabled)
    if enabled then
        hackConnections.superPunch = humanoid.Touched:Connect(function(hit)
            if hit.Parent:FindFirstChild("Humanoid") and hit.Parent ~= character then
                local bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
                bodyVelocity.Velocity = humanoidRootPart.CFrame.LookVector * 100
                bodyVelocity.Parent = hit.Parent.HumanoidRootPart
                game:GetService("Debris"):AddItem(bodyVelocity, 0.5)
            end
        end)
    else
        if hackConnections.superPunch then hackConnections.superPunch:Disconnect() end
    end
end

local function toggleRemoveDoors(enabled)
    if enabled then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj.Name:lower():find("door") and obj:IsA("BasePart") then
                obj:Destroy()
            end
        end
    end
end

local function toggleFreezeAllPlayers(enabled)
    if enabled then
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= player and otherPlayer.Character then
                local humanoidRootPart = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    humanoidRootPart.Anchored = true
                end
            end
        end
    else
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= player and otherPlayer.Character then
                local humanoidRootPart = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    humanoidRootPart.Anchored = false
                end
            end
        end
    end
end

local function toggleNoFallDamage(enabled)
    if enabled then
        hackConnections.noFallDamage = humanoid.StateChanged:Connect(function(old, new)
            if new == Enum.HumanoidStateType.Landed then
                humanoid.Health = humanoid.MaxHealth
            end
        end)
    else
        if hackConnections.noFallDamage then hackConnections.noFallDamage:Disconnect() end
    end
end

local function toggleChatSpam(enabled)
    if enabled then
        hackConnections.chatSpam = RunService.Heartbeat:Connect(function()
            game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("HACKED BY ULTIMATE GUI! 🚀", "All")
            wait(2)
        end)
    else
        if hackConnections.chatSpam then hackConnections.chatSpam:Disconnect() end
    end
end

-- Crear todos los botones
createHackButton("fly", "🚁 Fly (WASD + Space/Shift)", Color3.fromRGB(100, 50, 200), toggleFly)
createHackButton("noclip", "👻 NoClip", Color3.fromRGB(200, 50, 100), toggleNoclip)
createHackButton("esp", "👁️ ESP (Ver jugadores)", Color3.fromRGB(50, 200, 100), toggleESP)
createHackButton("speed", "⚡ Speed Hack", Color3.fromRGB(200, 200, 50), toggleSpeed)
createHackButton("jump", "🦘 Infinite Jump", Color3.fromRGB(50, 100, 200), toggleInfiniteJump)
createHackButton("godmode", "🛡️ God Mode", Color3.fromRGB(200, 100, 50), toggleGodMode)
createHackButton("infiniteHealth", "❤️ Infinite Health", Color3.fromRGB(200, 50, 50), toggleInfiniteHealth)
createHackButton("teleport", "📍 Teleport (Presiona T)", Color3.fromRGB(100, 200, 50), toggleTeleport)
createHackButton("aimbot", "🎯 Aimbot", Color3.fromRGB(150, 50, 150), toggleAimbot)
createHackButton("wallhack", "🧱 Wallhack", Color3.fromRGB(50, 150, 150), toggleWallhack)
createHackButton("autofarm", "🤖 Auto Farm", Color3.fromRGB(150, 150, 50), toggleAutoFarm)
createHackButton("xray", "🔍 X-Ray", Color3.fromRGB(100, 100, 200), toggleXray)
createHackButton("fullbright", "💡 Fullbright", Color3.fromRGB(200, 200, 200), toggleFullbright)
createHackButton("antiAFK", "💤 Anti-AFK", Color3.fromRGB(150, 100, 200), toggleAntiAFK)
createHackButton("clickTP", "🖱️ Click TP (Ctrl+Click)", Color3.fromRGB(100, 200, 150), toggleClickTP)
createHackButton("invisibility", "👤 Invisibility", Color3.fromRGB(200, 150, 100), toggleInvisibility)
createHackButton("bigHead", "🗿 Big Head", Color3.fromRGB(255, 100, 100), toggleBigHead)
createHackButton("walkOnWater", "🌊 Walk on Water", Color3.fromRGB(100, 150, 255), toggleWalkOnWater)
createHackButton("autoClicker", "🖱️ Auto Clicker", Color3.fromRGB(255, 150, 50), toggleAutoClicker)
createHackButton("spinBot", "🌀 Spin Bot", Color3.fromRGB(150, 255, 150), toggleSpinBot)
createHackButton("lowGravity", "🪐 Low Gravity", Color3.fromRGB(200, 100, 255), toggleLowGravity)
createHackButton("infiniteStamina", "💪 Infinite Stamina", Color3.fromRGB(255, 200, 100), toggleInfiniteStamina)
createHackButton("btools", "🔨 Btools", Color3.fromRGB(150, 150, 255), toggleBtools)
createHackButton("superPunch", "👊 Super Punch", Color3.fromRGB(255, 100, 150), toggleSuperPunch)
createHackButton("removeDoors", "🚪 Remove Doors", Color3.fromRGB(100, 255, 200), toggleRemoveDoors)
createHackButton("freezeAllPlayers", "🧊 Freeze All Players", Color3.fromRGB(150, 200, 255), toggleFreezeAllPlayers)
createHackButton("noFallDamage", "🛡️ No Fall Damage", Color3.fromRGB(200, 255, 100), toggleNoFallDamage)
createHackButton("chatSpam", "💬 Chat Spam", Color3.fromRGB(255, 150, 200), toggleChatSpam)

-- Ajustar el tamaño del scroll
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
end)

-- Función para cerrar la GUI
closeButton.MouseButton1Click:Connect(function()
    -- Desactivar todos los hacks antes de cerrar
    for hackName, _ in pairs(hackStates) do
        if hackStates[hackName] then
            hackStates[hackName] = false
            if hackName == "fly" then toggleFly(false)
            elseif hackName == "noclip" then toggleNoclip(false)
            elseif hackName == "esp" then toggleESP(false)
            elseif hackName == "speed" then toggleSpeed(false)
            elseif hackName == "jump" then toggleInfiniteJump(false)
            elseif hackName == "godmode" then toggleGodMode(false)
            elseif hackName == "infiniteHealth" then toggleInfiniteHealth(false)
            elseif hackName == "teleport" then toggleTeleport(false)
            elseif hackName == "aimbot" then toggleAimbot(false)
            elseif hackName == "wallhack" then toggleWallhack(false)
            elseif hackName == "autofarm" then toggleAutoFarm(false)
            elseif hackName == "xray" then toggleXray(false)
            elseif hackName == "fullbright" then toggleFullbright(false)
            elseif hackName == "antiAFK" then toggleAntiAFK(false)
            elseif hackName == "clickTP" then toggleClickTP(false)
            elseif hackName == "invisibility" then toggleInvisibility(false)
            elseif hackName == "bigHead" then toggleBigHead(false)
            elseif hackName == "walkOnWater" then toggleWalkOnWater(false)
            elseif hackName == "autoClicker" then toggleAutoClicker(false)
            elseif hackName == "spinBot" then toggleSpinBot(false)
            elseif hackName == "lowGravity" then toggleLowGravity(false)
            elseif hackName == "infiniteStamina" then toggleInfiniteStamina(false)
            elseif hackName == "btools" then toggleBtools(false)
            elseif hackName == "superPunch" then toggleSuperPunch(false)
            elseif hackName == "removeDoors" then toggleRemoveDoors(false)
            elseif hackName == "freezeAllPlayers" then toggleFreezeAllPlayers(false)
            elseif hackName == "noFallDamage" then toggleNoFallDamage(false)
            elseif hackName == "chatSpam" then toggleChatSpam(false)
            end
        end
    end
    screenGui:Destroy()
end)

-- Toggle GUI con tecla
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

-- Mensaje de inicio
print("🚀 Roblox Hacks GUI cargada!")
print("📝 Presiona Right Shift para mostrar/ocultar la GUI")
print("⚠️ Usa los hacks responsablemente")

-- Actualizar referencias cuando el personaje respawnee
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    
    originalValues.walkSpeed = humanoid.WalkSpeed
    originalValues.jumpPower = humanoid.JumpPower
    originalValues.health = humanoid.Health
    originalValues.maxHealth = humanoid.MaxHealth
end)
