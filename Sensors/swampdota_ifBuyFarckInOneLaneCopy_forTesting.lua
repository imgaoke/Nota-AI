local sensorInfo = {
	name = "ifBuyFarck",
	desc = "returns a boolean whether buying a farck or not",
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

local upgradeTimes = 1
function IfBuyFarck()
	Spring.Echo(upgradeTimes)
	upgradeTimes = upgradeTimes + 1
	return upgradeTimes


end

return function()	
	return IfBuyFarck()
end