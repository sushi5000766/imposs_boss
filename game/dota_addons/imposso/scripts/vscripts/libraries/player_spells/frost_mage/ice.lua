function ice_charge( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1	

	-- Clears any current command and disjoints projectiles
	caster:Stop()
	ProjectileManager:ProjectileDodge(caster)

	ability.ice_path_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_jakiro/jakiro_ice_path_shards.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(ability.ice_path_effect, 0, caster:GetAbsOrigin() )
	ParticleManager:SetParticleControl(ability.ice_path_effect, 1, target:GetAbsOrigin() )
	-- Ability variables
	ability.leap_direction = (target:GetAbsOrigin()-caster:GetAbsOrigin()):Normalized()
	ability.leap_distance = (caster:GetAbsOrigin() - target:GetAbsOrigin()):Length2D() - 50
	ability.leap_speed = 1600 * 1/30
	ability.leap_traveled = 0
end

--[[Moves the caster on the horizontal axis until it has traveled the distance]]
function ice_slide( keys )
	local caster = keys.target
	local ability = keys.ability

	local damage = ability:GetLevelSpecialValueFor( "damage" , ability:GetLevel() - 1  )
	local reduction = ability:GetLevelSpecialValueFor( "reduction" , ability:GetLevel() - 1  )
	local reduce = reduction / 100
	local dam = damage * reduce

	if ability.leap_traveled < ability.leap_distance then
		caster:SetAbsOrigin(caster:GetAbsOrigin() + ability.leap_direction * ability.leap_speed)
		ability.leap_traveled = ability.leap_traveled + ability.leap_speed		
	else
		caster:InterruptMotionControllers(true)
		caster:RemoveModifierByName("slide_mod")
		local slide_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_ancient_apparition/ancient_apparition_ice_blast_explode.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(slide_effect, 3, caster:GetAbsOrigin())
		Timers:CreateTimer(0.2, function()
			ParticleManager:DestroyParticle(ability.ice_path_effect, false)
		end)

		local chargeList = FindUnitsInRadius(DOTA_TEAM_NEUTRALS, caster:GetAbsOrigin(), nil, 200, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		if chargeList ~= nil then
			for k, v in pairs( chargeList ) do 

				if v:HasModifier("ice_align") == true or v:HasModifier("water_align") == true then

					local damageTable = {
						victim = v,
						attacker = caster,
						damage = dam,
						damage_type = DAMAGE_TYPE_MAGICAL,
						}				 
					ApplyDamage(damageTable)

				else
					local damageTable = {
						victim = v,
						attacker = caster,
						damage = damage,
						damage_type = DAMAGE_TYPE_MAGICAL,
						}				 
					ApplyDamage(damageTable)
				end					
			end
		end
	end
end

function ice_shield( event )
	-- Variables
	local target = event.target
	local max_damage_absorb = 750
	local shield_size = 75 -- could be adjusted to model scale

	-- Reset the shield
	target.AphoticShieldRemaining = max_damage_absorb

	-- Particle. Need to wait one frame for the older particle to be destroyed
	Timers:CreateTimer(0.01, function() 
		target.ShieldParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_lich/lich_frost_armor.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		--ParticleManager:SetParticleControl(target.ShieldParticle, 2, target:GetAbsOrigin())
		--ParticleManager:SetParticleControl(target.ShieldParticle, 0, target:GetAbsOrigin())
		

		-- Proper Particle attachment courtesy of BMD. Only PATTACH_POINT_FOLLOW will give the proper shield position
		ParticleManager:SetParticleControlEnt(target.ShieldParticle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(target.ShieldParticle, 2, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	end)
end

function ice_shield_absorb( event )
	-- Variables
	local damage = event.DamageTaken
	local unit = event.unit
	local ability = event.ability
	
	-- Track how much damage was already absorbed by the shield
	local shield_remaining = unit.AphoticShieldRemaining

	-- Check if the unit has the borrowed time modifier
	
	-- If the damage is bigger than what the shield can absorb, heal a portion
	if damage > shield_remaining then
		local newHealth = unit.OldHealth - damage + shield_remaining
		unit:SetHealth(newHealth)
	else
		local newHealth = unit.OldHealth			
		unit:SetHealth(newHealth)
	end

	-- Reduce the shield remaining and remove
	unit.AphoticShieldRemaining = unit.AphoticShieldRemaining-damage
	if unit.AphoticShieldRemaining <= 0 then
		unit.AphoticShieldRemaining = nil
		unit:RemoveModifierByName("modifier_ice_shield")
	end

	if unit.AphoticShieldRemaining then
		--print("Shield Remaining after Absorb: "..unit.AphoticShieldRemaining)
	end
	

end

-- Destroys the particle when the modifier is destroyed. Also plays the sound
function end_ice_particle( event )
	local target = event.target
	ParticleManager:DestroyParticle(target.ShieldParticle,false)
end


-- Keeps track of the targets health
function ice_shield_health( event )
	local target = event.target

	target.OldHealth = target:GetHealth()
end

function ice_field( event )
	local caster = event.caster
	local ability = event.ability

	local damage = ability:GetLevelSpecialValueFor( "damage" , ability:GetLevel() - 1  )
	local reduction = ability:GetLevelSpecialValueFor( "reduction" , ability:GetLevel() - 1  )
	local reduce = reduction / 100
	local dam = damage * reduce

	local fieldList = FindUnitsInRadius(DOTA_TEAM_NEUTRALS, caster:GetAbsOrigin(), nil, 400, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	if fieldList ~= nil then
		for k, v in pairs( fieldList ) do 				    
		    
			if v:HasModifier("water_align") == true or v:HasModifier("water_align") == true then

				local damageTable = {
					victim = target,
					attacker = caster,
					damage = dam,
					damage_type = DAMAGE_TYPE_MAGICAL,
					}				 
				ApplyDamage(damageTable)
				ability:ApplyDataDrivenModifier(caster, v, "field_mod", {duration = 4}) 

			else
				local damageTable = {
					victim = target,
					attacker = caster,
					damage = damage,
					damage_type = DAMAGE_TYPE_MAGICAL,
					}				 
				ApplyDamage(damageTable)
			end

			ability:ApplyDataDrivenModifier(caster, v, "field_mod", {duration = 4}) 		
			
		end
	end

	local cast_pos = caster:GetAbsOrigin()
	local angle = 0
	local dist = 0
	local change = 0

	local field_effect = ParticleManager:CreateParticle("particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(field_effect, 0, cast_pos)

	for i=0, 15 do

		if i <= 5 then
		
			dist = 150
			change = 60
		else
			dist = 300
			change = 45
		end
		

		local effect_pos = cast_pos + Vector(math.cos(math.rad(angle)), math.sin(math.rad(angle)), 0) * dist

		local ice_field_effect = ParticleManager:CreateParticle("particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/maiden_freezing_field_groundshards_arcana1.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(ice_field_effect, 0, effect_pos)
		angle = angle + change
		if angle > 360 then
			angle = angle - 360
		end
	end

	--[[Timers:CreateTimer(.5, function()
		for i=0, 5 do
			ParticleManager:DestroyParticle(ice_field_effect[i], true)
		end
	end)]]--

end

function ice_chill( event )
	local caster = event.caster
	local ability = event.ability

	caster:SetHealth(caster:GetHealth() + 150) 
	caster:SetMana(caster:GetMana() + 20)
end

function insta_cold( event )
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local damage = ability:GetLevelSpecialValueFor( "damage" , ability:GetLevel() - 1  )
	local reduction = ability:GetLevelSpecialValueFor( "reduction" , ability:GetLevel() - 1  )
	local amplify = ability:GetLevelSpecialValueFor( "amplify" , ability:GetLevel() - 1  )
	local reduce = reduction / 100

	local amp = damage + amplify
	local dam = damage * reduce

	if target:HasModifier("fire_align") == true or target:HasModifier("lightning_align") == true then

		local damageTable = {
			victim = target,
			attacker = caster,
			damage = amp,
			damage_type = DAMAGE_TYPE_MAGICAL,
			}				 
		ApplyDamage(damageTable)

	elseif target:HasModifier("water_align") == true and target:HasModifier("ice_align") == true then
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