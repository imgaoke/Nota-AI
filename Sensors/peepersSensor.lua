local sensorInfo = {
	name = "peepersSensor",
	desc = "sense all the enemies and put them into the mapInformation",
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

xGrid = math.ceil(Game.mapSizeX / 50)
zGrid = math.ceil(Game.mapSizeZ / 50)
enemyIDCheck = {}
function GetEnemies(peepers, mapInformation)
	
	for peeperIndex, peeperId in ipairs(peepers) do
		if Spring.ValidUnitID(peeperId) then
			local peeperDefID = Spring.GetUnitDefID(peeperId)
			local sightRadius = UnitDefs[peeperDefID].losRadius 
			local peeperPointX, peeperPointY, peeperPointZ = Spring.GetUnitPosition(peeperId)
			local enemies = Spring.GetUnitsInCylinder(peeperPointX, peeperPointZ, sightRadius - 200, 1)
			for enemyIndex, enemyId in ipairs(enemies) do
				if Spring.ValidUnitID(peeperId) and Spring.ValidUnitID(enemyId) and enemyIDCheck[enemyId] == nil then
					enemyIDCheck[enemyId] = true
					local enemyDefID = Spring.GetUnitDefID(enemyId)
					if enemyDefID == nil then
						Spring.Echo("enemyId: " .. enemyId)
					end
					local weaponsToBeChecked = UnitDefs[enemyDefID].weapons
					local enemyPointX, enemyPointY, enemyPointZ = Spring.GetUnitPosition(enemyId)
					local gridPositionX = math.ceil(enemyPointX / 50)
					local gridPositionZ = math.ceil(enemyPointZ / 50)
					if mapInformation[gridPositionX][gridPositionZ]["enemyExist"] == nil then
						mapInformation[gridPositionX][gridPositionZ]["enemyExist"] = true
						mapInformation[gridPositionX][gridPositionZ]["enemyNumbers"] = 1
						local maxWeaponRange = 0
						for weaponIndex, weaponDefTable in ipairs(weaponsToBeChecked) do
							local weaponDefID = weaponDefTable.weaponDef
							if WeaponDefs[weaponDefID].range > maxWeaponRange then
								maxWeaponRange = WeaponDefs[weaponDefID].range
							end
						end
						
						mapInformation[gridPositionX][gridPositionZ]["maxWeaponRange"] = maxWeaponRange
					else
						mapInformation[gridPositionX][gridPositionZ]["enemyNumbers"] = mapInformation[gridPositionX][gridPositionZ]["enemyNumbers"] + 1
					end
				end
				
			end
		end
	end
	return mapInformation
end

return function(peepers, mapInformation)	
	return GetEnemies(peepers, mapInformation, enemyIDCheck)
end