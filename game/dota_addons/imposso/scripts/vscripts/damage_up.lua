function damage_up_enter(trigger)
	local unit = trigger.activator
	local num = unit:GetPlayerOwnerID()

	if player_gem[num] >= 1 then
		player_gem[num] = player_gem[num] - 1

		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(num), "update_resource", {
	    value = player_gem[num]
	    })

		local light_effect = ParticleManager:CreateParticle("particles/generic_hero_status/hero_levelup.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
		ParticleManager:SetParticleControl(light_effect, 0, unit:GetAbsOrigin())

		for i=0, 10 do 
	      abHero = unit:GetAbilityByIndex(i)
	      if abHero ~= nil and abHero:GetLevel() < 5 and abHero:GetMaxLevel() > 1 and abHero:GetAbilityName() ~= "mana_up_ab" and abHero:GetAbilityName() ~= "mana_up_ro" and abHero:GetAbilityName() ~= "health_up_ab" then
	        abHero:SetLevel(abHero:GetLevel() + 1)
	      end
	    end
	    unit:EmitSound("Hero_Chen.HandOfGodHealHero")
	else
		return
	end
end
 
function health_up_enter(trigger)
	local unit = trigger.activator
	local num = unit:GetPlayerOwnerID()

	if player_gem[num] >= 1 and unit:HasModifier("tank_avatar") == false then
		player_gem[num] = player_gem[num] - 1

	    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(num), "update_resource", {
	    value = player_gem[num]
	    })

		local light_effect = ParticleManager:CreateParticle("particles/generic_hero_status/hero_levelup.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
		ParticleManager:SetParticleControl(light_effect, 0, unit:GetAbsOrigin())

		for i=0, 10 do 
	      abHero = unit:GetAbilityByIndex(i)
	      if abHero ~= nil and abHero:GetLevel() < 6 and abHero:GetMaxLevel() > 1 then
	      	if abHero:GetAbilityName() == "health_up_ab" then
	        	abHero:SetLevel(abHero:GetLevel() + 1)
	        	unit:CalculateStatBonus()
	        end
	      end
	    end
		unit:EmitSound("Hero_Chen.HandOfGodHealHero")
	else
		return
	end
end

function mana_up_enter(trigger)
	local unit = trigger.activator
	local num = unit:GetPlayerOwnerID()

	if player_gem[num] >= 1 then
		player_gem[num] = player_gem[num] - 1

		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(num), "update_resource", {
	    value = player_gem[num]
	    })

		local light_effect = ParticleManager:CreateParticle("particles/generic_hero_status/hero_levelup.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
		ParticleManager:SetParticleControl(light_effect, 0, unit:GetAbsOrigin())

		for i=0, 10 do 
	      abHero = unit:GetAbilityByIndex(i)
	      if abHero ~= nil and abHero:GetLevel() < 6 and abHero:GetMaxLevel() > 1 then
	      	if abHero:GetAbilityName() == "mana_up_ab" or abHero:GetAbilityName() == "mana_up_ro" then
	        	abHero:SetLevel(abHero:GetLevel() + 1)
	        	unit:CalculateStatBonus()
	        end
	      end
	    end
	    unit:EmitSound("Hero_Chen.HandOfGodHealHero")
	else
		return
	end
end

function movement_up_enter(trigger)
	local unit = trigger.activator
	local num = unit:GetPlayerOwnerID()

	if player_gem[num] >= 1 then
		player_gem[num] = player_gem[num] - 1

		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(num), "update_resource", {
	    value = player_gem[num]
	    })

		local light_effect = ParticleManager:CreateParticle("particles/generic_hero_status/hero_levelup.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
		ParticleManager:SetParticleControl(light_effect, 0, unit:GetAbsOrigin())

		unit:SetBaseMoveSpeed(unit:GetBaseMoveSpeed() + 25)
		unit:EmitSound("Hero_Chen.HandOfGodHealHero")
	else
		return
	end
end

function wall_hit(trigger) --earth areana wall stop
	local unit = trigger.activator
	local num = unit:GetPlayerOwnerID()

	

	if unit:HasModifier('modifier_knockback') then
		unit:RemoveModifierByName('modifier_knockback') 

		local dist = (unit:GetAbsOrigin() - boss:GetAbsOrigin()):Length2D()

		print(dist / 2)

		local damageTable = {
			victim = unit,
			attacker = boss,
			damage = (dist / 2),
			damage_type = DAMAGE_TYPE_MAGICAL,
		}
		ApplyDamage(damageTable)

		local slam_hit = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_warstomp.vpcf", PATTACH_ABSORIGIN, unit)
		ParticleManager:SetParticleControl(slam_hit, 0, unit:GetAbsOrigin())
	end

	unit:InterruptMotionControllers(true)

end

function earth_top_portal(trigger)
	local unit = trigger.activator
	local num = unit:GetPlayerOwnerID()
	local ability = boss:FindAbilityByName("earth_boss_armor")

	if unit:HasModifier('modifier_knockback') == false and earth_portals_open == true and unit:IsHero() == true then

		local top = Vector(5530, 6227, 0)
		local right = Vector(6560, 5184, 0)
		local bot = Vector(5440, 4192, 0)
		local left = Vector(4448, 5280, 0)

		--Roll and movement

		local chance = RandomInt(1, 3)

		local earth_portal = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_test_of_faith.vpcf", PATTACH_ABSORIGIN, unit)
		ParticleManager:SetParticleControl(earth_portal, 0, unit:GetAbsOrigin())

		if chance == 1 then
			FindClearSpaceForUnit(unit, right, true)

			local earth_portal_end = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_test_of_faith.vpcf", PATTACH_ABSORIGIN, unit)
			ParticleManager:SetParticleControl(earth_portal_end, 0, right)

		elseif chance == 2 then
			FindClearSpaceForUnit(unit, bot, true)

			local earth_portal_end = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_test_of_faith.vpcf", PATTACH_ABSORIGIN, unit)
			ParticleManager:SetParticleControl(earth_portal_end, 0, bot)

		elseif chance == 3 then
			FindClearSpaceForUnit(unit, left, true)

			local earth_portal_end = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_test_of_faith.vpcf", PATTACH_ABSORIGIN, unit)
			ParticleManager:SetParticleControl(earth_portal_end, 0, left)
		end

		PlayerResource:SetCameraTarget(num, unit)
		Timers:CreateTimer(0.1, function()
			PlayerResource:SetCameraTarget(num, nil)
		end)

		--Damage and portal stacks

		if unit:HasModifier("portal_stack") == false then
			stack_damage = 25
		else
			stack_damage = 25 * unit:GetModifierStackCount("portal_stack", ability)
		end

		local damageTable = {
			victim = unit,
			attacker = boss,
			damage = 500 + stack_damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
		}
		 
		ApplyDamage(damageTable)

		if unit:HasModifier("portal_stack") == false then

			ability:ApplyDataDrivenModifier(boss, unit, "portal_stack", nil) 

			unit:SetModifierStackCount( "portal_stack", ability, 1)

		elseif unit:HasModifier("portal_stack") == true then
			local stack_count = unit:GetModifierStackCount("portal_stack", ability)
				
			local stack_count = stack_count + 1

			unit:SetModifierStackCount( "portal_stack", ability, stack_count)
			
		end
	end
end

function earth_right_portal(trigger)
	local unit = trigger.activator
	local num = unit:GetPlayerOwnerID()
	local ability = boss:FindAbilityByName("earth_boss_armor")

	if unit:HasModifier('modifier_knockback') == false and earth_portals_open == true and unit:IsHero() == true then

		local top = Vector(5530, 6227, 0)
		local right = Vector(6560, 5184, 0)
		local bot = Vector(5440, 4192, 0)
		local left = Vector(4448, 5280, 0)

		--Roll and movement

		local chance = RandomInt(1, 3)

		local stack_damage = 0

		local earth_portal = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_test_of_faith.vpcf", PATTACH_ABSORIGIN, unit)
		ParticleManager:SetParticleControl(earth_portal, 0, unit:GetAbsOrigin())

		if chance == 1 then
			FindClearSpaceForUnit(unit, top, true)

			local earth_portal_end = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_test_of_faith.vpcf", PATTACH_ABSORIGIN, unit)
			ParticleManager:SetParticleControl(earth_portal_end, 0, top)

		elseif chance == 2 then
			FindClearSpaceForUnit(unit, bot, true)

			local earth_portal_end = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_test_of_faith.vpcf", PATTACH_ABSORIGIN, unit)
			ParticleManager:SetParticleControl(earth_portal_end, 0, bot)

		elseif chance == 3 then
			FindClearSpaceForUnit(unit, left, true)

			local earth_portal_end = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_test_of_faith.vpcf", PATTACH_ABSORIGIN, unit)
			ParticleManager:SetParticleControl(earth_portal_end, 0, left)
		end

		PlayerResource:SetCameraTarget(num, unit)
		Timers:CreateTimer(0.1, function()
			PlayerResource:SetCameraTarget(num, nil)
		end)

		--Damage and portal stacks

		if unit:HasModifier("portal_stack") == false then
			stack_damage = 25
		else
			stack_damage = 25 * unit:GetModifierStackCount("portal_stack", ability)
		end

		local damageTable = {
			victim = unit,
			attacker = boss,
			damage = 500 + stack_damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
		}
		 
		ApplyDamage(damageTable)

		if unit:HasModifier("portal_stack") == false then

			ability:ApplyDataDrivenModifier(boss, unit, "portal_stack", nil) 

			unit:SetModifierStackCount( "portal_stack", ability, 1)

		elseif unit:HasModifier("portal_stack") == true then
			local stack_count = unit:GetModifierStackCount("portal_stack", ability)
				
			local stack_count = stack_count + 1

			unit:SetModifierStackCount( "portal_stack", ability, stack_count)
			
		end
	end
end

function earth_bot_portal(trigger)
	local unit = trigger.activator
	local num = unit:GetPlayerOwnerID()
	local ability = boss:FindAbilityByName("earth_boss_armor")

	if unit:HasModifier('modifier_knockback') == false and earth_portals_open == true and unit:IsHero() == true then

		local top = Vector(5530, 6227, 0)
		local right = Vector(6560, 5184, 0)
		local bot = Vector(5440, 4192, 0)
		local left = Vector(4448, 5280, 0)

		--Roll and movement

		local chance = RandomInt(1, 3)

		local earth_portal = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_test_of_faith.vpcf", PATTACH_ABSORIGIN, unit)
		ParticleManager:SetParticleControl(earth_portal, 0, unit:GetAbsOrigin())

		if chance == 1 then
			FindClearSpaceForUnit(unit, right, true)

			local earth_portal_end = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_test_of_faith.vpcf", PATTACH_ABSORIGIN, unit)
			ParticleManager:SetParticleControl(earth_portal_end, 0, right)

		elseif chance == 2 then
			FindClearSpaceForUnit(unit, top, true)

			local earth_portal_end = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_test_of_faith.vpcf", PATTACH_ABSORIGIN, unit)
			ParticleManager:SetParticleControl(earth_portal_end, 0, top)

		elseif chance == 3 then
			FindClearSpaceForUnit(unit, left, true)

			local earth_portal_end = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_test_of_faith.vpcf", PATTACH_ABSORIGIN, unit)
			ParticleManager:SetParticleControl(earth_portal_end, 0, left)
		end

		PlayerResource:SetCameraTarget(num, unit)
		Timers:CreateTimer(0.1, function()
			PlayerResource:SetCameraTarget(num, nil)
		end)

		--Damage and portal stacks

		if unit:HasModifier("portal_stack") == false then
			stack_damage = 25
		else
			stack_damage = 25 * unit:GetModifierStackCount("portal_stack", ability)
		end

		local damageTable = {
			victim = unit,
			attacker = boss,
			damage = 500 + stack_damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
		}
		 
		ApplyDamage(damageTable)

		if unit:HasModifier("portal_stack") == false then

			ability:ApplyDataDrivenModifier(boss, unit, "portal_stack", nil) 

			unit:SetModifierStackCount( "portal_stack", ability, 1)

		elseif unit:HasModifier("portal_stack") == true then
			local stack_count = unit:GetModifierStackCount("portal_stack", ability)
				
			local stack_count = stack_count + 1

			unit:SetModifierStackCount( "portal_stack", ability, stack_count)
			
		end
	end
end

function earth_left_portal(trigger)
	local unit = trigger.activator
	local num = unit:GetPlayerOwnerID()
	local ability = boss:FindAbilityByName("earth_boss_armor")

	if unit:HasModifier('modifier_knockback') == false and earth_portals_open == true and unit:IsHero() == true then

		local top = Vector(5530, 6227, 0)
		local right = Vector(6560, 5184, 0)
		local bot = Vector(5440, 4192, 0)
		local left = Vector(4448, 5280, 0)

		--Roll and movement

		local chance = RandomInt(1, 3)

		local earth_portal = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_test_of_faith.vpcf", PATTACH_ABSORIGIN, unit)
		ParticleManager:SetParticleControl(earth_portal, 0, unit:GetAbsOrigin())

		if chance == 1 then
			FindClearSpaceForUnit(unit, right, true)

			local earth_portal_end = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_test_of_faith.vpcf", PATTACH_ABSORIGIN, unit)
			ParticleManager:SetParticleControl(earth_portal_end, 0, right)

		elseif chance == 2 then
			FindClearSpaceForUnit(unit, bot, true)

			local earth_portal_end = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_test_of_faith.vpcf", PATTACH_ABSORIGIN, unit)
			ParticleManager:SetParticleControl(earth_portal_end, 0, bot)

		elseif chance == 3 then
			FindClearSpaceForUnit(unit, top, true)

			local earth_portal_end = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_test_of_faith.vpcf", PATTACH_ABSORIGIN, unit)
			ParticleManager:SetParticleControl(earth_portal_end, 0, top)
		end

		PlayerResource:SetCameraTarget(num, unit)
		Timers:CreateTimer(0.1, function()
			PlayerResource:SetCameraTarget(num, nil)
		end)

		--Damage and portal stacks

		if unit:HasModifier("portal_stack") == false then
			stack_damage = 0
		else
			stack_damage = 25 * unit:GetModifierStackCount("portal_stack", ability)
		end

		local damageTable = {
			victim = unit,
			attacker = boss,
			damage = 500 + stack_damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
		}
		 
		ApplyDamage(damageTable)

		if unit:HasModifier("portal_stack") == false then

			ability:ApplyDataDrivenModifier(boss, unit, "portal_stack", nil) 

			unit:SetModifierStackCount( "portal_stack", ability, 1)

		elseif unit:HasModifier("portal_stack") == true then
			local stack_count = unit:GetModifierStackCount("portal_stack", ability)
				
			local stack_count = stack_count + 1

			unit:SetModifierStackCount( "portal_stack", ability, stack_count)
			
		end
	end
end