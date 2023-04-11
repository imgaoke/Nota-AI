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

function formation(numberOfUnits)
	dimention = math.ceil(math.sqrt(numberOfUnits))
	rest = numberOfUnits % dimention
	numberOfLoops = math.floor(numberOfUnits / dimention)
	returnedFormation = {}
	for i = 1, numberOfLoops do
		for j = 1, dimention do
			table.insert(returnedFormation, Vec3((i - 1) * 10, 0, (j - 1) * 10))
		end
	end
	
	for i = 1, rest do
		table.insert(returnedFormation, Vec3(numberOfLoops * 10, 0, (i - 1) * 10))
	end
	
	return returnedFormation
end

-- @description return commander position
return function(numberOfUnits)	
	return formation(numberOfUnits)
end