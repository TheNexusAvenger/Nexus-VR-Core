# Setup
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