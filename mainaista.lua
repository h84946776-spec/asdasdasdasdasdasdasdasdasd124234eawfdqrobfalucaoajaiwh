-- PART 2: Movement & Combat Features

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
            
            notify("✈️ Fly activated! WASD + Space/Shift")
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
        
        notify("🛬 Fly disabled!")
    end
end)

createButton("💨 Speed", UDim2.new(0.345, 0, 0, 50), Color3.fromRGB(255, 150, 50), Color3.fromRGB(255, 200, 100), function(btn)
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        if not speedEnabled then
            char.Humanoid.WalkSpeed = 100
            btn.Text = "💨 Normal Speed"
            speedEnabled = true
            notify("💨 Speed increased!")
        else
            char.Humanoid.WalkSpeed = 16
            btn.Text = "💨 Speed"
            speedEnabled = false
            notify("💨 Normal speed!")
        end
    end
end)

createButton("🦘 Jump Power", UDim2.new(0.69, 0, 0, 50), Color3.fromRGB(150, 255, 50), Color3.fromRGB(200, 255, 100), function(btn)
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        if not jumpEnabled then
            char.Humanoid.JumpPower = 200
            btn.Text = "🦘 Normal Jump"
            jumpEnabled = true
            notify("🦘 Jump power increased!")
        else
            char.Humanoid.JumpPower = 50
            btn.Text = "🦘 Jump Power"
            jumpEnabled = false
            notify("🦘 Normal jump!")
        end
    end
end)

createButton("👻 Noclip", UDim2.new(0, 0, 0, 105), Color3.fromRGB(150, 50, 255), Color3.fromRGB(200, 100, 255), function(btn)
    noclipEnabled = not noclipEnabled
    
    if noclipEnabled then
        btn.Text = "👻 Solid Mode"
        notify("👻 Noclip activated!")
    else
        btn.Text = "👻 Noclip"
        notify("👻 Noclip disabled!")
    end
end)

createButton("🌊 Swim in Air", UDim2.new(0.345, 0, 0, 105), Color3.fromRGB(50, 200, 255), Color3.fromRGB(100, 220, 255), function(btn)
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        if not swimInAirEnabled then
            char.Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
            btn.Text = "🌊 Stop Swimming"
            swimInAirEnabled = true
            notify("🌊 Swimming in air!")
        else
            char.Humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
            btn.Text = "🌊 Swim in Air"
            swimInAirEnabled = false
            notify("🌊 Normal movement!")
        end
    end
end)

createButton("♾️ Infinite Jump", UDim2.new(0.69, 0, 0, 105), Color3.fromRGB(255, 100, 200), Color3.fromRGB(255, 150, 220), function(btn)
    infiniteJumpEnabled = not infiniteJumpEnabled
    
    if infiniteJumpEnabled then
        btn.Text = "♾️ Normal Jump"
        notify("♾️ Infinite jump enabled!")
    else
        btn.Text = "♾️ Infinite Jump"
        notify("♾️ Infinite jump disabled!")
    end
end)

createButton("🚶 Auto Walk", UDim2.new(0, 0, 0, 160), Color3.fromRGB(100, 255, 200), Color3.fromRGB(150, 255, 220), function(btn)
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        if not autoWalkEnabled then
            char.Humanoid:Move(Vector3.new(0, 0, -1), true)
            btn.Text = "🚶 Stop Auto Walk"
            autoWalkEnabled = true
            notify("🚶 Auto walk enabled!")
        else
            char.Humanoid:Move(Vector3.new(0, 0, 0), true)
            btn.Text = "🚶 Auto Walk"
            autoWalkEnabled = false
            notify("🚶 Auto walk disabled!")
        end
    end
end)

createButton("🔄 Auto Jump", UDim2.new(0.345, 0, 0, 160), Color3.fromRGB(255, 200, 100), Color3.fromRGB(255, 220, 150), function(btn)
    autoJumpEnabled = not autoJumpEnabled
    
    if autoJumpEnabled then
        btn.Text = "🔄 Stop Auto Jump"
        notify("🔄 Auto jump enabled!")
    else
        btn.Text = "🔄 Auto Jump"
        notify("🔄 Auto jump disabled!")
    end
end)

createButton("🧊 Platform Stand", UDim2.new(0.69, 0, 0, 160), Color3.fromRGB(150, 200, 255), Color3.fromRGB(200, 220, 255), function(btn)
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        if not platformStandEnabled then
            char.Humanoid:ChangeState(Enum.HumanoidStateType.PlatformStanding)
            btn.Text = "🧊 Normal Stand"
            platformStandEnabled = true
            notify("🧊 Platform stand enabled!")
        else
            char.Humanoid:ChangeState(Enum.HumanoidStateType.Running)
            btn.Text = "🧊 Platform Stand"
            platformStandEnabled = false
            notify("🧊 Normal standing!")
        end
    end
end)

-- Combat Category
createCategory("⚔️ Combat & Protection", 230)

createButton("🛡️ God Mode", UDim2.new(0, 0, 0, 270), Color3.fromRGB(255, 215, 0), Color3.fromRGB(255, 235, 50), function(btn)
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        if not godModeEnabled then
            char.Humanoid.MaxHealth = math.huge
            char.Humanoid.Health = math.huge
            btn.Text = "🛡️ Disable God"
            godModeEnabled = true
            notify("🛡️ God Mode activated!")
        else
            char.Humanoid.MaxHealth = 100
            char.Humanoid.Health = 100
            btn.Text = "🛡️ God Mode"
            godModeEnabled = false
            notify("🛡️ God Mode disabled!")
        end
    end
end)

