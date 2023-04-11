local sensorInfo = {
	name = "LayeredBFSPathFinding",
	desc = "find the path from the transporter to the unit to be rescued",
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





function BFSPathFinding(dangerGridMap, missionInformation)

	--local units = Spring.GetSelectedUnits()peeperIndex
	local visited = {}
	local parent = {}
	local toBeVisited = {}
	local toBeVisitedNextMark = {}
	local dangerGridMapLayered = {}
	
	
	local xGrid = math.ceil(Game.mapSizeX / 50)
	local zGrid = math.ceil(Game.mapSizeZ / 50)
	
	local homeXGrid = math.ceil(missionInformation.safeArea.center.x / 50)
	local homeZGrid = math.ceil(missionInformation.safeArea.center.z / 50)
	
	
	
	for i = 1, xGrid do
		visited[i] = {}
		parent[i] = {}		
	end
	table.insert(toBeVisited, {homeXGrid, homeZGrid})
	parent[homeXGrid][homeZGrid] = "empty"

	function toBeVisitedMarkReset()
		toBeVisitedNextMark = {}
		for i = 1, xGrid do
			toBeVisitedNextMark[i] = {}
		end
	end

	toBeVisitedMarkReset()
	for i = 1, #dangerGridMap do
		dangerGridMapLayered[i] = {}
		for j = 1, #dangerGridMap[1] do
			if dangerGridMap[i][j] <= 300 then
				dangerGridMapLayered[i][j] = 1
			elseif dangerGridMap[i][j] > 300 and dangerGridMap[i][j] <= 600 then
				dangerGridMapLayered[i][j] = 2
			elseif dangerGridMap[i][j] > 600 and dangerGridMap[i][j] <= 1000 then
				dangerGridMapLayered[i][j] = 3
			elseif dangerGridMap[i][j] > 1000 and dangerGridMap[i][j] <= 1500 then
				dangerGridMapLayered[i][j] = 4
			elseif dangerGridMap[i][j] > 1500 then
				dangerGridMapLayered[i][j] = 5
			end
		end
	end

	
	while true do
		local toBeVisitedNext = {}
		local cellsExistForCurrentDangerLevel = false
		local currentDangerLevel = 1

		for _, value in ipairs(toBeVisited) do
			toBeVisitedNextMark[value[1]][value[2]] = "undetermined"
		end

		while cellsExistForCurrentDangerLevel == false and currentDangerLevel <= 5 do

			for _, value in ipairs(toBeVisited) do
				--Spring.Echo("to be visited: " .. value[1] .. "," .. value[2])
				--Spring.Echo("type of value[1]: " .. type(value[1]))
				--Spring.Echo("currentDangerLevel(outside): " .. currentDangerLevel)

				--[[
				if value[1] == 97 and value[2] == 58 then
					Spring.Echo("within 97,58 groups")
					for _, value2 in ipairs(toBeVisited) do
						Spring.Echo("97,58 groups: " .. value2[1] .. "," .. value2[2])
					end
				end
				if value[1] == 96 and value[2] == 58 then
					Spring.Echo("within 96,58 groups")
					for _, value2 in ipairs(toBeVisited) do
						Spring.Echo("96,58 groups: " .. value2[1] .. "," .. value2[2])
					end
				end
				]]
				local allNeighboursAreOpened = true

				for i = -1, 1 do
					for k = -1, 1 do
						if (not (i == 0 and k == 0)) and value[1] + i >= 1 and value[1] + i <= xGrid and value[2] + k >= 1 and value[2] + k <= zGrid then
							--Spring.Echo("here0")
							if (visited[value[1] + i][value[2] + k] == nil) then
								--Spring.Echo("here1")
								--Spring.Echo("level: " .. dangerGridMapLayered[value[1] + i][value[2] + k])
								if dangerGridMapLayered[value[1] + i][value[2] + k] <= currentDangerLevel and toBeVisitedNextMark[value[1] + i][value[2] + k] == nil then
									--Spring.Echo("here2")
									--Spring.Echo("here3")
									--Spring.Echo("currentDangerLevel(inside): " .. currentDangerLevel)
									--Spring.Echo("inside: " .. value[1] + i .. "," .. value[2] + k)
									table.insert(toBeVisitedNext, {value[1] + i, value[2] + k})
									parent[value[1] + i][value[2] + k] = {value[1], value[2]}
									toBeVisitedNextMark[value[1] + i][value[2] + k] = true
									cellsExistForCurrentDangerLevel = true
								elseif dangerGridMapLayered[value[1] + i][value[2] + k] > currentDangerLevel and cellsExistForCurrentDangerLevel == true then
									allNeighboursAreOpened = false
								end
							end
						end
					end
				end
				
				

				--add to closed list here?
				if allNeighboursAreOpened == false then
					table.insert(toBeVisitedNext, {value[1], value[2]})
				else
					visited[value[1]][value[2]] = true
				end
			end
			currentDangerLevel = currentDangerLevel + 1
		end
		
		

		if #toBeVisitedNext == 0 then
			break
		else
			toBeVisited = toBeVisitedNext
			toBeVisitedMarkReset()
		end
	end
	
	--[[
	for i = 1, xGrid do
		for k = 1, zGrid do
			if parent[i][k] == nil then
				Spring.Echo("parent missing: " .. i .. "," .. k)
			end
		end
	end
	]]
	
	--[[
	for i = 1, xGrid do
		for k = 1, zGrid do
			if visited[i][k] == nil then
				Spring.Echo("visit missing: " .. i .. "," .. k)
			end
		end
	end
	]]
	
	
	
	local homeStartX = missionInformation.safeArea.center.x - missionInformation.safeArea.radius
	local homeStartZ = missionInformation.safeArea.center.z - missionInformation.safeArea.radius
	local homeEndX = missionInformation.safeArea.center.x + missionInformation.safeArea.radius
	local homeEndZ = missionInformation.safeArea.center.z + missionInformation.safeArea.radius
	local homeStartGridX = math.ceil(homeStartX / 50)
	local homeStartGridZ = math.ceil(homeStartZ / 50)
	local homeEndGridX = math.ceil(homeEndX / 50)
	local homeEndGridZ = math.ceil(homeEndZ / 50)
	
	
	for i = homeStartGridX, homeEndGridX do
		for k = homeStartGridZ, homeEndGridZ do
			parent[i][k] = nil
		end
	end
	
	
	
		
	return parent
end

-- @description return commander position
return function(dangerGridMap, missionInformation)
	--local missionInformation = core.MissionInfo()
	local parent = BFSPathFinding(dangerGridMap, missionInformation)
	--[[
	local xGrid = math.ceil(Game.mapSizeX / 50)
	local zGrid = math.ceil(Game.mapSizeZ / 50)
	local count = 0
	for i = 1, xGrid do
		for k = 1, zGrid do
			if parent[i][k] == nil then
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
	return parent
end