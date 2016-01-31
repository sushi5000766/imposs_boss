function earth_orb_spawn( event )
	local caster = event.caster

	local Xmin = 4584
	local Xmax = 6272
	local Ymin = 4400
	local Ymax = 6128

	local earthXmin = 3595
	local earthXmax = 7256
	local earthYmin = 3360
	local earthYmax = 7141

	local chance = RandomInt(1, 8)	

	if chance == 1 then

		local orb_unit = CreateUnitByName("npc_earth_boss_orb", Vector(RandomFloat(Xmin,Xmax), RandomFloat(Ymin, Ymax),0), true, nil, nil, DOTA_TEAM_NEUTRALS)
		local death_ab = orb_unit:GetAbilityByIndex(0)
		death_ab:SetLevel(1) 


		for i=1, 30 do

			local newOrder = {
		 		UnitIndex = orb_unit:entindex(), 
		 		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		 		Position = Vector(RandomFloat(earthXmin,earthXmax), RandomFloat(earthYmin, earthYmax),0), --Optional.  Only used when targeting the ground
		 		Queue = 1 --Optional.  Used for queueing up abilities
		 	}
		 
			ExecuteOrderFromTable(newOrder)
		end
	end
end

function earth_orb_stepped( event )
	local target = event.target
	local caster = event.caster
	local ability = event.ability

	local mod_name = "modifier_earth_boss_damage_stack"

	if caster:HasModifier(mod_name) == true then

		local stack_count = caster:GetModifierStackCount(mod_name, ability)

	end

	if target:GetUnitLabel() == "earth_orb" then

		local angle = 0

		local earth_orb_effect_end = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_warstomp.vpcf", PATTACH_ABSORIGIN, boss)
		ParticleManager:SetParticleControl(earth_orb_effect_end, 0, target:GetAbsOrigin())

		if debug_drawing == true then
			DebugDrawCircle(target:GetAbsOrigin(), Vector(255,0,0), 1, 250, true, 1)
		end

		local orb_step_group = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, target:GetAbsOrigin(), nil, 250, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		if orb_step_group ~= nil then
			for k,v in pairs(orb_step_group) do
				local damageTable = {
					victim = v,
					attacker = caster,
					damage = 450,
					damage_type = DAMAGE_TYPE_MAGICAL,
				}
				 
				ApplyDamage(damageTable)

				if difficulty_mode >=2 then
					ability:ApplyDataDrivenModifier(caster, v, "modifier_earth_orb_stun", {duration = 1})
					ability:ApplyDataDrivenModifier(caster, boss, "earth_protection", {duration = 3})
				else
					ability:ApplyDataDrivenModifier(caster, boss, "earth_protection", {duration = 1})
				end
			end
		end

		caster:SetMana(caster:GetMana() + 85) 

		if caster:HasModifier(mod_name) == false then

			ability:ApplyDataDrivenModifier(caster, caster, mod_name, nil) 

			caster:SetModifierStackCount( mod_name, ability, 1)

		elseif caster:HasModifier(mod_name) == true then
			local stack_count = caster:GetModifierStackCount(mod_name, ability)
			if stack_count < 5 then
				
				stack_count = stack_count + 1

				caster:SetModifierStackCount( mod_name, ability, stack_count)
			end
		end

		
		target:ForceKill(false)


	end
end

