-- Episode 2: Operation: Eisenfaust
require( "doomrl:levels/ep2_spec2" )
require( "doomrl:levels/ep2_boss2" )

--[[ Wolf3d Level notes (I don't like brown BTW, there's no way to make it look good):

    mossy
    *s* blue
    moss blue some red min brown
    moss
    moss some white
    moss red brown blue dash of purple
    purple blue some white
    purple moss white--this is that level where 90% is secret
    brown white
    cyan, for the boss

    Zombies make their triumphant appearance here (and the alternate base
    enemies are unlocked).  Level-wise caves are three times as likely.
]]--

function DoomRL.loadepisode2()
	register_badge "hammer1" {
		name  = "Mengele Bronze Badge",
		desc  = "Reach level 5 of Castle Hollehammer",
		level = 1,
	}
	register_badge "hammer2" {
		name  = "Mengele Silver Badge",
		desc  = "Confront Dr. Schabbs",
		level = 2,
	}
	register_badge "hammer3" {
		name  = "Mengele Gold Badge",
		desc  = "Eliminate Dr. Schabbs on DHM",
		level = 3,
	}
	register_badge "hammer4" {
		name  = "Mengele Platinum Badge",
		desc  = "Eliminate Dr. Schabbs on BMO",
		level = 4,
	}
	register_badge "hammer5" {
		name  = "Mengele Diamond Badge",
		desc  = "Eliminate Dr. Schabbs on DI",
		level = 5,
	}
	register_badge "hammer6" {
		name  = "Mengele Angelic Badge",
		desc  = "Eliminate Schabbs within 10000 turns on DI",
		level = 6,
	}
	register_medal "award2" {
		name  = "Silver Star",
		desc  = "Awarded for preventing Operation: Eisenfaust.",
		hidden  = false,
	}

	register_challenge "challenge_ep2" {
		name        = "Operation: Eisenfaust",
		description = "Episode 2 of Wolfenstein.",
		rating      = "EASY",
		rank        = 1,
		abbr        = "Ep2",
		let         = "2",
		secondary   = { "Ber", "Mark", "Shot", "Seer", "Demo", "Stat", "MDK", "Game", "Surv", },
		removemedals = { "icarus1", "icarus2", "explorer", "conqueror", "competn1", "competn2", "competn3", "untouchable1", "untouchable2", "untouchable3" },
		win_mortem    = "Defeated Dr. Schabbs",
		win_highscore = "Completed Episode 2",

		--I would like to prevent everything above officers when reasonable
		OnCreateEpisode = function ()
			DoomRL.ep2_OnCreateEpisode()
		end,
		OnCreatePlayer = function ()
			DoomRL.ep2_OnCreatePlayer()
		end,
		OnIntro = function ()
			return DoomRL.ep2_OnIntro()
		end,
		OnWinGame = function ()
			return DoomRL.ep2_OnWinGame()
		end,
		OnGenerate = function ()
			DoomRL.ep2_OnGenerate()
			return false
		end,
		OnEnter = function ( dlvl, id )
			DoomRL.ep2_OnEnter(dlvl, id)
		end,

		OnMortem = function ()
			if player.depth >= 5 then player:add_badge("hammer1") end
			if player.depth >= 10 then player:add_badge("hammer2") end
			if player:has_won() and DIFFICULTY >= DIFF_MEDIUM then player:add_badge("hammer3") end
			if player:has_won() and DIFFICULTY >= DIFF_HARD then player:add_badge("hammer4") end
			if player:has_won() and DIFFICULTY >= DIFF_VERYHARD then player:add_badge("hammer5") end
			if player:has_won() and DIFFICULTY >= DIFF_VERYHARD and statistics.game_time < 10000 then player:add_badge("hammer6") end
			if player:has_won() then player:add_medal("award2") end
		end,
	}
end

