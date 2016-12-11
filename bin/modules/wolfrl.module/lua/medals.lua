-- XXX Maximum length for desc is 44 characters (maybe 43)
function DoomRL.loadmedals()

	register_medal "killall" {
		name  = "Genocide Superstar",
		desc  = "Awarded for a perfect kill rate",
		winonly = true,
		condition = function() return statistics.kills == statistics.max_kills end,
	}
	register_medal "knives" {
		name  = "Malicious Knives Cross",
		desc  = "Won & killed everything with knives and fists",
		hidden  = true,
		winonly = true,
		condition = function() return kills.get_type( "other" ) + kills.get_type( "melee" ) + kills.get_type( "wolf_knife" ) == statistics.kills end,
	}
	register_medal "fist" {
		name  = "Sunrise Iron Fist",
		desc  = "Won & killed everything with your bare hands",
		hidden  = true,
		winonly = true,
		removes = { "knives" },
		condition = function() return kills.get_type( "other" ) + kills.get_type( "melee" ) == statistics.kills end,
	}
	register_medal "uac1" {
		name  = "UAC Star (bronze cluster)",
		desc  = "25 kills without taking damage",
		condition = function() return statistics.kills_non_damage >= 25 end,
	}
	register_medal "uac2" {
		name  = "UAC Star (silver cluster)",
		desc  = "50 kills without taking damage",
		removes = { "uac1" },
		condition = function() return statistics.kills_non_damage >= 50 end,
	}
	register_medal "uac3" {
		name  = "UAC Star (gold cluster)",
		desc  = "100 kills without taking damage",
		removes = { "uac1", "uac2" },
		condition = function() return statistics.kills_non_damage >= 100 end,
	}
	register_medal "icarus1" {
		name  = "Minor Icarus Cross",
		desc  = "Finished the game in less than 40,000 turns",
		winonly = true,
		condition = function() return statistics.game_time <= 40000 end,
	}
	register_medal "icarus2" {
		name  = "Major Icarus Cross",
		desc  = "Finished the game in less than 20,000 turns",
		winonly = true,
		removes = { "icarus1" },
		condition = function() return statistics.game_time <= 20000 end,
	}
	register_medal "gambler" {
		name  = "Gambler's Shield",
		desc  = "Pulled more than 25 levers in one game",
		condition = function() return statistics.levers_pulled > 25 end,
	}
	register_medal "aurora" {
		name  = "Aurora Medallion",
		desc  = "Found more than 3 uniques in one game",
		condition = function() return statistics.uniques_found > 3 end,
	}
	register_medal "explorer" {
		name  = "Explorer Badge",
		desc  = "Visited all generated levels",
		condition = function() return statistics.bonus_levels_visited == statistics.bonus_levels_count end,
	}
	register_medal "conqueror" {
		name  = "Conqueror Badge",
		desc  = "Completed all generated levels",
		removes = { "explorer" },
		condition = function() return statistics.bonus_levels_completed == statistics.bonus_levels_count end,
	}
	register_medal "competn1" {
		name  = "Compet-n Silver Cross",
		desc  = "Finished the game in under 30 minutes",
		winonly = true,
		condition = function() return statistics.real_time <= 30*60 end,
	}
	register_medal "competn2" {
		name  = "Compet-n Gold Cross",
		desc  = "Finished the game in under 20 minutes",
		winonly = true,
		removes = { "competn1" },
		condition = function() return statistics.real_time <= 20*60 end,
	}
	register_medal "competn3" {
		name  = "Compet-n Platinum Cross",
		desc  = "Finished the game in under 10 minutes",
		winonly = true,
		removes = { "competn1", "competn2" },
		condition = function() return statistics.real_time <= 10*60 end,
	}
	register_medal "fallout1" {
		name  = "Fallout Gold Cross",
		desc  = "Nuked at least 3 levels in one game",
		hidden  = true,
		condition = function() return statistics.levels_nuked > 2 end,
	}
	register_medal "fallout2" {
		name  = "Fallout Platinum Cross",
		desc  = "Nuked at least 6 levels in one game",
		hidden  = true,
		removes = { "fallout1" },
		condition = function() return statistics.levels_nuked > 5 end,
	}
	register_medal "ironskull1" {
		name  = "Iron Skull",
		desc  = "Took 10,000 damage in one game",
		hidden  = true,
		condition = function() return statistics.damage_taken > 10000 end,
	}
	register_medal "untouchable1" {
		name  = "Untouchable Badge",
		desc  = "Won taking less than 500 damage",
		winonly = true,
		condition = function() return statistics.damage_taken < 500 end,
	}
	register_medal "untouchable2" {
		name  = "Untouchable Medal",
		desc  = "Won taking less than 200 damage",
		hidden  = true,
		winonly = true,
		removes = { "untouchable1" },
		condition = function() return statistics.damage_taken < 200 end,
	}
	register_medal "untouchable3" {
		name  = "Untouchable Cross",
		desc  = "Won taking less than 50 damage",
		hidden  = true,
		winonly = true,
		removes = { "untouchable1", "untouchable2" },
		condition = function() return statistics.damage_taken < 50 end,
	}
	register_medal "experience1" {
		name  = "Experience Medal",
		desc  = "Reach experience level 20",
		condition = function() return player.explevel >= 20 end,
	}
	register_medal "experience2" {
		name  = "Experience Cross",
		desc  = "Reach experience level 25",
		removes = { "experience1" },
		condition = function() return player.explevel >= 25 end,
	}

