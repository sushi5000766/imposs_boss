function shop_envelop( event )
	caster = event.caster
	ability = event.ability

	if caster:HasModifier("shop_aura_effect") == true then
		caster:Stop()
	end
end

function shadow_staff( event )
	local caster = event.caster
	local ability = event.ability

	if boss:GetHealth() <= (boss:GetMaxHealth() * 0.3) then
		local damageTable = {
			victim = boss,
			attacker = caster,
			damage = 450,
			damage_type = DAMAGE_TYPE_MAGICAL,
			}				 
		ApplyDamage(damageTable)
	else
		local damageTable = {
			victim = boss,
			attacker = caster,
			damage = 200,
			damage_type = DAMAGE_TYPE_MAGICAL,
			}				 
		ApplyDamage(damageTable)
	end
end

function envelop( event )
	local caster = event.caster
	local ability = event.ability
	local damage = ability:GetLevelSpecialValueFor( "damage" , ability:GetLevel() - 1  )
	local reduction = ability:GetLevelSpecialValueFor( "reduction" , ability:GetLevel() - 1  )
	local bonus = ability:GetLevelSpecialValueFor( "bonus" , ability:GetLevel() - 1  )
	local reduce = reduction / 100
	local add = damage + bonus
	local dam = damage * reduce
	local shad_dam = (damage + bonus) * reduce

	if boss:GetHealth() <= (boss:GetMaxHealth() * 0.3) then
		if boss:HasModifier("shadow_align") == true then
			local damageTable = {
				victim = boss,
				attacker = caster,
				damage = shad_dam,
				damage_type = DAMAGE_TYPE_MAGICAL,
				}				 
			ApplyDamage(damageTable)

		else
			local damageTable = {
				victim = boss,
				attacker = caster,
				damage = damage + bonus,
				damage_type = DAMAGE_TYPE_MAGICAL,
				}				 
			ApplyDamage(damageTable)
		end
	else
		if boss:HasModifier("shadow_align") == true then
			local damageTable = {
				victim = boss,
				attacker = caster,
				damage = dam,
				damage_type = DAMAGE_TYPE_MAGICAL,
				}				 
			ApplyDamage(damageTable)

		else
			local damageTable = {
				victim = boss,
				attacker = caster,
				damage = damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				}				 
			ApplyDamage(damageTable)
		end
	end

	local casterTable = {
			victim = caster,
			attacker = boss,
			damage = RandomInt(125, 175),
			damage_type = DAMAGE_TYPE_MAGICAL,
			}				 
	ApplyDamage(casterTable)

	boss:SetMana(boss:GetMana() - 35)

	local envelop_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_nevermore/nevermore_shadowraze.vpcf", PATTACH_ABSORIGIN, boss)
	ParticleManager:SetParticleControl(envelop_effect, 1, boss:GetAbsOrigin())

	local envelop_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_nevermore/nevermore_shadowraze.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(envelop_effect, 1, caster:GetAbsOrigin())

end

function LifeDrainParticle( event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability

	local particleName = "particles/units/heroes/hero_pugna/pugna_life_drain.vpcf"
	caster.LifeDrainParticle = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(caster.LifeDrainParticle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)

end

--[[
	Author: Noya
	Date: April 5, 2015
	When cast on an enemy, drains health from the target enemy unit to heal himself. 
	If the hero has full HP, and the enemy target is a Hero, Life Drain will restore mana instead.
	When cast on an ally, it will drain his own health into his ally.
]]
function LifeDrainHealthTransfer( event )
	local caster = event.caster
	local target = event.target
	local ability = event.ability

	local health_drain = 100
	local tick_rate = 1.0
	local HP_drain = health_drain * tick_rate

	-- HP drained depends on the actual damage dealt. This is for MAGICAL damage type
	local HP_gain = HP_drain * ( 1 - target:GetMagicalArmorValue())
	
	-- Health Transfer Enemy->Caster
	local damageTable = {
			victim = target,
			attacker = caster,
			damage = health_drain,
			damage_type = DAMAGE_TYPE_MAGICAL,
			}				 
	ApplyDamage(damageTable)
	caster:Heal( HP_gain, caster)
	print("life heal")
	-- Set the particle control color as green
	ParticleManager:SetParticleControl(caster.LifeDrainParticle, 10, Vector(0,0,0))
	ParticleManager:SetParticleControl(caster.LifeDrainParticle, 11, Vector(0,0,0))

	
end

function LifeDrainParticleEnd( event )
	local caster = event.caster
	ParticleManager:DestroyParticle(caster.LifeDrainParticle,false)
end