--[[ Professor Quarkblitz's lab ought to affect the artillery range
     but I can't think of a logical reason yet, nor can I think of
     an actual theme for this level.  Possibly a barracks + alarm?
     Or possibly a zombie lab if I have enough sprites to add bruiser
     mutants.
--]]

register_level "tll2" {
	name  = "The Complex",
	entry = "On level @1 he detoured to meet Quarkblitz.",
	welcome = "He puts the mad in mad scientist.",
	level = {9,11},

	canGenerate = function ()
		return DIFFICULTY >= DIFF_MEDIUM and not DoomRL.isepisode()
	end,

	OnCompletedCheck = function ()
		return level.status == 3
	end,

	OnRegister = function ()

	end,

	Create = function ()
		level.name = "War Pigs"
		generator.fill( "void", area.FULL )

		local quark_swap = table.shuffle{ "wolf_bossquark", nil}
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

			["1"] = {"floor", being = quark_swap[1]},
			["2"] = {"floor", being = quark_swap[2]},
		}

		local map = [[
`````````````#########`````````````
`````````````#.......#`````````````
```###########.......###########```
```#....#....#.......#.........#```
```#....+..>.#.......+.........#```
```#....#...1#.......#.........#```
####....#########+############+####
#.......#.................#.......#
#.......#.................#.......#
#.......#.................#.......#
#.......#.................#.......#
#####+###########+#########....####
```#.........#.......#2...#....#```
```#.........+.......#.>..+....#```
```#.........#.......#....#....#```
```###########.......###########```
`````````````#.......#`````````````
`````````````#########`````````````
]]
		generator.place_tile( translation, map, 22, 1 )

		level:player(39, 10)
	end,

	OnEnter = function ()

	end,

	OnTick = function ()

	end,

	OnKillAll = function ()
		level.status = level.status + 1
	end,

	OnExit = function (being)
		if statistics.damage_on_level == 0 then
			player:add_history("He won without damage.")
		else
			player:add_history("He won.")
		end

		level.status = level.status + 2
		player.level_statuses[level.id] = level.status
	end,
}
