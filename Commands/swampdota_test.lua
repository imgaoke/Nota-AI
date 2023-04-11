

function getInfo()
	return {
		onNoUnits = SUCCESS, -- instant success
		tooltip = "Buy unit in param",
		parameterDefs = {
			{ 
				name = "unitName",
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "'armbox'",
			},
		}
	}
end

function Run(self, units, parameter)
    Spring.Echo(self.path)
	if self.path == nil then
		self.path = 0
	else
		self.path = self.path + 1
	end
	return RUNNING
end


function Reset(self)
	self.path = "hello world"
end