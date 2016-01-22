-- This is the primary barebones gamemode script and should be used to assist in initializing your game mode


-- Set this to true if you want to see a complete debug output of all events/processes done by barebones
-- You can also change the cvar 'barebones_spew' at any time to 1 or 0 for output/no output
BAREBONES_DEBUG_SPEW = false

if GameMode == nil then
    DebugPrint( '[BAREBONES] creating barebones game mode' )
    _G.GameMode = class({})
end

-- This library allow for easily delayed/timed actions
require('libraries/timers')
-- This library can be used for advancted physics/motion/collision of units.  See PhysicsReadme.txt for more information.
require('libraries/physics')
-- This library can be used for advanced 3D projectile systems.
require('libraries/projectiles')
-- This library can be used for sending panorama notifications to the UIs of players/teams/everyone
require('libraries/notifications')
-- This library can be used for starting customized animations on units from lua
require('libraries/animations')
-- This library can be used for performing "Frankenstein" attachments on units
require('libraries/attachments')

require('libraries/boss_spells/fire/boss_auto')
require('libraries/boss_spells/fire/ligh_follows')
require('libraries/boss_spells/fire/fire_raze')
require('libraries/boss_spells/fire/fire_storm')


require('libraries/boss_spells/ai/fire_ai')


-- These internal libraries set up barebones's events and processes.  Feel free to inspect them/change them if you need to.
require('internal/gamemode')
require('internal/events')

-- settings.lua is where you can specify many different properties for your game mode and is one of the core barebones files.
require('settings')
-- events.lua is where you can specify the actions to be taken when any event occurs and is one of the core barebones files.
require('events')



--STAGES OF GAME--
--PREGAME
--STARTUP
--BOSS
--SHOP

--Locations
shopLOC = Vector(-6208, -6848, 128)
arenaLOC = Vector(-5002, 5120, 129)
bossLOC = Vector(-5002, 5864, 129)

SETGAME = "PREGAME"
ShopToggle = 0
heroTable = {}
player_gem = {}

late_pick_bool = {}

arena_count = 0
boss_num = 1


--[[
  This function should be used to set up Async precache calls at the beginning of the gameplay.

  In this function, place all of your PrecacheItemByNameAsync and PrecacheUnitByNameAsync.  These calls will be made
  after all players have loaded in, but before they have selected their heroes. PrecacheItemByNameAsync can also
  be used to precache dynamically-added datadriven abilities instead of items.  PrecacheUnitByNameAsync will 
  precache the precache{} block statement of the unit and all precache{} block statements for every Ability# 
  defined on the unit.

  This function should only be called once.  If you want to/need to precache more items/abilities/units at a later
  time, you can call the functions individually (for example if you want to precache units in a new wave of
  holdout).

  This function should generally only be used if the Precache() function in addon_game_mode.lua is not working.
]]
function GameMode:PostLoadPrecache()
  DebugPrint("[BAREBONES] Performing Post-Load precache")    
  --PrecacheItemByNameAsync("item_example_item", function(...) end)
  --PrecacheItemByNameAsync("example_ability", function(...) end)

  --PrecacheUnitByNameAsync("npc_dota_hero_viper", function(...) end)
  --PrecacheUnitByNameAsync("npc_dota_hero_enigma", function(...) end)
end

--[[
  This function is called once and only once as soon as the first player (almost certain to be the server in local lobbies) loads in.
  It can be used to initialize state that isn't initializeable in InitGameMode() but needs to be done before everyone loads in.
]]
function GameMode:OnFirstPlayerLoaded()
  DebugPrint("[BAREBONES] First Player has loaded")
end

--[[
  This function is called once and only once after all players have loaded into the game, right as the hero selection time begins.
  It can be used to initialize non-hero player state or adjust the hero selection (i.e. force random etc)
]]
function GameMode:OnAllPlayersLoaded()
  DebugPrint("[BAREBONES] All Players have loaded into the game")
  SETGAME = "PREGAME"

  GameMode:Setup()

end

