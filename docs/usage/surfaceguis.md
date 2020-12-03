# SurfaceGuis
Like `ScreenGui`s, Nexus VR Core tries to improve
`SurfaceGui`s. Unlike `ScreenGui`s, less functionality
is added beyond pointing and the `PointingEnabled`
property also found in the `ScreenGui`s. Most of what
is covered in `SurfaceGui`s can be found in [`ScreenGuis`](screenguis.md).

## Creating SurfaceGuis
Creating `SurfaceGui`s is nearly identical to Roblox's
default implementation.

```lua
local NexusVRCore = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusVRCore"))

local VRSurfaceGui = NexusVRCore:GetResource("Container.VRSurfaceGui")
local NexusWrappedInstance = NexusVRCore:GetResource("NexusWrappedInstance")

local TestPart = Instance.new("Part") --Can also use VRPart.new(). Do NOT use NexusWrappedInstance.new("Part")
TestPart.Name = "TestPart"
TestPart.Parent = game:GetService("Workspace")

local TestSurfaceGui = VRSurfaceGui.new()
TestSurfaceGui.Name = "TestGui"
TestSurfaceGui.Adornee = TestPart
TestSurfaceGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

local TestButton = NexusWrappedInstance.new("TextButton")
TestButton.Name = "TestButton"
TestButton.Size = UDim2.new(0,200,0,50)
TestButton.Position = UDim2.new(0,50,0,50)
TestButton.Parent = TestScreenGui

TestButton.MouseButton1Down:Connect(function()
    print("Button pressed!")
end)
```

## Existing SurfaceGuis
Using existing `SurfaceGui`s is identical to the
process for `ScreenGui`s.

```lua
local NexusVRCore = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusVRCore"))

local VRSurfaceGui = NexusVRCore:GetResource("Container.VRSurfaceGui")
local TestSurfaceGui = VRSurfaceGui.GetInstance(game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("TestGui"))
local TestButton = TestSurfaceGui:WaitForChild("TestButton")

--Since TestSurfaceGui is wrapped, TestButton is also wrapped when indexed.
--TestSurfaceGui.TestButton and TestSurfaceGui:FindFirstChild("TestButton") also work.
TestButton.MouseButton1Down:Connect(function()
    print("Button pressed!")
end)
```