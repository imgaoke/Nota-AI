local sensorInfo = {
	name = "peewees",
	desc = "Return ids of peewees in the selection",
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

function GetPeewees()
	--local units = Spring.GetSelectedUnits()
	peewees = {}
	for index, id in ipairs(units) do
		local unitDefID = Spring.GetUnitDefID(id)
		if UnitDefs[unitDefID].name == "armpw" then
			table.insert(peewees, id) 
		end
	end
	return peewees
end

-- @description return commander position
return function()	
	return GetPeewees()
end