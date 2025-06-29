local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")

local Window = Rayfield:CreateWindow({
    Name = "Troll Panel 😈",
    LoadingTitle = "Getting Evil...",
    LoadingSubtitle = "By Hunter!",
    ConfigurationSaving = {
        Enabled = false,
    }
})

-- MAIN TAB
local MainTab = Window:CreateTab("Main", 4483362458)

-- Loop Touch Button
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

-- Walk on Air
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
            BodyVelocity = Instance.new("BodyVelocity", hrp)
            BodyVelocity.Velocity = Vector3.new(0, 0, 0)
            BodyVelocity.MaxForce = Vector3.new(0, 1e9, 0)
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

-- Teleport
MainTab:CreateButton({
    Name = "Teleport to Troll Button 🛸",
    Callback = function()
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp and workspace:FindFirstChild("Gudock") then
            hrp.CFrame = workspace.Gudock.CFrame + Vector3.new(0, 5, 0)
        end
    end
})

-- Fly Toggle GUI Button
local flying = false
local flyConnection
MainTab:CreateButton({
    Name = "Toggle Fly ✈️",
    Callback = function()
        flying = not flying
        Rayfield:Notify({
            Title = "Fly Mode",
            Content = flying and "Enabled" or "Disabled",
            Duration = 3
        })

        local char = player.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        if flying then
            local bg = Instance.new("BodyGyro", hrp)
            bg.P = 9e4
            bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            bg.CFrame = hrp.CFrame

            local bv = Instance.new("BodyVelocity", hrp)
            bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            bv.Velocity = Vector3.zero

            flyConnection = game:GetService("RunService").RenderStepped:Connect(function()
                local cam = workspace.CurrentCamera
                local direction = Vector3.zero

                if UIS:IsKeyDown(Enum.KeyCode.W) then direction += cam.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.S) then direction -= cam.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.A) then direction -= cam.CFrame.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.D) then direction += cam.CFrame.RightVector end

                bv.Velocity = direction.Unit * 50
                if direction.Magnitude == 0 then bv.Velocity = Vector3.zero end

                bg.CFrame = cam.CFrame
            end)
        else
            if flyConnection then flyConnection:Disconnect() end
            for _, obj in ipairs(hrp:GetChildren()) do
                if obj:IsA("BodyVelocity") or obj:IsA("BodyGyro") then
                    obj:Destroy()
                end
            end
        end
    end
})

-------------------------------------------------
-- PLAYER TAB: WalkSpeed + JumpPower Settings --
-------------------------------------------------
local PlayerTab = Window:CreateTab("Player", 4483362458)

PlayerTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 200},
    Increment = 1,
    Default = 16,
    Callback = function(value)
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = value
        end
    end
})

PlayerTab:CreateSlider({
    Name = "JumpPower",
    Range = {50, 300},
    Increment = 5,
    Default = 50,
    Callback = function(value)
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.JumpPower = value
        end
    end
})

-- Wallhop GUI
PlayerTab:CreateButton({
    Name = "Wallhop Toggle GUI 🧱",
    Callback = function()
        -- Check if already exists
        if game.CoreGui:FindFirstChild("WallhopToggleGUI") then return end

        local screenGui = Instance.new("ScreenGui", game.CoreGui)
        screenGui.Name = "WallhopToggleGUI"
        screenGui.ResetOnSpawn = false

        local frame = Instance.new("Frame", screenGui)
        frame.Size = UDim2.new(0, 200, 0, 100)
        frame.Position = UDim2.new(0.5, -100, 0.5, -50)
        frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

        local toggle = Instance.new("TextButton", frame)
        toggle.Size = UDim2.new(1, 0, 0.5, 0)
        toggle.Position = UDim2.new(0, 0, 0, 0)
        toggle.Text = "Wallhop: OFF"
        toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        toggle.TextColor3 = Color3.new(1,1,1)

        local enabled = false
        toggle.MouseButton1Click:Connect(function()
            enabled = not enabled
            toggle.Text = "Wallhop: " .. (enabled and "ON" or "OFF")

            -- You can handle wallhop logic here
            -- Example: Rotate camera quickly
            if enabled then
                local cam = workspace.CurrentCamera
                local originalCF = cam.CFrame
                cam.CFrame = originalCF * CFrame.Angles(0, math.rad(90), 0)
                task.wait(0.2)
                cam.CFrame = originalCF
            end
        end)

        local destroyBtn = Instance.new("TextButton", frame)
        destroyBtn.Size = UDim2.new(1, 0, 0.5, 0)
        destroyBtn.Position = UDim2.new(0, 0, 0.5, 0)
        destroyBtn.Text = "Destroy GUI ❌"
        destroyBtn.BackgroundColor3 = Color3.fromRGB(100, 30, 30)
        destroyBtn.TextColor3 = Color3.new(1,1,1)

        destroyBtn.MouseButton1Click:Connect(function()
            screenGui:Destroy()
        end)
    end
})