--[[
  This function is called once and only once for every player when they spawn into the game for the first time.  It is also called
  if the player's hero is replaced with a new hero for any reason.  This function is useful for initializing heroes, such as adding
  levels, changing the starting gold, removing/adding abilities, adding physics, etc.

  The hero parameter is the hero entity that just spawned in
]]
function GameMode:OnHeroInGame(hero)
  DebugPrint("[BAREBONES] Hero spawned in game for first time -- " .. hero:GetUnitName())  
  SETGAME = "SHOP"

  heroTable[hero:GetPlayerOwnerID()] = hero

  player_gem[hero:GetPlayerOwnerID()] = 1

  CustomGameEventManager:Send_ServerToAllClients("hide_mana_bar", {})

  CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(hero:GetPlayerOwnerID()), "update_resource", {
  value = player_gem[hero:GetPlayerOwnerID()]
  })

  -- This line for example will set the starting gold of every hero to 500 unreliable gold
  hero:SetGold(20, false)

  -- These lines will create an item and add it to the player, effectively ensuring they start with the item
  local item = CreateItem("item_revive_item", hero, hero)
  item:SetCurrentCharges(1)
  hero:AddItem(item)

  print(hero:GetUnitLabel())

  for i=0, 10 do 
      abHero = hero:GetAbilityByIndex(i)
      if abHero ~= nil then
        abHero:SetLevel(1)
      end
  end

  
  
  --GameMode:Setup()
  --[[ --These lines if uncommented will replace the W ability of any hero that loads into the game
    --with the "example_ability" ability

  local abil = hero:GetAbilityByIndex(1)
  hero:RemoveAbility(abil:GetAbilityName())
  hero:AddAbility("example_ability")]]
end

--[[
  This function is called once and only once when the game completely begins (about 0:00 on the clock).  At this point,
  gold will begin to go up in ticks if configured, creeps will spawn, towers will become damageable etc.  This function
  is useful for starting any game logic timers/thinkers, beginning the first round, etc.
]]
function GameMode:OnGameInProgress()
  DebugPrint("[BAREBONES] The game has officially begun")
end



-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later
function GameMode:InitGameMode()
  GameMode = self
  DebugPrint('[BAREBONES] Starting to load Barebones gamemode...')


  -- Call the internal function to set up the rules/behaviors specified in constants.lua
  -- This also sets up event hooks for all event handlers in events.lua
  -- Check out internals/gamemode to see/modify the exact code
  GameMode:_InitGameMode()

  -- Commands can be registered for debugging purposes or as functions that can be called by the custom Scaleform UI
  Convars:RegisterCommand( "command_example", Dynamic_Wrap(GameMode, 'ExampleConsoleCommand'), "A console command example", FCVAR_CHEAT )

  DebugPrint('[BAREBONES] Done loading Barebones gamemode!\n\n')
end

-- This is an example console command
function GameMode:ExampleConsoleCommand()
  print( '******* Example Console Command ***************' )
  local cmdPlayer = Convars:GetCommandClient()
  if cmdPlayer then
    local playerID = cmdPlayer:GetPlayerID()
    if playerID ~= nil and playerID ~= -1 then
      -- Do something here for the player who called this command
      PlayerResource:ReplaceHeroWith(playerID, "npc_dota_hero_viper", 1000, 1000)
    end
  end

  print( '*********************************************' )
end


