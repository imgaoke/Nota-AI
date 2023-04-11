local sensorInfo = {
	name = "mapInformationInitializaition",
	desc = "initialize the 2D map array",
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
	local mapInformation = {}
	local xGrid = math.ceil(Game.mapSizeX / 50)
	local zGrid = math.ceil(Game.mapSizeZ / 50)
	
	peewees = {}
	for i = 1, xGrid - 1 do
		mapInformation[i] = {}
		for k = 1, zGrid - 1 do
			mapInformation[i][k] = {}
			mapInformation[i][k]["groundHeight"] = Spring.GetGroundHeight(i * 50 - 25, k * 50 - 25)
		end
	end
	
	for i = 1, xGrid - 1 do
		mapInformation[i][zGrid] = {}
		mapInformation[i][zGrid]["groundHeight"] = Spring.GetGroundHeight(i * 50 - 25, (Game.mapSizeZ + (zGrid - 1) * 50) / 2 )
	end
	
	mapInformation[xGrid] = {}
	for k = 1, zGrid - 1 do
		mapInformation[xGrid][k] = {}
		mapInformation[xGrid][k]["groundHeight"] = Spring.GetGroundHeight((Game.mapSizeX + (xGrid - 1) * 50) / 2, k * 50 - 25 )
	end
	
	mapInformation[xGrid][zGrid] = {}
	mapInformation[xGrid][zGrid]["groundHeight"] = Spring.GetGroundHeight((Game.mapSizeX + (xGrid - 1) * 50) / 2, (Game.mapSizeZ + (zGrid - 1) * 50) / 2 )
	
	return mapInformation
end

-- @description return commander position
return function()	
	return Initilization()
end