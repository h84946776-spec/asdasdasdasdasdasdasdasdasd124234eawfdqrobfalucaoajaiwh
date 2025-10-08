-- Main Window
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local Window = Rayfield:CreateWindow({
    Name = "Vyntra Hub | 🗡️",
    LoadingTitle = "Vyntra Hub",
    LoadingSubtitle = "by Lemor",
    ConfigurationSaving = {Enabled = true, FolderName = "VyntraHub", FileName = "Config"},
    KeySystem = false
})

-- Tab
local MovementTab = Window:CreateTab("Movement", 4483362458)
local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local uis = game:GetService("UserInputService")

-------------------
-- FLOAT TOGGLE --
-------------------
local floatParts = {}
local ascentSpeed = 0.6
local followSmoothness = 0.12
local partDistanceBelowFeet = -1.2
local partSize = Vector3.new(2.8,0.6,2.8)
local maxParts = 6
local floatConn

local function makeFloat()
    local p = Instance.new("Part")
    p.Name = "VyntraFloat"
    p.Size = partSize
    p.Anchored = false
    p.CanCollide = true
    p.Material = Enum.Material.Neon
    p.Transparency = 0.15
    p.CastShadow = false
    p.TopSurface = Enum.SurfaceType.Smooth
    p.BottomSurface = Enum.SurfaceType.Smooth
    p.Parent = workspace
    return p
end

local function cleanupFloat()
    for _,v in pairs(floatParts) do
        if v and v.Parent then v:Destroy() end
    end
    floatParts = {}
end

local function getFeetPosition(character)
    local l = character:FindFirstChild("LeftFoot")
    local r = character:FindFirstChild("RightFoot")
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if l and r then return (l.Position+r.Position)/2 end
    if hrp then return hrp.Position end
    return nil
end

MovementTab:CreateToggle({
    Name = "Float",
    CurrentValue = false,
    Callback = function(enabled)
        if enabled then
            cleanupFloat()
            for i=1,maxParts do table.insert(floatParts, makeFloat()) end

            floatConn = RunService.RenderStepped:Connect(function()
                local char = player.Character
                if not char or not char.Parent then return cleanupFloat() end
                local feetPos = getFeetPosition(char)
                if not feetPos then return end

                for i,part in ipairs(floatParts) do
                    local targetY = feetPos.Y + partDistanceBelowFeet + (i-1)*0.35
                    local targetPos = Vector3.new(feetPos.X, targetY, feetPos.Z-(i-1)*0.25)
                    part.CFrame = part.CFrame:Lerp(CFrame.new(targetPos), followSmoothness)
                end
            end)
        else
            if floatConn then floatConn:Disconnect() floatConn = nil end
            cleanupFloat()
        end
    end
})

-------------------
-- ESP TOGGLE --
-------------------
local espParts = {}
local espConn

local function cleanupESP()
    for _,v in pairs(espParts) do
        if v and v.Parent then v:Destroy() end
    end
    espParts = {}
end

local function createESP(plr)
    if plr == player or not plr.Character then return end
    local highlight = Instance.new("BoxHandleAdornment")
    highlight.Adornee = plr.Character:FindFirstChild("HumanoidRootPart") or plr.Character:FindFirstChildWhichIsA("BasePart")
    if not highlight.Adornee then return end
    highlight.Size = Vector3.new(2,5,2)
    highlight.Color3 = Color3.fromRGB(0,255,0)
    highlight.Transparency = 0.5
    highlight.AlwaysOnTop = true
    highlight.ZIndex = 10
    highlight.Parent = workspace
    table.insert(espParts, highlight)
end

MovementTab:CreateToggle({
    Name = "ESP",
    CurrentValue = false,
    Callback = function(enabled)
        if enabled then
            cleanupESP()
            for _,plr in pairs(game.Players:GetPlayers()) do createESP(plr) end
            espConn = RunService.RenderStepped:Connect(function()
                for i,v in pairs(espParts) do
                    if not v.Adornee or not v.Adornee.Parent then v:Destroy() espParts[i]=nil end
                end
            end)
        else
            if espConn then espConn:Disconnect() espConn = nil end
            cleanupESP()
        end
    end
})

--------------------------
-- SPRINT BOOST TOGGLE --
--------------------------
local normalJump = player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.JumpPower or 50
local jumpBoost = 150
local boosted = false

MovementTab:CreateToggle({
    Name = "Sprint Boost",
    CurrentValue = false,
    Callback = function(enabled)
        local char = player.Character or player.CharacterAdded:Wait()
        local humanoid = char:WaitForChild("Humanoid")
        if enabled then
            humanoid.JumpPower = jumpBoost
            boosted = true
        else
            humanoid.JumpPower = normalJump
            boosted = false
        end
        player.CharacterAdded:Connect(function(c)
            local h = c:WaitForChild("Humanoid")
            if boosted then h.JumpPower = jumpBoost end
        end)
    end
})
