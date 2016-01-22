function shadow_step( event )
	local caster = event.caster
	local target = event.target
	local ability = event.ability

	local castPos = caster:GetAbsOrigin()
	local targetPos = target:GetAbsOrigin()

	local targetFace = target:GetForwardVector()

	local antiVel = (targetFace * -1) * 300

	local telePos = target:GetAbsOrigin() + 175 * antiVel:Normalized()

	local tele_effect = ParticleManager:CreateParticle("particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_loadout.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(tele_effect, 1, castPos)

	local tele_out_effect = ParticleManager:CreateParticle("particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_loadout.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(tele_out_effect, 1, telePos)

	FindClearSpaceForUnit(caster, telePos, true) 
	caster:SetForwardVector((target:GetAbsOrigin()-caster:GetAbsOrigin()):Normalized())


	ability:ApplyDataDrivenModifier(caster, caster, "closein_buff", {duration = 10})
	
end

function back_manaburn( event )
	local attacked = event.target
	attacked:SetMana(attacked:GetMana() - 8)

	local mana_effect = ParticleManager:CreateParticle("particles/generic_gameplay/generic_manaburn.vpcf", PATTACH_ABSORIGIN, attacked)
	ParticleManager:SetParticleControl(mana_effect, 0, attacked:GetAbsOrigin())

end

function amplify( event )
	local target = event.target
	local currentHP = target:GetHealth()
	local removeHP
	if currentHP < 1500 then 
		removeHP = 0
	else
		removeHP = currentHP - 1500
	end
	Timers:CreateTimer(function()
		local hp_check = target:GetHealth() 
		if hp_check <= removeHP and target:HasModifier("shred_debuff") == true then
			target:RemoveModifierByName("shred_debuff")
			return
		elseif target:HasModifier("shred_debuff") == false then
			return
		else
			return 0.1
		end
	end)
end

function assassinate( event )
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local targetFace = target:GetForwardVector()

	if (target:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized():Dot(target:GetForwardVector()) > 0 then
		local damageTable = {
					victim = target,
					attacker = caster,
					damage = 540,
					damage_type = DAMAGE_TYPE_PHYSICAL,
					}				 
		ApplyDamage(damageTable)
	else
		local damageTable = {
					victim = target,
					attacker = caster,
					damage = 450,
					damage_type = DAMAGE_TYPE_PHYSICAL,
					}				 
		ApplyDamage(damageTable)
	end
end

function cripple( event )
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local targetFace = target:GetForwardVector()

	target:SetMana(target:GetMana() - 30) 

	local damageTable = {
				victim = target,
				attacker = caster,
				damage = 200,
				damage_type = DAMAGE_TYPE_PHYSICAL,
				}				 
	ApplyDamage(damageTable)
	
end