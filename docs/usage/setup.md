# Setup
!!! note
    If Nexus VR Character Model V.2.0.0 or newer is being
    used, then no setup is required since it loads Nexus VR
    Core and sets up pointing natively. This page is intended
    for developers not using Nexus VR Character Model.

Nexus VR Core does not automatically run when set up correctly
as some users may not want components of the native implementation.

## Module Setup
It is recommended to put the `NexusVRCore` module in
`ReplicatedStorage`. The module can be downloaded as
a model file from the [GitHub Releases](https://github.com/TheNexusAvenger/Nexus-VR-Core/releases),
or built from the repository using [Rojo](https://github.com/rojo-rbx/rojo).

## Referencing Modules
Nexus VR Core's main module is an instance of
[Nexus Project](https://github.com/TheNexusAvenger/Nexus-Project).
Modules can be accessed using the normal indexing
methods, but it is recommended to use `GetResource`
for the main module.

```lua
local NexusVRCore = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusVRCore"))

local ScreenGui = NexusVRCore:GetResource("Container.ScreenGui") --Equivalent to require(game.ReplicatedStorage.NexusVRCore.Container.ScreenGui)
local ScreenGui = NexusVRCore:GetResource("Utility.PartUtility") --Equivalent to require(game.ReplicatedStorage.NexusVRCore.Utility.PartUtility)
...
```

## Pointing Setup
!!! Warning
    Pointing is deprecated in Nexus VR Core and will be removed in a future version.

For pointing to be set up, the controller events
need to be connected and the updating of where the
controllers are pointing needs to be started. This
can be done with the following `LocalScript`, ideally
in `PlayerScripts`.

```lua
local NexusVRCore = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusVRCore"))
local VRPointing = NexusVRCore:GetResource("Interaction.VRPointing")
VRPointing:ConnectEvents()
VRPointing:RunUpdating()
```

The order of the function calls does not matter, but
both are required since `ConnectEvents` connects the
triggers being pressed and released and `RunUpdating`
starts the updating of where the controllers are pointing.
Neither function yields, but `WaitForChild` and `GetResource`
can yield.