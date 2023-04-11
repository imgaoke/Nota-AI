function getInfo()
	return {
		onNoUnits = SUCCESS, -- instant success
		tooltip = "go to the enemy and be a tank",
		parameterDefs = {
			{ 
				name = "unitTransporterID",
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "",
			},
			{ 
				name = "enemyPosition",
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


function Run(self, units, parameter)	
	
	-- FAIL CONDITIONS
	-- ○ “transporter” is dead
	if not Spring.ValidUnitID ( parameter.unitTransporterID ) then
		return FAILURE
	end
	-- ○ “Transporter” is not transporter
	local unitDefID = Spring.GetUnitDefID(parameter.unitTransporterID)
	if UnitDefs[unitDefID].name ~= "armthovr" then
		return FAILURE
	end
	-- ○ Unit stops to execute “Spring” order
	--if Spring.GetCommandQueue(parameter.unitTransporterID, 0) == 0 then
	--	return FAILURE
	--end
	
	-- SUCCESS CONDITIONS
	-- need to detect being under attack
	if Spring.GetUnitTransporter(currentWarrior) ~= nil and #warriorsToLoad == 0 then
		Spring.GiveOrderToUnit(parameter.unitTransporterID, CMD.STOP, {"shift"})
		return SUCCESS
	end
	
	-- first time
	if not self.initialized then
		Spring.GiveOrderToUnit(parameter.unitTransporterID, CMD.MOVE,{parameter.enemyPosition},{"shift"})
		self.initialized = true
	end
	
	
	return RUNNING
end


function Reset(self)
	self.initialized = false
end
