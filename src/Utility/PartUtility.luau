--Utility for parts.

local PartUtility = {}



--[[
Helper function for ray casting.
--]]
function PartUtility.RaycastToFront(AimingCFrame: CFrame, Size: Vector3, FrontCFrame: CFrame): (number, number, number)
    FrontCFrame = FrontCFrame * CFrame.new(0, 0, -Size.Z / 2)

    --Convert the aiming CFrame to a local CFrame.
	local LocalTargetCFrame = FrontCFrame:Inverse() * AimingCFrame
	local LocalTarget = LocalTargetCFrame.LookVector
	
	--Determine the angle away from the normal and cast the ray to the plane.
	local LookAngle = math.atan2(((LocalTarget.X ^ 2) + (LocalTarget.Y ^ 2)) ^ 0.5, LocalTarget.Z)
	local DistanceToScreen = LocalTargetCFrame.Z / math.cos(LookAngle)
	local LocalHitPosition = (LocalTargetCFrame * CFrame.new(0, 0, DistanceToScreen)).Position
	
	--Determine and return the relative positions.
	local RelativeX = 1 - (0.5 + (LocalHitPosition.X / Size.X))
	local RelativeY = 1 - (0.5 + (LocalHitPosition.Y / Size.Y))
    local Depth = -LocalTargetCFrame.Z * (1 / LocalTarget.Z)
	return RelativeX, RelativeY, Depth
end

--[[
Helper function for projecting.
--]]
function PartUtility.ProjectToFront(Position: Vector3, Size: Vector3, FrontCFrame: CFrame): (number, number, number)
    FrontCFrame = FrontCFrame * CFrame.new(0, 0, -Size.Z / 2)
	
	--Convert the aiming CFrame to a local CFrame.
	local LocalTargetCFrame = FrontCFrame:Inverse() * CFrame.new(Position)
	
	--Determine and return the relative positions.
	local RelativeX = 1 - (0.5 + (LocalTargetCFrame.X / Size.X))
	local RelativeY = 1 - (0.5 + (LocalTargetCFrame.Y / Size.Y))
	local Depth = -LocalTargetCFrame.Z
	return RelativeX, RelativeY, Depth
end

--[[
Ray casts to a surface. Returns the relative X and Y position
of the face, and the Z for the direction (>0 is facing, <0
is not facing).
--]]
function PartUtility.Raycast(Part: BasePart, AimingCFrame: CFrame, Face: Enum.NormalId | string): (number, number, number)
    local Size = Part.Size
    if Face == Enum.NormalId.Front or Face == "Front" then
        return PartUtility.RaycastToFront(AimingCFrame, Size, Part.CFrame)
    elseif Face == Enum.NormalId.Back or Face == "Back" then
        return PartUtility.RaycastToFront(AimingCFrame, Size, Part.CFrame * CFrame.Angles(0, math.pi, 0))
    elseif Face == Enum.NormalId.Top or Face == "Top" then
        local RelativeX, RelativeY, Depth = PartUtility.RaycastToFront(AimingCFrame, Vector3.new(Size.X, Size.Z, Size.Y), Part.CFrame * CFrame.Angles(math.pi / 2, 0, 0))
        return 1 - RelativeX, RelativeY, Depth
    elseif Face == Enum.NormalId.Bottom or Face == "Bottom" then
        local RelativeX, RelativeY, Depth = PartUtility.RaycastToFront(AimingCFrame, Vector3.new(Size.X, Size.Z, Size.Y), Part.CFrame * CFrame.Angles(-math.pi / 2, 0, 0))
        return RelativeX, 1 - RelativeY, Depth
    elseif Face == Enum.NormalId.Left or Face == "Left" then
        return PartUtility.RaycastToFront(AimingCFrame, Vector3.new(Size.Z, Size.Y, Size.X), Part.CFrame * CFrame.Angles(0, math.pi / 2, 0))
    elseif Face == Enum.NormalId.Right or Face == "Right" then
        return PartUtility.RaycastToFront(AimingCFrame, Vector3.new(Size.Z, Size.Y, Size.X), Part.CFrame * CFrame.Angles(0, -math.pi / 2, 0))
    end
    error("Unknown face type: "..tostring(Face))
end

--[[
Returns the relative position that is projected onto the
plane. Returns the relative X and Y position of the face,
and the Z for the direction (>0 is before the plane, <0
is after the plane).
--]]
function PartUtility.Project(Part: BasePart, HandPosition: Vector3, Face: Enum.NormalId | string): (number, number, number)
    local Size = Part.Size
    if Face == Enum.NormalId.Front or Face == "Front" then
        return PartUtility.ProjectToFront(HandPosition, Size, Part.CFrame)
    elseif Face == Enum.NormalId.Back or Face == "Back" then
        return PartUtility.ProjectToFront(HandPosition, Size, Part.CFrame * CFrame.Angles(0, math.pi, 0))
    elseif Face == Enum.NormalId.Top or Face == "Top" then
        local RelativeX, RelativeY, Depth = PartUtility.ProjectToFront(HandPosition, Vector3.new(Size.X, Size.Z, Size.Y), Part.CFrame * CFrame.Angles(math.pi / 2, 0, 0))
        return 1 - RelativeX, RelativeY, Depth
    elseif Face == Enum.NormalId.Bottom or Face == "Bottom" then
        local RelativeX, RelativeY, Depth = PartUtility.ProjectToFront(HandPosition, Vector3.new(Size.X, Size.Z, Size.Y), Part.CFrame * CFrame.Angles(-math.pi / 2, 0, 0))
        return RelativeX, 1 - RelativeY, Depth
    elseif Face == Enum.NormalId.Left or Face == "Left" then
        return PartUtility.ProjectToFront(HandPosition, Vector3.new(Size.Z, Size.Y, Size.X), Part.CFrame * CFrame.Angles(0, math.pi / 2, 0))
    elseif Face == Enum.NormalId.Right or Face == "Right" then
        return PartUtility.ProjectToFront(HandPosition, Vector3.new(Size.Z, Size.Y, Size.X), Part.CFrame * CFrame.Angles(0, -math.pi / 2, 0))
    end
    error("Unknown face type: "..tostring(Face))
end



return PartUtility