
function OnStaffLongTou( keys )
	local caster = keys.caster
	local x = keys.ability:GetLevelSpecialValueFor("heal_mana", keys.ability:GetLevel() - 1)
	caster:SetHealth(caster:GetHealth() + x)
	caster:SetMana(caster:GetMana() + x)
end

function OnStaffFengXue( keys )
	local caster = keys.caster

	--获取施法者所在点
	local caster_vec = caster:GetOrigin()

	--获取施法者的面向角度
	local caster_face = caster:GetForwardVector()

	--设置特效移动距离
	local Len = 800

	--用于存储特效
	local particle = {}

	--用于存储特效的位置
	local particle_vec = {}

	--用于存储特效移动的终点
	local particle_over = {}

	--定义移动函数
	function FengXue( particle , particle_vec , particle_over ,ice)
		GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("FengXue"), 
		function( )
			if (particle_over - particle_vec):Length()>50 then
				
				local face = (particle_over - particle_vec):Normalized()
				local vec = face * 30
				particle_vec = particle_vec + vec
				ParticleManager:SetParticleControl(particle,0,particle_vec)

				particle_over=RotatePosition(caster_vec, QAngle(0,2,0), particle_over)

				return 0.01
			else
				ParticleManager:DestroyParticle(particle,false)
				ParticleManager:DestroyParticle(ice,false)
				return nil
			end
		end, 0) 
	end

	--循环创建特效
	for i=1,12,1 do
		particle[i] = ParticleManager:CreateParticle("particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_snow.vpcf",PATTACH_WORLDORIGIN,caster)
		
		--初始化特效位置
		particle_vec[i] = caster_vec
		particle_over[i] = caster_vec + caster_face * Len
		ParticleManager:SetParticleControl(particle[i],0,caster_vec)

		--旋转终点
		particle_over[i]=RotatePosition(caster_vec, QAngle(0,(360/12)*i,0), particle_over[i])

		--创建冰女的一个特效
		local ice = ParticleManager:CreateParticle("particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf",PATTACH_WORLDORIGIN,caster)
		ParticleManager:SetParticleControl(ice,0,caster_vec + (particle_over[i] - caster_vec):Normalized() * (Len/2))

		--调用移动函数
		FengXue(particle[i],particle_vec[i],particle_over[i],ice)
	end
end