function full_heal( event )
	local caster = event.caster
	local target = event.target

	target:SetHealth(target:GetMaxHealth())
	target:SetMana(target:GetMaxMana())

	local light_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_chakra_magic.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(light_effect, 0, target:GetAbsOrigin() + Vector(0,0,128))
end

function nuke( event )
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local damage = ability:GetLevelSpecialValueFor( "damage" , ability:GetLevel() - 1  )
	local reduction = ability:GetLevelSpecialValueFor( "reduction" , ability:GetLevel() - 1  )
	local amp = ability:GetLevelSpecialValueFor( "amplify" , ability:GetLevel() - 1  )
	local reduce = reduction / 100
	local add = damage + amp
	local dam = damage * reduce

	if target:GetTeamNumber() == 2 then

		local dummy = CreateUnitByName("npc_dummy_unit", (caster:GetAbsOrigin() + Vector(1000,0,0)), false, nil, caster:GetPlayerOwner(), caster:GetTeamNumber())
		dummy:AddAbility("revive_ability")
		local abDummy = dummy:GetAbilityByIndex(0)
		local abRevive = dummy:GetAbilityByIndex(1)
		abDummy:SetLevel(1)

		abRevive:ApplyDataDrivenModifier(dummy, target, "grave_buff", {duration = 3})	

		local healer_glow = ParticleManager:CreateParticle("particles/units/heroes/hero_stormspirit/stormspirit_ball_lightning_end.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(healer_glow, 0, target:GetAbsOrigin())			

		UTIL_Remove(dummy) 

	elseif target:GetTeamNumber() == 4 then

		if target:HasModifier("shadow_align") == true then

			local damageTable = {
				victim = target,
				attacker = caster,
				damage = add,
				damage_type = DAMAGE_TYPE_MAGICAL,
				}				 
			ApplyDamage(damageTable)

		elseif target:HasModifier("light_align") == true then
			local damageTable = {
				victim = target,
				attacker = caster,
				damage = dam,
				damage_type = DAMAGE_TYPE_MAGICAL,
				}				 
			ApplyDamage(damageTable)

		else
			local damageTable = {
				victim = target,
				attacker = caster,
				damage = damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				}				 
			ApplyDamage(damageTable)
		end

		local nuke_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_stormspirit/stormspirit_ball_lightning_end.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(nuke_effect, 0, target:GetAbsOrigin())
	end

end

function pr_buff( event )
	local caster = event.caster
	local target = event.target
	local ability = event.ability

	ability:ApplyDataDrivenModifier(caster, target, "modifier_pr_buff", {duration = 60})

end