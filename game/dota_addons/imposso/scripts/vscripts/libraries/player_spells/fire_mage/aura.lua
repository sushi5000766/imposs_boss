function spell_mana( keys )
	local target = keys.unit
	local ability = keys.ability
	local restore_amount = 20

	local attack_effect = ParticleManager:CreateParticle("particles/econ/items/antimage/antimage_weapon_basher_ti5_gold/am_manaburn_basher_ti_5_b_gold.vpcf", PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControl(attack_effect, 0, target:GetAbsOrigin())

	target:SetMana((target:GetMana() + restore_amount))
end

function attack_mana( keys )
	local target = keys.attacker
	local ability = keys.ability
	local restore_amount = 30

	local attack_effect = ParticleManager:CreateParticle("particles/econ/items/antimage/antimage_weapon_basher_ti5_gold/am_manaburn_basher_ti_5_b_gold.vpcf", PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControl(attack_effect, 0, target:GetAbsOrigin())	

	target:SetMana((target:GetMana() + restore_amount))
end

function restore_mana( event )
	local hCaster = event.caster
	local enrage_group = FindUnitsInRadius( hCaster:GetTeamNumber(), hCaster:GetAbsOrigin(), nil, 500.0, DOTA_TEAM_GOODGUYS, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	for k, v in pairs( enrage_group ) do
		if v ~= hCaster then
			v:SetMana((v:GetMana() + 24))
		end
	end
end

function incinerate( event )
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local damage = ability:GetLevelSpecialValueFor( "damage" , ability:GetLevel() - 1  )

	if target:HasModifier("fire_align") == true then

		local damageTable = {
			victim = target,
			attacker = caster,
			damage = 0,
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
end

function meteor( event )
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local damage = ability:GetLevelSpecialValueFor( "damage" , ability:GetLevel() - 1  )
	local reduction = ability:GetLevelSpecialValueFor( "reduction" , ability:GetLevel() - 1  )
	local reduce = reduction / 100

	local count = 4

	local dam = damage * reduce

	local meteor_fm_effect = ParticleManager:CreateParticle("particles/fm_meteor.vpcf", PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControl(meteor_fm_effect, 0, target:GetAbsOrigin() + Vector(0,0,1500))
	ParticleManager:SetParticleControl(meteor_fm_effect, 1, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(meteor_fm_effect, 2, Vector(1.5,0,0))

	Timers:CreateTimer(function()

		ParticleManager:SetParticleControl(meteor_fm_effect, 1, target:GetAbsOrigin())
		count = count - 0.2

		if count > 0 then
			return 0.2
		else
			return
		end

	end)

	Timers:CreateTimer(1.5, function()

		if target:HasModifier("modifier_fm_meteor_debuff") == true then

			local damageTable = {
				victim = target,
				attacker = caster,
				damage = 0,
				damage_type = DAMAGE_TYPE_MAGICAL,
				}				 
			ApplyDamage(damageTable)

		elseif target:HasModifier("fire_align") == true and target:HasModifier("modifier_fm_meteor_debuff") == false then
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
	end)
end

function scorch( event )
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local damage = ability:GetLevelSpecialValueFor( "damage" , ability:GetLevel() - 1  )
	local reduction = ability:GetLevelSpecialValueFor( "reduction" , ability:GetLevel() - 1  )
	local amp = ability:GetLevelSpecialValueFor( "amplify" , ability:GetLevel() - 1  )
	local reduce = reduction / 100
	local add = damage + amp

	local dam = damage * reduce

	if target:HasModifier("water_align") == true or target:HasModifier("ice_align") == true then

		local damageTable = {
			victim = target,
			attacker = caster,
			damage = add,
			damage_type = DAMAGE_TYPE_MAGICAL,
			}				 
		ApplyDamage(damageTable)

	elseif target:HasModifier("fire_align") == true then
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
end