function earth_player_check( event )
	local caster = event.caster
	local ability = event.ability
	local mod_name = "modifier_earth_boss_damage_stack"

	local siesmic_ab = caster:FindAbilityByName("earth_boss_siesmic")

	if siesmic_ab:IsCooldownReady() == false then

		if debug_drawing == true then
							
			DebugDrawText(boss:GetAbsOrigin() + Vector(0,0,300), ("current cd = " .. tostring(siesmic_ab:GetCooldownTimeRemaining())), true, 2)
			
		end 
	end
	 

	local count = 0

	local player_group = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, caster:GetAbsOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	if player_group ~= nil then
		for k,v in pairs(player_group) do
			if v:HasModifier("modifier_earth_player_check_effect") == true then --checks for melee range aura on player
				count = count + 1
			end
		end
	end

	if count == 0 then
		if boss:HasModifier("modifier_earth_ult_casting") == false then
			caster:SetMana(caster:GetMana() + 85) 
		end

		if caster:HasModifier(mod_name) == false then

			ability:ApplyDataDrivenModifier(caster, caster, mod_name, nil) 

			caster:SetModifierStackCount( mod_name, ability, 1)

		elseif caster:HasModifier(mod_name) == true then
			local stack_count = caster:GetModifierStackCount(mod_name, ability)
			if stack_count < 5 then
				
				stack_count = stack_count + 1

				caster:SetModifierStackCount( mod_name, ability, stack_count)
			end
		end

		if siesmic_ab:IsCooldownReady() == false then
			local siesmic_cd = siesmic_ab:GetCooldownTimeRemaining()			
			if siesmic_cd > 3 then
				local new_cd = siesmic_cd - 3
				siesmic_ab:StartCooldown(new_cd)

				if debug_drawing == true then
						
					DebugDrawText(boss:GetAbsOrigin() + Vector(0,0,200), ("new cd = " .. tostring(new_cd)), true, 2)
					
				end 
			end
		end
	end	
end

function pummel_cast( event )
	local caster = event.caster
	local ability = event.ability
	local count = 2

	local forward = caster:GetForwardVector() * 300	

	local pummel_center = caster:GetAbsOrigin() + 300 * forward:Normalized()

	Timers:CreateTimer(function()

		if debug_drawing == true then
			DebugDrawCircle(pummel_center, Vector(255,0,255), 1, 250, true, 3)
			DebugDrawCircle(pummel_center, Vector(0,255,255), 1, 400, true, 3)
		end

		if count > 0.5 then

			local pummel_start = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_warstomp.vpcf", PATTACH_ABSORIGIN, caster)
			ParticleManager:SetParticleControl(pummel_start, 0, pummel_center)

			local pummel_start_group = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, pummel_center, nil, 250, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			if pummel_start_group ~= nil then
				for k,v in pairs(pummel_start_group) do
					local damageTable = {
						victim = v,
						attacker = caster,
						damage = 100,
						damage_type = DAMAGE_TYPE_MAGICAL,
					}
					 
					ApplyDamage(damageTable)
					
				end
			end
			count = count - 0.1
			return 0.1

		elseif count <= .5 and count > 0 then
			count = count - 0.1
			return 0.1
		else
			local pummel_end = ParticleManager:CreateParticle("particles/econ/items/brewmaster/brewmaster_offhand_elixir/brewmaster_thunder_clap_elixir.vpcf", PATTACH_ABSORIGIN, caster)
			ParticleManager:SetParticleControl(pummel_end, 0, pummel_center)

			local pummel_end_group = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, pummel_center, nil, 400, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			if pummel_end_group ~= nil then
				for k,v in pairs(pummel_end_group) do
					v:Purge( true, false, false, false, false )
					local damageTable = {
						victim = v,
						attacker = caster,
						damage = 1400,
						damage_type = DAMAGE_TYPE_MAGICAL,
					}
					 
					ApplyDamage(damageTable)
					
				end
			end
		end
		return
	end)
end

function imtimidate_purge( event )
	local target = event.target

	EmitGlobalSound("Imposs.boss_earth_yell") --[[Returns:void
	Play named sound for all players
	]]

	target:Purge( true, false, false, false, false )
end

