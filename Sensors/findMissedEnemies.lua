local sensorInfo = {
	name = "",
	desc = "find enemies that are not found by the peeoers",
	author = "KeGao",
	date = "2022-05-31",
	license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = 0 -- acutal, no caching

function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT 
	}
end


function GetMissedEnemies(tableOfEnemies)
	missedEnemies = {}
		


	
	
	return missedEnemies
end

return function(tableOfEnemies)	
	return GetMissedEnemies(tableOfEnemies)
end