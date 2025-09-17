-- Carga Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Ventana principal
local Window = Rayfield:CreateWindow({
   Name = "F4STERHUB | Universal Script",
   LoadingTitle = "F4STERHUB",
   LoadingSubtitle = "by Lemor 😎🔥",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "F4STERHUB",
      FileName = "Config"
   },
   KeySystem = false
})

-- Tab principal
local MainTab = Window:CreateTab("Main", 4483362458)
local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local uis = game:GetService("UserInputService")

-- Fly system
local flying = false
local flySpeed = 50
local bodyVel, bodyGyro

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

        runService.RenderStepped:Connect(function()
            if flying and bodyVel and bodyGyro then
                local camCF = workspace.CurrentCamera.CFrame
                local moveDir = Vector3.new()

                if uis:IsKeyDown(Enum.KeyCode.W) then
                    moveDir = moveDir + camCF.LookVector
                end
                if uis:IsKeyDown(Enum.KeyCode.S) then
                    moveDir = moveDir - camCF.LookVector
                end
                if uis:IsKeyDown(Enum.KeyCode.A) then
                    moveDir = moveDir - camCF.RightVector
                end
                if uis:IsKeyDown(Enum.KeyCode.D) then
                    moveDir = moveDir + camCF.RightVector
                end
                if uis:IsKeyDown(Enum.KeyCode.Space) then
                    moveDir = moveDir + Vector3.new(0,1,0)
                end
                if uis:IsKeyDown(Enum.KeyCode.LeftShift) then
                    moveDir = moveDir - Vector3.new(0,1,0)
                end

                bodyVel.Velocity = moveDir * flySpeed
                bodyGyro.CFrame = camCF
            end
        end)
    else
        if bodyVel then bodyVel:Destroy() bodyVel = nil end
        if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
    end
end

-- Toggle Fly
MainTab:CreateToggle({
   Name = "Fly",
   CurrentValue = false,
   Flag = "FlyToggle",
   Callback = function(toggled)
      Fly(toggled)
   end
})

-- NoClip system
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

-- Toggle NoClip
MainTab:CreateToggle({
   Name = "NoClip",
   CurrentValue = false,
   Flag = "NoClipToggle",
   Callback = function(toggled)
      Noclip(toggled)
   end
})

------------------------------------------------------
-- EXTRA TOGGLES (5 nuevas funciones)
------------------------------------------------------

-- Infinite Jump
local infJump = false
uis.JumpRequest:Connect(function()
    if infJump and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

MainTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Flag = "InfJumpToggle",
   Callback = function(toggled)
      infJump = toggled
   end
})

-- SpeedHack
local normalSpeed = 16
local fastSpeed = 50
local speedHack = false

MainTab:CreateToggle({
   Name = "SpeedHack",
   CurrentValue = false,
   Flag = "SpeedHackToggle",
   Callback = function(toggled)
      speedHack = toggled
      if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
         player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = toggled and fastSpeed or normalSpeed
      end
   end
})

-- High Jump
local normalJump = 50
local highJumpValue = 150

MainTab:CreateToggle({
   Name = "High Jump",
   CurrentValue = false,
   Flag = "HighJumpToggle",
   Callback = function(toggled)
      if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
         player.Character:FindFirstChildOfClass("Humanoid").JumpPower = toggled and highJumpValue or normalJump
      end
   end
})

-- ESP Names
local espEnabled = false
local espConnections = {}

local function toggleESP(state)
    espEnabled = state
    if espEnabled then
        for _,plr in pairs(game.Players:GetPlayers()) do
            if plr ~= player and plr.Character and plr.Character:FindFirstChild("Head") then
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "ESPName"
                billboard.Size = UDim2.new(0,200,0,50)
                billboard.AlwaysOnTop = true
                billboard.Parent = plr.Character.Head

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1,0,1,0)
                label.BackgroundTransparency = 1
                label.Text = plr.Name
                label.TextColor3 = Color3.fromRGB(255,0,0)
                label.TextScaled = true
                label.Parent = billboard
            end
        end
        table.insert(espConnections, game.Players.PlayerAdded:Connect(function(plr)
            plr.CharacterAdded:Connect(function(char)
                repeat task.wait() until char:FindFirstChild("Head")
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "ESPName"
                billboard.Size = UDim2.new(0,200,0,50)
                billboard.AlwaysOnTop = true
                billboard.Parent = char.Head

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1,0,1,0)
                label.BackgroundTransparency = 1
                label.Text = plr.Name
                label.TextColor3 = Color3.fromRGB(255,0,0)
                label.TextScaled = true
                label.Parent = billboard
            end)
        end))
    else
        for _,plr in pairs(game.Players:GetPlayers()) do
            if plr.Character and plr.Character:FindFirstChild("Head") then
                if plr.Character.Head:FindFirstChild("ESPName") then
                    plr.Character.Head.ESPName:Destroy()
                end
            end
        end
        for _,c in pairs(espConnections) do
            c:Disconnect()
        end
        espConnections = {}
    end
end

MainTab:CreateToggle({
   Name = "ESP Names",
   CurrentValue = false,
   Flag = "ESPToggle",
   Callback = function(toggled)
      toggleESP(toggled)
   end
})

-- Anti AFK
local antiAFK = false
local afkConn

local function toggleAntiAFK(state)
    antiAFK = state
    if antiAFK then
        afkConn = player.Idled:Connect(function()
            game:GetService("VirtualUser"):CaptureController()
            game:GetService("VirtualUser"):ClickButton2(Vector2.new())
        end)
    else
        if afkConn then afkConn:Disconnect() afkConn = nil end
    end
end

MainTab:CreateToggle({
   Name = "Anti AFK",
   CurrentValue = false,
   Flag = "AntiAFKToggle",
   Callback = function(toggled)
      toggleAntiAFK(toggled)
   end
})
