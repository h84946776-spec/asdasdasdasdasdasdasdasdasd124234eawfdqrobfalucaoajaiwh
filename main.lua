-- Made by Stipi F 😎
-- Complete modern GUI with all features
-- Load with: loadstring(game:HttpGet("https://raw.githubusercontent.com/h84946776-spec/asdasdasdasdasdasdasdasdasd124234eawfdqrobfalucaoajaiwh/refs/heads/main/stripi.lua"))()

-- Check if GUI already exists and destroy it
local existingGui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("StipiFHub")
if existingGui then
    existingGui:Destroy()
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- Wait for player to load
if not player.Character then
    player.CharacterAdded:Wait()
end

-- Variables
local flySpeed = 50
local isFlying = false
local flyConnection = nil
local espEnabled = false
local espConnections = {}
local noclipEnabled = false
local speedEnabled = false
local jumpEnabled = false

-- Notification function
local function notify(msg)
    pcall(function()
        game.StarterGui:SetCore("SendNotification", {
            Title = "Stipi F Hub",
            Text = msg,
            Duration = 3
        })
    end)
end

-- Create GUI
local gui = Instance.new("ScreenGui")
gui.Name = "StipiFHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Main Background Frame
local backgroundFrame = Instance.new("Frame")
backgroundFrame.Size = UDim2.new(0, 500, 0, 600)
backgroundFrame.Position = UDim2.new(0.5, -250, 0.5, -300)
backgroundFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
backgroundFrame.BorderSizePixel = 0
backgroundFrame.Active = true
backgroundFrame.Draggable = true
backgroundFrame.Parent = gui

local bgCorner = Instance.new("UICorner", backgroundFrame)
bgCorner.CornerRadius = UDim.new(0, 15)

-- Gradient effect
local bgGradient = Instance.new("UIGradient", backgroundFrame)
bgGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 20))
}
bgGradient.Rotation = 135

-- Glowing border
local glowStroke = Instance.new("UIStroke", backgroundFrame)
glowStroke.Thickness = 2
glowStroke.Color = Color3.fromRGB(100, 150, 255)
glowStroke.Transparency = 0.3

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 60)
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
header.BorderSizePixel = 0
header.Parent = backgroundFrame

local headerCorner = Instance.new("UICorner", header)
headerCorner.CornerRadius = UDim.new(0, 15)

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🌟 Stipi F Hub - Premium Edition"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -40, 0, 15)
closeButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
closeButton.BorderSizePixel = 0
closeButton.Text = "✕"
closeButton.Font = Enum.Font.GothamBold
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 16
closeButton.Parent = header

local closeCorner = Instance.new("UICorner", closeButton)
closeCorner.CornerRadius = UDim.new(0, 15)

closeButton.MouseButton1Click:Connect(function()
    local closeTween = TweenService:Create(backgroundFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    })
    closeTween:Play()
    closeTween.Completed:Connect(function()
        gui:Destroy()
    end)
end)

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -30, 1, -90)
contentFrame.Position = UDim2.new(0, 15, 0, 75)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = backgroundFrame

-- Scroll Frame
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 1, 0)
scrollFrame.Position = UDim2.new(0, 0, 0, 0)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 8
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 150, 255)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 800)
scrollFrame.Parent = contentFrame

