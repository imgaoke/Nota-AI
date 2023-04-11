local sensorInfo = {
	name = "windDirection",
	desc = "Return data of actual wind.",
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

-- speedups
local SpringGetWind = Spring.GetWind

-- @description return current wind statistics
return function()
	local dirX, dirY, dirZ, strength, normDirX, normDirY, normDirZ = SpringGetWind()
	return {
		dirX = dirX,
		dirY = dirY,
		dirZ = dirZ,
		strength = strength,
		normDirX = normDirX,
		normDirY = normDirY,
		normDirZ = normDirZ,
		heading = Spring.GetHeadingFromVector ( dirX, dirZ )
	}
end