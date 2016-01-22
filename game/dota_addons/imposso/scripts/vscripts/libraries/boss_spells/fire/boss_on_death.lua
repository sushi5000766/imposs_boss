function boss_death( event )
	local caster = event.unit
	local boss_pos = caster:GetAbsOrigin()
	local angle = 0
	local angle_two = 0
	local dist = 0
	local change = 0

	print(boss_poss)

	local fire_death_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_suicide_base.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(fire_death_effect, 0, caster:GetAbsOrigin())

	for i=0, 23 do
		if i <= 7 then
			dist = 400
			change = 45
		else
			dist = 800
			change = 22
		end

		local effect_pos = boss_pos + Vector(math.cos(math.rad(angle)), math.sin(math.rad(angle)), 0) * dist

		print(effect_pos)
		local fire_death_effect_one = ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_suicide_base.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(fire_death_effect_one, 0, effect_pos)
		angle = angle + change
		if angle > 360 then
			angle = angle - 360
		end
	end
end