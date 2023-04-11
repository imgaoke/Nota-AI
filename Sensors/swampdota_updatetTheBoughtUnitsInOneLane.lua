local sensorInfo = {
	name = "updatetTheBoughtUnitsInOneLane",
	desc = "get the newly bought units into the reservation system",
	author = "KeGao",
	date = "2022-06-14",
	license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = 0 -- acutal, no caching

function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT 
	}
end


function updatetTheBoughtUnitsInOneLane(reservationSystemMemory)
	
	local teamID = Spring.GetMyTeamID()
	local newUnits = Spring.GetUnitsInCylinder(1400, 8900, 1000, teamID)

	for index, unitID in ipairs(newUnits) do
		local unitType = UnitDefs[Spring.GetUnitDefID(unitID)].name
		if reservationSystemMemory[unitType][unitID] == nil then
			reservationSystemMemory[unitType][unitID] = "free"
		end
	end
end

return function(reservationSystemMemory)	
	return updatetTheBoughtUnitsInOneLane(reservationSystemMemory)
end