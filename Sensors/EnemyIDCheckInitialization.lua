local sensorInfo = {
	name = "EnemyIDCheckInitialization",
	desc = "initialize the checklist of enemies IDs",
	author = "KeGao",
	date = "2021-06-16",
	license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = 0 -- acutal, no caching

function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT 
	}
end


function Initilization()
	--local units = Spring.GetSelectedUnits()peeperIndex
	local enemyIDCheck = {}
	local xGrid = math.ceil(Game.mapSizeX / 50)
	local zGrid = math.ceil(Game.mapSizeZ / 50)
	
	for i = 1, xGrid do
		enemyIDCheck[i] = {}
		for j = 1, zGrid do
			enemyIDCheck[i][j] = {}
		end
	end
	return enemyIDCheck
end

-- @description return commander position
return function()	
	return Initilization()
end