--[[
TheNexusAvenger

Tests for VRSurfaceGui.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local NexusVRCore = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusVRCore"))
local NexusWrappedInstance = NexusVRCore:GetResource("NexusWrappedInstance")
local VRSurfaceGui = NexusVRCore:GetResource("Container.VRSurfaceGui")
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
Tests the GetVisibleFrames method.
--]]
NexusUnitTesting:RegisterUnitTest(VRSurfaceGuiTest.new("GetVisibleFrames"):SetRun(function(self)
    --Add several visible frames.
    local Frame1 = NexusWrappedInstance.new("Frame")
    Frame1.Parent = self.CuT
    local Frame2 = NexusWrappedInstance.new("Frame")
    Frame2.Parent = Frame1
    local Frame3 = NexusWrappedInstance.new("Frame")
    Frame3.Parent = Frame2
    local Frame4 = NexusWrappedInstance.new("Frame")
    Frame4.Parent = Frame1
    local Frame5 = NexusWrappedInstance.new("Frame")
    Frame5.Parent = self.CuT

    --Assert the total returned frames are correct.
    self:AssertEquals(#self.CuT:GetVisibleFrames(),5,"Total hidden frames is incorrect.")
    Frame1.Visible = false
    self:AssertEquals(#self.CuT:GetVisibleFrames(),1,"Total hidden frames is incorrect.")
    Frame1.Visible = true
    Frame2.Visible = false
    self:AssertEquals(#self.CuT:GetVisibleFrames(),3,"Total hidden frames is incorrect.")
    Frame2.Visible = true
    Frame3.Visible = false
    self:AssertEquals(#self.CuT:GetVisibleFrames(),4,"Total hidden frames is incorrect.")
    Frame3.Visible = true
    Frame4.Visible = false
    self:AssertEquals(#self.CuT:GetVisibleFrames(),4,"Total hidden frames is incorrect.")
    Frame4.Visible = true
    Frame5.Visible = false
    self:AssertEquals(#self.CuT:GetVisibleFrames(),4,"Total hidden frames is incorrect.")
    Frame1.Visible = false
    Frame2.Visible = false
    Frame3.Visible = false
    Frame4.Visible = false
    self:AssertEquals(#self.CuT:GetVisibleFrames(),0,"Total hidden frames is incorrect.")
end))

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

--[[
Tests the UpdateEvents method with a ScrollingFrame.
--]]
NexusUnitTesting:RegisterUnitTest(VRSurfaceGuiTest.new("UpdateEventsScrollingFrame"):SetRun(function(self)
    --Add a scrolling frame.
    local ScrollingFrame = NexusWrappedInstance.new("ScrollingFrame")
    ScrollingFrame.Size = UDim2.new(0,400,0,300)
    ScrollingFrame.Position = UDim2.new(0,100,0,100)
    ScrollingFrame.CanvasSize = UDim2.new(0,600,0,400)
    ScrollingFrame.Parent = self.CuT

    --Assert moving but not "clicking" doesn't change the canvas position.
    self.CuT:UpdateEvents({Vector3.new(0.4,0.5,0.3)})
    self:AssertEquals(ScrollingFrame.CanvasPosition,Vector2.new(0,0),"Canvas position is incorrect.")
    self.CuT:UpdateEvents({Vector3.new(0.3,0.4,0.3)})
    self:AssertEquals(ScrollingFrame.CanvasPosition,Vector2.new(0,0),"Canvas position is incorrect.")

    --Assert moving vertically is correct.
    self.CuT:UpdateEvents({Vector3.new(0.4,0.5,0.9)})
    self:AssertEquals(ScrollingFrame.CanvasPosition,Vector2.new(0,0),"Canvas position is incorrect.")
    self.CuT:UpdateEvents({Vector3.new(0.4,0.5 - (50/600),0.9)})
    self:AssertEquals(ScrollingFrame.CanvasPosition,Vector2.new(0,50),"Canvas position is incorrect.")
    self.CuT:UpdateEvents({Vector3.new(0.4,0.5 - (100/600),0.9)})
    self:AssertEquals(ScrollingFrame.CanvasPosition,Vector2.new(0,100),"Canvas position is incorrect.")
    self.CuT:UpdateEvents({Vector3.new(0.4,0.5 - (150/600),0.9)})
    self:AssertEquals(ScrollingFrame.CanvasPosition,Vector2.new(0,100),"Canvas position is incorrect.")
    self.CuT:UpdateEvents({Vector3.new(0.4,0.5 - (100/600),0.9)})
    self:AssertEquals(ScrollingFrame.CanvasPosition,Vector2.new(0,50),"Canvas position is incorrect.")
    self.CuT:UpdateEvents({Vector3.new(0.4,0.5 - (50/600),0.9)})
    self:AssertEquals(ScrollingFrame.CanvasPosition,Vector2.new(0,0),"Canvas position is incorrect.")

    --Assert moving horizontally is correct.
    self.CuT:UpdateEvents({Vector3.new(0.4,0.5,0.9)})
    self:AssertEquals(ScrollingFrame.CanvasPosition,Vector2.new(0,0),"Canvas position is incorrect.")
    self.CuT:UpdateEvents({Vector3.new(0.4 - (50/800),0.5,0.9)})
    self:AssertEquals(ScrollingFrame.CanvasPosition,Vector2.new(50,0),"Canvas position is incorrect.")
    self.CuT:UpdateEvents({Vector3.new(0.4 - (100/800),0.5,0.9)})
    self:AssertEquals(ScrollingFrame.CanvasPosition,Vector2.new(100,0),"Canvas position is incorrect.")
    self.CuT:UpdateEvents({Vector3.new(0.4 - (50/800),0.5,0.9)})
    self:AssertEquals(ScrollingFrame.CanvasPosition,Vector2.new(50,0),"Canvas position is incorrect.")
    self.CuT:UpdateEvents({Vector3.new(0.4,0.5,0.9)})
    self:AssertEquals(ScrollingFrame.CanvasPosition,Vector2.new(0,0),"Canvas position is incorrect.")

    --Assert moving horizontally and vertically is correct.
    self.CuT:UpdateEvents({Vector3.new(0.4,0.5,0.9)})
    self:AssertEquals(ScrollingFrame.CanvasPosition,Vector2.new(0,0),"Canvas position is incorrect.")
    self.CuT:UpdateEvents({Vector3.new(0.4 - (50/800),0.5 - (50/600),0.9)})
    self:AssertEquals(ScrollingFrame.CanvasPosition,Vector2.new(50,50),"Canvas position is incorrect.")
    self.CuT:UpdateEvents({Vector3.new(0.4 - (100/800),0.5 - (100/600),0.9)})
    self:AssertEquals(ScrollingFrame.CanvasPosition,Vector2.new(100,100),"Canvas position is incorrect.")
    self.CuT:UpdateEvents({Vector3.new(0.4 - (50/800),0.5 - (50/600),0.9)})
    self:AssertEquals(ScrollingFrame.CanvasPosition,Vector2.new(50,50),"Canvas position is incorrect.")
    self.CuT:UpdateEvents({Vector3.new(0.4,0.5,0.9)})
    self:AssertEquals(ScrollingFrame.CanvasPosition,Vector2.new(0,0),"Canvas position is incorrect.")
end))

--[[
Tests the UpdateEvents method starting from outside the frame while pressed.
--]]
NexusUnitTesting:RegisterUnitTest(VRSurfaceGuiTest.new("UpdateEventsEnterWhilePressed"):SetRun(function(self)
    --Add a frame.
    local Frame = NexusWrappedInstance.new("Frame")
    Frame.Size = UDim2.new(0,400,0,300)
    Frame.Position = UDim2.new(0,100,0,100)
    Frame.Parent = self.CuT

    --Connect the inputs.
    local FrameMouseEnterEvents,FrameMouseMovedEvents,FrameMouseLeaveEvents,FrameInputBeganEvents,FrameInputChangedEvents,FrameInputEndedEvents = {},{},{},{},{},{}
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

    --Update the inputs only over the frame and assert they are correct.
    self.CuT:UpdateEvents({Vector3.new(0,0,0.9)})
    self:AssertEquals(FrameMouseEnterEvents,{},"Frame MouseEnter events incorrect.")
    self:AssertEquals(FrameMouseMovedEvents,{},"Frame MouseMoved events incorrect.")
    self:AssertEquals(FrameMouseLeaveEvents,{},"Frame MouseLeave events incorrect.")
    self:AssertEquals(FrameInputBeganEvents,{},"Frame InputBegan events incorrect.")
    self:AssertEquals(FrameInputChangedEvents,{},"Frame InputChanged events incorrect.")
    self:AssertEquals(FrameInputEndedEvents,{},"Frame InputEnded events incorrect.")
    self.CuT:UpdateEvents({Vector3.new(0.25,0.25,0.9)})
    self:AssertEquals(FrameMouseEnterEvents,{{200,150}},"Frame MouseEnter events incorrect.")
    self:AssertEquals(FrameMouseMovedEvents,{{200,150}},"Frame MouseMoved events incorrect.")
    self:AssertEquals(FrameMouseLeaveEvents,{},"Frame MouseLeave events incorrect.")
    self:AssertEquals(FrameInputBeganEvents,{},"Frame InputBegan events incorrect.")
    self:AssertEquals(FrameInputChangedEvents,{Enum.UserInputType.MouseMovement},"Frame InputChanged events incorrect.")
    self:AssertEquals(FrameInputEndedEvents,{},"Frame InputEnded events incorrect.")
    self.CuT:UpdateEvents({Vector3.new(0.25,0.25,0.4)})
    self:AssertEquals(FrameMouseEnterEvents,{{200,150}},"Frame MouseEnter events incorrect.")
    self:AssertEquals(FrameMouseMovedEvents,{{200,150},{200,150}},"Frame MouseMoved events incorrect.")
    self:AssertEquals(FrameMouseLeaveEvents,{},"Frame MouseLeave events incorrect.")
    self:AssertEquals(FrameInputBeganEvents,{},"Frame InputBegan events incorrect.")
    self:AssertEquals(FrameInputChangedEvents,{Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement},"Frame InputChanged events incorrect.")
    self:AssertEquals(FrameInputEndedEvents,{},"Frame InputEnded events incorrect.")
    self.CuT:UpdateEvents({Vector3.new(0.25,0.25,0.9)})
    self:AssertEquals(FrameMouseEnterEvents,{{200,150}},"Frame MouseEnter events incorrect.")
    self:AssertEquals(FrameMouseMovedEvents,{{200,150},{200,150},{200,150}},"Frame MouseMoved events incorrect.")
    self:AssertEquals(FrameMouseLeaveEvents,{},"Frame MouseLeave events incorrect.")
    self:AssertEquals(FrameInputBeganEvents,{Enum.UserInputType.MouseButton1},"Frame InputBegan events incorrect.")
    self:AssertEquals(FrameInputChangedEvents,{Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement},"Frame InputChanged events incorrect.")
    self:AssertEquals(FrameInputEndedEvents,{},"Frame InputEnded events incorrect.")
    self.CuT:UpdateEvents({Vector3.new(0.25,0.25,0.4)})
    self:AssertEquals(FrameMouseEnterEvents,{{200,150}},"Frame MouseEnter events incorrect.")
    self:AssertEquals(FrameMouseMovedEvents,{{200,150},{200,150},{200,150},{200,150}},"Frame MouseMoved events incorrect.")
    self:AssertEquals(FrameMouseLeaveEvents,{},"Frame MouseLeave events incorrect.")
    self:AssertEquals(FrameInputBeganEvents,{Enum.UserInputType.MouseButton1},"Frame InputBegan events incorrect.")
    self:AssertEquals(FrameInputChangedEvents,{Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement},"Frame InputChanged events incorrect.")
    self:AssertEquals(FrameInputEndedEvents,{Enum.UserInputType.MouseButton1},"Frame InputEnded events incorrect.")
    self.CuT:UpdateEvents({Vector3.new(0,0,0.9)})
    self:AssertEquals(FrameMouseEnterEvents,{{200,150}},"Frame MouseEnter events incorrect.")
    self:AssertEquals(FrameMouseMovedEvents,{{200,150},{200,150},{200,150},{200,150}},"Frame MouseMoved events incorrect.")
    self:AssertEquals(FrameMouseLeaveEvents,{{}},"Frame MouseLeave events incorrect.")
    self:AssertEquals(FrameInputBeganEvents,{Enum.UserInputType.MouseButton1},"Frame InputBegan events incorrect.")
    self:AssertEquals(FrameInputChangedEvents,{Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement},"Frame InputChanged events incorrect.")
    self:AssertEquals(FrameInputEndedEvents,{Enum.UserInputType.MouseButton1},"Frame InputEnded events incorrect.")
    self.CuT:UpdateEvents({Vector3.new(0.25,0.25,0.9)})
    self:AssertEquals(FrameMouseEnterEvents,{{200,150},{200,150}},"Frame MouseEnter events incorrect.")
    self:AssertEquals(FrameMouseMovedEvents,{{200,150},{200,150},{200,150},{200,150},{200,150}},"Frame MouseMoved events incorrect.")
    self:AssertEquals(FrameMouseLeaveEvents,{{}},"Frame MouseLeave events incorrect.")
    self:AssertEquals(FrameInputBeganEvents,{Enum.UserInputType.MouseButton1},"Frame InputBegan events incorrect.")
    self:AssertEquals(FrameInputChangedEvents,{Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement},"Frame InputChanged events incorrect.")
    self:AssertEquals(FrameInputEndedEvents,{Enum.UserInputType.MouseButton1},"Frame InputEnded events incorrect.")
    self.CuT:UpdateEvents({Vector3.new(0.25,0.25,0.9),Vector3.new(0.25,0.25,0.95)})
    self:AssertEquals(FrameMouseEnterEvents,{{200,150},{200,150}},"Frame MouseEnter events incorrect.")
    self:AssertEquals(FrameMouseMovedEvents,{{200,150},{200,150},{200,150},{200,150},{200,150},{200,150}},"Frame MouseMoved events incorrect.")
    self:AssertEquals(FrameMouseLeaveEvents,{{}},"Frame MouseLeave events incorrect.")
    self:AssertEquals(FrameInputBeganEvents,{Enum.UserInputType.MouseButton1,Enum.UserInputType.MouseButton1},"Frame InputBegan events incorrect.")
    self:AssertEquals(FrameInputChangedEvents,{Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement,Enum.UserInputType.MouseMovement},"Frame InputChanged events incorrect.")
    self:AssertEquals(FrameInputEndedEvents,{Enum.UserInputType.MouseButton1},"Frame InputEnded events incorrect.")
end))

--[[
Tests setting the Adornee and Parent values.
--]]
NexusUnitTesting:RegisterUnitTest(VRSurfaceGuiTest.new("Adornee"):SetRun(function(self)
    self.CuT.Adornee = Instance.new("Part")
    self.CuT.Parent = Instance.new("Part")
    self:AssertTrue(self.CuT.Adornee:IsA("VRPart"),"Part wasn't converted to a VRPart.")
    self:AssertTrue(self.CuT.Parent:IsA("VRPart"),"Part wasn't converted to a VRPart.")
end))



return true