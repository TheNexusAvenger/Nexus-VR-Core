# ScreenGuis
The main improvement Nexus VR Core tries to make
is `ScreenGui`s, which are very limited with Roblox's
native VR integration.

## ScreenGui vs ScreenGui2D vs ScreenGui3D
When looking at the modules, `ScreenGui`, `ScreenGui2D`,
and `ScreenGui3D` all appear as options for `ScreenGui`
alternatives. `ScreenGui2D` is intended for non-VR users
while `ScreenGui3D` is intended for VR users. `ScreenGui`
returns either `ScreenGui2D` or `ScreenGui3D` depending
if VR is active or not. No special casing should be required
on the developer is most cases.

## Creating ScreenGuis
The process for creating `ScreenGui`s is close to the default
implementation for Roblox except for some additional
properties, such as:

* `RotationOffset` - Rotational offset that the ScreenGui
  appears, such as creating a HUD element at the edge of
  the VR user's vision.
* `Depth` - Depth that the user interface is displayed.
  This affects how the pointer appears and the layering
  of multiple UIs.
* `FieldOfView` - Angle in radians that the ScreenGui appears in.
* `CanvasSize` - Size in pixels the UI will be as a SurfaceGui.
* `Easing` - How slow the UI follows the user when turning.
  0 is default and results in the UI instantly appearing. Specific
  values to use require experimentation.
* `PointingEnabled` - Bool for whether pointing events are accepted.

Not all need to be changed, and the defaults may be fine
in a lot of cases. The following is an example of using them,
which will work with VR and non-VR.

```lua
local NexusVRCore = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusVRCore"))

local ScreenGui = NexusVRCore:GetResource("Container.ScreenGui")

local TestScreenGui = ScreenGui.new()
TestScreenGui.Name = "TestGui"
TestScreenGui.Easing = 0.2 --The UI will slowly follow VR users. No affect on non-VR players.
TestScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

local TestButton = Instance.new("TextButton")
TestButton.Name = "TestButton"
TestButton.Size = UDim2.new(0,200,0,50)
TestButton.Position = UDim2.new(0,50,0,50)
TestButton.Parent = TestScreenGui:GetContainer()

TestButton.MouseButton1Down:Connect(function()
    print("Button pressed!")
end)
```

Be aware that special casing may be required in some cases.
For example, a small button in the corner in a `ScreenGui`
covering the user's full field of view will prevent other UIs
behind it from being interactable.

```lua
local NexusVRCore = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusVRCore"))

local ScreenGui = NexusVRCore:GetResource("Container.ScreenGui")

local TestScreenGui = ScreenGui.new()
TestScreenGui.Name = "TestGui"
TestScreenGui.Easing = 0.2 --The UI will slowly follow VR users. No affect on non-VR players.
TestScreenGui.FieldOfView = math.rad(10) --Makes the UI take up less space in field of view. No affect on non-VR players.
TestScreenGui.RotationOffset = CFrame.Angles(math.rad(-15),math.rad(15),0) --Moves the UI to the bottom left of their field of view. No affect on non-VR players.
TestScreenGui.CanvasSize = Vector2.new(0,200,0,50) --Makes the UI only have the needed area for the button. No affect on non-VR players.
TestScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

local TestButton = Instance.new("TextButton")
TestButton.Name = "TestButton"
TestButton.Size = UDim2.new(0,200,0,50)
TestButton.Position = UDim2.new(0,50,0,50)
TestButton.Parent = TestScreenGui:GetContainer()

--Revert the position to the origin if the user is in VR.
if game:GetService("UserInputService").VREnabled then
  TestButton.Position = UDim2.new(0,0,0,0)
end

TestButton.MouseButton1Down:Connect(function()
    print("Button pressed!")
end)

```

## Existing ScreenGuis
!!! Warning
    The previous suggested changes for existing `ScreenGui`s
    has been removed due to the deprecation of `VRPointing`.