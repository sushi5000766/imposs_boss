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
				vVelocity = spawnPoints[spawnSelect]:Normalized() * 200,
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
	local target = event.target
	local speed = event.speed
	local radius = event.radius
	local forwardVec = (target:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized()
	local dist = (target:GetAbsOrigin() - caster:GetAbsOrigin()):Length2D()
	local travelTime = dist / speed

	chargeCount = 0


	caster:ApplyDataDrivenModifier(caster, caster, modifier, {})

	local projectileTable =
		{
			EffectName = "",
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

	local projectile = ProjectileManager:CreateLinearProjectile( projectileTable )

	Timers:CreateTimer(travelTime, function()
		local targetUnits = FindUnitsInRadius(
			caster:GetTeamNumber(),
			target:GetAbsOrigin(), 
			nil,
			300,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE, 
			FIND_ANY_ORDER, 
			false)

		for _, unit in pairs(targetUnits) do
			local damageTable = {
				victim = unit,
				attacker = caster,
				damage = damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
			}
				--ParticleManager:CreateParticle(string particleName, int particleAttach, handle owningEntity)
				ApplyDamage(damageTable)
			end
		end

		ProjectileManager:DestroyLinearProjectile( projectile )
		chargeCount = chargeCount + 1

		if (chargeCount < 3) then
			return
		end
	end)
end

function Submerge ( event )
	local caster = event.caster
	local ability = event.ability
	local modifier = event.modifier
	local radius = event.radius
	local damage = event.damage

	caster:ApplyDataDrivenModifier(caster, caster, modifier, {duration = 3})

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
		
	local bubbles = ParticleManager:CreateParticle("", PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(bubbles, 0, submergeLocation)
	ParticleManager:SetParticleControl(bubbles, 1, submergeLocation)

	Timers:CreateTimer(3, function()
		ParticleManager:DestroyParticle(bubbles, false)
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
			else if (distance <= 500) then
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



			
