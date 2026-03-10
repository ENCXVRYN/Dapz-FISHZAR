-- [[ DAPZX ATOMIC | [span_0](start_span)FISHZAR V14.0.0 - OPTIMIZED ]][span_0](end_span)
[span_1](start_span)local RunService = game:GetService("RunService")[span_1](end_span)
[span_2](start_span)local ReplicatedStorage = game:GetService("ReplicatedStorage")[span_2](end_span)
[span_3](start_span)local Players = game:GetService("Players")[span_3](end_span)
[span_4](start_span)local LocalPlayer = Players.LocalPlayer[span_4](end_span)
[span_5](start_span)local Stats = game:GetService("Stats")[span_5](end_span)
[span_6](start_span)local FishingSystem = ReplicatedStorage:WaitForChild("FishingSystem")[span_6](end_span)
[span_7](start_span)local AnimController = require(FishingSystem.FishingModules:WaitForChild("AnimationController"))[span_7](end_span)

_[span_8](start_span)G.Config = {Farming = false, Delay = 3, WalkWater = false, AntiDrown = false, Streamer = false, AntiStaff = false}[span_8](end_span)

-- [[ DEBUGGER & UTILS ]]
[span_9](start_span)local function Log(msg) print("[DapzX Debug]: " .. msg) end[span_9](end_span)

-- [[ CORE SYSTEMS ]]
local Systems = {
    Mancing = function()
        [span_10](start_span)if not _G.Config.Farming or not LocalPlayer.Character then return end[span_10](end_span)
        [span_11](start_span)local tool = LocalPlayer.Character:FindFirstChildWhichIsA("Tool")[span_11](end_span)
        [span_12](start_span)if not tool then return end[span_12](end_span)
        
        [span_13](start_span)local root = LocalPlayer.Character.HumanoidRootPart[span_13](end_span)
        [span_14](start_span)local castPos = root.Position + (root.CFrame.LookVector * 15)[span_14](end_span)
        
        [span_15](start_span)AnimController:Play("PrepareCast", 0.1)[span_15](end_span)
        [span_16](start_span)FishingSystem.CastReplication:FireServer(castPos, root.Position, tool.Name, 99.5)[span_16](end_span)
        [span_17](start_span)task.wait(1.5);[span_17](end_span)
        [span_18](start_span)FishingSystem.PrecalcFish:InvokeServer(); task.wait(0.5)[span_18](end_span)
        [span_19](start_span)FishingSystem.ReplicatePullAlert:FireServer("rbxassetid://76503247176490")[span_19](end_span)
        [span_20](start_span)task.wait(_G.Config.Delay)[span_20](end_span)
        [span_21](start_span)FishingSystem.FishGiver:FireServer({ ["hookPosition"] = castPos })[span_21](end_span)
        [span_22](start_span)task.wait(1.5);[span_22](end_span)
        [span_23](start_span)FishingSystem.CleanupCast:FireServer()[span_23](end_span)
    end,

    Security = function()
        [span_24](start_span)if _G.Config.Streamer then[span_24](end_span)
            [span_25](start_span)for _, p in pairs(Players:GetPlayers()) do[span_25](end_span)
                [span_26](start_span)if p.Character and p.Character:FindFirstChild("Head") then[span_26](end_span)
                    [span_27](start_span)for _, v in pairs(p.Character.Head:GetChildren()) do[span_27](end_span)
                        [span_28](start_span)if v:IsA("BillboardGui") then v.Enabled = false end[span_28](end_span)
                    end
                end
            end
        end
    end
}

-- [[ UI & TAB SETUP ]]
[span_29](start_span)local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()[span_29](end_span)
[span_30](start_span)local Window = WindUI:CreateWindow({Title = "DapzX Atomic V14", Icon = "solar:atom-bold", Size = UDim2.fromOffset(580, 460)})[span_30](end_span)

[span_31](start_span)local MainTab = Window:Tab({Title = "Main", Icon = "solar:home-smile-bold"})[span_31](end_span)
[span_32](start_span)MainTab:Section({Title = "DapzX Atomic System © 2026"})[span_32](end_span)
[span_33](start_span)MainTab:Button({Title = "Copy Discord Link", Callback = function() setclipboard("https://discord.gg/getsades") end})[span_33](end_span)

[span_34](start_span)local FTab = Window:Tab({Title = "Fishing", Icon = "solar:fishing-rod-bold"})[span_34](end_span)
[span_35](start_span)FTab:Toggle({Title = "Auto Farm", Callback = function(s) _G.Config.Farming = s end})[span_35](end_span)
[span_36](start_span)FTab:Input({Title = "Delay", Placeholder = "3.0", Callback = function(v) _G.Config.Delay = tonumber(v) or 3 end})[span_36](end_span)

-- [[ LOOPS (THREADED) ]]
[span_37](start_span)task.spawn(function() while true do task.wait(0.5);[span_37](end_span)
[span_38](start_span)Systems.Mancing() end end)[span_38](end_span)
[span_39](start_span)task.spawn(function() while true do task.wait(0.1); Systems.Security() end end)[span_39](end_span)

-- Walk on Water (Optimized)
[span_40](start_span)RunService.Heartbeat:Connect(function()[span_40](end_span)
    [span_41](start_span)if _G.Config.WalkWater and LocalPlayer.Character then[span_41](end_span)
        [span_42](start_span)local root = LocalPlayer.Character.HumanoidRootPart[span_42](end_span)
        [span_43](start_span)if root.Position.Y < 5 then root.Velocity = Vector3.new(0, 5, 0) end[span_43](end_span)
    end
end)
