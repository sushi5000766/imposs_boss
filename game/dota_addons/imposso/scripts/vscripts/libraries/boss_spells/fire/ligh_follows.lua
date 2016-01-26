require('libraries/boss_spells/ai/fire_ai')


function light_follow(event) 
	local hCaster = event.caster
	local hability = event.ability
	hCaster:SetMana(0)

	projectile_bool = false

	--Declare Points
	cirONE = Vector(-5712, 5270, 257)
	cirTWO = Vector(-6372, 5974, 257)
	cirTHREE = Vector(-5724, 6702, 257)
	cirFOUR = Vector(-4298, 6702, 257)
	cirFIVE = Vector(-3564, 5978, 257)
	cirSIX = Vector(-4312, 5280, 257)
	
	local eggX = -5634
	local eggY = 5974
	local eggZ = 257
	local eggSpot = Vector(eggX, eggY, eggZ)

	--Create the Egg
	egg_unit = CreateUnitByName("npc_mini_boss_egg", eggSpot, false, nil, nil, DOTA_TEAM_GOODGUYS)
	local abEgg = egg_unit:GetAbilityByIndex(0)
	local abImo = egg_unit:GetAbilityByIndex(1)
	abEgg:SetLevel(1) 
	abImo:SetLevel(1)

	--make boss face egg
	boss:SetForwardVector((egg_unit:GetAbsOrigin()-boss:GetAbsOrigin()):Normalized()) 

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
      		--Cut arena vision and start egg movement 
      		local arenaHeroes = FindUnitsInRadius(4, boss:GetAbsOrigin(), nil, 5000, DOTA_TEAM_GOODGUYS, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
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
	      			local darkList = FindUnitsInRadius(4, boss:GetAbsOrigin(), nil, 5000, DOTA_TEAM_GOODGUYS, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	      			for k, v in pairs( darkList ) do
	      				if v:IsHero() == true then
						    local hero_check = v
						    if (hero_check:GetAbsOrigin() - egg_unit:GetAbsOrigin()):Length2D() > 450 then
						    	local damageTable = {
								victim = hero_check,
								attacker = boss,
								damage = 2000,
								damage_type = DAMAGE_TYPE_PURE,
								}				 
								ApplyDamage(damageTable)
							end
						end
					end

				end

				if move_end > 5 then

					--move boss and provide temp vision
		      		FindClearSpaceForUnit(boss, spot_pick, true)
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
					boss:SetForwardVector((egg_unit:GetAbsOrigin()-boss:GetAbsOrigin()):Normalized())
					AddFOWViewer( DOTA_TEAM_GOODGUYS, boss:GetAbsOrigin(), 50, 10, false)

					projectile_bool = true

					local dist = (boss:GetAbsOrigin() - egg_unit:GetAbsOrigin()):Length2D()

					local info = 
					{
						Ability = hability,
						EffectName = "particles/fireball_travel.vpcf",
						vSpawnOrigin = boss:GetAbsOrigin() + Vector(0,0,180),
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
						vVelocity = (egg_unit:GetAbsOrigin() - boss:GetAbsOrigin()):Normalized() * 450,
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


		local arenaHeroes = FindUnitsInRadius(4, boss:GetAbsOrigin(), nil, 5000, DOTA_TEAM_GOODGUYS, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
  		if arenaHeroes ~= nil then
      		for k, v in pairs( arenaHeroes ) do
			    if v:IsHero() == true then
				   	v:SetDayTimeVisionRange(3000)
				   	v:SetNightTimeVisionRange(3000)
				end
			end
		end

		local arenaHeroes = FindUnitsInRadius(4, boss:GetAbsOrigin(), nil, 5000, DOTA_TEAM_GOODGUYS, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
  		if arenaHeroes ~= nil then
      		for k, v in pairs( arenaHeroes ) do
			    if v:IsHero() == true then
				   	v:SetDayTimeVisionRange(3000)
				   	v:SetNightTimeVisionRange(3000)
				end
			end
		end

		local arenaHeroes = FindUnitsInRadius(4, boss:GetAbsOrigin(), nil, 5000, DOTA_TEAM_GOODGUYS, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_DEAD, FIND_ANY_ORDER, false)
  		if arenaHeroes ~= nil then
      		for k, v in pairs( arenaHeroes ) do
			    if v:IsHero() == true then
				   	v:SetDayTimeVisionRange(3000)
				   	v:SetNightTimeVisionRange(3000)
				end
			end
		end

		local lightTable = FindUnitsInRadius( 4, lightPOS, nil, 1000.0, DOTA_TEAM_GOODGUYS, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
				
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

			print(effect_pos)
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

