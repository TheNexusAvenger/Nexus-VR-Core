# VRPart
(Extends `NexusWrappedInstance<Part>`)

`VRPart` extends the part with additional
functions for math with VR controllers.
They are used internally for VR pointing,
but can be used on their own.

## `static VRPart VRPart.GetInstance(Instance ExistingInstance)`
Returns a `VRPart` for an existing instance. If the
existing instance is nil, a new `VRPart` is returned.

## `static VRPart VRPart.new()`
Creates a `VRPart`.

## `float,float,float VRPart:Raycast(CFrame AimingCFrame,Enum.NormalId Face)`
Ray casts to a surface. Returns the relative
X and Y position of the face, and the Z for
the direction (>0 is facing, <0 is not facing).

![Raycast Demo](../../diagrams/VRPartRaycastDemo.png)

## `float,float,float VRPart:Project(Vector3 HandPosition,Enum.NormalId Face)`
Returns the relative position that is projected
onto the plane. Returns the relative X and Y position
of the face, and the Z for the direction (>0 is
before the plane, <0 is after the plane).

![Project Demo](../../diagrams/VRPartProjectDemo.png)