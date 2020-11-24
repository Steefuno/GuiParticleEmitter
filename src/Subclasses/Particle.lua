--[[
	This class represents a LoopEmittersHandler
	A LoopEmittersHandler will trigger LoopEmitters to emit when valid

	@author 4SHN (Steve)
]]

-- Constants
local PARTICLE_TEMPLATE = Instance.new("ImageLabel")
PARTICLE_TEMPLATE.BackgroundTransparency = 1

-- Static Variables
local ParticlesHandler = require(script.Parent:WaitForChild("ParticlesHandler"))

-- Setup _G to support optimizing multiple Particles
if _G._ParticlesHandler == nil then
	_G._ParticlesHandler = ParticlesHandler.New()
end
local ParticlesHandler = _G._ParticlesHandler

-- Setup the class
local Module = {}
local Methods = {}
Methods.__index = Methods

-- Instance Variables
Methods.Acceleration = Vector2.new(0, 0)
Methods.Angle = Vector2.new(1, 0)
Methods.Drag = 0
Methods.FrontDirection = 0
Methods.Position = UDim2.new(0, 0, 0, 0)
Methods.Rotation = 0
Methods.RotSpeed = 0
Methods.Speed = 10
Methods.Transparency = NumberSequence.new(0, 0)

Methods.ImageLabel = nil
Methods.Properties = nil
Methods.ParticlesTable = nil
Methods.StartTime = 0

-- Constructs a new Particle
function Module.New(Properties, ParticlesTable, offset)
	local Object = {}
	setmetatable(Object, Methods)

	Object.Properties = Properties

	Object.Acceleration = Properties.Acceleration
	Object.Angle = CalculateAngle(Properties.FrontDirection, Properties.SpreadAngle)
	Object.Drag = Properties.Drag
	Object.LifeTime = CalculateFromNumberRange(Properties.LifeTime)
	Object.Position = Properties.Position
	Object.RotSpeed = Properties.RotSpeed
	Object.Rotation = Properties.Rotation
	Object.Speed = CalculateFromNumberRange(Properties.Speed)
	Object.Transparency = Properties.Transparency

	Object:ConstructImageLabel()
	Object:Step(offset)

	Object.ParticlesTable = ParticlesTable
	ParticlesHandler:Enable(Object, offset)

	if ParticlesTable then
		table.insert(ParticlesTable, Object)
	end
	return Object
end

-- Creates an ImageLabel with the properties
function Methods:ConstructImageLabel()
	local imageLabel = PARTICLE_TEMPLATE:Clone()
	self.ImageLabel = imageLabel

	imageLabel.AnchorPoint = self.Properties.AnchorPoint
	imageLabel.Position = self.Properties.Position
	imageLabel.Rotation = self.Properties.Rotation
	imageLabel.Size = self.Properties.Size
	imageLabel.SizeConstraint = self.Properties.SizeConstraint
	imageLabel.ZIndex = self.Properties.ZIndex
	imageLabel.Image = self.Properties.Texture
	imageLabel.ImageColor3 = self.Properties.Color
	
	imageLabel.Parent = self.Properties.Parent

	return
end

-- Places the Particle at the respective position at t seconds and adjusts any necessary properties
function Methods:Step(t)
	if t > self.LifeTime then
		return false
	end

	-- Calculate the position
	local dx = ( (self.Speed * t) + (self.Acceleration.X * (t ^ 2) / 2) ) * self.Angle.X
	local dy = ( (self.Speed * t) + (self.Acceleration.Y * (t ^ 2) / 2) ) * self.Angle.Y
	local Position = UDim2.new(
		self.Position.X.Scale,
		self.Position.X.Offset + dx,
		self.Position.Y.Scale,
		self.Position.Y.Offset + dy
	)

	-- Calculate the rotation
	local Rotation = self.Rotation + (t * self.RotSpeed)

	-- Calculate the transparency
	--TODO

	-- Calculate the color
	--TODO

	-- Assign properties
	self.ImageLabel.Position = Position
	self.ImageLabel.Rotation = Rotation

	return true
end

-- Removes the particle
function Methods:Remove(ignoreParticlesHandler)
	-- Remove starting from the ParticlesHandler's queue
	if not ignoreParticlesHandler then
		return ParticlesHandler:Disable(self)
	end

	-- Find and remove from ParticlesTable in Emitter
	local index = table.find(self.ParticlesTable, self)
	assert(index ~= nil, "Particle " .. tostring(self) .. " was not found in the ParticlesTable")
	table.remove(self.ParticlesTable, index)

	-- Remove
	self.ImageLabel:Destroy()

	return
end

-- Selects a random angle from within the SpreadAngle
function CalculateAngle(FrontDirection, SpreadAngle)
	-- Get the angle from FrontDirection
	local selectAngle = FrontDirection % 360

	-- Apply the SpreadAngle
	selectAngle = selectAngle + ( (math.random() * 2 - 1) * (SpreadAngle) )

	-- Convert the angle to Vector2
	return Vector2.new(
		math.sin(
			math.rad(selectAngle)
		),
		math.cos(
			math.rad(selectAngle)
		)
	)
end

-- Selects a random number from within the NumberRange
function CalculateFromNumberRange(numberRange)
	return (math.random() * (numberRange.Max - numberRange.Min)) + numberRange.Min
end

return Module
