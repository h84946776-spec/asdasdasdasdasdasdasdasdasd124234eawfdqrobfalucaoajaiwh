local Tab = Window:CreateTab("Movement", 0)

local sectionFloat = Tab:CreateSection("Float Platform")
local sectionHelper = Tab:CreateSection("Steal Helper |💰|")
local sectionMovement = Tab:CreateSection("Movement Enhancements")

-- FLOAT TOGGLE
local FloatToggle
do
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local player = Players.LocalPlayer

    local floatParts = {}
    local ascentSpeed = 0.6        
    local followSmoothness = 0.12  
    local partDistanceBelowFeet = -1.2
    local partSize = Vector3.new(2.8, 0.6, 2.8)
    local maxParts = 6
    local conn
    local ascendOffset = 0

    local function getFeetPositions(character)
        local l = character:FindFirstChild("LeftFoot")
        local r = character:FindFirstChild("RightFoot")
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if l and r and l:IsA("BasePart") and r:IsA("BasePart") then
            return (l.Position + r.Position) / 2
        elseif hrp and hrp:IsA("BasePart") then
            return hrp.Position
        end
        return nil
    end

    local function makeFloat()
        local p = Instance.new("Part")
        p.Name = "VyntraFloat"
        p.Size = partSize
        p.CanCollide = true
        p.Anchored = false
        p.Material = Enum.Material.Neon
        p.Transparency = 0.15
        p.CastShadow = false
        p.TopSurface = Enum.SurfaceType.Smooth
        p.BottomSurface = Enum.SurfaceType.Smooth
        p.Parent = workspace
        return p
    end

    local function cleanup()
        for _,v in ipairs(floatParts) do
            if v and v.Parent then
                v:Destroy()
            end
        end
        floatParts = {}
        if conn then conn:Disconnect() conn = nil end
        ascendOffset = 0
    end

    local function startFloating()
        cleanup()
        for i = 1, maxParts do
            table.insert(floatParts, makeFloat())
        end

        conn = RunService.RenderStepped:Connect(function(dt)
            local character = player.Character
            if not character or not character.Parent then
                cleanup()
                return
            end

            local feetPos = getFeetPositions(character)
            if not feetPos then return end

            ascendOffset = ascendOffset + ascentSpeed * dt

            for i, part in ipairs(floatParts) do
                if not part or not part.Parent then
                    floatParts[i] = makeFloat()
                    part = floatParts[i]
                end
                local targetY = feetPos.Y + partDistanceBelowFeet + ascendOffset - (i - 1) * 0.35
                local targetPos = Vector3.new(feetPos.X, targetY, feetPos.Z - (i - 1) * 0.25)
                part.CFrame = part.CFrame:Lerp(CFrame.new(targetPos), followSmoothness)
                part.Velocity = Vector3.new()
            end
        end)
    end

    FloatToggle = Tab:CreateToggle({
        Name = "Float",
        Info = "Packetfly (Minecraft reference lol)",
        CurrentValue = false,
        Callback = function(enabled)
            if enabled then
                startFloating()
            else
                cleanup()
            end
        end
    })

    player.CharacterAdded:Connect(function()
        if FloatToggle.CurrentValue then
            startFloating()
        end
    end)

    player.CharacterRemoving:Connect(function()
        cleanup()
    end)
end

-- ESP TOGGLE
local ESPToggle
do
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local player = Players.LocalPlayer

    local espParts = {}
    local conn

    local function cleanupESP()
        for _, part in pairs(espParts) do
            if part and part.Parent then
                part:Destroy()
            end
        end
        espParts = {}
        if conn then conn:Disconnect() conn = nil end
    end

    local function createESP(plr)
        if plr == player then return end
        if not plr.Character then return end
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

    ESPToggle = Tab:CreateToggle({
        Name = "ESP",
        Info = "ESP 🔥",
        CurrentValue = false,
        Callback = function(enabled)
            cleanupESP()
            if enabled then
                for _, plr in pairs(Players:GetPlayers()) do
                    createESP(plr)
                end
                Players.PlayerAdded:Connect(createESP)
                Players.PlayerRemoving:Connect(function(plr)
                    for i = #espParts, 1, -1 do
                        local part = espParts[i]
                        if part.Adornee and part.Adornee.Parent == plr.Character then
                            part:Destroy()
                            table.remove(espParts, i)
                        end
                    end
                end)
                conn = RunService.RenderStepped:Connect(function()
                    for i = #espParts, 1, -1 do
                        local part = espParts[i]
                        if not part.Adornee or not part.Adornee.Parent then
                            part:Destroy()
                            table.remove(espParts, i)
                        end
                    end
                end)
            end
        end
    })
end
