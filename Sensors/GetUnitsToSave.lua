local sensorInfo = {
	name = "unitsToSave",
	desc = "Return ids of unitsToSave in the map",
	author = "KeGao",
	date = "2022-06-01",
	license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = 0 -- acutal, no caching

function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT 
	}
end

function GetUnitsToSave()
	--local units = Spring.GetSelectedUnits()
	local units = Spring.GetUnitsInRectangle(0, 0, Game.mapSizeX, Game.mapSizeZ, Spring.GetMyTeamID())
	local unitsToSave = {}
	for index, id in ipairs(units) do
		local unitDefID = Spring.GetUnitDefID(id)
		if UnitDefs[unitDefID].name ~= "armwin" and UnitDefs[unitDefID].name ~= "armrad" and UnitDefs[unitDefID].name ~= "armatlas" and UnitDefs[unitDefID].name ~= "armpeep"  then
			 table.insert(unitsToSave, id)
		end
	end
	return unitsToSave
end

-- @description return commander position
return function()	
	return GetUnitsToSave()
end