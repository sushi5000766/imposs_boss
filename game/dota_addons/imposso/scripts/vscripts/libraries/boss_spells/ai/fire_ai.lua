function fireAI()
	run_bool = true
	if run_bool == true then
		print("ai started")
						
		Timers:CreateTimer(10, function()	
			if run_bool == true then					
				local raze = boss:GetAbilityByIndex(0)
				raze:SetLevel(1) 	
				CustomGameEventManager:Send_ServerToAllClients("start_ability_timer", { 
				  reference_number = 1,
				  duration = 2
				  })

				Timers:CreateTimer(2, function()				
					boss:CastAbilityImmediately(raze, 0)
					print("cast raze")
				end)	
				
				return RandomFloat(10, 25)
			else
				return 1
			end
		end)

		Timers:CreateTimer(5, function()	
			if run_bool == true then					
				local five = boss:GetAbilityByIndex(1)
				five:SetLevel(1) 	
				CustomGameEventManager:Send_ServerToAllClients("start_ability_timer", { 
				  reference_number = 2,
				  duration = 2
				  })

				Timers:CreateTimer(2, function()				
					boss:CastAbilityImmediately(five, 0)
					print("cast five")
				end)	
				
				return RandomFloat(10, 40)
			else
				return 1
			end
		end)

		Timers:CreateTimer(10, function()	
			if run_bool == true then					
				local flame = boss:GetAbilityByIndex(2)
				flame:SetLevel(1) 	
				CustomGameEventManager:Send_ServerToAllClients("start_ability_timer", { 
				  reference_number = 3,
				  duration = 2
				  })

				Timers:CreateTimer(2, function()
					boss:CastAbilityImmediately(flame, 0)
				end)	
				
				return RandomFloat(10, 10)
			else
				return 1
			end
		end)

		Timers:CreateTimer(40, function()	
			if run_bool == true then					
				local ball = boss:GetAbilityByIndex(3)
				ball:SetLevel(1) 	
				CustomGameEventManager:Send_ServerToAllClients("start_ability_timer", { 
				  reference_number = 4,
				  duration = 2
				  })
			
				boss:CastAbilityImmediately(ball, 0)
				print("cast ball")	
				
				return RandomFloat(10, 40)
			else
				return 1
			end
		end)

		Timers:CreateTimer(20, function()	
			if run_bool == true then					
				local hell = boss:GetAbilityByIndex(4)
				hell:SetLevel(1) 	
				CustomGameEventManager:Send_ServerToAllClients("start_ability_timer", { 
				  reference_number = 5,
				  duration = 2
				  })
			
				Timers:CreateTimer(2, function()
					boss:CastAbilityImmediately(hell, 0)
					print("cast hell")	
				end)
				
				return RandomFloat(10, 40)
			else
				return 1
			end
		end)	

		Timers:CreateTimer(20, function()	
			if run_bool == true then					
				local storm = boss:GetAbilityByIndex(5)
				storm:SetLevel(1) 	
				CustomGameEventManager:Send_ServerToAllClients("start_ability_timer", { 
				  reference_number = 6,
				  duration = 2
				  })
			
				Timers:CreateTimer(2, function()
					boss:CastAbilityImmediately(storm, 0)
					print("cast storm")	
				end)
				
				return RandomFloat(10, 40)
			else
				return 1
			end
		end)

		Timers:CreateTimer(20, function()	
			if run_bool == true then					
				local turbine = boss:GetAbilityByIndex(6)
				turbine:SetLevel(1) 	
				CustomGameEventManager:Send_ServerToAllClients("start_ability_timer", { 
				  reference_number = 7,
				  duration = 2
				  })
			
				Timers:CreateTimer(2, function()
					boss:CastAbilityImmediately(turbine, 0)
					print("cast turbine")	
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
							  reference_number = 8,
							  duration = 5
							  })
						Notifications:BottomToAll({text="USE THE PORTALS TO ESCAPE", duration=4.0, style={color="White"}})
						local light = boss:GetAbilityByIndex(7)
						light:SetLevel(1) 		
						boss:CastAbilityImmediately(light, 0)
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