-- 🌟 Stipi F Hub - Stable Edition

-- Servicios
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Borrar GUI anterior si existe
if game.CoreGui:FindFirstChild("StipiFHub") then
    game.CoreGui.StipiFHub:Destroy()
end

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "StipiFHub"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 450, 0, 400)
main.Position = UDim2.new(0.25, 0, 0.2, 0)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.BorderSizePixel = 0
main.Parent = gui
main.Active = true
main.Draggable = true

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
title.Text = "🌟 Stipi F Hub - Stable Edition"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextSize = 16
title.Parent = main

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, 0, 1, -30)
scroll.Position = UDim2.new(0,0,0,30)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 6
scroll.CanvasSize = UDim2.new(0,0,5,0)
scroll.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0,6)
layout.Parent = scroll

-- Funciones de helper
local function createCategory(name)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,-10,0,25)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.GothamBold
    label.TextSize = 18
    label.TextColor3 = Color3.fromRGB(200,200,255)
    label.Text = "🔹 " .. name
    label.Parent = scroll
end

local function createButton(name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-20,0,30)
    btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.Text = name
    btn.Parent = scroll

    btn.MouseButton1Click:Connect(callback)
end

---------------------------------------------------
-- MOVEMENT
---------------------------------------------------
createCategory("Movement")

local flyEnabled = false
createButton("Fly (toggle)", function()
    flyEnabled = not flyEnabled
    print("Fly:", flyEnabled)
end)

RunService.RenderStepped:Connect(function()
    if flyEnabled and character:FindFirstChild("HumanoidRootPart") then
        local hrp = character.HumanoidRootPart
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
end)

local noclipEnabled = false
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

local espEnabled = false
createButton("ESP (toggle)", function()
    espEnabled = not espEnabled
    print("ESP:", espEnabled)
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            if espEnabled then
                if not plr.Character:FindFirstChild("ESP") then
                    local h = Instance.new("Highlight")
                    h.Name = "ESP"
                    h.FillTransparency = 1
                    h.OutlineColor = Color3.fromRGB(0,255,0)
                    h.OutlineTransparency = 0
                    h.Parent = plr.Character
                end
            else
                local h = plr.Character:FindFirstChild("ESP")
                if h then h:Destroy() end
            end
        end
    end
end)

---------------------------------------------------
-- AUTO FIX RESPAWN
---------------------------------------------------
player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = character:WaitForChild("Humanoid")
end)