function earth_shock( event )
	local caster = event.caster
	local ability = event.ability
	
	local shock_table = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, caster:GetAbsOrigin(), nil, 2000.0, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)	

	local player_count = 0

	
	if shock_table ~= nil then
		for k ,unit in pairs(shock_table) do
			player_count = (player_count + 1)
		end


		if player_count > 0 then
			local picked_earthshock = shock_table[RandomInt(1, player_count)]
			local picked_pos = picked_earthshock:GetAbsOrigin() 

			local count = 2

			local forward = caster:GetForwardVector() * 250	

			local shock_center = caster:GetAbsOrigin() + 250 * forward:Normalized()

			if debug_drawing == true then
				DebugDrawCircle(picked_pos, Vector(255,255,255), 1, 500, true, 2)
			end


			Timers:CreateTimer(function()

				local earth_shock_effect = ParticleManager:CreateParticle("particles/econ/items/brewmaster/brewmaster_offhand_elixir/brewmaster_thunder_clap_elixir.vpcf", PATTACH_ABSORIGIN, caster)
				ParticleManager:SetParticleControl(earth_shock_effect, 0, picked_pos)

				local shock_group = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, picked_pos, nil, 350, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
				if shock_group ~= nil then
					for k,v in pairs(shock_group) do
						local damageTable = {
							victim = v,
							attacker = caster,
							damage = 400,
							damage_type = DAMAGE_TYPE_MAGICAL,
						}
						 
						ApplyDamage(damageTable)
						ability:ApplyDataDrivenModifier(caster, v, "modifier_earth_earthshock_slow", {duration = 2}) --[[Returns:void
						No Description Set
						]]
					end
				end
				count = count - 0.5
				if count > 0 then
					return 0.5
				elseif count == 0 then
					return
				end
			end)
		end
	end
end

function earth_charge( event )
	local caster = event.caster
	local ability = event.ability

	local dist = 0

	local counter = 0

	local picked_unit = nil

	local charge_table = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, caster:GetAbsOrigin(), nil, 4000.0, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_FARTHEST, false)	
	if charge_table ~= nil then
		picked_unit = charge_table[1]

		if picked_unit:IsAlive() == true then
			local order = 
			{
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
				TargetIndex = picked_unit:entindex()
			}

			ExecuteOrderFromTable(order)
		else
			target:Stop()
			caster:RemoveModifierByName("modifier_earth_charge")
		end

	end
end

