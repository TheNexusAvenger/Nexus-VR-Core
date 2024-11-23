--Contains user interface components.
--!strict

local UserInputService = game:GetService("UserInputService")

local BaseScreenGui = require(script.Parent:WaitForChild("BaseScreenGui"))
local ScreenGui3D = require(script.Parent:WaitForChild("ScreenGui3D"))
local ScreenGui2D = require(script.Parent:WaitForChild("ScreenGui2D"))



--Return the class depending on if VR is enabled or not.
if UserInputService.VREnabled then
    return ScreenGui3D :: BaseScreenGui.BaseScreenGui<LayerCollector>
else
    return ScreenGui2D :: BaseScreenGui.BaseScreenGui<LayerCollector>
end