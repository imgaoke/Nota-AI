-- get madatory module operators
VFS.Include("modules.lua") -- modules table
VFS.Include(modules.attach.data.path .. modules.attach.data.head) -- attach lib module

-- get other madatory dependencies
attach.Module(modules, "message") -- communication backend load

function getInfo()
	return {
		onNoUnits = SUCCESS, -- instant success
		tooltip = "Get unit in param",
		parameterDefs = {
			{ 
				name = "lineName",
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "",
			},
			{ 
				name = "upgradeLevel",
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "",
			},
		}
	}
end

function Run(self, units, parameter)
	local teamID = Spring.GetMyTeamID()
	local currentLevel, storage, _, _, _, _, _, _ = Spring.GetTeamResources (teamID, "metal")
	local missionInformation = Sensors.core.MissionInfo()

	if currentLevel > missionInformation.upgrade.line * parameter.upgradeLevel then
		message.SendRules({
			subject = "swampdota_upgradeLine",
			data = {
				lineName = parameter.lineName,
				upgradeLevel = parameter.upgradeLevel,
			},
		})
		return SUCCESS
	else
		return FAILURE
	end
    
	
	
end


function Reset(self)
	return self
end