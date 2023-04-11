local sensorInfo = {
	name = "GiveMeFreeTransporter",
	desc = "Makes a reservation system.",
	author = "PepeAmpere",
	date = "2021-06-08",
	license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = -1 -- no caching 

function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT
	}
end

-- @description return filtered list of units
-- @argument atlases [array of unitIDs]
-- @argument unitsToSave [array of unitIDs]

return function(reservationSystemMemory)
	local unitSelectedID
	for unitID, reservationState in pairs(reservationSystemMemory.unitsToSave) do
		if (reservationState == "notRescued") and Spring.ValidUnitID(unitID) then
			unitSelectedID = unitID
			reservationSystemMemory.unitsToSave[unitID] = "beingRescued"
		break
		end
	end
	
	return unitSelectedID
end