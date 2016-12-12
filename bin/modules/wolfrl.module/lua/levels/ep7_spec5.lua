--[[ The teleporter lab, home of a phase device or two and absolutely loaded
     with invisible teleporters.  Generating this is tricky since we must make
     sure there is (1) a path to the exit and (2) dropping teleporters on cells
     can cause problems if an item is already there.  In regular DoomRL an item
     can't get dropped on a teleporter cell; it will be shifted like any other
     item.  But we can't actually DROP a teleporter until the user lands on that
     tile.  So we displace the item when dropping.  Annoying but the best way.

     Since all the magic happens in OnTick a player with a move speed below 0.1s
     can actually run over a teleporter (mire crystal).  There's nothing I can
     do about this without some egregious hacks.

     Lastly, despite my protests I had to whip up a pathfinding algorithm in
     LUA.  It is not fast.
--]]
local pathfinding_gettableentry = function( coord, cell_table )
	--I need these two procs because cells are complex user objects
	--and I need a way to treat them like primitives in a hashset
	if cell_table[coord.x] ~= nil then return cell_table[coord.x][coord.y] else return nil end
end
local pathfinding_settableentry = function( coord, val, out_cell_table )
	--I need these two procs because cells are complex user objects
	--and I need a way to treat them like primitives in a hashset
	if out_cell_table[coord.x] == nil then out_cell_table[coord.x] = {} end
	out_cell_table[coord.x][coord.y] = val
end
local pathfinding_manhattan_estimate = function( start_coord, end_coord )
	local straight_move_cost = 10
	return (math.abs(start_coord.x - end_coord.x) + math.abs(start_coord.y - end_coord.y)) * straight_move_cost
end
local pathfinding_find_lowest_est = function( list, f )
	local best_weight = 9999
	local best_index = 0

	--If there are performance issues we could try optimizing
	--this by maintaining a sorted list
	for i,c in ipairs( list ) do
		local current_f = pathfinding_gettableentry( c, f )
		if current_f <= best_weight then -->= ensures we favor more recent nodes
			best_weight = current_f
			best_index = i
		end
	end

	return best_index
