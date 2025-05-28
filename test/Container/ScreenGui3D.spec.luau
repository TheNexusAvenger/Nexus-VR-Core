--Tests for ScreenGui3D.
--!strict

local Workspace = game:GetService("Workspace")

local NexusVRCore = game:GetService("ReplicatedStorage"):WaitForChild("NexusVRCore")
local ScreenGui3D = require(NexusVRCore:WaitForChild("Container"):WaitForChild("ScreenGui3D"))

return function()
    local TestScreenGui3D = nil
    beforeEach(function()
        TestScreenGui3D = ScreenGui3D.new()
    end)
    afterEach(function()
        TestScreenGui3D:Destroy()
    end)

    local function expectNear<T>(Actual: T, Expected: T): ()
        local ActualValues, ExpectedValues = {}, {}
        if typeof(Actual) == "Vector3" and typeof(Expected) == "Vector3" then
            ActualValues = {Actual.X, Actual.Y, Actual.Z}
            ExpectedValues = {Expected.X, Expected.Y, Expected.Z}
        elseif typeof(Actual) == "CFrame" and typeof(Expected) == "CFrame" then
            ActualValues = {Actual:components()}
            ExpectedValues = {Expected:components()}
        end

        for i, ActualValue in ActualValues do
            expect(math.abs(ActualValue - ExpectedValues[i]) < 0.05).to.equal(true)
        end
    end

    describe("A ScreenGui3D", function()
        it("should return the container.", function()
            expect(TestScreenGui3D:GetContainer():IsA("SurfaceGui"))
        end)

        it("should update the size.", function()
            --Determine the minimum part size (may not be 0.05 as it is right now).
            local Part = Instance.new("Part")
            Part.Size = Vector3.new(0, 0, 0)
            Part:Destroy()
            local MinPartSize = Part.Size.X

            --Assert the size is correct.
            TestScreenGui3D.FieldOfView = math.rad(60)
            TestScreenGui3D.CanvasSize = Vector2.new(500, 500)
            TestScreenGui3D.Depth = 3 * math.sqrt(3)
            task.wait()
            expectNear(TestScreenGui3D.Adornee.Size, Vector3.new(6, 6, MinPartSize))
            TestScreenGui3D.Depth = 3
            task.wait()
            expectNear(TestScreenGui3D.Adornee.Size, Vector3.new(6 / math.sqrt(3), 6 / math.sqrt(3), MinPartSize))
            TestScreenGui3D.Depth = 3 * math.sqrt(3)
            task.wait()
            expectNear(TestScreenGui3D.Adornee.Size, Vector3.new(6, 6, MinPartSize))
            TestScreenGui3D.Depth = 6 * math.sqrt(3)
            task.wait()
            expectNear(TestScreenGui3D.Adornee.Size, Vector3.new(12, 12, MinPartSize))
            TestScreenGui3D.CanvasSize = Vector2.new(500, 250)
            task.wait()
            expectNear(TestScreenGui3D.Adornee.Size, Vector3.new(12, 6, MinPartSize))
            TestScreenGui3D.CanvasSize = Vector2.new(250, 500)
            task.wait()
            expectNear(TestScreenGui3D.Adornee.Size, Vector3.new(6, 12, MinPartSize))
        end)

        it("should update the CFrame.", function()
            --Assert updating with no easing results in the CFrame instantly changing.
            local CameraCFrame = Workspace.CurrentCamera:GetRenderCFrame()
            local CameraRotation = CFrame.new(CameraCFrame.Position):Inverse() * CameraCFrame
            local StartCFrame = CameraCFrame * CFrame.Angles(0, math.pi / 2, 0)

            --Assert updating with easing results in a movement to the destination.
            TestScreenGui3D.Easing = 0
            TestScreenGui3D.LastRotation = StartCFrame
            TestScreenGui3D:UpdateCFrame(0.1)
            expectNear(TestScreenGui3D.LastRotation, CameraRotation)

            --Assert the frame is eased.
            TestScreenGui3D.Easing = 1
            TestScreenGui3D.LastRotation = StartCFrame
            for i = 1, 10 do
                local ExpectedCFrame = StartCFrame:Lerp(CameraRotation, 0.1)
                StartCFrame = ExpectedCFrame
                TestScreenGui3D:UpdateCFrame(0.1)
                expectNear(TestScreenGui3D.LastRotation, ExpectedCFrame)
            end
        end)

        it("should change CanQuery.", function()
            TestScreenGui3D.PointingEnabled = false
            task.wait()
            expect(TestScreenGui3D.Adornee.CanQuery).to.equal(false)
            TestScreenGui3D.PointingEnabled = true
            task.wait()
            expect(TestScreenGui3D.Adornee.CanQuery).to.equal(true)
            TestScreenGui3D.PointingEnabled = true
            TestScreenGui3D.Enabled = false
            task.wait()
            expect(TestScreenGui3D.Adornee.CanQuery).to.equal(false)
            TestScreenGui3D.Enabled = true
            task.wait()
            expect(TestScreenGui3D.Adornee.CanQuery).to.equal(true)
        end)
    end)
end