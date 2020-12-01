--[[
TheNexusAvenger

Contains user interface components.
--]]

local UserInputService = game:GetService("UserInputService")

local NexusVRCore = require(script.Parent.Parent)



--Return the class depending on if VR is enabled or not.
if UserInputService.VREnabled then
    return NexusVRCore:GetResource("Container.ScreenGui3D")
else
    return NexusVRCore:GetResource("Container.ScreenGui2D")
end