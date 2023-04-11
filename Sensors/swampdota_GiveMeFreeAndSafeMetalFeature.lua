local sensorInfo = {
	name = "GiveMeFreeAndSafeMetalFeature",
	desc = "give a free and safe metal feature",
	author = "Ke Gao",
	date = "2021-06-13",
	license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = -1 -- no caching 

function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT
	}
end

return function(reservationSystemMemory, lane, battleFrontIndex)
	local points = lane.points
	local unitSelectedID
	-- distance to home
	local battleFrontDistance = math.sqrt((points[battleFrontIndex].position.x - 1400) * (points[battleFrontIndex].position.x - 1400) + (points[battleFrontIndex].position.z - 8900) * (points[battleFrontIndex].position.x - 8900))
	for unitID, reservationState in pairs(reservationSystemMemory.metalsToCollect) do
		if (reservationState == "notCollected") and Spring.ValidUnitID(unitID) then
			local basePointX, basePointY, basePointZ = Spring.GetUnitPosition(unitID)
			if basePointX ~= nil and math.sqrt((basePointX - 1400) * (basePointX - 1400) + (basePointZ - 8900) * (basePointZ - 8900)) < battleFrontDistance then
				unitSelectedID = unitID
				reservationSystemMemory.metalsToCollect[unitID] = "beingCollected"
				break
			end
		end
	end
	
	Spring.Echo(unitSelectedID == nil)
	return unitSelectedID
end