local sensorInfo = {
	name = "formation",
	desc = "Return the formation given number of units",
	author = "KeGao",
	date = "2021-05-16",
	license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = 0 -- acutal, no caching

function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT 
	}
end

function formation(unitsToBeFormed)
	Spring.Echo("number of units: ".. #unitsToBeFormed)
	local interval = Game.mapSizeX / (#unitsToBeFormed - 1)
	returnedFormation = {}
	for i = 1, #unitsToBeFormed do
		table.insert(returnedFormation, Vec3((i - 1) * interval, 0, 0))
	end
		
	return returnedFormation
end

-- @description return commander position
return function(unitsToBeFormed)	
	return formation(unitsToBeFormed)
end