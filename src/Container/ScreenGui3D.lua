--[[
TheNexusAvenger

Contains user interface components for a 3D user interface.
--]]

local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local NexusVRCore = require(script.Parent.Parent)
local VRSurfaceGui = NexusVRCore:GetResource("Container.VRSurfaceGui")
local VRPart = NexusVRCore:GetResource("Interaction.VRPart")

local ScreenGui3D = VRSurfaceGui:Extend()
ScreenGui3D:SetClassName("ScreenGui3D")
ScreenGui3D:CreateGetInstance()



--[[
Creates the Screen Gui 3D.
--]]
function ScreenGui3D:__new(ExistingScreenGui)
    self:InitializeSuper(Instance.new("SurfaceGui"))

    --Create the Adornee.
    local Adornee = VRPart.new()
    Adornee.Transparency = 1
    Adornee.Anchored = true
    Adornee.CanCollide = false
    self.Adornee = Adornee
    Adornee.Parent = self
    self.Face = Enum.NormalId.Back

    --Set the properties.
    self.AlwaysOnTop = true
    if ExistingScreenGui then
        self.Name = ExistingScreenGui.Name
        self.Enabled = ExistingScreenGui.Enabled
    end

    --Disable replication and set the defaults.
    self:DisableChangeReplication("RotationOffset")
    self.RotationOffset = CFrame.new()
    self:DisableChangeReplication("Depth")
    self.Depth = 5
    self:DisableChangeReplication("FieldOfView")
    self.FieldOfView = math.rad(50)
    self:DisableChangeReplication("CanvasSize")
    self.CanvasSize = Vector2.new(1000,1000)
    self:DisableChangeReplication("Easing")
    self.Easing = 0
    self:DisableChangeReplication("LastRotation")
    self.LastRotation = CFrame.new(Workspace.CurrentCamera:GetRenderCFrame().Position):inverse() * Workspace.CurrentCamera:GetRenderCFrame()

    --Connect updating the size.
    self:GetPropertyChangedSignal("Depth"):Connect(function()
        self:UpdateSize()
    end)
    self:GetPropertyChangedSignal("FieldOfView"):Connect(function()
        self:UpdateSize()
    end)
    self:GetPropertyChangedSignal("CanvasSize"):Connect(function()
        self:UpdateSize()
    end)

    --Update the size and position.
    self:UpdateSize()
    table.insert(self.EventsToDisconnect,RunService.RenderStepped:Connect(function(DeltaTime)
        if self.Enabled then
            self:UpdateCFrame(DeltaTime)
        end
    end))

    --Set the parent, move the instances over, and destroy the existing ScreenGui.
    if ExistingScreenGui then
        self.Parent = ExistingScreenGui.Parent
        for _,Ins in pairs(ExistingScreenGui:GetChildren()) do
            Ins.Parent = self:GetWrappedInstance()
        end
        spawn(function()
            ExistingScreenGui:Destroy()
        end)
    end
end

--[[
Updates the size of the part.
--]]
function ScreenGui3D:UpdateSize()
    local Width = 2 * math.tan(self.FieldOfView/2) * self.Depth
    if self.CanvasSize.Y <= self.CanvasSize.X then
        self.Adornee.Size = Vector3.new(Width,Width * (self.CanvasSize.Y/self.CanvasSize.X),0)
    else
        self.Adornee.Size = Vector3.new(Width * (self.CanvasSize.X/self.CanvasSize.Y),Width,0)
    end
end

--[[
Updates the CFrame of the part.
--]]
function ScreenGui3D:UpdateCFrame(DeltaTime)
    DeltaTime = DeltaTime or self.Easing

    --Update the rotation.
    local CameraCFrame = Workspace.CurrentCamera:GetRenderCFrame()
    local TargetCFrame = CFrame.new(CameraCFrame.Position):inverse() * CameraCFrame
    if self.Easing == 0 then
        self.LastRotation = TargetCFrame
    else
        self.LastRotation = self.LastRotation:Lerp(TargetCFrame,DeltaTime/self.Easing)
    end

    --Set the CFrame.
    self.Adornee.CFrame = CFrame.new(CameraCFrame.Position) * self.RotationOffset * self.LastRotation *  CFrame.new(0,0,-self.Depth)
end



return ScreenGui3D