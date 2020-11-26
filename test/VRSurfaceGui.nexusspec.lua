--[[
TheNexusAvenger

Tests for VRSurfaceGui.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local NexusVRCore = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusVRCore"))
local NexusWrappedInstance = NexusVRCore:GetResource("NexusWrappedInstance")
local VRSurfaceGui = NexusVRCore:GetResource("VRSurfaceGui")
local VRSurfaceGuiTest = NexusUnitTesting.UnitTest:Extend()



--[[
Sets up the test.
--]]
function VRSurfaceGuiTest:Setup()
    self.CuT = VRSurfaceGui.new()
    self.CuT.CanvasSize = Vector2.new(800,600)
end

--[[
Tears down the test.
--]]
function VRSurfaceGuiTest:Teardown()
    if self.CuT then
        self.CuT:Destroy()
    end
end

--[[
Tests the UpdateEvents method.
--]]
NexusUnitTesting:RegisterUnitTest(VRSurfaceGuiTest.new("UpdateEvents"):SetRun(function(self)
    --Add a frame and button.
    local Frame = NexusWrappedInstance.new("Frame")
    Frame.Size = UDim2.new(0,400,0,300)
    Frame.Position = UDim2.new(0,100,0,100)
    Frame.Parent = self.CuT

    local TextButton = NexusWrappedInstance.new("TextButton")
    TextButton.Size = UDim2.new(0,300,0,200)
    TextButton.Position = UDim2.new(0,400,0,300)
    TextButton.Parent = self.CuT

    --Connect the inputs.
    local FrameMouseEnterEvents,FrameMouseMovedEvents,FrameMouseLeaveEvents,FrameInputBeganEvents,FrameInputChangedEvents,FrameInputEndedEvents = {},{},{},{},{},{}
    local MouseButton1DownEvents,MouseButton1UpEvents,MouseButton1ClickEvents = {},{},{}
    Frame.MouseEnter:Connect(function(...)
        table.insert(FrameMouseEnterEvents,{...})
    end)
    Frame.MouseMoved:Connect(function(...)
        table.insert(FrameMouseMovedEvents,{...})
    end)
    Frame.MouseLeave:Connect(function(...)
        table.insert(FrameMouseLeaveEvents,{...})
    end)
    Frame.InputBegan:Connect(function(Input)
        table.insert(FrameInputBeganEvents,Input.UserInputType)
    end)
    Frame.InputChanged:Connect(function(Input)
        table.insert(FrameInputChangedEvents,Input.UserInputType)
    end)
    Frame.InputEnded:Connect(function(Input)
        table.insert(FrameInputEndedEvents,Input.UserInputType)
    end)
    TextButton.MouseButton1Down:Connect(function(...)
        table.insert(MouseButton1DownEvents,{...})
    end)
    TextButton.MouseButton1Up:Connect(function(...)
        table.insert(MouseButton1UpEvents,{...})
    end)
    TextButton.MouseButton1Click:Connect(function(...)
        table.insert(MouseButton1ClickEvents,{...})
    end)

    --Update the inputs only over the frame and assert they are correct.
    self.CuT:UpdateEvents({Vector3.new(0.25,0.25,0)})
    self:AssertEquals(FrameMouseEnterEvents,{{200,150}},"Frame MouseEnter events incorrect.")
    self:AssertEquals(FrameMouseMovedEvents,{{200,150}},"Frame MouseMoved events incorrect.")
    self:AssertEquals(FrameMouseLeaveEvents,{},"Frame MouseLeave events incorrect.")
    self:AssertEquals(FrameInputBeganEvents,{},"Frame InputBegan events incorrect.")
    self:AssertEquals(FrameInputChangedEvents,{Enum.UserInputType.MouseMovement},"Frame InputChanged events incorrect.")
    self:AssertEquals(FrameInputEndedEvents,{},"Frame InputEnded events incorrect.")
    self.CuT:UpdateEvents({Vector3.new(0.25,0.5,0.6)})
    self:AssertEquals(FrameMouseEnterEvents,{{200,150}},"Frame MouseEnter events incorrect.")
    self:AssertEquals(FrameMouseMovedEvents,{{200,150},{200,300}},"Frame MouseMoved events incorrect.")
    self:AssertEquals(FrameMouseLeaveEvents,{},"Frame MouseLeave events incorrect.")
    self:AssertEquals(FrameInputBeganEvents,{},"Frame InputBegan events incorrect.")
    self:AssertEquals(FrameInputChangedEvents,{Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement},"Frame InputChanged events incorrect.")
    self:AssertEquals(FrameInputEndedEvents,{},"Frame InputEnded events incorrect.")
    self.CuT:UpdateEvents({Vector3.new(0.25,0.5,0.9)})
    self:AssertEquals(FrameMouseEnterEvents,{{200,150}},"Frame MouseEnter events incorrect.")
    self:AssertEquals(FrameMouseMovedEvents,{{200,150},{200,300},{200,300}},"Frame MouseMoved events incorrect.")
    self:AssertEquals(FrameMouseLeaveEvents,{},"Frame MouseLeave events incorrect.")
    self:AssertEquals(FrameInputBeganEvents,{Enum.UserInputType.MouseButton1},"Frame InputBegan events incorrect.")
    self:AssertEquals(FrameInputChangedEvents,{Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement},"Frame InputChanged events incorrect.")
    self:AssertEquals(FrameInputEndedEvents,{},"Frame InputEnded events incorrect.")
    self.CuT:UpdateEvents({Vector3.new(0.25,0.5,0.95)})
    self:AssertEquals(FrameMouseEnterEvents,{{200,150}},"Frame MouseEnter events incorrect.")
    self:AssertEquals(FrameMouseMovedEvents,{{200,150},{200,300},{200,300},{200,300}},"Frame MouseMoved events incorrect.")
    self:AssertEquals(FrameMouseLeaveEvents,{},"Frame MouseLeave events incorrect.")
    self:AssertEquals(FrameInputBeganEvents,{Enum.UserInputType.MouseButton1},"Frame InputBegan events incorrect.")
    self:AssertEquals(FrameInputChangedEvents,{Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement},"Frame InputChanged events incorrect.")
    self:AssertEquals(FrameInputEndedEvents,{},"Frame InputEnded events incorrect.")
    self.CuT:UpdateEvents({Vector3.new(0.25,0.5,0.4)})
    self:AssertEquals(FrameMouseEnterEvents,{{200,150}},"Frame MouseEnter events incorrect.")
    self:AssertEquals(FrameMouseMovedEvents,{{200,150},{200,300},{200,300},{200,300},{200,300}},"Frame MouseMoved events incorrect.")
    self:AssertEquals(FrameMouseLeaveEvents,{},"Frame MouseLeave events incorrect.")
    self:AssertEquals(FrameInputBeganEvents,{Enum.UserInputType.MouseButton1},"Frame InputBegan events incorrect.")
    self:AssertEquals(FrameInputChangedEvents,{Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement},"Frame InputChanged events incorrect.")
    self:AssertEquals(FrameInputEndedEvents,{Enum.UserInputType.MouseButton1},"Frame InputEnded events incorrect.")
    self.CuT:UpdateEvents({Vector3.new(0.05,0.5,0)})
    self:AssertEquals(FrameMouseEnterEvents,{{200,150}},"Frame MouseEnter events incorrect.")
    self:AssertEquals(FrameMouseMovedEvents,{{200,150},{200,300},{200,300},{200,300},{200,300}},"Frame MouseMoved events incorrect.")
    self:AssertEquals(FrameMouseLeaveEvents,{{}},"Frame MouseLeave events incorrect.")
    self:AssertEquals(FrameInputBeganEvents,{Enum.UserInputType.MouseButton1},"Frame InputBegan events incorrect.")
    self:AssertEquals(FrameInputChangedEvents,{Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement},"Frame InputChanged events incorrect.")
    self:AssertEquals(FrameInputEndedEvents,{Enum.UserInputType.MouseButton1},"Frame InputEnded events incorrect.")

    --Update the inputs only over the button and assert they are correct.
    self.CuT:UpdateEvents({Vector3.new(0.75,0.75,0)})
    self:AssertEquals(MouseButton1DownEvents,{},"Button MouseButton1Down events incorrect.")
    self:AssertEquals(MouseButton1UpEvents,{},"Button MouseButton1Up events incorrect.")
    self:AssertEquals(MouseButton1ClickEvents,{},"Button MouseButton1Click events incorrect.")
    self.CuT:UpdateEvents({Vector3.new(0.75,0.75,0.4)})
    self:AssertEquals(MouseButton1DownEvents,{},"Button MouseButton1Down events incorrect.")
    self:AssertEquals(MouseButton1UpEvents,{},"Button MouseButton1Up events incorrect.")
    self:AssertEquals(MouseButton1ClickEvents,{},"Button MouseButton1Click events incorrect.")
    self.CuT:UpdateEvents({Vector3.new(0.75,0.75,0.9)})
    self:AssertEquals(MouseButton1DownEvents,{{600,450}},"Button MouseButton1Down events incorrect.")
    self:AssertEquals(MouseButton1UpEvents,{},"Button MouseButton1Up events incorrect.")
    self:AssertEquals(MouseButton1ClickEvents,{},"Button MouseButton1Click events incorrect.")
    self.CuT:UpdateEvents({Vector3.new(0.75,0.75,0.95)})
    self:AssertEquals(MouseButton1DownEvents,{{600,450}},"Button MouseButton1Down events incorrect.")
    self:AssertEquals(MouseButton1UpEvents,{},"Button MouseButton1Up events incorrect.")
    self:AssertEquals(MouseButton1ClickEvents,{},"Button MouseButton1Click events incorrect.")
    self.CuT:UpdateEvents({Vector3.new(0.75,0.5,0.2)})
    self:AssertEquals(MouseButton1DownEvents,{{600,450}},"Button MouseButton1Down events incorrect.")
    self:AssertEquals(MouseButton1UpEvents,{{600,300}},"Button MouseButton1Up events incorrect.")
    self:AssertEquals(MouseButton1ClickEvents,{{}},"Button MouseButton1Click events incorrect.")
    self.CuT:UpdateEvents({Vector3.new(0.75,0.5,0.95)})
    self:AssertEquals(MouseButton1DownEvents,{{600,450},{600,300}},"Button MouseButton1Down events incorrect.")
    self:AssertEquals(MouseButton1UpEvents,{{600,300}},"Button MouseButton1Up events incorrect.")
    self:AssertEquals(MouseButton1ClickEvents,{{}},"Button MouseButton1Click events incorrect.")
    self.CuT:UpdateEvents({Vector3.new(0.9,0.9,0.4)})
    self:AssertEquals(MouseButton1DownEvents,{{600,450},{600,300}},"Button MouseButton1Down events incorrect.")
    self:AssertEquals(MouseButton1UpEvents,{{600,300}},"Button MouseButton1Up events incorrect.")
    self:AssertEquals(MouseButton1ClickEvents,{{}},"Button MouseButton1Click events incorrect.")

    --Assert the frame inputs didn't change.
    self:AssertEquals(FrameMouseEnterEvents,{{200,150}},"Frame MouseEnter events incorrect.")
    self:AssertEquals(FrameMouseMovedEvents,{{200,150},{200,300},{200,300},{200,300},{200,300}},"Frame MouseMoved events incorrect.")
    self:AssertEquals(FrameMouseLeaveEvents,{{}},"Frame MouseLeave events incorrect.")
    self:AssertEquals(FrameInputBeganEvents,{Enum.UserInputType.MouseButton1},"Frame InputBegan events incorrect.")
    self:AssertEquals(FrameInputChangedEvents,{Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement},"Frame InputChanged events incorrect.")
    self:AssertEquals(FrameInputEndedEvents,{Enum.UserInputType.MouseButton1},"Frame InputEnded events incorrect.")

    --Assert overlapping inputs are correct on both objects.
    self.CuT:UpdateEvents({Vector3.new(0.5,0.5,0.2),Vector3.new(0.5,0.5,0.9)})
    self:AssertEquals(FrameMouseEnterEvents,{{200,150},{400,300}},"Frame MouseEnter events incorrect.")
    self:AssertEquals(FrameMouseMovedEvents,{{200,150},{200,300},{200,300},{200,300},{200,300},{400,300}},"Frame MouseMoved events incorrect.")
    self:AssertEquals(FrameMouseLeaveEvents,{{}},"Frame MouseLeave events incorrect.")
    self:AssertEquals(FrameInputBeganEvents,{Enum.UserInputType.MouseButton1,Enum.UserInputType.MouseButton1},"Frame InputBegan events incorrect.")
    self:AssertEquals(FrameInputChangedEvents,{Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement},"Frame InputChanged events incorrect.")
    self:AssertEquals(FrameInputEndedEvents,{Enum.UserInputType.MouseButton1},"Frame InputEnded events incorrect.")
    self:AssertEquals(MouseButton1DownEvents,{{600,450},{600,300},{400,300}},"Button MouseButton1Down events incorrect.")
    self:AssertEquals(MouseButton1UpEvents,{{600,300}},"Button MouseButton1Up events incorrect.")
    self:AssertEquals(MouseButton1ClickEvents,{{}},"Button MouseButton1Click events incorrect.")
    self.CuT:UpdateEvents({Vector3.new(0.25,0.25,0.9),Vector3.new(0.5,0.5,0.5)})
    self:AssertEquals(FrameMouseEnterEvents,{{200,150},{400,300}},"Frame MouseEnter events incorrect.")
    self:AssertEquals(FrameMouseMovedEvents,{{200,150},{200,300},{200,300},{200,300},{200,300},{400,300},{200,150}},"Frame MouseMoved events incorrect.")
    self:AssertEquals(FrameMouseLeaveEvents,{{}},"Frame MouseLeave events incorrect.")
    self:AssertEquals(FrameInputBeganEvents,{Enum.UserInputType.MouseButton1,Enum.UserInputType.MouseButton1},"Frame InputBegan events incorrect.")
    self:AssertEquals(FrameInputChangedEvents,{Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement},"Frame InputChanged events incorrect.")
    self:AssertEquals(FrameInputEndedEvents,{Enum.UserInputType.MouseButton1},"Frame InputEnded events incorrect.")
    self:AssertEquals(MouseButton1DownEvents,{{600,450},{600,300},{400,300}},"Button MouseButton1Down events incorrect.")
    self:AssertEquals(MouseButton1UpEvents,{{600,300},{400,300}},"Button MouseButton1Up events incorrect.")
    self:AssertEquals(MouseButton1ClickEvents,{{},{}},"Button MouseButton1Click events incorrect.")
    self.CuT:UpdateEvents({Vector3.new(0.25,0.25,0.3),Vector3.new(0.5,0.5,0.3)})
    self:AssertEquals(FrameMouseEnterEvents,{{200,150},{400,300}},"Frame MouseEnter events incorrect.")
    self:AssertEquals(FrameMouseMovedEvents,{{200,150},{200,300},{200,300},{200,300},{200,300},{400,300},{200,150},{200,150}},"Frame MouseMoved events incorrect.")
    self:AssertEquals(FrameMouseLeaveEvents,{{}},"Frame MouseLeave events incorrect.")
    self:AssertEquals(FrameInputBeganEvents,{Enum.UserInputType.MouseButton1,Enum.UserInputType.MouseButton1},"Frame InputBegan events incorrect.")
    self:AssertEquals(FrameInputChangedEvents,{Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement},"Frame InputChanged events incorrect.")
    self:AssertEquals(FrameInputEndedEvents,{Enum.UserInputType.MouseButton1,Enum.UserInputType.MouseButton1},"Frame InputEnded events incorrect.")
    self:AssertEquals(MouseButton1DownEvents,{{600,450},{600,300},{400,300}},"Button MouseButton1Down events incorrect.")
    self:AssertEquals(MouseButton1UpEvents,{{600,300},{400,300}},"Button MouseButton1Up events incorrect.")
    self:AssertEquals(MouseButton1ClickEvents,{{},{}},"Button MouseButton1Click events incorrect.")
    self:AssertEquals(MouseButton1ClickEvents,{{},{}},"Button MouseButton1Click events incorrect.")
    self.CuT:UpdateEvents({Vector3.new(0,0,0.3),Vector3.new(1,1,0.3)})
    self:AssertEquals(FrameMouseEnterEvents,{{200,150},{400,300}},"Frame MouseEnter events incorrect.")
    self:AssertEquals(FrameMouseMovedEvents,{{200,150},{200,300},{200,300},{200,300},{200,300},{400,300},{200,150},{200,150}},"Frame MouseMoved events incorrect.")
    self:AssertEquals(FrameMouseLeaveEvents,{{},{}},"Frame MouseLeave events incorrect.")
    self:AssertEquals(FrameInputBeganEvents,{Enum.UserInputType.MouseButton1,Enum.UserInputType.MouseButton1},"Frame InputBegan events incorrect.")
    self:AssertEquals(FrameInputChangedEvents,{Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement},"Frame InputChanged events incorrect.")
    self:AssertEquals(FrameInputEndedEvents,{Enum.UserInputType.MouseButton1,Enum.UserInputType.MouseButton1},"Frame InputEnded events incorrect.")
    self:AssertEquals(MouseButton1DownEvents,{{600,450},{600,300},{400,300}},"Button MouseButton1Down events incorrect.")
    self:AssertEquals(MouseButton1UpEvents,{{600,300},{400,300}},"Button MouseButton1Up events incorrect.")
    self:AssertEquals(MouseButton1ClickEvents,{{},{}},"Button MouseButton1Click events incorrect.")
end))



return true