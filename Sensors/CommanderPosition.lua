local sensorInfo = {
	name = "commanderPosition",
	desc = "Return position of the commander.",
	author = "KeGao",
	date = "2021-05-02",
	license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = 0 -- acutal, no caching

function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT 
	}
end

function getCommanderUnitID()
	--local units = Spring.GetSelectedUnits()
	local x, y, z
	for index, id in ipairs(units) do
		local unitDefID = Spring.GetUnitDefID(id)
		if UnitDefs[unitDefID].name == "armbcom" then
			return id
		end
	end
end

local id = getCommanderUnitID()

-- @description return commander position
return function()
	local x, y, z
	
	x, y, z = Spring.GetUnitBasePosition(id)
	
	return {
		x = x,
		y = y,
		z = z,
	}
end