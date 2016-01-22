

function Reincarnation( event )
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
	local caster_mana = caster:GetMaxMana() * 15 / 100

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