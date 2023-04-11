local sensorInfo = {
	name = "peepers",
	desc = "Return ids of peepers in the selection",
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

function GetPeepers(allUnits)
	--local units = Spring.GetSelectedUnits()
	peepers = {}
	count = 0
	for index, id in ipairs(allUnits) do
		local unitDefID = Spring.GetUnitDefID(id)
		if UnitDefs[unitDefID].name == "armpeep" then
			count = count + 1
			peepers[id] = count
		end
	end
	return peepers
end

-- @description return commander position
return function(allUnits)	
	return GetPeepers(allUnits)
end