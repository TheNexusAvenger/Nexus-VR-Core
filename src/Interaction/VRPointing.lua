--[[
TheNexusAvenger

Manages pointing from VR inputs.
--]]

local PROJECTION_DEPTH = 0.1
local TRIGGER_DOWN_THRESHOLD = 0.8
local TRIGGER_UP_THRESHOLD = 0.6
local CLICKDETECTOR_RAYCAST_DISTANCE = 1000



local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
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
VRPointing.PointersEnabled = true
VRPointing.Inputs = {
    [Enum.KeyCode.ButtonL2] = 0,
    [Enum.KeyCode.ButtonR2] = 0,
    [Enum.UserInputType.MouseButton1] = false,
}
VRPointing.ClickDetectorEvents = {}
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
    local Pointers = {}
    for SurfaceGui,_ in pairs(VRSurfaceGui.VRSurfaceGuis) do
        if SurfaceGui:IsDescendantOf(game) and SurfaceGui.Enabled and SurfaceGui.PointingEnabled then
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
                                Part = Part,
                            }
                            Pointers[InputId] = RaycastedFrames[InputId]
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
                                Part = Part,
                            }
                        end
                    end
                end
            end
        end
    end

    --Determine the ClickDetector events.
    local ClickDectorsHit = {}
    local ClickDetectorRaycastParams = RaycastParams.new()
    ClickDetectorRaycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    ClickDetectorRaycastParams.FilterDescendantsInstances = {Workspace.CurrentCamera}
    for InputId,ControllerCFrame in pairs(CFrames) do
        local RaycastResult = Workspace:Raycast(ControllerCFrame.Position,ControllerCFrame.LookVector * CLICKDETECTOR_RAYCAST_DISTANCE,ClickDetectorRaycastParams)
        if RaycastResult and RaycastResult.Instance then
            local ClickDetector = RaycastResult.Instance:FindFirstChildOfClass("ClickDetector")
            if ClickDetector then
                ClickDetector = NexusWrappedInstance.GetInstance(ClickDetector)
                local Distance = (ControllerCFrame.Position - RaycastResult.Instance.Position).Magnitude
                if Distance <= ClickDetector.MaxActivationDistance and (not RaycastedFrames[InputId] or RaycastedFrames[InputId].Part:GetWrappedInstance() ~= RaycastResult.Instance) then
                    --Store the pointer.
                    RaycastedFrames[InputId] = nil
                    Pointers[InputId] = {
                        ClickDetector = ClickDetector,
                        Depth = (ControllerCFrame.Position - RaycastResult.Position).Magnitude,
                    }
                    
                    --Add the ClickDetector to invoke.
                    local InputValue = PressedValues[InputId]
                    if not ClickDectorsHit[ClickDetector] or ClickDectorsHit[ClickDetector] < InputValue then
                        ClickDectorsHit[ClickDetector] = InputValue
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

    --Send the events for the frames.
    for Frame,Inputs in pairs(FrameInputs) do
        Frame:UpdateEvents(Inputs)
    end

    --Send the eveents for the ClickDetectors.
    for ClickDetector,Value in pairs(ClickDectorsHit) do
        --Send the hover event.
        if VRPointing.ClickDetectorEvents[ClickDetector] == nil then
            ClickDetector.MouseHoverEnter:Fire(Players.LocalPlayer)
            VRPointing.ClickDetectorEvents[ClickDetector] = false
        end

        --Send the click events.
        if Value >= TRIGGER_DOWN_THRESHOLD then
            if VRPointing.ClickDetectorEvents[ClickDetector] == false then
                ClickDetector.MouseClick:Fire(Players.LocalPlayer)
                VRPointing.ClickDetectorEvents[ClickDetector] = true
            end
        elseif Value <= TRIGGER_UP_THRESHOLD then
            VRPointing.ClickDetectorEvents[ClickDetector] = false
        end
    end
    local ClickDetectorsToEnd = {}
    for ClickDetector,_ in pairs(VRPointing.ClickDetectorEvents) do
        if not ClickDectorsHit[ClickDetector] then
            ClickDetector.MouseHoverLeave:Fire(Players.LocalPlayer)
            table.insert(ClickDetectorsToEnd,ClickDetector)
        end
    end
    for _,ClickDetector in pairs(ClickDetectorsToEnd) do
        VRPointing.ClickDetectorEvents[ClickDetector] = nil
    end

    if VRPointing.PointersEnabled then
        --Create and update the pointers.
        for _ = #VRPointing.VRPointers + 1,#CFrames do
            table.insert(VRPointing.VRPointers,VRPointer.new())
        end
        for i,Pointer in pairs(VRPointing.VRPointers) do
            local Frame = Pointers[i]
            if Frame then
                Pointer:SetFromCFrame(CFrames[i],Frame.Depth)
                Pointer.Visible = true
            else
                Pointer.Visible = false
            end
        end
    else
        --Destroy the pointers.
        for _,Pointer in pairs(VRPointing.VRPointers) do
            Pointer:Destroy()
        end
        VRPointing.VRPointers = {}
    end
end

--[[
Returns the CFrames and inputs for the VR service.
--]]
function VRPointing:GetVRInputs()
    --Return based on the controllers.
    local LeftEnabled,RightEnabled = VRPointing.VRService:GetUserCFrameEnabled(Enum.UserCFrame.LeftHand),VRPointing.VRService:GetUserCFrameEnabled(Enum.UserCFrame.RightHand)
    local HeadCFrame = Workspace.CurrentCamera:GetRenderCFrame()
    local CenterCFrame = HeadCFrame * VRPointing.VRService:GetUserCFrame(Enum.UserCFrame.Head):inverse()
    local LeftHandCFrame,RightHandCFrame = CenterCFrame * VRPointing.VRService:GetUserCFrame(Enum.UserCFrame.LeftHand),CenterCFrame * VRPointing.VRService:GetUserCFrame(Enum.UserCFrame.RightHand)
    if LeftEnabled and RightEnabled then
        return {LeftHandCFrame,RightHandCFrame},{VRPointing.Inputs[Enum.KeyCode.ButtonL2],VRPointing.Inputs[Enum.KeyCode.ButtonR2]}
    elseif LeftEnabled then
        return {LeftHandCFrame},{VRPointing.Inputs[Enum.KeyCode.ButtonL2]}
    elseif RightEnabled then
        return {RightHandCFrame},{VRPointing.Inputs[Enum.KeyCode.ButtonR2]}
    end

    --Return based on the head if no controllers are enabled.
    if VRPointing.Inputs[Enum.UserInputType.MouseButton1] then
        return {HeadCFrame},{1}
    else
        return {HeadCFrame},{VRPointing.Inputs[Enum.KeyCode.ButtonR2]}
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