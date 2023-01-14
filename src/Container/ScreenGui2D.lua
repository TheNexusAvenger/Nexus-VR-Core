--[[
TheNexusAvenger

Implementation of a ScreenGui for 2D players.
--]]
--!strict

local BaseScreenGui = require(script.Parent:WaitForChild("BaseScreenGui"))

local ScreenGui2D = BaseScreenGui:Extend()
ScreenGui2D:SetClassName("ScreenGui2D")

export type ScreenGui2D = {
    new: () -> ScreenGui2D,
    Extend: (self: ScreenGui2D) -> ScreenGui2D,
} & BaseScreenGui.BaseScreenGui



--[[
Creates a 2D ScreenGui.
--]]
function ScreenGui2D:__new(): ()
    BaseScreenGui.__new(self, Instance.new("ScreenGui"))
end



return ScreenGui2D