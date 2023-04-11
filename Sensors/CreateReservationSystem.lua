local sensorInfo = {
	name = "CreateReservationSystem",
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
return function(atlases, unitsToSave)
	local reservationSystem = {
		atalases = {},
		unitsToSave = {}
	}
	
	for i = 1, #atlases do
		local atlasUnitId = atlases[i]
		reservationSystem.atalases[atlasUnitId] = "free"
	end
	
	for i = 1, #unitsToSave do
		local unitID = unitsToSave[i]
		reservationSystem.unitsToSave[unitID] = "notRescued"
	end
	
	return reservationSystem
end