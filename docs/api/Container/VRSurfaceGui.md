# VRSurfaceGui
(Extends `NexusWrappedInstance<SurfaceGui>`)

!!! Warning
    `VRSurfaceGui` is deprecated and will be removed.

The `VRSurfaceGui` class is a container class for
user interfaces that are attached to a part.

## `static VRSurfaceGui VRSurfaceGui.GetInstance(Instance ExistingInstance)`
Returns a `VRSurfaceGui` for an existing instance. If the
existing instance is nil, a new `VRSurfaceGui` is returned.

## `static VRSurfaceGui VRSurfaceGui.new()`
Creates a `VRSurfaceGui`.

## `bool VRSurfaceGui.PointingEnabled`
If `true`, pointing by VR controllers will be performance
on the `VRSurfaceGui` and the events will be fired. If `false`,
pointing will be ignored and user interfaces behind it will
be able to accept pointing.

!!! Note
    This property only affects VR users. This property
    can be applied to non-VR users but will have no affect.