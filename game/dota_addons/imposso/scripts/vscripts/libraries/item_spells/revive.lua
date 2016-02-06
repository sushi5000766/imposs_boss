

--[[function Reincarnation( event )
	local caster = event.unit
	local attacker = event.attacker
	local ability = event.ability
	local casterHP = caster:GetHealth()
	
	print("Reincarnate")
	-- Variables for Reincarnation
	local reincarnate_time = 5.0
	local casterGold = caster:GetGold()
	local respawnPosition = caster:GetAbsOrigin()

	-- Kill, counts as death for the player but doesn't count the kill for the killer unit
	caster:SetHealth(1)
	caster:Kill(caster, nil)
	caster:SetGold(casterGold, false)

	-- Set the short respawn time and respawn position
	caster:SetTimeUntilRespawn(reincarnate_time) 
	caster:SetRespawnPosition(respawnPosition)

	local Reincarnation_unit = CreateUnitByName("npc_reincarnation_unit", respawnPosition, false, nil, caster:GetPlayerOwner(), caster:GetTeamNumber())
	local abRein = Reincarnation_unit:GetAbilityByIndex(0)
	abRein:SetLevel(1)

	local death_glow = ParticleManager:CreateParticle("particles/econ/items/dazzle/dazzle_pipe_dezun/dazzle_pipe_dezun_beam_glow.vpcf", PATTACH_ABSORIGIN, Reincarnation_unit)
	ParticleManager:SetParticleControl(death_glow, 0, Reincarnation_unit:GetAbsOrigin())

	



	Timers:CreateTimer(5.1, function()		
		ParticleManager:DestroyParticle(death_glow, true)
		local rebirth_glow = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_purification.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(rebirth_glow, 0,caster:GetAbsOrigin())
		UTIL_Remove(Reincarnation_unit)

		local dummy = CreateUnitByName("npc_dummy_unit", (caster:GetAbsOrigin() + Vector(1000,0,0)), false, nil, caster:GetPlayerOwner(), caster:GetTeamNumber())
		dummy:AddAbility("revive_ability")
		local abDummy = dummy:GetAbilityByIndex(0)
		local abRevive = dummy:GetAbilityByIndex(1)
		abDummy:SetLevel(1)
		abRevive:ApplyDataDrivenModifier(dummy, caster, "revive_buff", {duration = 3})
		dummy:ForceKill(false)

		for i=0, 5 do
			local revive_item = caster:GetItemInSlot(i)
			if revive_item ~= nil and revive_item:GetName() == "item_revive_item" then
				local revive_count = revive_item:GetCurrentCharges()
				if revive_count == 1 then
					caster:RemoveItem(revive_item)
				else
					revive_item:SetCurrentCharges((revive_count - 1))
				end
			end
		end
	end)
end

function no_revive( event )
	local caster = event.unit
	local attacker = event.attacker
	local ability = event.ability

	local caster_hp = caster:GetMaxHealth() * 40 / 100
	local caster_mana = 0

	local respawnPosition = caster:GetAbsOrigin()	

	if caster:HasItemInInventory("item_revive_item") == false then

		local grave_unit = CreateUnitByName("npc_grave_unit", respawnPosition, false, nil, caster:GetPlayerOwner(), caster:GetTeamNumber())
		print(grave_unit:GetName())

		print(grave_unit:GetClassname())
		local abGrave = grave_unit:GetAbilityByIndex(0)
		abGrave:SetLevel(1)

		caster:SetRespawnPosition(respawnPosition)
		Timers:CreateTimer(function()
			if caster:IsAlive() == false and grave_unit:HasModifier("grave_buff") == false then
				caster:SetTimeUntilRespawn(1)
				return 0.2
			elseif caster:IsAlive() == false and grave_unit:HasModifier("grave_buff") == true then
				caster:SetTimeUntilRespawn(0)
				Timers:CreateTimer(0.2, function()
					local dummy = CreateUnitByName("npc_dummy_unit", (caster:GetAbsOrigin() + Vector(1000,0,0)), false, nil, caster:GetPlayerOwner(), caster:GetTeamNumber())
					dummy:AddAbility("revive_ability")
					local abDummy = dummy:GetAbilityByIndex(0)
					local abRevive = dummy:GetAbilityByIndex(1)
					abDummy:SetLevel(1)
					abRevive:ApplyDataDrivenModifier(dummy, caster, "revive_buff", {duration = 2})
					dummy:ForceKill(false)
					caster:SetHealth(caster_hp)
					caster:SetMana(caster_mana)
					Timers:CreateTimer(0.1, function()
						caster:SetHealth(caster_hp)
						caster:SetMana(caster_mana)
					end)
				end)
				UTIL_Remove(grave_unit)
				return
			end
		end)		
	end
end

function grave_apply( event )
	local caster = event.caster
	local target = event.target
	local ability = event.ability

	local dummy = CreateUnitByName("npc_dummy_unit", (caster:GetAbsOrigin() + Vector(1000,0,0)), false, nil, caster:GetPlayerOwner(), caster:GetTeamNumber())
	dummy:AddAbility("revive_ability")
	local abDummy = dummy:GetAbilityByIndex(0)
	local abRevive = dummy:GetAbilityByIndex(1)
	abDummy:SetLevel(1)
	abRevive:ApplyDataDrivenModifier(dummy, target, "grave_buff", {duration = 3})
	dummy:ForceKill(false)

	local revive_glow = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_test_of_faith.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(revive_glow, 0, target:GetAbsOrigin())

	for i=0, 5 do
			local revive_item = caster:GetItemInSlot(i)
			if revive_item ~= nil and revive_item:GetName() == "item_team_revive_item" then
				local revive_count = revive_item:GetCurrentCharges()
				if revive_count == 1 then
					caster:RemoveItem(revive_item)
				else
					revive_item:SetCurrentCharges((revive_count - 1))
				end
			end
	end
end]]--

