local sensorInfo = {
	name = "unitDefField",
	desc = "Return a field of UnitDefs",
	author = "KeGao",
	date = "2021-05-22",
	license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = 0 -- acutal, no caching

function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT 
	}
end

function GetUnitDefField()
	local units = Spring.GetSelectedUnits()
	--[[
	for index, id in ipairs(units) do
		local unitDefID = Spring.GetUnitDefID(id)
		if UnitDefs[unitDefID].name == "armatlas" then
			return UnitDefs[unitDefID].wantedHeight
		end
	end
	--]]
	
	local unitDefID = Spring.GetUnitDefID(units[1])
	return UnitDefs[unitDefID].name
	
end

-- @description return commander position
return function()	
	return GetUnitDefField()
end