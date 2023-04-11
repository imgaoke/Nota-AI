local sensorInfo = {
	name = "getMetalsInOneLange",
	desc = "returns a table of metals in the current lane",
	author = "KeGao",
	date = "2022-06-13",
	license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = 0 -- acutal, no caching

function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT 
	}
end


function getMetalsInOneLane(lane)
	local tableOfMetals = {}
	local points = lane.points
	local areaOfEachPoint = 500

	for indexi, point in ipairs(points) do
		local currentFeatures = Spring.GetFeaturesInCylinder(point.position.x, point.position.z, areaOfEachPoint)
		for indexj, featureID in ipairs(currentFeatures) do
			local featureDefID = Spring.GetFeatureDefID (featureID)
			if featureDefID ~= nil and FeatureDefs[featureDefID].metal > 0 then
				table.insert(tableOfMetals, featureID)
			end
		end
	end

	return tableOfMetals

end

return function(lane)	
	return getMetalsInOneLane(lane)
end