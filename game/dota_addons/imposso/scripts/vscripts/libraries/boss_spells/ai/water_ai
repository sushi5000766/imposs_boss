function earthAI()
	run_bool = true
	if run_bool == true then
		print("ai started")
						
		Timers:CreateTimer(25, function()	
			if run_bool == true then					
				local shock = boss:GetAbilityByIndex(0)
				shock:SetLevel(1) 	
				CustomGameEventManager:Send_ServerToAllClients("start_ability_timer", { 
				  reference_number = 1,
				  duration = 2
				  })

				Timers:CreateTimer(2, function()				
					boss:CastAbilityNoTarget(shock, 0)
					print("cast shock")
				end)	
				
				return RandomFloat(10, 40)
			else
				return 1
			end
		end)

		Timers:CreateTimer(5, function()	
			if run_bool == true then					
				local quake = boss:GetAbilityByIndex(6)
				quake:SetLevel(1) 	
				CustomGameEventManager:Send_ServerToAllClients("start_ability_timer", { 
				  reference_number = 6,
				  duration = 2
				  })

				Timers:CreateTimer(2, function()				
					boss:CastAbilityNoTarget(quake, 0)
					print("cast quake")
				end)	
				
				return RandomFloat(10, 40)
			else
				return 1
			end
		end)

		Timers:CreateTimer(10, function()	
			if run_bool == true then					
				local pummel = boss:GetAbilityByIndex(2)
				pummel:SetLevel(1) 	
				CustomGameEventManager:Send_ServerToAllClients("start_ability_timer", { 
				  reference_number = 2,
				  duration = 2
				  })

				Timers:CreateTimer(2, function()				
					boss:CastAbilityNoTarget(pummel, 0)
					print("cast pummel")
				end)	
				
				return RandomFloat(10, 10)
			else
				return 1
			end
		end)

		Timers:CreateTimer(40, function()	
			if run_bool == true then					
				local imtimidate = boss:GetAbilityByIndex(3)
				imtimidate:SetLevel(1) 	
				CustomGameEventManager:Send_ServerToAllClients("start_ability_timer", { 
				  reference_number = 3,
				  duration = 2
				  })
			
				boss:CastAbilityNoTarget(imtimidate, 0)
				print("cast imtimidate")	
				
				return RandomFloat(10, 40)
			else
				return 1
			end
		end)

		Timers:CreateTimer(20, function()	
			if run_bool == true then					
				local charge = boss:GetAbilityByIndex(4)
				charge:SetLevel(1) 	
				CustomGameEventManager:Send_ServerToAllClients("start_ability_timer", { 
				  reference_number = 4,
				  duration = 2
				  })
			
				Timers:CreateTimer(2, function()
					boss:CastAbilityNoTarget(charge, 0)
					print("cast charge")	
				end)
				
				return RandomFloat(10, 40)
			else
				return 1
			end
		end)			

		Timers:CreateTimer(function()
			if run_bool == true then
				if boss:GetManaPercent() == 100 then	
					Timers:CreateTimer(function()
						CustomGameEventManager:Send_ServerToAllClients("start_ability_timer", { 
							  reference_number = 9,
							  duration = 19
							  })
						Notifications:BottomToAll({text="USE THE PORTALS TO ESCAPE", duration=4.0, style={color="White"}})
						local enrage = boss:GetAbilityByIndex(9)
						enrage:SetLevel(1) 		
						boss:CastAbilityNoTarget(enrage, 0)
						run_bool = false
						return
						end
					)
					return
				else
					return 1
				end
			end
		end)
		
	end
end