--[[
TheNexusAvenger

Wraps a SurfaceGui for invoking events from VR inputs.
--]]

local TRIGGER_DOWN_THRESHOLD = 0.8
local TRIGGER_UP_THRESHOLD = 0.6



local NexusVRCore = require(script.Parent.Parent)
local NexusObject = NexusVRCore:GetResource("NexusWrappedInstance.NexusInstance.NexusObject")
local NexusPropertyValidator = NexusVRCore:GetResource("NexusWrappedInstance.NexusInstance.PropertyValidator.NexusPropertyValidator")
local NexusWrappedInstance = NexusVRCore:GetResource("NexusWrappedInstance")
local VRPart = NexusVRCore:GetResource("Interaction.VRPart")

local VRSurfaceGui = NexusWrappedInstance:Extend()
VRSurfaceGui:SetClassName("VRSurfaceGui")
VRSurfaceGui:CreateGetInstance()
VRSurfaceGui.VRSurfaceGuis = {}
setmetatable(VRSurfaceGui.CachedInstances,{__mode="k"})

local VRPartValidator = NexusObject:Extend()
VRPartValidator:SetClassName("VRPartValidator")
VRPartValidator:Implements(NexusPropertyValidator)



--[[
Validates a change to the property of a NexusObject.
The new value must be returned. If the input is invalid,
an error should be thrown.
--]]
function VRPartValidator:ValidateChange(_,_,Value)
    --Wrap the value if it is a part.
    if typeof(Value) == "Instance" then
        return VRPart.GetInstance(Value)
    end

    --Return the base value.
    return Value
end



--[[
Creates the VR Surface Gui.
--]]
function VRSurfaceGui:__new(ExistingSurfaceGui)
    self:InitializeSuper(ExistingSurfaceGui or Instance.new("SurfaceGui"))

    --Add the validators for wrapping VRParts.
    local Validator = VRPartValidator.new()
    self:AddPropertyValidator("Adornee",Validator)
    self:AddPropertyValidator("Parent",Validator)

    --Store the SurfaceGui.
    VRSurfaceGui.VRSurfaceGuis[self.object] = true

    --Set up the event state storage.
    self:DisableChangeReplication("MouseEnterFrames")
    self.MouseEnterFrames = {}
    self:DisableChangeReplication("MouseDownFrames")
    self.MouseDownFrames = {}
    self:DisableChangeReplication("ScrollLastPositions")
    self.ScrollLastPositions = {}
    self:DisableChangeReplication("LastInputs")
    self.LastInputs = {}
end

--[[
Creates an __index metamethod for an object. Used to
setup custom indexing.
--]]
function VRSurfaceGui:__createindexmethod(Object,Class,RootClass)
    --Get the base method.
    local BaseIndexMethod = self.super:__createindexmethod(Object,Class,RootClass)

    --Return a wrapped method.
    return function(MethodObject,Index)
        --Return the special case for the Adornee or Parent.
        if Index == "Adornee" or Index == "Parent" then
            local Part = Object.WrappedInstance[Index]
            if Part and typeof(Part) == "Instance" and Part:IsA("BasePart") then
                return VRPart.GetInstance(Part)
            end
        end

        --Return the base return.
        return BaseIndexMethod(MethodObject,Index)
    end
end

--[[
Updates the events of frames with the
given relative points.
--]]
function VRSurfaceGui:UpdateEvents(Points)
    --Determine the max trigger inputs.
    local MaxTriggerInputs = {}
    local FrameInputId = {}
    local AbsoluteSize = self.AbsoluteSize
    for InputId,Point in pairs(Points) do
        local PosX,PosY,TriggerInput = Point.X * AbsoluteSize.X,Point.Y * AbsoluteSize.Y,Point.Z
        for _,Frame in pairs(self:GetDescendants()) do
            if Frame:IsA("GuiObject") then
                local FrameSize,FramePosition = Frame.AbsoluteSize,Frame.AbsolutePosition
                if FramePosition.X <= PosX and FramePosition.X + FrameSize.X >= PosX and FramePosition.Y <= PosY and FramePosition.Y + FrameSize.Y >= PosY then
                    if not MaxTriggerInputs[Frame] or TriggerInput > MaxTriggerInputs[Frame].Z then
                        MaxTriggerInputs[Frame] = Vector3.new(PosX,PosY,TriggerInput)
                        FrameInputId[Frame] = InputId
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
            local InputId = FrameInputId[Frame]
            if not self.LastInputs[InputId] or self.LastInputs[InputId].Z < TRIGGER_DOWN_THRESHOLD then
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

                --Capture the textbox.
                if Frame:IsA("TextBox") and not Frame:IsFocused() then
                    Frame:CaptureFocus()
                end
            end

            --Move the ScrollingFrame.
            if Frame:IsA("ScrollingFrame") then
                if ScrollLastPositions[Frame] then
                    local DeltaInput = InputPosition - ScrollLastPositions[Frame]
                    local ParentSize = Frame.Parent.AbsoluteSize
                    local CanvasSizeUDim2 = Frame.CanvasSize
                    local CanvasSize = Vector2.new((CanvasSizeUDim2.X.Scale * ParentSize.X) + CanvasSizeUDim2.X.Offset,(CanvasSizeUDim2.Y.Scale * ParentSize.Y) + CanvasSizeUDim2.Y.Offset)
                    local MaxCanvasPosition = CanvasSize - Frame.AbsoluteSize
                    MaxCanvasPosition = Vector2.new(math.max(MaxCanvasPosition.X,0),math.max(MaxCanvasPosition.Y,0))
                    Frame.CanvasPosition = Vector2.new(math.clamp(Frame.CanvasPosition.X - DeltaInput.X,0,MaxCanvasPosition.X),math.clamp(Frame.CanvasPosition.Y - DeltaInput.Y,0,MaxCanvasPosition.Y))
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

    --Store the last inputs.
    self.LastInputs = Points
end



return VRSurfaceGui