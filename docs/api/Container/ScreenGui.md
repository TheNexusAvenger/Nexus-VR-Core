# ScreenGui
(Extends `NexusWrappedInstance<Instance>`)

!!! Warning
    `NexusWrappedInstance` functionality will be removed in a
    future update. `GetContainer` should be used for parenting
    instances.

The `ScreenGui` class is a container class for
user interfaces that are not attached to a
part. The implementation depends on if the
user is using VR or not, but the properties
are the same. Be aware that in VR,
`ScreenGui.new():IsA("SurfaceGui")` will be
`true` and will be `false` in non-VR. The class
name will also either by `"ScreenGui2D"` or 
`"ScreenGui3D"`.

## `static ScreenGui ScreenGui.GetInstance(Instance ExistingInstance)`
Returns a `ScreenGui` for an existing instance. If the
existing instance is nil, a new `ScreenGui` is returned.

## `static ScreenGui ScreenGui.new()`
Creates a `ScreenGui`.

## `CFrame ScreenGui.RotationOffset`
The rotation that is applied to the `ScreenGui` for VR
users, such as for displaying the user interface
to the side of the user's field of view.

!!! Note
    This property only affects VR users. This property
    can be applied to non-VR users but will have no affect.

## `float ScreenGui.Depth`
How far away in studs the `ScreenGui` will appear. The distance
affects the ordering of the user interfaces, where lower depths
will on top of higher depths, and how the pointer appears.

!!! Note
    This property only affects VR users. This property
    can be applied to non-VR users but will have no affect.

## `float ScreenGui.FieldOfView`
The angle in radians that the `ScreenGui` will appear to a
VR user.

!!! Note
    This property only affects VR users. This property
    can be applied to non-VR users but will have no affect.

## `Vector2 ScreenGui.CanvasSize`
The canvas size to use for the `ScreenGui` for VR users since
it isn't tied to the size of the screen.

!!! Note
    This property only affects VR users. This property
    can be applied to non-VR users but will have no affect.

## `float ScreenGui.Easing`
The relative multiplier for how slowly the `ScreenGui` follows
the user when they turn their head in VR. `0` will result in
the `ScreenGui` always being locked in the same position
relative to their head, while a higher number will result in
the `ScreenGui` being slow to catch up. The values to use
may need to be found through experimentation.

!!! Note
    This property only affects VR users. This property
    can be applied to non-VR users but will have no affect.

## `bool ScreenGui.PointingEnabled`
If `true`, pointing by VR controllers will be performance
on the `ScreenGui` and the events will be fired. If `false`,
pointing will be ignored and user interfaces behind it will
be able to accept pointing.

!!! Note
    This property only affects VR users. This property
    can be applied to non-VR users but will have no affect.

## `Instance ScreenGui:GetContainer()`
Returns the container to parent instances to.