-- Button creation function
local function createButton(text, position, color1, color2, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.48, 0, 0, 50)
    button.Position = position
    button.BackgroundColor3 = color1
    button.BorderSizePixel = 0
    button.Text = text
    button.Font = Enum.Font.GothamSemibold
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.Parent = scrollFrame
    
    local buttonCorner = Instance.new("UICorner", button)
    buttonCorner.CornerRadius = UDim.new(0, 10)
    
    local buttonGradient = Instance.new("UIGradient", button)
    buttonGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, color1),
        ColorSequenceKeypoint.new(1, color2)
    }
    buttonGradient.Rotation = 45
    
    local buttonStroke = Instance.new("UIStroke", button)
    buttonStroke.Thickness = 1
    buttonStroke.Color = color2
    buttonStroke.Transparency = 0.5
    
    -- Hover animations
    button.MouseEnter:Connect(function()
        local hoverTween = TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0.48, 2, 0, 52)
        })
        hoverTween:Play()
        
        local glowTween = TweenService:Create(buttonStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            Transparency = 0,
            Thickness = 2
        })
        glowTween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        local leaveTween = TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0.48, 0, 0, 50)
        })
        leaveTween:Play()
        
        local unglowTween = TweenService:Create(buttonStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            Transparency = 0.5,
            Thickness = 1
        })
        unglowTween:Play()
    end)
    
    button.MouseButton1Click:Connect(function()
        local clickTween = TweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0.48, -2, 0, 48)
        })
        clickTween:Play()
        
        clickTween.Completed:Connect(function()
            local returnTween = TweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
                Size = UDim2.new(0.48, 0, 0, 50)
            })
            returnTween:Play()
        end)
        
        if callback then callback(button) end
    end)
    
    return button
end

-- Categories
local function createCategory(text, yPos)
    local category = Instance.new("TextLabel")
    category.Size = UDim2.new(1, 0, 0, 30)
    category.Position = UDim2.new(0, 0, 0, yPos)
    category.BackgroundTransparency = 1
    category.Text = text
    category.Font = Enum.Font.GothamBold
    category.TextColor3 = Color3.fromRGB(100, 150, 255)
    category.TextSize = 16
    category.TextXAlignment = Enum.TextXAlignment.Left
    category.Parent = scrollFrame
    
    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 2)
    line.Position = UDim2.new(0, 0, 1, -2)
    line.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    line.BorderSizePixel = 0
    line.Parent = category
    
    local lineCorner = Instance.new("UICorner", line)
    lineCorner.CornerRadius = UDim.new(0, 1)
end

-- Movement Category
createCategory("🚀 Movement & Physics", 10)

