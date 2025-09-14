-- Roblox Item Spawner Script (No Visual)
-- Spawnea items automáticamente en "Steal a Brainrot"
-- Sin interfaz visual - Solo comandos de chat

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local backpack = player:WaitForChild("Backpack")

-- Variables del spawner
local spawnerEnabled = true
local autoSpawnEnabled = false
local spawnDistance = 5
local spawnHeight = 2

-- Lista de items para spawnear
local itemsToSpawn = {
    -- Brainrots
    "Brainrot",
    "Ohio Brainrot",
    "Sigma Brainrot",
    "Skibidi Brainrot",
    "Gyatt Brainrot",
    "Rizz Brainrot",
    
    -- Items especiales
    "Clonador",
    "Clone Tool",
    "Duplicator",
    "Speed Coil",
    "Teleport Tool",
    "Gravity Coil",
    "Jump Tool",
    
    -- Armas/Tools
    "Sword",
    "Rocket Launcher",
    "Laser Gun",
    "Freeze Ray",
    "Delete Tool",
    "Build Tool",
    
    -- Items raros
    "Golden Brainrot",
    "Rainbow Brainrot",
    "Admin Commands",
    "Fly Tool",
    "Noclip Tool",
    "Infinite Jump"
}

-- Función para crear un item básico
local function createBasicItem(itemName, position)
    local tool = Instance.new("Tool")
    tool.Name = itemName
    tool.RequiresHandle = true
    tool.CanBeDropped = true
    
    -- Crear handle
    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(1, 1, 4)
    handle.Material = Enum.Material.Neon
    handle.BrickColor = BrickColor.Random()
    handle.Shape = Enum.PartType.Block
    handle.TopSurface = Enum.SurfaceType.Smooth
    handle.BottomSurface = Enum.SurfaceType.Smooth
    handle.CanCollide = false
    handle.Position = position
    handle.Parent = tool
    
    -- Agregar efectos visuales
    local pointLight = Instance.new("PointLight")
    pointLight.Color = Color3.fromRGB(math.random(0,255), math.random(0,255), math.random(0,255))
    pointLight.Brightness = 2
    pointLight.Range = 10
    pointLight.Parent = handle
    
    -- Sonido al equipar
    local equipSound = Instance.new("Sound")
    equipSound.SoundId = "rbxasset://sounds/electronicpingshort.wav"
    equipSound.Volume = 0.5
    equipSound.Parent = handle
    
    -- Script de funcionalidad básica
    local script = Instance.new("LocalScript")
    script.Source = [[
        local tool = script.Parent
        local handle = tool:WaitForChild("Handle")
        local equipSound = handle:FindFirstChild("Sound")
        
        tool.Equipped:Connect(function()
            if equipSound then
                equipSound:Play()
            end
            print("]] .. itemName .. [[ equipado!")
        end)
        
        tool.Activated:Connect(function()
            print("Usando ]] .. itemName .. [[!")
            -- Agregar efectos especiales según el item
            local effectName = "]] .. itemName:lower() .. [["
            if effectName:find("speed") then
                local humanoid = tool.Parent:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = 50
                    wait(5)
                    humanoid.WalkSpeed = 16
                end
            elseif effectName:find("jump") then
                local humanoid = tool.Parent:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.JumpPower = 100
                    wait(5)
                    humanoid.JumpPower = 50
                end
            elseif effectName:find("clone") or effectName:find("duplicat") then
                local character = tool.Parent
                if character then
                    local clone = character:Clone()
                    clone.Parent = workspace
                    clone.HumanoidRootPart.Position = character.HumanoidRootPart.Position + Vector3.new(5, 0, 0)
                end
            end
        end)
    ]]
    script.Parent = tool
    
    return tool
end

-- Función para spawnear item en posición específica
local function spawnItem(itemName, position)
    if not spawnerEnabled then return end
    
    local newPosition = position or (humanoidRootPart.Position + Vector3.new(
        math.random(-spawnDistance, spawnDistance),
        spawnHeight,
        math.random(-spawnDistance, spawnDistance)
    ))
    
    local item = createBasicItem(itemName, newPosition)
    item.Parent = Workspace
    
    -- Efecto de spawn
    local spawnEffect = Instance.new("Explosion")
    spawnEffect.Position = newPosition
    spawnEffect.BlastRadius = 0
    spawnEffect.BlastPressure = 0
    spawnEffect.Visible = false
    spawnEffect.Parent = Workspace
    
    print("✨ Spawneado: " .. itemName .. " en " .. tostring(newPosition))
    return item
end

