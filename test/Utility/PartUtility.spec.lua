--[[
TheNexusAvenger

Tests for PartUtility.
--]]
--!strict
--$NexusUnitTestExtensions

local NexusVRCore = game:GetService("ReplicatedStorage"):WaitForChild("NexusVRCore")
local PartUtility = require(NexusVRCore:WaitForChild("Utility"):WaitForChild("PartUtility"))

return function()
    local TestPart = nil
    beforeEach(function()
        TestPart = Instance.new("Part")
        TestPart.Size = Vector3.new(2,4,6)
    end)

    describe("The part utility", function()
        it("should raycast.", function()
            --Assert the front is valid.
            expect(Vector3.new(PartUtility.Raycast(TestPart, CFrame.new(0.5, 1, -5) * CFrame.Angles(0, math.pi, 0), "Front"))).to.be.near(Vector3.new(0.25, 0.25, 2), 0.001)
            expect(Vector3.new(PartUtility.Raycast(TestPart, CFrame.new(0.5, 1, -3) * CFrame.Angles(0, math.rad(15), 0) * CFrame.new(0,0,-2) * CFrame.Angles(0,math.pi,0), "Front"))).to.be.near(Vector3.new(0.25, 0.25, 2), 0.001)
            expect(Vector3.new(PartUtility.Raycast(TestPart, CFrame.new(0.5, 1, -3) * CFrame.Angles(math.rad(15), math.rad(15), 0) * CFrame.new(0, 0, -2) * CFrame.Angles(0, math.pi, 0), "Front"))).to.be.near(Vector3.new(0.25, 0.25, 2), 0.001)
            expect(Vector3.new(PartUtility.Raycast(TestPart, CFrame.new(0.5, 1, -3) * CFrame.Angles(math.rad(15), math.rad(15), 0) * CFrame.new(0, 0, -2), "Front"))).to.be.near(Vector3.new(0.25, 0.25, -2), 0.001)

            --Assert the other sides are valid.
            --The same math is used, so only a single result for the other side is used.
            expect(Vector3.new(PartUtility.Raycast(TestPart, CFrame.new(Vector3.new(-0.5, 1, 5), Vector3.new(-0.5, 1, 3)), "Back"))).to.be.near(Vector3.new(0.25, 0.25, 2), 0.001)
            expect(Vector3.new(PartUtility.Raycast(TestPart, CFrame.new(Vector3.new(-3, 1, -1.5), Vector3.new(-1, 1, -1.5)), "Left"))).to.be.near(Vector3.new(0.25, 0.25, 2), 0.001)
            expect(Vector3.new(PartUtility.Raycast(TestPart, CFrame.new(Vector3.new(3, 1, 1.5), Vector3.new(1, 1, 1.5)), "Right"))).to.be.near(Vector3.new(0.25, 0.25, 2), 0.001)
            expect(Vector3.new(PartUtility.Raycast(TestPart, CFrame.new(Vector3.new(-0.5, 4, 1.5), Vector3.new(-0.5, 2, 1.5)), "Top"))).to.be.near(Vector3.new(0.25, 0.25, 2), 0.001)
            expect(Vector3.new(PartUtility.Raycast(TestPart, CFrame.new(Vector3.new(0.5, -4, 1.5), Vector3.new(0.5, -2, 1.5)), "Bottom"))).to.be.near(Vector3.new(0.25, 0.25, 2), 0.001)
        end)

        it("should project.", function()
            --Assert the front is valid.
            expect(Vector3.new(PartUtility.Project(TestPart, Vector3.new(1.5, 3, -5), "Front"))).to.be.near(Vector3.new(-0.25, -0.25, 2), 0.001)
            expect(Vector3.new(PartUtility.Project(TestPart, Vector3.new(1, 2, -5), "Front"))).to.be.near(Vector3.new(0, 0, 2), 0.001)
            expect(Vector3.new(PartUtility.Project(TestPart, Vector3.new(0.5, 2, -5), "Front"))).to.be.near(Vector3.new(0.25, 0, 2), 0.001)
            expect(Vector3.new(PartUtility.Project(TestPart, Vector3.new(0, 2, -5), "Front"))).to.be.near(Vector3.new(0.5, 0, 2), 0.001)
            expect(Vector3.new(PartUtility.Project(TestPart, Vector3.new(-0.5, 2, -5), "Front"))).to.be.near(Vector3.new(0.75, 0, 2), 0.001)
            expect(Vector3.new(PartUtility.Project(TestPart, Vector3.new(-1, 2, -5), "Front"))).to.be.near(Vector3.new(1, 0, 2), 0.001)
            expect(Vector3.new(PartUtility.Project(TestPart, Vector3.new(1, 1, -5), "Front"))).to.be.near(Vector3.new(0, 0.25, 2), 0.001)
            expect(Vector3.new(PartUtility.Project(TestPart, Vector3.new(0.5, 1, -5), "Front"))).to.be.near(Vector3.new(0.25, 0.25, 2), 0.001)
            expect(Vector3.new(PartUtility.Project(TestPart, Vector3.new(0, 1, -5), "Front"))).to.be.near(Vector3.new(0.5, 0.25, 2), 0.001)
            expect(Vector3.new(PartUtility.Project(TestPart, Vector3.new(-0.5, 1, -5), "Front"))).to.be.near(Vector3.new(0.75, 0.25, 2), 0.001)
            expect(Vector3.new(PartUtility.Project(TestPart, Vector3.new(-1, 1, -5), "Front"))).to.be.near(Vector3.new(1, 0.25, 2), 0.001)
            expect(Vector3.new(PartUtility.Project(TestPart, Vector3.new(1, -1, -5), "Front"))).to.be.near(Vector3.new(0, 0.75, 2), 0.001)
            expect(Vector3.new(PartUtility.Project(TestPart, Vector3.new(0.5, -1, -5), "Front"))).to.be.near(Vector3.new(0.25, 0.75, 2), 0.001)
            expect(Vector3.new(PartUtility.Project(TestPart, Vector3.new(0, -1, -5), "Front"))).to.be.near(Vector3.new(0.5, 0.75, 2), 0.001)
            expect(Vector3.new(PartUtility.Project(TestPart, Vector3.new(-0.5, -1, -5), "Front"))).to.be.near(Vector3.new(0.75, 0.75, 2), 0.001)
            expect(Vector3.new(PartUtility.Project(TestPart, Vector3.new(-1, -1, -5), "Front"))).to.be.near(Vector3.new(1, 0.75, 2), 0.001)
            expect(Vector3.new(PartUtility.Project(TestPart, Vector3.new(-1, -1, -6), "Front"))).to.be.near(Vector3.new(1, 0.75, 3), 0.001)
            expect(Vector3.new(PartUtility.Project(TestPart, Vector3.new(-1, -1, -3), "Front"))).to.be.near(Vector3.new(1, 0.75, 0), 0.001)
            expect(Vector3.new(PartUtility.Project(TestPart, Vector3.new(-1, -1, -2), "Front"))).to.be.near(Vector3.new(1, 0.75, -1), 0.001)

            --Assert the other sides are valid.
            --The same math is used, so only a single result for the other side is used.
            expect(Vector3.new(PartUtility.Project(TestPart, Vector3.new(-0.5, 1, 5), "Back"))).to.be.near(Vector3.new(0.25, 0.25, 2), 0.001)
            expect(Vector3.new(PartUtility.Project(TestPart, Vector3.new(-3, 1, -1.5), "Left"))).to.be.near(Vector3.new(0.25, 0.25, 2), 0.001)
            expect(Vector3.new(PartUtility.Project(TestPart, Vector3.new(3, 1, 1.5), "Right"))).to.be.near(Vector3.new(0.25, 0.25, 2), 0.001)
            expect(Vector3.new(PartUtility.Project(TestPart, Vector3.new(-0.5, 4, 1.5), "Top"))).to.be.near(Vector3.new(0.25, 0.25, 2), 0.001)
            expect(Vector3.new(PartUtility.Project(TestPart, Vector3.new(0.5, -4, 1.5), "Bottom"))).to.be.near(Vector3.new(0.25, 0.25, 2), 0.001)
        end)
    end)
end