-- [[ DAPZX ATOMIC | FISHZAR V14.1.0 - HYBRID FIXED ]]
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local FishingSystem = ReplicatedStorage:WaitForChild("FishingSystem")
local AnimController = require(FishingSystem.FishingModules:WaitForChild("AnimationController"))

_G.Config = {Farming = false, Delay = 3, WalkWater = false, Streamer = false}

-- [[ DATA PANCINGAN (DARI V1) ]]
local FishingRods = {
    "Flimsy Rod", "Carbon Rod", "Fast Rod", "Long Rod", "Great Rod", 
    "Sovereign Rod", "Mythical Rod", "Magma Rod", "Ice Rod", "Reinforced Rod"
[span_4](start_span)}

-- [[ CORE SYSTEMS ]]
local Systems = {
    -- Logika Auto-Detect & Equip Rod[span_4](end_span)
    GetRod = function()
        local char = LocalPlayer.Character
        if not char then return nil end
        
        for _, rodName in ipairs(FishingRods) do
            local rod = char:FindFirstChild(rodName) or LocalPlayer.Backpack:FindFirstChild(rodName)
            if rod then 
                if rod.Parent == LocalPlayer.Backpack then rod.Parent = char end
                return rod 
            end
        end
        return char:FindFirstChildWhichIsA("Tool")
    end,

    Mancing = function()
        if not _G.Config.Farming or not LocalPlayer.Character then return end
        
        local tool = Systems.GetRod()
        if not tool then return end
        
        local root = LocalPlayer.Character.HumanoidRootPart
        local castPos = root.Position + (root.CFrame.LookVector * 15)
        
        [span_5](start_span)AnimController:Play("PrepareCast", 0.1)[span_5](end_span)
        [span_6](start_span)FishingSystem.CastReplication:FireServer(castPos, root.Position, tool.Name, 99.5)[span_6](end_span)
        
        task.wait(1.5)
        [span_7](start_span)FishingSystem.PrecalcFish:InvokeServer()[span_7](end_span)
        task.wait(0.5)
        
        [span_8](start_span)FishingSystem.ReplicatePullAlert:FireServer("rbxassetid://76503247176490")[span_8](end_span)
        
        [span_9](start_span)task.wait(_G.Config.Delay)[span_9](end_span)
        [span_10](start_span)FishingSystem.FishGiver:FireServer({ ["hookPosition"] = castPos })[span_10](end_span)
        
        task.wait(1.2)
        [span_11](start_span)FishingSystem.CleanupCast:FireServer()[span_11](end_span)
    end,

    Security = function()
        if _G.Config.Streamer then
            for _, p in pairs(Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("Head") then
                    for _, v in pairs(p.Character.Head:GetChildren()) do
                        [span_12](start_span)if v:IsA("BillboardGui") then v.Enabled = false end[span_12](end_span)
                    end
                end
            end
        end
    end
}

-- [[ UI SETUP ]]
local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
end)

if not success then return end

local Window = WindUI:CreateWindow({
    Title = "DapzX Atomic V14.1", 
    Icon = "solar:atom-bold", 
    Size = UDim2.fromOffset(580, 460)
})

-- [[ TAB INFO ]]
local InfoTab = Window:Tab({Title = "Info", Icon = "solar:info-circle-bold"})
InfoTab:Section({Title = "📢 Latest Update: v14.1.0"})
InfoTab:Paragraph({
    Title = "Recode Total by TheoXAtomic",
    Desc = "Halo semua! Kami baru saja melakukan Recode Total pada sistem utama kami.\n\n" ..
           "🚀 OPTIMASI SISTEM:\n" ..
           "- Modular Architecture Aktif.\n" ..
           "- Auto-Detect Rod (V1 Logic Integrated).\n" ..
           "- Fixed Android Element Loading Issue."
})
InfoTab:Section({Title = "Credits"})
InfoTab:Label({Text = "Lead Developer: TheoXAtomic"})

-- [[ TAB FISHING ]]
local FTab = Window:Tab({Title = "Fishing", Icon = "solar:fishing-rod-bold"})
FTab:Section({Title = "Automation"})
FTab:Toggle({
    Title = "Auto Farm (Auto Rod)", 
    Callback = function(s) _G.Config.Farming = s end
})
FTab:Input({
    Title = "Delay", 
    Placeholder = "3.0", 
    Callback = function(v) _G.Config.Delay = tonumber(v) or 3 end
})

-- [[ LOOPS ]]
task.spawn(function() 
    while task.wait(0.5) do 
        pcall(function() Systems.Mancing() end)
    end 
end)

task.spawn(function() 
    while task.wait(0.1) do 
        pcall(function() Systems.Security() end) 
    end 
end)

-- Walk on Water
RunService.Heartbeat:Connect(function()
    if _G.Config.WalkWater and LocalPlayer.Character then
        local root = LocalPlayer.Character.HumanoidRootPart
        if root.Position.Y < 5 then root.Velocity = Vector3.new(0, 5, 0) end
    end
end)
