-- Voroth's Ground Slam: expanding death shockwave (based on thorgrim_ground_slam)

local groundSlam = Spell("instant")

function groundSlam.onCastSpell(creature, variant)
	local bossId = creature:getId()
	local bossPos = creature:getPosition()

	-- Fala + efeito inicial
	creature:say("THE VOID TREMBLES!", TALKTYPE_MONSTER_YELL)
	bossPos:sendMagicEffect(CONST_ME_MORTAREA)

	-- Parametros
	local maxRadius = 6
	local waveDelay = 500 -- tempo entre cada onda (ms)
	local baseDamage = -14000 -- dano maximo (centro)
	local damageDecay = 6000 -- reducao de dano por tile de distancia

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
							wavePos:sendMagicEffect(CONST_ME_MORTAREA)

							-- Verificar se tem player nessa posicao exata
							local specs = Game.getSpectators(wavePos, false, true, 0, 0, 0, 0)
							for _, target in ipairs(specs) do
								if target:isPlayer() then
									local targetPos = target:getPosition()
									if targetPos.x == wavePos.x and targetPos.y == wavePos.y and targetPos.z == wavePos.z then
										-- Dano decresce com distancia
										local finalDamage = math.max(baseDamage + (r * damageDecay), -3000)
										doTargetCombatHealth(cId, target, COMBAT_DEATHDAMAGE, finalDamage, finalDamage * 0.8, CONST_ME_MORTAREA)
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

groundSlam:name("voroth ground slam")
groundSlam:words("###vslam")
groundSlam:isAggressive(true)
groundSlam:blockWalls(true)
groundSlam:needLearn(true)
groundSlam:register()
