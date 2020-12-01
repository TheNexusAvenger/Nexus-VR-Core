--[[
TheNexusAvenger

Contains user interface components for a 2D user interface.
--]]

local NexusVRCore = require(script.Parent.Parent)
local NexusWrappedInstance = NexusVRCore:GetResource("NexusWrappedInstance")

local ScreenGui2D = NexusWrappedInstance:Extend()
ScreenGui2D:SetClassName("ScreenGui2D")
ScreenGui2D:CreateGetInstance()



--[[
Creates the Screen Gui 2D.
--]]
function ScreenGui2D:__new(ExistingScreenGui)
    self:InitializeSuper(ExistingScreenGui or Instance.new("ScreenGui"))

    --Disable replication for 3D-specific properties.
    self:DisableChangeReplication("RotationOffset")
    self.RotationOffset = CFrame.new()
    self:DisableChangeReplication("Depth")
    self.Depth = 5
    self:DisableChangeReplication("FieldOfView")
    self.FieldOfView = math.rad(50)
    self:DisableChangeReplication("CanvasSize")
    self.CanvasSize = Vector2.new(1000,1000)
    self:DisableChangeReplication("Easing")
    self.Easing = 0
end



return ScreenGui2D