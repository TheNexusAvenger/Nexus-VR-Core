# Custom Pointing Deprecation
With [Roblox VR pointing update released in March](https://devforum.roblox.com/t/roblox-vr-system-update/1584379)
and [Nexus VR Character Model V.2.2.1](https://github.com/TheNexusAvenger/Nexus-VR-Character-Model/releases/tag/V.2.2.1),
the decision has been made to deprecate Nexus VR Core's
custom pointing. The decision was made with the assumption
that most games don't integrate with Nexus VR Core and
Roblox's pointing functions "good enough" compared to
Nexus VR Core.

## Why Deprecated Custom Pointing?
Custom pointing in Nexus VR Core was developed for use with
Nexus VR Character Model. With V.2.2.1, it became unused,
but still enabled by default for backwards compatibility.
Keeping it around has a major performance cost in all games
with no evidence that any games manually specify custom pointing.

## Schedule
The long-term plan for Nexus VR Core is to completely
remove the pointing functionality. This will be done
in stages.
- November 15th, 2022: Nexus VR Core's pointing will
  be deprecated but not removed. Games that integrate
  with Nexus VR Core will get a deprecation warning.
- January 15th, 2023: Nexus VR Character Model
  will no longer automatically set up pointing.
  Games that need to use custom pointing after it
  is removed can run the following:
```lua
local NexusVRCore = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusVRCore"))
local VRPointing = NexusVRCore:GetResource("Interaction.VRPointing")
VRPointing:ConnectEvents()
VRPointing:RunUpdating()
```
- April 15th, 2023: `VRSurfaceGui`, `VRPart`, `VRPointer`,
  and `VRPointing` will be **removed**. `NexusWrappedInstance`
  will no longer be included. `ScreenGui2D` and `ScreenGui3D`
  will change to extending `NexusInstance` instead of
  `NexusWrappedInstance`.

## Migrating Away
With how Nexus VR Core was designed, migrating away should
be easy. The summary of the changes are:
- `NexusWrappedInstance.new` and `NexusWrappedInstance.GetInstance`
  have to be reverted back to `Instance.new`. `GetWrappedInstance`
  calls must be removed.
- `ScreenGui` (`ScreenGui2D` and `ScreenGui3D` internally) will
  no longer be able to be used as a parent for instances.
  `ScreenGui:GetContainer()` is the replacement.
- `VRPart` references need to be removed and any calls to the
  helper functions need to be moved to `PartUtility`.

For points 1 and 2, the following is an example of what
may be in use:
```lua
local NexusVRCore = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusVRCore"))

local ScreenGui = NexusVRCore:GetResource("Container.ScreenGui")
local NexusWrappedInstance = NexusVRCore:GetResource("NexusWrappedInstance")

local TestScreenGui = ScreenGui.new()
TestScreenGui.Name = "TestGui"
TestScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

local TestButton = NexusWrappedInstance.new("TextButton")
TestButton.Name = "TestButton"
TestButton.Size = UDim2.new(0,200,0,50)
TestButton.Position = UDim2.new(0,50,0,50)
TestButton.Parent = TestScreenGui

TestButton.MouseButton1Down:Connect(function()
    print("Button pressed!")
end)
```

And the following is the migrated version:
```lua
local NexusVRCore = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusVRCore"))

local ScreenGui = NexusVRCore:GetResource("Container.ScreenGui")
--NexusWrappedInstance reference removed

local TestScreenGui = ScreenGui.new()
TestScreenGui.Name = "TestGui"
TestScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

local TestButton = Instance.new("TextButton") --NexusWrappedInstance.new -> Instance.new
TestButton.Name = "TestButton"
TestButton.Size = UDim2.new(0,200,0,50)
TestButton.Position = UDim2.new(0,50,0,50)
TestButton.Parent = TestScreenGui:GetContainer() --TestScreenGui -> TestScreenGui:GetContainer()

TestButton.MouseButton1Down:Connect(function()
    print("Button pressed!")
end)
```

Point 3 is more difficult to migrate because of the `VRPart`
class being removed.
```lua
--Before
local NexusVRCore = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusVRCore"))
local VRPart = NexusVRCore:GetResource("Interaction.VRPart")

local Part = game.Workspace.Part
local TestVRPart = VRPart.new(Part)
print(VRPart:Project(Vector3.new(0, 20, 0), Enum.NormalId.Front))

--After
local NexusVRCore = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusVRCore"))
local PartUtility = NexusVRCore:GetResource("Utility.PartUtility")

local Part = game.Workspace.Part
print(VRPart:Project(Part, Vector3.new(0, 20, 0), Enum.NormalId.Front))
```