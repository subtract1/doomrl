function DoomRL.loadaffects()

	register_affect "berserk" {
		name           = "brk",
		color          = LIGHTRED,
		color_expire   = RED,
		message_init   = "You feel like a killing machine!",
		message_ending = "You feel your anger slowly wearing off...",
		message_done   = "You feel more calm.",
		status_effect  = STATUSRED,
		status_strength= 7,

		OnAdd          = function(being)
			being.flags[ BF_BERSERK ] = true
			being.speed = being.speed + 50
			being.resist.bullet = (being.resist.bullet or 0) + 60
			being.resist.melee = (being.resist.melee or 0) + 60
			being.resist.shrapnel = (being.resist.shrapnel or 0) + 60
			being.resist.acid = (being.resist.acid or 0) + 60
			being.resist.fire = (being.resist.fire or 0) + 60
			being.resist.plasma = (being.resist.plasma or 0) + 60
		end,
		OnTick         = function(being)
			ui.msg("You need to taste blood!")
		end,
		OnRemove       = function(being)
			being.flags[ BF_BERSERK ] = false
			being.speed = being.speed - 50
			being.resist.bullet = (being.resist.bullet or 0) - 60
			being.resist.melee = (being.resist.melee or 0) - 60
			being.resist.shrapnel = (being.resist.shrapnel or 0) - 60
			being.resist.acid = (being.resist.acid or 0) - 60
			being.resist.fire = (being.resist.fire or 0) - 60
			being.resist.plasma = (being.resist.plasma or 0) - 60
		end,
	}
	register_affect "inv" {
		name           = "inv",
		color          = WHITE,
		color_expire   = DARKGRAY,
		message_init   = "You feel invincible!",
		message_ending = "You feel your invincibility fading...",
		message_done   = "You feel vulnerable again.",
		status_effect  = STATUSINVERT,
		status_strength= 10,

		OnAdd          = function(being)
			being.flags[ BF_INV ] = true
		end,
		OnTick         = function(being)
			if being.hp < being.hpmax and not being.flags[ BF_NOHEAL ] then
				being.hp = being.hpmax
			end
		end,
		OnRemove       = function(being)
			being.flags[ BF_INV ] = false
		end,
	}
	register_affect "enviro" {
		name           = "env",
		color          = LIGHTGREEN,
		color_expire   = GREEN,
		message_init   = "You feel protected!",
		message_ending = "You feel your protection fading...",
		message_done   = "You feel less protected.",
		status_effect  = STATUSGREEN,
		status_strength= 1,

		OnAdd          = function(being)
			being.resist.acid = (being.resist.acid or 0) + 25
			being.resist.fire = (being.resist.fire or 0) + 25
		end,

		OnRemove       = function(being)
			being.resist.acid = (being.resist.acid or 0) - 25
			being.resist.fire = (being.resist.fire or 0) - 25
		end,
	}
	register_affect "light" {
		name           = "lit",
		color          = YELLOW,
		color_expire   = BROWN,
		message_init   = "You see further!",
		message_ending = "You feel your enhanced vision fading...",
		message_done   = "Your vision fades.",

		OnAdd          = function(being)
			being.vision = being.vision + 4
		end,

		OnRemove       = function(being)
			being.vision = being.vision - 4
		end,
	}

	register_affect "power" {
		name           = "pow",
		color          = LIGHTMAGENTA,
		color_expire   = MAGENTA,
		message_init   = "Death guides you.",
		message_ending = "",
		message_done   = "",
		status_effect  = STATUSMAGENTA,
		status_strength= 8,

		OnAdd          = function(being)
			being.todamall = being.todamall + 20
		end,
		OnRemove       = function(being)
			being.todamall = being.todamall - 20
		end,
	}
	register_affect "shield" {
		name           = "shd",
		color          = LIGHTBLUE,
		color_expire   = BLUE,
		message_init   = "Fate shields you.",
		message_ending = "",
		message_done   = "",
		status_effect  = STATUSCYAN,
		status_strength= 6,

		--Consider adding the 'don't take damage from scratches' flag.
		OnAdd          = function(being)
			being.armor = being.armor + 20
		end,
		OnRemove       = function(being)
			being.armor = being.armor - 20
		end,
	}
	register_affect "mire" {
		name           = "spd",
		color          = YELLOW,
		color_expire   = YELLOW,
		message_init   = "Time saves you.",
		message_ending = "",
		message_done   = "",
		status_effect  = STATUSGRAY,
		status_strength= 9,

		--[[
		  Mire is tricky as we are definitely abusing the engine in ways that
		  were not originally anticipated.  OnTick runs whenever the player is
		  about to perform an action.  About to--not already done or decided,
		  so under normal circumstances being.scount will always equal 5000 when
		  OnTick is called.  If we cheat and create a scenario where that doesn't
		  happen (infinite being.scount, whatever) the OnTick hook won't be called.
		  Insetad the being/player will loop around performing actions until scount
		  dips below 5000 again.

		  Which is one way to make a time freezing powerup, albeit one where a fast
		  player could get in a LOT of free actions whereas a slow player might only
		  get a few.  Conversely we could go the opposite route--change the player
		  action speeds directly and restore them when the powerup ends.  This is a
		  MAJOR hassle when you start factoring in traits that must be restored as well
		  but it is also fair--everyone gets the exact same boon regardless of build.
		
		  A third but ultimately not possible option is to give everyone X numbers of
		  free actions, whatever those actions may be.  That would only be doable if
		  OnTick fired every action instead of just at the 5000 threshold, but I can't
		  complain too much when abusing the engine...
		--]]
		OnAdd          = function(being)
			being.scount = math.min(being.scount + 15000, 60000) --Roughly 15 free moves
		end,
		OnTick         = function(being)
			--Winding down time (mostly used because you still have the
			--powerup for a little bit after you go back down to 5000)
			being.scount = being.scount + 1000
		end,
	}

	register_affect "drugs" {
		name           = "œ“œ",
		color          = YELLOW,
		color_expire   = BROWN,
		message_init   = "Whoa!",
		message_ending = "",
		message_done   = "",
		status_effect  = STATUSYELLOW,
		status_strength= 2,

		OnAdd          = function(being)
			being:add_property( "wolf_drugadjust", { hpmax = 0, vision = 0, tohit = 0, } )
		end,
		OnTick         = function(being)
			--Nifty color effects!  And it only cost us 3 extra affect slots...
			local random_color = math.random(4)
			if     random_color == 1 then being:set_affect("drugs_a",2) being:remove_affect("drugs_b")
			elseif random_color == 2 then being:set_affect("drugs_b",2) being:remove_affect("drugs_a")
			else being:remove_affect("drugs_a") being:remove_affect("drugs_b")
			end

			local hpmax_middle  = being.hpnom + (player:get_trait( traits["ironman"].nid ) * math.floor(0.2 * being.hpnom))
			local vision_middle = 8 + beings[being.id].vision + (player:get_trait( traits["cateye"].nid ) * 2) --VisionBaseValue==8 but that constant is not exposed to the modding engine
			local tohit_middle  = 0 + (player:get_trait( traits["eagle"].nid ) * 2)
			local min_hpmax  = math.max( being.hp / 2, math.floor(hpmax_middle/5) )
			local min_vision = vision_middle - 3
			local min_tohit  = tohit_middle - 2
			local max_hpmax  = math.floor( hpmax_middle*2 )
			local max_vision = vision_middle + 3
			local max_tohit  = tohit_middle + 2

			local hpmax_adj  = math.random(-1*being.hpnom, 1*being.hpnom)
			local vision_adj = math.random(-2, 2)
			local tohit_adj  = math.random(-1, 1)

			if     ( being.hpmax + hpmax_adj < min_hpmax ) then hpmax_adj = being.hpmax - min_hpmax
			elseif ( being.hpmax + hpmax_adj > max_hpmax ) then hpmax_adj = max_hpmax - being.hpmax
			end
			if     ( being.vision + vision_adj < min_vision ) then vision_adj = being.vision - min_vision
			elseif ( being.vision + vision_adj > max_vision ) then vision_adj = max_vision - being.vision
			end
			if     ( being.tohit + tohit_adj < min_tohit ) then tohit_adj = being.tohit - min_tohit
			elseif ( being.tohit + tohit_adj > max_tohit ) then tohit_adj = max_tohit - being.tohit
			end

			being.hpmax  = being.hpmax  + hpmax_adj
			being.vision = being.vision + vision_adj
			being.tohit  = being.tohit  + tohit_adj
			being.wolf_drugadjust.hpmax  = being.wolf_drugadjust.hpmax  + hpmax_adj
			being.wolf_drugadjust.vision = being.wolf_drugadjust.vision + vision_adj
			being.wolf_drugadjust.tohit  = being.wolf_drugadjust.tohit  + tohit_adj
		end,
		OnRemove       = function(being)
			being.hpmax  = being.hpmax  - being.wolf_drugadjust.hpmax
			being.vision = being.vision - being.wolf_drugadjust.vision
			being.tohit  = being.tohit  - being.wolf_drugadjust.tohit

			being:remove_property( "wolf_drugadjust" )
		end,
	}
	register_affect "drugs_a" {
		name           = "",
		color          = BLACK,
		color_expire   = BLACK,
		message_init   = "",
		message_ending = "",
		message_done   = "",
		status_effect  = STATUSRED,
		status_strength= 3,
	}
	register_affect "drugs_b" {
		name           = "",
		color          = BLACK,
		color_expire   = BLACK,
		message_init   = "",
		message_ending = "",
		message_done   = "",
		status_effect  = STATUSBLUE,
		status_strength= 3,
	}

	register_affect "poison" {
		name           = "psn",
		color          = LIGHTGREEN,
		color_expire   = GREEN,
		message_init   = "You are poisoned!",
		message_ending = "",
		message_done   = "",
		status_effect  = STATUSGREEN,
		status_strength= 2,

		OnAdd          = function(being)
			--This WAS used to run a timer, but once per move works best and needs no timer
			--being:add_property( "wolf_poison", 10 )
		end,
		OnTick         = function(being)
			--being.wolf_poison = being.wolf_poison - 1
			--if (being.wolf_poison % 10 == 0) then
				--Take poison damage once a second
				being:msg("Poison courses through your veins!", being:get_name(true,false).." looks weaker!")
				being:apply_damage( 1, TARGET_INTERNAL, DAMAGE_ACID ) --To consider: for the NON-lethal decrements should we manipulate HP directly so as to cut down on pain noises?
				--being.wolf_poison = 10
			--end
		end,
		OnRemove       = function(being)
			--being:remove_property( "wolf_poison" )
		end,
	}

end
