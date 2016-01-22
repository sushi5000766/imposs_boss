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
