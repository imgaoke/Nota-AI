local sensorInfo = {
	name = "onePathGeneration",
	desc = "find the one path from the transporter to the unit to be rescued",
	author = "KeGao",
	date = "2021-07-17",
	license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = 0 -- acutal, no caching

function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT 
	}
end


function onePathGeneration(farckID, lane, metalID)
	
	local points = lane.points

	local unitX, unitY, unitZ = Spring.GetUnitPosition(farckID)
	local nearestPointIndexForFarck = nil
	local nearestDistanceForFarck = math.huge
	for index, point in pairs(points) do
		local currentDistanceForFarck = math.sqrt((unitX - point.position.x) * (unitX - point.position.x) + (unitZ - point.position.z) * (unitZ - point.position.z))
		if currentDistanceForFarck < nearestDistanceForFarck then
			nearestPointIndexForFarck = index
			nearestDistanceForFarck = currentDistanceForFarck
		end
	end

	local metalX, metalY, metalZ = Spring.GetFeaturePosition(metalID)
	local nearestPointIndexForMetal = nil
	local nearestDistanceForMetal = math.huge
	for index, point in pairs(points) do
		local currentDistanceForMetal = math.sqrt((metalX - point.position.x) * (metalX - point.position.x) + (metalZ - point.position.z) * (metalZ - point.position.z))
		
		local pointIsSafe = false
		local currentUnits = Spring.GetUnitsInCylinder(point.position.x, point.position.z, 500)
		local allyID = Spring.GetMyAllyTeamID()
		local count = 0
		for indexj, unitID in pairs(currentUnits) do
			if Spring.GetUnitAllyTeam(unitID) == allyID then
				count = count + 1
			end
		end
		if count >= 10 then
			pointIsSafe = true
		end

		if currentDistanceForMetal  < nearestDistanceForMetal and (pointIsSafe or (point.isStrongpoint and point.ownerAllyID == allyID)) then
			nearestPointIndexForMetal = index
			nearestDistanceForMetal = currentDistanceForMetal
		end
	end

	
	local one = {}

	Spring.Echo("nearestPointIndexForFarck: " .. nearestPointIndexForFarck)
	Spring.Echo("nearestPointIndexForMetal: " .. nearestPointIndexForMetal)

	if nearestPointIndexForFarck > nearestPointIndexForMetal then
		for i = nearestPointIndexForFarck, nearestPointIndexForMetal, -1 do
			table.insert(one, {points[i].position.x, points[i].position.z})
		end
	else
		for i = nearestPointIndexForFarck, nearestPointIndexForMetal do
			table.insert(one, {points[i].position.x, points[i].position.z})
		end
	end

	
	if one == {} then
		Spring.Echo("here01")
	end
		
	return one
end

-- @description return commander position
return function(farckID, lane, battleFrontIndex, metalID)
		
	local one = onePathGeneration(farckID, lane, battleFrontIndex, metalID)
	local count = 0
	
	for i = 1, #one do
		count = count + 1
		if (Script.LuaUI('exampleDebug_update')) then
				Script.LuaUI.exampleDebug_update(
					count, --count, --i * k, -- key
					{	-- data
						startPos = Vec3(one[i][1] * 50 - 30, 500 ,one[i][2] * 50 - 25), 
						endPos = Vec3(one[i][1] * 50 - 20, 500 ,one[i][2] * 50 - 25),
						r = 255/255,
						g = 255/255,
						b = 255/255
					}
				)
		end
	end
	
	return one
end