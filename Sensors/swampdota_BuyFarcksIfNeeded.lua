local sensorInfo = {
	name = "BuyFarcksIfNeeded",
	desc = "returns a boolean whether buying a farck or not(also responsible for deleting the invalid farcks)",
	author = "KeGao",
	date = "2022-06-07",
	license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = 0 -- acutal, no caching

function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT 
	}
end


--this is kind of static variable?
-- yes
local lastUpgradeTimes = global.upgradeTimes
function IfBuyFarck(currentFarcksInTheLane, reservationSystemMemory, lastUpgradeTimes)
	local missionInformation = Sensors.core.MissionInfo()
	--needs to be modified --no need
	--local metalThreshold = missionInformation.metalThreshold
	local prices = missionInformation.buy
	local farckPrice = prices["armfark"]
	local teamID = Spring.GetMyTeamID()
	
	local currentLevel, storage, _, _, _, _, _, _ = Spring.GetTeamResources (teamID, "metal")

	local teamUnits = Spring.GetTeamUnits(teamID)

	--[[
	local farcks = {}
	for index, unitID in ipairs(teamUnits) do
		local unitDefID = Spring.GetUnitDefID(unitID)
		if UnitDefs[unitDefID].name ~= "armfark" then
			table.insert(farcks, unitID)
		end
	end
	]]

	
	for index, unitID in ipairs(currentFarcksInTheLane) do
		if Spring.ValidUnitID(unitID) == false then
			currentFarcksInTheLane[index] = nil
			reservationSystemMemory.farcks[unitID] = nil
		end
	end

	local numberOfFarcks = 0
	for _, _ in pairs(currentFarcksInTheLane) do
		numberOfFarcks = numberOfFarcks + 1
	end
	

	if global.upgradeTimes > lastUpgradeTimes and currentLevel >= farckPrice and numberOfFarcks < 2 then
		lastUpgradeTimes = global.upgradeTimes
		return true
	end


end

return function(currentFarcksInTheLane, reservationSystemMemory, lastUpgradeTimes)	
	return IfBuyFarck(currentFarcksInTheLane, reservationSystemMemory, lastUpgradeTimes)
end