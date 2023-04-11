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

	local r = R * math.sqrt(math.random())
	local theta  = math.random() * 2 * math.pi
	local thisX = centerX + r * math.cos(theta)
	local thisZ = centerZ + r * math.sin(theta)
	
	return Vec3(thisX, centerY, thisZ)
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
		return SUCCESS
	end
	
	
	local unitBeingTransported = Spring.GetUnitIsTransporting ( parameter.unitTransporterID )[1]
	local unitBeingTransportedRadius = Spring.GetUnitRadius ( unitBeingTransported )
	-- first time
	if not self.initialized then
		--Spring.GiveOrderToUnit(parameter.unitTransporterID, CMD.STOP, {}, {})
		
		
		--Spring.Echo("unitBeingTransportedRadius: " .. unitBeingTransportedRadius)
		
		
		
		while true do
			local randomPoint = randomPointInCircle(parameter.unloadLocation.safeArea.center.x, parameter.unloadLocation.safeArea.center.y, parameter.unloadLocation.safeArea.center.z, parameter.unloadLocation.safeArea.radius)
			if #Spring.GetUnitsInSphere(randomPoint.x, randomPoint.y, randomPoint.z, unitBeingTransportedRadius) == 0 then
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
			
			elseif #Spring.GetUnitsInSphere(self.unloadPosition.x, self.unloadPosition.y, self.unloadPosition.z, unitBeingTransportedRadius) == 0 then
				Spring.GiveOrderToUnit(parameter.unitTransporterID, CMD.UNLOAD_UNIT, {self.unloadPosition.x, self.unloadPosition.y, self.unloadPosition.z},{"shift"})
				self.unloading = true
			else
				while true do
					local randomPoint = randomPointInCircle(parameter.unloadLocation.safeArea.center.x, parameter.unloadLocation.safeArea.center.y, parameter.unloadLocation.safeArea.center.z, parameter.unloadLocation.safeArea.radius)
					if #Spring.GetUnitsInSphere(randomPoint.x, randomPoint.y, randomPoint.z, unitBeingTransportedRadius) == 0 then
						self.unloadPosition = randomPoint
						break
					end	
				end
				Spring.GiveOrderToUnit(parameter.unitTransporterID, CMD.MOVE, {self.unloadPosition.x, self.unloadPosition.y, self.unloadPosition.z},{"shift"})
				self.chasingTarget = true
			end
		else
			local transporterRadius = Spring.GetUnitRadius(parameter.unitTransporterID)
			local x, y, z = Spring.GetUnitPosition( parameter.unitTransporterID )
			local velX, velY, velZ, velLength = Spring.GetUnitVelocity(parameter.unitTransporterID)
			if math.abs(x - self.unloadPosition.x) <= transporterRadius and math.abs(z - self.unloadPosition.z) <= transporterRadius and velLength < 0.5 then
				self.chasingTarget = false
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
	self.unloading = false
end