function slam_boss_cast( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local slam_center = keys.target_points[1]

	local earth_slam_effect = ParticleManager:CreateParticle("particles/econ/items/earthshaker/egteam_set/hero_earthshaker_egset/earthshaker_echoslam_start_fallback_low_egset.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(earth_slam_effect, 0, slam_center)

	if debug_drawing == true then
		DebugDrawCircle(slam_center, Vector(255,255,255), 1, 500, true, 2)
	end
	
	local slam_group = FindUnitsInRadius(DOTA_TEAM_NEUTRALS, caster:GetAbsOrigin(), nil, 3000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	if slam_group ~= nil then
		for k,v in pairs(slam_group) do
			if v:GetUnitLabel() == "earth_orb" then

				local earth_orb_effect_slam = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_warstomp.vpcf", PATTACH_ABSORIGIN, boss)
				ParticleManager:SetParticleControl(earth_orb_effect_slam, 0, v:GetAbsOrigin())

				if debug_drawing == true then
					DebugDrawCircle(v:GetAbsOrigin(), Vector(255,0,0), 1, 250, true, 1)
				end

				local slam_orb_group = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, v:GetAbsOrigin(), nil, 250, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
				if slam_orb_group ~= nil then
					for _,unit in pairs(slam_orb_group) do
						local damageTable = {
							victim = unit,
							attacker = caster,
							damage = 450,
							damage_type = DAMAGE_TYPE_MAGICAL,
						}
						 
						ApplyDamage(damageTable)

						if difficulty_mode >=2 then
							ability:ApplyDataDrivenModifier(caster, unit, "modifier_earth_orb_stun_two", {duration = 1})
						end
					end
				end
				v:ForceKill(false)
			end
		end
	end	
end

function earth_quake( event )
	local caster = event.caster
	local ability = event.ability
	
	local Xmin = 4584
	local Xmax = 6272
	local Ymin = 4400
	local Ymax = 6128

	local count = 4

	local quake_center = Vector(RandomFloat(Xmin,Xmax), RandomFloat(Ymin, Ymax),0)

	if debug_drawing == true then
		DebugDrawCircle(quake_center, Vector(255,255,255), 1, 500, true, 4)
	end

	Timers:CreateTimer(function()

		local earth_qauke_effect = ParticleManager:CreateParticle("particles/econ/items/earthshaker/egteam_set/hero_earthshaker_egset/earthshaker_echoslam_start_fallback_low_egset.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(earth_qauke_effect, 0, quake_center)

		local qauke_group = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, quake_center, nil, 500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		if qauke_group ~= nil then
			for k,v in pairs(qauke_group) do
				ability:ApplyDataDrivenModifier(caster, v, "modifier_earth_earthquake_debuff", {duration = 1})
			end
		end
		count = count - 1
		if count > 0 then
			return 1
		elseif count == 0 then
			return
		end
	end)
end

function barrage( event )
	local caster = event.caster
	local ability = event.ability

	local start_color = 0
	local start_dist = 1600

	local barrage_channel_effect = ParticleManager:CreateParticle("particles/barrage_warning.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(barrage_channel_effect, 0, caster:GetAbsOrigin())

	if debug_drawing == true then
		for i=1, 16 do
			DebugDrawCircle(caster:GetAbsOrigin(), Vector(start_color,0,0), 1, start_dist, true, 8)
			start_color = start_color + 12
			start_dist = start_dist - 100
		end
	end

	ScreenShake(caster:GetAbsOrigin(), 10, 2, 5, 3000, 0, true) --[[Returns:void
	Start a screenshake with the following parameters. vecCenter, flAmplitude, flFrequency, flDuration, flRadius, eCommand( SHAKE_START = 0, SHAKE_STOP = 1 ), bAirShake
	]]

	Timers:CreateTimer(4, function()
		ScreenShake(caster:GetAbsOrigin(), 1000, 1000, 3, 3000, 0, true)
	end)

	local counter = 0

	local angle = 0
	local timer = 4
	local countdown = .25
	local spike_number = {50,46,42,39,36, 32, 29, 25, 22, 20, 18, 16, 12, 10, 8, 4}
	local active = 1
	local dist = 1550
	local change = 360 / spike_number[active]
	

	--36 / 32 / 29 /25 / 22 / 20 / 18 / 16 / 12 / 10 / 8 / 4
	Timers:CreateTimer(4, function()

		Timers:CreateTimer(function()

			timer = timer - countdown

			for i=1, spike_number[active] do				

				local barrage_pos = caster:GetAbsOrigin() + Vector(math.cos(math.rad(angle)), math.sin(math.rad(angle)), 0) * dist

				if debug_drawing == true then
					
					DebugDrawCircle(barrage_pos, Vector(0,0,255), 1, 100, true, 8)
					
				end 

				local barrage_group = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, barrage_pos, nil, 100, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
				if barrage_group ~= nil then
					for k,v in pairs(barrage_group) do
						local damageTable = {
							victim = v,
							attacker = caster,
							damage = 2000,
							damage_type = DAMAGE_TYPE_MAGICAL,
						}
						 
						ApplyDamage(damageTable)

						if debug_drawing == true then
					
							DebugDrawText(v:GetAbsOrigin() + Vector(0,0,200), "2000", true, 2)
							
						end 
						
					end
				end

				local barrage_effect = ParticleManager:CreateParticle("particles/earth_boss_spikes.vpcf", PATTACH_ABSORIGIN, caster)
				ParticleManager:SetParticleControl(barrage_effect, 0, barrage_pos)
				angle = angle + change
				if angle > 360 then
					angle = angle - 360
				end

				counter = counter + 1
			end

			--update

			if timer == 0 then
				return
			elseif timer > 0 and counter == spike_number[active] then
				counter = 0
				active = active + 1		
				dist = dist - 100
				change = 360 / spike_number[active]
				return 0.25
			end
		end)
		ParticleManager:DestroyParticle(barrage_channel_effect, true)
	end)
	--[[for i=1, 232 do

		if i <= 36 then		
			dist = 1150
			change = 10
			next_break = 36
		elseif i > 36 and i <= 68 then 
			dist = 1050
			change = 11.25
			next_break = 68
		elseif i > 68 and i <= 97 then
			dist = 950	
			change = 12.41
			next_break = 97		
		elseif i > 97 and i <= 122 then
			dist = 850
			change = 14.44
			next_break = 122
		elseif i > 122 and i <= 144 then
			dist = 750
			change = 16.36
			next_break = 144
		elseif i > 144 and i <=164 then
			dist = 650
			change = 18
			next_break = 164
		elseif i > 164 and i <= 182 then
			dist = 550
			change = 20
			next_break = 182
		elseif i > 182 and i <= 198 then
			dist = 450
			change = 22.5
			next_break = 198
		elseif i > 198 and i <= 210 then
			dist = 350
			change = 30
			next_break = 210
		elseif i > 210 and i <= 220 then
			dist = 250
			change = 36
			next_break = 220
		elseif i > 220 and i <= 228 then
			dist = 150
			change = 45
			next_break = 228
		elseif i > 228 and i <= 232 then
			dist = 50
			change = 90 
			next_break = 232
		end



		local barrage_pos = caster:GetAbsOrigin() + Vector(math.cos(math.rad(angle)), math.sin(math.rad(angle)), 0) * dist

		print(effect_pos)
		local barrage_effect = ParticleManager:CreateParticle("particles/earth_boss_spikes.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(barrage_effect, 0, barrage_pos)
		angle = angle + change
		if angle > 360 then
			angle = angle - 360
		end
	end]]--
end

function siesmic_launch( event )
	local caster = event.caster
	local ability = event.ability
	--A Liner Projectile must have a table with projectile info
	local info = 
	{
		Ability = ability,
        	EffectName = "particles/units/heroes/hero_magnataur/magnataur_shockwave.vpcf",
        	vSpawnOrigin = caster:GetAbsOrigin(),
        	fDistance = 2000,
        	fStartRadius = 150,
        	fEndRadius = 240,
        	Source = caster,
        	bHasFrontalCone = true,
        	bReplaceExisting = false,
        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        	fExpireTime = GameRules:GetGameTime() + 10.0,
		bDeleteOnHit = true,
		vVelocity = caster:GetForwardVector() * 1400,
		bProvidesVision = true,
		iVisionRadius = 1000,
		iVisionTeamNumber = caster:GetTeamNumber()
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)
end

function siesmic_hit( event )
	local unit = event.target

	if unit:HasModifier("modifier_earth_player_check_effect") == true then
		local damageTable = {
			victim = unit,
			attacker = boss,
			damage = 1500,
			damage_type = DAMAGE_TYPE_MAGICAL,
		}
		 
		ApplyDamage(damageTable)

		if debug_drawing == true then
					
			DebugDrawText(unit:GetAbsOrigin() + Vector(0,0,300), "1500", true, 2)
			
		end 
	else
		local damageTable = {
			victim = unit,
			attacker = boss,
			damage = 50000,
			damage_type = DAMAGE_TYPE_MAGICAL,
		}
		 
		ApplyDamage(damageTable)
		if debug_drawing == true then
					
			DebugDrawText(unit:GetAbsOrigin() + Vector(0,0,300), "50000", true, 2)
			
		end 
	end
end

function earth_enrage( event )
	local caster = event.caster
	local ability = event.ability

	

	local stun_ab = caster:FindAbilityByName("earth_boss_armor")

	local center = bossLocs[currentBoss]

	CustomGameEventManager:Send_ServerToAllClients("start_ability_timer", { 
	  reference_number = 10,
	  duration = 20
	  })

	caster:SetMana(0)

	FindClearSpaceForUnit(caster, center, true)

	local effect_count = 1

	Timers:CreateTimer(function()

		local enrage_start_effect = ParticleManager:CreateParticle("particles/econ/items/sven/sven_cyclopean_marauder/sven_cyclopean_warcry.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(enrage_start_effect, 0, caster:GetAbsOrigin())

		print(effect_count)

		if effect_count <= 0 then
			return
		else
			effect_count = effect_count - 0.2
			return 0.2
		end
	end)



	Timers:CreateTimer(1, function()

		local slam_group = FindUnitsInRadius(DOTA_TEAM_NEUTRALS, caster:GetAbsOrigin(), nil, 3000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		if slam_group ~= nil then
			for k,v in pairs(slam_group) do
				if v:GetUnitLabel() == "earth_orb" then

					local earth_orb_effect_slam = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_warstomp.vpcf", PATTACH_ABSORIGIN, boss)
					ParticleManager:SetParticleControl(earth_orb_effect_slam, 0, v:GetAbsOrigin())

					if debug_drawing == true then
						DebugDrawCircle(v:GetAbsOrigin(), Vector(255,0,0), 1, 250, true, 1)
					end

					local slam_orb_group = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, v:GetAbsOrigin(), nil, 250, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
					if slam_orb_group ~= nil then
						for _,unit in pairs(slam_orb_group) do
							local damageTable = {
								victim = unit,
								attacker = caster,
								damage = 450,
								damage_type = DAMAGE_TYPE_MAGICAL,
							}
							 
							ApplyDamage(damageTable)

							if difficulty_mode >=2 then
								stun_ab:ApplyDataDrivenModifier(caster, unit, "modifier_earth_orb_stun", {duration = 1})
							end
						end
					end
					v:ForceKill(false)
				end
			end
		end	

		local enrage_group = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, center, nil, 4000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		if enrage_group ~= nil then
			for k,v in pairs(enrage_group) do				
				ability:ApplyDataDrivenModifier(caster, v, "modifier_earth_enrage_slow", {duration = 18}) 
			end
		end

		ScreenShake(caster:GetAbsOrigin(), 1000, 1000, 18, 4000, 0, true)

	end)
end

function earth_mana_check( event )

	local caster = event.caster
	local mod_name = "modifier_earth_diff_attack_damage"
	local ability = boss:FindAbilityByName("earth_boss_armor")

	if caster:GetMana() == caster:GetMaxMana() and boss:HasModifier("modifier_earth_casting") == false and boss:HasModifier("modifier_earth_ult_casting") == false and boss:HasModifier("modifier_earth_charge") == false and boss:HasModifier("modifier_earth_pummel_animation") == false then

		local newOrder = {
	 		UnitIndex = boss:entindex(), 
	 		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
	 		AbilityIndex = boss:GetAbilityByIndex(9):GetEntityIndex(), 
	 		Queue = 0
	 	}

	 	EmitGlobalSound("Imposs.boss_earth_ult")
		 
		ExecuteOrderFromTable(newOrder)

	end

	if difficulty_mode >=3 then
		if (boss:GetHealth() <= boss:GetMaxHealth() * 0.8) and (boss:GetHealth() > boss:GetMaxHealth() * 0.6) then
			if caster:HasModifier(mod_name) == false then

				ability:ApplyDataDrivenModifier(caster, caster, mod_name, nil) 

				caster:SetModifierStackCount( mod_name, ability, 1)

			end

		elseif (boss:GetHealth() <= boss:GetMaxHealth() * 0.6) and (boss:GetHealth() > boss:GetMaxHealth() * 0.4) then

			caster:SetModifierStackCount( mod_name, ability, 2)

		elseif (boss:GetHealth() <= boss:GetMaxHealth() * 0.4) and (boss:GetHealth() > boss:GetMaxHealth() * 0.2) then

			caster:SetModifierStackCount( mod_name, ability, 3)

		elseif (boss:GetHealth() <= boss:GetMaxHealth() * 0.2) and boss:GetHealth() > 0 then

			caster:SetModifierStackCount( mod_name, ability, 4)

		end
	end

end

function earth_boss_diff( event )
	local caster = event.caster
	local ability = event.ability

	EmitGlobalSound("Imposs.boss_earth_start") --[[Returns:void
	Play named sound for all players
	]]

	if difficulty_mode >=2 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_earth_diff_attack_speed", nil)
	end

end
		
