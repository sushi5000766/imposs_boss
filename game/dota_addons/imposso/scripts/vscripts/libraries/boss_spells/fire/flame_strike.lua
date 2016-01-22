function flame_strike( event )
	local hCaster = event.caster
	local flame_dummy = CreateUnitByName("npc_dummy_unit", hCaster:GetAbsOrigin(), false, nil, nil, DOTA_TEAM_NEUTRALS)
	local flamePass = flame_dummy:GetAbilityByIndex(0)
	flamePass:SetLevel(1)
	local flame_team = flame_dummy:GetTeamNumber()
	local unitTable = FindUnitsInRadius(flame_dummy:GetTeamNumber(), flame_dummy:GetAbsOrigin(), nil, 2000.0, DOTA_TEAM_GOODGUYS, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)	
	
	Timers:CreateTimer(0.1,function()
		FindClearSpaceForUnit(flame_dummy, flame_dummy:GetAbsOrigin(), true)
	end)


	local count = 0

	
	if unitTable ~= nil then
		for k ,unit in pairs(unitTable) do
			count = (count + 1)
		end


		if count > 0 then
			local picked = unitTable[RandomInt(1, count)]
			local hPos = picked:GetAbsOrigin() 


			local crack_effect = ParticleManager:CreateParticle("particles/flame_strike_cracks.vpcf", PATTACH_ABSORIGIN, picked)
			ParticleManager:SetParticleControl(crack_effect, 1, hPos)

			local fire_effect

			Timers:CreateTimer(1, function()
				fire_effect = ParticleManager:CreateParticle("particles/flame_strike_fire.vpcf", PATTACH_ABSORIGIN, picked)
				ParticleManager:SetParticleControl(fire_effect, 0, hPos)
				return
			end)

			local hpos
			local flame_time = 8

			Timers:CreateTimer(1, function()

				flame_time = (flame_time - 1)
				local flameTable = FindUnitsInRadius(flame_team, hPos, nil, 400.0, DOTA_TEAM_GOODGUYS, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
				
				if flameTable ~= nil then
					for k ,unit in pairs(flameTable) do
		   				if unit:IsHero() == true then
		   					local damageTable = {
							victim = unit,
							attacker = flame_dummy,
							damage = 75,
							damage_type = DAMAGE_TYPE_PURE,
							}				 
							ApplyDamage(damageTable)
						end
					end
				end

				if flame_time == 0 then
					ParticleManager:DestroyParticle(fire_effect, true)		
					unitTable = nil
					flameTable = nil
					return
				else
					return 1
				end
			end)
		end
	end	
end

function flame_strike_five( event )

	local hCaster = event.caster

	local pos1 = hCaster:GetAbsOrigin() + Vector(150,0,0)
	local pos2 = hCaster:GetAbsOrigin() + Vector(-150,0,0)
	local pos3 = hCaster:GetAbsOrigin() + Vector(0,150,0)
	local pos4 = hCaster:GetAbsOrigin() + Vector(0,-150,0)

	local crack_effect_five1 = ParticleManager:CreateParticle("particles/flame_strike_cracks.vpcf", PATTACH_ABSORIGIN, hCaster)
	ParticleManager:SetParticleControl(crack_effect_five1, 1, pos1)

	local fire_effect

	Timers:CreateTimer(1, function()
		fire_effect_five1 = ParticleManager:CreateParticle("particles/flame_strike_fire.vpcf", PATTACH_ABSORIGIN, hCaster)
		ParticleManager:SetParticleControl(fire_effect_five1, 0, pos1)
		return
	end)

	local crack_effect_five2 = ParticleManager:CreateParticle("particles/flame_strike_cracks.vpcf", PATTACH_ABSORIGIN, hCaster)
	ParticleManager:SetParticleControl(crack_effect_five2, 1, pos2)

	local fire_effect

	Timers:CreateTimer(1, function()
		fire_effect_five2 = ParticleManager:CreateParticle("particles/flame_strike_fire.vpcf", PATTACH_ABSORIGIN, hCaster)
		ParticleManager:SetParticleControl(fire_effect_five2, 0, pos2)
		return
	end)

	local crack_effect_five3 = ParticleManager:CreateParticle("particles/flame_strike_cracks.vpcf", PATTACH_ABSORIGIN, hCaster)
	ParticleManager:SetParticleControl(crack_effect_five3, 1, pos3)

	local fire_effect

	Timers:CreateTimer(1, function()
		fire_effect_five3 = ParticleManager:CreateParticle("particles/flame_strike_fire.vpcf", PATTACH_ABSORIGIN, hCaster)
		ParticleManager:SetParticleControl(fire_effect_five3, 0, pos3)
		return
	end)

	local crack_effect_five4 = ParticleManager:CreateParticle("particles/flame_strike_cracks.vpcf", PATTACH_ABSORIGIN, hCaster)
	ParticleManager:SetParticleControl(crack_effect_five4, 1, pos4)

	local fire_effect

	Timers:CreateTimer(1, function()
		fire_effect_five4 = ParticleManager:CreateParticle("particles/flame_strike_fire.vpcf", PATTACH_ABSORIGIN, hCaster)
		ParticleManager:SetParticleControl(fire_effect_five4, 0, pos4)
		return
	end)
	
	local fire_effect_five = {fire_effect_five1, fire_effect_five2, fire_effect_five3, fire_effect_five4}
	local flame_five_time = 6

	Timers:CreateTimer(1, function()
		flame_five_time = (flame_five_time - 1)
		local flameTablefive = FindUnitsInRadius(hCaster:GetTeamNumber(), hCaster:GetAbsOrigin(), nil, 600.0, DOTA_TEAM_GOODGUYS, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		
		if flameTablefive ~= nil then
			for k ,unit in pairs(flameTablefive) do
   				if unit:IsHero() == true then
   					local damageTable = {
					victim = unit,
					attacker = hCaster,
					damage = 150,
					damage_type = DAMAGE_TYPE_PURE,
					}				 
					ApplyDamage(damageTable)
				end
			end
		end

		if flame_five_time == 0 then
			for k, v in pairs( fire_effect_five ) do
				ParticleManager:DestroyParticle(fire_effect_five[k], true)	
			end	
			flameTablefive = nil
			return
		else
			return 1
		end
	end)
end