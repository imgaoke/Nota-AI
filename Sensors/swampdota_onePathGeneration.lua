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


function onePathGeneration(transporterID, lane, battleFrontIndex)
	
	local unitX, unitY, unitZ = Spring.GetUnitPosition(transporterID)
	local points = lane.points

	local nearestPointIndex = nil
	local nearestDistance = math.huge
	for index, point in pairs(points) do
		if math.sqrt((unitX - point.x) * (unitX - point.x) + (unitZ - point.z) * (unitZ - point.z)) < nearestDistance then
			nearestPointIndex = index
		end
	end

	
	local one = {}

	if battleFrontIndex > nearestPointIndex then
		for i = nearestPointIndex, battleFrontIndex do
			table.insert(one, {points[i].x, points[i].z})
		end
	else
		for i = nearestPointIndex, battleFrontIndex, -1 do
			table.insert(one, {points[i].x, points[i].z})
		end
	end

	
	if one == {} then
		Spring.Echo("here01")
	end
		
	return one
end

-- @description return commander position
return function(transporterID, lane, battleFrontIndex)
		
	local one = onePathGeneration(transporterID, lane, battleFrontIndex)
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