-- get madatory module operators
VFS.Include("modules.lua") -- modules table
VFS.Include(modules.attach.data.path .. modules.attach.data.head) -- attach lib module

-- get other madatory dependencies
attach.Module(modules, "message") -- communication backend load

function getInfo()
	return {
		onNoUnits = SUCCESS, -- instant success
		tooltip = "Buy units according to the quota",
		parameterDefs = {
			{ 
				name = "unitsQuota",
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "",
			},
			{ 
				name = "reservationSystemMemory",
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "",
			}
		}
	}
end

function BuyUnits(unitsToBuy)
	
    for _, unit in ipairs(unitsToBuy) do
        message.SendRules({
            subject = "swampdota_buyUnit",
            data = {
                unitName = unit
            },
        })
    end
end

function NumOfItemsInTheDictionary(unitType, reservationSystemMemory)
    
    local count = 0
    for _, _ in pairs(reservationSystemMemory[unitType]) do
        count = count + 1
    end

    return count
end

function Run(self, units, parameter)


	for unitType, units in pairs(parameter.reservationSystemMemory) do
		for unitID, unitStatus in pairs(units) do
			if Spring.ValidUnitID(unitID) == false then
				parameter.reservationSystemMemory[unitType][unitID] = nil
			end
		end
	end

	local missionInformation = core.MissionInfo()
	--needs to be modified
	local metalThreshold = missionInformation.metalThreshold
	local teamID = Spring.GetMyTeamID()
	local currentLevel, storage, _, _, _, _, _, _ = Spring.GetTeamResources (teamID, "metal")

	local numberOfAtlas = NumOfItemsInTheDictionary("armatlas", parameter.reservationSystemMemory)
	local numberOfBox = NumOfItemsInTheDictionary("armbox", parameter.reservationSystemMemory)
	local numberOfSeer = NumOfItemsInTheDictionary("armseer", parameter.reservationSystemMemory)
	local currentNumberOfUnits = numberOfAtlas + numberOfBox + numberOfSeer

	currentLevel = currentLevel - global.metalLevelAfterMetalSpent
	local metalLevelTillTarget = currentLevel - metalThreshold
	local metalLevelAfterMetalSpent = currentLevel - global.metalLevelAfterMetalSpent

	local totalCost = 0
	local unitsToBuy = {}
	local buyIndex = 1

	if metalLevelTillTarget < 0 then
		currentLevel = metalLevelAfterMetalSpent
	else
		currentLevel = metalLevelTillTarget
	end


	if numberOfAtlas == numberOfBox and numberOfAtlas == 0 then
		local price = missionInformation.buy["armatlas"] + missionInformation.buy["armbox"]
		if totalCost + price < currentLevel and currentNumberOfUnits + 2 < global.upgradeTimes * 2 then
			totalCost = totalCost + price
			unitsToBuy[buyIndex] = "armatlas"
			unitsToBuy[buyIndex + 1] = "armbox"
			buyIndex = buyIndex + 2
			currentNumberOfUnits = currentNumberOfUnits + 2
		end
	elseif numberOfAtlas == numberOfBox and numberOfAtlas ~= 0 then
		if numberOfSeer == 0 then
			local price = missionInformation.buy["armseer"]
			if totalCost + price < currentLevel and currentNumberOfUnits + 1 < global.upgradeTimes * 2 then
				totalCost = totalCost + price
				unitsToBuy[buyIndex + 1] = "armseer"
				buyIndex = buyIndex + 1
				currentNumberOfUnits = currentNumberOfUnits + 1
			end
		end
	else
		if numberOfAtlas > numberOfBox then
			local gap = numberOfAtlas - numberOfBox
			local price = missionInformation.buy["armbox"]
			for i = 1, gap do
				if totalCost + price < currentLevel and currentNumberOfUnits + 1 < global.upgradeTimes * 2 then
					totalCost = totalCost + price
					unitsToBuy[buyIndex + 1] = "armbox"
					buyIndex = buyIndex + 1
					currentNumberOfUnits = currentNumberOfUnits + 1
				end
			end
		else
			local gap = numberOfBox - numberOfAtlas
			local price = missionInformation.buy["armatlas"]
			for i = 1, gap do
				if totalCost + price < currentLevel and currentNumberOfUnits + 1 < global.upgradeTimes * 2 then
					totalCost = totalCost + price
					unitsToBuy[buyIndex + 1] = "armatlas"
					buyIndex = buyIndex + 1
					currentNumberOfUnits = currentNumberOfUnits + 1
				end
			end
		end
	end
	
	BuyUnits(unitsToBuy)

	
	return SUCCESS
end


function Reset(self)
	return self
end