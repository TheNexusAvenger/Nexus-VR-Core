--[[
TheNexusAvenger

Base ScreenGui instance.
--]]
--!strict

local NexusInstance = require(script.Parent.Parent:WaitForChild("NexusInstance"):WaitForChild("NexusInstance"))

local BaseScreenGui = NexusInstance:Extend()
BaseScreenGui:SetClassName("BaseScreenGui")

export type BaseScreenGui = {
    new: (Container: LayerCollector) -> BaseScreenGui,
    Extend: (self: BaseScreenGui) -> BaseScreenGui,

    RotationOffset: CFrame,
    Depth: number,
    FieldOfView: number,
    CanvasSize: Vector2,
    Easing: number,
    GetContainer: (self: BaseScreenGui) -> (LayerCollector),
    DisableChangeReplication: (self: BaseScreenGui, Name: string) -> (),
    Destroy: (self: BaseScreenGui) -> (),
} & NexusInstance.NexusInstance & LayerCollector



--[[
Creates the Base ScreenGui.
--]]
function BaseScreenGui:__new(Container: LayerCollector): ()
    NexusInstance.__new(self)
    self.Container = Container

    --Set the metatables.
    local NonReplicatedProperties = {} :: {[string]: boolean}
    self.NonReplicatedProperties = NonReplicatedProperties
    local Metatable = getmetatable(self)
    local BaseIndex, BaseNewIndex = Metatable.__index, Metatable.__newindex
    Metatable.__index = function(self, Index: string): any
        local BaseReturn = BaseIndex(self, Index)
        if BaseReturn ~= nil or NonReplicatedProperties[Index] then
            return BaseReturn
        end
        return (Container :: any)[Index]
    end
    Metatable.__newindex = function(self, Index: string, Value): ()
        if not NonReplicatedProperties[Index] then
            (Container :: any)[Index] = Value
        end
        BaseNewIndex(self, Index, Value)
    end

    --Set the properties.
    self:DisableChangeReplication("RotationOffset")
    self.RotationOffset = CFrame.new()
    self:DisableChangeReplication("Depth")
    self.Depth = 5
    self:DisableChangeReplication("FieldOfView")
    self.FieldOfView = math.rad(50)
    if not Container:IsA("SurfaceGui") then
        self:DisableChangeReplication("CanvasSize")
    end
    self.CanvasSize = Vector2.new(1000, 1000)
    self:DisableChangeReplication("Easing")
    self.Easing = 0
end

--[[
Disables a change to replicate to the container.
--]]
function BaseScreenGui:DisableChangeReplication(Name: string)
    self.NonReplicatedProperties[Name] = true
end

--[[
Returns the container of the ScreenGui.
--]]
function BaseScreenGui:GetContainer(): LayerCollector
    return self.Container
end

--[[
Destroys the ScreenGui.
--]]
function BaseScreenGui:Destroy(): ()
    NexusInstance.Destroy(self)
    self.Container:Destroy()
end



return (BaseScreenGui :: any) :: BaseScreenGui