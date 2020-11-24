--[[
	This class represents an Emitter
	An emitter emits particles

	@author 4SHN (Steve)
]]

-- Static Variables
local Particle = require(script.Parent:WaitForChild("Particle"))
local LoopEmitter = require(script.Parent:WaitForChild("LoopEmitter"))

-- Setup the class
local Module = {}
local Methods = {}
Methods.__index = Methods

-- Instance Variables
Methods.LoopEmitter = nil
Methods.Properties = nil
Methods.Particles = {}

-- Constructs a new Emitter
function Module.New(Properties)
	local Object = {}
	setmetatable(Object, Methods)

	Object.Properties = Properties
	Object:SetupLoopEmitter()

	return Object
end

-- Enables the LoopEmitter
function Methods:SetEnabled(enable)
	return self.LoopEmitter:SetEnabled(enable)
end

-- Emits N particles with an offset, e.g. given an offset of 5 seconds, the particle will load at the position it would be if loaded 5 seconds ago
function Methods:Emit(count, offset)
	Particle.New(self.Properties, self.Particles, offset)

	if count <= 1 then
		return
	else
		count -= 1
		return self:Emit(count) -- No complaining about my tail recursion, Lua's interpreter knows how to do proper tail calls
	end
end

-- Clears all existing particles
function Methods:Clear()
	while #self.Particles > 0 do
		self.Particles[1]:Remove()
	end

	return
end

-- Sets up the LoopEmitter
function Methods:SetupLoopEmitter()
	local loopEmitter = LoopEmitter.New(self)
	self.LoopEmitter = loopEmitter

	return
end

return Module
