abilityQueue = {}
aggroTable = {}

function fire_AI()

	print("ai ran")

	local ability_1 = boss:FindAbilityByName("fire_raze")
	local ability_2 = boss:FindAbilityByName("flame_strike_five")
	local ability_3 = boss:FindAbilityByName("flame_strike")
	local ability_4 = boss:FindAbilityByName("fire_ball")
	local ability_5 = boss:FindAbilityByName("hell_fire")
	local ability_6 = boss:FindAbilityByName("fire_storm")
	local ability_7 = boss:FindAbilityByName("flame_turbine")

	for i=0, 10 do 
	    abBoss = boss:GetAbilityByIndex(i)
	    if abBoss ~= nil then
	      abBoss:SetLevel(1)
	      CustomGameEventManager:Send_ServerToAllClients("add_boss_ability", { 
	        reference_number = i,
	        ability_name = abBoss:GetAbilityName()
	      })
	    end
  	end


	local choiceRNG = ChoicePseudoRNG.create( {0.15, 0.15, 0.14, 0.14, 0.14, 0.14, 0.14} )

	Timers:CreateTimer(10, function()	

		print("cast")	
		
		local result = choiceRNG:Choose()
		local ability = "ability_" .. result

		if boss:HasModifier("modifier_fire_ult_during") == false then

			CustomGameEventManager:Send_ServerToAllClients("start_ability_timer", { 
				  reference_number = result - 1,
				  duration = 2
				  })

			Timers:CreateTimer(2, function()

				local newOrder = {
			 		UnitIndex = boss:entindex(), 
			 		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			 		AbilityIndex = boss:GetAbilityByIndex(result-1):GetEntityIndex(), 
			 		Queue = 0
			 	}
				 
				ExecuteOrderFromTable(newOrder)

			end)	


			
		end
		return RandomFloat(1, 3)

	end)
end

function earth_AI()

	print("ai ran")

	local ability_1 = boss:FindAbilityByName("earth_boss_earthshock")
	local ability_2 = boss:FindAbilityByName("earth_boss_pummel")
	local ability_3 = boss:FindAbilityByName("earth_boss_imtimidate")
	local ability_4 = boss:FindAbilityByName("earth_boss_charge")
	local ability_5 = boss:FindAbilityByName("earth_boss_slam")
	local ability_6 = boss:FindAbilityByName("earth_boss_earthquake")
	local ability_7 = boss:FindAbilityByName("earth_boss_barrage")

	for i=0, 9 do 
	    abBoss = boss:GetAbilityByIndex(i)
	    if abBoss ~= nil then
	      abBoss:SetLevel(1)
	      if i > 0 then
		      CustomGameEventManager:Send_ServerToAllClients("add_boss_ability", { 
		        reference_number = i,
		        ability_name = abBoss:GetAbilityName()
		      })
		  end
	    end
  	end


	local choiceRNG_earth = ChoicePseudoRNG.create( {0.14, 0.12, 0.04, 0.18, 0.25, 0.15, 0.04} )

	Timers:CreateTimer(10, function()	

		print("cast")	
		
		local result = choiceRNG_earth:Choose()
		local ability = "ability_" .. result

		if boss:HasModifier("modifier_earth_casting") == false and boss:HasModifier("modifier_earth_ult_casting") == false and boss:HasModifier("modifier_earth_charge") == false and boss:HasModifier("modifier_earth_pummel_animation") == false then

			CustomGameEventManager:Send_ServerToAllClients("start_ability_timer", { 
				  reference_number = result,
				  duration = 2
				  })

			if result == 5 then

				local slam_ai = FindUnitsInRadius(DOTA_TEAM_NEUTRALS, boss:GetAbsOrigin(), nil, 3000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
				if slam_ai ~= nil then
					local pick_slam = slam_ai[1]
				
					local forward = (pick_slam:GetAbsOrigin() - boss:GetAbsOrigin()):Normalized() 
					local cast_point = boss:GetAbsOrigin() + 300 * forward
					Timers:CreateTimer(2, function()

						local newOrder = {
					 		UnitIndex = boss:entindex(), 
					 		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					 		Position = cast_point,
					 		AbilityIndex = boss:GetAbilityByIndex(result):GetEntityIndex(), 
					 		Queue = 0
					 	}
						 
						ExecuteOrderFromTable(newOrder)

					end)
				end

			else
				Timers:CreateTimer(2, function()

					local newOrder = {
				 		UnitIndex = boss:entindex(), 
				 		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				 		AbilityIndex = boss:GetAbilityByIndex(result):GetEntityIndex(), 
				 		Queue = 0
				 	}
					 
					ExecuteOrderFromTable(newOrder)



				end)
				
			end	
			
		else
			print("boss is using barrage or ult")
		end
		return RandomFloat(3, 5)

	end)
end