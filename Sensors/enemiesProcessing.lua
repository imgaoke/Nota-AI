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

local minWeaponRangeOfTheMap = math.huge
function ProcessEnemies(tableOfEnemies, mapInformation)
	
	for enemyID, enemyInformation in pairs(tableOfEnemies) do
		if Spring.ValidUnitID(enemyID) then
			local enemyDefID = enemyInformation["defID"]
			if enemyDefID ~= nil then
				local weaponsToBeChecked = UnitDefs[enemyDefID].weapons
				for weaponIndex, weaponDefTable in ipairs(weaponsToBeChecked) do
					local weaponDefID = weaponDefTable.weaponDef
					if WeaponDefs[weaponDefID].range > 0 and WeaponDefs[weaponDefID].range < minWeaponRangeOfTheMap then
						minWeaponRangeOfTheMap = WeaponDefs[weaponDefID].range
						--[[if WeaponDefs[weaponDefID].range == 0 then
							Spring.Echo("weapon range got 0")
						end]]--
					end
				end
			end
		end
	end
	--[[Spring.Echo("min weapon range: " .. minWeaponRangeOfTheMap)]]--
		
	for enemyID, enemyInformation in pairs(tableOfEnemies) do
		--if Spring.ValidUnitID(enemyID) then
		local sightRadius = 0
		local enemyDefID = enemyInformation["defID"]
		--local enemyPointX, enemyPointY, enemyPointZ = Spring.GetUnitPosition(enemyID)
		local maxWeaponRange = 0
		local maxEffectiveRange = 0
		if enemyDefID ~= nil then
			sightRadius = UnitDefs[enemyDefID].losRadius
			local weaponsToBeChecked = UnitDefs[enemyDefID].weapons
			for weaponIndex, weaponDefTable in ipairs(weaponsToBeChecked) do
				local weaponDefID = weaponDefTable.weaponDef
				if WeaponDefs[weaponDefID].range > maxWeaponRange then
					maxWeaponRange = WeaponDefs[weaponDefID].range
				end
			end
			maxEffectiveRange = math.min(maxWeaponRange, sightRadius)
		else
			maxEffectiveRange = math.max(minWeaponRangeOfTheMap, sightRadius)
		end
		
		local gridPositionX = math.ceil(enemyInformation["position"].x / 50)
		local gridPositionZ = math.ceil(enemyInformation["position"].z / 50)
		
		--mapInformation[gridPositionX][gridPositionZ]["enemyExist"] = true
		--mapInformation[gridPositionX][gridPositionZ]["enemyNumbers"] = 1
		if mapInformation[gridPositionX][gridPositionZ]["enemies"] == nil then
			mapInformation[gridPositionX][gridPositionZ]["enemies"] = {}
		end
		
		if enemyDefID ~= nil then
			table.insert(mapInformation[gridPositionX][gridPositionZ]["enemies"], {enemyDefID, maxEffectiveRange})
		else
			if enemyDefID == 300 then
				--Spring.Echo("found the ship")
				--Spring.Echo("maximum effective range: " .. maxWeaponRange)
			end
			table.insert(mapInformation[gridPositionX][gridPositionZ]["enemies"], {maxEffectiveRange})
		end
				
		--end
	end
		
		

	
	
	return mapInformation
end

return function(tableOfEnemies, mapInformation)	
	return ProcessEnemies(tableOfEnemies, mapInformation)
end