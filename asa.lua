-- LocalScript: StipiFHub (corregido)
-- Pegar como LocalScript en StarterPlayerScripts o ejecutar con executor que soporte LocalScripts.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- STATE
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:FindFirstChildOfClass("Humanoid")
local hrp = character:FindFirstChild("HumanoidRootPart")

local flyEnabled = false
local noclipEnabled = false
local espEnabled = false

-- internals
local flyBV = nil
local flyConn = nil
local noclipConn = nil
local espHighlights = {}
local espPlayerAddedConn = nil
local espCharacterConns = {}

local flySpeed = 80

-- UTILS
local function safeFindHRP(char)
    return (char and char:FindFirstChild("HumanoidRootPart")) or nil
end

-- HANDLE RESPAWN
local function onCharacterAdded(char)
    character = char
    humanoid = character:WaitForChild("Humanoid")
    hrp = safeFindHRP(character)

    -- If features were enabled, re-enable on the new character
    if flyEnabled then
        -- rebuild BodyVelocity for new HRP
        if flyBV then flyBV:Destroy(); flyBV = nil end
        if flyConn then flyConn:Disconnect(); flyConn = nil end
        -- call enabling function below after HRP ready
    end

    if noclipEnabled then
        -- no special action: noclip loop will apply to new parts next heartbeat
    end

    if espEnabled then
        -- reapply highlights where necessary (Player.CharacterAdded handlers already manage it)
    end
end

player.CharacterAdded:Connect(onCharacterAdded)

-- FLY
local function enableFly()
    if not character then return end
    hrp = safeFindHRP(character)
    if not hrp then return end

    flyBV = Instance.new("BodyVelocity")
    flyBV.Name = "StipiFly_BV"
    flyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    flyBV.P = 1250
    flyBV.Velocity = Vector3.new(0,0,0)
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
end

-- NOCOLLIDE
local function enableNoclip()
    if noclipConn then return end
    noclipConn = RunService.Stepped:Connect(function()
        if not character then return end
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
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
    if not char then return end
    if not char:IsA("Model") then return end
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
    -- cleanup old conn if exists
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
    -- add to all current players
    for _, plr in pairs(Players:GetPlayers()) do
        addESPToPlayer(plr)
    end
    -- listen for new players
    if not espPlayerAddedConn then
        espPlayerAddedConn = Players.PlayerAdded:Connect(function(plr) addESPToPlayer(plr) end)
    end
end

local function disableESP()
    espEnabled = false
    -- remove all highlights and conns
    if espPlayerAddedConn then espPlayerAddedConn:Disconnect(); espPlayerAddedConn = nil end
    for plr, _ in pairs(espHighlights) do removeESPFromPlayer(plr) end
    espHighlights = {}
end

-- GUI
local function createUI()
    local gui = Instance.new("ScreenGui")
    gui.Name = "StipiFHub"
    gui.ResetOnSpawn = false
    gui.Parent = player:WaitForChild("PlayerGui")

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 540, 0, 560)
    main.Position = UDim2.new(0.25, 0, 0.12, 0)
    main.BackgroundColor3 = Color3.fromRGB(18,18,22)
    main.BorderSizePixel = 0
    main.AnchorPoint = Vector2.new(0,0)
    main.Parent = gui
    main.Active = true
    main.Draggable = true

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundColor3 = Color3.fromRGB(30,30,36)
    title.Text = "🌟 Stipi F Hub - Enhanced Edition"
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.TextColor3 = Color3.fromRGB(255,255,255)
    title.Parent = main

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -20, 1, -60)
    scroll.Position = UDim2.new(0, 10, 0, 50)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.CanvasSize = UDim2.new(0,0,0,0)
    scroll.ScrollBarThickness = 8
    scroll.Parent = main

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = scroll

    -- auto-resize canvas
    local function updateCanvas()
        scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
    updateCanvas()

    -- helpers to create category/button
    local function createCategory(name)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 0, 26)
        lbl.BackgroundTransparency = 1
        lbl.Text = "🔹 " .. name
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 16
        lbl.TextColor3 = Color3.fromRGB(160,180,255)
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = scroll
    end

    local function createButton(text, cb)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -8, 0, 34)
        btn.BackgroundColor3 = Color3.fromRGB(36,36,40)
        btn.BorderSizePixel = 0
        btn.Text = text
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 15
        btn.TextColor3 = Color3.fromRGB(240,240,240)
        btn.Parent = scroll
        btn.MouseButton1Click:Connect(cb)
    end

    -- Movement
    createCategory("Movement")
    createButton("Fly (toggle)  [E]", function()
        flyEnabled = not flyEnabled
        if flyEnabled then
            enableFly()
        else
            disableFly()
        end
    end)

    createButton("Noclip (toggle)", function()
        noclipEnabled = not noclipEnabled
        if noclipEnabled then
            enableNoclip()
        else
            disableNoclip()
        end
    end)

    -- Visuals
    createCategory("Visuals")
    createButton("ESP Players (toggle)", function()
        if not espEnabled then
            enableESP()
        else
            disableESP()
        end
    end)
end

createUI()

-- Bind key E to toggle fly (handy)
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
end
game:BindToClose(cleanupAll)
