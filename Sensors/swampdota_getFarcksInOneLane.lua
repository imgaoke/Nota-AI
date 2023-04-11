local sensorInfo = {
	name = "getFarcksInOneLange",
	desc = "returns a table of farcks in the current lane",
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


function getFarcksInOneLange(lane)
	local teamID = Spring.GetMyTeamID()
	local points = lane.points
	local areaOfEachPoint = 500
	local currentMaxNumberOfUnits = 0
	local points = lane.points
	local tableOfFarcks = {}
	for indexi, point in ipairs(points) do
		local currentUnits = Spring.GetUnitsInCylinder(point.x, point.z, areaOfEachPoint, teamID)
		for indexj, unitID in ipairs(currentUnits) do
			local unitDefID = Spring.GetUnitDefID(unitID)
			if Spring.ValidUnitID(unitID) == true and UnitDefs[unitDefID].name == "armfark" and tableOfFarcks[unitID] == nil then
				--table.insert(tableOfFarcks, unitID)
				tableOfFarcks[unitID] = "exist"
			end

		end
	end

	return tableOfFarcks

end

return function(lane)	
	return getFarcksInOneLange(lane)
end