-- Función para spawnear item aleatorio
local function spawnRandomItem()
    local randomItem = itemsToSpawn[math.random(1, #itemsToSpawn)]
    return spawnItem(randomItem)
end

-- Función para spawnear múltiples items
local function spawnMultipleItems(count, itemName)
    count = count or 5
    for i = 1, count do
        if itemName then
            spawnItem(itemName)
        else
            spawnRandomItem()
        end
        wait(0.1)
    end
end

-- Función para limpiar items spawneados
local function clearSpawnedItems()
    local itemsCleared = 0
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj:IsA("Tool") and obj:FindFirstChild("Handle") then
            local handle = obj.Handle
            if handle:FindFirstChild("PointLight") then
                obj:Destroy()
                itemsCleared = itemsCleared + 1
            end
        end
    end
    print("🧹 Limpiados " .. itemsCleared .. " items spawneados")
end

-- Auto spawner
local autoSpawnConnection = nil
local function toggleAutoSpawn()
    if autoSpawnEnabled then
        autoSpawnEnabled = false
        if autoSpawnConnection then
            autoSpawnConnection:Disconnect()
            autoSpawnConnection = nil
        end
        print("🔴 Auto-spawn desactivado")
    else
        autoSpawnEnabled = true
        print("🟢 Auto-spawn activado")
        autoSpawnConnection = RunService.Heartbeat:Connect(function()
            wait(math.random(2, 5))
            if autoSpawnEnabled and spawnerEnabled then
                spawnRandomItem()
            end
        end)
    end
end

-- Función para spawnear items específicos del juego
local function spawnGameSpecificItem(itemType)
    local items = {
        brainrot = {"Brainrot", "Ohio Brainrot", "Sigma Brainrot", "Skibidi Brainrot"},
        tools = {"Clonador", "Speed Coil", "Teleport Tool", "Jump Tool"},
        weapons = {"Sword", "Rocket Launcher", "Laser Gun", "Freeze Ray"},
        rare = {"Golden Brainrot", "Rainbow Brainrot", "Admin Commands", "Fly Tool"}
    }
    
    local selectedItems = items[itemType] or items.brainrot
    local randomItem = selectedItems[math.random(1, #selectedItems)]
    return spawnItem(randomItem)
end

-- Sistema de comandos de chat
player.Chatted:Connect(function(message)
    local msg = message:lower()
    local args = {}
    for word in msg:gmatch("%S+") do
        table.insert(args, word)
    end
    
    if args[1] == "/spawn" then
        if args[2] == "random" then
            spawnRandomItem()
        elseif args[2] == "multi" then
            local count = tonumber(args[3]) or 5
            spawnMultipleItems(count)
        elseif args[2] == "brainrot" then
            spawnGameSpecificItem("brainrot")
        elseif args[2] == "tools" then
            spawnGameSpecificItem("tools")
        elseif args[2] == "weapons" then
            spawnGameSpecificItem("weapons")
        elseif args[2] == "rare" then
            spawnGameSpecificItem("rare")
        elseif args[2] then
            -- Spawnear item específico por nombre
            local itemName = ""
            for i = 2, #args do
                itemName = itemName .. args[i]
                if i < #args then itemName = itemName .. " " end
            end
            spawnItem(itemName)
        else
            spawnRandomItem()
        end
        
    elseif msg == "/clear" or msg == "/clean" then
        clearSpawnedItems()
        
    elseif msg == "/autospawn" then
        toggleAutoSpawn()
        
    elseif msg == "/spawner on" then
        spawnerEnabled = true
        print("✅ Spawner activado")
        
    elseif msg == "/spawner off" then
        spawnerEnabled = false
        print("❌ Spawner desactivado")
        
    elseif msg == "/spawner status" then
        print("📊 Estado del Spawner:")
        print("- Spawner: " .. (spawnerEnabled and "ON" or "OFF"))
        print("- Auto-spawn: " .. (autoSpawnEnabled and "ON" or "OFF"))
        print("- Items disponibles: " .. #itemsToSpawn)
        print("- Distancia de spawn: " .. spawnDistance)
        
    elseif msg == "/spawner help" or msg == "/help" then
        print("🔧 Comandos del Item Spawner:")
        print("/spawn random - Spawnea item aleatorio")
        print("/spawn multi [cantidad] - Spawnea múltiples items")
        print("/spawn brainrot - Spawnea brainrot aleatorio")
        print("/spawn tools - Spawnea herramienta aleatoria")
        print("/spawn weapons - Spawnea arma aleatoria")
        print("/spawn rare - Spawnea item raro")
        print("/spawn [nombre] - Spawnea item específico")
        print("/clear - Limpia items spawneados")
        print("/autospawn - Toggle auto-spawn")
        print("/spawner on/off - Activar/desactivar spawner")
        print("/spawner status - Ver estado")
        
    elseif args[1] == "/distance" and args[2] then
        local newDistance = tonumber(args[2])
        if newDistance and newDistance > 0 then
            spawnDistance = newDistance
            print("📏 Distancia de spawn cambiada a: " .. spawnDistance)
        end
    end
end)

-- Inicialización
print("🚀 Item Spawner cargado!")
print("📝 Escribe '/help' para ver los comandos disponibles")
print("✨ Listo para spawnear items en Steal a Brainrot!")

-- Spawnear algunos items iniciales
wait(1)
if spawnerEnabled then
    print("🎁 Spawneando items iniciales...")
    spawnMultipleItems(3)
end
