local library = loadstring(game:HttpGet(game, "https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/0x"))()
local w1 = library:Window("F4STERHUB | Universal Script")
local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local flying = false
local flySpeed = 50
local bodyVel, bodyGyro
local noclip = false
local noclipConn
local walkSpeedEnabled = false
local walkSpeedValue = 100
local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")

-- Fly
function Fly(state)
    flying = state
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = character.HumanoidRootPart

    if flying then
        bodyVel = Instance.new("BodyVelocity")
        bodyVel.Velocity = Vector3.new(0,0,0)
        bodyVel.MaxForce = Vector3.new(4000,4000,4000)
        bodyVel.Parent = hrp

        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(400000,400000,400000)
        bodyGyro.P = 10000
        bodyGyro.CFrame = hrp.CFrame
        bodyGyro.Parent = hrp

        runService.RenderStepped:Connect(function()
            if flying and bodyVel and bodyGyro then
                local camCF = workspace.CurrentCamera.CFrame
                local moveDir = Vector3.new()
                if uis:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camCF.LookVector end
                if uis:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camCF.LookVector end
                if uis:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camCF.RightVector end
                if uis:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camCF.RightVector end
                if uis:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
                if uis:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0,1,0) end
                bodyVel.Velocity = moveDir * flySpeed
                bodyGyro.CFrame = camCF
            end
        end)
    else
        if bodyVel then bodyVel:Destroy() bodyVel = nil end
        if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
    end
end

w1:Toggle("Fly", "Fly", false, function(toggled)
    Fly(toggled)
end)

-- NoClip
function Noclip(state)
    noclip = state
    if noclip then
        noclipConn = runService.Stepped:Connect(function()
            if noclip and player.Character then
                for _,v in pairs(player.Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConn then
            noclipConn:Disconnect()
            noclipConn = nil
        end
    end
end

w1:Toggle("NoClip", "Walk through walls", false, function(toggled)
    Noclip(toggled)
end)

-- WalkSpeed Toggle
local function UpdateWalkSpeed()
    if humanoid and walkSpeedEnabled then
        humanoid.WalkSpeed = walkSpeedValue
    end
end

w1:Toggle("WalkSpeed", "Enable custom WalkSpeed", false, function(toggled)
    walkSpeedEnabled = toggled
    UpdateWalkSpeed()
end)

-- Reactivar al respawnear
player.CharacterAdded:Connect(function(char)
    humanoid = char:WaitForChild("Humanoid")
    UpdateWalkSpeed()
    humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
        if walkSpeedEnabled and humanoid.WalkSpeed ~= walkSpeedValue then
            humanoid.WalkSpeed = walkSpeedValue
        end
    end)
end)
