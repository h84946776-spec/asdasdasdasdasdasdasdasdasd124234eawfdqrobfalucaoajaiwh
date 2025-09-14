-- Made by Stipi F 😎
-- Enhanced Complete modern GUI with 30+ features - PART 1
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
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
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
local infiniteJumpEnabled = false
local wallhackEnabled = false
local xrayEnabled = false
local fullbrightEnabled = false
local autoFarmEnabled = false
local autoClickEnabled = false
local godModeEnabled = false
local invisibilityEnabled = false
local magnetEnabled = false
local autoRespawnEnabled = false
local antiAfkEnabled = false
local chatSpamEnabled = false
local rainbowCharacterEnabled = false
local bigHeadEnabled = false
local spinBotEnabled = false
local autoWalkEnabled = false
local clickTeleportEnabled = false
local freeCamEnabled = false
local noFallDamageEnabled = false
local infiniteHealthEnabled = false
local speedHackEnabled = false
local jumpHackEnabled = false
local swimInAirEnabled = false
local autoJumpEnabled = false
local platformStandEnabled = false
local ragdollEnabled = false
local freezeEnabled = false
local highlightAllEnabled = false
local removeTexturesEnabled = false
local fogRemoveEnabled = false
local skyboxChangeEnabled = false
local timeChangeEnabled = false
local gravityChangeEnabled = false

-- Notification function
local function notify(msg)
    pcall(function()
        game.StarterGui:SetCore("SendNotification", {
            Title = "Stipi F Hub Enhanced",
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
backgroundFrame.Size = UDim2.new(0, 650, 0, 750)
backgroundFrame.Position = UDim2.new(0.5, -325, 0.5, -375)
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
title.Size = UDim2.new(1, -120, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🌟 Stipi F Hub - Enhanced Edition (40+ Features)"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- Minimize Button
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -80, 0, 15)
minimizeButton.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
minimizeButton.BorderSizePixel = 0
minimizeButton.Text = "−"
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.TextSize = 16
minimizeButton.Parent = header

local minimizeCorner = Instance.new("UICorner", minimizeButton)
minimizeCorner.CornerRadius = UDim.new(0, 15)

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

-- Minimize functionality
local isMinimized = false
minimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        local minimizeTween = TweenService:Create(backgroundFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 650, 0, 60)
        })
        minimizeTween:Play()
        minimizeButton.Text = "+"
    else
        local expandTween = TweenService:Create(backgroundFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 650, 0, 750)
        })
        expandTween:Play()
        minimizeButton.Text = "−"
    end
end)

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
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 2500)
scrollFrame.Parent = contentFrame

-- Button creation function
local function createButton(text, position, color1, color2, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.31, 0, 0, 45)
    button.Position = position
    button.BackgroundColor3 = color1
    button.BorderSizePixel = 0
    button.Text = text
    button.Font = Enum.Font.GothamSemibold
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 11
    button.TextWrapped = true
    button.Parent = scrollFrame
    
    local buttonCorner = Instance.new("UICorner", button)
    buttonCorner.CornerRadius = UDim.new(0, 8)
    
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
            Size = UDim2.new(0.31, 2, 0, 47)
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
            Size = UDim2.new(0.31, 0, 0, 45)
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
            Size = UDim2.new(0.31, -2, 0, 43)
        })
        clickTween:Play()
        
        clickTween.Completed:Connect(function()
            local returnTween = TweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
                Size = UDim2.new(0.31, 0, 0, 45)
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
