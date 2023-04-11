local sensorInfo = {
	name = "CreateReservationSystem",
	desc = "Makes a reservation system.",
	author = "Ke Gao",
	date = "2022-06-08",
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
		farcks = {},
		metalsToCollect = {}
	}
	
	for farckUnitID, farckStatus in pairs(currentFarcksInTheLane) do
		reservationSystem.farcks[farckUnitID] = "free"
	end
	--[[
	for i = 1, #currentFarcksInTheLane do
		local farckUnitId = currentFarcksInTheLane[i]
		reservationSystem.farcks[farckUnitId] = "free"
	end]]
	
	for i = 1, #currentMetalsInTheLane do
		local featureID = currentMetalsInTheLane[i]
		reservationSystem.metalsToCollect[featureID] = "notCollected"
	end
	
	return reservationSystem
end