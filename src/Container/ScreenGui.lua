--[[
TheNexusAvenger

Contains user interface components.
--]]
--!strict

local UserInputService = game:GetService("UserInputService")

local ScreenGui3D = require(script.Parent:WaitForChild("ScreenGui3D"))
local ScreenGui2D = require(script.Parent:WaitForChild("ScreenGui2D"))



--Return the class depending on if VR is enabled or not.
if UserInputService.VREnabled then
    return ScreenGui3D
else
    return ScreenGui2D
end