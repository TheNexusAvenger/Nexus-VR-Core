--[[
TheNexusAvenger

Manages pointing from VR inputs.
--]]

local PROJECTION_DEPTH = 0.1



local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VRService = game:GetService("VRService")

local NexusVRCore = require(script.Parent.Parent)
local NexusWrappedInstance = NexusVRCore:GetResource("NexusWrappedInstance")
local NexusInstance = NexusVRCore:GetResource("NexusWrappedInstance.NexusInstance.NexusInstance")
local VRPointer = NexusVRCore:GetResource("Interaction.VRPointer")
local VRSurfaceGui = NexusVRCore:GetResource("Container.VRSurfaceGui")

local VRPointing = NexusInstance:Extend()
VRPointing.VRService = NexusWrappedInstance.GetInstance(VRService)
VRPointing.VRPointers = {}
VRPointing.Inputs = {
    [Enum.KeyCode.ButtonL2] = 0,
    [Enum.KeyCode.ButtonR2] = 0,
    [Enum.UserInputType.MouseButton1] = false,
}
VRPointing:SetClassName("VRPointing")



--[[
Returns if the part is raycasted to with no
0-transparency parts.
--]]
local function CanRaycast(StartCF,Distance,TargetPart)
    --Return false if the distance is 0 or negative.
    if Distance <= 0 then
        return false
    end

    --Ray cast and return if the target part was hit.
    local RaycastResult = Workspace:Raycast(StartCF.Position,StartCF.LookVector * Distance)
    if not RaycastResult or not RaycastResult.Instance or RaycastResult.Instance == TargetPart then
        return true
    end

    --Return false if an opague part was hit.
    if RaycastResult.Instance.Transparency == 0 then
        return false
    end

    --Perform another ray cast.
    local CompleteDistance = (StartCF.Position - RaycastResult.Position).Magnitude
    return CanRaycast(StartCF * CFrame.new(0,0,-(CompleteDistance + 0.01)),Distance - (CompleteDistance + 0.01),TargetPart)
end



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
                if RaycastPointX >= 0 and RaycastPointX <= 1 and RaycastPointY >= 0 and RaycastPointY <= 1 and RaycastPointDepth >= 0 and (SurfaceGui.AlwaysOnTop or CanRaycast(ControllerCFrame,RaycastPointDepth + 0.05,Part:GetWrappedInstance())) then
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

--[[
Returns the CFrames and inputs for the VR service.
--]]
function VRPointing:GetVRInputs()
    --Return based on the controllers.
    local LeftEnabled,RightEnabled = VRPointing.VRService:GetUserCFrameEnabled(Enum.UserCFrame.LeftHand),VRPointing.VRService:GetUserCFrameEnabled(Enum.UserCFrame.RightHand)
    if LeftEnabled and RightEnabled then
        return {VRPointing.VRService:GetUserCFrame(Enum.UserCFrame.LeftHand),VRPointing.VRService:GetUserCFrame(Enum.UserCFrame.RightHand)},{VRPointing.Inputs[Enum.KeyCode.ButtonL2],VRPointing.Inputs[Enum.KeyCode.ButtonR2]}
    elseif LeftEnabled then
        return {VRPointing.VRService:GetUserCFrame(Enum.UserCFrame.LeftHand)},{VRPointing.Inputs[Enum.KeyCode.ButtonL2]}
    elseif RightEnabled then
        return {VRPointing.VRService:GetUserCFrame(Enum.UserCFrame.RightHand)},{VRPointing.Inputs[Enum.KeyCode.ButtonR2]}
    end

    --Return based on the head if no controllers are enabled.
    if VRPointing.Inputs[Enum.UserInputType.MouseButton1] then
        return {VRPointing.VRService:GetUserCFrame(Enum.UserCFrame.Head)},{1}
    else
        return {VRPointing.VRService:GetUserCFrame(Enum.UserCFrame.Head)},{VRPointing.Inputs[Enum.KeyCode.ButtonR2]}
    end
end

--[[
Connects the inputs for VR inputs.
--]]
function VRPointing:ConnectEvents()
    UserInputService.InputBegan:Connect(function(Input)
        if typeof(VRPointing.Inputs[Input.UserInputType]) == "boolean" then
            VRPointing.Inputs[Input.UserInputType] = true
        elseif typeof(VRPointing.Inputs[Input.KeyCode]) == "boolean" then
            VRPointing.Inputs[Input.KeyCode] = true
        end
    end)
    UserInputService.InputEnded:Connect(function(Input)
        if typeof(VRPointing.Inputs[Input.UserInputType]) == "boolean" then
            VRPointing.Inputs[Input.UserInputType] = false
        elseif typeof(VRPointing.Inputs[Input.KeyCode]) == "boolean" then
            VRPointing.Inputs[Input.KeyCode] = false
        end
    end)
    UserInputService.InputChanged:Connect(function(Input)
        if typeof(VRPointing.Inputs[Input.UserInputType]) == "number" then
            VRPointing.Inputs[Input.UserInputType] = Input.Position.Z
        elseif typeof(VRPointing.Inputs[Input.KeyCode]) == "number" then
            VRPointing.Inputs[Input.KeyCode] = Input.Position.Z
        end
    end)
end

--[[
Runs updating pointing.
--]]
function VRPointing:RunUpdating()
    --Return if VR is not enabled.
    if not UserInputService.VREnabled then
        return
    end
    
    --Connect updating the inpputs.
    RunService:BindToRenderStep("NexusVRCorePointingUpdate",Enum.RenderPriority.Camera.Value - 1,function()
        VRPointing:UpdatePointers(VRPointing:GetVRInputs())
    end)
end



return VRPointing