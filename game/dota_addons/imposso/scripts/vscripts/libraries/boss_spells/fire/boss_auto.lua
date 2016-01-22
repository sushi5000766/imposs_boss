function boss_auto_attack(event)
	local hCaster = event.caster
	local xTarget = event.target
	local hability = event.ability

	local dist = (hCaster:GetAbsOrigin() - xTarget:GetAbsOrigin()):Length2D()

	local info = 
	{
		Ability = hability,
		EffectName = "particles/boss_auto.vpcf",
		vSpawnOrigin = hCaster:GetAbsOrigin() + Vector(0,0,180),
		fDistance = dist,
		fStartRadius = 0,
		fEndRadius = 0,
		Source = hCaster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_NONE,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO,
		fExpireTime = GameRules:GetGameTime() + 10.0,
		bDeleteOnHit = false,
		vVelocity = hCaster:GetForwardVector() * 890,
		bProvidesVision = false,
		iVisionRadius = 0,
		iVisionTeamNumber = hCaster:GetTeamNumber()
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)
end
