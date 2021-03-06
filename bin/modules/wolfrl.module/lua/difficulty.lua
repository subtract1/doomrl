function DoomRL.load_difficulty()
	register_difficulty	"CIP" {
		name        = "Can I play, Daddy?",
		description = "He should have been better supervised.",
		code        = "@GE",
		tohitbonus  = -1,
		expfactor   = 1.4,
		scorefactor = 0.5,
		ammofactor  = 2,
		powerfactor = 2,
		powerbonus  = 1.5,
		respawn     = false,
		speed       = 1,
	}
	register_difficulty "DHM" {
		name        = "Don't hurt me.",
		description = "He didn't want to get hurt.",
		code        = "@BM",
		tohitbonus  = 0,
		expfactor   = 1.2,
		scorefactor = 1,
		ammofactor  = 1,
		powerfactor = 1,
		powerbonus  = 1.5,
		respawn     = false,
		speed       = 1,
	}
	register_difficulty "BMO" {
		name        = "Bring 'em on!",
		description = "He encouraged the enemy to do their best.",
		code        = "@yH",
		tohitbonus  = 1,
		expfactor   = 1,
		scorefactor = 2,
		ammofactor  = 1,
		powerfactor = 1,
		powerbonus  = 1.5,
		respawn     = false,
		speed       = 1,
	}
	register_difficulty "DI" {
		name        = "I am Death Incarnate!",
		description = "He hated all living things.",
		code        = "@rU",
		tohitbonus  = 2,
		expfactor   = 1,
		scorefactor = 4,
		ammofactor  = 2,
		powerfactor = 2,
		powerbonus  = 1.25,
		respawn     = true,
		req_skill   = 3,
		speed       = 1.5,
	}
end