end
local pathfinding_astar = function( start_coord, end_coord, border )
	--Unfortunately the pascal pathfinding algos are not available
	--to us in a usable format...
	local diag_move_cost = 10
	local straight_move_cost = 10

	--Initial setup (made harder because coords are complex 
	--datatypes that don't play nicely with lua table indexes)
	local open_list = {}
	local open_list_set = {} --true false and nil for open closed and never entered.
	local g_scores = {}
	local f_scores = {}
	table.insert( open_list, start_coord )
	pathfinding_settableentry( start_coord, true, open_list_set )
	pathfinding_settableentry( start_coord, 0, g_scores )
	pathfinding_settableentry( start_coord, pathfinding_gettableentry( start_coord, g_scores ) + pathfinding_manhattan_estimate( start_coord, end_coord ), f_scores )

	while #open_list > 0 do
		--Get best candidate
		local current_node_index = pathfinding_find_lowest_est( open_list, f_scores )
		local current_node = open_list[current_node_index]
		if current_node == end_coord then return true end

		--Add to closed set, remove from open list
		table.remove(open_list, current_node_index)
		pathfinding_settableentry( current_node, false, open_list_set )

		--Calculate values for bordering cells
		for neighbor_node in current_node:around_coords() do
			if ( border:contains(neighbor_node) and pathfinding_gettableentry(neighbor_node, open_list_set) == nil ) then
				--Okay, the coordinate is valid, now check the cell
				local cell_proto = cells[ level.map[ neighbor_node ] ]
				if ( ( not cell_proto.flags[ CF_BLOCKMOVE ] or cell_proto.set == CELLSET_DOORS ) and level.data.teleporters[neighbor_node.x*25+neighbor_node.y] == nil ) then
					--Okay, the cell type also checks out, calc G and F
					local new_g = pathfinding_gettableentry( current_node, g_scores )
					if neighbor_node.x == current_node.x or neighbor_node.y == current_node.y then new_g = new_g + straight_move_cost else new_g = new_g + diag_move_cost end
					local new_f = new_g + pathfinding_manhattan_estimate( neighbor_node, end_coord )

					--Ordinarily we'd check to see if we got a better f value with our current node than some past node.
					--That might concern us if we both cared to return a path and cared for it to be as efficient as possible.
					--We don't so I'm just going to add it to the open set.
					--Otherwise add it to the candidate pool and establish the g/h values.
					pathfinding_settableentry( neighbor_node, new_g, g_scores )
					pathfinding_settableentry( neighbor_node, new_f, f_scores )
					pathfinding_settableentry( neighbor_node, true, open_list_set )
					table.insert( open_list, neighbor_node:clone() )
				end
			end
		end
	end

	return false
end

register_level "tele" {
	name  = "Teleporter Labs",
	entry = "On level @1 he found the teleporter research labs.",
	welcome = "This area looks pretty simple.",
	level = {20,21},

	canGenerate = function ()
		return not DoomRL.isepisode()
	end,

	OnCompletedCheck = function ()
		return level.status == 3 or level.status == 4
	end,

	OnRegister = function ()

	end,

	Create = function ()
		local basetranslation = {
			['.'] = "floor",
			[','] = "rock",

			["`"] = "void",
			[">"] = "stairs",
			['#'] = "wolf_dkwall",
			['$'] = { "wolf_dkwall", flags = { LFPERMANENT } },
			['%'] = "wolf_cvwall",
			['&'] = { "wolf_cvwall", flags = { LFPERMANENT } },
			['S'] = "rock",

			["+"] = "door",
			["="] = { "lmdoor1", flags = { LFPERMANENT } },
			["-"] = { "lmdoor2", flags = { LFPERMANENT } },
		}
		local gametranslation = {
			['.'] = "floor",
			[','] = "rock",

			["`"] = "void",
			[">"] = "stairs",
			['#'] = "wolf_dkwall",
			['$'] = { "wolf_dkwall", flags = { LFPERMANENT } },
			['&'] = { "wolf_cvwall", flags = { LFPERMANENT } },
			['%'] = "wolf_cvwall",
			['S'] = { "rock", item = { "teleport", target = coord.new(4,11) } },

			["+"] = "door",
			["="] = { "lmdoor1", flags = { LFPERMANENT } },
			["-"] = { "lmdoor2", flags = { LFPERMANENT } },
		}

		--generator goes in top right
		local map = [[
,&&,,,,,,,,&&&&&..........&&&....$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
,,,,,,,,&&&&.....................###...............######...........####.....$
,,,,,,&&&........................+...................##...............##.....$
,,,,S&&......................#####........###........+.................#.....$
,,,,&&..........#####........#...+...................#.................##+#+#$
,,,&&...........#...###......##+####...............###........#........+.....$
&,&&............#.....###........##########+##########.................#.....$
,&&&......#######.......###......#........#.#........+.................#.....$
,&&...#####.....#.........+......#........#.#........##...............###+#+#$
&&....#.........+.......###......#####.####.####.########...........###......$
&&....+.........#.......###......+...................+..######.######........$
&.....#####################......+...................+.......................$
&&...............................#####.####.####.#####.......................$
&&&...........................&..#........#.#........#......%%%%%............$
`&&.....&.....................&&.#........#.#........#....%%%,,,%%.##+#####+#$
`&.....&&&.......................##########+##########..%%%,,,,,,%.#..........
&&....&&`&&....###+###############...................#.%%,,,,,,%%%.#..........
&.....&```&&...+.................+...................+..%%%%%%%%...+......>...
.....&&````&&&.#.................+.........&&&&.&&...+.............+........&&
&....&```````&&&$$$$$$$$$$$$$$$$$$$$$$$$$$&&&&&.&&&$$$$$$$$$$$$$$$$$&....&&&&`]]

		generator.place_tile( basetranslation, map, 1, 1 )
		generator.place_tile( gametranslation, map, 1, 1 )

		--Generate teleporters
		level.data.teleporters = {}
		level.data.mishaps = 0
		level.data.walls = 0
		level:player(2, 2)

		--Count all of the breakable walls.  For fun.
		for c in area.coords( area.FULL ) do
			if (level.light[c][LFPERMANENT] == false and cells[ generator.get_cell(c) ].set == CELLSET_WALLS) then
				level.data.walls = level.data.walls + 1
			end
		end

		--I'd like to just mention that we've got two different coord indexing methods in use.
		--The first is more proper, the second is a hack that works as long as level sizes are
		--no greater than 25 vertical.  I wrote them at different points in time and have not,
		--despite meaning to make things 'simple' for modders, rectified that yet.
		local start_area = area.new(1,1,4,2)
		local tele_targets = {}
		local count = 500
		repeat
			count = count - 1

			--Get free cells for the teleportation
			local tries = 5
			local pos1 = nil
			local pos2 = nil
			while true do
				tries = tries - 1
				if tries == 0 then break end

				if (pos1 == nil) then
					pos1 = generator.random_empty_coord{ EF_NOITEMS, EF_NOSTAIRS, EF_NOBLOCK, EF_NOHARM, EF_NOSPAWN }
					if (level.data.teleporters[pos1.x*25+pos1.y] ~= nil or tele_targets[pos1.x*25+pos1.y] or start_area:contains(pos1) or pos1 == pos2) then pos1 = nil end
				end
				if (pos2 == nil) then
					pos2 = generator.random_empty_coord{ EF_NOITEMS, EF_NOSTAIRS, EF_NOBLOCK, EF_NOHARM, EF_NOSPAWN }
					if (level.data.teleporters[pos2.x*25+pos2.y] ~= nil or pos1 == pos2) then pos2 = nil end
				end

				if (pos1 ~= nil and pos2 ~= nil) then break end
			end

			if (tries > 0) then
				level.data.teleporters[pos1.x*25+pos1.y] = pos2
				tele_targets[pos2.x*25+pos2.y] = true
			end
		until count <= 0

		--trace through the teleporters and make a path to the exit if none exists (TODO)

		tele_targets = nil
	end,

	OnEnter = function ()
		level.status = 1
	end,

	OnTick = function ()
		--iterate through every being and see if they are standing on a hidden teleporter.
		if (level.status == 1) then
			--for b in level:beings() do
				local b = player
				local tele_coord = level.data.teleporters[b.position.x*25+b.position.y]
				if (tele_coord ~= nil) then
					--Drop the teleporter, then displace any items that may already exist there.
					local tele = level:drop_item_ext( {"teleport", target = tele_coord }, b.position )
					if (tele ~= nil and tele.position ~= b.position) then
						local otherItem = level:get_item(b.position)
						if (otherItem ~= nil) then
							otherItem:displace(tele.position)
						end
						tele:displace(b.position)
					end

					if (b == player) then
						level.data.mishaps = level.data.mishaps + 1
						if (level.data.mishaps == 1) then
							ui.msg( table.random_pick( {"Huh?", "What the hell just happened?", "What the-", "This isn't where I wanted to go.", } ) )
						end
					end
					level.data.teleporters[b.position.x*25+b.position.y] = nil
				end
			--end
		end
	end,

	OnExit = function (being)
		local walls = 0
		for c in area.coords( area.FULL ) do
			if (level.light[c][LFPERMANENT] == false and cells[ generator.get_cell(c) ].set == CELLSET_WALLS) then
				walls = walls + 1
			end
		end

		local destroyedGenerator = (level.status == 2)
		local bruteForce = (level.data.walls * 4 / 5 > walls)
		local demolitionMan = (level.data.walls * 3 / 5 > walls)
		local mishaps = level.data.mishaps

		if (not destroyedGenerator) then
			player:add_history("He "
			 .. ((mishaps == 0) and ("glided through the area with ease" .. ((bruteForce) and " (and " .. ((demolitionMan) and "lots of " or "") .. "explosives)" or "") .. ".")
			 or ((mishaps < 19) and ("walked through the area with " .. ((bruteForce) and "" .. ((demolitionMan) and "" or "a little ") .. "help from high explosives" or "little trouble") .. ".")
			 or ((mishaps < 37) and ("ran through the area with some annoyance" .. ((bruteForce) and " (harmlessly taken out on the " .. ((demolitionMan) and "many " or "") .. "walls)" or "") .. ".")
			 or ((mishaps < 55) and ("" .. ((bruteForce) and "blasted " or "bashed ") .. "through the area with great difficulty.")
			 or ("blundered around with extreme frustration."))))))
		else
			player:add_history("He "
			 .. ((not bruteForce) and "disabled" or ((not demolitionMan) and "destroyed" or "recklessly blasted"))
			 .. " the generator "
			 .. ((mishaps == 0) and "immediately on entry" or ((mishaps < 55) and "and left" or "after blundering around in frustration"))
			 .. ".")
		end

		level.status = level.status + 2
		player.level_statuses[level.id] = level.status
	end,
}
