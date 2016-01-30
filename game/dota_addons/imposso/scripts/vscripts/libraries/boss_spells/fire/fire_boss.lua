function fire_boss_autoattack(event)
	local hCaster = event.caster
	local xTarget = event.target
	local hability = event.ability

	local dist = (hCaster:GetAbsOrigin() - xTarget:GetAbsOrigin()):Length2D()


	if debug_drawing == true then
		local debug_vel = hCaster:GetForwardVector() * 890
		local debug_dist = (hCaster:GetAbsOrigin() - xTarget:GetAbsOrigin()):Length2D()
		local debug_end = hCaster:GetAbsOrigin() + debug_dist * debug_vel:Normalized() 
		DebugDrawLine(hCaster:GetAbsOrigin(), debug_end, 255, 255, 255, false, 3)
	end


	local info = 
	{
		Ability = hability,
		EffectName = "particles/econ/items/shadow_fiend/sf_desolation/sf_base_attack_desolation_fire_arcana.vpcf",
		vSpawnOrigin = hCaster:GetAbsOrigin() + Vector(0,0,180),
		fDistance = dist,
		fStartRadius = 0,
		fEndRadius = 0,
		Source = hCaster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_NONE,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO,
		fExpireTime = GameRules:GetGameTime() + 10.0,
		bDeleteOnHit = false,
		vVelocity = hCaster:GetForwardVector() * 890,
		bProvidesVision = false,
		iVisionRadius = 0,
		iVisionTeamNumber = hCaster:GetTeamNumber()
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)
end

function flame_strike( event )
	local caster = event.caster
	local unitTable = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, caster:GetAbsOrigin(), nil, 5000.0, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)	
	local ability = event.ability

	local random_num = 0

	local count = 0
	local roll = 0

	
	if unitTable ~= nil then
		for k ,unit in pairs(unitTable) do
			count = (count + 1)
		end



		if count > 0 then
			random_num = RandomInt(1, count)
			picked = unitTable[random_num]
			pos = picked:GetAbsOrigin() 			
		end

		if picked ~= nil then

			ability.crack_effect = ParticleManager:CreateParticle("particles/flame_strike_cracks.vpcf", PATTACH_ABSORIGIN, picked)
			ParticleManager:SetParticleControl(ability.crack_effect, 1, pos)

			local flame_time = 8

			Timers:CreateTimer(1, function()
				ability.fire_effect = ParticleManager:CreateParticle("particles/flame_lava.vpcf", PATTACH_ABSORIGIN, picked)
				ParticleManager:SetParticleControl(ability.fire_effect, 0, pos)
			end)

			Timers:CreateTimer(3.7, function()
				ability.fire_effect = ParticleManager:CreateParticle("particles/flame_lava.vpcf", PATTACH_ABSORIGIN, picked)
				ParticleManager:SetParticleControl(ability.fire_effect, 0, pos)
			end)

			Timers:CreateTimer(1, function()
				
				

				flame_time = (flame_time -0.25)
				local flameTable = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, pos, nil, 275, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

				
				
				if flameTable ~= nil then
					for k ,unit in pairs(flameTable) do
	   					local damageTable = {
						victim = unit,
						attacker = caster,
						damage = 19,
						damage_type = DAMAGE_TYPE_PURE,
						}				 
						ApplyDamage(damageTable)
					end
				end

				if flame_time == 0 then	
					return
				else
					return 1
				end
			end)
		end
	end
end

