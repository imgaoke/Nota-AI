function getInfo()
	return {
		onNoUnits = SUCCESS, -- instant success
		tooltip = "Load a given unit",
		parameterDefs = {
			{ 
				name = "unitsToLoad",
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

function shallowcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

local warriorsToLoad
local currentWarrior

function Run(self, units, parameter)	
	
	
	-- first time
	if not self.initialized then
		warriorsToLoad = shallowcopy(parameter.unitsToLoad)
		--warriorsToLoad = shallowcopy(parameter.unitsToLoad)
		self.initialized = true
	else
		--○ Unit stops to execute “Spring” order
		--if Spring.GetCommandQueue(parameter.unitTransporterID, 0) == 0 then
		--	Logger.warn("here5")
		--	return FAILURE
		--end
	end
	currentWarrior = warriorsToLoad[#warriorsToLoad]
	
	if not self.orderGiven then
		Spring.GiveOrderToUnit(parameter.unitTransporterID, CMD.LOAD_UNITS,{currentWarrior},{"shift"})
		self.orderGiven = true
	end
	
	
	-- FAIL CONDITIONS
	-- ○ “Unit to be rescued” is dead
	if not Spring.ValidUnitID ( currentWarrior ) then
		Logger.warn("here0") 

		return FAILURE
	end
	-- ○ “Unit to be rescued” is loaded by other transporter
	if Spring.GetUnitTransporter(currentWarrior) ~= nil and Spring.GetUnitTransporter(currentWarrior) ~= parameter.unitTransporterID then
		Logger.warn("here1")
		return FAILURE
	end
	-- ○ “Unit to be rescued” is not transportable
	local unitDefID = Spring.GetUnitDefID(currentWarrior)
	if UnitDefs[unitDefID].cantBeTransported == true then
		Logger.warn("here2")
		return FAILURE
	end
	-- ○ “Transporter” is dead
	if not Spring.ValidUnitID ( parameter.unitTransporterID ) then
		Logger.warn("here3")
		return FAILURE
	end
	-- ○ “Transporter” is not transporter
	local unitDefID = Spring.GetUnitDefID(parameter.unitTransporterID)
	if UnitDefs[unitDefID].name ~= "armthovr" then
		Logger.warn("here4")
		return FAILURE
	end
	
	
	
	
	if Spring.GetUnitTransporter(currentWarrior) ~= nil then
		self.orderGiven = false
		table.remove(warriorsToLoad)
		--Logger.warn("warriorsToLoad: " .. #warriorsToLoad)
		
		-- SUCCESS CONDITIONS
		if #warriorsToLoad == 0 then
			return SUCCESS
		end
	end
	
	
	
	
	
	return RUNNING
end


function Reset(self)
	self.initialized = false
	self.orderGiven = false
end
