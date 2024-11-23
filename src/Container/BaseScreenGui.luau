--Base ScreenGui instance.
--!strict

local NexusInstance = require(script.Parent.Parent:WaitForChild("NexusInstance"))

local BaseScreenGui = {}
BaseScreenGui.ClassName = "BaseScreenGui"
BaseScreenGui.__index = BaseScreenGui

export type BaseScreenGui<T> = {
    Container: T,
    RotationOffset: CFrame,
    Depth: number,
    FieldOfView: number,
    CanvasSize: Vector2,
    Easing: number,
    PointingEnabled: boolean,
    NonReplicatedProperties: {[string]: boolean},
} & typeof(setmetatable({}, BaseScreenGui)) & T
export type NexusInstanceBaseScreenGui<T> = NexusInstance.NexusInstance<BaseScreenGui<T>>



--[[
Creates the Base ScreenGui.
--]]
function BaseScreenGui.__new<T>(self: NexusInstanceBaseScreenGui<T>, Container: T): ()
    self.Container = Container

    --Modify __index.
    local NonReplicatedProperties = {}
    self.NonReplicatedProperties = NonReplicatedProperties
    local Metatable = getmetatable(self) :: any
    local OriginalIndex = Metatable.__index
    Metatable.__index = function(self, Index: any): any
        --Return the object's value.
        local ObjectValue = OriginalIndex(self, Index)
        if ObjectValue ~= nil or NonReplicatedProperties[Index] then
            return ObjectValue
        end

        --Return the instance's value.
        return (Container :: any)[Index]
    end

    --Replicate changes.
    self:OnAnyPropertyChanged(function(PropertyName, Value)
        if NonReplicatedProperties[PropertyName] then return end
        (Container :: any)[PropertyName] = Value
    end)

    --Set the properties.
    self:DisableChangeReplication("RotationOffset")
    self.RotationOffset = CFrame.identity
    self:DisableChangeReplication("Depth")
    self.Depth = 5
    self:DisableChangeReplication("FieldOfView")
    self.FieldOfView = math.rad(50)
    if not (Container :: any):IsA("SurfaceGui") then
        self:DisableChangeReplication("CanvasSize")
    end
    self.CanvasSize = Vector2.new(1000, 1000)
    self:DisableChangeReplication("Easing")
    self.Easing = 0
    self:DisableChangeReplication("PointingEnabled")
    self.PointingEnabled = true
end

--[[
Returns if the BaseScreenGui is a type of instance.
IsA is not provided in Nexus Instance V4 and is provided for backwards compatibility.
--]]
function BaseScreenGui.IsA<T>(self: NexusInstanceBaseScreenGui<T>, ClassName: string): boolean
    warn("BaseScreenGui::IsA is deprecated.")
    return ClassName == "NexusObject" or ClassName == "NexusInstance" or ClassName == "BaseScreenGui"
end

--[[
Disables a change to replicate to the container.
--]]
function BaseScreenGui.DisableChangeReplication<T>(self: NexusInstanceBaseScreenGui<T>, Name: string)
    self.NonReplicatedProperties[Name] = true
end

--[[
Returns the container of the ScreenGui.
--]]
function BaseScreenGui.GetContainer<T>(self: NexusInstanceBaseScreenGui<T>): T
    return self.Container
end

--[[
Destroys the ScreenGui.
--]]
function BaseScreenGui.Destroy<T>(self: NexusInstanceBaseScreenGui<T>): ()
    (self.Container :: any):Destroy()
end



return NexusInstance.ToInstance(BaseScreenGui) :: NexusInstance.NexusInstanceClass<typeof(BaseScreenGui), <T>(Container: T) -> (NexusInstanceBaseScreenGui<T>)>