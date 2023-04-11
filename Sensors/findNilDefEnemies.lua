local sensorInfo = {
	name = "",
	desc = "find enemies with nil defIDs",
	author = "KeGao",
	date = "2022-05-31",
	license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = 0 -- acutal, no caching

function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT 
	}
end


function GetNilDefEnemies(tableOfEnemies)
	nilDefEnemies = {}
		
	for k,v in pairs(tableOfEnemies) do
		if (table[k] == {}) then
			table.insert(nilDefEnemies, k)
		end
	end

	
	
	return nilDefEnemies
end

return function(tableOfEnemies)	
	return GetNilDefEnemies(tableOfEnemies)
end