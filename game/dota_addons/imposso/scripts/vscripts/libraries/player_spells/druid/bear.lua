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

		ability:ApplyDataDrivenModifier(caster, caster, "mod_attack_range", nil) --[[Returns:void
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

		caster:RemoveModifierByName("mod_attack_range")

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
