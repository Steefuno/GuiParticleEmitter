--[[
	This class represents a LoopEmitter
	A LoopEmitter will constantly emit particles while enabled

	@author 4SHN (Steve)
]]

-- Static Variables
local LoopEmittersHandler = require(script.Parent:WaitForChild("LoopEmittersHandler"))

-- Setup _G to support optimizing multiple GuiParticleEmitters
if _G._LoopEmittersHandler == nil then
	_G._LoopEmittersHandler = LoopEmittersHandler.New()
end
local LoopEmittersHandler = _G._LoopEmittersHandler

-- Setup the class
local Module = {}
local Methods = {}
Methods.__index = Methods

-- Instance Variables
Methods.Emitter = nil
Methods.PrevTime = 0

-- Constructs a new LoopEmitter
function Module.New(Emitter)
	local Object = {}
	setmetatable(Object, Methods)

	Object.Emitter = Emitter

	return Object
end

-- Add or remove this LoopEmitter from the LoopEmittersHandler
function Methods:SetEnabled(enable)
	if enable then
		return LoopEmittersHandler:Enable(self)
	else
		return LoopEmittersHandler:Disable(self)
	end
end

return Module
