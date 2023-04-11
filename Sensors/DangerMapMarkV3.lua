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
		for k = 1, zGrid do
			if mapInformation[i][k]["enemies"] == nil and mapInformation[i][k]["groundHeight"] < 0 then
				dangerMapMark[i][k] = -500
			else
				dangerMapMark[i][k] = mapInformation[i][k]["groundHeight"]
			end
			--[[
			if mapInformation[i][k]["groundHeight"] > 0 then
				dangerMapMark[i][k] = mapInformation[i][k]["groundHeight"] ^ 1.2
			else
				dangerMapMark[i][k] = -math.abs(mapInformation[i][k]["groundHeight"]) ^ 1.2
			end
			--dangerMapMark[i][k] = math.abs(mapInformation[i][k]["groundHeight"]) ^ 1.2
			--dangerMapMark[i][k] = mapInformation[i][k]["groundHeight"] * mapInformation[i][k]["groundHeight"]
			]]
		end
	end
	
	
	for i = 1, xGrid do
		for k = 1, zGrid do
			local enemies = mapInformation[i][k]["enemies"]
			if enemies ~= nil then
				
				if #enemies >= 2 then
					Spring.Echo("number of enemies: " .. #enemies)
				end
				local enemyDefID = nil
				local maxEffectiveRange = 0 
				for _, enemyInformation in ipairs(enemies) do
					dangerMapMark[i][k] = dangerMapMark[i][k] + 1000
					
					local markIfEnemyHasDefID = enemyInformation[2]
					if markIfEnemyHasDefID == nil then
						maxEffectiveRange = enemyInformation[1]
					else
						enemyDefID = enemyInformation[1]
						maxEffectiveRange = enemyInformation[2]
					end
				

					if enemyDefID == 263 then
						maxEffectiveRange = maxEffectiveRange / 2
						Spring.Echo("divide the range")
					end

					if enemyDefID == 300 then
						Spring.Echo("found the ship")
					end
								
					local maxSurroundingStep = math.ceil(maxEffectiveRange / 50)
					
					for l = -maxSurroundingStep - 3, maxSurroundingStep + 3 do
						for n = -maxSurroundingStep - 3, maxSurroundingStep + 3 do
							if (not (l == 0 and n == 0)) and (i + l >= 1 and i + l <= xGrid) and (k + n >= 1 and k + n <= zGrid) and math.abs(mapInformation[i][k]["groundHeight"] - mapInformation[i + l][k + n]["groundHeight"]) < 720 then 
								--and
								--mapInformation[i + l][k + n]["groundHeight"]) >= 50 then--math.abs(mapInformation[i][k]["groundHeight"] - mapInformation[i + l][k + n]["groundHeight"]) < 800 then
								--local distance = (maxWeaponRange - math.sqrt(l * 50 * l * 50 + n * 50 * n * 50)) * 100
								--if distance > 0 then
								--	dangerMapMark[i][k] = dangerMapMark[i][k] + distance
								--end
								
								local dangerGrade = (1 - math.sqrt(l * 50 * l * 50 + n * 50 * n * 50) / math.sqrt(2 * (maxSurroundingStep + 3) * 50 * (maxSurroundingStep + 3) * 50)) * 2000
								--if i == 62 and k >= 96 and k <= 106 then
								--	Spring.Echo("62," .. k .. ": " .. dangerGrade)
								--end
								--(1 / math.abs(mapInformation[i][k]["groundHeight"] - averageHeight)) * 100
								if dangerGrade < 0 then
									Spring.Echo("dangerGrade < 0: " .. dangerGrade)
								end
								--Spring.Echo("dangerGrade: " .. dangerGrade)
								-- 263 is DefID of Cobra
								dangerMapMark[i + l][k + n] = dangerMapMark[i + l][k + n] + dangerGrade
								
							end
						end
					end
				end
			end
		end
	end	
	--[[
	for i = 1, xGrid do
		for k = 1, zGrid do
			if dangerMapMark[i][k] == nil then
				Spring.Echo("here")
			end
		end
	end
	]]
	--[[
	local maximum = -1/0
	for i = 1, xGrid do
		for k = 1, zGrid do
			if dangerMapMark[i][k] > maximum then
				maximum = dangerMapMark[i][k]
			end
		end
	end
	Spring.Echo("maximum: ")
	Spring.Echo(maximum)
	]]

	local dangerGridMapLayered = {}
	for i = 1, #dangerMapMark do
		dangerGridMapLayered[i] = {}
		for j = 1, #dangerMapMark[1] do
			if dangerMapMark[i][j] <= 0 then
				dangerGridMapLayered[i][j] = 1
			elseif dangerMapMark[i][j] > 0 and dangerMapMark[i][j] <= 100 then
				dangerGridMapLayered[i][j] = 2
			elseif dangerMapMark[i][j] > 100 and dangerMapMark[i][j] <= 600 then
				dangerGridMapLayered[i][j] = 3
			elseif dangerMapMark[i][j] > 600 and dangerMapMark[i][j] <= 1000 then
				dangerGridMapLayered[i][j] = 4
			elseif dangerMapMark[i][j] > 1000 then
				dangerGridMapLayered[i][j] = 5

			end
		end
	end

	return dangerGridMapLayered
