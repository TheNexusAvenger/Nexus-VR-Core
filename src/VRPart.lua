--[[
TheNexusAvenger

Wraps a part for use with VR math.
--]]

local NexusWrappedInstance = require(script.Parent:WaitForChild("NexusWrappedInstance"))

local VRPart = NexusWrappedInstance:Extend()
VRPart:SetClassName("VRPart")



--[[
Gets a VR Part.
--]]
function VRPart.GetInstance(ExistingPart)
	--Create the string instance or create the cached instance if needed.
	local CachedInstance = NexusWrappedInstance.CachedInstances[ExistingPart]
	if not CachedInstance then
		CachedInstance = VRPart.new(ExistingPart)
	end
	
	--Return the cached entry.
	return CachedInstance
end

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
    FrontCFrame = FrontCFrame * CFrame.new(0,0,-Size.Z/2)

    --Convert the aiming CFrame to a local CFrame.
	local LocalTargetCFrame = FrontCFrame:inverse() * AimingCFrame
	local LocalTarget = LocalTargetCFrame.LookVector
	
	--Determine the angle away from the normal and cast the ray to the plane.
	local LookAngle = math.atan2(((LocalTarget.X ^ 2) + (LocalTarget.Y ^ 2)) ^ 0.5,LocalTarget.Z)
	local DistanceToScreen = LocalTargetCFrame.Z / math.cos(LookAngle)
	local LocalHitPosition = (LocalTargetCFrame * CFrame.new(0,0,DistanceToScreen)).p
	
	--Determine and return the relative positions.
	local RelativeX = 1 - (0.5 + (LocalHitPosition.X/Size.X))
	local RelativeY = 1 - (0.5 + (LocalHitPosition.Y/Size.Y))
    local Depth = -LocalTargetCFrame.Z * (1/LocalTarget.Z)
	return RelativeX,RelativeY,Depth
end

--[[
Helper function for projecting.
--]]
function VRPart:ProjectToFront(Position,Size,FrontCFrame)
    FrontCFrame = FrontCFrame * CFrame.new(0,0,-Size.Z/2)
	
	--Convert the aiming CFrame to a local CFrame.
	local LocalTargetCFrame = FrontCFrame:inverse() * CFrame.new(Position)
	
	--Determine and return the relative positions.
	local RelativeX = 1 - (0.5 + (LocalTargetCFrame.X/Size.X))
	local RelativeY = 1 - (0.5 + (LocalTargetCFrame.Y/Size.Y))
	local Depth = -LocalTargetCFrame.Z
	return RelativeX,RelativeY,Depth
end

--[[
Ray casts to a surface. Returns the relative X and Y position
of the face, and the Z for the direction (>0 is facing, <0
is not facing).
--]]
function VRPart:Raycast(AimingCFrame,Face)
    local Size = self.Size
    if Face == Enum.NormalId.Front or Face == "Front" then
        return self:RaycastToFront(AimingCFrame,Size,self.CFrame)
    elseif Face == Enum.NormalId.Back or Face == "Back" then
        return self:RaycastToFront(AimingCFrame,Size,self.CFrame * CFrame.Angles(0,math.pi,0))
    elseif Face == Enum.NormalId.Top or Face == "Top" then
        local RelativeX,RelativeY,Depth = self:RaycastToFront(AimingCFrame,Vector3.new(Size.X,Size.Z,Size.Y),self.CFrame * CFrame.Angles(math.pi/2,0,0))
        return 1 - RelativeX,RelativeY,Depth
    elseif Face == Enum.NormalId.Bottom or Face == "Bottom" then
        local RelativeX,RelativeY,Depth = self:RaycastToFront(AimingCFrame,Vector3.new(Size.X,Size.Z,Size.Y),self.CFrame * CFrame.Angles(-math.pi/2,0,0))
        return RelativeX,1 - RelativeY,Depth
    elseif Face == Enum.NormalId.Left or Face == "Left" then
        return self:RaycastToFront(AimingCFrame,Vector3.new(Size.Z,Size.Y,Size.X),self.CFrame * CFrame.Angles(0,math.pi/2,0))
    elseif Face == Enum.NormalId.Right or Face == "Right" then
        return self:RaycastToFront(AimingCFrame,Vector3.new(Size.Z,Size.Y,Size.X),self.CFrame * CFrame.Angles(0,-math.pi/2,0))
    end
end

--[[
Returns the relative position that is projected onto the
plane. Returns the relative X and Y position of the face,
and the Z for the direction (>0 is before the plane, <0
is after the plane).
--]]
function VRPart:Project(HandPosition,Face)
    local Size = self.Size
    if Face == Enum.NormalId.Front or Face == "Front" then
        return self:ProjectToFront(HandPosition,Size,self.CFrame)
    elseif Face == Enum.NormalId.Back or Face == "Back" then
        return self:ProjectToFront(HandPosition,Size,self.CFrame * CFrame.Angles(0,math.pi,0))
    elseif Face == Enum.NormalId.Top or Face == "Top" then
        local RelativeX,RelativeY,Depth = self:ProjectToFront(HandPosition,Vector3.new(Size.X,Size.Z,Size.Y),self.CFrame * CFrame.Angles(math.pi/2,0,0))
        return 1 - RelativeX,RelativeY,Depth
    elseif Face == Enum.NormalId.Bottom or Face == "Bottom" then
        local RelativeX,RelativeY,Depth = self:ProjectToFront(HandPosition,Vector3.new(Size.X,Size.Z,Size.Y),self.CFrame * CFrame.Angles(-math.pi/2,0,0))
        return RelativeX,1 - RelativeY,Depth
    elseif Face == Enum.NormalId.Left or Face == "Left" then
        return self:ProjectToFront(HandPosition,Vector3.new(Size.Z,Size.Y,Size.X),self.CFrame * CFrame.Angles(0,math.pi/2,0))
    elseif Face == Enum.NormalId.Right or Face == "Right" then
        return self:ProjectToFront(HandPosition,Vector3.new(Size.Z,Size.Y,Size.X),self.CFrame * CFrame.Angles(0,-math.pi/2,0))
    end
end



return VRPart