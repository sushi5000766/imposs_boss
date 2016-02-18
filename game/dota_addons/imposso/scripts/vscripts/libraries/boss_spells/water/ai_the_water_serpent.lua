function AutoAttack( event )
	local caster = event.caster
	local target = event.target

	local targetUnits = FindUnitsInRadius(
		caster:GetTeamNumber(),
		caster:GetAbsOrigin(), 
		nil,
		6000,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE, 
		FIND_ANY_ORDER, 
		false)

	local ability = event.ability
	local radius = event.radius
	local projectile_speed = event.projectile_speed

	local dist = (caster:GetAbsOrigin() - target:GetAbsOrigin()):Length2D()


	if (caster:HasModifier("ai_burst") == true) then

		for _, unit in pairs(targetUnits) do
			if (unit:HasModifier("ai_ais_influence") == false) then				
				local info = 
				{
					Ability = ability,
					EffectName = "particles/water_boss_autoattack.vpcf",
					vSpawnOrigin = caster:GetAbsOrigin(),
					fDistance = dist,
					fStartRadius = radius,
					fEndRadius = radius,
					Source = caster,
					bHasFrontalCone = false,
					bReplaceExisting = false,
					iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
					iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
					iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
					fExpireTime = GameRules:GetGameTime() + 10.0,
					bDeleteOnHit = false,
					vVelocity = caster:GetForwardVector() * (projectile_speed * 2),
					bProvidesVision = false,
					iVisionRadius = 0,
					iVisionTeamNumber = caster:GetTeamNumber()
				}
				projectile = ProjectileManager:CreateLinearProjectile(info)
			end
		end
	else
		local info = 
		{
			Ability = ability,
			EffectName = "particles/water_boss_autoattack.vpcf",
			vSpawnOrigin = caster:GetAbsOrigin(),
			fDistance = dist,
			fStartRadius = 100,
			fEndRadius = 100,
			Source = caster,
			bHasFrontalCone = false,
			bReplaceExisting = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime = GameRules:GetGameTime() + 10.0,
			bDeleteOnHit = false,
			vVelocity = caster:GetForwardVector() * projectile_speed,
			bProvidesVision = false,
			iVisionRadius = 0,
			iVisionTeamNumber = caster:GetTeamNumber()
		}

		projectile = ProjectileManager:CreateLinearProjectile(info)
	end
end

function Splash ( event )
	local caster = event.caster
	local damage = event.damage
	local targetUnits = FindUnitsInRadius(
		caster:GetTeamNumber(),
		caster:GetAbsOrigin(), 
		nil,
		6000,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE, 
		FIND_ANY_ORDER, 
		false)

	local targetCount = 0

	for _, unit in pairs(targetUnits) do
		local unitInfluenced = unit:HasModifier("modifier_ais_influence")
		if (unitInfluenced == true and targetCount < 3) then
			local damageTable = {
				victim = unit,
				attacker = caster,
				damage = damage,
				damage_type = DAMAGE_TYPE_PURE,
			}

			--ParticleManager:CreateParticle(string particleName, int particleAttach, handle owningEntity)
			ApplyDamage(damageTable)
			targetCount = targetCount + 1
		end
	end
end

function TidalWaves ( event )
	local caster = event.caster
	local damage = event.damage
	local ability = event.ability
	local spawnWest = bossLocs["water"] + Vector(-2000, 0, 0)
	local spawnNorth = bossLocs["water"] + Vector(0, 2000, 0)
	local spawnEast = bossLocs["water"] + Vector(2000, 0, 0)
	local spawnSouth = bossLocs["water"] + Vector(0, -2000, 0)
	print(" BOSS LOCATION")
	print(bossLocs["water"])
	print("WEST")
	print(spawnWest)
	print("EAST")
	print(spawnEast)
	print("NORTH")
	print(spawnNorth)
	print("SOUTH")
	print(spawnSouth)

	local spawnPoints = {
		spawnWest,
		spawnNorth,
		spawnEast,
		spawnSouth
	}
	local spawnSelect = math.random(1, 4)

	local dist = (bossLocs["water"] - spawnPoints[spawnSelect]):Length2D()

	waveCount = 0
	
	Timers:CreateTimer( function()
		local spawnLocation = spawnPoints[spawnSelect]
		print("SPAWN LOCATION ORIGINAL")
		print(spawnLocation)
		local forwardVec = (bossLocs["water"] - spawnLocation):Normalized()

		if (spawnSelect == 2 or spawnSelect == 4) then
			spawnLocation.x = spawnLocation.x + math.random(-500, 500)
		elseif (spawnSelect == 1 or spawnSelect == 3) then
			spawnLocation.y = spawnLocation.y + math.random(-500, 500)
		end

		print("SPAWN LOCATION RANDOM")
		print(spawnLocation)

		MinimapEvent( DOTA_TEAM_GOODGUYS, caster, spawnLocation.x, spawnLocation.y, DOTA_MINIMAP_EVENT_HINT_LOCATION, 5 )

		local info = 
			{
				Ability = ability,
				EffectName = "particles/water_boss_autoattack.vpcf",
				vSpawnOrigin = spawnLocation,
				fDistance = dist,
				fStartRadius = 150,
				fEndRadius = 150,
				Source = caster,
				bHasFrontalCone = false,
				bReplaceExisting = false,
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
				iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				fExpireTime = GameRules:GetGameTime() + 20.0,
				bDeleteOnHit = false,
				vVelocity = forwardVec * 200,
				bProvidesVision = false,
				iVisionRadius = 0,
				iVisionTeamNumber = caster:GetTeamNumber()
			}

		ProjectileManager:CreateLinearProjectile(info)

		waveCount = waveCount + 1

		if waveCount < 24 then
			return 0.1
		end
	end
	)
