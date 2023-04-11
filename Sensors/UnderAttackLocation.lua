local sensorInfo = {
	name = "UnderAttackLocation",
	desc = "Return the location where the unit is first attacked",
	author = "KeGao",
	date = "2021-05-28",
	license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = 0 -- acutal, no caching

function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT 
	}
end

-- @description return current wind statistics
return function(unitID)
	local x, y, z = Spring.GetUnitPosition(unitID)
	return {
		x = x,
		y = y,
		z = z
	}
end