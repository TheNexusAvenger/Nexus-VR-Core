--Main module for Nexus VR Core.
--!strict

local BaseScreenGui = require(script:WaitForChild("Container"):WaitForChild("BaseScreenGui"))
local ScreenGui = require(script:WaitForChild("Container"):WaitForChild("ScreenGui"))
local ScreenGui2D = require(script:WaitForChild("Container"):WaitForChild("ScreenGui2D"))
local ScreenGui3D = require(script:WaitForChild("Container"):WaitForChild("ScreenGui3D"))
local PartUtility = require(script:WaitForChild("Utility"):WaitForChild("PartUtility"))

local NexusVRCore = {}
NexusVRCore.BaseScreenGui = BaseScreenGui
NexusVRCore.ScreenGui = ScreenGui
NexusVRCore.ScreenGui2D = ScreenGui2D
NexusVRCore.ScreenGui3D = ScreenGui3D
NexusVRCore.PartUtility = PartUtility

export type BaseScreenGui<T> = BaseScreenGui.BaseScreenGui<T>
export type ScreenGui2D = ScreenGui2D.ScreenGui2D
export type ScreenGui3D = ScreenGui3D.ScreenGui3D



--[[
Returns a resource in Nexus VR Core.
Legacy from Nexus Project.
--]]
function NexusVRCore:GetResource(Path: string): any
    local Module = script
    for _, PathPart in string.split(Path, ".") do
        Module = (Module :: any)[PathPart]
    end
    return require(Module :: ModuleScript) :: any
end



return NexusVRCore