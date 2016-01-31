function bearform( event )

	local caster = event.caster
	local model = event.model
	local ability = event.ability

	--[[local druid_ab = {"fm_counter_spell", "dr_starfall", "dr_renew"}
	local bear_ab = {"dr_maul", "dr_rend", "dr_sprint"}]]--
	local count = 0

	local bear_model = "models/heroes/lone_druid/true_form.vmdl"
	local druid_model = "models/heroes/furion/furion.vmdl"

	local active = {}
	local backup = {}

	for i=0, 2 do
		active[i] = caster:GetAbilityByIndex(i)
	end

	for i=5, 7 do
		backup[count] = caster:GetAbilityByIndex(i)
		count = count + 1
	end

	if caster:GetModelName() == druid_model then 
		-- Sets the new model
		caster:SetOriginalModel(bear_model)

		caster:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK) 

		ability:ApplyDataDrivenModifier(caster, caster, "modifier_dr_attack_range", nil) --[[Returns:void
		No Description Set
		]]

		caster.hiddenWearables = {} -- Keep every wearable handle in a table to show them later
	    local model = caster:FirstMoveChild()
	    while model ~= nil do
	        if model:GetClassname() == "dota_item_wearable" then
	            model:AddEffects(EF_NODRAW) -- Set model hidden
	            table.insert(caster.hiddenWearables, model)
	        end
	        model = model:NextMovePeer()
	    end

		for i=0, 2 do
			caster:SwapAbilities(active[i]:GetAbilityName(), backup[i]:GetAbilityName(), false, true) 
		end

	elseif caster:GetModelName() == bear_model then 
		-- Sets the new model
		caster:SetOriginalModel(druid_model)

		caster:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)

		caster:RemoveModifierByName("modifier_dr_attack_range")

		local hero = event.caster

		for i,v in pairs(caster.hiddenWearables) do
			v:RemoveEffects(EF_NODRAW)
		end

		for i=0, 2 do
			caster:SwapAbilities(active[i]:GetAbilityName(), backup[i]:GetAbilityName(), false, true)
		end
	end

end

function renew( event )
	local caster = event.caster
	local target = event.target
	local ability = event.ability

	if target:GetName() == "npc_dota_hero_phantom_assassin" then
		target:SetMana(target:GetMana() + 1)
	else
		target:SetMana(target:GetMana() + 4)
	end
end

function maul( event )
	local caster = event.caster
	local target = event.target
	local ability = event.ability

	if target:GetHealth() < (target:GetMaxHealth() * .2) then
		local damageTable = {
					victim = target,
					attacker = caster,
					damage = 450,
					damage_type = DAMAGE_TYPE_PHYSICAL,
					}				 
		ApplyDamage(damageTable)
	else
		local damageTable = {
					victim = target,
					attacker = caster,
					damage = 315,
					damage_type = DAMAGE_TYPE_PHYSICAL,
					}				 
		ApplyDamage(damageTable)
	end
end

function bear_cancel( event )
	local caster = event.caster

	if caster:HasModifier("bird_form_mod") == true then
		caster:Stop() 
	end
end

function bird_form( event )

	local caster = event.caster
	local model = event.model
	local ability = event.ability

	--[[local druid_ab = {"fm_counter_spell", "dr_starfall", "dr_renew"}
	local bear_ab = {"dr_maul", "dr_rend", "dr_sprint"}]]--
	local count = 0

	ability.bear_model = "models/heroes/lone_druid/true_form.vmdl"
	ability.druid_model = "models/heroes/furion/furion.vmdl"
	ability.bird_model = "models/heroes/beastmaster/beastmaster_bird.vmdl"

	ability.caster = caster

	ability.original_model = caster:GetModelName()

	print(ability.original_model)

	ability.active = {}
	ability.backup = {}

	ability.swap = caster:GetAbilityByIndex(11)

	for i=0, 2 do
		ability.active[i] = caster:GetAbilityByIndex(i)
	end

	for i=5, 7 do
		ability.backup[count] = caster:GetAbilityByIndex(i)
		count = count + 1
	end

	if caster:GetModelName() == ability.druid_model then 
		-- Sets the new model
		caster:SetOriginalModel(ability.bird_model)

		--ability:ApplyDataDrivenModifier(caster, caster, "mod_attack_range", nil)

		caster.hiddenWearables = {} -- Keep every wearable handle in a table to show them later
	    local model = caster:FirstMoveChild()
	    while model ~= nil do
	        if model:GetClassname() == "dota_item_wearable" then
	            model:AddEffects(EF_NODRAW) -- Set model hidden
	            table.insert(caster.hiddenWearables, model)
	        end
	        model = model:NextMovePeer()
	    end

		caster:SwapAbilities(ability.swap:GetAbilityName(), ability.active[1]:GetAbilityName(), true, false)


	elseif caster:GetModelName() == ability.bear_model then 
		-- Sets the new model
		caster:SetOriginalModel(ability.bird_model)

		caster:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)

		caster:RemoveModifierByName("modifier_dr_attack_range")

		for i=0, 2 do
			caster:SwapAbilities(ability.active[i]:GetAbilityName(), ability.backup[i]:GetAbilityName(), false, true)
		end


		caster:SwapAbilities(ability.swap:GetAbilityName(), ability.backup[1]:GetAbilityName(), true, false)

	end
