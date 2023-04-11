local sensorInfo = {
	name = "reversePath",
	desc = "reverse one path",
	author = "KeGao",
	date = "2022-06-01",
	license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = 0 -- acutal, no caching

function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT 
	}
end


function reversePath(one)
	

		
	local reverseOne = {}
	
	for i = #one, 1, -1 do
		table.insert(reverseOne, one[i])
	end

	
	if reverseOne == {} then
		Spring.Echo("reverse path empty")
	end
		
	return reverseOne
end

-- @description return commander position
return function(one)
		
	local one = reversePath(one)
	

	
	return one
end