local sensorInfo = {
	name = "swamptdota_battleline",
	desc = "get all the battlelines of three lanes",
	author = "KeGao",
	date = "2022-06-07",
	license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = 0 -- acutal, no caching

function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT 
	}
end

function GetBattleFronts()
	local missionInformation = core.MissionInfo()
	local lanes = missionInformation.lanes
	local tableOfBattlelines = {}
	local teamID = Spring.GetMyTeamID()
	for indexi, lane in pairs(lanes) do
		local areaOfEachPoint = 500
		local currentMaxNumberOfUnits = 0
		local currentFrontNormalPoint = nil
		local points = lane.points
		for indexj, point in ipairs(lane) do
			local currentNumberOfUnits = Spring.GetUnitsInSphere(point.x, point.y, point.z, areaOfEachPoint, teamID)
			if currentNumberOfUnits > currentMaxNumberOfUnits then
				currentMaxNumberOfUnits = currentNumberOfUnits
				currentFrontNormalPoint = point
			end
		end
		--

		local strongPoints = lane.strongPoints
		local frontStrongPoint = nil
		local strongpointBeforefrontStrongPoint = nil
		for indexi, point in ipairs(strongPoints) do
			if point.owner ~= teamID then
				frontStrongPoint = point
				strongpointBeforefrontStrongPoint = strongPoints[indexi - 1]
				break
			end
		end

		local battleFront = nil
		if Spring.GetUnitsInSphere(frontStrongPoint.x, frontStrongPoint.y, frontStrongPoint.z, areaOfEachPoint, teamID) >= 5 then
			battleFront = frontStrongPoint
		else
			battleFront = currentFrontNormalPoint
		end

		tableOfBattlelines[indexi] = battleFront
	end

	return tableOfBattlelines
end

return function()	
	return GetBattleFronts()
end