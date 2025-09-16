local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local uis = game:GetService("UserInputService")

-- Espera a que el personaje cargue
local function waitForCharacter()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        return player.Character
    end
    return player.CharacterAdded:Wait()
end

local character = waitForCharacter()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")

local walkSpeed = 100
humanoid.WalkSpeed = walkSpeed

humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
    if humanoid.WalkSpeed ~= walkSpeed then
        humanoid.WalkSpeed = walkSpeed
    end
end)

-- Fly
local flying = true
local flySpeed = 50
local bodyVel, bodyGyro

local function Fly(state)
    flying = state
    if flying then
        bodyVel = Instance.new("BodyVelocity")
        bodyVel.MaxForce = Vector3.new(4000,4000,4000)
        bodyVel.Velocity = Vector3.new(0,0,0)
        bodyVel.Parent = hrp

        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(400000,400000,400000)
        bodyGyro.P = 10000
        bodyGyro.CFrame = hrp.CFrame
        bodyGyro.Parent = hrp

        runService:BindToRenderStep("FlyStep", Enum.RenderPriority.Character.Value, function()
            if flying then
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
        runService:UnbindFromRenderStep("FlyStep")
        if bodyVel then bodyVel:Destroy() bodyVel = nil end
        if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
    end
end

-- Noclip
local noclip = true
local noclipConn
local function Noclip(state)
    noclip = state
    if noclip then
        noclipConn = runService.Stepped:Connect(function()
            for _,v in pairs(character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end)
    else
        if noclipConn then noclipConn:Disconnect() noclipConn = nil end
    end
end

Fly(true)
Noclip(true)

-- Reactivar al respawnear
player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = character:WaitForChild("Humanoid")
    hrp = character:WaitForChild("HumanoidRootPart")
    humanoid.WalkSpeed = walkSpeed
    Fly(flying)
    Noclip(noclip)
    humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
        if humanoid.WalkSpeed ~= walkSpeed then
            humanoid.WalkSpeed = walkSpeed
        end
    end)
end)
