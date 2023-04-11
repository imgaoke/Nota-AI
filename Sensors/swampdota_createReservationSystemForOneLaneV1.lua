local sensorInfo = {
	name = "CreateReservationSystem",
	desc = "Makes a reservation system.",
	author = "Ke Gao",
	date = "2022-06-13",
	license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = -1 -- no caching 

function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT
	}
end

return function(lane, currentFarcksInTheLane, currentMetalsInTheLane)
	local reservationSystem = {
		--only the first 3 is considered now
		armbox = {},
		armatlas = {},
		armseer = {},

		armmav = {},
		armmart = {},
		cmercdrag = {},
		armspy = {},
		armzeus = {}
	}
	
	return reservationSystem
end