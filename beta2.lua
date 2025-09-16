local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "F4STERHUB | Universal Script",
   LoadingTitle = "F4STERHUB",
   LoadingSubtitle = "by Lemor 😎🔥",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "F4STERHUB",
      FileName = "Config"
   },
   KeySystem = false,
   Theme = "Serenity"
})

local MainTab = Window:CreateTab("Main", 4483362458)
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local runService = game:GetService("RunService")
local uis = game:GetService("UserInputService")

-- Fly
local flying = false
local flySpeed = 50
local bodyVel, bodyGyro
local flyConn

local function Fly(state)
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

        flyConn = runService.RenderStepped:Connect(function()
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
        if flyConn then flyConn:Disconnect() flyConn = nil end
    end
end

MainTab:CreateToggle({
   Name = "Fly",
   CurrentValue = false,
   Flag = "FlyToggle",
   Callback = function(toggled)
      Fly(toggled)
   end
})

-- NoClip
local noclip = false
local noclipConn

local function Noclip(state)
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

MainTab:CreateToggle({
   Name = "NoClip",
   CurrentValue = false,
   Flag = "NoClipToggle",
   Callback = function(toggled)
      Noclip(toggled)
   end
})

-- ESP
local Settings = {
    Color = Color3.fromRGB(0, 255, 0),
    Thickness = 1,
    Transparency = 1,
    AutoThickness = true,
    Length = 15,
    Smoothness = 0.2
}

local ESPEnabled = false
local camera = workspace.CurrentCamera

local function ESP(plr)
    local line = Drawing.new("Line")
    line.Visible = false
    line.Color = Settings.Color
    line.Thickness = Settings.Thickness
    line.Transparency = Settings.Transparency

    local connection
    connection = runService.RenderStepped:Connect(function()
        if ESPEnabled 
        and plr.Character 
        and plr.Character:FindFirstChild("Humanoid") 
        and plr.Character:FindFirstChild("HumanoidRootPart") 
        and plr.Character.Humanoid.Health > 0 
        and plr.Character:FindFirstChild("Head") then
            
            local headpos, OnScreen = camera:WorldToViewportPoint(plr.Character.Head.Position)
            if OnScreen then
                line.From = Vector2.new(headpos.X, headpos.Y)

                if Settings.AutoThickness then
                    local distance = (player.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                    local value = math.clamp(1/distance*100, 0.1, 3)
                    line.Thickness = value
                end

                local dir = plr.Character.Head.CFrame * CFrame.new(0, 0, -Settings.Length)
                local dirpos, vis = camera:WorldToViewportPoint(dir.Position)
                if vis then
                    line.To = Vector2.new(dirpos.X, dirpos.Y)
                    line.Visible = true
                else
                    line.Visible = false
                end
            else
                line.Visible = false
            end
        else
            line.Visible = false
            if not Players:FindFirstChild(plr.Name) then
                connection:Disconnect()
            end
        end
    end)
end

for _, v in pairs(Players:GetPlayers()) do
    if v.Name ~= player.Name then
        coroutine.wrap(ESP)(v)
    end
end

Players.PlayerAdded:Connect(function(newplr)
    if newplr.Name ~= player.Name then
        coroutine.wrap(ESP)(newplr)
    end
end)

MainTab:CreateToggle({
    Name = "ESP",
    CurrentValue = false,
    Flag = "ESP_Toggle",
    Callback = function(state)
        ESPEnabled = state
    end
})
