function pillar_spawn( event )
	local caster = event.caster
	local pillar_spot_1 = Vector(-4523, 1422,0)
	local pillar_spot_2 = Vector(-5253, -109,0)
	local pillar_spot_3 = Vector(-6276, -109,0)
	local pillar_spot_4 = Vector(-7009, 1428,0)
	local pillar_spot_5 = Vector(-6276, 2907,0)
	local pillar_spot_6 = Vector(-5253, 2907,0)

	local roll_one = 0
	local roll_two = 0

	if difficulty_mode <= 2 then
		roll_one = RandomInt(1, 6)
		if roll_one <= 3 then
			roll_two = roll_one + RandomInt(1, 3)
		elseif roll_one > 3 then
			roll_two = roll_one - RandomInt(1, 3)
		end

		local spot_one = "pillar_spot_" .. roll_one
		local spot_two = "pillar_spot_" .. roll_two

		local pillar_one = CreateUnitByName("npc_lightning_boss_pillar", spot_one , false, nil, nil, DOTA_TEAM_NEUTRALS)
		local pillar_one_pass = pillar_one:GetAbilityByIndex(0)
		pillar_one_pass:SetLevel(1)
		local pillar_two = CreateUnitByName("npc_lightning_boss_pillar", spot_two , false, nil, nil, DOTA_TEAM_NEUTRALS)
		local pillar_two_pass = pillar_two:GetAbilityByIndex(0)
		pillar_two_pass:SetLevel(1)
		lightning_pillar_group[1] = pillar_one
		lightning_pillar_group[2] = pillar_two
		print("spawned 2")
	else
		for i=1, 6 do
			if i == 1 then
				spot =  Vector(-4523, 1422,0)
			elseif i == 2 then
				spot = Vector(-5253, -109,0)
			elseif i == 3 then
				spot =  Vector(-6276, -109,0)
			elseif i == 4 then
				spot = Vector(-7009, 1428,0)
			elseif i == 5 then
				spot = Vector(-6276, 2907,0)
			elseif i == 6 then
				spot = Vector(-5253, 2907,0)
			end
			
			local pillar = CreateUnitByName("npc_lightning_boss_pillar", spot , false, nil, caster:GetPlayerOwner(), caster:GetTeamNumber())
			local pillar_pass = pillar:GetAbilityByIndex(0)
			pillar_pass:SetLevel(1)
			lightning_pillar_group[i] = pillar
			print("spawned" .. i)

		end
	end
end

function lightning_health_check( event )
	local caster = event.unit
	local ability = event.ability
	local health = caster:GetHealth()
	if difficulty_mode == 2 then
		if health <= (caster:GetMaxHealth() * 0.2) then
			caster:RemoveModifierByName("modifier_thunder_form")
		end
	elseif difficulty_mode >= 3 then
		if health <= (caster:GetMaxHealth() * 0.4) then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_thunder_form_immunity", nil)
		end
	end
end

function pillar_start( event )
	local caster = event.caster
	local health = caster:GetMaxHealth() * .54
	caster:SetHealth(health)
end

function pillar_check( event )
	local pillar = event.unit
	local ability = event.ability
	
	print("unstable")
	if pillar:GetHealth() == 1 then
		local pillar_spawn_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_disruptor/disruptor_thunder_strike_bolt.vpcf", PATTACH_ABSORIGIN, pillar)
		ParticleManager:SetParticleControl(pillar_spawn_effect, 0, pillar:GetAbsOrigin())
		ParticleManager:SetParticleControl(pillar_spawn_effect, 1, pillar:GetAbsOrigin() + Vector(0,0,500))
		ability:ApplyDataDrivenModifier(pillar, pillar, "modifier_pillar_weakened", nil)
	end
end

function lightning_boss_thunderform_autoattack(event)
	local hCaster = event.caster
	local xTarget = event.target
	local hability = event.ability

	local dist = (hCaster:GetAbsOrigin() - xTarget:GetAbsOrigin()):Length2D()


	if debug_drawing == true then
		local debug_vel = hCaster:GetForwardVector() * 890
		local debug_dist = (hCaster:GetAbsOrigin() - xTarget:GetAbsOrigin()):Length2D()
		local debug_end = hCaster:GetAbsOrigin() + debug_dist * debug_vel:Normalized() 
		DebugDrawLine(hCaster:GetAbsOrigin(), debug_end, 255, 255, 255, false, 3)
	end


	local info = 
	{
		Ability = hability,
		EffectName = "particles/lightning_boss_auto.vpcf",
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