createButton("✈️ Fly", UDim2.new(0, 0, 0, 50), Color3.fromRGB(50, 150, 255), Color3.fromRGB(100, 200, 255), function(btn)
    if not isFlying then
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            isFlying = true
            btn.Text = "🛬 Stop Fly"
            
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.Parent = char.HumanoidRootPart
            
            flyConnection = RunService.Heartbeat:Connect(function()
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local camera = workspace.CurrentCamera
                    local velocity = Vector3.new(0, 0, 0)
                    
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        velocity = velocity + (camera.CFrame.LookVector * flySpeed)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        velocity = velocity - (camera.CFrame.LookVector * flySpeed)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        velocity = velocity - (camera.CFrame.RightVector * flySpeed)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        velocity = velocity + (camera.CFrame.RightVector * flySpeed)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        velocity = velocity + Vector3.new(0, flySpeed, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        velocity = velocity - Vector3.new(0, flySpeed, 0)
                    end
                    
                    bodyVelocity.Velocity = velocity
                end
            end)
            
            notify("✈️ Fly activado! WASD + Space/Shift")
        end
    else
        isFlying = false
        btn.Text = "✈️ Fly"
        
        if flyConnection then
            flyConnection:Disconnect()
        end
        
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local bodyVelocity = char.HumanoidRootPart:FindFirstChild("BodyVelocity")
            if bodyVelocity then
                bodyVelocity:Destroy()
            end
        end
        
        notify("🛬 Fly desactivado!")
    end
end)

createButton("💨 Speed", UDim2.new(0.52, 0, 0, 50), Color3.fromRGB(255, 150, 50), Color3.fromRGB(255, 200, 100), function(btn)
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        if not speedEnabled then
            char.Humanoid.WalkSpeed = 100
            btn.Text = "💨 Normal Speed"
            speedEnabled = true
            notify("💨 Velocidad aumentada!")
        else
            char.Humanoid.WalkSpeed = 16
            btn.Text = "💨 Speed"
            speedEnabled = false
            notify("💨 Velocidad normal!")
        end
    end
end)

createButton("🦘 Jump Power", UDim2.new(0, 0, 0, 110), Color3.fromRGB(150, 255, 50), Color3.fromRGB(200, 255, 100), function(btn)
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        if not jumpEnabled then
            char.Humanoid.JumpPower = 200
            btn.Text = "🦘 Normal Jump"
            jumpEnabled = true
            notify("🦘 Salto aumentado!")
        else
            char.Humanoid.JumpPower = 50
            btn.Text = "🦘 Jump Power"
            jumpEnabled = false
            notify("🦘 Salto normal!")
        end
    end
end)

createButton("👻 Noclip", UDim2.new(0.52, 0, 0, 110), Color3.fromRGB(150, 50, 255), Color3.fromRGB(200, 100, 255), function(btn)
    noclipEnabled = not noclipEnabled
    
    if noclipEnabled then
        btn.Text = "👻 Solid Mode"
        notify("👻 Noclip activado!")
    else
        btn.Text = "👻 Noclip"
        notify("👻 Noclip desactivado!")
    end
end)

-- Visual Category
createCategory("👁️ Visual Effects", 180)

createButton("👁️ ESP", UDim2.new(0, 0, 0, 220), Color3.fromRGB(255, 50, 150), Color3.fromRGB(255, 100, 200), function(btn)
    espEnabled = not espEnabled
    
    if espEnabled then
        btn.Text = "👁️ Disable ESP"
        
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= player then
                local function addESP(character)
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        local highlight = Instance.new("Highlight")
                        highlight.Name = "StipiFESP"
                        highlight.Adornee = character
                        highlight.FillColor = Color3.fromRGB(255, 100, 100)
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        highlight.FillTransparency = 0.5
                        highlight.OutlineTransparency = 0
                        highlight.Parent = character
                        
                        local billboard = Instance.new("BillboardGui")
                        billboard.Name = "StipiFNameTag"
                        billboard.Size = UDim2.new(0, 200, 0, 50)
                        billboard.StudsOffset = Vector3.new(0, 3, 0)
                        billboard.Parent = character.HumanoidRootPart
                        
                        local nameLabel = Instance.new("TextLabel")
                        nameLabel.Size = UDim2.new(1, 0, 1, 0)
                        nameLabel.BackgroundTransparency = 1
                        nameLabel.Text = otherPlayer.Name
                        nameLabel.Font = Enum.Font.GothamBold
                        nameLabel.TextColor3 = Color3.new(1, 1, 1)
                        nameLabel.TextStrokeTransparency = 0
                        nameLabel.TextScaled = true
                        nameLabel.Parent = billboard
                    end
                end
                
                if otherPlayer.Character then
                    addESP(otherPlayer.Character)
                end
                
                espConnections[otherPlayer] = otherPlayer.CharacterAdded:Connect(addESP)
            end
        end
        
        notify("👁️ ESP activado!")
    else
        btn.Text = "👁️ ESP"
        
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer.Character then
                local highlight = otherPlayer.Character:FindFirstChild("StipiFESP")
                local nameTag = otherPlayer.Character:FindFirstChild("StipiFNameTag")
                if highlight then highlight:Destroy() end
                if nameTag then nameTag:Destroy() end
            end
        end
        
        for _, connection in pairs(espConnections) do
            connection:Disconnect()
        end
        espConnections = {}
        
        notify("👁️ ESP desactivado!")
    end
end)

createButton("🌈 Trail Effect", UDim2.new(0.52, 0, 0, 220), Color3.fromRGB(255, 100, 255), Color3.fromRGB(255, 150, 255), function(btn)
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        if not char:FindFirstChild("StipiFTrail") then
            local att0 = Instance.new("Attachment", char.HumanoidRootPart)
            local att1 = Instance.new("Attachment", char.HumanoidRootPart)
            att0.Position = Vector3.new(0, 2, 0)
            att1.Position = Vector3.new(0, -2, 0)

            local trail = Instance.new("Trail")
            trail.Name = "StipiFTrail"
            trail.Attachment0 = att0
            trail.Attachment1 = att1
            trail.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 150, 255)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 100, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 150, 100))
            }
            trail.Lifetime = 2
            trail.MinLength = 0
            trail.Parent = char
            btn.Text = "❌ Remove Trail"
            notify("🌈 Trail activado!")
        else
            char.StipiFTrail:Destroy()
            btn.Text = "🌈 Trail Effect"
            notify("❌ Trail removido!")
        end
    end
