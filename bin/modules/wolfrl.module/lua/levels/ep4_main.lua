-- Episode 4: A Dark Secret
require( "doomrl:levels/ep4_boss4" )
require( "doomrl:levels/ep4_spec4" )

--[[ Wolf3d Level notes (I don't like brown BTW, there's no way to make it look good):

    white some red very little rock
    blue some red
    red some white
    secret-rock
    wood and rock
    rock then white
    blue then wood
    red then white
    moss white red blue rock
    white minor red & blue

    Mazes mazes mazes.  This episode loves 'em.  We also see fakehitlers and
    alternate officers in ordinary levels here.
]]--

function DoomRL.loadepisode4()
	register_badge "lab1" {
		name  = "Sarin Bronze Badge",
		desc  = "Reach Otto Giftmacher",
		level = 1,
	}
	register_badge "lab2" {
		name  = "Sarin Silver Badge",
		desc  = "Best Otto Giftmacher in battle",
		level = 2,
	}
	register_badge "lab3" {
		name  = "Sarin Gold Badge",
		desc  = "Best Otto Giftmacher on DHM",
		level = 3,
	}
	register_badge "lab4" {
		name  = "Sarin Platinum Badge",
		desc  = "Best Otto Giftmacher on BMO",
		level = 4,
	}
	register_badge "lab5" {
		name  = "Sarin Diamond Badge",
		desc  = "Best Otto Giftmacher on DI",
		level = 5,
	}
	register_badge "lab6" {
		name  = "Sarin Angelic Badge",
		desc  = "Best Otto Giftmacher on DI without taking dmage",
		level = 6,
	}
	register_medal "award4" {
		name  = "EAME Campaign Medal",
		desc  = "Awarded for eliminating Otto Giftmacher.",
		hidden  = false,
	}

	register_challenge "challenge_ep4" {
		name        = "A Dark Secret",
		description = "Episode 4 of Wolfenstein.",
		rating      = "MEDIUM",
		rank        = 2,
		abbr        = "Ep4",
		let         = "4",
		secondary   = { "Ber", "Mark", "Shot", "Seer", "Demo", "Stat", "MDK", "Game", "Surv", },
		removemedals = { "icarus1", "icarus2", "explorer", "conqueror", "competn1", "competn2", "competn3", "untouchable1", "untouchable2", "untouchable3" },
		win_mortem    = "Defeated Otto Giftmacher",
		win_highscore = "Completed Episode 4",

		OnCreateEpisode = function ()
			DoomRL.ep4_OnCreateEpisode()
		end,
		OnCreatePlayer = function ()
			DoomRL.ep4_OnCreatePlayer()
		end,
		OnIntro = function ()
			return DoomRL.ep4_OnIntro()
		end,
		OnWinGame = function ()
			return DoomRL.ep4_OnWinGame()
		end,
		OnGenerate = function ()
			DoomRL.ep4_OnGenerate()
			return false
		end,
		OnEnter = function ( dlvl, id )
			DoomRL.ep4_OnEnter(dlvl, id)
		end,

		OnMortem = function ()
			if player.depth >= 10 then player:add_badge("lab1") end
			if player:has_won() then player:add_badge("lab2") end
			if player:has_won() and DIFFICULTY >= DIFF_MEDIUM then player:add_badge("lab3") end
			if player:has_won() and DIFFICULTY >= DIFF_HARD then player:add_badge("lab4") end
			if player:has_won() and DIFFICULTY >= DIFF_VERYHARD then player:add_badge("lab5") end
			if player:has_won() and DIFFICULTY >= DIFF_VERYHARD and statistics.damage_on_level == 0 then player:add_badge("lab6") end
			if player:has_won() then player:add_medal("award4") end
		end,
	}
end

