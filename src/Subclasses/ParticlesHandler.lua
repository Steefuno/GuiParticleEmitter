--[[
	This class represents a ParticlesHandler
	A ParticlesHandler handles iterating the kinematics of all particles

	@author 4SHN (Steve)
]]

-- Constants
local SECONDS_IN_A_YEAR = 60 * 60 * 24 * 365
-- Yea, I'll be off by 24 hours on a leap year, but that's a one time thing, I'm not making a function for this <.<

-- Static Variables
local RunService = game:GetService("RunService")
local RenderStepped = RunService.RenderStepped

-- Setup the class
local Module = {}
local Methods = {}
Methods.__index = Methods

-- Instance Variables
Methods.Particles = {}
Methods.RenderSteppedConnection = nil

-- Constructs a new ParticlesHandler
function Module.New()
	local Object = {}
	setmetatable(Object, Methods)

	Object:Run()

	return Object	
end

-- Runs the Handler
function Methods:Run()
	assert(self.RenderSteppedConnection == nil, "ParticlesHandler is already running")

	local CurrentYear = os.date("%Y")

	-- Handle a Renderstep
	local function OnRenderStepped(d)
		local time = os.clock()

		-- If the os.clock() has reset back to 0, decrement all StartTimes by SECONDS_IN_A_YEAR
		local offsetStartTimes = false
		if os.date("%Y") ~= CurrentYear then
			offsetStartTimes = true
		end

		-- For each Particle
		for index, particle in ipairs(self.Particles) do
			if offsetStartTimes then
				particle.StartTime -= SECONDS_IN_A_YEAR
			end

			local continueHandling = particle:Step(time - particle.StartTime)

			if not continueHandling then
				self:Disable(particle)
			end
		end 
	end

	local renderSteppedConnection = RenderStepped:Connect(OnRenderStepped)
	self.RenderSteppedConnection = renderSteppedConnection

	return
end

-- Appends a Particle to the queue to be incremented
function Methods:Enable(particle, offset)
	particle.StartTime = os.clock() - offset

	table.insert(self.Particles, particle)
	return
end

-- Removes a Particle from being incremented
function Methods:Disable(particle)
	local index = table.find(self.Particles, particle)
	assert(index ~= nil, "Particle " .. tostring(particle) .. " was not found in the ParticlesHandler")
	table.remove(self.Particles, index)

	particle:Remove(true)
	return
end

return Module
