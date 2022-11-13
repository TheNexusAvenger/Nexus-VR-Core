# VRPointer
(Extends `NexusInstance`)

!!! Warning
    `VRPointer` is deprecated and will be removed.

Visual for pointing at an object. Used
with [`VRPointing`](VRPointing.md) to
create pointers when updating where the
controllers are pointing.

## `static VRPointer VRPointer.new()`
Creates a `VRPointer`.

## `Vector3 VRPointer.StartPosition`
The start position of the pointer.

## `Vector3 VRPointer.EndPosition`
The end position of the pointer.

## `Color3 VRPointer.Color3`
The color of the pointer.

## `float VRPointer.Transparency`
The transparency of the pointer.

## `bool VRPointer.Visible`
Bool value for if the pointer is visible.

## `void VRPointer:SetFromCFrame(CFrame StartCFrame,float Distance)`
Sets the `StartPosition` and `EndPosition`
of the pointer given the start `CFrame` and
the distance to cover with the pointer.

## `void VRPointer:Destroy()`
Destroys the pointer.