end

function UnderTheSea ( event )
	local caster = event.caster
	local ability = event.ability
	local modifier = event.modifier
	local speed = event.speed
	local radius = event.radius

	local possibleTargets =	FindUnitsInRadius(
		caster:GetTeamNumber(),
		caster:GetAbsOrigin(), 
		nil,
		6000,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE, 
		FIND_ANY_ORDER, 
		false)

	chargeCount = 0
	ability:ApplyDataDrivenModifier(caster, caster, modifier, {})

	Timers:CreateTimer(function()
		print("charge start")
		chargeCount = chargeCount + 1

		for k, unit in pairs(possibleTargets) do
			dist = (unit:GetAbsOrigin() - caster:GetAbsOrigin()):Length2D()
			if (dist > 300 and dist < 1000) then
				target = unit
				targetLoc = target:GetAbsOrigin()
				table.remove(possibleTargets, k)
				break
			else
				target = unit
				targetLoc = target:GetAbsOrigin()
				table.remove(possibleTargets, k)
			end
		end

		if (target == nil) then
			for k, unit in pairs(possibleTargets) do
				target = unit
				targetLoc = target:GetAbsOrigin()
				print("CHARGING")
				print(k)
				print(unit:GetUnitName())
				table.remove(possibleTargets, k)
				break
			end
		end

		local forwardVec = (targetLoc - caster:GetAbsOrigin()):Normalized()
		local travelTime = dist / speed

		local projectileTable =
			{
				EffectName = "particles/units/heroes/hero_morphling/morphling_waveform.vpcf",
				Ability = ability,
				vSpawnOrigin = caster:GetAbsOrigin(),
				vVelocity = speed * forwardVec,
				fDistance = 99999,
				fStartRadius = radius,
				fEndRadius = radius,
				Source = caster,
				bHasFrontalCone = false,
				bReplaceExisting = true,
				bProvidesVision = true,
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
				iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				iVisionRadius = 0,
				iVisionTeamNumber = caster:GetTeamNumber()
			}

		local projectile = ProjectileManager:CreateLinearProjectile(projectileTable)

		Timers:CreateTimer(travelTime, function()
			print("START TRAVELTIME TIMER")
			print(travelTime)
			local targetUnits = FindUnitsInRadius(
				caster:GetTeamNumber(),
				targetLoc, 
				nil,
				150,
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				DOTA_UNIT_TARGET_FLAG_NONE, 
				FIND_ANY_ORDER, 
				false)

			for _, unit in pairs(targetUnits) do
				local damageTable = {
					victim = unit,
					attacker = caster,
					damage = 99999,
					damage_type = DAMAGE_TYPE_MAGICAL,
				}
					--ParticleManager:CreateParticle(string particleName, int particleAttach, handle owningEntity)
					ApplyDamage(damageTable)
			end

			ProjectileManager:DestroyLinearProjectile(projectile)
			local bubbles = ParticleManager:CreateParticle("particles/units/heroes/hero_tidehunter/tidehunter_anchor.vpcf", PATTACH_WORLDORIGIN, caster)
			ParticleManager:SetParticleControl(bubbles, 0, targetLoc)
			ParticleManager:SetParticleControl(bubbles, 1, targetLoc)
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_phased", {duration = 0.3})
			print("TELEPORT")
			FindClearSpaceForUnit(caster, targetLoc, false)
		end)

		if (chargeCount < 3) then
			print("charging again")
			print(travelTime + 0.1)
			return travelTime + 0.1
		else
			Timers:CreateTimer(travelTime, function()
				caster:RemoveModifierByName(modifier)
			end)
		end
	end)