-- <action> [on <difficulty>][<special conditions>] (for badges)
	register_badge "buac1" {
		name  = "UAC Bronze Badge",
		desc  = "Win @<standard@> game on any difficulty",
		level = 1,
	}
	register_badge "buac2" {
		name  = "UAC Silver Badge",
		desc  = "Win @<standard@> game on Hurt Me Plenty",
		level = 2,
	}
	register_badge "buac3" {
		name  = "UAC Gold Badge",
		desc  = "Win @<standard@> game on Ultra-Violence",
		level = 3,
	}
	register_badge "buac4" {
		name  = "UAC Platinum Badge",
		desc  = "Win @<standard@> game on N!",
		level = 4,
	}
	register_badge "buac5" {
		name  = "UAC Diamond Badge",
		desc  = "Win @<standard@> N! game under 20 min",
		level = 5,
	}
	register_badge "buac6" {
		name  = "UAC Angelic Badge",
		desc  = "Win @<standard@> N! damageless",
		level = 6,
	}

	register_badge "veteran1" {
		name  = "Veteran Bronze Badge",
		desc  = "Win game on any difficulty w/100% kills",
		level = 1,
	}
	register_badge "veteran2" {
		name  = "Veteran Silver Badge",
		desc  = "Win game on Hurt Me Plenty w/100% kills",
		level = 2,
	}
	register_badge "veteran3" {
		name  = "Veteran Gold Badge",
		desc  = "Win game on UV/100% kills",
		level = 3,
	}
	register_badge "veteran4" {
		name  = "Veteran Platinum Badge",
		desc  = "Fully win the game on UV",
		level = 4,
	}
	register_badge "veteran5" {
		name  = "Veteran Diamond Badge",
		desc  = "Fully win the game on N!",
		level = 5,
	}
	register_badge "veteran6" {
		name  = "Veteran Angelic Badge",
		desc  = "Fully win on N!/100%",
		level = 6,
	}

	register_badge "strongman1" {
		name  = "Strongman Bronze Badge",
		desc  = "Win @<standard@> game using basic melee weapons",
		level = 1,
	}
	register_badge "strongman2" {
		name  = "Strongman Silver Badge",
		desc  = "Win @<standard@> game using knives/fists",
		level = 2,
	}
	register_badge "strongman3" {
		name  = "Strongman Gold Badge",
		desc  = "Win @<standard@> game using knives/fists HMP",
		level = 3,
	}
	register_badge "strongman4" {
		name  = "Strongman Platinum Badge",
		desc  = "Win @<standard@> game using only fists HMP",
		level = 4,
	}
	register_badge "strongman5" {
		name  = "Strongman Diamond Badge",
		desc  = "Win @<standard@> game fist-only HMP/100% kills",
		level = 5,
	}
	register_badge "strongman6" {
		name  = "Strongman Angelic Badge",
		desc  = "Win @<standard@> game fist-only N!/90% kills",
		level = 6,
	}

	register_badge "speedrunner1" {
		name  = "Speedrunner Bronze Badge",
		desc  = "Win @<standard@> game under 30 minutes",
		level = 1,
	}
	register_badge "speedrunner2" {
		name  = "Speedrunner Silver Badge",
		desc  = "Win @<standard@> HNTR game under 25 minutes",
		level = 2,
	}
	register_badge "speedrunner3" {
		name  = "Speedrunner Gold Badge",
		desc  = "Win @<standard@> HMP game under 20 minutes",
		level = 3,
	}
	register_badge "speedrunner4" {
		name  = "Speedrunner Platinum Badge",
		desc  = "Win AoHaste HMP+ game under 10 minutes",
		level = 4,
	}
	register_badge "speedrunner5" {
		name  = "Speedrunner Diamond Badge",
		desc  = "Win AoHaste N! game under 10 minutes",
		level = 5,
	}
	register_badge "speedrunner6" {
		name  = "Speedrunner Angelic Badge",
		desc  = "Win @<standard@> N! game under 4 minutes",
		level = 6,
	}

	register_badge "elite4" {
		name  = "Elite Platinum Badge",
		desc  = "Win @<standard@> UV game as Conqueror",
		level = 4,
	}
	register_badge "elite5" {
		name  = "Elite Diamond Badge",
		desc  = "Win @<standard@> N!/90% kills",
		level = 5,
	}
	register_badge "elite6" {
		name  = "Elite Angelic Badge",
		desc  = "Win @<standard@> N!/100% as Conqueror",
		level = 6,
	}

	register_badge "demonic4" {
		name  = "Demonic Platinum Badge",
		desc  = "Win @<standard@> N! as Explorer",
		level = 4,
	}
	register_badge "demonic5" {
		name  = "Demonic Diamond Badge",
		desc  = "Win @<standard@> N! with Untouchable Medal",
		level = 5,
	}
	register_badge "demonic6" {
		name  = "Demonic Angelic Badge",
		desc  = "Win @<standard@> N!/100% damageless",
		level = 6,
	}

	register_badge "technician1" {
		name  = "Technician Bronze Badge",
		desc  = "Discover an assembly",
		level = 1,
	}
	register_badge "technician2" {
		name  = "Technician Silver Badge",
		desc  = "Discover an advanced assembly",
		level = 2,
	}
	register_badge "technician3" {
		name  = "Technician Gold Badge",
		desc  = "Discover @<all@> basic assemblies",
		level = 3,
	}
	register_badge "technician4" {
		name  = "Technician Platinum Badge",
		desc  = "Discover @<all@> advanced assemblies",
		level = 4,
	}
	register_badge "technician5" {
		name  = "Technician Diamond Badge",
		desc  = "Discover @<all@> assemblies",
		level = 5,
	}

	register_badge "armorer1" {
		name  = "Armorer Bronze Badge",
		desc  = "Discover 10 exotics/uniques",
		level = 1,
	}
	register_badge "armorer2" {
		name  = "Armorer Silver Badge",
		desc  = "Discover 30 exotics/uniques",
		level = 2,
	}
	register_badge "armorer3" {
		name  = "Armorer Gold Badge",
		desc  = "Discover @<all@> exotics/uniques",
		level = 3,
	}
	register_badge "armorer4" {
		name  = "Armorer Platinum Badge",
		desc  = "Find @<1,000@> exotics/uniques",
		level = 4,
	}
	register_badge "armorer5" {
		name  = "Armorer Diamond Badge",
		desc  = "Find 3 of @<each@> exotic/unique",
		level = 5,
	}

	register_badge "heroic1" {
		name  = "Heroic Bronze Badge",
		desc  = "Receive 8 unique medals",
		level = 1,
	}
	register_badge "heroic2" {
		name  = "Heroic Silver Badge",
		desc  = "Receive 16 unique medals",
		level = 2,
	}
	register_badge "heroic3" {
		name  = "Heroic Gold Badge",
		desc  = "Receive 24 unique medals",
		level = 3,
	}
	register_badge "heroic4" {
		name  = "Heroic Platinum Badge",
		desc  = "Receive 32 unique medals",
		level = 4,
	}
	register_badge "heroic5" {
		name  = "Heroic Diamond Badge",
		desc  = "Receive @<all@> medals",
		level = 5,
	}