function DoomRL.ep2_OnCreateEpisode()

	--Assign our levels.  There's too much flair to loop
	player.episode = {}
	player.episode[1]  = {style = STYLE_GREEN,                                                                       number = 1,  name = "Hollehammer", deathname = "Castle Hollehammer", danger = 2}
	player.episode[2]  = {style = STYLE_BLUE,                                                                        number = 2,  name = "Hollehammer", deathname = "Castle Hollehammer", danger = 2}
	player.episode[3]  = {style = table.random_pick( { STYLE_GREEN,    STYLE_BLUE,     STYLE_RED                } ), number = 3,  name = "Hollehammer", deathname = "Castle Hollehammer", danger = 3}
	player.episode[4]  = {style = STYLE_GREEN,                                                                       number = 4,  name = "Hollehammer", deathname = "Castle Hollehammer", danger = 4}
	player.episode[5]  = {style = table.random_pick( { STYLE_GREEN,    STYLE_WHITE                              } ), number = 5,  name = "Hollehammer", deathname = "Castle Hollehammer", danger = 4}
	player.episode[6]  = {style = table.random_pick( { STYLE_GREEN,    STYLE_BROWN,    STYLE_RED,    STYLE_BLUE } ), number = 6,  name = "Hollehammer", deathname = "Castle Hollehammer", danger = 5}
	player.episode[7]  = {style = table.random_pick( { STYLE_PURPLE,   STYLE_WHITE,    STYLE_BLUE               } ), number = 7,  name = "Hollehammer", deathname = "Castle Hollehammer", danger = 6}
	player.episode[8]  = {style = table.random_pick( { STYLE_PURPLE,   STYLE_GREEN,    STYLE_WHITE              } ), number = 8,  name = "Hollehammer", deathname = "Castle Hollehammer", danger = 6}
	player.episode[9]  = {style = table.random_pick( { STYLE_BROWN,    STYLE_WHITE                              } ), number = 9,  name = "Hollehammer", deathname = "Castle Hollehammer", danger = 7}
--[[--]]	player.episode[10] = {style = STYLE_CYAN,                                                                        number = 10, name = "Hollehammer", deathname = "Castle Hollehammer", danger = 8}

	player.episode[10] = {script = "boss2", style=STYLE_CYAN, deathname = "Castle Hollehammer"}

	--Episodes only get one special level.
	local level_proto = levels["spec2"]
	if (not level_proto.canGenerate) or level_proto.canGenerate() then
		player.episode[resolverange(level_proto.level)].special = level_proto.id
	end
	statistics.bonus_levels_count = 1
end
function DoomRL.ep2_OnCreatePlayer()
	--Nothing to do right now
end
function DoomRL.ep2_OnIntro()
	DoomRL.plot_intro_2()
	return false
end
function DoomRL.ep2_OnWinGame()
	DoomRL.plot_outro_2()
	return false
end
function DoomRL.ep2_OnGenerate()
	core.log("DoomRL.OnGenerate()")

	--Select the level type based on (modified) weights
	local dlevel = level.danger_level
	local choice = weight_table.new()
	for _,g in ipairs(generators) do
		if dlevel >= g.min_dlevel and DIFFICULTY >= g.min_diff then
			local weight = core.ranged_table( g.weight, dlevel )
			if g.id == "gen_caves" or g.id == "gen_caves_2" then weight = math.ceil(weight * 3) end
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
			local arg_list = { "wolf_guard1", "wolf_ss1", "wolf_dog1", "wolf_mutant1",
			                   "wolf_guard2", "wolf_ss2", "wolf_dog2", "wolf_mutant2" }
			level:flood_monsters{ danger = arg_danger, list = arg_list }
		end
	end

	generator.run( gen )
end
function DoomRL.ep2_OnEnter(dlvl, id)
	core.log("DoomRL.OnEnter()")

	--Hack to account for the lack of a dynamic music sheet.
	--If the id string begins with 'level' replace that with 'ep' and play that track.
	if ( string.sub(id, 1, string.len("level")) == "level" ) then
		core.play_music('ep2_' .. string.sub(id, 6))
	end
end
