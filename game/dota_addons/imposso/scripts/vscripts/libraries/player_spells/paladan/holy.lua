function pre_bless( event )
	local caster = event.caster
	local target = event.target
	local ability = event.ability

	if target ~= caster and target:GetName() == "npc_dota_hero_omniknight" then
		caster:Stop()
	end


end

function blessing_check( event )
	local caster = event.caster
	local target = event.target
	local ability = event.ability

	local buff_time = 8		

	Timers:CreateTimer(function()
		buff_time = buff_time - 0.1
		if target:GetHealth() == 1 then
			target:RemoveModifierByName("blessing_mod")
			ability:ApplyDataDrivenModifier(caster, target, "protection_mod", {duration = 3})
			buff_time = 0
		end

		

		if buff_time == 0 then
			return
		else
			return 0.1
		end
	end)
	
end

function strike_apply( event )
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	--ability:ApplyDataDrivenModifier(caster, caster, "strike_safe", {duration = 2})
	ability:ApplyDataDrivenModifier(caster, caster, "strike_speed", {duration = 9})
end

function paly_mana( event )
	local caster = event.caster
	local cur_mana = caster:GetMana()

	caster:SetMana(cur_mana + 10) 
end

function strike_damage( event )
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local damage = ability:GetLevelSpecialValueFor( "onhit" , ability:GetLevel() - 1  )
	local reduction = ability:GetLevelSpecialValueFor( "reduction" , ability:GetLevel() - 1  )
	local amp = ability:GetLevelSpecialValueFor( "amplify" , ability:GetLevel() - 1  )
	local reduce = reduction / 100
	local add = damage + amp
	local dam = damage * reduce

	if target:HasModifier("light_align") == true then

		local damageTable = {
			victim = target,
			attacker = caster,
			damage = dam,
			damage_type = DAMAGE_TYPE_MAGICAL,
			}				 
		ApplyDamage(damageTable)

	elseif  target:HasModifier("shadow_align") == true then

		local damageTable = {
			victim = target,
			attacker = caster,
			damage = add,
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

	target:SetMana(target:GetMana() - 10)
end

function sacrifice( event )
	local caster = event.caster
	local ability = event.ability

	local dummy = CreateUnitByName("npc_dummy_unit", (caster:GetAbsOrigin() + Vector(1000,0,0)), false, nil, caster:GetPlayerOwner(), caster:GetTeamNumber())
	dummy:AddAbility("revive_ability")
	local abDummy = dummy:GetAbilityByIndex(0)
	local abRevive = dummy:GetAbilityByIndex(1)
	abDummy:SetLevel(1)

	local arenaGraves =  Entities:FindAllByName("npc_dota_creature")
	if arenaGraves ~= nil then
		for k, v in pairs( arenaGraves ) do
			if v:GetUnitLabel() == "grave" then
				abRevive:ApplyDataDrivenModifier(dummy, v, "grave_buff", {duration = 3})
			end
		end
	end

	UTIL_Remove(dummy) 
	caster:ForceKill(false)
end

function ex_disable( event )
	local caster = event.caster

	if caster:IsInvulnerable() == true then
		local cd_ability = caster:FindAbilityByName("pl_exodus")
		cd_ability:StartCooldown(4) 
	end
end

function paly_heal( event )
	local caster = event.caster
	local target = event.target
	local ability = event.ability

	if target:HasModifier("modifier_pl_aura_effect") == true and target:GetHealthPercent() <= 20 then
		target:SetHealth((target:GetHealth() + 850))
	elseif target:HasModifier("modifier_pl_aura_effect") == true and target:GetHealthPercent() > 20 then
		target:SetHealth((target:GetHealth() + 650))
	else
		target:SetHealth((target:GetHealth() + 500))
	end
end

function paly_taunt( keys )
	local caster = keys.caster
	local target = keys.target

	-- Clear the force attack target
	target:SetForceAttackTarget(nil)

	-- Give the attack order if the caster is alive
	-- otherwise forces the target to sit and do nothing
	if caster:IsAlive() then
		local order = 
		{
			UnitIndex = target:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
			TargetIndex = caster:entindex()
		}

		ExecuteOrderFromTable(order)
	else
		target:Stop()
	end

	-- Set the force attack target to be the caster
	target:SetForceAttackTarget(caster)
end

-- Clears the force attack target upon expiration
function taunt_end( keys )
	local target = keys.target

	target:SetForceAttackTarget(nil)
end