end

function DoomRL.check_badges()
	-- UAC, veteran, strongman and elite badges
	if player:has_won() then
		local is_conqueror = (statistics.bonus_levels_completed == statistics.bonus_levels_count)
		local is_explorer  = (statistics.bonus_levels_visited   == statistics.bonus_levels_count)
		local is_maxkills  = (statistics.kills == statistics.max_kills)
		local is_90kills   = (statistics.kills >= statistics.max_kills * 0.9)
		local is_zerodmg   = (statistics.damage_taken == 0)
		local is_fullwin   = (kills.get("jc") > 0 and player.hp > 0)

		-- veteran badges
		if is_maxkills then
			player:add_badge( "veteran1" )
			if DIFFICULTY >= DIFF_HARD      then player:add_badge("veteran2") end
			if DIFFICULTY >= DIFF_VERYHARD  then player:add_badge("veteran3") end
		end
		if is_fullwin then
			if DIFFICULTY >= DIFF_VERYHARD  then player:add_badge("veteran4") end
			if DIFFICULTY >= DIFF_NIGHTMARE then 
				player:add_badge("veteran5") 
				if is_maxkills then
					player:add_badge("veteran6") 
				end
			end
		end

		if CHALLENGE == "" then
			-- basic UAC badges
			player:add_badge( "buac1" )
			if DIFFICULTY >= DIFF_HARD      then player:add_badge("buac2") end
			if DIFFICULTY >= DIFF_VERYHARD  then player:add_badge("buac3") end
			if DIFFICULTY >= DIFF_NIGHTMARE then
				player:add_badge("buac4")
				if statistics.real_time <= 20*60 then player:add_badge("buac5") end
				if is_zerodmg                    then player:add_badge("buac6") end
			end

			-- strongman badges
			if kills.get_type( "other" ) + kills.get_type( "melee" ) + kills.get_type( "wolf_knife" ) + kills.get_type( "wolf_knife" ) == statistics.kills then player:add_badge("strongman1") end
			if kills.get_type( "other" ) + kills.get_type( "melee" ) + kills.get_type( "wolf_knife" ) == statistics.kills then
				player:add_badge("strongman2")
				if DIFFICULTY >= DIFF_HARD then player:add_badge("strongman3") end
			end
			if kills.get_type( "other" ) + kills.get_type( "melee" ) == statistics.kills and DIFFICULTY >= DIFF_HARD then
				player:add_badge("strongman4")
				if is_maxkills then player:add_badge("strongman5") end
				if DIFFICULTY >= DIFF_NIGHTMARE and is_90kills then
					player:add_badge("strongman6")
				end
			end
			
			-- speedrunner badges
			if statistics.real_time <= 30*60 then
				player:add_badge("speedrunner1")
			end
			if statistics.real_time <= 25*60 and DIFFICULTY >= DIFF_MEDIUM then
				player:add_badge("speedrunner2")
			end
			if statistics.real_time <= 20*60 and DIFFICULTY >= DIFF_HARD then
				player:add_badge("speedrunner3")
			end
			if statistics.real_time <= 4*60 and DIFFICULTY >= DIFF_NIGHTMARE then
				player:add_badge("speedrunner6")
			end

			-- elite badges
			if DIFFICULTY >= DIFF_VERYHARD  and is_conqueror then player:add_badge("elite4") end
			if DIFFICULTY >= DIFF_NIGHTMARE then
				if is_90kills then player:add_badge("elite5") end
				if is_maxkills and is_conqueror then player:add_badge("elite6") end
			end

			-- demonic badges
			if DIFFICULTY >= DIFF_NIGHTMARE then
				if is_explorer                   then player:add_badge("demonic4") end
				if statistics.damage_taken < 200 then player:add_badge("demonic5") end
				if is_zerodmg and is_maxkills    then player:add_badge("demonic6") end
			end
		end
	end
