-- // SEPTI HUB | Version ONE PIECE
-- // Made by Lemor 😎🔥
-- // Loadstringable y funcional

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("🌟 SEPTI HUB | Version ONE PIECE 🌟", "Ocean")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- // MAIN TAB
local Main = Window:NewTab("Main")
local MainSection = Main:NewSection("⚡ Funciones Principales")

-- Helper
local function GetHumanoid()
    return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
end

local function GetHRP()
    return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end

-- 1. God Mode
MainSection:NewButton("God Mode", "Invencible", function()
    local hum = GetHumanoid()
    if hum then hum.Health = math.huge end
end)

-- 2. Teleport Home
MainSection:NewButton("Teleport Home", "Vuelve al spawn", function()
    local hrp = GetHRP()
    if hrp then hrp.CFrame = CFrame.new(0,10,0) end
end)

-- 3. WalkSpeed
MainSection:NewSlider("WalkSpeed", "Velocidad máxima", 500, 16, function(value)
    local hum = GetHumanoid()
    if hum then hum.WalkSpeed = value end
end)

-- 4. JumpPower
MainSection:NewSlider("JumpPower", "Salta alto", 500, 50, function(value)
    local hum = GetHumanoid()
    if hum then hum.JumpPower = value end
end)

-- 5. Fly Mode
local FlyActive = false
local FlyBV
MainSection:NewToggle("Fly Mode", "Volar", function(state)
    local hrp = GetHRP()
    if hrp then
        if state then
            FlyActive = true
            FlyBV = Instance.new("BodyVelocity")
            FlyBV.MaxForce = Vector3.new(1e5,1e5,1e5)
            FlyBV.Velocity = Vector3.new(0,0,0)
            FlyBV.Parent = hrp
            LocalPlayer.Character.Humanoid.PlatformStand = true
        else
            FlyActive = false
            if FlyBV then FlyBV:Destroy() end
            LocalPlayer.Character.Humanoid.PlatformStand = false
        end
    end
end)

-- 6. ESP Players
local ESPBoxes = {}
MainSection:NewToggle("ESP Players", "Ver jugadores", function(state)
    for i,v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            if state then
                local box = Instance.new("BoxHandleAdornment")
                box.Adornee = v.Character.HumanoidRootPart
                box.Size = Vector3.new(2,5,1)
                box.Color = BrickColor.new("Bright red")
                box.Transparency = 0.5
                box.AlwaysOnTop = true
                box.Parent = v.Character.HumanoidRootPart
                ESPBoxes[v] = box
            else
                if ESPBoxes[v] then ESPBoxes[v]:Destroy() end
            end
        end
    end
end)

-- 7. Remove Fog
MainSection:NewButton("Remove Fog", "Elimina niebla", function()
    game.Lighting.FogEnd = 100000
end)

-- 8. Full Bright
MainSection:NewButton("Full Bright", "Iluminación total", function()
    game.Lighting.Brightness = 5
    game.Lighting.Ambient = Color3.fromRGB(255,255,255)
end)

-- 9. Fireworks
MainSection:NewButton("Fireworks", "Fuegos artificiales", function()
    local hrp = GetHRP()
    if hrp then
        local part = Instance.new("Part", workspace)
        part.Position = hrp.Position + Vector3.new(0,5,0)
        part.Anchored = true
        part.Size = Vector3.new(1,1,1)
        local fire = Instance.new("Fire", part)
        fire.Heat = 10
        fire.Size = 10
        game.Debris:AddItem(part,5)
    end
end)

-- 10. Chat Message
MainSection:NewButton("Broadcast Message", "Envía mensaje", function()
    pcall(function()
        game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("🌟 SEPTI HUB ACTIVADO 🌟", "All")
    end)
end)

-- // FUN TAB
local Fun = Window:NewTab("Fun")
local FunSection = Fun:NewSection("🎉 Diversión")

-- 11. Noclip
local NoclipActive = false
FunSection:NewToggle("Noclip", "Atravesar paredes", function(state)
    NoclipActive = state
end)
RunService.Stepped:Connect(function()
    if NoclipActive and LocalPlayer.Character then
        for _,p in pairs(LocalPlayer.Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
end)

-- 12. Sit
FunSection:NewButton("Sit", "Siéntate instantáneo", function()
    local hrp = GetHRP()
    if hrp then
        local sit = Instance.new("Seat", workspace)
        sit.Position = hrp.Position
        sit.Anchored = true
        LocalPlayer.Character.Humanoid.Sit = true
    end
end)

-- 13. Speed Teleport
FunSection:NewButton("Speed Teleport", "Teletransportate rápido", function()
    local hrp = GetHRP()
    if hrp then
        hrp.CFrame = hrp.CFrame + Vector3.new(50,0,0)
    end
end)

-- 14. Invisible
local InvisibleActive = false
FunSection:NewToggle("Invisible", "Hazte invisible", function(state)
    InvisibleActive = state
    if LocalPlayer.Character then
        for _,p in pairs(LocalPlayer.Character:GetDescendants()) do
            if p:IsA("BasePart") then
                p.Transparency = state and 1 or 0
            end
        end
    end
end)

-- 15. Destroy Tools
FunSection:NewButton("Destroy Tools", "Elimina tus herramientas", function()
    for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
        tool:Destroy()
    end
end)

-- 16. Auto Respawn
local AutoRespawnActive = false
FunSection:NewToggle("Auto Respawn", "Reaparece automáticamente", function(state)
    AutoRespawnActive = state
end)
LocalPlayer.CharacterAdded:Connect(function()
    if AutoRespawnActive then
        LocalPlayer:LoadCharacter()
    end
end)

-- 17. Spin
FunSection:NewButton("Spin", "Gira loco", function()
    local hrp = GetHRP()
    if hrp then hrp.RotVelocity = Vector3.new(0,50,0) end
end)

-- 18. Jump High
FunSection:NewButton("Jump High", "Salto ultra alto", function()
    local hum = GetHumanoid()
    if hum then
        hum.JumpPower = 200
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- 19. Speed Boost
FunSection:NewButton("Speed Boost", "Velocidad ultra rápida", function()
    local hum = GetHumanoid()
    if hum then hum.WalkSpeed = 100 end
end)

-- 20. Reset Character
FunSection:NewButton("Reset Character", "Reinicia personaje", function()
    LocalPlayer:LoadCharacter()
end)
