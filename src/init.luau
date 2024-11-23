--Project for fetching resources of Nexus VR Core.

local NexusProject = {}



--[[
Returns a resource in Nexus VR Core.
Legacy from Nexus Project.
--]]
function NexusProject:GetResource(Path: string): any
    local Module = script
    for _, PathPart in string.split(Path, ".") do
        Module = (Module :: any)[PathPart]
    end
    return require(Module :: ModuleScript)
end



return NexusProject