end
function DoomRL.award_medals()
	-- check badges
	DoomRL.check_badges()

	-- Prefetch win condition
	local win = player:has_won()

	-- Iterate through the medals
	for _,medal_proto in ipairs(medals) do
		if medal_proto.condition and ( ( not medal_proto.winonly ) or win ) then
			if medal_proto.condition() then
				player:add_medal( medal_proto.id )
				--if the player already has lesser medals in their player.wad, remove them from mortem
				if medal_proto.removes then
					for _,zero_medal in ipairs(medal_proto.removes) do
						local medal_count = player_data.get_counted( 'medals', 'medal', zero_medal )
						if medal_count <= 0 then
							player:add_medal( zero_medal )
						else
							player:remove_medal( zero_medal )
						end
					end
				end
			end
		end
	end

	-- Check for challenge medal removals
	if CHALLENGE ~= "" then
		player:remove_medals( chal[CHALLENGE].removemedals )
	end
	if SCHALLENGE ~= "" then
		player:remove_medals( chal[SCHALLENGE].removemedals )
	end
end

function DoomRL.award_global_badges()
	local medals_max = medals.__counter
	local medals     = player_data.child_count('player/medals')

	--Todo: adjust once I know how many medals I'm keeping
	if medals >= 8          then player:add_badge("heroic1") end
	if medals >= 16         then player:add_badge("heroic2") end
	if medals >= 24         then player:add_badge("heroic3") end
	if medals >= 32         then player:add_badge("heroic4") end
	if medals >= medals_max then player:add_badge("heroic5") end

	local uniques_max    = 0
	local uniques_triple = 0
	local uniques        = player_data.child_count('player/uniques')

	for _,v in ipairs(items) do
		if v.is_unique or v.is_exotic then
			uniques_max = uniques_max + 1
			uniques_triple = uniques_triple + math.min( 3, player_data.count('player/uniques/unique[@id="'..v.id..'"]') )
		end
	end

	--Todo: adjust once I know how many exotics/uniques I'm keeping (possibly just ditch)
	if uniques >= 10                               then player:add_badge("armorer1") end
	if uniques >= 30                               then player:add_badge("armorer2") end
	if uniques >= uniques_max                      then player:add_badge("armorer3") end
	if player_data.count('player/uniques') >= 1000 then player:add_badge("armorer4") end
	if uniques_triple >= uniques_max * 3           then player:add_badge("armorer5") end

	local amb_found  = { 0, 0, 0 }
 	local amb_max    = { 0, 0, 0 }

	for _,v in ipairs(mod_arrays) do
		amb_max[v.level+1] = amb_max[v.level+1] + 1
		if player_data.count('player/assemblies/assembly[@id="'..v.id..'"]') > 0 then
			amb_found[v.level+1] = amb_found[v.level+1] + 1
		end
	end

	local amb_total     = amb_found[1] + amb_found[2] + amb_found[3]
	local amb_total_max = amb_max[1]   + amb_max[2]   + amb_max[3]

	--Todo: adjust once I know how many assemblies I'm keeping
	if amb_total > 0                 then player:add_badge("technician1") end
	if amb_found[2]+amb_found[3] > 0 then player:add_badge("technician2") end
	if amb_found[1] >= amb_max[1]    then player:add_badge("technician3") end
	if amb_found[2] >= amb_max[2]    then player:add_badge("technician4") end
	if amb_total >= amb_total_max    then player:add_badge("technician5") end
end

function DoomRL.register_awards( no_record )

	for k,v in ipairs( awards ) do
		if player:has_award( v.id ) then
			player_data.add_counted( 'awards', 'award', v.id.."_"..tostring(player:get_award( v.id )))
		end
	end

	if no_record then return end

	for k,v in ipairs( items ) do
		if ( v.is_exotic or v.is_unique ) and player:has_found_item( v.id ) then
			player_data.add_counted( 'uniques', 'unique', v.id )
		end
	end

	for k,v in ipairs( mod_arrays ) do
		if player:has_assembly(v.id) then
			player_data.add_counted( 'assemblies', 'assembly', v.id, player:has_assembly(v.id) )
		end
	end

	for k,v in ipairs( medals ) do
		if player:has_medal( v.id ) then
			player_data.add_counted( 'medals', 'medal', v.id )
		end
	end

	DoomRL.award_global_badges()

	for k,v in ipairs( badges ) do
		if player:has_badge( v.id ) then
			if player_data.get_counted( 'badges', 'badge', v.id ) > 0 then
				player:remove_badge( v.id )
			end
			player_data.add_counted( 'badges', 'badge', v.id )
		end
	end

end
