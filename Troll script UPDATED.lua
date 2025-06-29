local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local player = game.Players.LocalPlayer

local Window = Rayfield:CreateWindow({
    Name = "Troll Panel 😈",
    LoadingTitle = "Getting Evil...",
    LoadingSubtitle = "By Hunter!",
    ConfigurationSaving = {
        Enabled = false,
    }
})
local MainTab = Window:CreateTab("Main", 4483362458)

-- Loop Touch 🔁💥
local loopTouching = false
MainTab:CreateButton({
    Name = "Loop Touch 🔁 (MAX)",
    Callback = function()
        loopTouching = not loopTouching
        Rayfield:Notify({
            Title = "Touch Spam",
            Content = loopTouching and "MAX Troll Mode Enabled 😈" or "Stopped",
            Duration = 3
        })

        task.spawn(function()
            while loopTouching do
                local char = player.Character
                if not char then continue end
                for _, part in ipairs(workspace:GetDescendants()) do
                    if part:IsA("BasePart") and (part.Name == "Gudock" or part.Name == "사라지는 파트") then
                        for _, limb in ipairs(char:GetDescendants()) do
                            if limb:IsA("BasePart") then
                                firetouchinterest(limb, part, 0)
                                firetouchinterest(limb, part, 1)
                            end
                        end
                    end
                end
                task.wait()
            end
        end)
    end
})

-- Walk on Air ☁️
local UIS = game:GetService("UserInputService")
local walkOnAir = false
local BodyVelocity = nil
MainTab:CreateButton({
    Name = "Walk on Air ☁️",
    Callback = function()
        walkOnAir = not walkOnAir
        Rayfield:Notify({
            Title = "Airwalk",
            Content = walkOnAir and "Enabled" or "Disabled",
            Duration = 3
        })

        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        if walkOnAir then
            BodyVelocity = Instance.new("BodyVelocity")
            BodyVelocity.Velocity = Vector3.new(0, 0, 0)
            BodyVelocity.MaxForce = Vector3.new(0, 1e9, 0)
            BodyVelocity.Parent = hrp

            UIS.JumpRequest:Connect(function()
                if walkOnAir then
                    hrp.Velocity = Vector3.new(0, 50, 0)
                end
            end)
        else
            if BodyVelocity then BodyVelocity:Destroy() end
        end
    end
})

-- Teleport to Troll Button 🛸
MainTab:CreateButton({
    Name = "Teleport to Troll Button 🛸",
    Callback = function()
        if workspace:FindFirstChild("Gudock") then
            player.Character.HumanoidRootPart.CFrame = workspace.Gudock.CFrame + Vector3.new(0, 5, 0)
        else
            Rayfield:Notify({
                Title = "Teleport Failed",
                Content = "Gudock not found in Workspace!",
                Duration = 3
            })
        end
    end
})

MainTab:CreateButton({
    Name = "Fly ✈️",
    Callback = function()
        local plr = game.Players.LocalPlayer
        local char = plr.Character or plr.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")

        local UIS = game:GetService("UserInputService")
        local flying = true
        local speed = 50

        Rayfield:Notify({
            Title = "Fly Mode",
            Content = "Fly Enabled — Press E to toggle",
            Duration = 4
        })

        local bg = Instance.new("BodyGyro")
        bg.P = 9e4
        bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.CFrame = hrp.CFrame
        bg.Parent = hrp

        local bv = Instance.new("BodyVelocity")
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Parent = hrp

        local direction = {
            w = false, s = false, a = false, d = false
        }

        UIS.InputBegan:Connect(function(input, gpe)
            if gpe then return end
            local key = input.KeyCode
            if key == Enum.KeyCode.W then direction.w = true end
            if key == Enum.KeyCode.S then direction.s = true end
            if key == Enum.KeyCode.A then direction.a = true end
            if key == Enum.KeyCode.D then direction.d = true end
            if key == Enum.KeyCode.E then
                flying = not flying
                Rayfield:Notify({
                    Title = "Fly",
                    Content = flying and "Fly Enabled" or "Fly Disabled",
                    Duration = 3
                })
                if not flying then
                    bg:Destroy()
                    bv:Destroy()
                end
            end
        end)

        UIS.InputEnded:Connect(function(input)
            local key = input.KeyCode
            if key == Enum.KeyCode.W then direction.w = false end
            if key == Enum.KeyCode.S then direction.s = false end
            if key == Enum.KeyCode.A then direction.a = false end
            if key == Enum.KeyCode.D then direction.d = false end
        end)

        task.spawn(function()
            while flying and bv and bg and hrp do
                task.wait()
                local cam = workspace.CurrentCamera
                local move = Vector3.new()

                if direction.w then move += cam.CFrame.LookVector end
                if direction.s then move -= cam.CFrame.LookVector end
                if direction.a then move -= cam.CFrame.RightVector end
                if direction.d then move += cam.CFrame.RightVector end

                if move.Magnitude > 0 then
                    bv.Velocity = move.Unit * speed
                else
                    bv.Velocity = Vector3.zero
                end

                bg.CFrame = cam.CFrame
            end
        end)
    end
})

