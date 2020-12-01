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
    self.FieldOfView = 50
    self:DisableChangeReplication("CanvasSize")
    self.Depth = Vector2.new(1000,1000)
end



return ScreenGui2D