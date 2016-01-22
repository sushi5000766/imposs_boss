function fire_ball(event)
	local hCaster = event.caster
	local hability = event.ability
	local castPos = hCaster:GetAbsOrigin()
	local unitTable = FindUnitsInRadius(hCaster:GetTeamNumber(), hCaster:GetAbsOrigin(), nil, 2000.0, DOTA_TEAM_GOODGUYS, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	local count = 0

	for k ,unit in pairs(unitTable) do
		count = (count + 1)
	end

	

	local info = 
	{
		Ability = hability,
		EffectName = "particles/fireball_travel.vpcf",
		vSpawnOrigin = castPos,
		fDistance = 800,
		fStartRadius = 64,
		fEndRadius = 64,
		Source = hCaster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_NONE,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 10.0,
		bDeleteOnHit = false,
		vVelocity = RandomVector(1) * 300,
		bProvidesVision = false,
		iVisionRadius = 0,
		iVisionTeamNumber = hCaster:GetTeamNumber()
	}
	fireball = ProjectileManager:CreateLinearProjectile(info)	

	fireball_end = boss:GetAbsOrigin() + 800 * info.vVelocity:Normalized() 
	--[[fireball_end = nil
	fireball_end = boss:GetAbsOrigin() + 750 * info.vVelocity:Normalized() 
	fireball_dummy = CreateUnitByName("npc_dummy_unit", fireball_end, false, nil, nil, DOTA_TEAM_GOODGUYS)
	local ballPass = fireball_dummy:GetAbilityByIndex(0)
	ballPass:SetLevel(1)

	Timers:CreateTimer(2.2, function()
		
		fireball_dummy:ForceKill(false)
	end)]]--
end

function fireball_explode( event )
	local angle = 0
	local dist = 0
	local change = 0

	local fireball_effect_end = ParticleManager:CreateParticle("particles/econ/items/gyrocopter/hero_gyrocopter_gyrotechnics/gyro_calldown_explosion.vpcf", PATTACH_ABSORIGIN, boss)
	ParticleManager:SetParticleControl(fireball_effect_end, 3, fireball_end)

	for i=0, 47 do
		if i <= 7 then
			dist = 100
			change = 45
		elseif i > 7 and i <= 23 then
			dist = 225
			change = 22
		elseif i > 23 then
			dist = 350
			change = 15
		end

		local effect_pos = fireball_end + Vector(math.cos(math.rad(angle)), math.sin(math.rad(angle)), 0) * dist

		local fireball_effect_end = ParticleManager:CreateParticle("particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_base_attack_impact.vpcf", PATTACH_ABSORIGIN, boss)
		ParticleManager:SetParticleControl(fireball_effect_end, 1, effect_pos)
		angle = angle + change
		if angle > 360 then
			angle = angle - 360
		end
	end

end

--[[local target = event.target
	local angle = 0
	local dist = 0
	local change = 0

	for i=0, 47 do
		if i <= 7 then
			dist = 100
			change = 45
		elseif i > 7 and i <= 23 then
			dist = 225
			change = 22
		elseif i > 23 then
			dist = 350
			change = 15
		end

		local effect_pos = fireball_dummy:GetAbsOrigin() + Vector(math.cos(math.rad(angle)), math.sin(math.rad(angle)), 0) * dist

		print(effect_pos)
		local fireball_effect_end = ParticleManager:CreateParticle("particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_base_attack_impact.vpcf", PATTACH_ABSORIGIN, fireball_dummy)
		ParticleManager:SetParticleControl(fireball_effect_end, 1, effect_pos)
		angle = angle + change
		if angle > 360 then
			angle = angle - 360
		end
	end]]--



--(hPos-castPos):Normalized() * 500