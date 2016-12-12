--[[ A sewer level of some sort.  There's very little danger so this makes a
     nice intro level.  Enemies are annoying but mostly harmless if you avoid
     the currents and there are nifty water-like effects to keep it interesting.
--]]

register_level "sewer" {
	name  = "The Sewers",
	entry = "On level @1 he snuck into the sewers.",
	welcome = "It stinks like rotting meat.",
	level = {4,5},

	canGenerate = function ()
		return not DoomRL.isepisode()
	end,

	OnCompletedCheck = function ()
		return level.status == 3 or level.status == 4
	end,

	OnRegister = function ()

	end,

	Create = function ()
		level.name = "Raging Waters"
		level.status = (player.level_statuses["tll1"] or 0) >= 3 and 2 or 1 --Beating Sub Willie floods this level with acid just because.

		generator.fill( "void", area.FULL )

		local translation = {
			['.'] = "floor",
			['~'] = "water",
			['"'] = "bridge",

			["`"] = "void",
			[">"] = "stairs",
			['#'] = { "wolf_whwall", flags = { LFPERMANENT } },
			['$'] = { "wolf_whwall", flags = { LFPERMANENT } }, --Todo: flarify special levels
			['&'] = "wolf_whwall",
			['%'] = "wolf_whwall", --flair

			["+"] = "door",
			["="] = { "lmdoor1", flags = { LFPERMANENT } },
			["-"] = { "lmdoor2", flags = { LFPERMANENT } },

			["1"] = {"floor", being = "wolf_rat"},
			["2"] = {"floor", being = core.bydiff{nil, "wolf_rat"}},
			["3"] = {"floor", being = core.bydiff{nil, nil, "wolf_rat"}},
			["4"] = {"floor", being = core.bydiff{nil, nil, nil, "wolf_rat"}},
		}

		local map = [[
````````````````####################################~~~#`````````
```````````````##.....3..........................2..~~~##````````
``############`#..~~~"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.1#````````
``#..........#`#.~~~~............................."""...#````````
``#..........#`#.~~~~#############################~~~...#######``
``#..........#`#.~~~~#```````````````````````````#~~~...##.1.3#``
``#..........###.~~~~#############################~~.....#..2.#``
``#..........+.+4~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~4....+.4>4#``
``#..........###.~~~~#############################~~.....#..2.#``
``#..........#`#.~~~~#```````````````````````````#~~~...##.1.3#``
``#..........#`#.~~~~#############################~~~...#######``
``#..........#`#.~~~~............................."""...#````````
``############`#..~~~"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.1#````````
```````````````##.....3..........................2..~~~##````````
````````````````####################################~~~#`````````
]]
		generator.place_tile( translation, map, 8, 3 )

		if (level.status >= 2) then
			generator.scatter( area.FULL,"water","acid", 60)
		end

		level:player(12, 10)
	end,

	OnEnter = function ()
		--Rats, go forth and maul the player!
		for b in level:beings() do
			if (math.random(2) == 1) then
				b.flags[ BF_HUNTING ] = true
			end
		end
	end,

	OnFire = function(item, being)
		--Gunplay is unreliable if you're stuck in the sewer.  Melee is always safe.
		if being:is_player() and item.itype == ITEMTYPE_RANGED and cells[level.map[being.position]].flags[ CF_LIQUID ] == true and math.random(3) > 1 then
			ui.msg("You slip trying to fire your " .. item.name .. ".")
			being.scount = being.scount - 500
			return false
		end
		return true
	end,

	OnUse = function (item, being)
		--Item usage is also unreliable in the rushing torrents.
		if being:is_player() and item.itype == ITEMTYPE_PACK and cells[level.map[being.position]].flags[ CF_LIQUID ] == true and math.random(5) > 2 then
			ui.msg("You slip trying to use your " .. item.name .. ".")
			being.scount = being.scount - 500
			return false
		end
		return true
	end,

	OnTick = function ()

	end,

	OnExit = function (being)
		if statistics.damage_on_level == 0 then
			player:add_history("He crawled through undetected.")
		else
			player:add_history("He slipped through intact.")
		end

		level.status = level.status + 2
		player.level_statuses[level.id] = level.status
	end,
}
