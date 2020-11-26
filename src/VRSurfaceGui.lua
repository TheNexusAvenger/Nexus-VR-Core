--[[
TheNexusAvenger

Wraps a SurfaceGui for invoking events from VR inputs.
--]]

local TRIGGER_DOWN_THRESHOLD = 0.8
local TRIGGER_UP_THRESHOLD = 0.6



local NexusVRCore = require(script.Parent)
local NexusWrappedInstance = NexusVRCore:GetResource("NexusWrappedInstance")
local VRPart = NexusVRCore:GetResource("VRPart")

local VRSurfaceGui = NexusWrappedInstance:Extend()
VRSurfaceGui:SetClassName("VRSurfaceGui")



--[[
Gets a VR Surface Gui.
--]]
function VRSurfaceGui.GetInstance(ExistingSurfaceGui)
	--Create the string instance or create the cached instance if needed.
	local CachedInstance = NexusWrappedInstance.CachedInstances[ExistingSurfaceGui]
	if not CachedInstance then
		CachedInstance = VRSurfaceGui.new(ExistingSurfaceGui)
	end
	
	--Return the cached entry.
	return CachedInstance
end

--[[
Creates the VR Surface Gui.
--]]
function VRSurfaceGui:__new(ExistingSurfaceGui)
    self:InitializeSuper(ExistingSurfaceGui or Instance.new("SurfaceGui"))

    --Set up the event state storage.
    self:DisableChangeReplication("MouseEnterFrames")
    self.MouseEnterFrames = {}
    self:DisableChangeReplication("MouseDownFrames")
    self.MouseDownFrames = {}
    self:DisableChangeReplication("ScrollLastPositions")
    self.ScrollLastPositions = {}
end

--[[
Updates the events of frames with the
given relative points.
--]]
function VRSurfaceGui:UpdateEvents(Points)
    --Determine the max trigger inputs.
    local MaxTriggerInputs = {}
    local AbsoluteSize = self.AbsoluteSize
    for _,Point in pairs(Points) do
        local PosX,PosY,TriggerInput = Point.X * AbsoluteSize.X,Point.Y * AbsoluteSize.Y,Point.Z
        for _,Frame in pairs(self:GetDescendants()) do
            if Frame:IsA("GuiObject") then
                local FrameSize,FramePosition = Frame.AbsoluteSize,Frame.AbsolutePosition
                if FramePosition.X <= PosX and FramePosition.X + FrameSize.X >= PosX and FramePosition.Y <= PosY and FramePosition.Y + FrameSize.Y >= PosY then
                    if not MaxTriggerInputs[Frame] or TriggerInput > MaxTriggerInputs[Frame].Z then
                        MaxTriggerInputs[Frame] = Vector3.new(PosX,PosY,TriggerInput)
                    end
                end
            end
        end
    end

    --Update the events for mouse movement and clicks.
    local MouseEnterFrames,MouseDownFrames,ScrollLastPositions = self.MouseEnterFrames,self.MouseDownFrames,self.ScrollLastPositions
    for Frame,InputPosition in pairs(MaxTriggerInputs) do
        --Send the movement inputs.
        if not MouseEnterFrames[Frame] then
            MouseEnterFrames[Frame] = true
            Frame.MouseEnter:Fire(InputPosition.X,InputPosition.Y)
        end
        Frame.InputChanged:Fire({
            KeyCode = Enum.KeyCode.Unknown,
            UserInputType = Enum.UserInputType.MouseMovement,
            Position = InputPosition,
        })
        Frame.MouseMoved:Fire(InputPosition.X,InputPosition.Y)
        
        --Send the mouse button inputs.
        if InputPosition.Z >= TRIGGER_DOWN_THRESHOLD then
            if not MouseDownFrames[Frame] then
                MouseDownFrames[Frame] = true
                if Frame:IsA("GuiButton") then
                    Frame.MouseButton1Down:Fire(InputPosition.X,InputPosition.Y)
                end
                Frame.InputBegan:Fire({
                    KeyCode = Enum.KeyCode.Unknown,
                    UserInputType = Enum.UserInputType.MouseButton1,
                    Position = InputPosition,
                })
            end

            --Move the ScrollingFrame.
            if Frame:IsA("ScrollingFrame") then
                if ScrollLastPositions[Frame] then
                    local DeltaInput = InputPosition - ScrollLastPositions[Frame]
                    Frame.CanvasPosition = Vector2.new(Frame.CanvasPosition.X + DeltaInput.X,Frame.CanvasPosition.Y + DeltaInput.Y)
                end
                ScrollLastPositions[Frame] = InputPosition
            end
        elseif InputPosition.Z <= TRIGGER_UP_THRESHOLD and MouseDownFrames[Frame] then
            ScrollLastPositions[Frame] = nil
            MouseDownFrames[Frame] = nil
            if Frame:IsA("GuiButton") then
                Frame.MouseButton1Up:Fire(InputPosition.X,InputPosition.Y)
                Frame.MouseButton1Click:Fire()
            end
            Frame.InputEnded:Fire({
                KeyCode = Enum.KeyCode.Unknown,
                UserInputType = Enum.UserInputType.MouseButton1,
                Position = InputPosition,
            })
        end
    end

    --Create a list of frames to end events.
    --Prevnets modifying the table being iterated over, which stops iterating over the list.
    local FramesToRemove = {}
    for Frame,_ in pairs(MouseEnterFrames) do
        if not MaxTriggerInputs[Frame] then
            table.insert(FramesToRemove,Frame)
        end
    end

    --End the mouse events.
    for _,Frame in pairs(FramesToRemove) do
        --Fire the end events.
        Frame.MouseLeave:Fire()

        --Remove the frame.
        MouseEnterFrames[Frame] = nil
        MouseDownFrames[Frame] = nil
        ScrollLastPositions[Frame] = nil
    end
end



return VRSurfaceGui