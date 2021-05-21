--[[
TheNexusAvenger

Visualizes pointing to a position.
--]]

local BEAM_GRADIENT_DISTANCE = 2



local Workspace = game:GetService("Workspace")

local NexusVRCore = require(script.Parent.Parent)
local NexusInstance = NexusVRCore:GetResource("NexusWrappedInstance.NexusInstance.NexusInstance")

local VRPointer = NexusInstance:Extend()
VRPointer:SetClassName("VRPointer")



--[[
Creates the pointer.
--]]
function VRPointer:__new()
    self:InitializeSuper()
    self.StartPosition = Vector3.new(0,0,0)
    self.EndPosition = Vector3.new(0,0,0)

    --Create the pointer components.
    local StartPart = Instance.new("Part")
    StartPart.Transparency = 1
    StartPart.Anchored = true
    StartPart.CanCollide = false
    StartPart.Size = Vector3.new(0,0,0)
    StartPart.Parent = Workspace.CurrentCamera
    self.StartPart = StartPart

    local EndPart = Instance.new("Part")
    EndPart.Transparency = 1
    EndPart.Anchored = true
    EndPart.CanCollide = false
    EndPart.Size = Vector3.new(0,0,0)
    EndPart.Parent = Workspace.CurrentCamera
    self.EndPart = EndPart
    
    local StartAttachment = Instance.new("Attachment")
    StartAttachment.Parent = StartPart
    
    local EndAttachment = Instance.new("Attachment")
    EndAttachment.Parent = EndPart

    local Beam = Instance.new("Beam")
    Beam.Attachment0 = StartAttachment
    Beam.Attachment1 = EndAttachment
    Beam.Width0 = 0.05
    Beam.Width1 = 0.05
    Beam.FaceCamera = true
    Beam.Parent = StartPart
    self.Beam = Beam

    local EndSphere = Instance.new("SphereHandleAdornment")
    EndSphere.Transparency = 0.5
    EndSphere.AlwaysOnTop = true
    EndSphere.ZIndex = 1
    EndSphere.Radius = 0.1
    EndSphere.Adornee = EndPart
    EndSphere.Parent = EndPart
    self.EndSphere = EndSphere

    --Connect changes to the properties.
    self:AddPropertyFinalizer("Color3",function(_,Value)
        Beam.Color = ColorSequence.new(Value)
        EndSphere.Color3 = Value
    end)
    self:AddPropertyFinalizer("Transparency",function(_,Value)
        EndSphere.Transparency = Value
        self:UpdateTransparency()
    end)
    self:AddPropertyFinalizer("Visible",function(_,Value)
        EndSphere.Visible = Value
        Beam.Enabled = Value
    end)
    self:AddPropertyFinalizer("StartPosition",function(_,Value)
        StartPart.CFrame = CFrame.new(Value)
        self:UpdateTransparency()
    end)
    self:AddPropertyFinalizer("EndPosition",function(_,Value)
        EndPart.CFrame = CFrame.new(Value)
        self:UpdateTransparency()
    end)

    --Set the defaults.
    self.Color3 = Color3.new(0,170/255,255/255)
    self.Transparency = 0.5
    self.Visible = true
end

--[[
Moves to the pointer to a start CFrame and length.
--]]
function VRPointer:SetFromCFrame(StartCFrame,Distance)
    self.StartPosition = StartCFrame.Position
    self.EndPosition = (StartCFrame * CFrame.new(0,0,-Distance)).Position
end

--[[
Updates the transparency of the beam.
--]]
function VRPointer:UpdateTransparency()
    --Update the end sphere.
    self.EndSphere.Transparency = self.Transparency

    --Return if the start and end are the same to prevent a divide by 0 case.
    if self.StartPosition == self.EndPosition then
        return
    end

    --Update the transparency of the beam.
    local Distance = (self.EndPosition - self.StartPosition).Magnitude
    if Distance <= 2 * BEAM_GRADIENT_DISTANCE then
        self.Beam.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0,1),
            NumberSequenceKeypoint.new(0.5,1 - ((1 - self.Transparency) * ((Distance/2) / BEAM_GRADIENT_DISTANCE))),
            NumberSequenceKeypoint.new(1,1),
        })
    else
        self.Beam.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0,1),
            NumberSequenceKeypoint.new(BEAM_GRADIENT_DISTANCE/Distance,self.Transparency),
            NumberSequenceKeypoint.new(1 - (BEAM_GRADIENT_DISTANCE/Distance),self.Transparency),
            NumberSequenceKeypoint.new(1,1),
        })
    end
end

--[[
Destroys the pointer.
--]]
function VRPointer:Destroy()
    self.super:Destroy()
    self.StartPart:Destroy()
    self.EndPart:Destroy()
end



return VRPointer