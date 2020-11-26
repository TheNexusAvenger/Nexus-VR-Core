--[[
TheNexusAvenger
Tests for NexusWrappedInstance.
--]]

local NexusUnitTesting = require("NexusUnitTesting")
local VRPart = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusVRCore"):WaitForChild("VRPart"))
local VRPartTest = NexusUnitTesting.UnitTest:Extend()



--[[
Sets up the test.
--]]
function VRPartTest:Setup()
    self.CuT = VRPart.new("Part")
    self.CuT.Size = Vector3.new(2,4,6)
end

--[[
Tears down the test.
--]]
function VRPartTest:Teardown()
    if self.CuT then
        self.CuT:Destroy()
    end
end

--[[
Asserts 3 values are close.
--]]
function VRPartTest:Assert3Values(Value1A,Value2A,Value3A,Value1B,Value2B,Value3B)
    self:AssertClose(Value1A,Value1B,0.001,"Value 1 isn't close.")
    self:AssertClose(Value2A,Value2B,0.001,"Value 2 isn't close.")
    self:AssertClose(Value3A,Value3B,0.001,"Value 3 isn't close.")
end

--[[
Tests the Raycast method.
--]]
NexusUnitTesting:RegisterUnitTest(VRPartTest.new("Raycast"):SetRun(function(self)
    --Assert the front is valid.
    self:Assert3Values(0.25,0.25,2,self.CuT:Raycast(CFrame.new(0.5,1,-5) * CFrame.Angles(0,math.pi,0),"Front"))
    self:Assert3Values(0.25,0.25,2,self.CuT:Raycast(CFrame.new(0.5,1,-3) * CFrame.Angles(0,math.rad(15),0) * CFrame.new(0,0,-2) * CFrame.Angles(0,math.pi,0),"Front"))
    self:Assert3Values(0.25,0.25,2,self.CuT:Raycast(CFrame.new(0.5,1,-3) * CFrame.Angles(math.rad(15),math.rad(15),0) * CFrame.new(0,0,-2) * CFrame.Angles(0,math.pi,0),"Front"))
    self:Assert3Values(0.25,0.25,-2,self.CuT:Raycast(CFrame.new(0.5,1,-3) * CFrame.Angles(math.rad(15),math.rad(15),0) * CFrame.new(0,0,-2),"Front"))

    --Assert the other sides are valid.
    --The same math is used, so only a single result for the other side is used.
    self:Assert3Values(0.25,0.25,2,self.CuT:Raycast(CFrame.new(Vector3.new(-0.5,1,5),Vector3.new(-0.5,1,3)),"Back"))
    self:Assert3Values(0.25,0.25,2,self.CuT:Raycast(CFrame.new(Vector3.new(-3,1,-1.5),Vector3.new(-1,1,-1.5)),"Left"))
    self:Assert3Values(0.25,0.25,2,self.CuT:Raycast(CFrame.new(Vector3.new(3,1,1.5),Vector3.new(1,1,1.5)),"Right"))
    self:Assert3Values(0.25,0.25,2,self.CuT:Raycast(CFrame.new(Vector3.new(-0.5,4,1.5),Vector3.new(-0.5,2,1.5)),"Top"))
    self:Assert3Values(0.25,0.25,2,self.CuT:Raycast(CFrame.new(Vector3.new(0.5,-4,1.5),Vector3.new(0.5,-2,1.5)),"Bottom"))
end))

--[[
Tests the Project method.
--]]
NexusUnitTesting:RegisterUnitTest(VRPartTest.new("Project"):SetRun(function(self)
    --Assert the front is valid.
    self:Assert3Values(-0.25,-0.25,2,self.CuT:Project(Vector3.new(1.5,3,-5),"Front"))
    self:Assert3Values(0,0,2,self.CuT:Project(Vector3.new(1,2,-5),"Front"))
    self:Assert3Values(0.25,0,2,self.CuT:Project(Vector3.new(0.5,2,-5),"Front"))
    self:Assert3Values(0.5,0,2,self.CuT:Project(Vector3.new(0,2,-5),"Front"))
    self:Assert3Values(0.75,0.,2,self.CuT:Project(Vector3.new(-0.5,2,-5),"Front"))
    self:Assert3Values(1,0,2,self.CuT:Project(Vector3.new(-1,2,-5),"Front"))
    self:Assert3Values(0,0.25,2,self.CuT:Project(Vector3.new(1,1,-5),"Front"))
    self:Assert3Values(0.25,0.25,2,self.CuT:Project(Vector3.new(0.5,1,-5),"Front"))
    self:Assert3Values(0.5,0.25,2,self.CuT:Project(Vector3.new(0,1,-5),"Front"))
    self:Assert3Values(0.75,0.25,2,self.CuT:Project(Vector3.new(-0.5,1,-5),"Front"))
    self:Assert3Values(1,0.25,2,self.CuT:Project(Vector3.new(-1,1,-5),"Front"))
    self:Assert3Values(0,0.75,2,self.CuT:Project(Vector3.new(1,-1,-5),"Front"))
    self:Assert3Values(0.25,0.75,2,self.CuT:Project(Vector3.new(0.5,-1,-5),"Front"))
    self:Assert3Values(0.5,0.75,2,self.CuT:Project(Vector3.new(0,-1,-5),"Front"))
    self:Assert3Values(0.75,0.75,2,self.CuT:Project(Vector3.new(-0.5,-1,-5),"Front"))
    self:Assert3Values(1,0.75,2,self.CuT:Project(Vector3.new(-1,-1,-5),"Front"))
    self:Assert3Values(1,0.75,3,self.CuT:Project(Vector3.new(-1,-1,-6),"Front"))
    self:Assert3Values(1,0.75,0,self.CuT:Project(Vector3.new(-1,-1,-3),"Front"))
    self:Assert3Values(1,0.75,-1,self.CuT:Project(Vector3.new(-1,-1,-2),"Front"))

    --Assert the other sides are valid.
    --The same math is used, so only a single result for the other side is used.
    self:Assert3Values(0.25,0.25,2,self.CuT:Project(Vector3.new(-0.5,1,5),"Back"))
    self:Assert3Values(0.25,0.25,2,self.CuT:Project(Vector3.new(-3,1,-1.5),"Left"))
    self:Assert3Values(0.25,0.25,2,self.CuT:Project(Vector3.new(3,1,1.5),"Right"))
    self:Assert3Values(0.25,0.25,2,self.CuT:Project(Vector3.new(-0.5,4,1.5),"Top"))
    self:Assert3Values(0.25,0.25,2,self.CuT:Project(Vector3.new(0.5,-4,1.5),"Bottom"))
end))



return true