end)

-- Teleport Category
createCategory("🚀 Teleport Options", 290)

createButton("🏠 Teleport to Spawn", UDim2.new(0, 0, 0, 330), Color3.fromRGB(100, 255, 100), Color3.fromRGB(150, 255, 150), function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(0, 10, 0)
        notify("🏠 Teleported to spawn!")
    end
end)

createButton("🎯 Teleport to Random", UDim2.new(0.52, 0, 0, 330), Color3.fromRGB(255, 255, 100), Color3.fromRGB(255, 255, 150), function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local x = math.random(-500, 500)
        local z = math.random(-500, 500)
        char.HumanoidRootPart.CFrame = CFrame.new(x, 50, z)
        notify("🎯 Teleported to random location!")
    end
end)

-- Utility Category
createCategory("⚙️ Utilities", 400)

createButton("🔄 Reset Character", UDim2.new(0, 0, 0, 440), Color3.fromRGB(255, 150, 100), Color3.fromRGB(255, 200, 150), function()
    player.Character.Humanoid.Health = 0
    notify("🔄 Character reset!")
end)

createButton("💬 Join Discord", UDim2.new(0.52, 0, 0, 440), Color3.fromRGB(88, 101, 242), Color3.fromRGB(120, 150, 255), function()
    if setclipboard then
        setclipboard("https://discord.gg/8MKrSBNx2V")
        notify("📋 Discord link copied!")
    else
        notify("❌ Clipboard not supported!")
    end
end)

createButton("ℹ️ About Script", UDim2.new(0, 0, 0, 500), Color3.fromRGB(150, 150, 150), Color3.fromRGB(200, 200, 200), function()
    notify("👨‍💻 Made by Stipi F 😎 - Premium Edition")
end)

createButton("❌ Close GUI", UDim2.new(0.52, 0, 0, 500), Color3.fromRGB(200, 50, 50), Color3.fromRGB(255, 100, 100), function()
    local closeTween = TweenService:Create(backgroundFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    })
    closeTween:Play()
    closeTween.Completed:Connect(function()
        gui:Destroy()
    end)
end)

-- Noclip functionality
RunService.Stepped:Connect(function()
    if noclipEnabled then
        local char = player.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end
end)

-- Smooth entrance animation
backgroundFrame.Size = UDim2.new(0, 0, 0, 0)
backgroundFrame.Position = UDim2.new(0.5, 0, 0.5, 0)

local entranceTween = TweenService:Create(backgroundFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 500, 0, 600),
    Position = UDim2.new(0.5, -250, 0.5, -300)
})
entranceTween:Play()

-- Glow animation
task.spawn(function()
    local time = 0
    while backgroundFrame.Parent do
        time = time + 0.05
        
        local r = 100 + math.sin(time) * 50
        local g = 150 + math.sin(time + 2) * 50
        local b = 255 + math.sin(time + 4) * 50
        
        glowStroke.Color = Color3.fromRGB(r, g, b)
        
        task.wait(0.05)
    end
end)

-- Welcome notification
task.wait(1)
notify("🌟 Stipi F Hub loaded successfully!")

print("Stipi F Hub - Premium Edition Loaded!")
