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
			},
			{ 
				name = "onePath",
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
	-- ○ Unit stops to execute “Spring” order
	--if Spring.GetCommandQueue(parameter.unitTransporterID, 0) == 0 then
	--	return FAILURE
	--end
	
	
	
	local x, y, z = Spring.GetUnitPosition(parameter.unitTransporterID)
	-- first time
	if not self.initialized then
		

		
		
		self.initialized = true
		self.currentCount = 1
		
		Spring.Echo("path length:")
		Spring.Echo(#parameter.onePath)
		
		self.nextSpot = parameter.onePath[self.currentCount]
		
		Spring.GiveOrderToUnit(parameter.unitTransporterID, CMD.MOVE, {self.nextSpot[1], y, self.nextSpot[2]},{"shift"})
	end
	
	-- SUCCESS CONDITIONS
	if self.nextSpot == nil then
		return SUCCESS
	end
	--Spring.Echo(math.ceil(x / 50))
	--Spring.Echo(self.nextSpot[1])
	--Spring.Echo(math.ceil(z / 50))
	--Spring.Echo(self.nextSpot[2])
	if math.abs(x - self.nextSpot[1]) <= 10 and math.abs(z - self.nextSpot[2]) <= 10 then
		self.currentCount = self.currentCount + 1
		self.nextSpot = parameter.onePath[self.currentCount]
		if self.nextSpot ~= nil then
			Spring.GiveOrderToUnit(parameter.unitTransporterID, CMD.MOVE, {self.nextSpot[1], y, self.nextSpot[2]},{"shift"})
		end
	end	
	
	
	return RUNNING
end


function Reset(self)
	self.initialized = false
	self.nextSpot = nil
	self.currentCount = nil
	
	--[[
	local danger = DangerMark(mapInformation)
	local xGrid = math.ceil(Game.mapSizeX / 50)
	local zGrid = math.ceil(Game.mapSizeZ / 50)
	local count = 0
	
	for i = 1, xGrid do
		for k = 1, zGrid do
			if danger[i][k] == true then
				Spring.Echo("here")
				count = count + 1
				if (Script.LuaUI('exampleDebug_update')) then
						Script.LuaUI.exampleDebug_update(
							i * k, --count, --i * k, -- key
							{	-- data
								startPos = Vec3(i * 50 - 30, 500 ,k * 50 - 25), 
								endPos = Vec3(i * 50 - 20, 500 ,k * 50 - 25)
							}
						)
				end
			end
		end
	end
	]]--
end
