--[[
TheNexusAvenger

Wraps a part for use with VR math.
--]]

local NexusVRCore = require(script.Parent.Parent)
local NexusWrappedInstance = NexusVRCore:GetResource("NexusWrappedInstance")
local PartUtility = NexusVRCore:GetResource("Utility.PartUtility")

local VRPart = NexusWrappedInstance:Extend()
VRPart:SetClassName("VRPart")
VRPart:CreateGetInstance()



--[[
Creates the VR part.
--]]
function VRPart:__new(ExistingPart)
    self:InitializeSuper(ExistingPart or Instance.new("Part"))
end

--[[
Helper function for ray casting.
--]]
function VRPart:RaycastToFront(AimingCFrame,Size,FrontCFrame)
    return PartUtility.RaycastToFront(AimingCFrame, Size, FrontCFrame)
end

--[[
Helper function for projecting.
--]]
function VRPart:ProjectToFront(Position,Size,FrontCFrame)
    return PartUtility.RaycastToFront(Position, Size, FrontCFrame)
end

--[[
Ray casts to a surface. Returns the relative X and Y position
of the face, and the Z for the direction (>0 is facing, <0
is not facing).
--]]
function VRPart:Raycast(AimingCFrame,Face)
    return PartUtility.Raycast(self, AimingCFrame, Face)
end

--[[
Returns the relative position that is projected onto the
plane. Returns the relative X and Y position of the face,
and the Z for the direction (>0 is before the plane, <0
is after the plane).
--]]
function VRPart:Project(HandPosition,Face)
    return PartUtility.Project(self, HandPosition,Face)
end



return VRPart