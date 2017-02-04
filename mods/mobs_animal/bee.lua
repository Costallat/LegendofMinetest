
-- Bee by KrupnoPavel

mobs:register_mob("mobs_animal:bee", {
	type = "animal",
	passive = true,
	hp_min = 1,
	hp_max = 2,
	armor = 200,
	collisionbox = {-0.2, -0.01, -0.2, 0.2, 0.2, 0.2},
	visual = "mesh",
	mesh = "mobs_bee.x",
	textures = {
		{"mobs_bee.png"},
	},
	makes_footstep_sound = false,
	sounds = {
		random = "mobs_bee",
	},	
	walk_velocity = 1,
	jump = true,
	drops = {
		{name = "mobs:honey", chance = 2, min = 1, max = 2},
	},
	water_damage = 2,
	lava_damage = 2,
	light_damage = 0,
	fall_damage = 0,
	fall_speed = -3,
	animation = {
		speed_normal = 15,
		stand_start = 0,
		stand_end = 30,
		walk_start = 35,
		walk_end = 65,
	},
	on_rightclick = function(self, clicker)
		mobs:capture_mob(self, clicker, 25, 80, 0, true, nil)
	end,
})

mobs:register_spawn("mobs_animal:bee", {"group:flower"}, 20, 10, 9000, 1, 31000, true)

mobs:register_egg("mobs_animal:bee", "Bee", "mobs_bee_inv.png", 0)

-- compatibility
mobs:alias_mob("mobs:bee", "mobs_animal:bee")

-- honey
minetest.register_craftitem(":mobs:honey", {
	description = "Honey",
	inventory_image = "mobs_honey_inv.png",
	on_use = minetest.item_eat(6),
})

-- honey block
minetest.register_node(":mobs:honey_block", {
	description = "Honey Block",
	tiles = {"mobs_honey_block.png"},
	groups = {snappy = 3, flammable = 2},
	sounds = default.node_sound_dirt_defaults(),
})

minetest.register_craft({
	output = "mobs:honey_block",
	recipe = {
		{"mobs:honey", "mobs:honey", "mobs:honey"},
		{"mobs:honey", "mobs:honey", "mobs:honey"},
		{"mobs:honey", "mobs:honey", "mobs:honey"},
	}
})

minetest.register_craft({
	output = "mobs:honey 9",
	recipe = {
		{"mobs:honey_block"},
	}
})
--[[
-- beehive workings
minetest.register_abm({
	nodenames = {"mobs:beehive"},
	interval = 6,
	chance = 6,
	catch_up = false,
	action = function(pos, node)

		-- bee's only make honey during the day
		local tod = (minetest.get_timeofday() or 0) * 24000

		if tod < 5500 or tod > 18500 then
			return
		end

		-- is hive full?
		local meta = minetest.get_meta(pos)
		if not meta then return end -- for older beehives
		local inv = minetest.get_meta(pos):get_inventory()
		local honey = inv:get_stack("beehive", 1):get_count()

		-- is hive full?
		if honey > 19 then
			return
		end

		-- no flowers no honey, nuff said!
		if #minetest.find_nodes_in_area_under_air(
			{x = pos.x - 4, y = pos.y - 3, z = pos.z - 4},
			{x = pos.x + 4, y = pos.y + 3, z = pos.z + 4},
			"group:flower") > 3 then

			inv:add_item("beehive", "mobs:honey")
		end
	end
})
]]