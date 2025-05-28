--Contains user interface components for a 3D user interface.
--!strict

local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local NexusInstance = require(script.Parent.Parent:WaitForChild("Packages"):WaitForChild("NexusInstance"))
local BaseScreenGui = require(script.Parent:WaitForChild("BaseScreenGui"))

local ScreenGui3D = {}
ScreenGui3D.ClassName = "ScreenGui3D"
ScreenGui3D.__index = ScreenGui3D
setmetatable(ScreenGui3D, BaseScreenGui)

export type ScreenGui3D = {
    Adornee: BasePart,
    LastRotation: CFrame,
    UpdateEvent: RBXScriptConnection,
} & typeof(setmetatable({}, ScreenGui3D)) & BaseScreenGui.BaseScreenGui<SurfaceGui>
export type NexusInstanceScreenGui3D = NexusInstance.NexusInstance<ScreenGui3D>



--[[
Creates a 3D ScreenGui.
--]]
function ScreenGui3D.__new(self: NexusInstanceScreenGui3D): ()
    BaseScreenGui.__new(self, Instance.new("SurfaceGui"))

    --Create the Adornee.
    local NexusVRCoreContainer = Workspace.CurrentCamera:FindFirstChild("NexusVRCoreContainer")
    if not NexusVRCoreContainer then
        NexusVRCoreContainer = Instance.new("Folder")
        NexusVRCoreContainer.Name = "NexusVRCoreContainer"
        NexusVRCoreContainer.Parent = Workspace.CurrentCamera
    end
    local Adornee = Instance.new("Part")
    Adornee.Transparency = 1
    Adornee.Anchored = true
    Adornee.CanCollide = false
    Adornee.Parent = NexusVRCoreContainer
    self.Adornee = Adornee
    self.Face = Enum.NormalId.Back

    --Set the properties.
    self.AlwaysOnTop = true
    self:OnPropertyChanged("PointingEnabled", function()
        self.Adornee.CanQuery = self.Enabled and self.PointingEnabled
    end)
    self:OnPropertyChanged("Enabled", function()
        self.Adornee.CanQuery = self.Enabled and self.PointingEnabled
    end)

    --Disable replication of ScreenGui properties.
    self:DisableChangeReplication("DisplayOrder")
    self:DisableChangeReplication("IgnoreGuiInset")
    self:DisableChangeReplication("LastRotation")
    self.LastRotation = CFrame.new(Workspace.CurrentCamera:GetRenderCFrame().Position):Inverse() * Workspace.CurrentCamera:GetRenderCFrame()

    --Connect updating the size.
    self:OnPropertyChanged("Depth", function()
        self:UpdateSize()
    end)
    self:OnPropertyChanged("FieldOfView", function()
        self:UpdateSize()
    end)
    self:OnPropertyChanged("CanvasSize", function(Value)
        self:UpdateSize()
    end)

    --Update the size and position.
    self:UpdateSize()
    self:DisableChangeReplication("UpdateEvent")
    self.UpdateEvent = RunService.RenderStepped:Connect(function(DeltaTime: number)
        if self.Enabled then
            self:UpdateCFrame(DeltaTime)
        end
    end)
end

--[[
Updates the size of the part.
--]]
function ScreenGui3D.UpdateSize(self: NexusInstanceScreenGui3D): ()
    local Width = 2 * math.tan(self.FieldOfView/2) * self.Depth
    local CanvasSize = self.CanvasSize :: Vector2
    if CanvasSize.Y <= CanvasSize.X then
        self.Adornee.Size = Vector3.new(Width, Width * (self.CanvasSize.Y / self.CanvasSize.X), 0)
    else
        self.Adornee.Size = Vector3.new(Width * (self.CanvasSize.X / self.CanvasSize.Y), Width, 0)
    end
    self.CanvasSize = self.CanvasSize
end

--[[
Updates the CFrame of the part.
--]]
function ScreenGui3D.UpdateCFrame(self: NexusInstanceScreenGui3D, DeltaTime: number): ()
    DeltaTime = DeltaTime or self.Easing

    --Update the rotation.
    local CameraCFrame = Workspace.CurrentCamera:GetRenderCFrame()
    local TargetCFrame = CFrame.new(CameraCFrame.Position):Inverse() * CameraCFrame
    if self.Easing == 0 then
        self.LastRotation = TargetCFrame
    else
        self.LastRotation = self.LastRotation:Lerp(TargetCFrame, math.clamp(DeltaTime / self.Easing, 0, 1))
    end

    --Set the CFrame.
    self.Adornee.CFrame = CFrame.new(CameraCFrame.Position) * self.LastRotation * self.RotationOffset * CFrame.new(0, 0, -self.Depth)
end

--[[
Destroys the ScreenGui.
--]]
function ScreenGui3D.Destroy(self: NexusInstanceScreenGui3D): ()
    BaseScreenGui.Destroy(self)
    self.UpdateEvent:Disconnect()
    self.Adornee:Destroy()
end



return NexusInstance.ToInstance(ScreenGui3D) :: NexusInstance.NexusInstanceClass<typeof(ScreenGui3D), () -> (NexusInstanceScreenGui3D)>