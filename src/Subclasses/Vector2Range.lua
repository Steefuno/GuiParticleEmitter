--[[
	This class represents a Vector2
	A Vector2Range represents a range from one Vector2 to another

	@author 4SHN (Steve)
]]

-- Setup the class
local Module = {}
local Methods = {}
Methods.__index = Methods

-- Instance Variables
Methods.Min = Vector2.new() -- ReadOnly
Methods.Max = Vector2.new() -- ReadOnly

-- Constructs a new UDim2Range
function Module.New(min, max)
	local Object = {}
	setmetatable(Object, Methods)
	
	if (min ~= nil) and (max ~= nil) then
		return ConstructWithMinMax(Object, min, max)
	end

	if (min ~= nil) and (max == nil) then
		return ConstructWithMin(Object, min)
	end

	error("Argument 1 missing or nil")
end

-- Constructs a Vector2Range with a minimum and maximum
function ConstructWithMinMax(Object, min, max)
	assert(typeof(min) == "Vector2", "Argument #1 must be a Vector2")
	assert(typeof(max) == "Vector2", "Argument #2 must be a Vector2")

	assert(min.X <= max.X, "Invalid Range: X")
	assert(min.Y <= max.Y, "Invalid Range: Y")

	Object.Min = min
	Object.Max = max

	return Object
end

-- Constructs a Vector2Range with a single UDim2
function ConstructWithMin(Object, min)
	assert(typeof(min) == "Vector2", "Argument #1 must be a Vector2")

	Object.Min = min
	Object.Max = min

	return Object
end

return Module
