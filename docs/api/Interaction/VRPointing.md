# VRPointing
(Extends `NexusInstance`)

Manages pointing at [`VRSurfaceGui`](../Container/VRSurfaceGui.md)s,
[`ScreenGui`](../Container/ScreenGui.md)s, and `ClickDetector`s.

!!! warning
    `VRPointing` is not intended with being instantiated. All
    functions and properties should be changed directly on `VRPointing`.

## `static bool VRPointing.PointersEnabled`
If `true`, [`VRPointer`](VRPointer.md)s will be created when
pointing.

## `static void VRPointing:UpdatePointers(List<CFrames> CFrames,List<float> PressedValues)
Invokes the events for the given inputs.

## `static List<CFrames>,List<float> VRPointing:GetVRInputs()`
Returns the CFrames and inputs for the VR service.

## `static void VRPointing:ConnectEvents()`
Connects the inputs for VR inputs.

## `static void VRPointing:RunUpdating()`
Runs updating pointing.