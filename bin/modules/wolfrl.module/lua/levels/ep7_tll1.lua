--[[ Submarine Willie.  Originally this was going to be a submarine bay despite
     the fact that canonically (well, TLL canon) Willie is not a submariner by
     the time BJ meets him.  And that Nuremberg is inland.  That grand plan was
     discarded however when it became clear that such a level just couldn't be
     done.  A water theme level seemed appropriate and I had, through unrelated
     level doodles, the basic corridor structure seen below which I reimagined
     as an elaborate aquarium compound and crafted from there.

     Beating sub willie floods a future level making that level harder.
--]]
local flood_checkcellhashset = function( coord, checked_cells )
	--I need these two procs because cells are complex user objects
	--and I need a way to treat them like primitives in a hashset
	return checked_cells[coord.x] ~= nil and checked_cells[coord.x][coord.y]
end
local flood_setcellhashset = function( coord, out_checked_cells )
	--I need these two procs because cells are complex user objects
	--and I need a way to treat them like primitives in a hashset
	if out_checked_cells[coord.x] == nil then out_checked_cells[coord.x] = {} end
	out_checked_cells[coord.x][coord.y] = true
end
local flood_multiscan = function( scan_area, good_set )
	for scan_coord in scan_area:coords() do
		local cell_id = level.map[ scan_coord ]
		if not good_set[cell_id] then return scan_coord end
	end

	return nil
end
local flood_corridor_calcpending = function( cells_to_check, border, out_checked_cells )
	--This proc ONLY gets a list of coords currently bordering our recently
	--added set.  It does not evaluate them for worthiness (though it does
	--distinguish between 'direct' and 'diagonal')
	local pending_direct = {}
	local pending_diagonal = {}

	for _,target in pairs(cells_to_check) do
		for edge in target:cross_coords() do
			if border:contains(edge) and not flood_checkcellhashset(edge, out_checked_cells) then
				flood_setcellhashset(edge, out_checked_cells)
				table.insert(pending_direct, edge:clone())
			end
		end
	end
	for _,target in pairs(cells_to_check) do
		for edge in target:around_coords() do
			if border:contains(edge) and not flood_checkcellhashset(edge, out_checked_cells) then
				flood_setcellhashset(edge, out_checked_cells)
				table.insert(pending_diagonal, edge:clone())
			end
		end
	end

	return pending_direct, pending_diagonal
