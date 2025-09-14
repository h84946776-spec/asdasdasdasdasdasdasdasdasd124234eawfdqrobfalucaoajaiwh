-- LocalScript: StipiFHub (mejorado)
-- Pegar como LocalScript en StarterPlayerScripts.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- STATE
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")

local flyEnabled = false
local noclipEnabled = false
local espEnabled = false
local speedEnabled = false

-- internals
local flyBV = nil
local flyConn = nil
local noclipConn = nil
local espHighlights = {}
local espPlayerAddedConn = nil
local espCharacterConns = {}

local flySpeed = 80
local defaultWalkSpeed = humanoid.WalkSpeed
local speedMultiplier = 30 -- Velocidad a la que se moverá el personaje

-- UTILS
local function safeFindHRP(char)
    return (char and char:FindFirstChild("HumanoidRootPart")) or nil
end

local function safeFindHumanoid(char)
    return (char and char:FindFirstChildOfClass("Humanoid")) or nil
end

-- HANDLE RESPAWN
local function onCharacterAdded(char)
    character = char
    humanoid = safeFindHumanoid(char)
    hrp = safeFindHRP(char)

    if flyEnabled then
        if flyBV then flyBV:Destroy(); flyBV = nil end
        enableFly()
    end

    if speedEnabled then
        enableSpeed()
    end
end

player.CharacterAdded:Connect(onCharacterAdded)

-- FLY
local function enableFly()
    if not character or not hrp then return end
    if flyBV then flyBV:Destroy(); flyBV = nil end -- Limpiar cualquier instancia vieja

    humanoid.PlatformStand = true
    flyBV = Instance.new("BodyVelocity")
    flyBV.Name = "StipiFly_BV"
    flyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    flyBV.P = 1250
    flyBV.Velocity = Vector3.new(0, 0, 0)
    flyBV.Parent = hrp

    flyConn = RunService.RenderStepped:Connect(function(dt)
        if not flyBV or not hrp or not character then return end
        local cam = workspace.CurrentCamera
        local dir = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.C) then dir = dir - Vector3.new(0, 1, 0) end

        if dir.Magnitude > 0 then
            flyBV.Velocity = dir.Unit * flySpeed
        else
            flyBV.Velocity = Vector3.new(0, 0, 0)
        end
    end)
end

local function disableFly()
    if flyConn then flyConn:Disconnect(); flyConn = nil end
    if flyBV then flyBV:Destroy(); flyBV = nil end
    if humanoid and humanoid.Parent then
        humanoid.PlatformStand = false
    end
end

-- NOCOLLIDE
local function enableNoclip()
    if noclipConn then return end
    noclipConn = RunService.Stepped:Connect(function()
        if not character then return end
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                pcall(function() part.CanCollide = false end)
            end
        end
    end)
end

local function disableNoclip()
    if noclipConn then
        noclipConn:Disconnect()
        noclipConn = nil
    end
    if character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                pcall(function() part.CanCollide = true end)
            end
        end
    end
end

-- ESP
local function createHighlightForCharacter(char)
    if not char or not char:IsA("Model") then return end
    local existing = char:FindFirstChild("Stipi_ESP_Highlight")
    if existing then return existing end

    local h = Instance.new("Highlight")
    h.Name = "Stipi_ESP_Highlight"
    h.Adornee = char
    h.Parent = workspace
    h.FillTransparency = 0.9
    h.OutlineTransparency = 0
    h.OutlineColor = Color3.fromRGB(0, 200, 80)
    return h
end

local function addESPToPlayer(plr)
    if plr == player then return end
    if espCharacterConns[plr] then espCharacterConns[plr]:Disconnect(); espCharacterConns[plr] = nil end

    espCharacterConns[plr] = plr.CharacterAdded:Connect(function(char)
        if espEnabled then
            local h = createHighlightForCharacter(char)
            espHighlights[plr] = h
        end
    end)

    if plr.Character and espEnabled then
        local h = createHighlightForCharacter(plr.Character)
        espHighlights[plr] = h
    end
end

local function removeESPFromPlayer(plr)
    if espHighlights[plr] then
        pcall(function() espHighlights[plr]:Destroy() end)
        espHighlights[plr] = nil
    end
    if espCharacterConns[plr] then
        espCharacterConns[plr]:Disconnect()
        espCharacterConns[plr] = nil
    end
end

local function enableESP()
    espEnabled = true
    for _, plr in pairs(Players:GetPlayers()) do
        addESPToPlayer(plr)
    end
    if not espPlayerAddedConn then
        espPlayerAddedConn = Players.PlayerAdded:Connect(function(plr) addESPToPlayer(plr) end)
    end
