local sensorInfo = {
	name = "GiveMeFreeFarck",
	desc = "give a free farck",
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
	for unitID, reservationState in pairs(reservationSystemMemory.farcks) do
		if (reservationState == "free") and Spring.ValidUnitID(unitID) then
			unitSelectedID = unitID
			reservationSystemMemory.farcks[unitSelectedID] = "occupied"
			break
		end
	end
	
	
	return unitSelectedID
end