function GameMode:Setup()

  if ShopToggle == 0 then

    local ui_off = 80

    Timers:CreateTimer(function()
      ui_off = ui_off - 1
      for k, hero in pairs( heroTable ) do
        CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(hero:GetPlayerOwnerID()), "update_resource", {
        value = player_gem[hero:GetPlayerOwnerID()]
        })
        CustomGameEventManager:Send_ServerToAllClients("hide_mana_bar", {})
      end
      if ui_off == 0 then
        return
      else
        return 1
      end
    end)


    

    AddFOWViewer(2, Vector(-7400, -6550, 260), 3000, 99999, true)

    if shop_dummy == nil then

      local shop_dummy = CreateUnitByName("npc_dummy_unit", Vector(-7400, -6550, 260) , false, nil, nil, DOTA_TEAM_GOODGUYS)
      shop_dummy:AddAbility("shop_aura")
      local shop_ab = shop_dummy:GetAbilityByIndex(1)
      local shop_pass = shop_dummy:GetAbilityByIndex(0)
      shop_ab:SetLevel(1)
      shop_pass:SetLevel(1)
      --[[Timers:CreateTimer(80 , function()
        UTIL_Remove(shop_dummy)
      end)]]--
    end

    local Quest = SpawnEntityFromTableSynchronous( "quest", { name = "QuestName", title = "#QuestTimer" } )
    local play_count = PlayerResource:GetPlayerCountForTeam(2)

    local end_end = 80

    Quest.EndTime = end_end

    Quest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, end_end )
    Quest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_TARGET_VALUE, end_end )
    ShopToggle = 1
    Timers:CreateTimer(1, function()
      Quest.EndTime = Quest.EndTime - 1
      Quest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, Quest.EndTime )
      -- Finish the quest when the time is up

      if Quest.EndTime == 0 then 
          EmitGlobalSound("Tutorial.Quest.complete_01") -- Part of game_sounds_music_tutorial

          for i=0, play_count - 1 do
            if PlayerResource:GetPlayer(i):GetAssignedHero() == nil then
              late_pick_bool[i] = true
            elseif PlayerResource:GetPlayer(i):GetAssignedHero() ~= nil then
              late_pick_bool[i] = false
            end
          end

          Quest:CompleteQuest()
          GameMode:ArenaSetup()
          return
      elseif Quest.EndTime == 20 then 
          
          for i=0, play_count - 1 do
            print("random!")
            if PlayerResource:GetPlayer(i):GetAssignedHero() == nil then
              PlayerResource:GetPlayer(i):MakeRandomHeroSelection()
              local force_hero = PlayerResource:GetSelectedHeroName(i)
              PlayerResource:SetHasRepicked(i)
            end
          end

          return 1          
      else
          return 1 -- Call again every second
      end
    end)
  end   
end

function GameMode:ArenaSetup()

  print("boss Spawned")

  local arena_start_dummy = CreateUnitByName("npc_dummy_unit", arenaLOC, false, nil, nil, DOTA_TEAM_NEUTRALS)
  arena_start_dummy:AddAbility("arena_start_aura")
  local abPass = arena_start_dummy:GetAbilityByIndex(0)
  local abAura = arena_start_dummy:GetAbilityByIndex(1)
  abAura:SetLevel(1) 
  abPass:SetLevel(1)
  Timers:CreateTimer(5, function()
    UTIL_Remove(arena_start_dummy)
  end)

  if boss_num == 1 then

    boss = CreateUnitByName("npc_boss_one", bossLOC, true, nil, nil, DOTA_TEAM_NEUTRALS)

    for i=0, 10 do 
      abBoss = boss:GetAbilityByIndex(i)
      if abBoss ~= nil then
        abBoss:SetLevel(1)
      end
    end

      CustomGameEventManager:Send_ServerToAllClients("remove_boss_ability", { 
      reference_number = 1
      })

      CustomGameEventManager:Send_ServerToAllClients("add_boss_ability", { 
      reference_number = 1,
      ability_name = "MassFireRaze"
      })

      CustomGameEventManager:Send_ServerToAllClients("add_boss_ability", { 
      reference_number = 2,
      ability_name = "flame_strike_five"
      })

      CustomGameEventManager:Send_ServerToAllClients("add_boss_ability", { 
      reference_number = 3,
      ability_name = "flame_strike"
      })

      CustomGameEventManager:Send_ServerToAllClients("add_boss_ability", { 
      reference_number = 4,
      ability_name = "fire_storm"
      })

      CustomGameEventManager:Send_ServerToAllClients("add_boss_ability", { 
      reference_number = 5,
      ability_name = "fire_ball"
      })

      CustomGameEventManager:Send_ServerToAllClients("add_boss_ability", { 
      reference_number = 6,
      ability_name = "hell_fire"
      })

      CustomGameEventManager:Send_ServerToAllClients("add_boss_ability", { 
      reference_number = 7,
      ability_name = "LightFollow"
      })
  end
  

  GameMode:ArenaStart()

