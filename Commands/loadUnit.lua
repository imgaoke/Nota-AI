function getInfo()
	return {
		onNoUnits = SUCCESS, -- instant success
		tooltip = "Load a given unit",
		parameterDefs = {
			{ 
				name = "unitToRescueID",
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "",
			},
			{ 
				name = "unitTransporterID",
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "",
			}
		}
	}
end

--[[
● Parameters
	○ unitID we would like to be rescued
	○ unitID of the transporter
● Definition of SUCCESS:
	○ “Unit to be rescued” is loaded in “transporter”
● Definition of FAIL:
	○ “Unit to be rescued” is dead
	○ “Unit to be rescued” is loaded by other transporter
	○ “Unit to be rescued” is not transportable
	○ “Transporter” is dead
	○ “Transporter” is not transporter
	○ “They are far away from each other”
	○ Unit stops to execute “Spring” order
● Definition of RUNNING:
	○ Not success, Not fail,
● Init (only first time):
	○ Check all failure conditions
	○ Give “Spring” order to transporter to load a unit
● Once running (always):
	○ Check all failure conditions
	○ Check all success conditions
]]--


local function ClearState(self)
end

function Run(self, units, parameter)	
	
	
	-- FAIL CONDITIONS
	-- ○ “Unit to be rescued” is dead
	if not Spring.ValidUnitID ( parameter.unitToRescueID ) then
		return FAILURE
	end
	-- ○ “Unit to be rescued” is loaded by other transporter
	if Spring.GetUnitTransporter(parameter.unitToRescueID) ~= nil and Spring.GetUnitTransporter(parameter.unitToRescueID) ~= parameter.unitTransporterID then
		return FAILURE
	end
	-- ○ “Unit to be rescued” is not transportable
	local unitDefID = Spring.GetUnitDefID(parameter.unitToRescueID)
	if UnitDefs[unitDefID].cantBeTransported == true then
		return FAILURE
	end
	-- ○ “Transporter” is dead
	if not Spring.ValidUnitID ( parameter.unitTransporterID ) then
		return FAILURE
	end
	-- ○ “Transporter” is not transporter
	local unitDefID = Spring.GetUnitDefID(parameter.unitTransporterID)
	if UnitDefs[unitDefID].name ~= "armatlas" then
		return FAILURE
	end
	-- ○ “They are far away from each other”
	--local distance = Spring.GetUnitSeparation(parameter.unitToRescueID, parameter.unitTransporterID)

	--if distance > 200 then
	--	return FAILURE
	--end

	
	-- SUCCESS CONDITIONS
	if Spring.GetUnitTransporter(parameter.unitToRescueID) ~= nil then
		return SUCCESS
	end
	
	-- first time
	if not self.initialized then
		
		Spring.GiveOrderToUnit(parameter.unitTransporterID, CMD.LOAD_UNITS,{parameter.unitToRescueID},{"shift"})
		self.initialized = true
	else
		--○ Unit stops to execute “Spring” order
		--if Spring.GetCommandQueue(parameter.unitTransporterID, 0) == 0 then
		--	return FAILURE
		--end
	end
	
	return RUNNING
end


function Reset(self)
	self.initialized = false
end
