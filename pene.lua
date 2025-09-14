-- =========================================================
--             SECCIÓN DE CONFIGURACIÓN
--   He activado algunas opciones por defecto. 
--   Puedes cambiar 'true' a 'false' para desactivarlas,
--   o viceversa para probar otras acciones.
-- =========================================================

-- Opciones del script original
local changeColorAndSize = true  -- Cambia el color y tamaño de la parte
local teleportPlayer = false     -- Teletransporta al jugador (ajusta las coordenadas abajo)
local playSound = false          -- Reproduce un sonido (añade un Sound en la parte)
local giveTool = false           -- Le da una herramienta al jugador (ajusta el nombre abajo)
local changeTransparency = false -- Hace la parte invisible y luego visible
local boostSpeed = true          -- Aumenta la velocidad del jugador temporalmente
local givePoints = true          -- Le da puntos al jugador (requiere 'leaderstats')
local movePart = false           -- Mueve la parte a otra posición
local destroyPart = false        -- Destruye la parte al tocarla
local changeMaterial = false     -- Cambia el material de la parte

-- Nuevas opciones
local boostJumpPower = false       -- Aumenta el poder de salto del jugador
local changeHealth = false         -- Suma o resta salud al jugador
local spawnPart = false            -- Crea una nueva parte al tocar
local createExplosion = false      -- Crea una explosión en la parte
local changeCharacterColor = false -- Cambia el color del personaje del jugador
local addForceToPlayer = false     -- Aplica una fuerza al jugador, lanzándolo
local playGlobalSound = false      -- Reproduce un sonido desde SoundService
local destroyPartWithDelay = false   -- Destruye la parte después de un retraso
local changeGameLighting = false   -- Cambia la iluminación del juego

-- =========================================================
--             LÓGICA DEL SCRIPT (No es necesario editar)
-- =========================================================

local part = script.Parent
local tweenService = game:GetService("TweenService")
local soundService = game:GetService("SoundService")

local function onPartTouched(otherPart)
	local character = otherPart.Parent
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local player = game.Players:GetPlayerFromCharacter(character)

	if not humanoid or not player then
		return
	end

	-- OPCIÓN 1: Cambiar color y tamaño
	if changeColorAndSize then
		part.BrickColor = BrickColor.random()
		part.Size = part.Size + Vector3.new(1, 1, 1)
		task.wait(2)
		part.Size = part.Size - Vector3.new(1, 1, 1)
	end

	-- OPCIÓN 2: Teletransportar al jugador
	if teleportPlayer then
		character:MoveTo(Vector3.new(0, 50, 0))
	end

	-- OPCIÓN 3: Reproducir un sonido
	if playSound then
		local sound = part:FindFirstChildOfClass("Sound")
		if sound and not sound.IsPlaying then
			sound:Play()
		end
	end

	-- OPCIÓN 4: Dar una herramienta
	if giveTool then
		local toolName = "ToolName"
		local tool = game.ServerStorage:FindFirstChild(toolName)
		if tool and not player.Backpack:FindFirstChild(toolName) then
			tool:Clone().Parent = player.Backpack
		end
	end

	-- OPCIÓN 5: Cambiar transparencia
	if changeTransparency then
		part.Transparency = 1
		part.CanCollide = false
		task.wait(5)
		part.Transparency = 0
		part.CanCollide = true
	end
	
	-- OPCIÓN 6: Aumentar velocidad
	if boostSpeed then
		humanoid.WalkSpeed = 32
		task.wait(10)
		humanoid.WalkSpeed = 16
	end

	-- OPCIÓN 7: Dar puntos
	if givePoints then
		local leaderstats = player:FindFirstChild("leaderstats")
		if leaderstats and leaderstats:FindFirstChild("Points") then
			leaderstats.Points.Value += 100
		end
	end

	-- OPCIÓN 8: Mover la parte
	if movePart then
		local endPos = part.Position + Vector3.new(0, 10, 0)
		local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Quad)
		tweenService:Create(part, tweenInfo, {Position = endPos}):Play()
	end

	-- OPCIÓN 9: Destruir la parte (instantáneo)
	if destroyPart then
		part:Destroy()
	end

	-- OPCIÓN 10: Cambiar material
	if changeMaterial then
		local originalMaterial = part.Material
		part.Material = Enum.Material.Neon
		task.wait(3)
		part.Material = originalMaterial
	end

	-- NUEVA OPCIÓN 11: Aumentar poder de salto
	if boostJumpPower then
		humanoid.JumpPower = 100
		task.wait(10)
		humanoid.JumpPower = 50
	end

	-- NUEVA OPCIÓN 12: Cambiar salud
	if changeHealth then
		humanoid.Health += 20
	end

	-- NUEVA OPCIÓN 13: Crear una nueva parte
	if spawnPart then
		local newPart = Instance.new("Part")
		newPart.Position = part.Position + Vector3.new(0, 5, 0)
		newPart.Anchored = true
		newPart.BrickColor = BrickColor.new("Really red")
		newPart.Parent = game.Workspace
		task.wait(5)
		newPart:Destroy()
	end

	-- NUEVA OPCIÓN 14: Crear explosión
	if createExplosion then
		local explosion = Instance.new("Explosion")
		explosion.Position = part.Position
		explosion.Parent = game.Workspace
	end
	
	-- NUEVA OPCIÓN 15: Cambiar color del personaje
	if changeCharacterColor then
		for _, child in pairs(character:GetChildren()) do
			if child:IsA("Part") or child:IsA("MeshPart") then
				child.BrickColor = BrickColor.random()
			end
		end
	end

	-- NUEVA OPCIÓN 16: Aplicar fuerza al jugador
	if addForceToPlayer then
		local rootPart = character:FindFirstChild("HumanoidRootPart")
		if rootPart then
			local bodyVelocity = Instance.new("BodyVelocity")
			bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
			bodyVelocity.Velocity = character.HumanoidRootPart.CFrame.lookVector * 50
			bodyVelocity.Parent = rootPart
			game.Debris:AddItem(bodyVelocity, 0.5)
		end
	end

	-- NUEVA OPCIÓN 17: Reproducir un sonido global
	if playGlobalSound then
		local soundId = "rbxassetid://1319200424"
		soundService:PlayLocalSound(soundId)
	end
	
	-- NUEVA OPCIÓN 18: Destruir la parte con retraso
	if destroyPartWithDelay then
		task.wait(3)
		part:Destroy()
	end
end

part.Touched:Connect(onPartTouched)
