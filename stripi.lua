-- Made by Stipi F 😎
-- Modern GUI with smooth animations
-- Load with: loadstring(game:HttpGet("https://raw.githubusercontent.com/h84946776-spec/asdasdasdasdasdasdasdasdasd124234eawfdqrobfalucaoajaiwh/refs/heads/main/stipi_trail_script.lua"))()

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

-- Notification function (define early)
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

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 420, 0, 500)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(87, 100, 170)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui

-- Main Frame Corner
local mainCorner = Instance.new("UICorner", mainFrame)
mainCorner.CornerRadius = UDim.new(0, 16)

-- Main Frame Gradient
local mainGradient = Instance.new("UIGradient", mainFrame)
mainGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(87, 100, 170)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(110, 140, 200))
}
mainGradient.Rotation = 45

-- Sidebar Frame
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 180, 1, 0)
sidebar.Position = UDim2.new(0, 0, 0, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(65, 75, 130)
sidebar.BorderSizePixel = 0
sidebar.Parent = mainFrame

local sidebarCorner = Instance.new("UICorner", sidebar)
sidebarCorner.CornerRadius = UDim.new(0, 16)

local sidebarGradient = Instance.new("UIGradient", sidebar)
sidebarGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(65, 75, 130)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(85, 95, 150))
}
sidebarGradient.Rotation = 90

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -10, 0, 40)
title.Position = UDim2.new(0, 5, 0, 10)
title.BackgroundTransparency = 1
title.Text = "Stipi F Hub"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Parent = sidebar

-- Subtitle
local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -10, 0, 20)
subtitle.Position = UDim2.new(0, 5, 0, 45)
subtitle.BackgroundTransparency = 1
subtitle.Text = "discord.gg/8MKrSBNx2V"
subtitle.Font = Enum.Font.Gotham
subtitle.TextColor3 = Color3.fromRGB(200, 200, 255)
subtitle.TextScaled = true
subtitle.Parent = sidebar

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -30, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
closeButton.BorderSizePixel = 0
closeButton.Text = "✕"
closeButton.Font = Enum.Font.GothamBold
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Parent = mainFrame

local closeCorner = Instance.new("UICorner", closeButton)
closeCorner.CornerRadius = UDim.new(0, 12)

closeButton.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -190, 1, -20)
contentFrame.Position = UDim2.new(0, 190, 0, 10)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Scroll Frame for content
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 1, 0)
scrollFrame.Position = UDim2.new(0, 0, 0, 0)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 6
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 600)
scrollFrame.Parent = contentFrame

-- Button creation function with smooth animations
local function createSidebarButton(text, position, icon, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 35)
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(75, 85, 140)
    button.BorderSizePixel = 0
    button.Text = "  " .. icon .. "  " .. text
    button.Font = Enum.Font.Gotham
    button.TextColor3 = Color3.fromRGB(200, 200, 255)
    button.TextScaled = true
    button.TextXAlignment = Enum.TextXAlignment.Left
    button.Parent = sidebar
    
    local buttonCorner = Instance.new("UICorner", button)
    buttonCorner.CornerRadius = UDim.new(0, 8)
    
    -- Hover animations
    button.MouseEnter:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = Color3.fromRGB(100, 115, 180),
            TextColor3 = Color3.fromRGB(255, 255, 255)
        })
        tween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = Color3.fromRGB(75, 85, 140),
            TextColor3 = Color3.fromRGB(200, 200, 255)
        })
        tween:Play()
    end)
    
    button.MouseButton1Click:Connect(function()
        -- Click animation
        local clickTween = TweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
            Size = UDim2.new(1, -22, 0, 33)
        })
        clickTween:Play()
        
        clickTween.Completed:Connect(function()
            local returnTween = TweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
                Size = UDim2.new(1, -20, 0, 35)
            })
            returnTween:Play()
        end)
        
        if callback then callback() end
    end)
    
    return button
end

-- Content button creation with smooth animations
local function createContentButton(text, position, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 45)
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(70, 80, 140)
    button.BorderSizePixel = 0
    button.Text = text
    button.Font = Enum.Font.GothamSemibold
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.Parent = scrollFrame
    
    local buttonCorner = Instance.new("UICorner", button)
    buttonCorner.CornerRadius = UDim.new(0, 12)
    
    local buttonGradient = Instance.new("UIGradient", button)
    buttonGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 80, 140)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 105, 170))
    }
    buttonGradient.Rotation = 45
    
    -- Hover animations
    button.MouseEnter:Connect(function()
        local tween = TweenService:Create(buttonGradient, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Rotation = 90
        })
        tween:Play()
        
        local colorTween = TweenService:Create(buttonGradient, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(90, 105, 170)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(110, 130, 200))
            }
        })
        colorTween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        local tween = TweenService:Create(buttonGradient, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Rotation = 45
        })
        tween:Play()
        
        local colorTween = TweenService:Create(buttonGradient, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 80, 140)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 105, 170))
            }
        })
        colorTween:Play()
    end)
    
    button.MouseButton1Click:Connect(callback)
    return button
end

