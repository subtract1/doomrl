-- Episode 5: Trail of a Madman
require( "doomrl:levels/ep5_boss5" )
require( "doomrl:levels/ep5_spec5" )

--[[ Wolf3d Level notes (I don't like brown BTW, there's no way to make it look good):

    blue and white
    mostly white
    white
    white red blue
    wooden then white
    s-redwhiteblueequal
    white
    white
    rwb
    white & brown

    Unlike the last few episodes this doesn't mess with level types.
    Instead it messes with the actual generation parameters--more treasure,
    more flair, less everything else.
]]--

function DoomRL.loadepisode5()
	register_badge "erlangen1" {
		name  = "Decadent Bronze Badge",
		desc  = "Find the chemical plans in Castle Erlangen",
		level = 1,
	}
	register_badge "erlangen2" {
		name  = "Decadent Silver Badge",
		desc  = "Capture the chemical plans on DHM",
		level = 2,
	}
	register_badge "erlangen3" {
		name  = "Decadent Gold Badge",
		desc  = "Capture the chemical plans on BMO",
		level = 3,
	}
	register_badge "erlangen4" {
		name  = "Decadent Platinum Badge",
		desc  = "Capture the chemical plans on DI",
		level = 4,
	}
	register_badge "erlangen5" {
		name  = "Decadent Diamond Badge",
		desc  = "Succeed w/o any damage bonus traits on DI",
		level = 5,
	}
	register_badge "erlangen6" {
		name  = "Decadent Angelic Badge",
		desc  = "Succeed w/o any offensive traits on DI",
		level = 6,
	}
	register_medal "award5" {
		name  = "Legion of Merit",
		desc  = "Awarded for capturing the chemical war plans.",
		hidden  = false,
	}

	register_challenge "challenge_ep5" {
		name        = "Trail of a Madman",
		description = "Episode 5 of Wolfenstein.",
		rating      = "HARD",
		rank        = 3,
		abbr        = "Ep5",
		let         = "5",
		secondary   = { "Ber", "Mark", "Shot", "Seer", "Demo", "Stat", "MDK", "Game", "Surv", },
		removemedals = { "icarus1", "icarus2", "explorer", "conqueror", "competn1", "competn2", "competn3", "untouchable1", "untouchable2", "untouchable3" },
		win_mortem    = "Defeated Gretel Grosse",
		win_highscore = "Completed Episode 5",

		OnCreateEpisode = function ()
			DoomRL.ep5_OnCreateEpisode()
		end,
		OnCreatePlayer = function ()
			DoomRL.ep5_OnCreatePlayer()
		end,
		OnIntro = function ()
			return DoomRL.ep5_OnIntro()
		end,
		OnWinGame = function ()
			return DoomRL.ep5_OnWinGame()
		end,
		OnGenerate = function ()
			DoomRL.ep5_OnGenerate()
			return false
		end,
		OnEnter = function ( dlvl, id )
			DoomRL.ep5_OnEnter(dlvl, id)
		end,

		OnMortem = function ()
			if player:has_won() then player:add_badge("erlangen1") end
			if player:has_won() and DIFFICULTY >= DIFF_MEDIUM then player:add_badge("erlangen2") end
			if player:has_won() and DIFFICULTY >= DIFF_HARD then player:add_badge("erlangen3") end
			if player:has_won() and DIFFICULTY >= DIFF_VERYHARD then player:add_badge("erlangen4") end
			if player:has_won() and DIFFICULTY >= DIFF_VERYHARD and player:get_trait( traits["bitch"].nid ) <= 0 and player:get_trait( traits["gun"].nid ) <= 0 and player:get_trait( traits["brute"].nid ) <= 0 then player:add_badge("erlangen5") end
			if player:has_won() and DIFFICULTY >= DIFF_VERYHARD and player:get_trait( traits["finesse"].nid ) <= 0 and player:get_trait( traits["bitch"].nid ) <= 0 and player:get_trait( traits["gun"].nid ) <= 0 and player:get_trait( traits["reloader"].nid ) <= 0 and player:get_trait( traits["brute"].nid ) <= 0 and player:get_trait( traits["eagle"].nid ) <= 0 then player:add_badge("erlangen6") end
			if player:has_won() then player:add_medal("award5") end
		end,
	}
end

