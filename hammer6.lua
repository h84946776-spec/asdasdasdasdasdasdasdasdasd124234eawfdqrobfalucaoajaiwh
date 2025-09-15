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
    autofarm = false,
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
    chatSpam = false,
    autoFarmCoins = false,
    megaJump = false,
    killAura = false,
    oneHitKill = false,
    weaponMods = false,
    autoParry = false,
    criticalHits = false,
    damageBoost = false,
    armorPiercing = false,
    combatBot = false,
    chams = false,
    tracers = false,
    nameESP = false,
    distanceESP = false,
    itemESP = false,
    nightVision = false,
    serverHop = false,
    rejoin = false,
    autoSave = false,
    rainbowCharacter = false,
    infiniteAmmo = false,
    autoRespawn = false,
    magnetHands = false,
    phaseWalk = false,
    timeFreeze = false,
    massDestroy = false,
    playerClone = false,
    antiKick = false,
    speedBoost = false,
    gravityFlip = false
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

-- 20 NUEVOS HACKS ADICIONALES
local function toggleAutoFarmCoins(enabled)
    if enabled then
        hackConnections.autoFarmCoins = RunService.Heartbeat:Connect(function()
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj.Name:lower():find("coin") or obj.Name:lower():find("money") or obj.Name:lower():find("cash") then
                    if obj:IsA("BasePart") and obj.Parent ~= character then
                        obj.CFrame = humanoidRootPart.CFrame
                    end
                end
            end
        end)
    else
        if hackConnections.autoFarmCoins then hackConnections.autoFarmCoins:Disconnect() end
    end
end

local function toggleMegaJump(enabled)
    if enabled then
        humanoid.JumpPower = 500
    else
        humanoid.JumpPower = originalValues.jumpPower
    end
end

