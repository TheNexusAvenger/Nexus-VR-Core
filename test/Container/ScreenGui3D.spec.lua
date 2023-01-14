--[[
TheNexusAvenger

Tests for ScreenGui3D.
--]]
--!strict
--$NexusUnitTestExtensions

local Workspace = game:GetService("Workspace")

local NexusVRCore = game:GetService("ReplicatedStorage"):WaitForChild("NexusVRCore")
local ScreenGui3D = require(NexusVRCore:WaitForChild("Container"):WaitForChild("ScreenGui3D"))

return function()
    local TestScreenGui3D = nil
    beforeEach(function()
        TestScreenGui3D = ScreenGui3D.new()
        TestScreenGui3D.UpdateEvent:Disconnect()
    end)
    afterEach(function()
        TestScreenGui3D:Destroy()
    end)

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
            expect(TestScreenGui3D.Adornee.Size).to.be.near(Vector3.new(6, 6, MinPartSize), 0.05)
            TestScreenGui3D.Depth = 3
            task.wait()
            expect(TestScreenGui3D.Adornee.Size).to.be.near(Vector3.new(6 / math.sqrt(3), 6 / math.sqrt(3), MinPartSize), 0.05)
            TestScreenGui3D.Depth = 3 * math.sqrt(3)
            task.wait()
            expect(TestScreenGui3D.Adornee.Size).to.be.near(Vector3.new(6, 6, MinPartSize), 0.05)
            TestScreenGui3D.Depth = 6 * math.sqrt(3)
            task.wait()
            expect(TestScreenGui3D.Adornee.Size).to.be.near(Vector3.new(12, 12, MinPartSize), 0.05)
            TestScreenGui3D.CanvasSize = Vector2.new(500, 250)
            task.wait()
            expect(TestScreenGui3D.Adornee.Size).to.be.near(Vector3.new(12, 6, MinPartSize), 0.05)
            TestScreenGui3D.CanvasSize = Vector2.new(250, 500)
            task.wait()
            expect(TestScreenGui3D.Adornee.Size).to.be.near(Vector3.new(6, 12, MinPartSize), 0.05)
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
            expect(TestScreenGui3D.LastRotation).to.be.near(CameraRotation, 0.05)

            --Assert the frame is eased.
            TestScreenGui3D.Easing = 1
            TestScreenGui3D.LastRotation = StartCFrame
            for i = 1, 10 do
                local ExpectedCFrame = StartCFrame:Lerp(CameraRotation, 0.1)
                StartCFrame = ExpectedCFrame
                TestScreenGui3D:UpdateCFrame(0.1)
                expect(TestScreenGui3D.LastRotation).to.be.near(ExpectedCFrame, 0.05)
            end
        end)
    end)
end