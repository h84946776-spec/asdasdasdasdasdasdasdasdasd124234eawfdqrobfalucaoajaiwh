-- Master Hub by igGabySyta

-- Load external scripts
loadstring(game:HttpGet("https://raw.githubusercontent.com/Cat558-uz/Chaos-hub-/refs/heads/main/obfuscated_script-1753037381403.lua.txt"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Cat558-uz/CMDS-ADM/refs/heads/main/libray%20cmds%20Adm.lua.txt"))()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Configuration
local CONFIG = {
    Jumpscares = {
        {
            command = {"jumpscare", "jps"},
            imageId = "10755920324",
            soundId = "85271883712040",
            duration = 3
        },
        {
            command = {"jumpscare2", "jps2"},
            imageId = "17817953835",
            soundId = "85271883712040",
            duration = 3
        },
        {
            command = {"jumpscare3", "jps3"},
            imageId = "16372854155",
            soundId = "85271883712040",
            duration = 3
        }
    },
    AllowedUsers = {
        "kit_cynALT",
        "fandofgg",
        "juju_dupix1302"
    }
}

-- Create a lookup table for allowed users
local allowedUsers = {}
for _, username in ipairs(CONFIG.AllowedUsers) do
    allowedUsers[username] = true
end

-- Function to create a jumpscare
local function createJumpscare(player, imageId, soundId, duration)
    local PlayerGui = player:WaitForChild("PlayerGui")
    
    -- Create GUI
    local jumpscareGui = Instance.new("ScreenGui")
    jumpscareGui.Name = "JumpscareGui"
    jumpscareGui.ResetOnSpawn = false
    jumpscareGui.IgnoreGuiInset = true
    jumpscareGui.Parent = PlayerGui

    -- Create image
    local img = Instance.new("ImageLabel")
    img.Size = UDim2.new(1.2, 0, 1.2, 0)
    img.Position = UDim2.new(-0.1, 0, -0.1, 0)
    img.BackgroundTransparency = 1
    img.Image = "rbxassetid://" .. imageId
    img.ZIndex = 999
    img.Parent = jumpscareGui

    -- Create sound
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://" .. soundId
    sound.Volume = 10
    sound.Looped = false
    sound.Parent = workspace
    sound:Play()

    -- Shake effect
    local shaking = true
    task.spawn(function()
        while shaking do
            local x = math.random(-20, 20)
            local y = math.random(-20, 20)
            img.Position = UDim2.new(-0.1, x, -0.1, y)
            task.wait(0.02)
        end
    end)

    -- Cleanup
    task.delay(duration, function()
        shaking = false
        sound:Destroy()
        jumpscareGui:Destroy()
    end)
end

-- Function to find player by partial name
local function findPlayer(partialName)
    partialName = partialName:lower()
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Name:lower():find(partialName) then
            return player
        end
    end
    return nil
end

-- Function to handle chat commands
local function setupChatCommands(player)
    if not allowedUsers[player.Name] then return end

    player.Chatted:Connect(function(message)
        local args = string.split(message, " ")
        if #args < 2 then return end

        local command = args[1]:lower()
        local targetName = args[2]

        -- Check each jumpscare type
        for _, jumpscare in ipairs(CONFIG.Jumpscares) do
            for _, cmd in ipairs(jumpscare.command) do
                if command == ";" .. cmd then
                    local target = findPlayer(targetName)
                    if target and target == player then
                        createJumpscare(
                            target,
                            jumpscare.imageId,
                            jumpscare.soundId,
                            jumpscare.duration
                        )
                    end
                    return
                end
            end
        end
    end)
end

-- Setup chat commands for existing players
for _, player in ipairs(Players:GetPlayers()) do
    setupChatCommands(player)
end

-- Setup chat commands for new players
Players.PlayerAdded:Connect(setupChatCommands)

-- Create RemoteEvent for future expansion
if not ReplicatedStorage:FindFirstChild("MasterHubRemotes") then
    local folder = Instance.new("Folder")
    folder.Name = "MasterHubRemotes"
    folder.Parent = ReplicatedStorage
end

print("Master Hub by igGabySyta loaded successfully!")
