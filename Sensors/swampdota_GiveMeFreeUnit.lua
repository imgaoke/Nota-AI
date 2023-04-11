local sensorInfo = {
	name = "GiveMeFreeUnit",
	desc = "give a free unit",
	author = "Ke Gao",
	date = "2021-06-14",
	license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = -1 -- no caching 

function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT
	}
end

return function(unitType, reservationSystemMemory)
	local unitSelectedID
	for unitID, reservationState in pairs(reservationSystemMemory[unitType]) do
		if (reservationState == "free") and Spring.ValidUnitID(unitID) then
			unitSelectedID = unitID
			reservationSystemMemory[unitType][unitSelectedID] = "occupied"
			break
		end
	end
	
	
	return unitSelectedID
end