function revive_test( event )
	local caster = event.unit
	local ability = event.ability

	local number = caster:GetPlayerOwnerID()



	local death_health = caster:GetHealth()
	local death_pos = caster:GetAbsOrigin()

	local has_anhk = false


	if death_health == 1 and caster:HasModifier("modifier_pl_blessing") == false then

		if player_deaths[number] == nil then
			player_deaths[number] = 1
		else
			player_deaths[number] = player_deaths[number] + 1
		end

		print("DEATHS")
		print(player_deaths[number])
		print("DEATHS")

		for i=0, 5 do
			local revive_item = caster:GetItemInSlot(i)
			if revive_item ~= nil and revive_item:GetName() == "item_revive_item" then
				has_anhk = true
				local revive_count = revive_item:GetCurrentCharges()
				if revive_count == 1 then
					caster:RemoveItem(revive_item)
				else
					revive_item:SetCurrentCharges((revive_count - 1))
				end
			end
		end

		if has_anhk == true then

			ability:ApplyDataDrivenModifier(caster, caster, "modifier_death_phase", nil)

			caster:AddNoDraw()

			local Reincarnation_unit = CreateUnitByName("npc_reincarnation_unit", death_pos, false, nil, caster:GetPlayerOwner(), caster:GetTeamNumber())
			local abRein = Reincarnation_unit:GetAbilityByIndex(0)
			abRein:SetLevel(1)

			local death_glow = ParticleManager:CreateParticle("particles/econ/items/dazzle/dazzle_pipe_dezun/dazzle_pipe_dezun_beam_glow.vpcf", PATTACH_ABSORIGIN, Reincarnation_unit)
			ParticleManager:SetParticleControl(death_glow, 0, Reincarnation_unit:GetAbsOrigin())

			Timers:CreateTimer(5, function()

				ParticleManager:DestroyParticle(death_glow, true)
				UTIL_Remove(Reincarnation_unit)

				 
				caster:RemoveModifierByName("modifier_death_phase")
				caster:SetHealth(caster:GetMaxHealth())
				caster:SetMana(caster:GetMaxMana())	

				caster:RemoveNoDraw()				

				local rebirth_glow = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_purification.vpcf", PATTACH_ABSORIGIN, caster)
				ParticleManager:SetParticleControl(rebirth_glow, 0,caster:GetAbsOrigin())

			end)

		else
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_death_phase", nil)
			caster:AddNoDraw()
			local grave_unit = CreateUnitByName("npc_grave_unit", death_pos, false, nil, caster, caster:GetTeamNumber())

			local abGrave = grave_unit:GetAbilityByIndex(0)
			abGrave:SetLevel(1)


			local total = 0
			local check = 0
			local final_check = 0

			for k, hero in pairs( heroTable ) do
				total = total + 1
				if hero:HasModifier("modifier_death_phase") == true then
				  check = check + 1
				end
			end

			print("Total Heroes in Arena = " .. total)
			print("Total Heroes Dead = " .. check)

			if check == total then
				Timers:CreateTimer(10, function()
				  for k, hero in pairs( heroTable ) do
				    if hero:HasModifier("modifier_death_phase") == true then
				      final_check = final_check + 1
				    end
				  end

				  print("Total Heroes in Arena = " .. total)
				  print("Total Heroes after Final Check = " .. final_check)

				  if final_check == total then
				    GameRules:MakeTeamLose(DOTA_TEAM_GOODGUYS)
				  end
				end)
			end

			--[[local dummy = CreateUnitByName("npc_dummy_unit", grave_unit:GetAbsOrigin(), false, nil, caster:GetPlayerOwner(), caster:GetTeamNumber())
			dummy:AddAbility("pr_nuke")
			local abDummy = dummy:GetAbilityByIndex(0)
			local abRevive = dummy:GetAbilityByIndex(1)
			abDummy:SetLevel(1)
			abRevive:SetLevel(1)

			Timers:CreateTimer(5, function()

				local newOrder = {
				 		UnitIndex = dummy:entindex(), 
				 		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
				 		TargetIndex = grave_unit:entindex(), --Optional.  Only used when targeting units
				 		AbilityIndex = abRevive:GetEntityIndex(), --Optional.  Only used when casting abilities
				 		Queue = 0 --Optional.  Used for queueing up abilities
				 	}
				 
				ExecuteOrderFromTable(newOrder)

			end)]]--
		end
	end
