--[[
TheNexusAvenger

Tests for ScreenGui3D.
--]]

local Workspace = game:GetService("Workspace")

local NexusUnitTesting = require("NexusUnitTesting")

local NexusVRCore = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusVRCore"))
local ScreenGui3D = NexusVRCore:GetResource("Container.ScreenGui3D")
local ScreenGui3DTest = NexusUnitTesting.UnitTest:Extend()



--[[
Sets up the test.
--]]
function ScreenGui3DTest:Setup()
    self.CuT = ScreenGui3D.new()
    self.CuT.EventsToDisconnect[#self.CuT.EventsToDisconnect]:Disconnect()
end

--[[
Tears down the test.
--]]
function ScreenGui3DTest:Teardown()
    if self.CuT then
        self.CuT:Destroy()
    end
end

--[[
Tests the UpdateSize method.
--]]
NexusUnitTesting:RegisterUnitTest(ScreenGui3DTest.new("UpdateSize"):SetRun(function(self)
    --Determine the minimum part size (may not be 0.05 as it is right now).
    local Part = Instance.new("Part")
    Part.Size = Vector3.new(0,0,0)
    Part:Destroy()
    local MinPartSize = Part.Size.X

    --Assert the size is correct.
    self.CuT.FieldOfView = math.rad(60)
    self.CuT.CanvasSize = Vector2.new(500,500)
    self.CuT.Depth = 3 * math.sqrt(3)
    wait()
    self:AssertClose(self.CuT.Adornee.Size,Vector3.new(6,6,MinPartSize),0.05)
    self.CuT.Depth = 3
    wait()
    self:AssertClose(self.CuT.Adornee.Size,Vector3.new(6 / math.sqrt(3),6 / math.sqrt(3),MinPartSize),0.05)
    self.CuT.Depth = 3 * math.sqrt(3)
    wait()
    self:AssertClose(self.CuT.Adornee.Size,Vector3.new(6,6,MinPartSize),0.05)
    self.CuT.Depth = 6 * math.sqrt(3)
    wait()
    self:AssertClose(self.CuT.Adornee.Size,Vector3.new(12,12,MinPartSize),0.05)
    self.CuT.CanvasSize = Vector2.new(500,250)
    wait()
    self:AssertClose(self.CuT.Adornee.Size,Vector3.new(12,6,MinPartSize),0.05)
    self.CuT.CanvasSize = Vector2.new(250,500)
    wait()
    self:AssertClose(self.CuT.Adornee.Size,Vector3.new(6,12,MinPartSize),0.05)
end))

--[[
Tests the UpdateCFrame method.
--]]
NexusUnitTesting:RegisterUnitTest(ScreenGui3DTest.new("UpdateCFrame"):SetRun(function(self)
    --Assert updating with no easing results in the CFrame instantly changing.
    local CameraCFrame = Workspace.CurrentCamera:GetRenderCFrame()
    local CameraRotation = CFrame.new(CameraCFrame.Position):Inverse() * CameraCFrame
    local StartCFrame = CameraCFrame * CFrame.Angles(0,math.pi/2,0)

    --Assert updating with easing results in a movement to the destination.
    self.CuT.Easing = 0
    self.CuT.LastRotation = StartCFrame
    self.CuT:UpdateCFrame(0.1)
    self:AssertClose(self.CuT.LastRotation,CameraRotation,0.05)

    --Assert the frame is eased.
    self.CuT.Easing = 1
    self.CuT.LastRotation = StartCFrame
    for i = 1,10 do
        local ExpectedCFrame = StartCFrame:Lerp(CameraRotation,0.1)
        StartCFrame = ExpectedCFrame
        self.CuT:UpdateCFrame(0.1)
        self:AssertClose(self.CuT.LastRotation,ExpectedCFrame,0.05)
    end
end))



return true