end

-- @description return commander position
return function(mapInformation)
	local danger = DangerMark(mapInformation)
	local xGrid = math.ceil(Game.mapSizeX / 50)
	local zGrid = math.ceil(Game.mapSizeZ / 50)
	local count = 0
	
	for i = 1, xGrid do
		for k = 1, zGrid do
			count = count + 1
			if danger[i][k] == 1 then
				--Spring.Echo("here")
				if (Script.LuaUI('exampleDebug_update')) then
						Script.LuaUI.exampleDebug_update(
							count, --count, --i * k, -- key
							{	-- data
								startPos = Vec3(i * 50 - 30, 500 ,k * 50 - 25), 
								endPos = Vec3(i * 50 - 20, 500 ,k * 50 - 25),
								r = 0/255,
								g = 255/255,
								b = 0/255
							}
						)
				end
			elseif danger[i][k] == 2 then
				--Spring.Echo("here")
				if (Script.LuaUI('exampleDebug_update')) then
						Script.LuaUI.exampleDebug_update(
							count, --count, --i * k, -- key
							{	-- data
								startPos = Vec3(i * 50 - 30, 500 ,k * 50 - 25), 
								endPos = Vec3(i * 50 - 20, 500 ,k * 50 - 25),
								r = 255/255,
								g = 192/255,
								b = 203/255
							}
						)
				end
			--[[elseif danger[i][k] == 3 then
				--Spring.Echo("here")
				if (Script.LuaUI('exampleDebug_update')) then
						Script.LuaUI.exampleDebug_update(
							count, --count, --i * k, -- key
							{	-- data
								startPos = Vec3(i * 50 - 30, 500 ,k * 50 - 25), 
								endPos = Vec3(i * 50 - 20, 500 ,k * 50 - 25),
								r = 125/255,
								g = 206/255,
								b = 235/255
							}
						)
				end
			elseif danger[i][k] == 4 then
				--Spring.Echo("here")
				if (Script.LuaUI('exampleDebug_update')) then
						Script.LuaUI.exampleDebug_update(
							count, --count, --i * k, -- key
							{	-- data
								startPos = Vec3(i * 50 - 30, 500 ,k * 50 - 25), 
								endPos = Vec3(i * 50 - 20, 500 ,k * 50 - 25),
								r = 255/255,
								g = 255/255,
								b = 0/255
							}
						)
				end
			elseif danger[i][k] == 5 then
				--Spring.Echo("here")
				if (Script.LuaUI('exampleDebug_update')) then
						Script.LuaUI.exampleDebug_update(
							count, --count, --i * k, -- key
							{	-- data
								startPos = Vec3(i * 50 - 30, 500 ,k * 50 - 25), 
								endPos = Vec3(i * 50 - 20, 500 ,k * 50 - 25),
								r = 255/255,
								g = 0/255,
								b = 0/255
							}
						)
				end
			elseif danger[i][k] > 1500 and danger[i][k] <= 2000 then
				--Spring.Echo("here")
				if (Script.LuaUI('exampleDebug_update')) then
						Script.LuaUI.exampleDebug_update(
							count, --count, --i * k, -- key
							{	-- data
								startPos = Vec3(i * 50 - 30, 500 ,k * 50 - 25), 
								endPos = Vec3(i * 50 - 20, 500 ,k * 50 - 25),
								r = 255/255,
								g = 255/255,
								b = 0/255
							}
						)
				end
			elseif danger[i][k] > 2000 then
				--Spring.Echo("here")
				if (Script.LuaUI('exampleDebug_update')) then
						Script.LuaUI.exampleDebug_update(
							count, --count, --i * k, -- key
							{	-- data
								startPos = Vec3(i * 50 - 30, 500 ,k * 50 - 25), 
								endPos = Vec3(i * 50 - 20, 500 ,k * 50 - 25),
								r = 255/255,
								g = 0/255,
								b = 0/255
							}
						)
				end--]]
			end
		end
	end
	
	
	
	return danger
end