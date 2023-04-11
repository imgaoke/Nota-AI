local sensorInfo = {
	name = "updatetTheBoughtFarckInOneLane",
	desc = "move the newly bought farck to the table currentFarcksInTheLane",
	author = "KeGao",
	date = "2022-06-012",
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
	local points = lane.points
	local areaOfEachPoint = 500
	local points = lane.points
	local tableOfFarcks = {}
	local foundNewBoughtFarck = false
	for indexi, point in ipairs(points) do
		local currentUnits = Spring.GetUnitsInCylinder(point.position.x, point.position.z, areaOfEachPoint, teamID)
		for indexj, unitID in ipairs(currentUnits) do
			if Spring.ValidUnitID(unitID) == true and currentFarcksInTheLane[unitID] == nil then
				currentFarcksInTheLane[unitID] = "exist"
				foundNewBoughtFarck = true
				reservationSystemMemory.farcks[unitID] = "free"
				break
			end
			if foundNewBoughtFarck == true then
				break
			end
		end
	end
end

return function(lane, currentFarcksInTheLane, reservationSystemMemory)	
	return updatetTheBoughtFarckInOneLane(lane, currentFarcksInTheLane, reservationSystemMemory)
end