-- // SEPTI HUB | Version ONE PIECE
-- // Made by Lemor 😎🔥
-- // Loadstringable con 20 funciones funcionales

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("🌟 SEPTI HUB | Version ONE PIECE 🌟", "Ocean")

-- // MAIN TAB
local Main = Window:NewTab("Main")
local MainSection = Main:NewSection("⚡ Funciones Principales")

-- 1. God Mode
MainSection:NewButton("God Mode", "Invencible", function()
    local plr = game.Players.LocalPlayer
    if plr.Character and plr.Character:FindFirstChild("Humanoid") then
        plr.Character.Humanoid.Health = math.huge
    end
end)

-- 2. Teleport Home
MainSection:NewButton("Teleport Home", "Vuelve al spawn", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0,10,0)
end)

-- 3. WalkSpeed Boost
MainSection:NewSlider("WalkSpeed", "Velocidad máxima", 500, 16, function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)

-- 4. JumpPower Boost
MainSection:NewSlider("JumpPower", "Salta alto", 500, 50, function(value)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
end)

-- 5. Fly Mode
MainSection:NewToggle("Fly Mode", "Volar", function(state)
    local plr = game.Players.LocalPlayer
    if state then
        plr.Character.HumanoidPlatformStand = true
        local bv = Instance.new("BodyVelocity", plr.Character.HumanoidRootPart)
        bv.Velocity = Vector3.new(0,0,0)
        bv.MaxForce = Vector3.new(1e5,1e5,1e5)
    else
        plr.Character.HumanoidPlatformStand = false
        if plr.Character.HumanoidRootPart:FindFirstChild("BodyVelocity") then
            plr.Character.HumanoidRootPart.BodyVelocity:Destroy()
        end
    end
end)

-- 6. ESP Players
MainSection:NewToggle("ESP Players", "Ver jugadores", function(state)
    for i,v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer then
            if state then
                local box = Instance.new("BoxHandleAdornment")
                box.Adornee = v.Character and v.Character:FindFirstChild("HumanoidRootPart") or nil
                box.Size = Vector3.new(2,5,1)
                box.Color = BrickColor.new("Bright red")
                box.Transparency = 0.5
                box.AlwaysOnTop = true
                if box.Adornee then box.Parent = box.Adornee end
            else
                if v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    for _,c in pairs(v.Character.HumanoidRootPart:GetChildren()) do
                        if c:IsA("BoxHandleAdornment") then c:Destroy() end
                    end
                end
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
    local plr = game.Players.LocalPlayer
    local part = Instance.new("Part", workspace)
    part.Position = plr.Character.HumanoidRootPart.Position + Vector3.new(0,5,0)
    part.Anchored = true
    part.Size = Vector3.new(1,1,1)
    local fire = Instance.new("Fire", part)
    fire.Heat = 10
    fire.Size = 10
end)

-- 10. Chat Message
MainSection:NewButton("Broadcast Message", "Envía mensaje", function()
    game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("🌟 SEPTI HUB ACTIVADO 🌟", "All")
end)

-- // FUN TAB
local Fun = Window:NewTab("Fun")
local FunSection = Fun:NewSection("🎉 Diversión")

-- 11. Noclip
FunSection:NewToggle("Noclip", "Atravesar paredes", function(state)
    local plr = game.Players.LocalPlayer
    local runService = game:GetService("RunService")
    local connection
    if state then
        connection = runService.Stepped:Connect(function()
            for _, part in pairs(plr.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
        FunSection.Connection = connection
    else
        if FunSection.Connection then FunSection.Connection:Disconnect() end
        for _, part in pairs(plr.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end)

-- 12. Sit
FunSection:NewButton("Sit", "Siéntate instantáneo", function()
    local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local sit = Instance.new("Seat", workspace)
        sit.Position = hrp.Position
        sit.Anchored = true
        game.Players.LocalPlayer.Character.Humanoid.Sit = true
    end
end)

-- 13. Speed Teleport
FunSection:NewButton("Speed Teleport", "Teletransportate rápido", function()
    local plr = game.Players.LocalPlayer
    plr.Character.HumanoidRootPart.CFrame = CFrame.new(plr.Character.HumanoidRootPart.Position + Vector3.new(50,0,0))
end)

-- 14. Invisible
FunSection:NewToggle("Invisible", "Hazte invisible", function(state)
    local plr = game.Players.LocalPlayer
    if state then
        for _, part in pairs(plr.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.Transparency = 1 end
        end
    else
        for _, part in pairs(plr.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.Transparency = 0 end
        end
    end
end)

-- 15. Destroy Tools
FunSection:NewButton("Destroy Tools", "Elimina tus herramientas", function()
    local plr = game.Players.LocalPlayer
    for _, tool in pairs(plr.Backpack:GetChildren()) do
        tool:Destroy()
    end
end)

-- 16. Auto Respawn
FunSection:NewToggle("Auto Respawn", "Reaparece automáticamente", function(state)
    local plr = game.Players.LocalPlayer
    local connection
    if state then
        connection = plr.Character.Humanoid.Died:Connect(function()
            plr:LoadCharacter()
        end)
        FunSection.RespawnConnection = connection
    else
        if FunSection.RespawnConnection then FunSection.RespawnConnection:Disconnect() end
    end
end)

-- 17. Spin
FunSection:NewButton("Spin", "Gira loco", function()
    local plr = game.Players.LocalPlayer
    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.RotVelocity = Vector3.new(0,50,0)
    end
end)

-- 18. Jump High
FunSection:NewButton("Jump High", "Salto ultra alto", function()
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = 200
    game.Players.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
end)

-- 19. Speed Boost
FunSection:NewButton("Speed Boost", "Velocidad ultra rápida", function()
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 100
end)

-- 20. Reset Character
FunSection:NewButton("Reset Character", "Reinicia personaje", function()
    game.Players.LocalPlayer:LoadCharacter()
end)
