function pillar_spawn( event )
	local caster = event.caster

	Timers:CreateTimer(5, function()

		local pillar_spawn_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_thundergods_wrath_start.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(pillar_spawn_effect, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(pillar_spawn_effect, 1, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(pillar_spawn_effect, 2, caster:GetAbsOrigin() + Vector(0,0,1000))

		
		local pillar_spot_1 = Vector(-4523, 1422,0)
		local pillar_spot_2 = Vector(-5253, -109,0)
		local pillar_spot_3 = Vector(-6276, -109,0)
		local pillar_spot_4 = Vector(-7009, 1428,0)
		local pillar_spot_5 = Vector(-6276, 2907,0)
		local pillar_spot_6 = Vector(-5253, 2907,0)
		

		local roll_one = 0
		local roll_two = 0

		local spot_one = nil
		local spot_two = nil

		if difficulty_mode <= 2 then
			roll_one = RandomInt(1, 6)
			if roll_one <= 3 then
				roll_two = roll_one + RandomInt(1, 3)
			elseif roll_one > 3 then
				roll_two = roll_one - RandomInt(1, 3)
			end

			if roll_one == 1 then
				spot_one =  Vector(-4523, 1422,0)
			elseif roll_one == 2 then
				spot_one = Vector(-5253, -109,0)
			elseif roll_one == 3 then
				spot_one =  Vector(-6276, -109,0)
			elseif roll_one == 4 then
				spot_one = Vector(-7009, 1428,0)
			elseif roll_one == 5 then
				spot_one = Vector(-6276, 2907,0)
			elseif roll_one == 6 then
				spot_one = Vector(-5253, 2907,0)
			end

			if roll_two == 1 then
				spot_two =  Vector(-4523, 1422,0)
			elseif roll_two == 2 then
				spot_two = Vector(-5253, -109,0)
			elseif roll_two == 3 then
				spot_two =  Vector(-6276, -109,0)
			elseif roll_two == 4 then
				spot_two = Vector(-7009, 1428,0)
			elseif roll_two == 5 then
				spot_two = Vector(-6276, 2907,0)
			elseif roll_two == 6 then
				spot_two = Vector(-5253, 2907,0)
			end


			local pillar_one = CreateUnitByName("npc_lightning_boss_pillar", spot_one , false, nil, nil, DOTA_TEAM_NEUTRALS)
			local pillar_one_pass = pillar_one:GetAbilityByIndex(0)
			pillar_one_pass:SetLevel(1)
			local pillar_spawn_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", PATTACH_ABSORIGIN, pillar_one)
			ParticleManager:SetParticleControl(pillar_spawn_effect, 0, pillar_one:GetAbsOrigin())
			ParticleManager:SetParticleControl(pillar_spawn_effect, 1, pillar_one:GetAbsOrigin() + Vector(0,0,1200))

			local pillar_two = CreateUnitByName("npc_lightning_boss_pillar", spot_two , false, nil, nil, DOTA_TEAM_NEUTRALS)
			local pillar_two_pass = pillar_two:GetAbilityByIndex(0)
			pillar_two_pass:SetLevel(1)
			lightning_pillar_group[1] = pillar_one
			lightning_pillar_group[2] = pillar_two
			local pillar_spawn_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", PATTACH_ABSORIGIN, pillar_two)
			ParticleManager:SetParticleControl(pillar_spawn_effect, 0, pillar_two:GetAbsOrigin())
			ParticleManager:SetParticleControl(pillar_spawn_effect, 1, pillar_two:GetAbsOrigin() + Vector(0,0,1200))
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

				local pillar_spawn_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", PATTACH_ABSORIGIN, pillar)
				ParticleManager:SetParticleControl(pillar_spawn_effect, 0, pillar:GetAbsOrigin())
				ParticleManager:SetParticleControl(pillar_spawn_effect, 1, pillar:GetAbsOrigin() + Vector(0,0,1200))

			end
		end
	end)
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
			if caster:HasModifier("modifier_thunder_form_immunity") == false then
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_thunder_form_immunity", nil)
			end
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
		local pillar_weak_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_disruptor/disruptor_thunder_strike_bolt.vpcf", PATTACH_ABSORIGIN, pillar)
		ParticleManager:SetParticleControl(pillar_weak_effect, 0, pillar:GetAbsOrigin())
		ParticleManager:SetParticleControl(pillar_weak_effect, 1, pillar:GetAbsOrigin() + Vector(0,0,500))
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

function lightning_thunder_call( event )
	local caster = event.caster
	local ability = event.ability

	local Xmin = -7080
	local Xmax = -4472
	local Ymin = -176
	local Ymax = 2988

	for i=1, 60 do
		local spot = Vector(RandomInt(Xmin, Xmax), RandomInt(Ymin, Ymax), 250)
		local thunder_dummy = CreateUnitByName("npc_call_thunder_dummy", spot , false, nil, nil, DOTA_TEAM_NEUTRALS)
		local thunder_dummy_pass = thunder_dummy:GetAbilityByIndex(0)
		thunder_dummy_pass:SetLevel(1)

		local call_thunder_effect_start = ParticleManager:CreateParticle("particles/econ/items/zeus/arcana_chariot/zeus_arcana_arc_lightning_impact.vpcf", PATTACH_ABSORIGIN, thunder_dummy)
		ParticleManager:SetParticleControl(call_thunder_effect_start, 1, thunder_dummy:GetAbsOrigin())

		Timers:CreateTimer(RandomFloat(2.5, 4), function()

			if debug_drawing == true then
				DebugDrawCircle(thunder_dummy:GetAbsOrigin(), Vector(255,100,0), 1, 125, true, 1)
			end

			local call_thunder_effect = ParticleManager:CreateParticle("particles/items_fx/chain_lightning.vpcf", PATTACH_ABSORIGIN, thunder_dummy)
			ParticleManager:SetParticleControl(call_thunder_effect, 0, thunder_dummy:GetAbsOrigin())
			ParticleManager:SetParticleControl(call_thunder_effect, 1, thunder_dummy:GetAbsOrigin() + Vector(0,0,1200))

			local call_thunder_effect_end = ParticleManager:CreateParticle("particles/econ/items/zeus/lightning_weapon_fx/zuus_lightning_bolt_castfx_ground2.vpcf", PATTACH_ABSORIGIN, thunder_dummy)
			ParticleManager:SetParticleControl(call_thunder_effect_end, 0, thunder_dummy:GetAbsOrigin())

			local unitTable = FindUnitsInRadius(DOTA_TEAM_GOODGUYS , thunder_dummy:GetAbsOrigin(), nil, 125, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			if unitTable ~= nil then
				for k ,unit in pairs(unitTable) do
	   				if unit:IsHero() == true then
	   					local damageTable = {
						victim = unit,
						attacker = caster,
						damage = 1000,
						damage_type = DAMAGE_TYPE_MAGICAL,
						}				 
						ApplyDamage(damageTable)
					end
				end
			end

			Timers:CreateTimer(0.1, function()
				UTIL_Remove(thunder_dummy)
			end)
		end)
	end
end

function lightning_slide_start( keys )
	local caster = keys.caster
	local ability = keys.ability	

	print("lightning slide")

	-- Clears any current command and disjoints projectiles
	--caster:Stop()

	-- Ability variables
	ability.leap_direction = caster:GetForwardVector()
	ability.leap_distance = 3000
	ability.leap_speed = 1000 * 1/30
	ability.leap_traveled = 0
end

--[[Moves the caster on the horizontal axis until it has traveled the distance]]
function lightning_slide_during( keys )


	local caster = keys.target
	local ability = keys.ability

	local outXmin = -7252
	local outXmax = -4284
	local outYmin = -324
	local outYmax = 3136

	local inXmin = -7164
	local inXmax = -4352
	local inYmin = -256
	local inYmax = 3068

	local cur_pos = caster:GetAbsOrigin()

	if ability.leap_traveled < ability.leap_distance and cur_pos.x < -4352 and cur_pos.x > -7164 and cur_pos.y < 3068 and cur_pos.y > -256 then
		caster:SetAbsOrigin(caster:GetAbsOrigin() + ability.leap_direction * ability.leap_speed)
		ability.leap_traveled = ability.leap_traveled + ability.leap_speed
	else
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_lightning_second_slide", nil)
		caster:InterruptMotionControllers(true)
	end
end

function lightning_slide_start_two( keys )
	local caster = keys.caster
	local ability = keys.ability

	local Xmin = -5072
	local Xmax = -4472
	local Ymin = 636
	local Ymax = 2152

	local spot = Vector(RandomInt(Xmin, Xmax), RandomInt(Ymin, Ymax), 250)	

	caster:SetForwardVector((spot-caster:GetAbsOrigin()):Normalized())

	print("lightning slide two")

	-- Clears any current command and disjoints projectiles
	--caster:Stop()

	-- Ability variables
	ability.leap_direction = (spot-caster:GetAbsOrigin()):Normalized()
	ability.leap_distance = 1000
	ability.leap_speed = 1000 * 1/30
	ability.leap_traveled = 0
end

--[[Moves the caster on the horizontal axis until it has traveled the distance]]
function lightning_slide_during_two( keys )


	local caster = keys.target
	local ability = keys.ability

	if ability.leap_traveled < ability.leap_distance then
		caster:SetAbsOrigin(caster:GetAbsOrigin() + ability.leap_direction * ability.leap_speed)
		ability.leap_traveled = ability.leap_traveled + ability.leap_speed
	else
		caster:RemoveModifierByName("modifier_lightning_slide")
		caster:RemoveModifierByName("modifier_lightning_second_slide")
		caster:InterruptMotionControllers(true)
	end
end

function lightning_slide_kill_check( event )
	local caster = event.caster
	local ability = event.ability

	local unitTable = FindUnitsInRadius(DOTA_TEAM_NEUTRALS , caster:GetAbsOrigin(), nil, 115, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	if unitTable ~= nil then
		for k ,unit in pairs(unitTable) do
			if unit:HasModifier("modifier_pillar_weakened") == true then
				caster:InterruptMotionControllers(true)
				caster:RemoveModifierByName("modifier_lightning_slide")
				if caster:HasModifier("modifier_lightning_second_slide") == true then
					caster:RemoveModifierByName("modifier_lightning_second_slide")
				end
				local pillar_death_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_stormspirit/stormspirit_overload_discharge.vpcf", PATTACH_ABSORIGIN, unit)
				ParticleManager:SetParticleControl(pillar_death_effect, 0, unit:GetAbsOrigin())
				

				unit:SetOriginalModel("models/props_structures/radiant_tower002_destruction.vmdl")
				unit:ForceKill(false)
			end
		end
	end
end