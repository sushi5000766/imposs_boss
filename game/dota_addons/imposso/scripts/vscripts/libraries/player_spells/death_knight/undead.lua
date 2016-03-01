function pre_reanimate( event )
	local caster = event.caster
	local target = event.target
	local ability = event.ability

	if target ~= caster and target:GetName() == "npc_dota_hero_vengefulspirit" then
		caster:Stop()
	end
end

function reanimate( event )
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local skel_dur = ability:GetLevelSpecialValueFor( "duration" , ability:GetLevel() - 1  )
	local mana = ability:GetLevelSpecialValueFor( "mana" , ability:GetLevel() - 1  )

	if target:GetUnitLabel() == "grave" then
		local player = caster:GetPlayerOwnerID()
		local skel_unit = CreateUnitByName("npc_dk_skel_unit", target:GetAbsOrigin(), true, target, nil, target:GetTeamNumber())
		skel_unit:SetControllableByPlayer(player, true)
		skel_unit:AddNewModifier(skel_unit, nil, "modifier_kill", {duration = skel_dur})
		Timers:CreateTimer(function()
			if skel_unit:IsNull() == false and target:IsNull() == true then
				UTIL_Remove(skel_unit)
				return
			else
				return 0.25
			end
			
		end)

	elseif target:IsHero() == true then
		target:SetMana(target:GetMana() + mana)
	end
end

function undead_step( event )
	local caster = event.caster
	local target = event.target
	local ability = event.ability

	local castPos = caster:GetAbsOrigin()
	local targetPos = target:GetAbsOrigin()

	local tele_out_effect = ParticleManager:CreateParticle("particles/econ/events/nexon_hero_compendium_2014/blink_dagger_end_nexon_hero_cp_2014.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(tele_out_effect, 0, targetPos)

	FindClearSpaceForUnit(caster, targetPos, true) 
	--caster:SetForwardVector((target:GetAbsOrigin()-caster:GetAbsOrigin()):Normalized())
	
end

function unholy( event )
	local caster = event.caster
	local ability = event.ability
	local count = 0

	local group = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, caster:GetAbsOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for k, v in pairs( group ) do
		local count = count + 1
		print(count)
	end

	if count == 1 then
		for k, v in pairs( group ) do
			v:SetHealth(v:GetHealth() + 500)
		end
	elseif count > 1 then
		local heal = 1000 / count
		for k, v in pairs( group ) do
			v:SetHealth(v:GetHealth() + heal)
		end
	end
end

function radiance_heal( event )
	local caster = event.caster
	local ability = event.ability
	local count = 0

	local group = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, caster:GetAbsOrigin(), nil, 400, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for k, v in pairs( group ) do
		local count = count + 1
		print(count)
	end

	if count == 1 then
		for k, v in pairs( group ) do
			v:SetHealth(v:GetHealth() + 750)
		end
	elseif count > 1 then
		local heal = 2250 / count
		for k, v in pairs( group ) do
			v:SetHealth(v:GetHealth() + heal)
		end
	end
end

function fury_p( event )
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local Pdamage = ability:GetLevelSpecialValueFor( "Pdamage" , ability:GetLevel() - 1  )
	local reduction = ability:GetLevelSpecialValueFor( "reduction" , ability:GetLevel() - 1  )
	local reduce = reduction / 100

	local p_dam = Pdamage * reduce

	if caster:IsChanneling() == false then 
		target:RemoveModifierByName("modifier_dk_drain")

	else

		if target:HasModifier("shadow_align") == true then

			local damageTable = {
				victim = target,
				attacker = caster,
				damage = p_dam,
				damage_type = DAMAGE_TYPE_MAGICAL,
				}				 
			ApplyDamage(damageTable)
			print(p_dam)

		else
			local damageTable = {
				victim = target,
				attacker = caster,
				damage = Pdamage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				}				 
			ApplyDamage(damageTable)
			print(Pdamage)
		end
	end
end



function fury_m( event )
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local Mdamage = ability:GetLevelSpecialValueFor( "Mdamage" , ability:GetLevel() - 1  )
	local reduction = ability:GetLevelSpecialValueFor( "reduction" , ability:GetLevel() - 1  )
	local reduce = reduction / 100

	local magic_dam = Mdamage * reduce

	if target:HasModifier("shadow_align") == true then

		local damageTable = {
			victim = target,
			attacker = caster,
			damage = magic_dam,
			damage_type = DAMAGE_TYPE_MAGICAL,
			}				 
		ApplyDamage(damageTable)
		print(magic_dam)

	else
		local damageTable = {
			victim = target,
			attacker = caster,
			damage = Mdamage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			}				 
		ApplyDamage(damageTable)
		print(Mdamage)
	end
end

function Defile( event )
	local caster = event.caster
end