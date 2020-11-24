--[[
	This class represents a LoopEmittersHandler
	A LoopEmittersHandler will handle iterating LoopEmitters

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
Methods.LoopEmitters = {}
Methods.RenderSteppedConnection = nil

-- Constructs a new LoopEmittersHandler
function Module.New()
	local Object = {}
	setmetatable(Object, Methods)

	Object:Run()

	return Object
end

-- Runs the Handler
function Methods:Run()
	assert(self.RenderSteppedConnection == nil, "LoopEmittersHandler is already running")

	local CurrentYear = os.date("%Y")

	-- Handle a Renderstep
	local function OnRenderStepped(d)
		local currentTime = os.clock()

		-- If the os.clock() has reset back to 0, decrement all PrevTimes by SECONDS_IN_A_YEAR
		local offsetPrevTimes = false
		if os.date("%Y") ~= CurrentYear then
			offsetPrevTimes = true
		end

		-- For each LoopEmitter
		for index, loopEmitter in ipairs(self.LoopEmitters) do
			if offsetPrevTimes then
				loopEmitter.PrevTime -= SECONDS_IN_A_YEAR
			end

			-- Emits whenever Time * Rate % 1 == 0
			local prevTime = loopEmitter.PrevTime
			local dTime = currentTime - prevTime
			local tick = dTime * loopEmitter.Emitter.Properties.Rate

			if tick < 1 then
				continue
			end

			local offset = tick % 1
			loopEmitter.PrevTime = currentTime

			-- For each missed particle to emit, emit 1 given the time missed
			for i = 1, tick, 1 do
				local missed = tick - i
				loopEmitter.Emitter:Emit(1, offset + missed)
			end
		end 
	end

	local renderSteppedConnection = RenderStepped:Connect(OnRenderStepped)
	self.RenderSteppedConnection = renderSteppedConnection

	return
end

-- Appends a LoopEmitter to the queue to be incremented
function Methods:Enable(loopEmitter)
	loopEmitter.PrevTime = os.clock()

	table.insert(self.LoopEmitters, loopEmitter)
	return
end

-- Removes a LoopEmitter from being incremented
function Methods:Disable(loopEmitter)
	local index = table.find(self.LoopEmitters, loopEmitter)
	assert(index ~= nil, "LoopEmitter " .. tostring(loopEmitter) .. " was not found in the LoopEmittersHandler")

	table.remove(self.LoopEmitters, index)
	return
end

return Module
