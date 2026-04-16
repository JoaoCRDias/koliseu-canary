-- Thorgrim the Hammerborn - Custom Spells
-- Thor-themed Boss Mechanics

-- ============================================================
-- CONSTANTS / PLACEHOLDERS
-- ============================================================

-- PLACEHOLDER: Area da sala do boss (ajustar conforme mapa)
local ROOM_FROM = Position(3102, 3144, 4)
local ROOM_TO = Position(3112, 3160, 4)

-- PLACEHOLDER: Centro da sala (onde o boss teleporta durante Thunder Rain)
local ROOM_CENTER = Position(3107, 3151, 4)

-- PLACEHOLDER: Efeito visual do aviso de relampago (efeito amarelo/energia)
local WARNING_EFFECT = 581

-- PLACEHOLDER: ID do item que aparece no chao como aviso (ex: piso de energia/fogo)
-- Exemplos comuns: 2129 (energy field), 1487 (magic wall), 23364 (lava), 2130 (fire field)
local WARNING_FLOOR_ITEM = 3064

-- PLACEHOLDER: Efeito visual do dano do relampago
local LIGHTNING_DAMAGE_EFFECT = CONST_ME_ENERGYAREA

-- ============================================================
-- SPELL 1: Thunder Rain (Mjolnir's Wrath)
-- Boss teleporta pro centro da sala, fica imovel por 5 segundos
-- Solta fala epica, chove relampagos pela sala inteira
-- Cada relampago tem aviso (item + efeito) -> delay -> dano forte
-- ============================================================

local thunderRain = Spell("instant")

function thunderRain.onCastSpell(creature, variant)
	local bossId = creature:getId()
	local bossPos = creature:getPosition()

	-- 1. Teleporta o boss pro centro da sala
	creature:teleportTo(ROOM_CENTER)
	ROOM_CENTER:sendMagicEffect(CONST_ME_ENERGYAREA)

	-- 2. Fala epica
	creature:say("FEEL THE WRATH OF MJOLNIR!", TALKTYPE_MONSTER_YELL)

	-- 3. Boss fica imovel (sem target) por 5 segundos
	-- Usar condition de root/paralize no proprio boss
	local rootCondition = Condition(CONDITION_ROOTED)
	rootCondition:setParameter(CONDITION_PARAM_TICKS, 5500)
	creature:addCondition(rootCondition)

	-- 4. Coletar todas as posicoes walkaveis da sala
	local allPositions = {}
	for x = ROOM_FROM.x, ROOM_TO.x do
		for y = ROOM_FROM.y, ROOM_TO.y do
			local pos = Position(x, y, ROOM_FROM.z)
			local tile = Tile(pos)
			if tile then
				local ground = tile:getGround()
				if ground and not tile:hasFlag(TILESTATE_BLOCKSOLID) then
					local canWalk = true
					local items = tile:getItems()
					if items then
						for _, item in ipairs(items) do
							if item:hasProperty(CONST_PROP_BLOCKSOLID) then
								canWalk = false
								break
							end
						end
					end
					if canWalk then
						table.insert(allPositions, pos)
					end
				end
			end
		end
	end

	if #allPositions == 0 then
		return true
	end

	-- 5. Disparar 3 ondas de relampagos durante os 5 segundos
	-- Cada wave: Aviso -> 1500ms -> Dano -> 500ms -> proxima wave
	-- Wave 1: 0ms (inicio imediato)
	-- Wave 2: 2000ms (1500ms dano + 500ms wait)
	-- Wave 3: 4000ms (1500ms dano + 500ms wait)
	local waves = { 0, 2000, 4000 }

	for waveIndex, waveDelay in ipairs(waves) do
		addEvent(function(positions, creatureId, waveNum)
			local boss = Creature(creatureId)
			if not boss then
				return
			end

			-- Selecionar 40-55% das posicoes para esta onda
			local percentage = math.random(40, 55) / 100
			local count = math.floor(#positions * percentage)

			-- Shuffle para selecao aleatoria
			local shuffled = {}
			for i, pos in ipairs(positions) do
				shuffled[i] = pos
			end
			for i = #shuffled, 2, -1 do
				local j = math.random(1, i)
				shuffled[i], shuffled[j] = shuffled[j], shuffled[i]
			end

			local selectedPositions = {}
			local markerItems = {}

			for i = 1, count do
				local pos = shuffled[i]
				if pos then
					-- Efeito visual de aviso
					pos:sendMagicEffect(WARNING_EFFECT)

					-- Criar item no chao como aviso visual
					local tile = Tile(pos)
					if tile then
						local warningItem = Game.createItem(WARNING_FLOOR_ITEM, 1, pos)
						if warningItem then
							warningItem:setActionId(100) -- ActionID 100 = não pode ser movido
							table.insert(markerItems, warningItem)
						end
					end

					table.insert(selectedPositions, pos)
				end
			end

			-- Fala por onda
			local waveYells = {
				"The storm gathers!",
				"THUNDER!",
				"NONE SHALL BE SPARED!",
			}
			boss:say(waveYells[waveNum] or "THUNDER!", TALKTYPE_MONSTER_YELL)

			-- Apos 1500ms do aviso (sinal), cai o dano
			addEvent(function(damagePositions, markers, cId)
				local b = Creature(cId)
				if not b then
					-- Mesmo sem boss, remover os markers
					for _, item in ipairs(markers) do
						if item and item:isItem() then
							item:remove()
						end
					end
					return
				end

				for _, pos in ipairs(damagePositions) do
					-- Efeito visual do relampago caindo
					pos:sendMagicEffect(LIGHTNING_DAMAGE_EFFECT)

					-- Dano nos players naquela posicao exata
					local specs = Game.getSpectators(pos, false, true, 0, 0, 0, 0)
					for _, target in ipairs(specs) do
						if target:isPlayer() then
							local targetPos = target:getPosition()
							if targetPos.x == pos.x and targetPos.y == pos.y and targetPos.z == pos.z then
								doTargetCombatHealth(b:getId(), target, COMBAT_ENERGYDAMAGE, -80000, -140000, LIGHTNING_DAMAGE_EFFECT)
							end
						end
					end
				end

				-- Remover markers
				for _, item in ipairs(markers) do
					if item and item:isItem() then
						item:remove()
					end
				end
			end, 1500, selectedPositions, markerItems, creatureId)
		end, waveDelay, allPositions, bossId, waveIndex)
	end

	return true
end

thunderRain:name("thorgrim_thunder_rain")
thunderRain:words("###700")
thunderRain:isAggressive(true)
thunderRain:blockWalls(true)
thunderRain:needLearn(true)
thunderRain:register()

-- ============================================================
-- SPELL 2: Chain Lightning (Mjolnir's Arc)
-- Relampago que pula de player em player
-- Cada pulo aumenta o dano (+20% por bounce)
-- Maximo de 5 bounces
-- Efeito visual: raio entre cada player
-- ============================================================

local chainLightning = Spell("instant")

function chainLightning.onCastSpell(creature, variant)
	local target = creature:getTarget()
	if not target or not target:isPlayer() then
		return false
	end

	local bossId = creature:getId()
	local bossPos = creature:getPosition()

	-- Parametros do chain
	local baseDamage = -5000 -- dano base no primeiro alvo
	local damageMultiplier = 1.15 -- +15% por bounce
	local maxBounces = 5
	local bounceRange = 6 -- alcance maximo para pular pro proximo player (sqm)
	local bounceDelay = 50 -- delay entre cada pulo (ms)

	-- Coletar todos os players na sala
	local allPlayers = {}
	local specs = Game.getSpectators(bossPos, false, true, 15, 15, 15, 15)
	for _, spec in ipairs(specs) do
		if spec:isPlayer() then
			table.insert(allPlayers, spec)
		end
	end

	if #allPlayers == 0 then
		return false
	end

	-- Fala do boss
	creature:say("Lightning, obey me!", TALKTYPE_MONSTER_YELL)

	-- Funcao recursiva de bounce
	local function bounce(fromPos, currentTargetId, currentDamage, bouncesLeft, hitPlayers)
		if bouncesLeft <= 0 then
			return
		end

		local currentTarget = Creature(currentTargetId)
		if not currentTarget then
			return
		end

		local boss = Creature(bossId)
		if not boss then
			return
		end

		local targetPos = currentTarget:getPosition()

		-- Efeito de raio do ponto anterior ate o alvo
		fromPos:sendDistanceEffect(targetPos, CONST_ANI_ENERGY)

		-- Efeito e dano no alvo
		targetPos:sendMagicEffect(CONST_ME_ENERGYHIT)
		doTargetCombatHealth(bossId, currentTarget, COMBAT_ENERGYDAMAGE, currentDamage, currentDamage * 0.8, CONST_ME_ENERGYHIT)

		-- Marcar player como ja atingido
		hitPlayers[currentTargetId] = true

		-- Procurar proximo player mais proximo que ainda nao foi atingido
		local nextTarget = nil
		local nearestDist = bounceRange + 1

		for _, player in ipairs(allPlayers) do
			local pId = player:getId()
			if not hitPlayers[pId] and player:getHealth() > 0 then
				local pPos = player:getPosition()
				local dist = math.max(
					math.abs(pPos.x - targetPos.x),
					math.abs(pPos.y - targetPos.y)
				)
				if dist <= bounceRange and dist < nearestDist then
					nearestDist = dist
					nextTarget = player
				end
			end
		end

		-- Se encontrou proximo alvo, agendar o bounce
		if nextTarget then
			local nextDamage = math.floor(currentDamage * damageMultiplier)
			addEvent(function(fPos, nId, nDmg, bLeft, hPlayers)
				bounce(fPos, nId, nDmg, bLeft, hPlayers)
			end, bounceDelay, targetPos, nextTarget:getId(), nextDamage, bouncesLeft - 1, hitPlayers)
		end
	end

	-- Iniciar o chain no target atual do boss
	local hitPlayers = {}
	bounce(bossPos, target:getId(), baseDamage, maxBounces, hitPlayers)

	return true
end

chainLightning:name("thorgrim_chain_lightning")
chainLightning:words("###701")
chainLightning:isAggressive(true)
chainLightning:blockWalls(true)
chainLightning:needLearn(true)
chainLightning:register()

-- ============================================================
-- SPELL 3: Ground Slam (Earthquake of the Gods)
-- Boss bate o martelo no chao criando ondas de choque concentricas
-- Cada onda se expande (raio 1 -> 2 -> 3 -> 4 -> 5 -> 6)
-- Players precisam se MOVER para fora do alcance
-- Dano MAIOR perto do boss, menor longe
-- Onda visivel se expandindo a cada 0.5s
-- ============================================================

local groundSlam = Spell("instant")

function groundSlam.onCastSpell(creature, variant)
	local bossId = creature:getId()
	local bossPos = creature:getPosition()

	-- Fala + efeito inicial
	creature:say("THE EARTH TREMBLES!", TALKTYPE_MONSTER_YELL)
	bossPos:sendMagicEffect(CONST_ME_GROUNDSHAKER)

	-- Parametros
	local maxRadius = 6
	local waveDelay = 500 -- tempo entre cada onda (ms)
	local baseDamage = -12000 -- dano maximo (centro)
	local damageDecay = 1000 -- reducao de dano por tile de distancia

	-- Expandir ondas
	for radius = 1, maxRadius do
		addEvent(function(centerPos, cId, r)
			local boss = Creature(cId)
			if not boss then
				return
			end

			-- Desenhar o anel da onda neste raio
			for x = -r, r do
				for y = -r, r do
					-- Somente as bordas do quadrado (o anel)
					if math.abs(x) == r or math.abs(y) == r then
						local wavePos = Position(centerPos.x + x, centerPos.y + y, centerPos.z)
						local tile = Tile(wavePos)
						if tile and not tile:hasFlag(TILESTATE_BLOCKSOLID) then
							-- Efeito visual da onda
							wavePos:sendMagicEffect(CONST_ME_GROUNDSHAKER)

							-- Verificar se tem player nessa posicao exata
							local specs = Game.getSpectators(wavePos, false, true, 0, 0, 0, 0)
							for _, target in ipairs(specs) do
								if target:isPlayer() then
									local targetPos = target:getPosition()
									if targetPos.x == wavePos.x and targetPos.y == wavePos.y and targetPos.z == wavePos.z then
										-- Dano decresce com distancia
										local finalDamage = math.max(baseDamage + (r * damageDecay), -3000)
										doTargetCombatHealth(cId, target, COMBAT_PHYSICALDAMAGE, finalDamage, finalDamage * 0.8, CONST_ME_GROUNDSHAKER)
									end
								end
							end
						end
					end
				end
			end
		end, radius * waveDelay, bossPos, bossId, radius)
	end

	return true
end

groundSlam:name("thorgrim_ground_slam")
groundSlam:words("###702")
groundSlam:isAggressive(true)
groundSlam:blockWalls(true)
groundSlam:needLearn(true)
groundSlam:register()

print(">> Thorgrim the Hammerborn spells loaded successfully!")