end

function GameMode:ArenaStart()


  --Move Heros to ArenaS
  --[[for k, v in pairs( heroTable ) do
    local moveing = heroTable[k]
    FindClearSpaceForUnit(moveing, arenaLOC, true)
    local temp_hero = CreateHeroForPlayer("npc_dota_hero_lina_fm" , moveing:GetPlayerOwner())
  end]]--

   --GameRules:GetGameModeEntity():SetCameraDistanceOverride(1700.0)

  for k, hero in pairs( heroTable ) do
    if late_pick_bool[k] ~= true then
      arena_count = arena_count + 1
      FindClearSpaceForUnit(hero, arenaLOC, true)
      PlayerResource:SetCameraTarget(k, hero)
      Timers:CreateTimer(0.1, function()
        PlayerResource:SetCameraTarget(k, nil)
      end)
    end
  end



  GameRules.Quest = SpawnEntityFromTableSynchronous( "quest", {
        name = "QuestName",
        title = "#QuestKill"
  })
  GameRules.Quest.UnitsKilled = 0
  GameRules.Quest.KillLimit = 1

  -- text on the quest timer at start
  GameRules.Quest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, 0 )
  GameRules.Quest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_TARGET_VALUE, GameRules.Quest.KillLimit )

  fireAI()
  
end

function GameMode:OnEntityKilled( event )
    local killedUnit = EntIndexToHScript( event.entindex_killed )

    if killedUnit and string.find(killedUnit:GetUnitLabel(), "Boss") then
        -- Fill the quest bar and substract one from the quest remaining text
        GameRules.Quest.UnitsKilled = GameRules.Quest.UnitsKilled + 1
        GameRules.Quest:SetTextReplaceValue(QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, GameRules.Quest.UnitsKilled)
        

        -- Check if quest completed 
        if GameRules.Quest.UnitsKilled >= GameRules.Quest.KillLimit then
          EmitGlobalSound("Tutorial.Quest.complete_01")
          GameRules.Quest:CompleteQuest()
          ShopToggle = 0

          run_bool = false

          for i=1, 7 do
              CustomGameEventManager:Send_ServerToAllClients("remove_boss_ability", { 
              reference_number = i
              })
          end

          local arena_start_dummy = CreateUnitByName("npc_dummy_unit", arenaLOC, false, nil, nil, DOTA_TEAM_NEUTRALS)
          arena_start_dummy:AddAbility("arena_start_aura")
          local abPass = arena_start_dummy:GetAbilityByIndex(0)
          local abAura = arena_start_dummy:GetAbilityByIndex(1)
          abAura:SetLevel(1) 
          abPass:SetLevel(1)
          Timers:CreateTimer(5, function()
            UTIL_Remove(arena_start_dummy)

            for k, v in pairs( heroTable ) do  
              v:SetGold((v:GetGold() + 45), false)           
              FindClearSpaceForUnit(heroTable[k], shopLOC, true)
              player_gem[k] = player_gem[k] + 1
              CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(hero:GetPlayerOwnerID()), "update_resource", {
              value = player_gem[k]
              })
              PlayerResource:SetCameraTarget(k, v)
              Timers:CreateTimer(0.1, function()
                PlayerResource:SetCameraTarget(k, nil)
              end)
            end

          end)

          
          GameMode:Setup()
        end
   end

   --player wipe check
    
    if killedUnit and string.find(killedUnit:GetUnitLabel(), "hero") then
      Timers:CreateTimer(1, function()
        local death_count = 0
        for k, v in pairs( heroTable ) do
          if v:IsAlive() == false and late_pick_bool[k] == false then
            death_count = death_count + 1
          end
        end
        print(death_count)
          print(arena_count)
        if death_count == arena_count then
          Timers:CreateTimer(10, function()
            local death_count = 0
            for k, v in pairs( heroTable ) do
              if v:IsAlive() == false and late_pick_bool[k] == false then
                death_count = death_count + 1
              end
            end
            print(death_count)
            print(arena_count)
            if death_count == arena_count then
              GameRules:MakeTeamLose(2)
            end
          end)
        end
      end)
    end

end