function flame_strike_five( event )

	local hCaster = event.caster
	local center = hCaster:GetAbsOrigin()

	local angle = 0

	local dist = 250
	local change = 72

	if debug_drawing == true then
		DebugDrawCircle(center, Vector(255,0,255), 1, 600, true, 6)
	end 

	for i=1, 5 do

		local effect_pos = center + Vector(math.cos(math.rad(angle)), math.sin(math.rad(angle)), 0) * dist

		local crack_effect_five = ParticleManager:CreateParticle("particles/flame_strike_cracks.vpcf", PATTACH_ABSORIGIN, hCaster)
		ParticleManager:SetParticleControl(crack_effect_five, 1, effect_pos)
		angle = angle + change
		if angle > 360 then
			angle = angle - 360
		end

	end

	Timers:CreateTimer(1, function()

		local angle2 = 0

		for i=1, 5 do

			local effect_pos = center + Vector(math.cos(math.rad(angle)), math.sin(math.rad(angle)), 0) * dist

			local fire_effect_five = ParticleManager:CreateParticle("particles/flame_lava_five.vpcf", PATTACH_ABSORIGIN, hCaster)
			ParticleManager:SetParticleControl(fire_effect_five, 0, effect_pos)
			angle = angle + change
			if angle > 360 then
				angle = angle - 360
			end

		end
	end)

	Timers:CreateTimer(2, function()

		local angle = 0

		for i=1, 5 do

			local effect_pos = center + Vector(math.cos(math.rad(angle)), math.sin(math.rad(angle)), 0) * dist

			local fire_effect_five = ParticleManager:CreateParticle("particles/flame_lava_five.vpcf", PATTACH_ABSORIGIN, hCaster)
			ParticleManager:SetParticleControl(fire_effect_five, 0, effect_pos)
			angle = angle + change
			if angle >= 360 then
				angle = angle - 360
			end

		end
	end)
	
	local flame_five_time = 6

	Timers:CreateTimer(1, function()
		flame_five_time = (flame_five_time - 1)
		local flameTablefive = FindUnitsInRadius(hCaster:GetTeamNumber(), hCaster:GetAbsOrigin(), nil, 600.0, DOTA_TEAM_GOODGUYS, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

		
		
		if flameTablefive ~= nil then
			for k ,unit in pairs(flameTablefive) do
   				if unit:IsHero() == true then
   					local damageTable = {
					victim = unit,
					attacker = hCaster,
					damage = 150,
					damage_type = DAMAGE_TYPE_PURE,
					}				 
					ApplyDamage(damageTable)
				end
			end
		end

		if flame_five_time == 0 then
			return
		else
			return 1
		end
	end)
end

function fire_ball(event)
	local hCaster = event.caster
	local hability = event.ability
	local castPos = hCaster:GetAbsOrigin()	

	local info = 
	{
		Ability = hability,
		EffectName = "particles/fireball_travel.vpcf",
		vSpawnOrigin = castPos,
		fDistance = 800,
		fStartRadius = 64,
		fEndRadius = 64,
		Source = hCaster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_NONE,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 10.0,
		bDeleteOnHit = false,
		vVelocity = RandomVector(1) * 300,
		bProvidesVision = false,
		iVisionRadius = 0,
		iVisionTeamNumber = hCaster:GetTeamNumber()
	}
	fireball = ProjectileManager:CreateLinearProjectile(info)	

	fireball_end = boss:GetAbsOrigin() + 800 * info.vVelocity:Normalized() 
	if debug_drawing == true then
		DebugDrawCircle(fireball_end, Vector(255,0,0), 1, 350, true, 8)
	end 
end

function fireball_explode( event )
	local angle = 0
	local dist = 0
	local change = 0

	local fireball_effect_end = ParticleManager:CreateParticle("particles/econ/items/gyrocopter/hero_gyrocopter_gyrotechnics/gyro_calldown_explosion.vpcf", PATTACH_ABSORIGIN, boss)
	ParticleManager:SetParticleControl(fireball_effect_end, 3, fireball_end)

	for i=0, 47 do
		if i <= 7 then
			dist = 100
			change = 45
		elseif i > 7 and i <= 23 then
			dist = 225
			change = 22
		elseif i > 23 then
			dist = 350
			change = 15
		end

		local effect_pos = fireball_end + Vector(math.cos(math.rad(angle)), math.sin(math.rad(angle)), 0) * dist

		local fireball_effect_end = ParticleManager:CreateParticle("particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_base_attack_impact.vpcf", PATTACH_ABSORIGIN, boss)
		ParticleManager:SetParticleControl(fireball_effect_end, 1, effect_pos)
		angle = angle + change
		if angle > 360 then
			angle = angle - 360
		end
	end
end

function fireStorm( event )
	local hCaster = event.caster
	local Ymax = 7260--Temporary
	local Ymin = 4704
	local Xmax = -2998
	local Xmin = -7070
	local i = 1
	for i=1, 15 do
		local spot = Vector(RandomInt(Xmin, Xmax), RandomInt(Ymin, Ymax), 200)

		if debug_drawing == true then
			DebugDrawCircle(spot, Vector(255,100,0), 1, 215, true, 5)
		end

		local shadow_effect = ParticleManager:CreateParticle("particles/meteor_shadow.vpcf", PATTACH_ABSORIGIN, hCaster)
		ParticleManager:SetParticleControl(shadow_effect, 0, spot + Vector(0,0,200))

		local meteor_effect = ParticleManager:CreateParticle("particles/invoker_chaos_meteor_fly2.vpcf", PATTACH_ABSORIGIN, hCaster)
		ParticleManager:SetParticleControl(meteor_effect, 0, spot + Vector(0,0,2000))
		ParticleManager:SetParticleControl(meteor_effect, 1, spot)
		ParticleManager:SetParticleControl(meteor_effect, 2, Vector(4,0,0))

		Timers:CreateTimer(4, function()

			local crash_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_hit.vpcf", PATTACH_ABSORIGIN, hCaster)
			ParticleManager:SetParticleControl(crash_effect, 0, spot + Vector(0,0,200))

			

			local unitTable = FindUnitsInRadius(DOTA_TEAM_GOODGUYS ,spot, nil, 215.0, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			if unitTable ~= nil then
				for k ,unit in pairs(unitTable) do
	   				if unit:IsHero() == true then
	   					local damageTable = {
						victim = unit,
						attacker = hCaster,
						damage = 800,
						damage_type = DAMAGE_TYPE_PURE,
						}				 
						ApplyDamage(damageTable)
					end
				end
			end
			return 
		end)
	end
end

function fire_raze( event ) 
	local hCaster = event.caster
	local hAbility = event.ability

	for i=1, 30 do	
		local info = 
		{
			Ability = hAbility,
			EffectName = "particles/lina_base_attack2.vpcf",
			vSpawnOrigin = hCaster:GetAbsOrigin(),
			fDistance = 3000,
			fStartRadius = 64,
			fEndRadius = 64,
			Source = hCaster,
			bHasFrontalCone = false,
			bReplaceExisting = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO,
			fExpireTime = GameRules:GetGameTime() + 10.0,
			bDeleteOnHit = false,
			vVelocity = RandomVector(1) * 500,
			bProvidesVision = false,
			iVisionRadius = 1000,
			iVisionTeamNumber = hCaster:GetTeamNumber()
		}
		projectile = ProjectileManager:CreateLinearProjectile(info)
	end
end

function boss_death( event )
	local caster = event.unit
	local boss_pos = caster:GetAbsOrigin()
	local angle = 0
	local angle_two = 0
	local dist = 0
	local change = 0

	if debug_drawing == true then
			DebugDrawCircle(caster:GetAbsOrigin(), Vector(255,100,0), 1, 1200, true, 5)
		end

	print(boss_poss)

	local fire_death_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_suicide_base.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(fire_death_effect, 0, caster:GetAbsOrigin())

	for i=0, 23 do
		if i <= 7 then
			dist = 400
			change = 45
		else
			dist = 800
			change = 22
		end

		local effect_pos = boss_pos + Vector(math.cos(math.rad(angle)), math.sin(math.rad(angle)), 0) * dist

		print(effect_pos)
		local fire_death_effect_one = ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_suicide_base.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(fire_death_effect_one, 0, effect_pos)
		angle = angle + change
		if angle > 360 then
			angle = angle - 360
		end
	end
end

function egg_aura( event )
	local caster = event.caster

	local darkList = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, caster:GetAbsOrigin(), nil, 5000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for k, v in pairs( darkList ) do
		if v:IsAlive() == true then
		    if (v:GetAbsOrigin() - egg_unit:GetAbsOrigin()):Length2D() > 450 then
		    	local damageTable = {
				victim = v,
				attacker = boss,
				damage = 50000,
				damage_type = DAMAGE_TYPE_MAGICAL,
				}				 
				ApplyDamage(damageTable)

				local dark_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_sun_strike.vpcf", PATTACH_ABSORIGIN, v)
				ParticleManager:SetParticleControl(dark_effect, 0, v:GetAbsOrigin())
			else
				local damageTable = {
				victim = v,
				attacker = boss,
				damage = 25,
				damage_type = DAMAGE_TYPE_MAGICAL,
				}				 
				ApplyDamage(damageTable)

			end

		end
	end

end

function light_follow(event) 
	local hCaster = event.caster
	local hability = event.ability
	hCaster:SetMana(0)

	EmitGlobalSound("Imposs.boss_fire_ult") --[[Returns:void
	Play named sound for all players
	]]

	projectile_bool = false

	--Declare Points
	cirONE = Vector(-5712, 5270, 257)
	cirTWO = Vector(-6372, 5974, 257)
	cirTHREE = Vector(-5724, 6702, 257)
	cirFOUR = Vector(-4298, 6702, 257)
	cirFIVE = Vector(-3564, 5978, 257)
	cirSIX = Vector(-4312, 5280, 257)

	local arena_center = Vector(-4976, 5976, 257)

	local egg_vel = (arena_center-hCaster:GetAbsOrigin()):Normalized()

	
	local eggX = -5634
	local eggY = 5974
	local eggZ = 257

	local eggSpot = hCaster:GetAbsOrigin() + 600 * egg_vel

	local mod_ab = hCaster:FindAbilityByName("flame_strike") 

	--Create the Egg
	egg_unit = CreateUnitByName("npc_mini_boss_egg", eggSpot, false, nil, nil, DOTA_TEAM_GOODGUYS)
	mod_ab:ApplyDataDrivenModifier(hCaster, egg_unit, "fire_dot", nil) 
	local egg_aura = egg_unit:GetAbilityByIndex(1)
	local abEgg = egg_unit:GetAbilityByIndex(0)
	abEgg:SetLevel(1) 
	

	--make boss face egg
	hCaster:SetForwardVector((egg_unit:GetAbsOrigin()-hCaster:GetAbsOrigin()):Normalized()) 

	eggList = {}
	randVec = {}

	--create flames that build egg
	for i=1, 20 do
		randVec[i] = (RandomVector(1) * 500)
		eggList[i] = eggSpot + 500 * randVec[i]:Normalized()
	end

	local EndTime = 5.0
	local count = 0
	local eggSize = egg_unit:GetModelScale()
	local sizeAdd = 0.025

	--increase egg size and fire projectiles
	Timers:CreateTimer(function()
		EndTime = EndTime - 0.25
		count = count + 1
		egg_unit:SetModelScale(eggSize + sizeAdd)
		eggSize = eggSize + sizeAdd
		local info = 
		{
			Ability = hability,
			EffectName = "particles/fireball_travel.vpcf",
			vSpawnOrigin = eggList[count] + Vector(0,0,180),
			fDistance = 500,
			fStartRadius = 64,
			fEndRadius = 64,
			Source = hCaster,
			bHasFrontalCone = false,
			bReplaceExisting = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_NONE,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO,
			fExpireTime = GameRules:GetGameTime() + 10.0,
			bDeleteOnHit = false,
			vVelocity = -randVec[count],
			bProvidesVision = false,
			iVisionRadius = 0,
			iVisionTeamNumber = hCaster:GetTeamNumber()
		}

		light_add = ProjectileManager:CreateLinearProjectile(info)
      if EndTime == 0 then  
      		egg_aura:SetLevel(1) 
      		--Cut arena vision and start egg movement 
      		local arenaHeroes = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, hCaster:GetAbsOrigin(), nil, 5000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
      		if arenaHeroes ~= nil then
	      		for k, v in pairs( arenaHeroes ) do
				    if v:IsHero() == true then
					   	v:SetDayTimeVisionRange(10)
					   	v:SetNightTimeVisionRange(10)
					end
				end
			end

			local arenaHeroes = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, boss:GetAbsOrigin(), nil, 5000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_DEAD, FIND_ANY_ORDER, false)
	  		if arenaHeroes ~= nil then
	      		for k, v in pairs( arenaHeroes ) do
				    if v:IsHero() == true then
					   	v:SetDayTimeVisionRange(10)
					   	v:SetNightTimeVisionRange(10)
					end
				end
			end

      		move_end = 20.0
      		local re_roll = true

      		CustomGameEventManager:Send_ServerToAllClients("start_ability_timer", { 
			  reference_number = 7,
			  duration = 25
			  })

      		Timers:CreateTimer(function()
      			move_end = move_end - 0.5

      			--roll for where boss with apear(random)
      			local spot_roll = RandomInt(1, 6)
	      		local spot_pick

	      		if spot_roll == 1 then
	      			spot_pick = cirONE
	      		elseif spot_roll == 2 then
	      			spot_pick = cirTWO
	      		elseif spot_roll == 3 then
	      			spot_pick = cirTHREE
	      		elseif spot_roll == 4 then
	      			spot_pick = cirFOUR
	      		elseif spot_roll == 5 then
	      			spot_pick = cirFIVE
	      		elseif spot_roll == 6 then
	      			spot_pick = cirSIX
	      		end

	      		if move_end > 0 then      		

	      			--check for player heros distance to egg to kill them!!!!
	      			

				end

				if move_end > 5 then

					--move boss and provide temp vision
		      		FindClearSpaceForUnit(hCaster, spot_pick, true)
		      		AddFOWViewer( DOTA_TEAM_GOODGUYS, spot_pick, 50, 0.25, false)

		      		local Ymax = 7260--Temporary
					local Ymin = 4704
					local Xmax = -2998
					local Xmin = -7070

					--if egg is at dest then route new dest
	      			if re_roll == true then
	      				randomPOS = Vector(RandomFloat(Xmin, Xmax),RandomFloat(Ymin, Ymax), 0)
	      				re_roll = false
	      			end

	      			--if egg is not close then continue on route
	      			if (egg_unit:GetAbsOrigin() - randomPOS):Length2D() > 150 then
		      			local newOrder = {
					 		UnitIndex = egg_unit:entindex(), 
					 		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
					 		Position = randomPOS,
					 	}

						ExecuteOrderFromTable(newOrder)
					--if egg is close then enable re routing
					elseif (egg_unit:GetAbsOrigin() - randomPOS):Length2D() <= 150 then
						re_roll = true					
					end

					return 0.5

					--if moving phase is over stop the egg
				elseif move_end == 5 then
					local newOrder = {
					 		UnitIndex = egg_unit:entindex(), 
					 		OrderType = DOTA_UNIT_ORDER_STOP,
					}

					ExecuteOrderFromTable(newOrder)

					--boss face the egg and show the boss
					hCaster:SetForwardVector((egg_unit:GetAbsOrigin()-hCaster:GetAbsOrigin()):Normalized())
					AddFOWViewer( DOTA_TEAM_GOODGUYS, hCaster:GetAbsOrigin(), 50, 10, false)

					projectile_bool = true

					local dist = (hCaster:GetAbsOrigin() - egg_unit:GetAbsOrigin()):Length2D()

					local info = 
					{
						Ability = hability,
						EffectName = "particles/fireball_travel.vpcf",
						vSpawnOrigin = hCaster:GetAbsOrigin() + Vector(0,0,180),
						fDistance = dist,
						fStartRadius = 64,
						fEndRadius = 64,
						Source = hCaster,
						bHasFrontalCone = false,
						bReplaceExisting = false,
						iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
						iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
						iUnitTargetType = DOTA_UNIT_TARGET_BASIC,
						fExpireTime = GameRules:GetGameTime() + 10.0,
						bDeleteOnHit = false,
						vVelocity = (egg_unit:GetAbsOrigin() - hCaster:GetAbsOrigin()):Normalized() * 450,
						bProvidesVision = true,
						iVisionRadius = 300,
						iVisionTeamNumber = DOTA_TEAM_GOODGUYS,
					}
					killball = ProjectileManager:CreateLinearProjectile(info)

					return 0.5
				elseif move_end == 0 then
					return
				end
			end)
          	return
      else
          	return 0.25
      end
    end)
end

--(randVec[count] * -1):Normalized()

--unit:SetForwardVector(unit:GetAbsOrigin-POINT:Normalized()) set unit facing point'

function light_damage()
	local lightPOS = egg_unit:GetAbsOrigin()
	if projectile_bool == true then


		local arenaHeroes = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, boss:GetAbsOrigin(), nil, 5000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
  		if arenaHeroes ~= nil then
      		for k, v in pairs( arenaHeroes ) do
			    if v:IsHero() == true then
				   	v:SetDayTimeVisionRange(3000)
				   	v:SetNightTimeVisionRange(3000)
				end
			end
		end

		local arenaHeroes = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, boss:GetAbsOrigin(), nil, 5000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_DEAD, FIND_ANY_ORDER, false)
  		if arenaHeroes ~= nil then
      		for k, v in pairs( arenaHeroes ) do
			    if v:IsHero() == true then
				   	v:SetDayTimeVisionRange(3000)
				   	v:SetNightTimeVisionRange(3000)
				end
			end
		end

		local lightTable = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, lightPOS, nil, 1000.0, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
				
		if lightTable ~= nil then
			for k ,unit in pairs(lightTable) do
   				if unit:IsHero() == true then
   					local damageTable = {
					victim = unit,
					attacker = boss,
					damage = 10000,
					damage_type = DAMAGE_TYPE_PURE,
					}				 
					ApplyDamage(damageTable)
				end
			end
		end

		local angle = 0
		local dist = 0
		local change = 0

		for i=0, 47 do
			if i <= 7 then
				dist = 300
				change = 45
			elseif i > 7 and i <= 23 then
				dist = 600
				change = 22
			elseif i > 23 then
				dist = 900
				change = 15
			end

			local effect_pos = lightPOS + Vector(math.cos(math.rad(angle)), math.sin(math.rad(angle)), 0) * dist

			local fire_death_effect_one = ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_suicide_base.vpcf", PATTACH_ABSORIGIN, boss)
			ParticleManager:SetParticleControl(fire_death_effect_one, 0, effect_pos)
			angle = angle + change
			if angle > 360 then
				angle = angle - 360
			end
		end
		UTIL_Remove(egg_unit)
      	run_bool = true
      	fireAI()
	end
