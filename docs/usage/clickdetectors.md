# ClickDetectors
`ClickDetector`s are also supported in Nexus VR Core,
and are on-par with the `SurfaceGui`'s usage from a 
developer standpoint. Unlike `ScreenGui` and `SurfaceGui`,
there is no dedicated class. `NexusWrappedInstance` should
be used directly for them.

```lua
local NexusVRCore = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusVRCore"))

local NexusWrappedInstance = NexusVRCore:GetResource("NexusWrappedInstance")

--New ClickDetector.
local ClickDetector = NexusWrappedInstance.new("ClickDetector")
ClickDetector.Parent = game:GetService("Workspace"):WaitForChild("SomePart")

--Existing ClickDetector.
local ClickDetector = NexusWrappedInstance.GetInstancee(game:GetService("Workspace"):WaitForChild("SomePart"):WaitForChild("ClickDetector"))

TestButton.MouseClick:Connect(function()
    print("Button pressed!")
end)
```

For ClickDetectors, be aware that `ClickDetector`s under
the `Workspace`'s `Camera` will never be invoked and
`RightMouseClick` is never used in VR.