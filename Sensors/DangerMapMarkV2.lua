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
			dangerMapMark[i][k] = mapInformation[i][k]["groundHeight"] * 2
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
			if mapInformation[i][k]["enemyExist"] ~= nil then
				dangerMapMark[i][k] = dangerMapMark[i][k] + mapInformation[i][k]["enemyNumbers"] * 100
			
				local maxWeaponRange = mapInformation[i][k]["maxWeaponRange"]
				local maxSurroundingStep = math.ceil(maxWeaponRange / 50)
				
				for l = -maxSurroundingStep - 2, maxSurroundingStep + 2 do
					for n = -maxSurroundingStep - 2, maxSurroundingStep + 2 do
						if (not (l == 0 and n == 0)) and (i + l >= 1 and i + l <= xGrid) and (k + n >= 1 and k + n <= zGrid) then --and
							--mapInformation[i + l][k + n]["groundHeight"]) >= 50 then--math.abs(mapInformation[i][k]["groundHeight"] - mapInformation[i + l][k + n]["groundHeight"]) < 800 then
							--local distance = (maxWeaponRange - math.sqrt(l * 50 * l * 50 + n * 50 * n * 50)) * 100
							--if distance > 0 then
							--	dangerMapMark[i][k] = dangerMapMark[i][k] + distance
							--end
							
							local accumulatedHeight = 0
							local count = 0
							local o = math.abs(math.abs(l) - math.abs(n))
							local p = 0
							local signOfL = 0
							local signOfN = 0
							
							if l ~= 0 then
								signOfL = l / math.abs(l)
							end
							if n ~= 0 then
								signOfN = n / math.abs(n)
							end
							
							
							if math.abs(l) > math.abs(n) then
								p = math.abs(math.abs(l) - math.abs(o))
								count = count + math.abs(l)
							else
								p = math.abs(math.abs(n) - math.abs(o))
								count = count + math.abs(n)
							end
							
							
							
							for q = 1, p do
								accumulatedHeight = accumulatedHeight + mapInformation[i + q * signOfL][k + q * signOfN]["groundHeight"]
							end
							
							
							for r = 1, o do
								if math.abs(l) > math.abs(n) then
									--[[
									if mapInformation[i + (p + r) * signOfL][k + p * signOfN] == nil then
										Spring.Echo("what's over shoot: ")
										Spring.Echo(i + (p + r) * signOfL)
										Spring.Echo(k + p * signOfN)
										Spring.Echo(k)
										Spring.Echo(p)
										Spring.Echo(signOfN)
									end
									]]
									accumulatedHeight = accumulatedHeight + mapInformation[i + (p + r) * signOfL][k + p * signOfN]["groundHeight"]
								else
									accumulatedHeight = accumulatedHeight + mapInformation[i + p * signOfL][k + (p + r) * signOfN]["groundHeight"]
								end
							end
							
							
							local averageHeight = accumulatedHeight / count
							
							local dangerGrade = (1 - math.sqrt(l * 50 * l * 50 + n * 50 * n * 50) / math.sqrt(2 * (maxSurroundingStep + 2) * 50 * (maxSurroundingStep + 2) * 50)) * 100
							(1 / math.abs(mapInformation[i][k]["groundHeight"] - averageHeight)) * 100
							if dangerGrade < 0 then
								Spring.Echo(dangerGrade)
							end
							dangerMapMark[i + l][k + n] = dangerMapMark[i + l][k + n] + dangerGrade
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
	return dangerMapMark
end

-- @description return commander position
return function(mapInformation)
	local danger = DangerMark(mapInformation)
	local xGrid = math.ceil(Game.mapSizeX / 50)
	local zGrid = math.ceil(Game.mapSizeZ / 50)
	local count = 0
	--[[
	for i = 1, xGrid do
		for k = 1, zGrid do
			if danger[i][k] > 1000 then
				--Spring.Echo("here")
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
	]]
	
	return danger
end