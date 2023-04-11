local sensorInfo = {
	name = "peeperScanCheck",
	desc = "Check if the people scanned right",
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
						if not (l == 0 and n == 0) and (i + l >= 1 and i + l <= xGrid) and (k + n >= 1 and k + n <= zGrid) and
							mapInformation[i][k]["groundHeight"] - mapInformation[i + l][k + n]["groundHeight"] < 500 then
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
	local xGrid = math.ceil(Game.mapSizeX / 50)
	local zGrid = math.ceil(Game.mapSizeZ / 50)
	
	
	for i = 1, xGrid do
		for k = 1, zGrid do
			if mapInformation[i][k]["enemyExist"] == true then
				--Spring.Echo("here")
				if (Script.LuaUI('exampleDebug_update')) then
						Script.LuaUI.exampleDebug_update(
							i * k, -- key
							{	-- data
								startPos = Vec3(i * 50 - 40, 0 ,k * 50 - 25), 
								endPos = Vec3(i * 50 - 10, 0 ,k * 50 - 25)
							}
						)
				end
			end
		end
	end
	
	
	return DangerMark(mapInformation)
end