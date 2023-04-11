local sensorInfo = {
	name = "GiveMeFreeAndSafeMetalFeature",
	desc = "give a free and safe metal feature",
	author = "Ke Gao",
	date = "2021-06-13",
	license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = -1 -- no caching 

function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT
	}
end

return function(reservationSystemMemory)
	local unitSelectedID
	for unitID, reservationState in pairs(reservationSystemMemory.metalsToCollect) do
		if (reservationState == "notCollected") then
			unitSelectedID = unitID
			reservationSystemMemory.metalsToCollect[unitID] = "beingCollected"
			break
		end
	end
	
	--Spring.Echo(unitSelectedID == nil)
	return unitSelectedID
end