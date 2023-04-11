function getInfo()
	return {
		onNoUnits = SUCCESS, -- instant success
		tooltip = "send peepers top down",
		parameterDefs = {
			{ 
				name = "peepers",
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

scanCommandGiven = false
function Run(self, units, parameter)	
	 
	
	-- SUCCESS CONDITIONS
	
	
	-- first time
	if not self.formationInitialized then
		local interval1 = Game.mapSizeX / 3 * 2 / (#parameter.peepers - 1)
		local interval2 = Game.mapSizeX / (#parameter.peepers - 1)
		for i = 1, #parameter.peepers do
			Spring.GiveOrderToUnit(parameter.peepers[i], CMD.MOVE,{Game.mapSizeX / 6 + interval1 * (i - 1), 0, 1000},{"shift"})
			Spring.GiveOrderToUnit(parameter.peepers[i], CMD.MOVE,{interval2 * (i - 1), 0, Game.mapSizeZ},{"shift"})
		end
		self.formationInitialized = true
		scanCommandGiven = true
	else
		--○ Unit stops to execute “Spring” order
		--if Spring.GetCommandQueue(parameter.unitTransporterID, 0) == 0 then
		--	return FAILURE
		--end
		local allArrived = true
		
		for i = 1, #parameter.peepers do
			local basePointX, basePointY, basePointZ = Spring.GetUnitPosition(parameter.peepers[i])
			if Spring.ValidUnitID(parameter.peepers[i]) and basePointZ < 7400 then
				allArrived = false
				break
			end
		end
		
		--Spring.Echo("allStopped: " .. tostring(allStopped))
		--Spring.Echo("self.formationInitialized: " .. tostring(self.formationInitialized))
		--Spring.Echo("scanCommandGiven: " .. tostring(scanCommandGiven))
		--Spring.Echo("readyToGiveScanCommand: " .. tostring(readyToGiveScanCommand))

		if allArrived == true and scanCommandGiven == true then
			return SUCCESS
		end
		
	end
	
	return RUNNING
end


function Reset(self)
	self.formationInitialized = false
	--self.scanCommandGiven = false
	--self.readyToGiveScanCommand = false
end
