local hazard = Hazard.new({
	name = "hazard.edron-kingdom",
	maxLevel = 50,
	crit = 0.05,
	dodge = 0.04,
	damageBoost = 0.1,
	defenseBoost = 0.1,
})

local zone = hazard.zone
zone:addArea(Position(2932, 3079, 4), Position(3249, 3188, 4))
zone:addArea(Position(3736, 4498, 6), Position(4043, 4644, 6))
zone:addArea(Position(3704, 4339, 6), Position(4039, 4490, 6))
zone:addArea(Position(3408, 4346, 7), Position(3705, 4487, 7))
zone:addArea(Position(3375, 4694, 7), Position(3708, 4865, 7))
zone:addArea(Position(3732, 4848, 3), Position(4092, 5028, 3))
zone:addArea(Position(3724, 4659, 6), Position(4073, 4826, 6))
zone:addArea(Position(3377, 4864, 6), Position(3708, 5051, 6))
zone:addArea(Position(2858, 4241, 5), Position(3214, 4440, 5))
zone:addArea(Position(2862, 4507, 5), Position(3214, 4690, 5))
zone:addArea(Position(2995, 4704, 5), Position(3345, 4877, 5))
zone:addArea(Position(2958, 5485, 7), Position(3327, 5661, 7))
zone:addArea(Position(2999, 4876, 4), Position(3345, 5080, 4))
zone:addArea(Position(2950, 6076, 7), Position(3309, 6291, 7))
zone:addArea(Position(2953, 5685, 7), Position(3327, 5870, 7))
zone:addArea(Position(2986, 5080, 4), Position(3347, 5280, 4))
zone:addArea(Position(2984, 5278, 4), Position(3354, 5482, 4))
zone:addArea(Position(3383, 5473, 6), Position(3743, 5687, 6))
zone:addArea(Position(3375, 5705, 6), Position(3745, 5893, 6))
zone:addArea(Position(2959, 5873, 6), Position(3318, 6070, 6))
zone:addArea(Position(3354, 5898, 7), Position(3738, 6101, 7))
zone:addArea(Position(2500, 3850, 7), Position(2660, 4160, 7))
zone:addArea(Position(2300, 3950, 7), Position(2497, 4160, 7))
zone:addArea(Position(2178, 3954, 7), Position(2332, 4152, 7))
zone:addArea(Position(2042, 4034, 2), Position(2184, 4162, 2))
zone:addArea(Position(2017, 3868, 3), Position(2188, 4009, 3))
zone:addArea(Position(1540, 3931, 4), Position(1753, 4122, 4))
zone:addArea(Position(1767, 3931, 4), Position(1983, 4125, 4))

hazard:register()
