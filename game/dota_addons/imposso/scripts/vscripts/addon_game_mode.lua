-- This is the entry-point to your game mode and should be used primarily to precache models/particles/sounds/etc

require('internal/util')
require('gamemode')

function Precache( context )
--[[
  This function is used to precache resources/units/items/abilities that will be needed
  for sure in your game and that will not be precached by hero selection.  When a hero
  is selected from the hero selection screen, the game will precache that hero's assets,
  any equipped cosmetics, and perform the data-driven precaching defined in that hero's
  precache{} block, as well as the precache{} block for any equipped abilities.

  See GameMode:PostLoadPrecache() in gamemode.lua for more information
  ]]

  DebugPrint("[BAREBONES] Performing pre-load precache")

  -- Particles can be precached individually or by folder
  -- It it likely that precaching a single particle system will precache all of its children, but this may not be guaranteed
  PrecacheResource("particle", "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf", context)
  PrecacheResource("particle", "particles/econ/items/shadow_fiend/sf_desolation/sf_base_attack_desolation_desolator.vpcf", context)
  PrecacheResource("particle", "particles/lina_base_attack2.vpcf", context)
  PrecacheResource("particle", "particles/invoker_chaos_meteor_fly2.vpcf", context)
  PrecacheResource("particle", "particles/meteor_shadow.vpcf", context)
  PrecacheResource("particle", "particles/flame_strike_cracks.vpcf", context)
  PrecacheResource("particle", "particles/fireball_explode.vpcf", context)
  PrecacheResource("particle", "particles/fireball_travel.vpcf", context)
  PrecacheResource("particle", "particles/boss_auto.vpcf", context)
  PrecacheResource("particle", "particles/light_follows_add.vpcf", context)
  PrecacheResource("particle", "particles/econ/items/warlock/warlock_staff_glory/warlock_upheaval_infernal_cast_fire.vpcf", context)
  PrecacheResource("particle", "particles/units/heroes/hero_skeletonking/skeletonking_hellfireblast.vpcf", context)
  PrecacheResource("particle", "particles/items_fx/aura_assault.vpcf", context)
  PrecacheResource("particle", "particles/units/heroes/hero_lina/lina_spell_light_strike_array_explosion.vpcf", context)
  PrecacheResource("particle", "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_base_attack.vpcf", context)
  PrecacheResource("particle", "particles/econ/items/antimage/antimage_weapon_basher_ti5_gold/am_manaburn_basher_ti_5_b_gold.vpcf", context)
  PrecacheResource("particle", "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_base_attack_impact.vpcf", context)
  PrecacheResource("particle", "particles/econ/items/dazzle/dazzle_pipe_dezun/dazzle_pipe_dezun_beam_glow.vpcf", context)
  PrecacheResource("particle", "particles/units/heroes/hero_omniknight/omniknight_purification.vpcf", context)
  PrecacheResource("particle", "particles/units/heroes/hero_chen/chen_test_of_faith.vpcf", context)
  PrecacheResource("particle", "particles/generic_gameplay/generic_manaburn.vpcf", context)
  PrecacheResource("particle", "particles/units/heroes/hero_abaddon/abaddon_borrowed_time_heal.vpcf", context)
  PrecacheResource("particle", "particles/items3_fx/lotus_orb_shield.vpcf", context)
  PrecacheResource("particle", "particles/units/heroes/hero_omniknight/omniknight_repel_buff.vpcf", context)
  PrecacheResource("particle", "particles/units/heroes/hero_enchantress/enchantress_impetus.vpcf", context)
  PrecacheResource("particle", "particles/units/heroes/hero_omniknight/omniknight_purification_cast.vpcf", context)
  PrecacheResource("particle", "particles/units/heroes/hero_lina/lina_spell_dragon_slave.vpcf", context)
  PrecacheResource("particle", "particles/econ/items/axe/axe_cinder/axe_cinder_battle_hunger.vpcf", context)
  PrecacheResource("particle", "particles/units/heroes/hero_keeper_of_the_light/keeper_spirit_form_ambient_static.vpcf", context)
  PrecacheResource("particle", "particles/units/heroes/hero_ancient_apparition/ancient_apparition_ice_blast_explode.vpcf", context)
  PrecacheResource("particle", "particles/units/heroes/hero_ancient_apparition/ancient_apparition_ice_blast_final_grid_b.vpcf", context)
  PrecacheResource("particle", "particles/units/heroes/hero_lich/lich_frost_armor.vpcf", context)
  PrecacheResource("particle", "particles/units/heroes/hero_winter_wyvern/winter_wyvern_base_attack.vpcf", context)
  PrecacheResource("particle", "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf", context)
  PrecacheResource("particle", "particles/neutral_fx/roshan_death_aegis_spotlight.vpcf", context)
  PrecacheResource("particle", "particles/units/heroes/hero_skywrath_mage/skywrath_mage_concussive_shot.vpcf", context)
  PrecacheResource("particle", "particles/units/heroes/hero_omniknight/omniknight_purification_e.vpcf", context)
  PrecacheResource("particle", "particles/units/heroes/hero_windrunner/windrunner_base_attack.vpcf", context)
  PrecacheResource("particle", "particles/units/heroes/hero_skywrath_mage/skywrath_mage_base_attack.vpcf", context)
  PrecacheResource("particle", "particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf", context)
  PrecacheResource("particle", "particles/units/heroes/hero_jakiro/jakiro_base_attack.vpcf", context)
  PrecacheResource("particle", "particles/units/heroes/hero_winter_wyvern/wyvern_splinter_blast_explosion_flare.vpcf", context)
  PrecacheResource("particle", "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_loadout.vpcf", context)
  PrecacheResource("particle", "particles/units/heroes/hero_warlock/warlock_base_attack.vpcf", context)

  PrecacheResource("particle", "particles/generic_hero_status/hero_levelup.vpcf", context)

  PrecacheResource("particle", "particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_fire.vpcf", context)

  PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_chen.vsndevts", context)

 




  PrecacheResource("particle_folder", "particles/econ/items/earthshaker/egteam_set/hero_earthshaker_egset/earthshaker_totem_buff_fire_egset.vpcf", context)
  PrecacheResource("particle_folder", "particles/test_particle", context)

  -- Models can also be precached by folder or individually
  -- PrecacheModel should generally used over PrecacheResource for individual models
  PrecacheResource("model_folder", "particles/heroes/antimage", context)
  PrecacheResource("model", "particles/heroes/viper/viper.vmdl", context)
  PrecacheModel("models/heroes/viper/viper.vmdl", context)
  PrecacheModel("models/heroes/viper/viper.vmdl", context)
  PrecacheModel("models/items/warlock/golem/hellsworn_golem/hellsworn_golem.vmdl", context)
  PrecacheModel("models/heroes/earthshaker/belt.vmdl", context)
  PrecacheModel("models/heroes/earthshaker/bracers.vmdl", context)
  PrecacheModel("models/heroes/earthshaker/totem.vmdl", context)

  -- Sounds can precached here like anything else
  PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_gyrocopter.vsndevts", context)

  -- Entire items can be precached by name
  -- Abilities can also be precached in this way despite the name
  PrecacheItemByNameSync("example_ability", context)
  PrecacheItemByNameSync("item_example_item", context)

  -- Entire heroes (sound effects/voice/models/particles) can be precached with PrecacheUnitByNameSync
  -- Custom units from npc_units_custom.txt can also have all of their abilities and precache{} blocks precached in this way
  PrecacheUnitByNameSync("npc_dota_hero_ancient_apparition", context)
  PrecacheUnitByNameSync("npc_dota_hero_enigma", context)
end

-- Create the game mode when we activate
function Activate()
  GameRules.GameMode = GameMode()
  GameRules.GameMode:InitGameMode()
end