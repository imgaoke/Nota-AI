local sensorInfo = {
	name = "danger map",
	desc = "mark on the map grid where it's dangerous",
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


function DangerMark(mapInformation)

	
	dangerMapMark = {}
	local xGrid = math.ceil(Game.mapSizeX / 50)
	local zGrid = math.ceil(Game.mapSizeZ / 50)
	
	for i = 1, xGrid do
		dangerMapMark[i] = {}
	end
	
	
	for i = 1, xGrid do
		for k = 1, zGrid do
			if mapInformation[i][k]["enemyExist"] ~= nil then
				dangerMapMark[i][k] = true
				local maxWeaponRange = mapInformation[i][k]["maxWeaponRange"]
				local maxSurroundingStep = math.ceil(maxWeaponRange / 50)
				
				for l = -maxSurroundingStep, maxSurroundingStep do
					for n = -maxSurroundingStep, maxSurroundingStep do
						if (not (l == 0 and n == 0)) and (i + l >= 1 and i + l <= xGrid) and (k + n >= 1 and k + n <= zGrid) and 
						math.abs(mapInformation[i][k]["groundHeight"] - mapInformation[i + l][k + n]["groundHeight"]) < 600 and
						math.sqrt(l * 50 * l * 50 + n * 50 * n * 50) <= maxWeaponRange then
							dangerMapMark[i + l][k + n] = true
							--Spring.Echo("here")
						end
					end
				end
			end
		end
	end	
	return dangerMapMark
end

-- @description return commander position
return function(mapInformation)
	local danger = DangerMark(mapInformation)
	local xGrid = math.ceil(Game.mapSizeX / 50)
	local zGrid = math.ceil(Game.mapSizeZ / 50)
	local count = 0
	
	for i = 1, xGrid do
		for k = 1, zGrid do
			if danger[i][k] == true then
				Spring.Echo("here")
				count = count + 1
				if (Script.LuaUI('exampleDebug_update')) then
						Script.LuaUI.exampleDebug_update(
							count, --count, --i * k, -- key
							{	-- data
								startPos = Vec3(i * 50 - 30, 500 ,k * 50 - 25), 
								endPos = Vec3(i * 50 - 20, 500 ,k * 50 - 25)
							}
						)
				end
			end
		end
	end
	
	
	return danger
end