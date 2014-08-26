--[[
			==天炼:addon_game_mode.lua==
			*********2014.08.10*********
			***********AMHC*************
			============================
				Authors:
				XavierCHN
				...
			============================
]]

-- load everyhing
require('require_everything')

if CForgedGameMode == nil then
	CForgedGameMode = class({})
end

function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
	PrecacheResource( "particle", "particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_e_cowlofice.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_jakiro/jakiro_ice_path_shards.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_ice_wall_shards.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_jakiro/jakiro_icepath_debuff.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_ancient_apparition/ancient_apparition_cold_feet_marker_b.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_ice_wall_icicle.vpcf", context )
	PrecacheResource( "particle", "particles/hw_fx/hw_roshan_death_e.vpcf", context )
	PrecacheResource( "particle", "particles/econ/courier/courier_trail_orbit/courier_trail_orbit.vpcf", context )
	PrecacheResource( "particle", "particles/econ/courier/courier_greevil_green/courier_greevil_green_ambient_3.vpcf", context )


    PrecacheResource( "model", "models/creeps/neutral_creeps/n_creep_gnoll/n_creep_gnoll.vmdl", context )
    PrecacheResource( "model", "models/creeps/mega_greevil/mega_greevil.vmdl", context )
    PrecacheResource( "model", "models/creeps/lane_creeps/creep_radiant_melee/radiant_melee.vmdl", context )
    PrecacheResource( "model", "models/creeps/roshan/roshan.vmdl", context )
   
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_beastmaster.vsndevts", context )

    
end

-- Create the game mode when we activate
function Activate()
	CForgedGameMode:InitGameMode()
end

function CForgedGameMode:InitGameMode()
 	
 	-- 设定游戏准备时间
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 0.1 )

	GameRules:GetGameModeEntity():SetCameraDistanceOverride(1800)
	GameRules:SetPreGameTime(1)
		
    GameRules:SetUseCustomHeroXPValues ( true )
    -- 是否使用自定义的英雄经验

    ListenToGameEvent('entity_killed', Dynamic_Wrap(CForgedGameMode, 'OnEntityKilled'), self)
    -- 监听单位被击杀的事件
	
	-- 初始化
	CFRoundThinker:InitPara()
	--ItemCore:Init()
	
end

-- Evaluate the state of the game
function CForgedGameMode:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then

		CFRoundThinker:Think()
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end

function CForgedGameMode:OnEntityKilled( keys )
  print( '[CForged] OnEntityKilled Called' )
  --PrintTable( keys )

  -- 储存被击杀的单位
  local killedUnit = EntIndexToHScript( keys.entindex_killed )
  -- 储存杀手单位
  local killerEntity =EntIndexToHScript( keys.entindex_attacker )

  if (killerEntity:IsHero()) then
	killerEntity:AddExperience(50, true)
  end 
end

function CForgedGameMode:FinishedGame()
    GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS) 
    GameRules:SetSafeToLeave(true)
end