end

function turbine( event )
	local caster = event.caster
	local ability = event.ability
	local center = caster:GetAbsOrigin() 

	local angle = 0
	local count = 4.5


	local part = "particles/units/heroes/hero_batrider/batrider_flamebreak_explosion.vpcf"

	local dist = RandomFloat(500, 1400)
	local change = 10



	Timers:CreateTimer(function()			

		local effect_pos = center + Vector(math.cos(math.rad(angle)), math.sin(math.rad(angle)), 0) * dist

		local turbine_effect_end = ParticleManager:CreateParticle(part, PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(turbine_effect_end, 3, effect_pos)
		angle = angle + change
		if angle > 360 then
			angle = angle - 360
		end
		count = count - 0.04

		if debug_drawing == true then
			DebugDrawCircle(effect_pos, Vector(255,100,100), 1, 180, true, 2)
		end

		local unitTable = FindUnitsInRadius(DOTA_TEAM_GOODGUYS , effect_pos, nil, 180, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		if unitTable ~= nil then
			for k ,unit in pairs(unitTable) do
				local damageTable = {
				victim = unit,
				attacker = caster,
				damage = 350,
				damage_type = DAMAGE_TYPE_PURE,
				}				 
				ApplyDamage(damageTable)
			end
		end

		if count < 0 then
			return
		else
			return 0.04
		end

	end)
	
end

function enrage( event )
	local caster = event.caster
	local ult = caster:FindAbilityByName("light_follow")

	if difficulty_mode == 1 then
		if caster:GetHealth() <= (caster:GetMaxHealth() * 0.2) then
			caster:SetBaseManaRegen(20)
		end
	elseif difficulty_mode > 1 then
		if caster:GetHealth() <= (caster:GetMaxHealth() * 0.7) then 
			if difficulty_mode == 2 then
				caster:SetBaseManaRegen(25)
			elseif difficulty_mode > 2 then
				caster:SetBaseManaRegen(30)
			end
		end
	end

	if caster:GetMana() == caster:GetMaxMana() then

		CustomGameEventManager:Send_ServerToAllClients("start_ability_timer", { 
		  reference_number = 8,
		  duration = 5
		  })

		local newOrder = {
	 		UnitIndex = caster:entindex(), 
	 		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
	 		AbilityIndex = ult:entindex(), 
	 		Queue = 0
	 	}
		 
		ExecuteOrderFromTable(newOrder)	
	end
end

function fire_start_sound()
	EmitGlobalSound("Imposs.boss_fire_start")
end