local sensorInfo = {
	name = "peepersSensor",
	desc = "sense all the enemies and put them into the mapInformation",
	author = "KeGao",
	date = "2021-07-22",
	license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = 0 -- acutal, no caching

function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT 
	}
end

tableOfEnemies = {}
function GetEnemies()
	
	local enemyUnits = Spring.GetTeamUnits(1)
	
	for _, enemyID in ipairs(enemyUnits) do
		local enemyDefID = Spring.GetUnitDefID(enemyID)
		--local enemyPointX, enemyPointY, enemyPointZ = Spring.GetUnitPosition(enemyId)
		if tableOfEnemies[enemyID] == nil then
			tableOfEnemies[enemyID] = {}
			local x, y, z = Spring.GetUnitPosition(enemyID)
			if (Spring.GetUnitPosition(enemyID) == nil) then
				Spring.Echo("invalid ID:" .. enemyID)
			else
				--Spring.Echo(Spring.GetUnitPosition(enemyID))
			end
			tableOfEnemies[enemyID]["position"] = Vec3(x, y, z)
		end
			--tableOfEnemies[enemyID]["position"] = {enemyPointX, enemyPointY, enemyPointZ}
		--elseif tableOfEnemies[enemyID]["defID"] == nil and enemyDefID ~= nil then
		--	tableOfEnemies[enemyID]["defID"] = enemyDefID
		if tableOfEnemies[enemyID] ~= nil and tableOfEnemies[enemyID]["defID"] == nil and enemyDefID ~= nil then
			tableOfEnemies[enemyID]["defID"] = enemyDefID
		end
	end
		
	-- for debugging
	--[[
	local counter = 0
	for k,v in pairs(tableOfEnemies) do
		if (type(v) ~= "number") then
			counter = counter + 1
		end
		
	end
	tableOfEnemies.counter = counter
	--Spring.Echo(counter)
	]]--
	
	
	return tableOfEnemies
end

return function()	
	return GetEnemies()
end