createButton("👤 Invisibility", UDim2.new(0.345, 0, 0, 270), Color3.fromRGB(100, 100, 100), Color3.fromRGB(150, 150, 150), function(btn)
    local char = player.Character
    if char then
        if not invisibilityEnabled then
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.Transparency = 1
                elseif part:IsA("Accessory") then
                    part.Handle.Transparency = 1
                end
            end
            if char:FindFirstChild("Head") and char.Head:FindFirstChild("face") then
                char.Head.face.Transparency = 1
            end
            btn.Text = "👤 Visible"
            invisibilityEnabled = true
            notify("👤 Invisibility activated!")
        else
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.Transparency = 0
                elseif part:IsA("Accessory") then
                    part.Handle.Transparency = 0
                end
            end
            if char:FindFirstChild("Head") and char.Head:FindFirstChild("face") then
                char.Head.face.Transparency = 0
            end
            btn.Text = "👤 Invisibility"
            invisibilityEnabled = false
            notify("👤 Invisibility disabled!")
        end
    end
end)

createButton("🧲 Magnet Items", UDim2.new(0.69, 0, 0, 270), Color3.fromRGB(255, 50, 100), Color3.fromRGB(255, 100, 150), function(btn)
    magnetEnabled = not magnetEnabled
    
    if magnetEnabled then
        btn.Text = "🧲 Stop Magnet"
        notify("🧲 Item magnet enabled!")
    else
        btn.Text = "🧲 Magnet Items"
        notify("🧲 Item magnet disabled!")
    end
end)

createButton("🔄 Auto Respawn", UDim2.new(0, 0, 0, 325), Color3.fromRGB(50, 255, 150), Color3.fromRGB(100, 255, 200), function(btn)
    autoRespawnEnabled = not autoRespawnEnabled
    
    if autoRespawnEnabled then
        btn.Text = "🔄 Stop Auto Respawn"
        notify("🔄 Auto respawn enabled!")
    else
        btn.Text = "🔄 Auto Respawn"
        notify("🔄 Auto respawn disabled!")
    end
end)

createButton("🛡️ No Fall Damage", UDim2.new(0.345, 0, 0, 325), Color3.fromRGB(100, 255, 100), Color3.fromRGB(150, 255, 150), function(btn)
    noFallDamageEnabled = not noFallDamageEnabled
    
    if noFallDamageEnabled then
        btn.Text = "🛡️ Normal Fall"
        notify("🛡️ No fall damage enabled!")
    else
        btn.Text = "🛡️ No Fall Damage"
        notify("🛡️ No fall damage disabled!")
    end
end)

createButton("❤️ Infinite Health", UDim2.new(0.69, 0, 0, 325), Color3.fromRGB(255, 50, 50), Color3.fromRGB(255, 100, 100), function(btn)
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        if not infiniteHealthEnabled then
            char.Humanoid.MaxHealth = 999999
            char.Humanoid.Health = 999999
            btn.Text = "❤️ Normal Health"
            infiniteHealthEnabled = true
            notify("❤️ Infinite health enabled!")
        else
            char.Humanoid.MaxHealth = 100
            char.Humanoid.Health = 100
            btn.Text = "❤️ Infinite Health"
            infiniteHealthEnabled = false
            notify("❤️ Normal health restored!")
        end
    end
end)

createButton("🎯 Auto Click", UDim2.new(0, 0, 0, 380), Color3.fromRGB(255, 150, 255), Color3.fromRGB(255, 200, 255), function(btn)
    autoClickEnabled = not autoClickEnabled
    
    if autoClickEnabled then
        btn.Text = "🎯 Stop Auto Click"
        notify("🎯 Auto click enabled!")
    else
        btn.Text = "🎯 Auto Click"
        notify("🎯 Auto click disabled!")
    end
end)

createButton("🧊 Freeze Character", UDim2.new(0.345, 0, 0, 380), Color3.fromRGB(100, 200, 255), Color3.fromRGB(150, 220, 255), function(btn)
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        if not freezeEnabled then
            char.HumanoidRootPart.Anchored = true
            btn.Text = "🧊 Unfreeze"
            freezeEnabled = true
            notify("🧊 Character frozen!")
        else
            char.HumanoidRootPart.Anchored = false
            btn.Text = "🧊 Freeze Character"
            freezeEnabled = false
            notify("🧊 Character unfrozen!")
        end
    end
end)

createButton("💀 Ragdoll", UDim2.new(0.69, 0, 0, 380), Color3.fromRGB(150, 100, 50), Color3.fromRGB(200, 150, 100), function(btn)
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        if not ragdollEnabled then
            char.Humanoid:ChangeState(Enum.HumanoidStateType.Ragdoll)
            btn.Text = "💀 Stop Ragdoll"
            ragdollEnabled = true
            notify("💀 Ragdoll enabled!")
        else
            char.Humanoid:ChangeState(Enum.HumanoidStateType.Running)
            btn.Text = "💀 Ragdoll"
            ragdollEnabled = false
            notify("💀 Ragdoll disabled!")
        end
    end
end)
