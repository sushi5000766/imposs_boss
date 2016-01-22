function fireAI()


	run_bool = true
	--Raze Start
	if run_bool == true then
		Timers:CreateTimer(RandomFloat(5, 18), function()
			if run_bool == true then
				local bossPos = boss:GetAbsOrigin() 
				local raze_dummy = CreateUnitByName("npc_dummy_unit", bossPos, false, nil, nil, DOTA_TEAM_NEUTRALS)
				raze_dummy:AddAbility("MassFireRaze")
				local abRaze = raze_dummy:GetAbilityByIndex(1)
				local abPass = raze_dummy:GetAbilityByIndex(0)
				abRaze:SetLevel(1) 
				abPass:SetLevel(1)

				CustomGameEventManager:Send_ServerToAllClients("start_ability_timer", { 
				  reference_number = 1,
				  duration = 2
				  })

				Timers:CreateTimer(2, function()
					if boss:HasModifier("spell_countered") == true then
						 Notifications:BottomToAll(0, {text="Flame Burst Countered!", duration=1, style={color="red"}, continue=true})
						return
					else
						raze_dummy:CastAbilityImmediately(abRaze, 0)
					end
				end)
				Timers:CreateTimer(4, function()
					raze_dummy:ForceKill(false)
				end)

				return RandomFloat(10, 20)
			end
		end)

		--Storm Start
		Timers:CreateTimer(RandomFloat(5, 18), function()
			if run_bool == true then
				local bossPos = boss:GetAbsOrigin() 
				local storm_dummy = CreateUnitByName("npc_dummy_unit", bossPos, false, nil, nil, DOTA_TEAM_NEUTRALS)
				storm_dummy:AddAbility("fire_storm")
				local abStorm = storm_dummy:GetAbilityByIndex(1)
				local stPass = storm_dummy:GetAbilityByIndex(0)
				abStorm:SetLevel(1) 
				stPass:SetLevel(1)

				CustomGameEventManager:Send_ServerToAllClients("start_ability_timer", { 
				  reference_number = 4,
				  duration = 2
				  })
				Timers:CreateTimer(2, function()				
					storm_dummy:CastAbilityImmediately(abStorm, 0)
				end)
				Timers:CreateTimer(4, function()	
					storm_dummy:ForceKill(false)
					return 
				end)

				return RandomFloat(15, 25)
			end
		end)

		--Flame Strike Start
		Timers:CreateTimer(RandomFloat(5, 18), function()
			if run_bool == true then
				local bossPos = boss:GetAbsOrigin() 
				local flame_dummy = CreateUnitByName("npc_dummy_unit", bossPos, false, nil, nil, DOTA_TEAM_NEUTRALS)
				flame_dummy:AddAbility("flame_strike")
				local abFlame = flame_dummy:GetAbilityByIndex(1)
				local skPass = flame_dummy:GetAbilityByIndex(0)
				abFlame:SetLevel(1) 
				skPass:SetLevel(1)
				CustomGameEventManager:Send_ServerToAllClients("start_ability_timer", { 
				  reference_number = 3,
				  duration = 2
				  })

				Timers:CreateTimer(2, function()				
					flame_dummy:CastAbilityImmediately(abFlame, 0)
				end)
				
				Timers:CreateTimer(4, function()	
					flame_dummy:ForceKill(false)
					return 
				end)

				return RandomFloat(10, 25)
			end
		end)

		--Flame Strike Five Start
		Timers:CreateTimer(RandomFloat(5, 18), function()
			if run_bool == true then
				local bossPos = boss:GetAbsOrigin() 
				local flame_dummy = CreateUnitByName("npc_dummy_unit", bossPos, false, nil, nil, DOTA_TEAM_NEUTRALS)
				flame_dummy:AddAbility("flame_strike_five")
				local abFlame = flame_dummy:GetAbilityByIndex(1)
				local skPass = flame_dummy:GetAbilityByIndex(0)
				abFlame:SetLevel(1) 
				skPass:SetLevel(1)
				CustomGameEventManager:Send_ServerToAllClients("start_ability_timer", { 
				  reference_number = 2,
				  duration = 2
				  })
				Timers:CreateTimer(2, function()
					if boss:HasModifier("spell_countered") == true then
						Notifications:BottomToAll(0, {text="Mega Flame Strike Countered!", duration=1, style={color="red"}, continue=true})
						return
					else
						flame_dummy:CastAbilityImmediately(abFlame, 0)
					end
				end)
				Timers:CreateTimer(4, function()	
					flame_dummy:ForceKill(false)
					return 
				end)

				return RandomFloat(20, 30)
			end
		end)

		--Fireball Start
		Timers:CreateTimer(RandomFloat(5, 18), function()
			if run_bool == true then
				local bossPos = boss:GetAbsOrigin() 
				local ball_dummy = CreateUnitByName("npc_dummy_unit", bossPos, false, nil, nil, DOTA_TEAM_NEUTRALS)
				ball_dummy:AddAbility("fire_ball")
				local abBall = ball_dummy:GetAbilityByIndex(1)
				local baPass = ball_dummy:GetAbilityByIndex(0)
				abBall:SetLevel(1) 
				baPass:SetLevel(1)
				CustomGameEventManager:Send_ServerToAllClients("start_ability_timer", { 
				  reference_number = 5,
				  duration = 2
				  })
				Timers:CreateTimer(2, function()				
					ball_dummy:CastAbilityImmediately(abBall, 0)
				end)
				
				Timers:CreateTimer(4, function()	
					ball_dummy:ForceKill(false)
					return 
				end)

				return RandomFloat(15, 25)
			end
		end)

		--Hellfire start
		Timers:CreateTimer(function()
			if run_bool == true then
				if boss:GetHealthPercent() < 40 then		
					Timers:CreateTimer(1, function()	
						if run_bool == true then					
							local AttackSpeed = boss:GetAbilityByIndex(2)
							AttackSpeed:SetLevel(1) 	
							CustomGameEventManager:Send_ServerToAllClients("start_ability_timer", { 
							  reference_number = 6,
							  duration = 2
							  })

							Timers:CreateTimer(2, function()				
								boss:CastAbilityImmediately(AttackSpeed, 0)
							end)	
							
							return RandomFloat(30, 40)
						else
							return 1
						end
					end)
					return
				else
					return 1
				end
			end
		end)

		--Light Start
		Timers:CreateTimer(function()
			if run_bool == true then
				if boss:GetManaPercent() == 100 then	
					Timers:CreateTimer(function()
						CustomGameEventManager:Send_ServerToAllClients("start_ability_timer", { 
							  reference_number = 7,
							  duration = 5
							  })
						Notifications:BottomToAll({text="FOLLOW THE EGG CLOSELY", duration=4.0, style={color="White"}})
						local eggStart = boss:GetAbilityByIndex(1)
						eggStart:SetLevel(1) 		
						boss:CastAbilityImmediately(eggStart, 0)
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