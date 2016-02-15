function WallCollision ( trigger )
	local tornado = trigger.activator

	if tornado:GetUnitName() == "npc_water_boss_tornado" and tornado:HasModifier("modifier_tornado_call") then
		local targetUnits =	FindUnitsInRadius(
			DOTA_TEAM_NEUTRALS,
			tornado:GetAbsOrigin(), 
			nil,
			300,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE, 
			FIND_ANY_ORDER, 
			false)

		if targetUnits ~= nil then
			for _, unit in pairs(targetUnits) do
				local damageTable = {
					victim = unit,
					attacker = tornado,
					damage = 3000,
					damage_type = DAMAGE_TYPE_MAGICAL,
				}
					
				ApplyDamage(damageTable)
			end
		end
	end
end