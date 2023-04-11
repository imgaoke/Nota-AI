local sensorInfo = {
	name = "debug",
	desc = "get function values",
	author = "KeGao",
	date = "2021-05-23",
	license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = 0 -- acutal, no caching

function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT 
	}
end

function Debug(ID)
	return Spring.GetCommandQueue(ID, 0)
	
end

-- @description return commander position
return function(ID)	
	return Debug(ID)
end