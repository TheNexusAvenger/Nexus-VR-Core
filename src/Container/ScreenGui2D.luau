--Implementation of a ScreenGui for 2D players.
--!strict

local NexusInstance = require(script.Parent.Parent:WaitForChild("NexusInstance"))
local BaseScreenGui = require(script.Parent:WaitForChild("BaseScreenGui"))

local ScreenGui2D = {}
ScreenGui2D.ClassName = "ScreenGui2D"
ScreenGui2D.__index = ScreenGui2D
setmetatable(ScreenGui2D, BaseScreenGui)

export type ScreenGui2D = typeof(setmetatable({}, ScreenGui2D)) & BaseScreenGui.BaseScreenGui<ScreenGui>
export type NexusInstanceScreenGui2D = NexusInstance.NexusInstance<ScreenGui2D>



--[[
Creates a 2D ScreenGui.
--]]
function ScreenGui2D.__new(self: NexusInstanceScreenGui2D): ()
    BaseScreenGui.__new(self, Instance.new("ScreenGui"))
end

--[[
Returns if the ScreenGui2D is a type of instance.
IsA is not provided in Nexus Instance V4 and is provided for backwards compatibility.
--]]
function ScreenGui2D.IsA(self: NexusInstanceScreenGui2D, ClassName: string): boolean
    return BaseScreenGui.IsA(self, ClassName) or ClassName == "ScreenGui2D"
end



return NexusInstance.ToInstance(ScreenGui2D) :: NexusInstance.NexusInstanceClass<typeof(ScreenGui2D), () -> (NexusInstanceScreenGui2D)>