end

function bird_revert( event )
	local caster = event.caster
	local model = event.model
	local ability = event.ability	

	if ability.original_model == ability.bear_model then 
		-- Sets the new model

		print("ran")
		caster:SetOriginalModel(ability.bear_model)

		caster:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK) 

		ability:ApplyDataDrivenModifier(caster, caster, "modifier_dr_attack_range", nil) --[[Returns:void
		No Description Set
		]]

		caster.hiddenWearables = {} -- Keep every wearable handle in a table to show them later
	    local model = caster:FirstMoveChild()
	    while model ~= nil do
	        if model:GetClassname() == "dota_item_wearable" then
	            model:AddEffects(EF_NODRAW) -- Set model hidden
	            table.insert(caster.hiddenWearables, model)
	        end
	        model = model:NextMovePeer()
	    end

	    caster:SwapAbilities(ability.swap:GetAbilityName(), ability.backup[1]:GetAbilityName(), false, true)

		for i=0, 2 do
			caster:SwapAbilities(ability.active[i]:GetAbilityName(), ability.backup[i]:GetAbilityName(), true, false) 
		end

		caster:ManageModelChanges()

	elseif ability.original_model == ability.druid_model then 

		print("ran2")
		-- Sets the new model
		caster:SetOriginalModel(ability.druid_model)


		caster:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)

		caster:RemoveModifierByName("modifier_dr_attack_range")

		local hero = event.caster

		for i,v in pairs(caster.hiddenWearables) do
			v:RemoveEffects(EF_NODRAW)
		end

		caster:SwapAbilities(ability.swap:GetAbilityName(), ability.active[1]:GetAbilityName(), false, true)

		caster:ManageModelChanges()
		
	end
end


function CastFireSpirits( event )
	local caster	= event.caster
	local ability	= event.ability
	local modifierStackName	= event.modifier_stack_name

	local numSpirits	=  6

	-- Create particle FX
	local particleName = "particles/vera_main.vpcf"
	pfx = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControl( pfx, 1, Vector( numSpirits, 0, 0 ) )
	for i=1, numSpirits do
		ParticleManager:SetParticleControl( pfx, 8+i, Vector( 1, 0, 0 ) )
		print(8+i)
	end

	caster.fire_spirits_numSpirits	= numSpirits
	caster.fire_spirits_pfx			= pfx

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_fire_spirit_stack_datadriven", nil)

	-- Set the stack count
	caster:SetModifierStackCount( modifierStackName, ability, numSpirits )

	-- Apply HP removal
--	ApplyDamage( {
--		victim = caster,
--		attacker = caster,
--		damage = caster:GetHealth() * hpCost / 100,
--		damage_type = DAMAGE_TYPE_PURE,		-- will show the pure damage indicator popup
--	} )

end

--[[
	Author: Ractidous
	Date: 28.01.2015.
	Launch a fire spirit.
]]
function LaunchFireSpirit( event )
	local caster		= event.caster
	local ability		= event.ability
	local modifierName	= event.modifier_stack_name

	-- Update spirits count
	local mainAbility	= caster:FindAbilityByName( event.main_ability_name )
	local currentStack	= caster:GetModifierStackCount( modifierName, mainAbility )
	currentStack = currentStack - 1
	caster:SetModifierStackCount( modifierName, mainAbility, currentStack )

	-- Update the particle FX
	local pfx = caster.fire_spirits_pfx
	ParticleManager:SetParticleControl( pfx, 1, Vector( currentStack, 0, 0 ) )
	for i=1, caster.fire_spirits_numSpirits do
		local radius = 0
		if i <= currentStack then
			radius = 1
		end

		ParticleManager:SetParticleControl( pfx, 8+i, Vector( radius, 0, 0 ) )

		print(8+i)
	end

	-- Remove the stack modifier if all the spirits has been launched.
	if currentStack == 0 then
		caster:RemoveModifierByName( modifierName )
	end
end

--[[
	Author: Ractidous
	Date: 28.01.2015.
	Remove fire spirits' FX.
]]
function RemoveFireSpirits( event )
	local caster	= event.caster
	local ability	= event.ability

	local pfx = caster.fire_spirits_pfx
	ParticleManager:DestroyParticle( pfx, false )

end
