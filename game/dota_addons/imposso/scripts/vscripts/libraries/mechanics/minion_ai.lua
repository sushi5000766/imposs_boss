function Spawn()
	if thisEntity:GetUnitName() == "npc_boss_water_tornado" then
		thisEntity:SetContextThink ("tornadoAI", tornadoAI, 1)
	else
		thisEntity:SetContextThink ("minionAI", minionAI, 1)
	end
end

function minionAI()	
	Timers:CreateTimer(1, function()
		local currentMana = thisEntity:GetMana()

		if thisEntity:GetUnitName() == "npc_boss_water_siren" then
			if thisEntity:HasModifier("modifier_minion_splash") == false then
				if currentMana >= 10 then
					thisEntity:CastAbilityNoTarget("ai_minion_splash", -1)
				end
			end
		else
			if thisEntity:HasModifier("modifier_minion_crush") == false then
				if currentMana >= 10 then
					thisEntity:CastAbilityNoTarget("ai_minion_crush", -1)
				end
			end
		end

		if thisEntity:IsAttacking() then
			local target = thisEntity:GetAggroTarget()
			thisEntity:MoveToPositionAggressive(target:GetAbsOrigin())
		else
			thisEntity:MoveToPositionAggressive(thisEntity:GetAbsOrigin())
		end

		while thisEntity:IsNull() == false do
			return 1.0
		end
	end)
end

function tornadoAI()	
	Timers:CreateTimer(1, function()
		while thisEntity:IsNull() == false do
			return 1.0
		end
	end)
end