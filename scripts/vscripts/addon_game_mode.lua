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

local function PrecacheSound(sound, context )
    PrecacheResource( "soundfile", sound, context)
end
local function PrecacheParticle(particle, context )
    PrecacheResource( "particle",  particle, context)
end
local function PrecacheModel(model, context )
    PrecacheResource( "model", model, context )
end
-- Create the game mode when we activate
function Activate()
    CForgedGameMode:InitGameMode()
end

function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheSound( "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
    -- 特效文件
	PrecacheParticle( "particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_e_cowlofice.vpcf", context )
	PrecacheParticle( "particles/units/heroes/hero_jakiro/jakiro_ice_path_shards.vpcf", context )
	PrecacheParticle( "particles/units/heroes/hero_invoker/invoker_ice_wall_shards.vpcf", context )
	PrecacheParticle( "particles/units/heroes/hero_jakiro/jakiro_icepath_debuff.vpcf", context )
	PrecacheParticle( "particles/units/heroes/hero_ancient_apparition/ancient_apparition_cold_feet_marker_b.vpcf", context )
	PrecacheParticle( "particles/units/heroes/hero_invoker/invoker_ice_wall_icicle.vpcf", context )
	PrecacheParticle( "particles/hw_fx/hw_roshan_death_e.vpcf", context )
	PrecacheParticle( "particles/econ/courier/courier_trail_orbit/courier_trail_orbit.vpcf", context )
	PrecacheParticle( "particles/econ/courier/courier_greevil_green/courier_greevil_green_ambient_3.vpcf", context )
    PrecacheParticle( "particles/hero_templar/antimage_blink_end_b.vpcf", context)
    PrecacheParticle( "particles/units/heroes/hero_warlock/warlock_rain_of_chaos_start.vpcf", context)
    PrecacheParticle( "particles/hero_templar/antimage_blink_start_sparkles.vpcf", context)
    PrecacheParticle( "particles/hero_templar/antimage_manavoid_explode_b.vpcf", context)
    PrecacheParticle( "particles/hero_templar/abysal/abyssal_blade.vpcf", context)
    PrecacheParticle( "particles/econ/courier/courier_jadehoof_ambient/jadehoof_special_blossoms.vpcf", context)

    -- 音效文件
    PrecacheSound( 'soundevents/game_sounds_heroes/game_sounds_templar_assassin.vsndevts', context)
	PrecacheSound( "soundevents/game_sounds_heroes/game_sounds_beastmaster.vsndevts", context )
	PrecacheSound( "soundevents/game_sounds_heroes/game_sounds_axe.vsndevts", context )
	PrecacheSound( "soundevents/game_sounds_heroes/game_sounds_elder_titan.vsndevts", context )
    
    -- 小兵的统一音效
    PrecacheSound( 'soundevents/game_sounds_heroes/game_sounds_undying.vsndevts', context)
    PrecacheSound( 'soundevents/game_sounds_creeps.vsndevts', context )

    -- 从KV文件统一载入小怪模型
    local unit_kv = LoadKeyValues("scripts/npc/npc_units_custom.txt")
    if unit_kv then
        for unit_name,keys in pairs(unit_kv) do
            print("precacheing resource for unit"..unit_name)
            if type(keys) == "table" then
                if keys.Model then
                    print("precacheing model"..keys.Model)
                    PrecacheModel(keys.Model, context )
                end
            end
        end
    end

    -- 从KV文件统一载入物品模型
    local item_kv = LoadKeyValues("scripts/npc/npc_items_custom.txt")
    if item_kv then
        for item_name,keys in pairs(item_kv) do
            print("precacheing resource for item"..item_name)
            if type(keys) == "table" then
                if keys.Model then
                    print("precacheing model"..keys.Model)
                    PrecacheModel(keys.Model, context )
                end
            end
        end
    end
end


function CForgedGameMode:InitGameMode()
 	
 	-- 设定游戏准备时间
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 0.1 )

	GameRules:GetGameModeEntity():SetCameraDistanceOverride(1600)
	GameRules:SetPreGameTime(120)

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
--[[等HUD做好，再启用。 todo
    self._hudHide = self._hudHide or false
    if not self._hudHide then
        SendToServerConsole("sv_cheats 1")
        SendToConsole('dota_sf_hud_actionpanel 0')
        SendToConsole('dota_sf_hud_inventory 0')
        SendToConsole('dota_sf_hud_top 0')
        SendToConsole('dota_no_minimap 1')
        SendToConsole('dota_render_crop_height 0')
        SendToConsole('dota_render_y_inset 0')
        SendToServerConsole("sv_cheats 0")
        self._hudHide = true
    end
]]
    return 0.1
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
