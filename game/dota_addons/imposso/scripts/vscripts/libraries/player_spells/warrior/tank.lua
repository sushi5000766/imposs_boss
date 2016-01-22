
function BerserkersCall( keys )
	local caster = keys.caster
	local target = keys.target

	-- Clear the force attack target
	target:SetForceAttackTarget(nil)

	-- Give the attack order if the caster is alive
	-- otherwise forces the target to sit and do nothing
	if caster:IsAlive() then
		print("alive")
		local order = 
		{
			UnitIndex = target:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
			TargetIndex = caster:entindex()
		}

		ExecuteOrderFromTable(order)
		print("taunted")
	else
		target:Stop()
	end

	-- Set the force attack target to be the caster
	target:SetForceAttackTarget(caster)
end

-- Clears the force attack target upon expiration
function BerserkersCallEnd( keys )
	local target = keys.target

	target:SetForceAttackTarget(nil)
end

function war_charge( keys )
	local caster = keys.caster
	local point = keys.target_points[1]
	local ability = keys.ability

	-- Clears any current command and disjoints projectiles
	caster:Stop()
	--ProjectileManager:ProjectileDodge(caster)

	-- Ability variables
	ability.leap_direction = (point-caster:GetAbsOrigin()):Normalized()
	ability.leap_distance = (caster:GetAbsOrigin() - point):Length2D()
	ability.leap_speed = 1600 * 1/30
	ability.leap_traveled = 0
end

function war_slide( keys )
	local caster = keys.target
	local ability = keys.ability	

	if ability.leap_traveled < ability.leap_distance then
		caster:SetAbsOrigin(caster:GetAbsOrigin() + ability.leap_direction * ability.leap_speed)
		ability.leap_traveled = ability.leap_traveled + ability.leap_speed
	else		
		caster:InterruptMotionControllers(true)
		caster:RemoveModifierByName("war_slide_mod")
	end
	
end

function sizeup( event )
	caster = event.caster
	ability = event.ability

	caster:SetModelScale(1.3)
end

function sizedown( event )
	caster = event.caster
	ability = event.ability

	caster:SetModelScale(1.0)
end

function shop_charge( event )
	caster = event.caster
	ability = event.ability

	if caster:HasModifier("shop_aura_effect") == true then
		caster:Stop()
	end
end