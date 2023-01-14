--[[
TheNexusAvenger

Tests for BaseScreenGui.
--]]
--!strict

local NexusVRCore = game:GetService("ReplicatedStorage"):WaitForChild("NexusVRCore")
local BaseScreenGui = require(NexusVRCore:WaitForChild("Container"):WaitForChild("BaseScreenGui"))

return function()
    local Container, TestBaseScreenGui = nil, nil
    beforeEach(function()
        Container = Instance.new("ScreenGui")
        TestBaseScreenGui = BaseScreenGui.new(Container)
    end)
    afterEach(function()
        TestBaseScreenGui:Destroy()
    end)

    describe("A ScreenGui", function()
        it("should return the container", function()
            expect(TestBaseScreenGui:GetContainer()).to.equal(Container)
        end)

        it("should read stored values.", function()
            expect(TestBaseScreenGui.Depth).to.equal(5)
            expect(TestBaseScreenGui.CanvasSize).to.equal(Vector2.new(1000, 1000))
            expect(TestBaseScreenGui.Name).to.equal("ScreenGui")
            expect(TestBaseScreenGui.AbsoluteSize).to.never.equal(nil)
        end)

        it("should write values.", function()
            TestBaseScreenGui.Depth = 9
            expect(TestBaseScreenGui.Depth).to.equal(9)
            TestBaseScreenGui.Name = "Test"
            expect(TestBaseScreenGui.Name).to.equal("Test")
            expect(Container.Name).to.equal("Test")
        end)
    end)
end