local function toggleKillAura(enabled)
    if enabled then
        hackConnections.killAura = RunService.Heartbeat:Connect(function()
            for _, otherPlayer in pairs(Players:GetPlayers()) do
                if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("Humanoid") then
                    local distance = (otherPlayer.Character.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude
                    if distance < 20 then
                        otherPlayer.Character.Humanoid.Health = 0
                    end
                end
            end
        end)
    else
        if hackConnections.killAura then hackConnections.killAura:Disconnect() end
    end
end

local function toggleOneHitKill(enabled)
    if enabled then
        hackConnections.oneHitKill = humanoid.Touched:Connect(function(hit)
            if hit.Parent:FindFirstChild("Humanoid") and hit.Parent ~= character then
                hit.Parent.Humanoid.Health = 0
            end
        end)
    else
        if hackConnections.oneHitKill then hackConnections.oneHitKill:Disconnect() end
    end
end

local function toggleWeaponMods(enabled)
    if enabled then
        hackConnections.weaponMods = RunService.Heartbeat:Connect(function()
            for _, tool in pairs(player.Backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    tool.Damage.Value = 999
                end
            end
        end)
    else
        if hackConnections.weaponMods then hackConnections.weaponMods:Disconnect() end
    end
end

local function toggleAutoParry(enabled)
    if enabled then
        hackConnections.autoParry = RunService.Heartbeat:Connect(function()
            for _, otherPlayer in pairs(Players:GetPlayers()) do
                if otherPlayer ~= player and otherPlayer.Character then
                    local tool = otherPlayer.Character:FindFirstChildOfClass("Tool")
                    if tool then
                        -- Auto parry logic
                        humanoid:EquipTool(player.Backpack:FindFirstChildOfClass("Tool"))
                    end
                end
            end
        end)
    else
        if hackConnections.autoParry then hackConnections.autoParry:Disconnect() end
    end
end

local function toggleCriticalHits(enabled)
    if enabled then
        hackConnections.criticalHits = humanoid.Touched:Connect(function(hit)
            if hit.Parent:FindFirstChild("Humanoid") and hit.Parent ~= character then
                hit.Parent.Humanoid.Health = hit.Parent.Humanoid.Health - (hit.Parent.Humanoid.MaxHealth * 0.5)
            end
        end)
    else
        if hackConnections.criticalHits then hackConnections.criticalHits:Disconnect() end
    end
end

local function toggleDamageBoost(enabled)
    if enabled then
        hackConnections.damageBoost = humanoid.Touched:Connect(function(hit)
            if hit.Parent:FindFirstChild("Humanoid") and hit.Parent ~= character then
                hit.Parent.Humanoid.Health = hit.Parent.Humanoid.Health - 50
            end
        end)
    else
        if hackConnections.damageBoost then hackConnections.damageBoost:Disconnect() end
    end
end

local function toggleArmorPiercing(enabled)
    if enabled then
        hackConnections.armorPiercing = humanoid.Touched:Connect(function(hit)
            if hit.Parent:FindFirstChild("ForceField") then
                hit.Parent.ForceField:Destroy()
            end
        end)
    else
        if hackConnections.armorPiercing then hackConnections.armorPiercing:Disconnect() end
    end
end

local function toggleCombatBot(enabled)
    if enabled then
        hackConnections.combatBot = RunService.Heartbeat:Connect(function()
            local closestPlayer = nil
            local shortestDistance = math.huge
            
            for _, otherPlayer in pairs(Players:GetPlayers()) do
                if otherPlayer ~= player and otherPlayer.Character then
                    local distance = (otherPlayer.Character.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude
                    if distance < shortestDistance and distance < 50 then
                        shortestDistance = distance
                        closestPlayer = otherPlayer
                    end
                end
            end
            
            if closestPlayer then
                humanoidRootPart.CFrame = CFrame.lookAt(humanoidRootPart.Position, closestPlayer.Character.HumanoidRootPart.Position)
                humanoid:MoveTo(closestPlayer.Character.HumanoidRootPart.Position)
            end
        end)
    else
        if hackConnections.combatBot then hackConnections.combatBot:Disconnect() end
    end
end

local function toggleChams(enabled)
    if enabled then
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= player and otherPlayer.Character then
                for _, part in pairs(otherPlayer.Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.Material = Enum.Material.ForceField
                        part.BrickColor = BrickColor.new("Bright red")
                    end
                end
            end
        end
    else
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= player and otherPlayer.Character then
                for _, part in pairs(otherPlayer.Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.Material = Enum.Material.Plastic
                        part.BrickColor = BrickColor.new("Medium stone grey")
                    end
                end
            end
        end
    end
end

local function toggleTracers(enabled)
    if enabled then
        hackConnections.tracers = RunService.Heartbeat:Connect(function()
            for _, otherPlayer in pairs(Players:GetPlayers()) do
                if otherPlayer ~= player and otherPlayer.Character then
                    local beam = Instance.new("Beam")
                    local attachment1 = Instance.new("Attachment")
                    local attachment2 = Instance.new("Attachment")
                    
                    attachment1.Parent = humanoidRootPart
                    attachment2.Parent = otherPlayer.Character.HumanoidRootPart
                    
                    beam.Attachment0 = attachment1
                    beam.Attachment1 = attachment2
                    beam.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
                    beam.Parent = workspace
                    
                    game:GetService("Debris"):AddItem(beam, 0.1)
                    game:GetService("Debris"):AddItem(attachment1, 0.1)
                    game:GetService("Debris"):AddItem(attachment2, 0.1)
                end
            end
        end)
    else
        if hackConnections.tracers then hackConnections.tracers:Disconnect() end
    end
end

local function toggleNameESP(enabled)
    if enabled then
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("Head") then
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "NameESP"
                billboard.Size = UDim2.new(0, 200, 0, 50)
                billboard.StudsOffset = Vector3.new(0, 2, 0)
                billboard.Parent = otherPlayer.Character.Head
                
                local nameLabel = Instance.new("TextLabel")
                nameLabel.Size = UDim2.new(1, 0, 1, 0)
                nameLabel.BackgroundTransparency = 1
                nameLabel.Text = otherPlayer.Name
                nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                nameLabel.TextScaled = true
                nameLabel.Font = Enum.Font.GothamBold
                nameLabel.Parent = billboard
            end
        end
    else
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer.Character and otherPlayer.Character.Head then
                local billboard = otherPlayer.Character.Head:FindFirstChild("NameESP")
                if billboard then billboard:Destroy() end
            end
        end
    end
end

local function toggleDistanceESP(enabled)
    if enabled then
        hackConnections.distanceESP = RunService.Heartbeat:Connect(function()
            for _, otherPlayer in pairs(Players:GetPlayers()) do
                if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("Head") then
                    local distance = math.floor((otherPlayer.Character.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude)
                    local billboard = otherPlayer.Character.Head:FindFirstChild("DistanceESP")
                    
                    if not billboard then
                        billboard = Instance.new("BillboardGui")
                        billboard.Name = "DistanceESP"
                        billboard.Size = UDim2.new(0, 200, 0, 50)
                        billboard.StudsOffset = Vector3.new(0, -2, 0)
                        billboard.Parent = otherPlayer.Character.Head
                        
                        local distanceLabel = Instance.new("TextLabel")
                        distanceLabel.Size = UDim2.new(1, 0, 1, 0)
                        distanceLabel.BackgroundTransparency = 1
                        distanceLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                        distanceLabel.TextScaled = true
                        distanceLabel.Font = Enum.Font.Gotham
                        distanceLabel.Parent = billboard
                    end
                    
                    billboard.TextLabel.Text = distance .. " studs"
                end
            end
        end)
    else
        if hackConnections.distanceESP then hackConnections.distanceESP:Disconnect() end
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer.Character and otherPlayer.Character.Head then
                local billboard = otherPlayer.Character.Head:FindFirstChild("DistanceESP")
                if billboard then billboard:Destroy() end
            end
        end
    end
end

local function toggleItemESP(enabled)
    if enabled then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Tool") or obj.Name:lower():find("item") or obj.Name:lower():find("weapon") then
                local highlight = Instance.new("Highlight")
                highlight.Name = "ItemESP"
                highlight.FillColor = Color3.fromRGB(0, 255, 255)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.Parent = obj
            end
        end
    else
        for _, obj in pairs(workspace:GetDescendants()) do
            local highlight = obj:FindFirstChild("ItemESP")
            if highlight then highlight:Destroy() end
        end
    end
end

local function toggleNightVision(enabled)
    if enabled then
        Lighting.Brightness = 5
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    else
        Lighting.Brightness = 1
        Lighting.Ambient = Color3.fromRGB(70, 70, 70)
        Lighting.OutdoorAmbient = Color3.fromRGB(70, 70, 70)
    end
end

local function toggleServerHop(enabled)
    if enabled then
        local TeleportService = game:GetService("TeleportService")
        TeleportService:Teleport(game.PlaceId, player)
    end
end

local function toggleRejoin(enabled)
    if enabled then
        local TeleportService = game:GetService("TeleportService")
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
    end
end

local function toggleAutoSave(enabled)
    if enabled then
        hackConnections.autoSave = RunService.Heartbeat:Connect(function()
            wait(300) -- Auto save every 5 minutes
            game:GetService("DataStoreService"):GetDataStore("PlayerData"):SetAsync(player.UserId, {
                coins = player.leaderstats.Coins.Value,
                level = player.leaderstats.Level.Value
            })
        end)
    else
        if hackConnections.autoSave then hackConnections.autoSave:Disconnect() end
    end
end

local function toggleRainbowCharacter(enabled)
    if enabled then
        hackConnections.rainbowCharacter = RunService.Heartbeat:Connect(function()
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                end
            end
        end)
    else
        if hackConnections.rainbowCharacter then hackConnections.rainbowCharacter:Disconnect() end
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.Color = Color3.fromRGB(163, 162, 165) -- Default color
            end
        end
    end
end

-- HACK: INFINITE AMMO
local function toggleInfiniteAmmo(enabled)
    if enabled then
        hackConnections.infiniteAmmo = RunService.Heartbeat:Connect(function()
            for _, tool in pairs(player.Backpack:GetChildren()) do
                if tool:IsA("Tool") and tool:FindFirstChild("Ammo") then
                    tool.Ammo.Value = tool.Ammo.MaxValue or 999
                end
            end
            if character:FindFirstChildOfClass("Tool") then
                local equippedTool = character:FindFirstChildOfClass("Tool")
                if equippedTool:FindFirstChild("Ammo") then
                    equippedTool.Ammo.Value = equippedTool.Ammo.MaxValue or 999
                end
            end
        end)
    else
        if hackConnections.infiniteAmmo then hackConnections.infiniteAmmo:Disconnect() end
    end
end

-- HACK: AUTO RESPAWN
local function toggleAutoRespawn(enabled)
    if enabled then
        hackConnections.autoRespawn = humanoid.Died:Connect(function()
            wait(2)
            player:LoadCharacter()
        end)
    else
        if hackConnections.autoRespawn then hackConnections.autoRespawn:Disconnect() end
    end
end

-- HACK: MAGNET HANDS
local function toggleMagnetHands(enabled)
    if enabled then
        hackConnections.magnetHands = RunService.Heartbeat:Connect(function()
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Tool") or (obj:IsA("BasePart") and obj.Name:lower():find("coin")) then
                    if (obj.Position - humanoidRootPart.Position).Magnitude < 50 then
                        obj.CFrame = humanoidRootPart.CFrame
                    end
                end
            end
        end)
    else
        if hackConnections.magnetHands then hackConnections.magnetHands:Disconnect() end
    end
end

-- HACK: PHASE WALK
local function togglePhaseWalk(enabled)
    if enabled then
        hackConnections.phaseWalk = RunService.Stepped:Connect(function()
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                for _, part in pairs(character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            else
                for _, part in pairs(character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = true
                    end
                end
            end
        end)
    else
        if hackConnections.phaseWalk then hackConnections.phaseWalk:Disconnect() end
    end
end

-- HACK: TIME FREEZE
local function toggleTimeFreeze(enabled)
    if enabled then
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= player and otherPlayer.Character then
                local humanoidRootPart = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    humanoidRootPart.Anchored = true
                end
                local humanoid = otherPlayer.Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = 0
                    humanoid.JumpPower = 0
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
                local humanoid = otherPlayer.Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = 16
                    humanoid.JumpPower = 50
                end
            end
        end
    end
end

-- HACK: MASS DESTROY
local function toggleMassDestroy(enabled)
    if enabled then
        hackConnections.massDestroy = UserInputService.InputBegan:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.X then
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and obj.Parent ~= character and not Players:GetPlayerFromCharacter(obj.Parent) then
                        if (obj.Position - humanoidRootPart.Position).Magnitude < 100 then
                            obj:Destroy()
                        end
                    end
                end
            end
        end)
    else
        if hackConnections.massDestroy then hackConnections.massDestroy:Disconnect() end
    end
end

-- HACK: PLAYER CLONE
local function togglePlayerClone(enabled)
    if enabled then
        local clone = character:Clone()
        clone.Name = character.Name .. "_Clone"
        clone.Parent = workspace
        clone.HumanoidRootPart.CFrame = humanoidRootPart.CFrame + Vector3.new(5, 0, 0)
        
        -- Hacer que el clon siga al jugador
        hackConnections.playerClone = RunService.Heartbeat:Connect(function()
            if clone and clone.Parent then
                clone.HumanoidRootPart.CFrame = humanoidRootPart.CFrame + Vector3.new(5, 0, 0)
            end
        end)
    else
        if hackConnections.playerClone then hackConnections.playerClone:Disconnect() end
        for _, obj in pairs(workspace:GetChildren()) do
            if obj.Name == character.Name .. "_Clone" then
                obj:Destroy()
            end
        end
    end
end

-- HACK: ANTI KICK
local function toggleAntiKick(enabled)
    if enabled then
        -- Proteger contra kicks comunes
        local mt = getrawmetatable(game)
        local oldNamecall = mt.__namecall
        setreadonly(mt, false)
        
        mt.__namecall = function(self, ...)
            local method = getnamecallmethod()
            if method == "Kick" then
                return
            end
            return oldNamecall(self, ...)
        end
        
        setreadonly(mt, true)
    else
        -- Restaurar funcionalidad normal (difícil de revertir completamente)
    end
end

-- HACK: SPEED BOOST
local function toggleSpeedBoost(enabled)
    if enabled then
        humanoid.WalkSpeed = 200
        hackConnections.speedBoost = RunService.Heartbeat:Connect(function()
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                humanoid.WalkSpeed = 500
            else
                humanoid.WalkSpeed = 200
            end
        end)
    else
        if hackConnections.speedBoost then hackConnections.speedBoost:Disconnect() end
        humanoid.WalkSpeed = originalValues.walkSpeed
    end
end

-- HACK: GRAVITY FLIP
local function toggleGravityFlip(enabled)
    if enabled then
        workspace.Gravity = -196.2
        hackConnections.gravityFlip = UserInputService.InputBegan:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.G then
                workspace.Gravity = workspace.Gravity * -1
            end
        end)
    else
        if hackConnections.gravityFlip then hackConnections.gravityFlip:Disconnect() end
        workspace.Gravity = 196.2
    end
end

-- Crear todos los botones
createHackButton("infiniteAmmo", "💸 Infinite Ammo", Color3.fromRGB(255, 255, 0), toggleInfiniteAmmo)
createHackButton("autoRespawn", "♻️ Auto Respawn", Color3.fromRGB(0, 255, 0), toggleAutoRespawn)
createHackButton("magnetHands", "🤚 Magnet Hands", Color3.fromRGB(0, 0, 255), toggleMagnetHands)
createHackButton("phaseWalk", "🚶‍♂️ Phase Walk", Color3.fromRGB(255, 0, 255), togglePhaseWalk)
createHackButton("timeFreeze", "❄️ Time Freeze", Color3.fromRGB(128, 128, 128), toggleTimeFreeze)
createHackButton("massDestroy", "💣 Mass Destroy", Color3.fromRGB(255, 0, 0), toggleMassDestroy)
createHackButton("playerClone", "👥 Player Clone", Color3.fromRGB(0, 255, 0), togglePlayerClone)
createHackButton("antiKick", "🚫 Anti Kick", Color3.fromRGB(255, 128, 0), toggleAntiKick)
createHackButton("speedBoost", "⚡ Speed Boost", Color3.fromRGB(255, 255, 255), toggleSpeedBoost)
createHackButton("gravityFlip", "🌌 Gravity Flip", Color3.fromRGB(0, 0, 255), toggleGravityFlip)
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
createHackButton("autoFarmCoins", "💸 Auto Farm Coins", Color3.fromRGB(255, 255, 0), toggleAutoFarmCoins)
createHackButton("megaJump", "🦸‍♂️ Mega Jump", Color3.fromRGB(255, 0, 255), toggleMegaJump)
createHackButton("killAura", "💀 Kill Aura", Color3.fromRGB(255, 0, 0), toggleKillAura)
createHackButton("oneHitKill", "💣 One Hit Kill", Color3.fromRGB(255, 128, 0), toggleOneHitKill)
createHackButton("weaponMods", "🔫 Weapon Mods", Color3.fromRGB(0, 255, 0), toggleWeaponMods)
createHackButton("autoParry", "⚔️ Auto Parry", Color3.fromRGB(0, 0, 255), toggleAutoParry)
createHackButton("criticalHits", "💥 Critical Hits", Color3.fromRGB(255, 255, 255), toggleCriticalHits)
createHackButton("damageBoost", "💪 Damage Boost", Color3.fromRGB(255, 128, 128), toggleDamageBoost)
createHackButton("armorPiercing", "🔪 Armor Piercing", Color3.fromRGB(128, 0, 128), toggleArmorPiercing)
createHackButton("combatBot", "🤖 Combat Bot", Color3.fromRGB(0, 128, 0), toggleCombatBot)
createHackButton("chams", "🔮 Chams", Color3.fromRGB(255, 0, 255), toggleChams)
createHackButton("tracers", "🔴 Tracers", Color3.fromRGB(255, 0, 0), toggleTracers)
createHackButton("nameESP", "👥 Name ESP", Color3.fromRGB(0, 255, 0), toggleNameESP)
createHackButton("distanceESP", "📍 Distance ESP", Color3.fromRGB(0, 0, 255), toggleDistanceESP)
createHackButton("itemESP", "🎁 Item ESP", Color3.fromRGB(255, 255, 0), toggleItemESP)
createHackButton("nightVision", "🌃 Night Vision", Color3.fromRGB(128, 128, 128), toggleNightVision)
createHackButton("serverHop", "🔄 Server Hop", Color3.fromRGB(255, 0, 255), toggleServerHop)
createHackButton("rejoin", "🔄 Rejoin", Color3.fromRGB(0, 255, 0), toggleRejoin)
createHackButton("autoSave", "💾 Auto Save", Color3.fromRGB(255, 255, 255), toggleAutoSave)
createHackButton("rainbowCharacter", "🌈 Rainbow Character", Color3.fromRGB(255, 128, 0), toggleRainbowCharacter)

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
            elseif hackName == "autoFarmCoins" then toggleAutoFarmCoins(false)
            elseif hackName == "megaJump" then toggleMegaJump(false)
            elseif hackName == "killAura" then toggleKillAura(false)
            elseif hackName == "oneHitKill" then toggleOneHitKill(false)
            elseif hackName == "weaponMods" then toggleWeaponMods(false)
            elseif hackName == "autoParry" then toggleAutoParry(false)
            elseif hackName == "criticalHits" then toggleCriticalHits(false)
            elseif hackName == "damageBoost" then toggleDamageBoost(false)
            elseif hackName == "armorPiercing" then toggleArmorPiercing(false)
            elseif hackName == "combatBot" then toggleCombatBot(false)
            elseif hackName == "chams" then toggleChams(false)
            elseif hackName == "tracers" then toggleTracers(false)
            elseif hackName == "nameESP" then toggleNameESP(false)
            elseif hackName == "distanceESP" then toggleDistanceESP(false)
            elseif hackName == "itemESP" then toggleItemESP(false)
            elseif hackName == "nightVision" then toggleNightVision(false)
            elseif hackName == "serverHop" then toggleServerHop(false)
            elseif hackName == "rejoin" then toggleRejoin(false)
            elseif hackName == "autoSave" then toggleAutoSave(false)
            elseif hackName == "rainbowCharacter" then toggleRainbowCharacter(false)
            elseif hackName == "infiniteAmmo" then toggleInfiniteAmmo(false)
            elseif hackName == "autoRespawn" then toggleAutoRespawn(false)
            elseif hackName == "magnetHands" then toggleMagnetHands(false)
            elseif hackName == "phaseWalk" then togglePhaseWalk(false)
            elseif hackName == "timeFreeze" then toggleTimeFreeze(false)
            elseif hackName == "massDestroy" then toggleMassDestroy(false)
            elseif hackName == "playerClone" then togglePlayerClone(false)
            elseif hackName == "antiKick" then toggleAntiKick(false)
            elseif hackName == "speedBoost" then toggleSpeedBoost(false)
            elseif hackName == "gravityFlip" then toggleGravityFlip(false)
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

-- Manejo de entrada táctil
local isDragging = false
local dragStart
local dragStartPosition

local function onTouchInputBegan(input, gameProcessed)
    if gameProcessed then return end
    
    local touchPos = input.Position
    local framePos = mainFrame.AbsolutePosition
    local frameSize = mainFrame.AbsoluteSize
    
    -- Verificar si el toque está dentro del área del título
    if touchPos.X >= framePos.X and touchPos.X <= framePos.X + frameSize.X and
       touchPos.Y >= framePos.Y and touchPos.Y <= framePos.Y + 50 then
        isDragging = true
        dragStart = input.Position
        dragStartPosition = mainFrame.Position
        
        -- Crear un efecto visual al tocar
        local touchEffect = Instance.new("Frame")
        touchEffect.Size = UDim2.new(1, 0, 0, 50)
        touchEffect.Position = UDim2.new(0, 0, 0, 0)
        touchEffect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        touchEffect.BackgroundTransparency = 0.9
        touchEffect.BorderSizePixel = 0
        touchEffect.Parent = mainFrame
        
        -- Animación de desvanecimiento
        game:GetService("TweenService"):Create(
            touchEffect,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundTransparency = 1}
        ):Play()
        
        -- Eliminar después de la animación
        game:GetService("Debris"):AddItem(touchEffect, 0.31)
    end
end

local function onTouchInputChanged(input)
    if isDragging and input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            0, dragStartPosition.X.Offset + delta.X,
            0, dragStartPosition.Y.Offset + delta.Y
        )
    end
end

local function onTouchInputEnded()
    isDragging = false
end

-- Conectar eventos táctiles
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.Touch then
        onTouchInputBegan(input, gameProcessed)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        onTouchInputChanged(input)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        onTouchInputEnded()
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
