--[[
	This class represents a GuiParticleEmitter
	A GuiParticleEmitter holds an Emitter and the properties

	@author 4SHN (Steve)
]]

-- Constants
local MIN_LIFETIME, MAX_LIFETIME = 0, 20 --TODO, setup metamethods to enforce

-- Static Variables
local Emitter = require(script:WaitForChild("Emitter"))

-- Setup the class
local Module = {}
local Methods = {}
Methods.__index = Methods

-- Public Properties
Methods.Acceleration = Vector2.new(0, 0)
Methods.AnchorPoint = Vector2.new(0, 0)
Methods.Color = Color3.new(1,1,1) --TODO, change this to a ColorSequence
Methods.FrontDirection = 0 -- Angle in Degrees
Methods.IsEnabled = false -- ReadOnly, use Methods:SetEnabled(enabled)
Methods.LifeTime = NumberRange.new(1, 1)
Methods.Parent = nil
Methods.Position = UDim2.new(0, 0, 0, 0)
Methods.Rate = 1
Methods.RotSpeed = 0
Methods.Rotation = 0 -- Angle in Degrees
Methods.Size = UDim2.new(0, 10, 0, 10)
Methods.SizeConstraint = Enum.SizeConstraint.RelativeXY
Methods.Speed = NumberRange.new(10, 10)
Methods.SpreadAngle = 0 -- Angle in Degrees. e.g. Inputting 90 will give a range of -90 to 90
Methods.Texture = "rbxasset://textures/particles/sparkles_main.dds"
Methods.Transparency = NumberSequence.new(0, 0)
Methods.ZIndex = 0

-- "Private" Instance Variables
Methods._Emitter = nil

-- Constructs a new GuiParticleEmitter
function Module.New()
	local Object = {}
	setmetatable(Object, Methods)

	Object:_SetupEmitter()

	return Object
end

-- Enables the Emitter to loop
function Methods:SetEnabled(enable)
	assert(enable ~= nil, "Argument 1 missing or nil")
	assert(type(enable) == "boolean", "Argument 1 must be a boolean")
	assert(self.Parent ~= nil, "GuiParticleEmitter needs a Parent")

	self.IsEnabled = enable
	return self._Emitter:SetEnabled(enable)
end

-- Emits N particles
function Methods:Emit(count)
	assert(count ~= nil, "Argument 1 missing or nil")
	assert(type(count) == "number", "Argument 1 must be a number")
	assert(self.Parent ~= nil, "GuiParticleEmitter needs a Parent")

	local count = math.floor(count)
	assert(count > 0, "Argument 1 must be greater than 0")

	return self._Emitter:Emit(count)
end

-- Clears all existing particles
function Methods:Clear()
	return self._Emitter:Clear()
end

-- Sets up the emitter to handle particles
function Methods:_SetupEmitter()
	local emitter = Emitter.New(self)
	self._Emitter = emitter

	return
end

return Module
