local sensorInfo = {
	name = "swamptdota_battlelineInOneLane",
	desc = "get the battle front in the current lane",
	author = "KeGao",
	date = "2022-06-08",
	license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = 0 -- acutal, no caching

function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT 
	}
end

function GetBattleFrontsInOneLane(lane)
	local teamID = Spring.GetMyTeamID()
	local allyID = Spring.GetMyAllyTeamID()
	local areaOfEachPoint = 500
	local currentFrontNormalPoint = nil
	local points = lane.points
	local pointIndexBeforeFrontNormalPoint = nil
	for indexi, point in ipairs(points) do
		local currentUnits = Spring.GetUnitsInCylinder(point.position.x, point.position.z, areaOfEachPoint)
		local count = 0
		for indexj, unitID in pairs(currentUnits) do
			if Spring.GetUnitAllyTeam(unitID) == allyID then
				count = count + 1
			end
		end
		if count >= 5 then
			currentFrontNormalPoint = point
			pointIndexBeforeFrontNormalPoint = indexi - 1
		end
	end
	local frontNormalPoint = currentFrontNormalPoint

	local frontStrongPoint = nil
	local pointIndexBeforefrontStrongPoint = nil
	for indexi, point in ipairs(points) do
		if point.isStrongpoint == true and point.ownerAllyID == allyID then
			frontStrongPoint = point
			pointIndexBeforefrontStrongPoint = indexi - 1
		end
	end

	local battleFrontIndex = nil
	if pointIndexBeforeFrontNormalPoint > pointIndexBeforefrontStrongPoint then
		if frontNormalPoint ~= nil then
			battleFrontIndex = pointIndexBeforeFrontNormalPoint
		end
		
	else
		if frontStrongPoint ~= nil then
			battleFrontIndex = pointIndexBeforefrontStrongPoint
		end
	end


	return battleFrontIndex
end

return function(lane)	
	return GetBattleFrontsInOneLane(lane)
end