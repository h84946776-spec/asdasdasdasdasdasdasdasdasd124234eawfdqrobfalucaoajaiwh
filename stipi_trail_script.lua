-- Made by Stipi F 😎

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "StipiFUniversalTrail"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 350, 0, 220)
frame.Position = UDim2.new(0.3, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BorderSizePixel = 0
frame.Parent = gui

local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(255, 0, 255)

local UIGradient = Instance.new("UIGradient", frame)
UIGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,255)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0,255,255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255,255,0))
}
UIGradient.Rotation = 0

frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "Stipi F | Universal Trail Script"
title.Font = Enum.Font.Arcade
title.TextColor3 = Color3.fromRGB(255, 0, 0)
title.TextScaled = true
title.Parent = frame

local trailButton = Instance.new("TextButton")
trailButton.Size = UDim2.new(0.8, 0, 0, 50)
trailButton.Position = UDim2.new(0.1, 0, 0.35, 0)
trailButton.Text = "Trail"
trailButton.Font = Enum.Font.GothamBlack
trailButton.TextColor3 = Color3.new(1, 1, 1)
trailButton.TextScaled = true
trailButton.Parent = frame
trailButton.BackgroundColor3 = Color3.fromRGB(120, 0, 0)

local copyButton = Instance.new("TextButton")
copyButton.Size = UDim2.new(0.8, 0, 0, 40)
copyButton.Position = UDim2.new(0.1, 0, 0.7, 0)
copyButton.Text = "Connect With Us!"
copyButton.Font = Enum.Font.GothamBold
copyButton.TextColor3 = Color3.new(1, 1, 1)
copyButton.TextScaled = true
copyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
copyButton.Parent = frame

task.spawn(function()
	while task.wait(0.05) do
		frame.BackgroundColor3 = Color3.fromRGB(math.random(0,255), math.random(0,255), math.random(0,255))

		stroke.Thickness = math.random(1,5)
		stroke.Color = Color3.fromRGB(math.random(100,255), math.random(0,255), math.random(100,255))
		UIGradient.Rotation = math.random(0,360)

		title.Position = UDim2.new(0, math.random(-4,4), 0, math.random(-2,2))
		title.TextColor3 = Color3.fromRGB(math.random(150,255), math.random(0,150), math.random(150,255))

		trailButton.Rotation = math.random(-5,5)
		copyButton.Rotation = math.random(-5,5)

		trailButton.BackgroundColor3 = Color3.fromRGB(math.random(200,255), math.random(0,60), math.random(0,60))
		copyButton.BackgroundColor3 = Color3.fromRGB(math.random(0,255), math.random(0,255), math.random(0,255))
	end
end)

local function notify(msg)
	pcall(function()
		game.StarterGui:SetCore("SendNotification", {
			Title = "Stipi F Hub",
			Text = msg,
			Duration = 3
		})
	end)
end

trailButton.MouseButton1Click:Connect(function()
	local char = player.Character or player.CharacterAdded:Wait()
	if char and char:FindFirstChild("HumanoidRootPart") then
		if not char:FindFirstChild("StipiFTrail") then
			local att0 = Instance.new("Attachment", char.HumanoidRootPart)
			local att1 = Instance.new("Attachment", char.HumanoidRootPart)
			att0.Position = Vector3.new(0,2,0)
			att1.Position = Vector3.new(0,-2,0)

			local trail = Instance.new("Trail")
			trail.Name = "StipiFTrail"
			trail.Attachment0 = att0
			trail.Attachment1 = att1
			trail.Color = ColorSequence.new(Color3.new(1,0,0),Color3.new(0,0,1))
			trail.Lifetime = 1
			trail.Parent = char
			notify("Trail By Stipi F 😎")
		else
			notify("Activated!🤫")
		end
	end
end)

copyButton.MouseButton1Click:Connect(function()
	if setclipboard then
		setclipboard("https://discord.gg/8MKrSBNx2V")
		notify("Copied To Clipboard!")
	else
		notify("Clipboard not supported!")
	end
end)