if MassFireRaze = nil then
	MassFireRaze = class({})
end

function MassFireRaze:OnSpellStart() 
	local hCaster = self:GetCaster()
	local hAbility = self

	local i = 1
	local projectile = {}

	for i=1, 30 do	
		local info = 
		{
			Ability = hAbility,
			EffectName = "particles/lina_base_attack2.vpcf",
			vSpawnOrigin = hCaster:GetAbsOrigin(),
			fDistance = 3000,
			fStartRadius = 64,
			fEndRadius = 64,
			Source = hCaster,
			bHasFrontalCone = false,
			bReplaceExisting = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO,
			fExpireTime = GameRules:GetGameTime() + 10.0,
			bDeleteOnHit = false,
			vVelocity = RandomVector(1) * 500,
			bProvidesVision = false,
			iVisionRadius = 1000,
			iVisionTeamNumber = hCaster:GetTeamNumber()
		}
		projectile[i] = ProjectileManager:CreateLinearProjectile(info)
	end
end

function MassFireRaze:OnProjectileHit( hTarget, vLocation )
	local pCaster = self:GetCaster() 
	if hTarget ~= nil then

		local RazeDamage = {
		victim = hTarget,
		attacker = self:GetCaster(),
		damage = 250,
		damage_type = DAMAGE_TYPE_PURE,
		}	

		ApplyDamage(RazeDamage)
	end
	return true
end


