local sensorInfo = {
	name = "commanders",
	desc = "Return ids of commanders in the selection",
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

function GetCommanders()
	--local units = Spring.GetSelectedUnits()
	commanders = {}
	count = 0
	for index, id in ipairs(units) do
		local unitDefID = Spring.GetUnitDefID(id)
		if UnitDefs[unitDefID].name == "armbcom" then
			count = count + 1
			commanders[id] = count
		end
	end
	return commanders
end

-- @description return commander position
return function()	
	return GetCommanders()
end