--[[
TheNexusAvenger

Tests for VRPointing.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local NexusVRCore = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusVRCore"))
local NexusWrappedInstance = NexusVRCore:GetResource("NexusWrappedInstance")
local VRSurfaceGui = NexusVRCore:GetResource("Container.VRSurfaceGui")
local VRPointing = NexusVRCore:GetResource("Interaction.VRPointing")
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
    for _,Pointer in pairs(VRPointing.VRPointers) do
        Pointer:Destroy()
    end
end

--[[
Tests the UpdatePointers method.
--]]
NexusUnitTesting:RegisterUnitTest(VRPointingTest.new("UpdatePointers"):SetRun(function(self)
    --Create 2 overlapping SurfaceGuis and a SurfaceGui facing the opposite direction.
    local Part1 = Instance.new("Part")
    Part1.Transparency = 0.5
    Part1.Size = Vector3.new(10,10,1)
    Part1.CFrame = CFrame.new(3,0,0.5)
    Part1.Archivable = false
    Part1.Parent = Workspace
    table.insert(self.SurfaceGuis,Part1)

    local SurfaceGui1 = VRSurfaceGui.GetInstance()
    SurfaceGui1.Name = "SurfaceGui1"
    SurfaceGui1.Face = Enum.NormalId.Back
    SurfaceGui1.Adornee = Part1
    SurfaceGui1.Archivable = false
    SurfaceGui1.Parent = Workspace
    table.insert(self.SurfaceGuis,SurfaceGui1)

    local Part2 = Instance.new("Part")
    Part2.Transparency = 0.5
    Part2.Size = Vector3.new(10,10,1)
    Part2.CFrame = CFrame.new(-3,0,-0.5)
    Part2.Archivable = false
    Part2.Parent = Workspace
    table.insert(self.SurfaceGuis,Part2)

    local SurfaceGui2 = VRSurfaceGui.new()
    SurfaceGui2.Name = "SurfaceGui2"
    SurfaceGui2.Face = Enum.NormalId.Back
    SurfaceGui2.Parent = Part2
    SurfaceGui2.Archivable = false
    table.insert(self.SurfaceGuis,SurfaceGui2)

    local Part3 = Instance.new("Part")
    Part3.Transparency = 0.5
    Part3.Size = Vector3.new(10,10,1)
    Part3.CFrame = CFrame.new(0,0,5.5)
    Part3.Archivable = false
    Part3.Parent = Workspace
    table.insert(self.SurfaceGuis,Part3)

    local SurfaceGui3 = VRSurfaceGui.new()
    SurfaceGui3.Name = "SurfaceGui3"
    SurfaceGui3.Adornee = Part3
    SurfaceGui3.Archivable = false
    SurfaceGui3.Parent = Workspace
    table.insert(self.SurfaceGuis,SurfaceGui3)

    --Update the pointers and assert they are correct.
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

    --Assert disabled SurfaceGuis don't allow pointing.
    SurfaceGui1.LastInputs,SurfaceGui2.LastInputs,SurfaceGui3.LastInputs = {},{},{}
    SurfaceGui1.Enabled = false
    VRPointing:UpdatePointers({CFrame.new(0,1,2)},{0.5})
    self:AssertEquals(SurfaceGui1.LastInputs,{})
    self:AssertClose(SurfaceGui2.LastInputs[1],Vector3.new(0.8,0.4,0.5),0.01)
    self:AssertEquals(SurfaceGui3.LastInputs,{})
    SurfaceGui1.LastInputs,SurfaceGui2.LastInputs,SurfaceGui3.LastInputs = {},{},{}
    SurfaceGui1.Enabled = true
    SurfaceGui1.PointingEnabled = false
    VRPointing:UpdatePointers({CFrame.new(0,1,2)},{0.5})
    self:AssertEquals(SurfaceGui1.LastInputs,{})
    self:AssertClose(SurfaceGui2.LastInputs[1],Vector3.new(0.8,0.4,0.5),0.01)
    self:AssertEquals(SurfaceGui3.LastInputs,{})
    SurfaceGui1.PointingEnabled = true

    --Assert enabling and disabling pointers is correct.
    self:AssertEquals(#VRPointing.VRPointers,2,"Total pointers isn't correct.")
    VRPointing.PointersEnabled = false
    VRPointing:UpdatePointers({CFrame.new(0,1,2),CFrame.new(1,1,2)},{0.5,0.5})
    self:AssertEquals(#VRPointing.VRPointers,0,"Total pointers isn't correct.")
    VRPointing.PointersEnabled = true
    VRPointing:UpdatePointers({CFrame.new(0,1,2),CFrame.new(1,1,2)},{0.5,0.5})
    self:AssertEquals(#VRPointing.VRPointers,2,"Total pointers isn't correct.")
end))

--[[
Tests the UpdatePointers method with ClickDetectors.
--]]
NexusUnitTesting:RegisterUnitTest(VRPointingTest.new("UpdatePointersClickDetectors"):SetRun(function(self)
    --Create 2 overlapping parts. 1 with a SurfaceGui and 1 with a ClickDetector.
    local Part1 = Instance.new("Part")
    Part1.Transparency = 0.5
    Part1.Size = Vector3.new(10,10,1)
    Part1.CFrame = CFrame.new(3,0,0.5)
    Part1.Archivable = false
    Part1.Parent = Workspace
    table.insert(self.SurfaceGuis,Part1)

    local SurfaceGui1 = VRSurfaceGui.GetInstance()
    SurfaceGui1.Name = "SurfaceGui1"
    SurfaceGui1.Face = Enum.NormalId.Back
    SurfaceGui1.Adornee = Part1
    SurfaceGui1.Archivable = false
    SurfaceGui1.Parent = Workspace
    table.insert(self.SurfaceGuis,SurfaceGui1)

    local Part2 = Instance.new("Part")
    Part2.Transparency = 0.5
    Part2.Size = Vector3.new(10,10,1)
    Part2.CFrame = CFrame.new(-3,0,-0.5)
    Part2.Archivable = false
    Part2.Parent = Workspace
    table.insert(self.SurfaceGuis,Part2)

    local ClickDetector = NexusWrappedInstance.new("ClickDetector")
    ClickDetector.MaxActivationDistance = 5
    ClickDetector.Parent = Part2
    ClickDetector.Archivable = false
    table.insert(self.SurfaceGuis,ClickDetector)

    --Connect the ClickDetector events.
    local MouseHoverEnterEvents,MouseHoverLeaveEvents,MouseClickEvents = 0,0,0
    ClickDetector.MouseHoverEnter:Connect(function()
        MouseHoverEnterEvents = MouseHoverEnterEvents + 1
    end)
    ClickDetector.MouseHoverLeave:Connect(function()
        MouseHoverLeaveEvents = MouseHoverLeaveEvents + 1
    end)
    ClickDetector.MouseClick:Connect(function()
        MouseClickEvents = MouseClickEvents + 1
    end)

    --Update the pointers and assert they are correct.
    VRPointing:UpdatePointers({CFrame.new(0,1,2)},{0.4})
    wait()
    self:AssertEquals(MouseHoverEnterEvents,0,"Mouse enter events are incorrect.")
    self:AssertEquals(MouseHoverLeaveEvents,0,"Mouse leave events are incorrect.")
    self:AssertEquals(MouseClickEvents,0,"Mouse click events are incorrect.")
    VRPointing:UpdatePointers({CFrame.new(-7,1,2)},{0.4})
    wait()
    self:AssertEquals(MouseHoverEnterEvents,1,"Mouse enter events are incorrect.")
    self:AssertEquals(MouseHoverLeaveEvents,0,"Mouse leave events are incorrect.")
    self:AssertEquals(MouseClickEvents,0,"Mouse click events are incorrect.")
    VRPointing:UpdatePointers({CFrame.new(-7,1,2)},{0.8})
    wait()
    self:AssertEquals(MouseHoverEnterEvents,1,"Mouse enter events are incorrect.")
    self:AssertEquals(MouseHoverLeaveEvents,0,"Mouse leave events are incorrect.")
    self:AssertEquals(MouseClickEvents,1,"Mouse click events are incorrect.")
    VRPointing:UpdatePointers({CFrame.new(-7,1,2)},{0.9})
    wait()
    self:AssertEquals(MouseHoverEnterEvents,1,"Mouse enter events are incorrect.")
    self:AssertEquals(MouseHoverLeaveEvents,0,"Mouse leave events are incorrect.")
    self:AssertEquals(MouseClickEvents,1,"Mouse click events are incorrect.")
    VRPointing:UpdatePointers({CFrame.new(-7,1,2)},{0.4})
    wait()
    self:AssertEquals(MouseHoverEnterEvents,1,"Mouse enter events are incorrect.")
    self:AssertEquals(MouseHoverLeaveEvents,0,"Mouse leave events are incorrect.")
    self:AssertEquals(MouseClickEvents,1,"Mouse click events are incorrect.")
    VRPointing:UpdatePointers({CFrame.new(-7,1,2)},{0.8})
    wait()
    self:AssertEquals(MouseHoverEnterEvents,1,"Mouse enter events are incorrect.")
    self:AssertEquals(MouseHoverLeaveEvents,0,"Mouse leave events are incorrect.")
    self:AssertEquals(MouseClickEvents,2,"Mouse click events are incorrect.")
    VRPointing:UpdatePointers({CFrame.new(0,1,2)},{0.4})
    wait()
    self:AssertEquals(MouseHoverEnterEvents,1,"Mouse enter events are incorrect.")
    self:AssertEquals(MouseHoverLeaveEvents,1,"Mouse leave events are incorrect.")
    self:AssertEquals(MouseClickEvents,2,"Mouse click events are incorrect.")
    VRPointing:UpdatePointers({CFrame.new(-7,1,2)},{0.8})
    wait()
    self:AssertEquals(MouseHoverEnterEvents,2,"Mouse enter events are incorrect.")
    self:AssertEquals(MouseHoverLeaveEvents,1,"Mouse leave events are incorrect.")
    self:AssertEquals(MouseClickEvents,3,"Mouse click events are incorrect.")
    VRPointing:UpdatePointers({CFrame.new(-7,1,6)},{0.8})
    wait()
    self:AssertEquals(MouseHoverEnterEvents,2,"Mouse enter events are incorrect.")
    self:AssertEquals(MouseHoverLeaveEvents,2,"Mouse leave events are incorrect.")
    self:AssertEquals(MouseClickEvents,3,"Mouse click events are incorrect.")
    VRPointing:UpdatePointers({CFrame.new(0,1,2)},{0.4})
    wait()
    self:AssertEquals(MouseHoverEnterEvents,2,"Mouse enter events are incorrect.")
    self:AssertEquals(MouseHoverLeaveEvents,2,"Mouse leave events are incorrect.")
    self:AssertEquals(MouseClickEvents,3,"Mouse click events are incorrect.")
    Part2.CFrame = CFrame.new(-3,0,1.5)
    VRPointing:UpdatePointers({CFrame.new(0,1,3)},{0.4})
    wait()
    self:AssertEquals(MouseHoverEnterEvents,3,"Mouse enter events are incorrect.")
    self:AssertEquals(MouseHoverLeaveEvents,2,"Mouse leave events are incorrect.")
    self:AssertEquals(MouseClickEvents,3,"Mouse click events are incorrect.")
end))

--[[
Tests the GetVRInputs method.
--]]
NexusUnitTesting:RegisterUnitTest(VRPointingTest.new("GetVRInputs"):SetRun(function(self)
    --Mock GetUserCFrameEnabled and GetUserCFrame.
    local LeftEnabled,RightEnabled,HeadEnabled = true,true,true
    VRPointing.VRService:DisableChangeReplication("GetUserCFrameEnabled")
    function VRPointing.VRService:GetUserCFrameEnabled(EnumCFrame)
        if EnumCFrame == Enum.UserCFrame.LeftHand then
            return LeftEnabled
        elseif EnumCFrame == Enum.UserCFrame.RightHand then
            return RightEnabled
        elseif EnumCFrame == Enum.UserCFrame.Head then
            return HeadEnabled
        end
    end
    function VRPointing.VRService:GetUserCFrame()
        return CFrame.new()
    end

    --Assert that the hand CFrames are returned correctly.
    local HeadCFrame = Workspace.CurrentCamera:GetRenderCFrame()
    VRPointing.Inputs[Enum.KeyCode.ButtonL2] = 0.4
    VRPointing.Inputs[Enum.KeyCode.ButtonR2] = 0.6
    self:AssertEquals({VRPointing:GetVRInputs()},{{HeadCFrame * CFrame.new(),HeadCFrame * CFrame.new()},{0.4,0.6}})
    LeftEnabled,RightEnabled = true,false
    self:AssertEquals({VRPointing:GetVRInputs()},{{HeadCFrame * CFrame.new()},{0.4}})
    LeftEnabled,RightEnabled = false,true
    self:AssertEquals({VRPointing:GetVRInputs()},{{HeadCFrame * CFrame.new()},{0.6}})

    --Assert that the head CFrames are returned correctly.
    LeftEnabled,RightEnabled = false,false
    self:AssertEquals({VRPointing:GetVRInputs()},{{HeadCFrame},{0.6}})
    VRPointing.Inputs[Enum.UserInputType.MouseButton1] = true
    self:AssertEquals({VRPointing:GetVRInputs()},{{HeadCFrame},{1}})
end))



return true