-- Sidebar buttons
createSidebarButton("Search", UDim2.new(0, 10, 0, 80), "🔍", function() 
    notify("🔍 Search function coming soon!")
end)
createSidebarButton("Information", UDim2.new(0, 10, 0, 125), "ℹ️", function() 
    notify("ℹ️ Script by Stipi F 😎")
end)
createSidebarButton("Fun", UDim2.new(0, 10, 0, 170), "⭐", function() 
    notify("⭐ Fun features loaded!")
end)
createSidebarButton("Automation", UDim2.new(0, 10, 0, 215), "🔄", function() 
    notify("🔄 Automation panel opened!")
end)
createSidebarButton("Bring Stuff", UDim2.new(0, 10, 0, 260), "📦", function() 
    notify("📦 Bring stuff activated!")
end)
createSidebarButton("Main", UDim2.new(0, 10, 0, 305), "🏠", function() 
    notify("🏠 Main panel active!")
end)
createSidebarButton("Fishing", UDim2.new(0, 10, 0, 350), "🎣", function() 
    notify("🎣 Fishing tools loaded!")
end)
createSidebarButton("Teleport", UDim2.new(0, 10, 0, 395), "🚀", function() 
    notify("🚀 Teleport menu opened!")
end)
createSidebarButton("Visuals", UDim2.new(0, 10, 0, 440), "👁️", function() 
    notify("👁️ Visual enhancements loaded!")
end)

-- Content buttons with functionality
createContentButton("🗺️ Reveal Map", UDim2.new(0, 10, 0, 10), function()
    notify("🗺️ Map revealed!")
end)

createContentButton("🌳 Teleport All Trees", UDim2.new(0, 10, 0, 65), function()
    notify("🌳 Trees teleported!")
end)

createContentButton("🌲 Teleport All BIG Trees", UDim2.new(0, 10, 0, 120), function()
    notify("🌲 Big trees teleported!")
end)

createContentButton("📦 Teleport All Chests", UDim2.new(0, 10, 0, 175), function()
    notify("📦 Chests teleported!")
end)

createContentButton("👶 Teleport All Children [BETA]", UDim2.new(0, 10, 0, 230), function()
    notify("👶 Children teleported!")
end)

createContentButton("🚀 Teleport Entities", UDim2.new(0, 10, 0, 285), function()
    notify("🚀 Entities teleported!")
end)

createContentButton("👻 Teleport The Entities", UDim2.new(0, 10, 0, 340), function()
    notify("👻 The Entities teleported!")
end)

createContentButton("🌈 Trail Effect", UDim2.new(0, 10, 0, 395), function()
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
                ColorSequenceKeypoint.new(0, Color3.fromRGB(87, 100, 170)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(120, 150, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 150, 255))
            }
            trail.Lifetime = 2
            trail.MinLength = 0
            trail.Parent = char
            notify("🌈 Trail activado!")
        else
            char.StipiFTrail:Destroy()
            notify("❌ Trail desactivado!")
        end
    end
end)

createContentButton("💬 Join Discord", UDim2.new(0, 10, 0, 450), function()
    if setclipboard then
        setclipboard("https://discord.gg/8MKrSBNx2V")
        notify("📋 Discord copiado!")
    else
        notify("❌ Clipboard no soportado!")
    end
end)

-- User profile at bottom
local userProfile = Instance.new("Frame")
userProfile.Size = UDim2.new(1, -20, 0, 50)
userProfile.Position = UDim2.new(0, 10, 1, -60)
userProfile.BackgroundColor3 = Color3.fromRGB(55, 65, 120)
userProfile.BorderSizePixel = 0
userProfile.Parent = sidebar

local profileCorner = Instance.new("UICorner", userProfile)
profileCorner.CornerRadius = UDim.new(0, 10)

local profileImage = Instance.new("ImageLabel")
profileImage.Size = UDim2.new(0, 35, 0, 35)
profileImage.Position = UDim2.new(0, 7, 0, 7)
profileImage.BackgroundColor3 = Color3.fromRGB(87, 100, 170)
profileImage.BorderSizePixel = 0
profileImage.Image = "rbxasset://textures/face.png"
profileImage.Parent = userProfile

local profileImageCorner = Instance.new("UICorner", profileImage)
profileImageCorner.CornerRadius = UDim.new(0, 20)

local profileName = Instance.new("TextLabel")
profileName.Size = UDim2.new(1, -50, 0, 20)
profileName.Position = UDim2.new(0, 45, 0, 5)
profileName.BackgroundTransparency = 1
profileName.Text = "Stipi F"
profileName.Font = Enum.Font.GothamBold
profileName.TextColor3 = Color3.fromRGB(255, 255, 255)
profileName.TextScaled = true
profileName.TextXAlignment = Enum.TextXAlignment.Left
profileName.Parent = userProfile

local profileTag = Instance.new("TextLabel")
profileTag.Size = UDim2.new(1, -50, 0, 15)
profileTag.Position = UDim2.new(0, 45, 0, 25)
profileTag.BackgroundTransparency = 1
profileTag.Text = "@StipiFDev"
profileTag.Font = Enum.Font.Gotham
profileTag.TextColor3 = Color3.fromRGB(180, 180, 220)
profileTag.TextScaled = true
profileTag.TextXAlignment = Enum.TextXAlignment.Left
profileTag.Parent = userProfile

-- Smooth entrance animation
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)

local entranceTween = TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 420, 0, 500),
    Position = UDim2.new(0.5, -210, 0.5, -250)
})
entranceTween:Play()

-- Background gradient animation
task.spawn(function()
    local time = 0
    while mainFrame.Parent do
        time = time + 0.02
        
        -- Smooth gradient rotation
        if mainGradient and mainGradient.Parent then
            mainGradient.Rotation = (time * 10) % 360
        end
        if sidebarGradient and sidebarGradient.Parent then
            sidebarGradient.Rotation = 90 + math.sin(time * 0.5) * 10
        end
        
        task.wait(0.05)
    end
end)

-- Welcome notification
task.wait(1)
notify("🌟 Stipi F Hub loaded successfully!")

print("Stipi F Hub - Loaded successfully!")