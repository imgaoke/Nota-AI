function getInfo()
	return {
		onNoUnits = SUCCESS, -- instant success
		tooltip = "Move custom group to defined position. Group is defined by table of unitID => formationIndex.",
		parameterDefs = {
			{ 
				name = "groupDefintion",
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "",
			},
			-- @parameter groupDefintion [table] - mapping unitID => positionIndex
			--[[ local example = {
				[14945] = 1,
				[5814] = 2,
				[126450] = 3,
			}
			]]--
			{ 
				name = "position",
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "",
			},
			{ 
				name = "formation", -- relative formation
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "<relative formation>",
			},
			-- @parameter formation [array] - list of Vec3
			--[[ local example = {
				[1] = Vec3(0,0,0),
				[2] = Vec3(10,0,0),
				[3] = Vec3(-10,0,0),
			}
			]]--
			{ 
				name = "fight",
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "false",
			}
		}
	}
end

-- constants
local THRESHOLD_STEP = 25
local THRESHOLD_DEFAULT = 0

-- speed-ups
local SpringGetUnitPosition = Spring.GetUnitPosition
local SpringGiveOrderToUnit = Spring.GiveOrderToUnit

local function ClearState(self)
	self.threshold = THRESHOLD_DEFAULT
	self.lastPointmanPosition = Vec3(0,0,0)
end

function Run(self, units, parameter)
	local customGroup = parameter.groupDefintion -- table
	local position = parameter.position -- Vec3
	local formation = parameter.formation -- array of Vec3
	local fight = parameter.fight -- boolean
	
	--Spring.Echo(dump(parameter.formation))
	
	-- validation
	-- if (#units > #formation) then
		-- Logger.warn("formation.move", "Your formation size [" .. #formation .. "] is smaller than needed for given count of units [" .. #units .. "] in this group.") 
		-- return FAILURE
	-- end
	
	-- pick the spring command implementing the move
	local cmdID = CMD.MOVE
	if (fight) then cmdID = CMD.FIGHT end

	-- choose the pointmen
	local minIndex = math.huge
	local pointmanID
	for unitID, posIndex in pairs(customGroup) do
		if posIndex < minIndex then
		minIndex = posIndex 
		pointmanID = unitID
		end
	end
	local pointX, pointY, pointZ = SpringGetUnitPosition(pointmanID)
	local pointmanPosition = Vec3(pointX, pointY, pointZ)
	
	-- threshold of pointan success
	if (pointmanPosition == self.lastPointmanPosition) then 
		self.threshold = self.threshold + THRESHOLD_STEP 
	else
		self.threshold = THRESHOLD_DEFAULT
	end
	self.lastPointmanPosition = pointmanPosition
	
	-- check pointman success
	-- THIS LOGIC IS TEMPORARY, NOT CONSIDERING OTHER UNITS POSITION
	local pointmanOffset = formation[1]
	local pointmanWantedPosition = position + pointmanOffset
	if (pointmanPosition:Distance(pointmanWantedPosition) < self.threshold) then
		return SUCCESS
	else
		SpringGiveOrderToUnit(pointmanID, cmdID, pointmanWantedPosition:AsSpringVector(), {})
		
		for unitID, posIndex in pairs(customGroup) do
			if unitID ~= pointmanID then
				local thisUnitWantedPosition = pointmanPosition - pointmanOffset + formation[posIndex]
				SpringGiveOrderToUnit(unitID, cmdID, thisUnitWantedPosition:AsSpringVector(), {})
			end
		end
		
		return RUNNING
	end
end


function Reset(self)
	ClearState(self)
end
