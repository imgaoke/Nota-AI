local sensorInfo = {
	name = "updatetTheBoughtFarckInOneLane",
	desc = "move the newly bought farck to the table currentFarcksInTheLane",
	author = "KeGao",
	date = "2022-06-12",
	license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = 0 -- acutal, no caching

function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT 
	}
end


function updatetTheBoughtFarckInOneLane(lane, currentFarcksInTheLane, reservationSystemMemory)
	local teamID = Spring.GetMyTeamID()
	local newUnits = Spring.GetUnitsInCylinder(1400, 8900, 1000, teamID)
	local tableOfFarcks = {}
	local foundNewBoughtFarck = false

	for index, unitID in ipairs(newUnits) do
		local unitType = UnitDefs[Spring.GetUnitDefID(unitID)].name
		if Spring.ValidUnitID(unitID) == true and currentFarcksInTheLane[unitID] == nil and unitType == "armfark" then
			currentFarcksInTheLane[unitID] = "exist"
			foundNewBoughtFarck = true
			reservationSystemMemory.farcks[unitID] = "free"
		end
		if foundNewBoughtFarck == true then
			break
		end
	end
end

return function(lane, currentFarcksInTheLane, reservationSystemMemory)	
	return updatetTheBoughtFarckInOneLane(lane, currentFarcksInTheLane, reservationSystemMemory)
end