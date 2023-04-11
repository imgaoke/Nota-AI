function getInfo()
	return {
		onNoUnits = SUCCESS, -- instant success
		tooltip = "unload the unit",
		parameterDefs = {
			{ 
				name = "unitTransporterID",
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "",
			},
			{ 
				name = "unloadLocation",
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

--https://trello.com/c/6u6ZVofQ/93-still-problems-with-units-sliding-away
local function randomPointInCircle(centerX, centerY, centerZ, R)
	-- -50 to make sure the unit is within the rescue area
	local r = (R - 50) * math.random()
	local theta  = math.random() * 2 * math.pi
	local thisX = centerX + r * math.cos(theta)
	local thisZ = centerZ + r * math.sin(theta)
	
	return Vec3(thisX, centerY, thisZ)
end

local function randomPointInRectangle()
	local xMin = 3330
	local xMax = 4090
	local zMin = 50
	local zMax = 250
	local x = math.random(xMin, xMax)
	local z = math.random(zMin, zMax)
	
	return Vec3(x, 683, z)
end

local function countingLandedUnits(position, transporterID, unitBeingTransportedID)
	local unitBeingTransportedRadius = Spring.GetUnitRadius ( unitBeingTransportedID )
	local unitsToBeChecked = Spring.GetUnitsInSphere(position.x, position.y, position.z, unitBeingTransportedRadius + 15)
	local count = 0
	for index, unitID in pairs(unitsToBeChecked) do
		if unitID ~= transporterID and unitID ~= unitBeingTransportedID then
			count = count + 1
		end
	end
	
	return count
end

function Run(self, units, parameter)	
	
	-- FAIL CONDITIONS
	-- ○ “Transporter” is dead
	if not Spring.ValidUnitID ( parameter.unitTransporterID ) then
		return FAILURE
	end
	-- ○ “Transporter” is not transporter
	local unitDefID = Spring.GetUnitDefID(parameter.unitTransporterID)
	if UnitDefs[unitDefID].name ~= "armatlas" then
		return FAILURE
	end
	
	
	
	-- SUCCESS CONDITIONS
	if #Spring.GetUnitIsTransporting ( parameter.unitTransporterID ) == 0 then
		local transporterRadius = Spring.GetUnitRadius(parameter.unitTransporterID)
		if not self.chasingRest then
			Spring.Echo("here4")
			while true do
				local randomPoint = randomPointInRectangle()
				if countingLandedUnits(randomPoint, parameter.unitTransporterID, parameter.unitTransporterID) == 0 then
					Spring.Echo("restPosition is set")
					self.restPosition = randomPoint
					break
				end	
			end
			Spring.Echo("here5")
			Spring.GiveOrderToUnit(parameter.unitTransporterID, CMD.MOVE, {self.restPosition.x, self.restPosition.y, self.restPosition.z},{"shift"})
			self.chasingRest = true;
		else
			Spring.Echo("here6")
			local x, y, z = Spring.GetUnitPosition( parameter.unitTransporterID )
			local velX, velY, velZ, velLength = Spring.GetUnitVelocity(parameter.unitTransporterID)
			if math.abs(x - self.restPosition.x) <= 10 and math.abs(z - self.restPosition.z) <= 10 and velLength < 0.5 then
				if countingLandedUnits(self.restPosition, parameter.unitTransporterID, parameter.unitTransporterID) ~= 0 then
					Spring.Echo("here7")
					self.chasingRest = false
				else
					Spring.GiveOrderToUnit(parameter.unitTransporterID, CMD.STOP, {},{"shift"})
					return SUCCESS
				end
				
			elseif (math.abs(x - self.restPosition.x) > 10 or math.abs(z - self.restPosition.z) > 10) and velLength < 0.5 then
				Spring.Echo("here8")
				Spring.GiveOrderToUnit(parameter.unitTransporterID, CMD.MOVE, {self.restPosition.x, self.restPosition.y, self.restPosition.z},{"shift"})
			end
		end
		return RUNNING
	end
	
	
	local unitBeingTransported = Spring.GetUnitIsTransporting ( parameter.unitTransporterID )[1]
	local unitBeingTransportedRadius = Spring.GetUnitRadius ( unitBeingTransported )
	-- first time
	if not self.initialized then
		--Spring.GiveOrderToUnit(parameter.unitTransporterID, CMD.STOP, {}, {})
		
		
		--Spring.Echo("unitBeingTransportedRadius: " .. unitBeingTransportedRadius)
		
		
		
		while true do
			local randomPoint = randomPointInCircle(parameter.unloadLocation.safeArea.center.x, parameter.unloadLocation.safeArea.center.y, parameter.unloadLocation.safeArea.center.z, parameter.unloadLocation.safeArea.radius)
			-- +10 to make sure
			if #Spring.GetUnitsInSphere(randomPoint.x, randomPoint.y, randomPoint.z, unitBeingTransportedRadius + 10) == 0 then
				--Spring.Echo("here0")
				self.unloadPosition = randomPoint
				break
			end	
		end
		
		--local randomPoint = randomPointInCircle(parameter.unloadLocation.safeArea.center.x, parameter.unloadLocation.safeArea.center.y, parameter.unloadLocation.safeArea.center.z, parameter.unloadLocation.safeArea.radius)

		--Spring.Echo("randomPoint: " .. randomPoint.x .. " " .. randomPoint.y .. " " .. randomPoint.z)
		
		
		Spring.GiveOrderToUnit(parameter.unitTransporterID, CMD.MOVE, {self.unloadPosition.x, self.unloadPosition.y, self.unloadPosition.z},{"shift"})
		self.chasingTarget = true
		--Spring.GiveOrderToUnit(parameter.unitTransporterID, CMD.UNLOAD_UNIT, {randomPoint.x, randomPoint.y, randomPoint.z},{"shift"})

		--Spring.GiveOrderToUnit(parameter.unitTransporterID, CMD.UNLOAD_UNITS, {parameter.unloadLocation.safeArea.center.x, parameter.unloadLocation.safeArea.center.y, parameter.unloadLocation.safeArea.center.z, parameter.unloadLocation.safeArea.radius},{"shift"})
		
		self.initialized = true
	else
		-- ○ Unit stops to execute “Spring” order
		if self.chasingTarget == false then
			if self.unloading == true then
			
			elseif countingLandedUnits(self.unloadPosition, parameter.unitTransporterID, unitBeingTransported) == 0 then
				Spring.Echo("unitBeingTransportedRadius: " .. unitBeingTransportedRadius)
				Spring.Echo("here2")
				Spring.GiveOrderToUnit(parameter.unitTransporterID, CMD.UNLOAD_UNIT, {self.unloadPosition.x, self.unloadPosition.y, self.unloadPosition.z},{"shift"})
				self.unloading = true
			else
				Spring.Echo("here3")
				while true do
					local randomPoint = randomPointInCircle(parameter.unloadLocation.safeArea.center.x, parameter.unloadLocation.safeArea.center.y, parameter.unloadLocation.safeArea.center.z, parameter.unloadLocation.safeArea.radius)
					if #Spring.GetUnitsInSphere(randomPoint.x, randomPoint.y, randomPoint.z, unitBeingTransportedRadius + 15) == 0 then
						self.unloadPosition = randomPoint
						break
					end	
				end
				Spring.GiveOrderToUnit(parameter.unitTransporterID, CMD.MOVE, {self.unloadPosition.x, self.unloadPosition.y, self.unloadPosition.z},{"shift"})
				self.chasingTarget = true
			end
		else
			local x, y, z = Spring.GetUnitPosition( parameter.unitTransporterID )
			local velX, velY, velZ, velLength = Spring.GetUnitVelocity(parameter.unitTransporterID)
			if math.abs(x - self.unloadPosition.x) <= 5 and math.abs(z - self.unloadPosition.z) <= 5 and velLength < 0.2 then
				Spring.Echo("here0")
				self.chasingTarget = false
			elseif (math.abs(x - self.unloadPosition.x) > 5 or math.abs(z - self.unloadPosition.z) > 5) and velLength < 0.2 then
				Spring.Echo("here1")
				Spring.GiveOrderToUnit(parameter.unitTransporterID, CMD.MOVE, {self.unloadPosition.x, self.unloadPosition.y, self.unloadPosition.z},{"shift"})
			end
		end
		
		--[[
		if Spring.GetCommandQueue(parameter.unitTransporterID, 0) == 0 then
			
			
			while true do
				local randomPoint = randomPointInCircle(parameter.unloadLocation.safeArea.center.x, parameter.unloadLocation.safeArea.center.y, parameter.unloadLocation.safeArea.center.z, parameter.unloadLocation.safeArea.radius)
				if Spring.GetUnitsInSphere(randomPoint.x, randomPoint.y, randomPoint.z, unitBeingTransportedRadius) == nil then
					unloadPosition = randomPoint
					break
				end
			end	
		end
		Spring.GiveOrderToUnit(parameter.unitTransporterID, CMD.UNLOAD_UNIT, {unloadPosition.x, unloadPosition.y, unloadPosition.z},{"shift"})
		--]]
	end

	
	
	
	return RUNNING
end


function Reset(self)
	self.initialized = false
	self.chasingTarget = false
	self.unloadPosition = nil
	self.restPosition = nil
	self.unloading = false
	self.chasingRest = false
end
