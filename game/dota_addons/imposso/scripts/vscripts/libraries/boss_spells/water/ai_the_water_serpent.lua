function AutoAttack( event )
	local caster = event.caster
	local target = event.target

	local targetUnits = FindUnitsInRadius(
		caster:GetTeamNumber(),
		caster:GetAbsOrigin(), 
		nil,
		6000,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
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
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
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
				vVelocity = dist:Normalized() * 200,
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