end

local function disableESP()
    espEnabled = false
    if espPlayerAddedConn then espPlayerAddedConn:Disconnect(); espPlayerAddedConn = nil end
    for plr, _ in pairs(espHighlights) do removeESPFromPlayer(plr) end
    espHighlights = {}
end

-- SPEED
local function enableSpeed()
    if not humanoid then return end
    humanoid.WalkSpeed = speedMultiplier
end

local function disableSpeed()
    if not humanoid then return end
    humanoid.WalkSpeed = defaultWalkSpeed
end

-- GUI
local function createUI()
    local gui = Instance.new("ScreenGui")
    gui.Name = "StipiFHub"
    gui.ResetOnSpawn = false
    gui.Parent = player:WaitForChild("PlayerGui")

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 280, 0, 360)
    main.Position = UDim2.new(0.5, -140, 0.5, -180)
    main.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
    main.BorderSizePixel = 0
    main.AnchorPoint = Vector2.new(0, 0)
    main.Parent = gui
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)

    local dragBar = Instance.new("Frame")
    dragBar.Size = UDim2.new(1, 0, 0, 40)
    dragBar.BackgroundColor3 = Color3.fromRGB(36, 36, 42)
    dragBar.BorderSizePixel = 0
    dragBar.Parent = main
    dragBar.Active = true
    dragBar.Draggable = true
    Instance.new("UICorner", dragBar).CornerRadius = UDim.new(0, 8)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 1, 0)
    title.BackgroundTransparency = 1
    title.Text = "🌟 Stipi F Hub"
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Parent = dragBar

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -20, 1, -50)
    scroll.Position = UDim2.new(0, 10, 0, 45)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.ScrollBarThickness = 6
    scroll.Parent = main
    
    Instance.new("UIPadding", scroll).PaddingRight = UDim.new(0, 10)

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 10)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = scroll
    
    local function updateCanvas()
        scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
    updateCanvas()

    local function createCategory(name)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 0, 26)
        lbl.BackgroundTransparency = 1
        lbl.Text = "🔹 " .. name
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 16
        lbl.TextColor3 = Color3.fromRGB(160, 180, 255)
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = scroll
    end

    local function createButton(text, cb)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -8, 0, 34)
        btn.BackgroundColor3 = Color3.fromRGB(36, 36, 40)
        btn.BorderSizePixel = 0
        btn.Text = text
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 15
        btn.TextColor3 = Color3.fromRGB(240, 240, 240)
        btn.Parent = scroll
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        btn.MouseButton1Click:Connect(cb)
        return btn
    end

    -- Movement
    createCategory("Movement")
    local flyButton = createButton("Fly (toggle) [E]", function()
        flyEnabled = not flyEnabled
        if flyEnabled then
            enableFly()
            flyButton.Text = "Fly: ON"
        else
            disableFly()
            flyButton.Text = "Fly: OFF"
        end
    end)
    flyButton.Text = "Fly: OFF"

    local noclipButton = createButton("Noclip (toggle)", function()
        noclipEnabled = not noclipEnabled
        if noclipEnabled then
            enableNoclip()
            noclipButton.Text = "Noclip: ON"
        else
            disableNoclip()
            noclipButton.Text = "Noclip: OFF"
        end
    end)
    noclipButton.Text = "Noclip: OFF"
    
    local speedButton = createButton("Speed (toggle)", function()
        speedEnabled = not speedEnabled
        if speedEnabled then
            enableSpeed()
            speedButton.Text = "Speed: ON"
        else
            disableSpeed()
            speedButton.Text = "Speed: OFF"
        end
    end)
    speedButton.Text = "Speed: OFF"

    -- Visuals
    createCategory("Visuals")
    local espButton = createButton("ESP Players (toggle)", function()
        espEnabled = not espEnabled
        if espEnabled then
            enableESP()
            espButton.Text = "ESP: ON"
        else
            disableESP()
            espButton.Text = "ESP: OFF"
        end
    end)
    espButton.Text = "ESP: OFF"
end

createUI()

-- Bind key E to toggle fly
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == Enum.KeyCode.E then
            flyEnabled = not flyEnabled
            if flyEnabled then enableFly() else disableFly() end
        end
    end
end)

-- clean up on script unload (safety)
local function cleanupAll()
    disableFly()
    disableNoclip()
    disableESP()
    disableSpeed()
end

game:BindToClose(cleanupAll)