function DoomRL.ep4_OnCreateEpisode()

	--Assign our levels.  There's too much flair to loop
	player.episode = {}
	player.episode[1]  = {style = table.random_pick( { STYLE_WHITE,    STYLE_WHITE,    STYLE_RED                  } ), number = 1,  name = "Laboratory", deathname = "the Laboratory", danger = 2}
	player.episode[2]  = {style = table.random_pick( { STYLE_BLUE,     STYLE_BLUE,     STYLE_RED                  } ), number = 2,  name = "Laboratory", deathname = "the Laboratory", danger = 2}
	player.episode[3]  = {style = table.random_pick( { STYLE_RED,      STYLE_RED,      STYLE_WHITE                } ), number = 3,  name = "Laboratory", deathname = "the Laboratory", danger = 3}
	player.episode[4]  = {style = table.random_pick( { STYLE_DARK,     STYLE_BROWN                                } ), number = 4,  name = "Laboratory", deathname = "the Laboratory", danger = 4}
	player.episode[5]  = {style = table.random_pick( { STYLE_WHITE,    STYLE_BROWN                                } ), number = 5,  name = "Laboratory", deathname = "the Laboratory", danger = 5}
	player.episode[6]  = {style = table.random_pick( { STYLE_BLUE,     STYLE_BROWN                                } ), number = 6,  name = "Laboratory", deathname = "the Laboratory", danger = 6}
	player.episode[7]  = {style = STYLE_RED,                                                                           number = 7,  name = "Laboratory", deathname = "the Laboratory", danger = 7}
	player.episode[8]  = {style = table.random_pick( { STYLE_GREEN,    STYLE_WHITE,    STYLE_RED,    STYLE_BROWN  } ), number = 8,  name = "Laboratory", deathname = "the Laboratory", danger = 8}
	player.episode[9]  = {style = table.random_pick( { STYLE_GREEN,    STYLE_WHITE,    STYLE_RED,    STYLE_BROWN  } ), number = 9,  name = "Laboratory", deathname = "the Laboratory", danger = 9}
--[[--]]	player.episode[10] = {style = STYLE_WHITE,                                                                         number = 10, name = "Laboratory", deathname = "the Laboratory", danger = 9}

	player.episode[10] = {script = "boss4", style=STYLE_RED, deathname = "the Laboratory"}

	--Episodes only get one special level.
	local level_proto = levels["spec4"]
	if (not level_proto.canGenerate) or level_proto.canGenerate() then
		player.episode[resolverange(level_proto.level)].special = level_proto.id
	end
	statistics.bonus_levels_count = 1
end
function DoomRL.ep4_OnCreatePlayer()
	--Nothing to do right now
end
function DoomRL.ep4_OnIntro()
	DoomRL.plot_intro_4()
	return false
end
function DoomRL.ep4_OnWinGame()
	DoomRL.plot_outro_4()
	--As a special bonus, if the player beat the Blake Stone level play THAT game's music during the mortem.
	if (statistics.bonus_levels_completed == statistics.bonus_levels_count) then core.play_music("blake") end
	return false
end
function DoomRL.ep4_OnGenerate()
	core.log("DoomRL.OnGenerate()")

	--Select the level type based on (modified) weights
	local dlevel = level.danger_level
	local choice = weight_table.new()
	for _,g in ipairs(generators) do
		if dlevel >= g.min_dlevel and DIFFICULTY >= g.min_diff then
			local weight = core.ranged_table( g.weight, dlevel )
			if g.id == "gen_maze" then weight = math.ceil(weight * 4) end
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
			                   "wolf_guard2", "wolf_ss2", "wolf_dog2", "wolf_mutant2", "wolf_officer2"}
			level:flood_monsters{ danger = arg_danger, list = arg_list }
		end
	end

	generator.run( gen )
end
function DoomRL.ep4_OnEnter(dlvl, id)
	core.log("DoomRL.OnEnter()")

	--Hack to account for the lack of a dynamic music sheet.
	--If the id string begins with 'level' replace that with 'ep' and play that track.
	if ( string.sub(id, 1, string.len("level")) == "level" ) then
		core.play_music('ep4_' .. string.sub(id, 6))
	end
end