end
local flood_corridor_floodpending = function( pending, units, out_assigned )
	--This proc checks a list, assigns cells, then returns the 'valid' cells + counts
	local count = 0

	--Try to paint some cells.
	while #pending > 0 and units > 0 do
		local test_cell_index = math.random(#pending)
		local test_cell = pending[test_cell_index]
		table.remove(pending, test_cell_index)

		--Determine if cell is traversible
		local cell_proto = cells[ level.map[ test_cell ] ]
		if not cell_proto.flags[ CF_BLOCKMOVE ] then
			--It's traversible.  Add it to our list of assigned cells.
			table.insert(out_assigned, test_cell)
			--It's a valid cell, but is it one we WANT to overwrite?
			--if cell_proto.set == CELLSET_FLOORS and not cell_proto.flags[ CF_CRITICAL ] then
			if cell_proto.id ~= "deepwater" and cell_proto.set == CELLSET_FLOORS and not cell_proto.flags[ CF_CRITICAL ] then
				units = units - 1
				level.map[ test_cell ] = "water"
			end
		end
	end

	return units - count
end
local flood_corridor = function( start_coord, units, border )
	--This is a bit brute force-ish but it can afford to be.

	--Default out optional parameters.
	units = units or 1
	border = border or area.FULL

	--Build our working cell lists (can coords be safely used as args?)
	local checked_cells = {}
	local pending_direct = { start_coord }
	local pending_diagonal = {}

	while #pending_direct > 0 or #pending_diagonal > 0 do
		local assigned = {}
		units = flood_corridor_floodpending( pending_direct, units, assigned )
		units = flood_corridor_floodpending( pending_diagonal, units, assigned )
		if units <= 0 then break end

		pending_direct, pending_diagonal = flood_corridor_calcpending( assigned, border, checked_cells )
	end
end

register_level "tll1" {
	name  = "The Aquarium",
	entry = "On level @1 he detoured to meet Submarine Willie.",
	welcome = "Everything seems a bit warped here.",
	level = 3,

	canGenerate = function ()
		return DIFFICULTY >= DIFF_MEDIUM and not DoomRL.isepisode()
	end,

	OnCompletedCheck = function ()
		return level.status == 3
	end,

	OnRegister = function ()

	end,

	Create = function ()
		level.name = "Children Of The Sea"
		generator.fill( "void", area.FULL )

		local translation = {
			['.'] = "floor",
			['~'] = "water",
			['"'] = "bridge",

			["`"] = "void",
			[">"] = "stairs",
			['#'] = { "wolf_cywall", flags = { LFPERMANENT } },
			['$'] = { "wolf_cywall", flags = { LFPERMANENT } },
			['%'] = { "wolf_cvwall", flags = { LFPERMANENT } },
			['&'] = { "wolf_cvwall", flags = { LFPERMANENT } },
			['x'] = "wolf_cywall",
			['X'] = "wolf_cywall",
			["_"] = "wolf_glass_h",
			["|"] = "wolf_glass_v",
			["~"] = "deepwater",

			["+"] = "door",
			["="] = { "lmdoor1", flags = { LFPERMANENT } },
			["-"] = { "lmdoor2", flags = { LFPERMANENT } },

			[";"] = {"deepwater", being = "wolf_piranha"},
			["@"] = {"floor", being = "wolf_bosswillie"},
		}

		local map = [[
``````%%%%%%%%#########################%%%%%%%%``````
``#####~~~~;~##......+.........+......##~;~~~~#####``
`##>..##____##..XXX..###########..XXX..##____##..>##`
`#..X..+....+..XXXXX..#...#...#..XXXXX..+....+..X..#`
%##...##____#..XXXXX..#.%.#.%.#..XXXXX..#____##...##%
%~##+##~;~~~##...X...##.%...%.##...X...##~~~;~##+##~%
%~;|.|~~%%%%%#+#...###..%+%+%..###...#+#%%%%%~~|.|;~%
%~~|.|~~%````#.#####...%%.%.%%...#####.#````%~~|.|~~%
%~~|.|~;%````#.#.....%%%.%.%.%%%.....#.#````%;~|.|~~%
%;~|.|~~%````#.+.%%%%%%.%.@.%.%%%%%%.+.#````%~~|.|~;%
%~~|.|~;%````#.#.....%%%.%.%.%%%.....#.#````%;~|.|~~%
%~~|.|~~%````#.#####...%%.%.%%...#####.#````%~~|.|~~%
%~;|.|~~%%%%%#+#...###..%+%+%..###...#+#%%%%%~~|.|;~%
%~##+##~;~~~##...X...##.%...%.##...X...##~~~;~##+##~%
%##...##____#..XXXXX..#.%.#.%.#..XXXXX..#____##...##%
`#..X..+....+..XXXXX..#...#...#..XXXXX..+....+..X..#`
`##>..##____##..XXX..###########..XXX..##____##..>##`
``#####~~~~;~##......+.........+......##~;~~~~#####``
``````%%%%%%%%#########################%%%%%%%%``````
]]
		generator.place_tile( translation, map, 14, 1 )
		level:player((math.random(2) == 1) and 17 or 63, (math.random(2) == 1) and 3 or 17)
	end,

	OnEnter = function ()
		level.status = 1

		--Just hardcode these.  It's a special level after all.
		level.data.regions = { { glass = { area.new( 17,  7, 17, 13 ) }, water = area.new( 15,  6, 16, 14 ) },
		                       { glass = { area.new( 22,  3, 25,  3 ) }, water = area.new( 21,  2, 26,  2 ) },
		                       { glass = { area.new( 22, 17, 25, 17 ) }, water = area.new( 21, 18, 26, 18 ) },
		                       { glass = { area.new( 19,  7, 19, 13 )
		                                 , area.new( 22,  5, 25,  5 )
		                                 , area.new( 22, 15, 25, 15 ) }, water = area.new( 20,  6, 25, 14 ) },
		                       { glass = { area.new( 63,  7, 63, 13 ) }, water = area.new( 64,  6, 65, 14 ) },
		                       { glass = { area.new( 55,  3, 58,  3 ) }, water = area.new( 54,  2, 59,  2 ) },
		                       { glass = { area.new( 55, 17, 58, 17 ) }, water = area.new( 54, 18, 59, 18 ) },
		                       { glass = { area.new( 61,  7, 61, 13 )
		                                 , area.new( 55,  5, 58,  5 )
		                                 , area.new( 55, 15, 58, 15 ) }, water = area.new( 55,  6, 60, 14 ) },
		                     }
	end,

	OnTick = function ()
		--Shooting the glass will cause portions of the level to flood
		--with water and release the harmless fish.  You bastard.
		--There are eight distinct water areas.  Flooding is computed
		--based on how many cells are released and where.
		for k, r in pairs(level.data.regions) do
			--Check for broken glass
			local glass_coord = nil
			for kk, glass_area in pairs(r.glass) do
				--Cannot use generator.scan, have multiple cell types.
				--Rolled up own variant for this level.
				glass_coord = flood_multiscan(glass_area, { wolf_glass_h = true, wolf_glass_v = true })
				if glass_coord ~= nil then break end
			end

			--If the glass broke flood some water and eliminate this check from future cycles
			if glass_coord ~= nil then
				local units = 0
				local water_area = r.water
				for water_coord in water_area() do
					if level.map[ water_coord ] == "deepwater" then units = units + 1 end
				end

				flood_corridor( glass_coord, units, area.FULL )
				generator.transmute("deepwater", "water", water_area)
				level.data.regions[k] = nil --The reason we use pairs instead of ipairs or loops is so we can do this safely
			end
		end
	end,

	OnKill = function (being)
		if level.status == 1 and being.id == "wolf_piranha" then
			level.status = 2
			for b in level:beings() do
				if (b.id == "wolf_bosswillie" and b ~= being) then
					b.flags[BF_HUNTING] = true
					break
				end
			end
		elseif being.id == "wolf_bosswillie" then
			level.status = 3
		end
	end,

	OnExit = function (being)
		--You're not suppossed to kill the fish.
		for b in level:beings() do
			if (b.id == "wolf_pirahna") then
				statistics.max_kills = statistics.max_kills - 1
			end
		end

		if statistics.damage_on_level == 0 and level.status == 3 then
			player:add_history("He won without damage.")
		elseif level.status == 3 then
			player:add_history("He won.")
		elseif level.status == 2 then
			player:add_history("He ran.")
		elseif level.status == 1 then
			player:add_history("He left.")
		end

		player.level_statuses[level.id] = level.status
	end,
}
