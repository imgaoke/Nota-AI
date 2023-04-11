function getInfo()
	return {
		onNoUnits = SUCCESS, -- instant success
		tooltip = "unload all the units",
		parameterDefs = {
			{ 
				name = "unitTransporterID",
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "",
			},
			{ 
				name = "radius",
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
	-- ○ “Transporter” is dead
	if not Spring.ValidUnitID(parameter.unitTransporterID) then
		return FAILURE
	end
	-- ○ “Transporter” is not transporter
	local unitDefID = Spring.GetUnitDefID(parameter.unitTransporterID)
	if UnitDefs[unitDefID].name ~= "armatlas" then
		return FAILURE
	end
	
	
	-- SUCCESS CONDITIONS
	if #Spring.GetUnitIsTransporting(parameter.unitTransporterID) == 0 then
		return SUCCESS
	end
	
	-- first time
	if not self.initialized then
		local x,y,z = SpringGetUnitPosition(parameter.unitTransporterID)
		Spring.GiveOrderToUnit(parameter.unitTransporterID, CMD.UNLOAD_UNITS, {x, y, z, parameter.radius},{"shift"})
		Spring.GiveOrderToUnit(parameter.unitTransporterID, CMD.STOP, {}, {})
		self.initialized = true
	end

	
	
	
	return RUNNING
end


function Reset(self)
	self.initialized = false
end