end

function Submerge ( event )
	local caster = event.caster
	local ability = event.ability
	local modifier = event.modifier
	local radius = event.radius
	local damage = event.damage

	ability:ApplyDataDrivenModifier(caster, caster, modifier, {duration = 3})

	local targetUnits = FindUnitsInRadius(
			caster:GetTeamNumber(),
			target:GetAbsOrigin(), 
			nil,
			6000,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO,
			DOTA_UNIT_TARGET_FLAG_NONE, 
			FIND_ANY_ORDER, 
			false)

	for _, unit in pairs(targetUnits) do
		submergeLocation = unit:GetAbsOrigin()
		break
	end
		
	--local bubbles = ParticleManager:CreateParticle("", PATTACH_WORLDORIGIN, caster)
	--ParticleManager:SetParticleControl(bubbles, 0, submergeLocation)
	--ParticleManager:SetParticleControl(bubbles, 1, submergeLocation)

	Timers:CreateTimer(3, function()
		--ParticleManager:DestroyParticle(bubbles, false)
		FindClearSpaceForUnit(caster, submergeLocation, false)		

		local damagedUnits = FindUnitsInRadius(
			caster:GetTeamNumber(),
			target:GetAbsOrigin(), 
			nil,
			1000,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE, 
			FIND_ANY_ORDER, 
			false)

		for _, unit in pairs(damagedUnits) do
			local distance = (unit:GetAbsOrigin() - submergeLocation):Length2D()
			if (distance <= 100) then
				unit:ForceKill(true)
			elseif (distance <= 500) then
				local damageTable = {
					victim = unit,
					attacker = caster,
					damage = 500,
					damage_type = DAMAGE_TYPE_MAGICAL,
				}
				--ParticleManager:CreateParticle(string particleName, int particleAttach, handle owningEntity)
				ApplyDamage(damageTable)
			else
				local damageTable = {
					victim = unit,
					attacker = caster,
					damage = 250,
					damage_type = DAMAGE_TYPE_MAGICAL,
				}
				--ParticleManager:CreateParticle(string particleName, int particleAttach, handle owningEntity)
				ApplyDamage(damageTable)
			end
		end
	end)
end

function TornadoCall ( event )
	local caster = event.caster
	local ability = event.ability
	local modifier = event.modifier
	local tornadoes = Entities:FindByName(nil, "npc_boss_water_tornado")
	for _, unit in pairs(tornadoes) do
		unit:CastAbilityImmediately("tornado_tornado_call", -1)
		break
	end
end

function _TornadoCall ( event )
	local caster = event.caster
	local ability = event.ability
	local modifier = event.modifier
	local selectTarget = math.random(1,8)
	local collisionTargetName = "wallCollision" .. i
	local collisionTarget = Entities:FindByName(nil, collisionTargetName)
	local currentLoc = caster:GetAbsOrigin()
	local targetLoc = collisionTarget:GetAbsOrigin()
end

function CallTheSea ( event )
	local caster = event.caster
	local ability = event.ability
	local num = 4  -- Change based on difficulty

	for i = 1, num do
		local x = math.random(-5000, 5000)
		local y = math.random(-5000, 5000)
		local spawnLocation = (x, y, 0)
		ParticleManager:CreateParticle("", PATTACH_WORLDORIGIN, caster)

		local minionType = math.random(1, 3)

		Timers:CreateTimer(2, function()
			if (minionType == 1) then
				local minion = CreateUnitByName("npc_boss_water_myrmidon", spawnLocation, true, caster, caster, DOTA_TEAM_NEUTRALS)
				ability:ApplyDataDrivenModifier(minion, minion, "modifier_phased", {duration = 0.3})
			elseif (minionType == 2) then
				local minion = CreateUnitByName("npc_boss_water_snap_dragon", spawnLocation, true, caster, caster, DOTA_TEAM_NEUTRALS)
				ability:ApplyDataDrivenModifier(minion, minion, "modifier_phased", {duration = 0.3})
			else
				local minion = CreateUnitByName("npc_boss_water_siren", spawnLocation, true, caster, caster, DOTA_TEAM_NEUTRALS)
				ability:ApplyDataDrivenModifier(minion, minion, "modifier_phased", {duration = 0.3})
			end
		end)
	end
end
