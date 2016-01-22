function fireStorm( event )
	local hCaster = event.caster
	local Ymax = 7104 --Temporary
	local Ymin = 4544
	local Xmax = -3072
	local Xmin = -6976 
	local i = 1
	for i=1, 15 do
		local spot = Vector(RandomInt(Xmin, Xmax), RandomInt(Ymin, Ymax), 0)

		local storm_dummy = CreateUnitByName("npc_dummy_unit", spot, false, nil, nil, DOTA_TEAM_NEUTRALS)
		local abPass = storm_dummy:GetAbilityByIndex(0)
		abPass:SetLevel(1)

		local shadow_effect = ParticleManager:CreateParticle("particles/meteor_shadow.vpcf", PATTACH_ABSORIGIN, storm_dummy)
		ParticleManager:SetParticleControl(shadow_effect, 0, storm_dummy:GetAbsOrigin())

		local meteor_effect = ParticleManager:CreateParticle("particles/invoker_chaos_meteor_fly2.vpcf", PATTACH_ABSORIGIN, storm_dummy)
		ParticleManager:SetParticleControl(meteor_effect, 0, storm_dummy:GetAbsOrigin() + Vector(0,0,1600))
		ParticleManager:SetParticleControl(meteor_effect, 1, storm_dummy:GetAbsOrigin())
		ParticleManager:SetParticleControl(meteor_effect, 2, Vector(4,0,0))

		Timers:CreateTimer(4, function()			
			local unitTable = FindUnitsInRadius(storm_dummy:GetTeamNumber() ,storm_dummy:GetAbsOrigin(), nil, 215.0, DOTA_TEAM_GOODGUYS, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			if unitTable ~= nil then
				for k ,unit in pairs(unitTable) do
	   				if unit:IsHero() == true then
	   					local damageTable = {
						victim = unit,
						attacker = storm_dummy,
						damage = 800,
						damage_type = DAMAGE_TYPE_PURE,
						}				 
						ApplyDamage(damageTable)
					end
				end
			end
			storm_dummy:ForceKill(false)
			return 
		end)
	end
end



function Leap( keys )
	local caster = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1	

	ability.leap_direction = {}
	ability.leap_distance = {}
	ability.leap_speed = {}
	ability.leap_traveled = {}
	ability.leap_z = {}

	local Ymax = 7104 --Temporary
	local Ymin = 4544
	local Xmax = -3072
	local Xmin = -6976 


	-- Clears any current command and disjoints projectiles
	caster:Stop()

	end_pos  = Vector(RandomInt(Xmin, Xmax), RandomInt(Ymin, Ymax), 0)

	-- Ability variables
	ability.leap_direction = (end_pos -caster:GetAbsOrigin()):Normalized()
	ability.leap_distance = (caster:GetAbsOrigin() - end_pos ):Length2D() - 50
	ability.leap_speed = RandomInt(800, 1200) * 1/30
	ability.leap_traveled  = 0
	ability.leap_z  = 0

end


--[[Moves the caster on the horizontal axis until it has traveled the distance]]
function LeapHorizonal( keys )
	local caster = keys.target
	local ability = keys.ability



	if ability.leap_traveled < ability.leap_distance  then
		caster:SetAbsOrigin(caster:GetAbsOrigin() + ability.leap_direction  * ability.leap_speed )
		ability.leap_traveled = ability.leap_traveled  + ability.leap_speed 
	else
		caster:InterruptMotionControllers(true)
	end
end

--[[Moves the caster on the vertical axis until movement is interrupted]]
function LeapVertical( keys )
	local caster = keys.target
	local ability = keys.ability

	-- For the first half of the distance the unit goes up and for the second half it goes down
	if ability.leap_traveled  < ability.leap_distance /2 then
		-- Go up
		-- This is to memorize the z point when it comes to cliffs and such although the division of speed by 2 isnt necessary, its more of a cosmetic thing
		ability.leap_z  = ability.leap_z  + ability.leap_speed /2
		-- Set the new location to the current ground location + the memorized z point
		caster:SetAbsOrigin(GetGroundPosition(caster:GetAbsOrigin(), caster) + Vector(0,0,ability.leap_z ))
	else
		-- Go down
		ability.leap_z  = ability.leap_z  - ability.leap_speed /2
		caster:SetAbsOrigin(GetGroundPosition(caster:GetAbsOrigin(), caster) + Vector(0,0,ability.leap_z ))
	end
end

function leap_caster( event )
	local caster = event.caster
	local leap_dummy = CreateUnitByName("npc_dummy_unit", caster:GetAbsOrigin(), false, nil, nil, DOTA_TEAM_GOODGUYS)
	leap_dummy:AddAbility("fire_storm_test")
	local abLeap = leap_dummy:GetAbilityByIndex(1)
	local skPass = leap_dummy:GetAbilityByIndex(0)
	abLeap:SetLevel(1) 
	skPass:SetLevel(0)
	leap_dummy:CastAbilityNoTarget(abLeap, 0)
	print("created")
end



