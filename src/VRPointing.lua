--[[
TheNexusAvenger

Manages pointing from VR inputs.
--]]

local PROJECTION_DEPTH = 0.1

local NexusVRCore = require(script.Parent)
local NexusInstance = NexusVRCore:GetResource("NexusWrappedInstance.NexusInstance.NexusInstance")
local VRPointer = NexusVRCore:GetResource("VRPointer")
local VRSurfaceGui = NexusVRCore:GetResource("VRSurfaceGui")

local VRPointing = NexusInstance:Extend()
VRPointing.VRPointers = {}
VRPointing:SetClassName("VRPointing")



--[[
Invokes the events for the given inputs.
--]]
function VRPointing:UpdatePointers(CFrames,PressedValues)
    --Determine the frames to interact with.
    local RaycastedFrames = {}
    local ProjectFrames = {}
    for SurfaceGui,_ in pairs(VRSurfaceGui.VRSurfaceGuis) do
        local Part = SurfaceGui.Adornee or SurfaceGui.Parent
        local Face = SurfaceGui.Face
        if Part and Part:IsA("BasePart") then
            for InputId,ControllerCFrame in pairs(CFrames) do
                --Set the frame if the ray cast is closer and is valid.
                local RaycastPointX,RaycastPointY,RaycastPointDepth = Part:Raycast(ControllerCFrame,Face)
                if RaycastPointX >= 0 and RaycastPointX <= 1 and RaycastPointY >= 0 and RaycastPointY <= 1 and RaycastPointDepth >= 0 then
                    if not RaycastedFrames[InputId] or RaycastedFrames[InputId].Depth > RaycastPointDepth then
                        RaycastedFrames[InputId] = {
                            Gui = SurfaceGui,
                            RelativeInput = Vector3.new(RaycastPointX,RaycastPointY,PressedValues[InputId] or 0),
                            Depth = RaycastPointDepth,
                        }
                    end
                end

                --Set the frame if the projection is valid.
                local ProjectionPointX,ProjectionPointY,ProjectionDepth = Part:Project(ControllerCFrame.Position,Face)
                if ProjectionPointX >= 0 and ProjectionPointX <= 1 and ProjectionPointY >= 0 and ProjectionPointY <= 1 and math.abs(ProjectionDepth) <= PROJECTION_DEPTH then
                    if not ProjectFrames[InputId] or ProjectFrames[InputId].Depth > ProjectionDepth then
                        ProjectFrames[InputId] = {
                            Gui = SurfaceGui,
                            RelativeInput = Vector3.new(ProjectionPointX,ProjectionPointY,math.min((PROJECTION_DEPTH - ProjectionDepth)/PROJECTION_DEPTH,1)),
                            Depth = ProjectionDepth,
                        }
                    end
                end
            end
        end
    end

    --Combine the inputs.
    local FrameInputs = {}
    for _,InputsTable in pairs({RaycastedFrames,ProjectFrames}) do
        for _,Input in pairs(InputsTable) do
            if not FrameInputs[Input.Gui] then
                FrameInputs[Input.Gui] = {}
            end
            table.insert(FrameInputs[Input.Gui],Input.RelativeInput)
        end
    end

    --Send the events.
    for Frame,Inputs in pairs(FrameInputs) do
        Frame:UpdateEvents(Inputs)
    end

    --Create and update the pointers.
    for _ = #VRPointing.VRPointers + 1,#CFrames do
        table.insert(VRPointing.VRPointers,VRPointer.new())
    end
    for i = 1,#CFrames do
        local Pointer = VRPointing.VRPointers[i]
        local Frame = RaycastedFrames[i]
        if Frame then
            Pointer:SetFromCFrame(CFrames[1],Frame.Depth)
            Pointer.Visible = true
        else
            Pointer.Visible = false
        end
    end
end



return VRPointing