function DoomRL.ep5_OnCreateEpisode()

	--Assign our levels.  There's too much flair to loop
	player.episode = {}
	player.episode[1]  = {style = table.random_pick( { STYLE_BLUE,     STYLE_WHITE                 } ), number = 1,  name = "Erlangen", deathname = "Castle Erlangen", danger = 2}
	player.episode[2]  = {style = STYLE_WHITE,                                                          number = 2,  name = "Erlangen", deathname = "Castle Erlangen", danger = 2}
	player.episode[3]  = {style = table.random_pick( { STYLE_BLUE,     STYLE_RED,      STYLE_WHITE } ), number = 3,  name = "Erlangen", deathname = "Castle Erlangen", danger = 3}
	player.episode[4]  = {style = table.random_pick( { STYLE_WHITE,    STYLE_BROWN                 } ), number = 4,  name = "Erlangen", deathname = "Castle Erlangen", danger = 5}
	player.episode[5]  = {style = table.random_pick( { STYLE_BLUE,     STYLE_RED,      STYLE_WHITE } ), number = 5,  name = "Erlangen", deathname = "Castle Erlangen", danger = 6}
	player.episode[6]  = {style = STYLE_WHITE,                                                          number = 6,  name = "Erlangen", deathname = "Castle Erlangen", danger = 7}
	player.episode[7]  = {style = STYLE_WHITE,                                                          number = 7,  name = "Erlangen", deathname = "Castle Erlangen", danger = 9}
	player.episode[8]  = {style = table.random_pick( { STYLE_BLUE,     STYLE_RED,      STYLE_WHITE } ), number = 8,  name = "Erlangen", deathname = "Castle Erlangen", danger = 10}
	player.episode[9]  = {style = table.random_pick( { STYLE_WHITE,    STYLE_BROWN                 } ), number = 9,  name = "Erlangen", deathname = "Castle Erlangen", danger = 11}
--[[--]]	player.episode[10] = {style = STYLE_WHITE,                                                          number = 10, name = "Erlangen", deathname = "Castle Erlangen", danger = 12}

	player.episode[10] = {script = "boss5", style=STYLE_WHITE, deathname = "Castle Erlangen"}

	--Episodes only get one special level.
	local level_proto = levels["spec5"]
	if (not level_proto.canGenerate) or level_proto.canGenerate() then
		player.episode[resolverange(level_proto.level)].special = level_proto.id
	end
	statistics.bonus_levels_count = 1
end
function DoomRL.ep5_OnCreatePlayer()
	--Nothing to do right now
end
function DoomRL.ep5_OnIntro()
	DoomRL.plot_intro_5()
	return false
end
function DoomRL.ep5_OnWinGame()
	DoomRL.plot_outro_5()
	return false
end
function DoomRL.ep5_OnGenerate()
	core.log("DoomRL.OnGenerate()")

	--Select the level type based on (modified) weights
	local dlevel = level.danger_level
	local choice = weight_table.new()
	for _,g in ipairs(generators) do
		if dlevel >= g.min_dlevel and DIFFICULTY >= g.min_diff then
			local weight = core.ranged_table( g.weight, dlevel )
			if weight > 0 then choice:add( g, weight ) end
		end
	end
	if choice:size() == 0 then error("NO GENERATOR AVAILABLE!") end

	--Clone the generator.  Modify the generator to prevent high level enemies from spawning.
	local gen = generator.clone(choice:roll())
	if type( gen.monsters ) ~= "function" and gen.monsters > 0.01 then
		--Assign the generator our own custom inline function.
		--Normally the generator uses level:flood_monsters and just passes a weight.
		--That function actually has a LOT of potential arguments INCLUDING a 'permissible'
		--list.  The bad news is we lose groups since those don't have a name 
		local weight_adj = gen.monsters
		gen.monsters = function ( weight )
			local arg_danger = math.ceil( weight * weight_adj )
			local arg_list = { "wolf_guard1", "wolf_ss1", "wolf_dog1", "wolf_mutant1", "wolf_officer1", "wolf_fakehitler",
			                   "wolf_guard2", "wolf_ss2", "wolf_dog2", "wolf_mutant2", "wolf_officer2", "wolf_soldier1", "wolf_soldier2", "wolf_soldier3" }
			level:flood_monsters{ danger = arg_danger, list = arg_list }
		end
	end

	--Now modify the generator to abuse the rates of just about everything.
	if (type(gen.monsters) == "number") then gen.monsters = gen.monsters * 0.9 end
	if (type(gen.items)    == "number") then gen.items    = gen.items * 0.8 end
	if (type(gen.treasure) == "number") then gen.treasure = gen.treasure * 3 end
	if (type(gen.flair_rdoor) == "number") then gen.flair_rdoor = gen.flair_rdoor * 1.5 end
	if (type(gen.flair_rwall) == "number") then gen.flair_rwall = gen.flair_rwall * 1.5 end
	if (type(gen.flair_cwall) == "number") then gen.flair_cwall = gen.flair_cwall * 1.5 end
	if (type(gen.flair_ccorn) == "number") then gen.flair_ccorn = gen.flair_ccorn * 1.5 end
	if (type(gen.flair_cdoor) == "number") then gen.flair_cdoor = gen.flair_cdoor * 1.5 end
	if (type(gen.flair_nwall) == "number") then gen.flair_nwall = gen.flair_nwall * 1.5 end
	if (type(gen.flair_ncorn) == "number") then gen.flair_ncorn = gen.flair_ncorn * 1.5 end
	if (type(gen.flair_ndoor) == "number") then gen.flair_ndoor = gen.flair_ndoor * 1.5 end

	generator.run( gen )
end
function DoomRL.ep5_OnEnter(dlvl, id)
	core.log("DoomRL.OnEnter()")

	--Hack to account for the lack of a dynamic music sheet.
	--If the id string begins with 'level' replace that with 'ep' and play that track.
	if ( string.sub(id, 1, string.len("level")) == "level" ) then
		core.play_music('ep5_' .. string.sub(id, 6))
	end
end
