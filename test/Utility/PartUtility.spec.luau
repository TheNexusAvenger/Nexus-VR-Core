--Tests for PartUtility.
--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PartUtility = require(ReplicatedStorage.Packages.NexusVRCore.Utility.PartUtility)

return function()
    local TestPart = nil
    beforeEach(function()
        TestPart = Instance.new("Part")
        TestPart.Size = Vector3.new(2,4,6)
    end)

    local function expectNear(Actual: Vector3, Expected: Vector3): ()
        local ActualValues, ExpectedValues = {Actual.X, Actual.Y, Actual.Z}, {Expected.X, Expected.Y, Expected.Z}
        for i, ActualValue in ActualValues do
            expect(math.abs(ActualValue - ExpectedValues[i]) < 0.05).to.equal(true)
        end
    end

    describe("The part utility", function()
        it("should raycast.", function()
            --Assert the front is valid.
            expectNear(Vector3.new(PartUtility.Raycast(TestPart, CFrame.new(0.5, 1, -5) * CFrame.Angles(0, math.pi, 0), "Front")), Vector3.new(0.25, 0.25, 2))
            expectNear(Vector3.new(PartUtility.Raycast(TestPart, CFrame.new(0.5, 1, -3) * CFrame.Angles(0, math.rad(15), 0) * CFrame.new(0,0,-2) * CFrame.Angles(0,math.pi,0), "Front")), Vector3.new(0.25, 0.25, 2))
            expectNear(Vector3.new(PartUtility.Raycast(TestPart, CFrame.new(0.5, 1, -3) * CFrame.Angles(math.rad(15), math.rad(15), 0) * CFrame.new(0, 0, -2) * CFrame.Angles(0, math.pi, 0), "Front")), Vector3.new(0.25, 0.25, 2))
            expectNear(Vector3.new(PartUtility.Raycast(TestPart, CFrame.new(0.5, 1, -3) * CFrame.Angles(math.rad(15), math.rad(15), 0) * CFrame.new(0, 0, -2), "Front")), Vector3.new(0.25, 0.25, -2))

            --Assert the other sides are valid.
            --The same math is used, so only a single result for the other side is used.
            expectNear(Vector3.new(PartUtility.Raycast(TestPart, CFrame.new(Vector3.new(-0.5, 1, 5), Vector3.new(-0.5, 1, 3)), "Back")), Vector3.new(0.25, 0.25, 2))
            expectNear(Vector3.new(PartUtility.Raycast(TestPart, CFrame.new(Vector3.new(-3, 1, -1.5), Vector3.new(-1, 1, -1.5)), "Left")), Vector3.new(0.25, 0.25, 2))
            expectNear(Vector3.new(PartUtility.Raycast(TestPart, CFrame.new(Vector3.new(3, 1, 1.5), Vector3.new(1, 1, 1.5)), "Right")), Vector3.new(0.25, 0.25, 2))
            expectNear(Vector3.new(PartUtility.Raycast(TestPart, CFrame.new(Vector3.new(-0.5, 4, 1.5), Vector3.new(-0.5, 2, 1.5)), "Top")), Vector3.new(0.25, 0.25, 2))
            expectNear(Vector3.new(PartUtility.Raycast(TestPart, CFrame.new(Vector3.new(0.5, -4, 1.5), Vector3.new(0.5, -2, 1.5)), "Bottom")), Vector3.new(0.25, 0.25, 2))
        end)

        it("should project.", function()
            --Assert the front is valid.
            expectNear(Vector3.new(PartUtility.Project(TestPart, Vector3.new(1.5, 3, -5), "Front")), Vector3.new(-0.25, -0.25, 2))
            expectNear(Vector3.new(PartUtility.Project(TestPart, Vector3.new(1, 2, -5), "Front")), Vector3.new(0, 0, 2))
            expectNear(Vector3.new(PartUtility.Project(TestPart, Vector3.new(0.5, 2, -5), "Front")), Vector3.new(0.25, 0, 2))
            expectNear(Vector3.new(PartUtility.Project(TestPart, Vector3.new(0, 2, -5), "Front")), Vector3.new(0.5, 0, 2))
            expectNear(Vector3.new(PartUtility.Project(TestPart, Vector3.new(-0.5, 2, -5), "Front")), Vector3.new(0.75, 0, 2))
            expectNear(Vector3.new(PartUtility.Project(TestPart, Vector3.new(-1, 2, -5), "Front")), Vector3.new(1, 0, 2))
            expectNear(Vector3.new(PartUtility.Project(TestPart, Vector3.new(1, 1, -5), "Front")), Vector3.new(0, 0.25, 2))
            expectNear(Vector3.new(PartUtility.Project(TestPart, Vector3.new(0.5, 1, -5), "Front")), Vector3.new(0.25, 0.25, 2))
            expectNear(Vector3.new(PartUtility.Project(TestPart, Vector3.new(0, 1, -5), "Front")), Vector3.new(0.5, 0.25, 2))
            expectNear(Vector3.new(PartUtility.Project(TestPart, Vector3.new(-0.5, 1, -5), "Front")), Vector3.new(0.75, 0.25, 2))
            expectNear(Vector3.new(PartUtility.Project(TestPart, Vector3.new(-1, 1, -5), "Front")), Vector3.new(1, 0.25, 2))
            expectNear(Vector3.new(PartUtility.Project(TestPart, Vector3.new(1, -1, -5), "Front")), Vector3.new(0, 0.75, 2))
            expectNear(Vector3.new(PartUtility.Project(TestPart, Vector3.new(0.5, -1, -5), "Front")), Vector3.new(0.25, 0.75, 2))
            expectNear(Vector3.new(PartUtility.Project(TestPart, Vector3.new(0, -1, -5), "Front")), Vector3.new(0.5, 0.75, 2))
            expectNear(Vector3.new(PartUtility.Project(TestPart, Vector3.new(-0.5, -1, -5), "Front")), Vector3.new(0.75, 0.75, 2))
            expectNear(Vector3.new(PartUtility.Project(TestPart, Vector3.new(-1, -1, -5), "Front")), Vector3.new(1, 0.75, 2))
            expectNear(Vector3.new(PartUtility.Project(TestPart, Vector3.new(-1, -1, -6), "Front")), Vector3.new(1, 0.75, 3))
            expectNear(Vector3.new(PartUtility.Project(TestPart, Vector3.new(-1, -1, -3), "Front")), Vector3.new(1, 0.75, 0))
            expectNear(Vector3.new(PartUtility.Project(TestPart, Vector3.new(-1, -1, -2), "Front")), Vector3.new(1, 0.75, -1))

            --Assert the other sides are valid.
            --The same math is used, so only a single result for the other side is used.
            expectNear(Vector3.new(PartUtility.Project(TestPart, Vector3.new(-0.5, 1, 5), "Back")), Vector3.new(0.25, 0.25, 2))
            expectNear(Vector3.new(PartUtility.Project(TestPart, Vector3.new(-3, 1, -1.5), "Left")), Vector3.new(0.25, 0.25, 2))
            expectNear(Vector3.new(PartUtility.Project(TestPart, Vector3.new(3, 1, 1.5), "Right")), Vector3.new(0.25, 0.25, 2))
            expectNear(Vector3.new(PartUtility.Project(TestPart, Vector3.new(-0.5, 4, 1.5), "Top")), Vector3.new(0.25, 0.25, 2))
            expectNear(Vector3.new(PartUtility.Project(TestPart, Vector3.new(0.5, -4, 1.5), "Bottom")), Vector3.new(0.25, 0.25, 2))
        end)
    end)
end