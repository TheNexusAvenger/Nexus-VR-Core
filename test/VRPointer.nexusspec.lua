--[[
TheNexusAvenger

Tests for VRPart.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local NexusVRCore = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusVRCore"))
local VRPointer = NexusVRCore:GetResource("VRPointer")
local VRPointerTest = NexusUnitTesting.UnitTest:Extend()



--[[
Sets up the test.
--]]
function VRPointerTest:Setup()
    self.CuT = VRPointer.new()
end

--[[
Tears down the test.
--]]
function VRPointerTest:Teardown()
    if self.CuT then
        self.CuT:Destroy()
    end
end

--[[
Tests the SetFromCFrame method.
--]]
NexusUnitTesting:RegisterUnitTest(VRPointerTest.new("SetFromCFrame"):SetRun(function(self)
    self.CuT:SetFromCFrame(CFrame.new(0,10,0),10)
    self:AssertClose(self.CuT.StartPosition,Vector3.new(0,10,0),0.01,"Start isn't correct.")
    self:AssertClose(self.CuT.EndPosition,Vector3.new(0,10,-10),0.01,"End isn't correct.")
    self.CuT:SetFromCFrame(CFrame.new(0,10,0) * CFrame.Angles(math.rad(45),0,0),10 * math.sqrt(2))
    self:AssertClose(self.CuT.StartPosition,Vector3.new(0,10,0),0.01,"Start isn't correct.")
    self:AssertClose(self.CuT.EndPosition,Vector3.new(0,20,-10),0.01,"End isn't correct.")
    self.CuT:SetFromCFrame(CFrame.new(0,10,0),0)
    self:AssertClose(self.CuT.StartPosition,Vector3.new(0,10,0),0.01,"Start isn't correct.")
    self:AssertClose(self.CuT.EndPosition,Vector3.new(0,10,0),0.01,"End isn't correct.")
end))

--[[
Tests the Transparency properties.
--]]
NexusUnitTesting:RegisterUnitTest(VRPointerTest.new("Transparency"):SetRun(function(self)
    --Assert the transparency is correct for a long pointer.
    self.CuT.StartPosition = Vector3.new(0,10,0)
    self.CuT.EndPosition = Vector3.new(0,10,10)
    self.CuT.Transparency = 0.25
    self:AssertEquals(self.CuT.EndSphere.Transparency,0.25,"Sphere transparency is incorrect.")
    self:AssertEquals(self.CuT.Beam.Transparency,NumberSequence.new({
        NumberSequenceKeypoint.new(0,1),
        NumberSequenceKeypoint.new(0.2,0.25),
        NumberSequenceKeypoint.new(0.8,0.25),
        NumberSequenceKeypoint.new(1,1),
    }),"Beam transparency is incorrect.")
    self.CuT.Transparency = 0.5
    self:AssertEquals(self.CuT.EndSphere.Transparency,0.5,"Sphere transparency is incorrect.")
    self:AssertEquals(self.CuT.Beam.Transparency,NumberSequence.new({
        NumberSequenceKeypoint.new(0,1),
        NumberSequenceKeypoint.new(0.2,0.5),
        NumberSequenceKeypoint.new(0.8,0.5),
        NumberSequenceKeypoint.new(1,1),
    }),"Beam transparency is incorrect.")

    --Assert the transparency is correct for a short pointer.
    self.CuT.StartPosition = Vector3.new(0,10,0)
    self.CuT.EndPosition = Vector3.new(0,10,2)
    self.CuT.Transparency = 0.25
    self:AssertEquals(self.CuT.EndSphere.Transparency,0.25,"Sphere transparency is incorrect.")
    self:AssertEquals(self.CuT.Beam.Transparency,NumberSequence.new({
        NumberSequenceKeypoint.new(0,1),
        NumberSequenceKeypoint.new(0.5,0.625),
        NumberSequenceKeypoint.new(1,1),
    }),"Beam transparency is incorrect.")
    self.CuT.Transparency = 0.5
    self:AssertEquals(self.CuT.EndSphere.Transparency,0.5,"Sphere transparency is incorrect.")
    self:AssertEquals(self.CuT.Beam.Transparency,NumberSequence.new({
        NumberSequenceKeypoint.new(0,1),
        NumberSequenceKeypoint.new(0.5,0.75),
        NumberSequenceKeypoint.new(1,1),
    }),"Beam transparency is incorrect.")
end))



return true