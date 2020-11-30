--[[
TheNexusAvenger

Tests for VRPointing.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local NexusVRCore = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusVRCore"))
local VRSurfaceGui = NexusVRCore:GetResource("VRSurfaceGui")
local VRPointing = NexusVRCore:GetResource("VRPointing")
local VRPointingTest = NexusUnitTesting.UnitTest:Extend()



--[[
Sets up the test.
--]]
function VRPointingTest:Setup()
    self.SurfaceGuis = {}
end

--[[
Tears down the test.
--]]
function VRPointingTest:Teardown()
    for _,SurfaceGui in pairs(self.SurfaceGuis) do
        SurfaceGui:Destroy()
    end
end

--[[
Tests the UpdatePointers method.
--]]
NexusUnitTesting:RegisterUnitTest(VRPointingTest.new("UpdatePointers"):SetRun(function(self)
    --Create 2 overlapping SurfaceGuis and a SurfaceGui facing the opposite direction.
    local Part1 = Instance.new("Part")
    Part1.Size = Vector3.new(10,10,1)
    Part1.CFrame = CFrame.new(3,0,0.5)

    local SurfaceGui1 = VRSurfaceGui.GetInstance()
    SurfaceGui1.Name = "SurfaceGui1"
    SurfaceGui1.Face = Enum.NormalId.Back
    SurfaceGui1.Adornee = Part1
    table.insert(self.SurfaceGuis,SurfaceGui1)

    local Part2 = Instance.new("Part")
    Part2.Size = Vector3.new(10,10,1)
    Part2.CFrame = CFrame.new(-3,0,-0.5)

    local SurfaceGui2 = VRSurfaceGui.new()
    SurfaceGui2.Name = "SurfaceGui2"
    SurfaceGui2.Face = Enum.NormalId.Back
    SurfaceGui2.Parent = Part2
    table.insert(self.SurfaceGuis,SurfaceGui2)

    local Part3 = Instance.new("Part")
    Part3.Size = Vector3.new(10,10,1)
    Part3.CFrame = CFrame.new(0,0,5.5)

    local SurfaceGui3 = VRSurfaceGui.new()
    SurfaceGui3.Name = "SurfaceGui3"
    SurfaceGui3.Adornee = Part3
    table.insert(self.SurfaceGuis,SurfaceGui3)

    --Update the pointers and assert they are corret.
    VRPointing:UpdatePointers({CFrame.new(0,1,2)},{0.5})
    self:AssertClose(SurfaceGui1.LastInputs[1],Vector3.new(0.2,0.4,0.5),0.01)
    self:AssertEquals(SurfaceGui2.LastInputs,{})
    self:AssertEquals(SurfaceGui3.LastInputs,{})
    VRPointing:UpdatePointers({CFrame.new(-7,1,2)},{0.5})
    self:AssertClose(SurfaceGui1.LastInputs[1],Vector3.new(0.2,0.4,0.5),0.01)
    self:AssertClose(SurfaceGui2.LastInputs[1],Vector3.new(0.1,0.4,0.5),0.01)
    self:AssertEquals(SurfaceGui3.LastInputs,{})
    VRPointing:UpdatePointers({CFrame.new(-6,1,2),CFrame.new(1,1,2)},{0.4,0.6})
    self:AssertClose(SurfaceGui1.LastInputs[1],Vector3.new(0.3,0.4,0.6),0.01)
    self:AssertClose(SurfaceGui2.LastInputs[1],Vector3.new(0.2,0.4,0.4),0.01)
    self:AssertEquals(SurfaceGui3.LastInputs,{})
    VRPointing:UpdatePointers({CFrame.new(0,1,2) * CFrame.Angles(0,math.pi,0)},{0.5})
    self:AssertClose(SurfaceGui1.LastInputs[1],Vector3.new(0.3,0.4,0.6),0.01)
    self:AssertClose(SurfaceGui2.LastInputs[1],Vector3.new(0.2,0.4,0.4),0.01)
    self:AssertClose(SurfaceGui3.LastInputs[1],Vector3.new(0.5,0.4,0.5),0.01)
    VRPointing:UpdatePointers({CFrame.new(0,1,2) * CFrame.Angles(0,math.pi,0)},{0.5})
    self:AssertClose(SurfaceGui1.LastInputs[1],Vector3.new(0.3,0.4,0.6),0.01)
    self:AssertClose(SurfaceGui2.LastInputs[1],Vector3.new(0.2,0.4,0.4),0.01)
    self:AssertClose(SurfaceGui3.LastInputs[1],Vector3.new(0.5,0.4,0.5),0.01)
    VRPointing:UpdatePointers({CFrame.new(0,1,5 - 0.05) * CFrame.Angles(0,math.pi,0)},{0})
    self:AssertClose(SurfaceGui1.LastInputs[1],Vector3.new(0.3,0.4,0.6),0.01)
    self:AssertClose(SurfaceGui2.LastInputs[1],Vector3.new(0.2,0.4,0.4),0.01)
    self:AssertClose(SurfaceGui3.LastInputs[1],Vector3.new(0.5,0.4,0),0.01)
    self:AssertClose(SurfaceGui3.LastInputs[2],Vector3.new(0.5,0.4,0.5),0.01)
    VRPointing:UpdatePointers({CFrame.new(0,1,5) * CFrame.Angles(0,math.pi,0)},{0})
    self:AssertClose(SurfaceGui1.LastInputs[1],Vector3.new(0.3,0.4,0.6),0.01)
    self:AssertClose(SurfaceGui2.LastInputs[1],Vector3.new(0.2,0.4,0.4),0.01)
    self:AssertClose(SurfaceGui3.LastInputs[1],Vector3.new(0.5,0.4,0),0.01)
    self:AssertClose(SurfaceGui3.LastInputs[2],Vector3.new(0.5,0.4,1),0.01)
    VRPointing:UpdatePointers({CFrame.new(0,1,5.05) * CFrame.Angles(0,math.pi,0)},{0})
    self:AssertClose(SurfaceGui1.LastInputs[1],Vector3.new(0.3,0.4,0.6),0.01)
    self:AssertClose(SurfaceGui2.LastInputs[1],Vector3.new(0.2,0.4,0.4),0.01)
    self:AssertClose(SurfaceGui3.LastInputs[1],Vector3.new(0.5,0.4,1),0.01)
end))



return true