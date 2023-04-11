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


function onePathGeneration(allPaths, unitToBeRescuedID)
	
	local unitX, unitY, unitZ = Spring.GetUnitPosition(unitToBeRescuedID)
	local unitXGrid = math.ceil(unitX / 50)
	local unitZGrid = math.ceil(unitZ / 50)
		
	local one = {}
	
	local currentXGrid = unitXGrid
	local currentZGrid = unitZGrid
	
	while true do
		if allPaths[currentXGrid][currentZGrid] ~= nil then
			currentXGrid, currentZGrid = allPaths[currentXGrid][currentZGrid][1], allPaths[currentXGrid][currentZGrid][2]
			table.insert(one, {currentXGrid, currentZGrid})
		else
			break
		end
	end
	
	if one == {} then
		Spring.Echo("here01")
	end
		
	return one
end

-- @description return commander position
return function(allPaths, unitToBeRescuedID)
		
	local one = onePathGeneration(allPaths, unitToBeRescuedID)
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