end

function team_revive( event )
	local target = event.target
	local player_num = target:GetPlayerOwnerID()

	UTIL_Remove(grave)	

	heroTable[player_num]:SetHealth(caster:GetMaxHealth())
	heroTable[player_num]:SetMana(caster:GetMaxMana()) 

	heroTable[player_num]:RemoveModifierByName("modifier_death_phase")
	heroTable[player_num]:RemoveNoDraw()


end

function grave_revive( event )
	local grave = event.target
	local player_num = grave:GetPlayerOwnerID()
	UTIL_Remove(grave)

	
	heroTable[player_num]:RemoveModifierByName("modifier_death_phase")
	heroTable[player_num]:RemoveNoDraw()
end



function mana_give( event )
	local caster = event.caster
	caster:SetMana(caster:GetMana() + 300) 
end

function big_mana_give( event )
	local caster = event.caster
	caster:SetMana(caster:GetMana() + 500) 
end

function test()
	print("fired!!!")
end

function sheild_purge( event )
	local caster = event.caster
	local ability = event.ability

	caster:Purge( true, false, false, false, false )
end

function gold_give( event )
	local caster = event.caster
	local caster_num = caster:GetPlayerOwnerID()
	local gold = PlayerResource:GetGold(caster_num)

	local gold_pick = ParticleManager:CreateParticle("particles/econ/items/alchemist/alchemist_midas_knuckles/alch_knuckles_lasthit_coins.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(gold_pick, 1, caster:GetAbsOrigin())

	if caster:IsHero() == true then
		caster:SetGold((gold + 5), false)
		keys.target:EmitSound("DOTA_Item.Hand_Of_Midas")
	end
end 

--[[
Timers:CreateTimer(RandomFloat(30, 60), function()
    local Ymax = 7104 --Temporary
    local Ymin = 4544
    local Xmax = -3072
    local Xmin = -6976 
    local spot = Vector(RandomInt(Xmin, Xmax), RandomInt(Ymin, Ymax), 0)
    local gold_item = CreateItem("item_gold_drop", nil, nil)
    CreateItemOnPositionSync(spot, gold_item)
    
    return RandomFloat(30, 60)
end)]]-- 