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
	local currentMaxHealth = 0
	for unitID, reservationState in pairs(reservationSystemMemory.atalases) do
		if (reservationState == "free") and Spring.ValidUnitID(unitID) then
			local health, _, _, _, _ = Spring.GetUnitHealth (unitID)
			if health > currentMaxHealth then
				currentMaxHealth = health
				unitSelectedID = unitID
			end
		end
	end
	reservationSystemMemory.atalases[unitSelectedID] = "occupied"
	
	return unitSelectedID
end