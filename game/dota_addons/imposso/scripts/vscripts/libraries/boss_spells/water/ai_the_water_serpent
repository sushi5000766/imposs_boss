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
					EffectName = "",
					vSpawnOrigin = caster:GetAbsOrigin() + Vector(0, 0, 200),
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
			EffectName = "",
			vSpawnOrigin = caster:GetAbsOrigin() + Vector(0, 0, 200),
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
			vVelocity = caster:GetForwardVector() * projectile_speed,
			bProvidesVision = false,
			iVisionRadius = 0,
			iVisionTeamNumber = caster:GetTeamNumber()
		}

		projectile = ProjectileManager:CreateLinearProjectile(info)
end
