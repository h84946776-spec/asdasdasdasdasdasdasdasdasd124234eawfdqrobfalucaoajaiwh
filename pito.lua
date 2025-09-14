-- Servicios
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Variables de features
local flyEnabled = false
local noclipEnabled = false
local espEnabled = false

-- GUI principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StipiFHub"
ScreenGui.Parent = game.CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 420, 0, 400)
mainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = ScreenGui
mainFrame.Active = true
mainFrame.Draggable = true

-- Título
local titleBar = Instance.new("TextLabel")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
titleBar.Text = "🌟 Stipi F Hub - Enhanced Edition"
titleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
titleBar.Font = Enum.Font.GothamBold
titleBar.TextSize = 16
titleBar.Parent = mainFrame

-- ScrollingFrame
local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1, 0, 1, -30)
scrollingFrame.Position = UDim2.new(0, 0, 0, 30)
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.BorderSizePixel = 0
scrollingFrame.CanvasSize = UDim2.new(0, 0, 5, 0)
scrollingFrame.ScrollBarThickness = 6
scrollingFrame.Parent = mainFrame

-- Layout
local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 6)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = scrollingFrame

-- Crear categoría
local function createCategory(name)
    local categoryLabel = Instance.new("TextLabel")
    categoryLabel.Text = "🔹 " .. name
    categoryLabel.Size = UDim2.new(1, -10, 0, 25)
    categoryLabel.BackgroundTransparency = 1
    categoryLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    categoryLabel.Font = Enum.Font.GothamBold
    categoryLabel.TextSize = 18
    categoryLabel.TextXAlignment = Enum.TextXAlignment.Left
    categoryLabel.Parent = scrollingFrame
end

-- Crear botón
local function createButton(text, callback)
    local button = Instance.new("TextButton")
    button.Text = text
    button.Size = UDim2.new(1, -20, 0, 30)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.Gotham
    button.TextSize = 16
    button.Parent = scrollingFrame

    button.MouseButton1Click:Connect(function()
        callback()
    end)
end

---------------------------------------------------
-- MOVEMENT
---------------------------------------------------
createCategory("Movement")

-- Fly
createButton("Fly (toggle)", function()
    flyEnabled = not flyEnabled
    print("Fly:", flyEnabled)
end)

RunService.RenderStepped:Connect(function()
    if flyEnabled then
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local move = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                move = move + hrp.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                move = move - hrp.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                move = move - hrp.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                move = move + hrp.CFrame.RightVector
            end
            hrp.Velocity = move * 60
        end
    end
end)

-- Noclip
createButton("Noclip (toggle)", function()
    noclipEnabled = not noclipEnabled
    print("Noclip:", noclipEnabled)
end)

RunService.Stepped:Connect(function()
    if noclipEnabled and character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

---------------------------------------------------
-- VISUALS
---------------------------------------------------
createCategory("Visuals")

-- ESP
createButton("ESP Players (toggle)", function()
    espEnabled = not espEnabled
    print("ESP:", espEnabled)

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local highlight = plr.Character:FindFirstChild("ESP") or Instance.new("Highlight")
            highlight.Name = "ESP"
            highlight.FillTransparency = 1
            highlight.OutlineColor = Color3.fromRGB(0, 255, 0)
            highlight.OutlineTransparency = 0
            highlight.Parent = plr.Character

            if not espEnabled then
                highlight:Destroy()
            end
        end
    end
end)
