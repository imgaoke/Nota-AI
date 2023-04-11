local sensorInfo = {
	name = "BFSPathFinding",
	desc = "find the path from the transporter to the unit to be rescued",
	author = "KeGao",
	date = "2021-07-16",
	license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = 0 -- acutal, no caching

function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT 
	}
end





function BFSPathFinding(dangerGridMap, missionInformation)

	function deepcopy(orig)
		local orig_type = type(orig)
		local copy
		if orig_type == 'table' then
			copy = {}
			for orig_key, orig_value in next, orig, nil do
				copy[deepcopy(orig_key)] = deepcopy(orig_value)
			end
			setmetatable(copy, deepcopy(getmetatable(orig)))
		else -- number, string, boolean, etc
			copy = orig
		end
		return copy
	end
	--local units = Spring.GetSelectedUnits()peeperIndex
	local visited = {}
	local toBeVisitedMarkOrigin = {}
	local parent = {}
	local parented = {}
	local dangerParent = {}
	
	local xGrid = math.ceil(Game.mapSizeX / 50)
	local zGrid = math.ceil(Game.mapSizeZ / 50)
	
	--local unitX, unitY, unitZ = Spring.GetUnitPosition(unitToBeRescuedID)
	--local transX, transY, transZ = Spring.GetUnitPosition(transporterID)
	--local unitXGrid = math.ceil(unitX / 50)
	--local unitZGrid = math.ceil(unitZ / 50)
	--local transXGrid = math.ceil(transX / 50)
	--local transZGrid = math.ceil(transZ / 50)
	local homeXGrid = math.ceil(missionInformation.safeArea.center.x / 50)
	local homeZGrid = math.ceil(missionInformation.safeArea.center.z / 50)
	
	local toBeVisited = {}
	
	for i = 1, xGrid do
		visited[i] = {}
		toBeVisitedMarkOrigin[i] = {}
		parent[i] = {}
		--parented[i] = {}
		dangerParent[i] = {}
		for k = 1, zGrid do
			dangerParent[i][k] = 1 / 0
		end
	end
	local leastDangerParentAmongToBeVisited = deepcopy(dangerParent)
	local toBeVisitedMark = deepcopy(toBeVisitedMarkOrigin)
	table.insert(toBeVisited, {homeXGrid, homeZGrid})
	toBeVisitedMark[homeXGrid][homeZGrid] = true
	--visited[unitXGrid][unitZGrid] = true
	while true do
		local toBeVisitedNext = {}
		for _, value in ipairs(toBeVisited) do
			if visited[value[1]][value[2]] == nil then
				visited[value[1]][value[2]] = true
				for i = -1, 1 do
					for k = -1, 1 do
						if (not (i == 0 and k == 0)) and value[1] + i >= 1 and value[1] + i <= xGrid and value[2] + k >= 1 and value[2] + k <= zGrid and
							visited[value[1] + i][value[2] + k] == nil and (not toBeVisitedMark[value[1] + i][value[2] + k]) and 
							dangerGridMap[value[1]][value[2]] < leastDangerParentAmongToBeVisited[value[1] + i][value[2] + k]
							then --
							leastDangerParentAmongToBeVisited[value[1] + i][value[2] + k] = dangerGridMap[value[1]][value[2]]
							table.insert(toBeVisitedNext, {value[1] + i, value[2] + k})
							parent[value[1] + i][value[2] + k] = {value[1], value[2]}
							--parented[value[1] + i][value[2] + k] = true
						end
					end
				end
			end
		end
		leastDangerParentAmongToBeVisited = deepcopy(dangerParent)
		toBeVisitedMark = deepcopy(toBeVisitedMarkOrigin)
		
		
		
		if #toBeVisitedNext == 0 then
			break
		else
			toBeVisited = deepcopy(toBeVisitedNext)
		end
		
		for _, value in ipairs(toBeVisited) do
			toBeVisitedMark[value[1]][value[2]] = true
		end
		
	end
	
	--[[
	for i = 1, xGrid do
		for k = 1, zGrid do
			if parent[i][k] == nil then
				Spring.Echo("parent missing")
			end
		end
	end
	]]
	for i = 1, xGrid do
		for k = 1, zGrid do
			if visited[i][k] == nil then
				Spring.Echo("visit missing")
			end
		end
	end
	
	
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
	local xGrid = math.ceil(Game.mapSizeX / 50)
	local zGrid = math.ceil(Game.mapSizeZ / 50)
	local count = 0
	--[[
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