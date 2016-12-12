--[[ This as-of-yet-unknown special level is meant to look chaotic.
     I will probably make a zombie rush go here.  Special larger than
     average zombies may also be introduced here.
--]]

register_level "torment" {
	name  = "Proving Grounds",
	entry = "On level @1 he found the proving grounds.",
	welcome = "It's dark in here...",
	level = 13,

	canGenerate = function ()
		return not DoomRL.isepisode()
	end,

	OnCompletedCheck = function ()
		return level.status == 3 or level.status == 4
	end,

	OnRegister = function ()

	end,

	Create = function ()
		level.name = "Elysian Fields"
		generator.fill( "wolf_whwall", area.FULL )

		--Generate the map...
		local basetranslation = {
			['.'] = "acid",
			[','] = "floor",

			["`"] = "void",
			[">"] = "stairs",
			['#'] = { "wolf_whwall", flags = { LFPERMANENT } },
			['&'] = { "wolf_rewall", flags = { LFPERMANENT } },
			['%'] = { "wolf_blwall", flags = { LFPERMANENT } },
			['$'] = { "wolf_grwall", flags = { LFPERMANENT } },

			["+"] = "door",
			["="] = { "lmdoor1", flags = { LFPERMANENT } },
			["-"] = { "lmdoor2", flags = { LFPERMANENT } },
		}
		local gametranslation = {
			['.'] = "acid",
			[','] = "floor",

			["`"] = "void",
			[">"] = "stairs",
			['#'] = { "wolf_whwall", flags = { LFPERMANENT } },
			['&'] = { "wolf_rewall", flags = { LFPERMANENT } },
			['%'] = { "wolf_blwall", flags = { LFPERMANENT } },
			['$'] = { "wolf_grwall", flags = { LFPERMANENT } },

			["+"] = "door",
			["="] = { "lmdoor1", flags = { LFPERMANENT } },
			["-"] = { "lmdoor2", flags = { LFPERMANENT } },
		}

		local map = [[
#######################,,,,,,,,,,,,,,,,,,,&&&&&,,,,,#######################
############,,,,,,,,,,,,,,,$$$$,,,%,,,,&&&,,,,,,,,,,,,,,,,,,,,,############
#####,,,,,,,,,,,,%%%,,,,,$$..$,,,,,,,&&,,,,,,,,$$$$,,,,%,,,&,,,,,,,,,,#####
##,,,,&&&&&,,%%%,,,,,%,,$.....$,,,,,&,,,,,,$$$$.$$,,,,,%,,,,,,,$,,,,,,,,,##
#,,>,,,,,,&&,,,,,,,,,%,,$.$....$$$,,,,,$$$$....$,,,,,,%,,,,,,$,$,,,$,,,,,,#
,,,,,,,##,,&,,,,,,,,,,,,$$,$$.....$$$$$.......$,,,,,,%,,,,,$,,,$,$,$,,,,,,,
,,,,,#,,,,,,,,%%%%%%,,,,,,,,,$..$$...........$,,,,,%%,,,,,,,,,,$,,,$,,,,,,,
,,,,,,,,%,,,,,,,,,,,%%%%,,,,,,$.$...$$$$$...$,,,,%%,,,,,,,,,,$,$,,,$,,,,,,,
,,,,,,,,,,,,,,,,,,,,,,,,%%%%%%,$..$$`````$.$,,%%%,,,,,,&&,,$,,,$,,,,,,,,,,,
,,,#,,,,,,,$,,,,,,,,&&,,,,,,,,,$.$```````$.$,,,,,,,,,&&,,,,,,,,$,,,,,,,#,,,
,,,,,,,,,,,$,,,$,,&&,,,,,,%%%,,$.$`````$$..$,%%%%%%,,,,,,,,,,,,,,,,,,,,,,,,
,,,,,,,$,,,$,$,,,,,,,,,,%%,,,,$...$$$$$...$.$,,,,,,%%%%,,,,,,,,,,,%,,,,,,,,
,,,,,,,$,,,$,,,,,,,,,,%%,,,,,$...........$$..$,,,,,,,,,%%%%%%,,,,,,,,#,,,,,
,,,,,,,$,$,$,,,$,,,,,%,,,,,,$.......$$$$$.....$$,$$,,,,,,,,,,,,&,,##,,,,,,,
#,,,,,,$,,,$,$,,,,,,%,,,,,,$....$$$$,,,,,$$$....$.$,,%,,,,,,,,,&&,,,,,,,>,#
##,,,,,,,,,$,,,,,,,%,,,,,$$.$$$$,,,,,,&,,,,,$.....$,,%,,,,,%%%,,&&&&&,,,,##
#####,,,,,,,,,,&,,,%,,,,$$$$,,,,,,,,&&,,,,,,,$..$$,,,,,%%%,,,,,,,,,,,,#####
############,,,,,,,,,,,,,,,,,,,,,&&&,,,,%,,,$$$$,,,,,,,,,,,,,,,############
#######################,,,,,&&&&&,,,,,,,,,,,,,,,,,,,#######################
]]
		generator.place_tile( basetranslation, map, 2, 2 )
		generator.place_tile( gametranslation, map, 2, 2 )
		generator.scatter_blood(area.FULL,"floor",math.random(20)+70)
		generator.scatter( area.FULL,"floor","bloodpool", math.random(20))

		--Q+D generation so that there's something here for sneak peek
		local monster_list = { "wolf_dog1", "wolf_mutant1", "wolf_supermutant1",
		                       "wolf_dog2", "wolf_mutant2", "wolf_supermutant2", }
		level:flood_monsters{ danger = math.ceil( generator.being_weight() * 0.5 ), list = monster_list }
		level:flood_items{ amount = math.ceil( generator.item_amount() * 0.5 ) }

		generator.transmute("acid", "floor")

		level:player(34, 14)
	end,

	OnEnter = function ()
		level.data.penalty = math.floor(player.vision / 2)
		player.vision = player.vision - level.data.penalty
	end,

	OnCreate = function ( this )
		if this:is_being() and not this:is_player() then
			this.vision = math.floor( this.vision * 2 / 3)
		end
	end,

	OnTick = function ()

	end,

	OnExit = function (being)
		if statistics.damage_on_level == 0 then
			player:add_history("He took no damage.")
		else
			player:add_history("He took damage.")
		end

		player.vision = player.vision + level.data.penalty
		level.status = level.status + 2
		player.level_statuses[level.id] = level.status
	end,
}
