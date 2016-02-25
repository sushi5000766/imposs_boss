function snipe( event )
	local caster = event.caster
	local target = event.target
	local ability = event.ability

	local dist = (caster:GetAbsOrigin() - target:GetAbsOrigin()):Length2D()

	local info = 
	{
		Ability = ability,
		EffectName = "particles/units/heroes/hero_windrunner/windrunner_spell_powershot.vpcf",
		vSpawnOrigin = caster:GetAbsOrigin() + Vector(0,0,180),
		fDistance = dist,
		fStartRadius = 64,
		fEndRadius = 64,
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 10.0,
		bDeleteOnHit = true,
		vVelocity = caster:GetForwardVector() * 1700,
		bProvidesVision = false,
		iVisionRadius = 0,
		iVisionTeamNumber = caster:GetTeamNumber()
	}
	arrow = ProjectileManager:CreateLinearProjectile(info)
end

function ranger_burn( event )
	local caster = event.caster
	local target = event.target

	target:SetMana(target:GetMana() - 8)
end