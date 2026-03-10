-- [[ DAPZX ATOMIC | FISHZAR V14.1.0 - FINAL FIXED ]]
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local FishingSystem = ReplicatedStorage:WaitForChild("FishingSystem")
local AnimController = require(FishingSystem.FishingModules:WaitForChild("AnimationController"))

_G.Config = {Farming = false, Delay = 3, WalkWater = false, Streamer = false}

-- [[ DATA PANCINGAN ]]
local FishingRods = {
    "Flimsy Rod", "Carbon Rod", "Fast Rod", "Long Rod", "Great Rod", 
    "Sovereign Rod", "Mythical Rod", "Magma Rod", "Ice Rod", "Reinforced Rod"
}

-- [[ CORE SYSTEMS ]]
local Systems = {
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
        AnimController:Play("PrepareCast", 0.1)
        FishingSystem.CastReplication:FireServer(castPos, root.Position, tool.Name, 99.5)
        task.wait(1.5)
        FishingSystem.PrecalcFish:InvokeServer()
        task.wait(0.5)
        FishingSystem.ReplicatePullAlert:FireServer("rbxassetid://76503247176490")
        task.wait(_G.Config.Delay)
        FishingSystem.FishGiver:FireServer({ ["hookPosition"] = castPos })
        task.wait(1.2)
        FishingSystem.CleanupCast:FireServer()
    end,

    Security = function()
        if _G.Config.Streamer then
            for _, p in pairs(Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("Head") then
                    for _, v in pairs(p.Character.Head:GetChildren()) do
                        if v:IsA("BillboardGui") then v.Enabled = false end
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

if not success or not WindUI then return end

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
    Desc = "🚀 OPTIMASI SISTEM:\n- Modular Architecture Aktif.\n- Auto-Detect Rod (V1 Logic).\n- Fixed Android Element Loading Issue."
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
    while task.wait(0.5) do pcall(function() Systems.Mancing() end) end 
end)

task.spawn(function() 
    while task.wait(0.1) do pcall(function() Systems.Security() end) end 
end)

-- Walk on Water
RunService.Heartbeat:Connect(function()
    if _G.Config.WalkWater and LocalPlayer.Character then
        local root = LocalPlayer.Character.HumanoidRootPart
        if root.Position.Y < 5 then root.Velocity = Vector3.new(0, 5, 0) end
    end
end)

-- [[ LOADSTRING UNTUK USER ]]
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/ENCXVRYN/Dapz-FISHZAR/refs/heads/main/fishzar.lua"))()
