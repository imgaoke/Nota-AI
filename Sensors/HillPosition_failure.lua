local sensorInfo = {
	name = "hillPosition",
	desc = "Return a table of hills.",
	author = "KeGao",
	date = "2021-05-15",
	license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = 0 -- acutal, no caching

function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT 
	}
end

function getHills()
	--local units = Spring.GetSelectedUnits()
	width = Game.mapSizeX
	height = Game.mapSizeZ
	accumulatedHeight = 0
	lowestHeight = math.huge
	highestHeight = -math.huge
	for i = 1, width do
		for k = 1, height do
			currentHeight = Spring.GetGroundHeight ( i, k )
			accumulatedHeight = accumulatedHeight + currentHeight
			if currentHeight < lowestHeight then
				lowestHeight = currentHeight
			end
			
			if currentHeight > highestHeight then
				highestHeight = currentHeight
			end
		end
	end

	
	
	--[[
	terrain = {}
	
	for i=1, width do
      terrain[i] = {}
      for k=1, height do
		currentHeight = Spring.GetGroundHeight ( i, k )
		if highestHeight - currentHeight < 5 then
			terrain[i][k] = true
		else
			terrain[i][k] = false
		end
      end
    end
	--]]
	
	
	
	
	hills = {}
	hillIndex = 1
	
	function adjustHillIndex(horizontal, vertical)
		while hills[hillIndex] ~= nil do
			for index1, value1 in ipairs(hills[hillIndex]) do
				firstPassed = false
				secondPassed = false
				for index2, value2 in ipairs(value1) do
					if index2 == 1 and value2 == horizontal - 1 then
						firstPassed = true
					end
					
					if index2 == 2 and value2 == vertical then
						secondPassed = true
					end
					
					if firstPassed == true and secondPassed == true then
						return
					end
				end
			end
			hillIndex = hillIndex + 1
		end
	end
	terrain = {}
	for i = 1, width do
		hillIndex = 1
		terrain[i] = {}
		hillIndexSettled = false
		for k = 1, height do
			currentHeight = Spring.GetGroundHeight ( i, k )
			if highestHeight - currentHeight < 0.1 then
				terrain[i][k] = true
				if terrain[i - 1][k] ~= nil and terrain[i - 1][k] == true and hillIndexSettled == false then
					adjustHillIndex(i, k)
					hillIndexSettled = true	
					table.insert(hills[hillIndex],{i, k})
				elseif terrain[i - 1][k] ~= nil and terrain[i - 1][k] == true and hillIndexSettled == true then
					table.insert(hills[hillIndex],{i, k})
				elseif terrain[i - 1][k] == false and hillIndexSettled == false then
					adjustHillIndex(i, k)
					hillIndexSettled = true
					hills[hillIndex] = {}
					table.insert(hills[hillIndex],{i, k})
				elseif terrain[i - 1][k] == false and hillIndexSettled == true then
					table.insert(hills[hillIndex],{i, k})
				end
			elseif highestHeight - currentHeight >= 0.1 then
				hillIndexSettled = false
				terrain[i][k] = false
			end
			
		end
	end
	

	return hills
	
	
end


-- @description return commander position
return function()
	local tableOfHills
	
	tableOfHills = getHills()
	
	return {
		tableOfHills = tableOfHills,
	}
end