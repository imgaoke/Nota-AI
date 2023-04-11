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
	for i = 1, width, 10 do
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
				horizontalDistance = 0
				verticalDistance = 0
				
				
				for index2, value2 in ipairs(value1) do
					
					if index2 == 1 then
						horizontalDistance = math.abs(value2 - horizontal)
					end
					
					if index2 == 2 then
						verticalDistance = math.abs(value2 - vertical)
					end
					
					if math.sqrt(horizontalDistance * horizontalDistance + verticalDistance * verticalDistance) <= 300 then
						return
					end
				end
			end
			hillIndex = hillIndex + 1
		end
	end
	
	
	sliceHeight = highestHeight - 1
	for i = 1, width, 10 do
		hillIndex = 1
		for k = 1, height do
			currentHeight = Spring.GetGroundHeight ( i, k )
			if math.abs(sliceHeight - currentHeight)  <= 0.1 then
				adjustHillIndex(i, k)
				if hills[hillIndex] == nil then
					hills[hillIndex] = {}
				end
				table.insert(hills[hillIndex],{i, k})
			end
		end
	end
	
	
	hillPeaks = {}
	for index1, value1 in ipairs(hills) do
		accumulatedHorizontal = 0
		accumulatedVertical = 0
		for index2, value2 in ipairs(value1) do
			for index3, value3 in ipairs(value2) do
				if index3 == 1 then
					accumulatedHorizontal = accumulatedHorizontal + value3			
				elseif index3 == 2 then
					accumulatedVertical = accumulatedVertical + value3
				end
			end
			
		end
		averageHorizontal = math.floor(accumulatedHorizontal / #value1)
		averageVertical = math.floor(accumulatedVertical / #value1)
		table.insert(hillPeaks, {averageHorizontal, averageVertical})
	end

	return hillPeaks
	
	--return hills
	
end


-- @description return commander position
return function()	
	return getHills()
end