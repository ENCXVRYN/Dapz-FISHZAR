-- [[ DAPZX ATOMIC | FISHZAR V1 - HYBRID UPGRADE ]]
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Loader WindUI gaya V1 (Paling stabil untuk Android)
local WindUI
if game:GetService("RunService"):IsStudio() then
     WindUI = require(ReplicatedStorage:WaitForChild("WindUI"):WaitForChild("Init"))
else
     WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
end

-- ============================================================================
-- GLOBAL CONFIG (Gaya V14)
-- ============================================================================
_G.Config = {
    Farming = false,
    Delay = 3.0,
    WalkWater = false,
    Streamer = false
}

local FishingRods = {
    "Flimsy Rod", "Carbon Rod", "Fast Rod", "Long Rod", "Great Rod", 
    "Sovereign Rod", "Mythical Rod", "Magma Rod", "Ice Rod", "Reinforced Rod"
}

-- ============================================================================
-- CORE SYSTEMS (Modular Architecture V14)
-- ============================================================================
local FishingSystem = ReplicatedStorage:WaitForChild("FishingSystem")
local AnimController = require(FishingSystem.FishingModules:WaitForChild("AnimationController"))

local Systems = {}

-- Logika Deteksi Pancingan Otomatis (V1)
Systems.GetRod = function()
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
end

-- Logika Mancing (V14)
Systems.Mancing = function()
    if not _G.Config.Farming or not LocalPlayer.Character then return end
    
    local tool = Systems.GetRod()
    if not tool then return end
    
    local root = LocalPlayer.Character.HumanoidRootPart
    local castPos = root.Position + (root.CFrame.LookVector * 15)
    
    -- Fast Cast Logic
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
end

-- ============================================================================
-- UI SETUP (Struktur Penulisan V1 - Anti Error Android)
-- ============================================================================
local Window = WindUI:CreateWindow({
    Title = "DapzX Atomic Hybrid",
    Icon = "solar:atom-bold",
    Size = UDim2.fromOffset(580, 460)
})

local InfoTab = Window:Tab({
    Title = "Info",
    Icon = "solar:info-circle-bold"
})

InfoTab:Section({Title = "V1 Hybrid Edition"})
InfoTab:Label({Text = "Base: V1 Stable"})
InfoTab:Label({Text = "Engine: V14 Modular"})
InfoTab:Label({Text = "Developer: TheoXAtomic"})

local FTab = Window:Tab({
    Title = "Fishing",
    Icon = "solar:fishing-rod-bold"
})

FTab:Section({Title = "Main Farm"})

FTab:Toggle({
    Title = "Auto Farm (Auto Rod)",
    Callback = function(state)
        _G.Config.Farming = state
    end
})

FTab:Input({
    Title = "Delay",
    Placeholder = "3.0",
    Callback = function(val)
        _G.Config.Delay = tonumber(val) or 3
    end
})

-- ============================================================================
-- LOOPS & UTILS
-- ============================================================================
task.spawn(function()
    while true do
        task.wait(0.5)
        if _G.Config.Farming then
            pcall(function() Systems.Mancing() end)
        end
    end
end)

-- Walk on Water (Logika V14)
RunService.Heartbeat:Connect(function()
    if _G.Config.WalkWater and LocalPlayer.Character then
        local root = LocalPlayer.Character.HumanoidRootPart
        if root.Position.Y < 5 then
            root.Velocity = Vector3.new(root.Velocity.X, 5, root.Velocity.Z)
        end
    end
end)

print("✅ DapzX Atomic Hybrid Loaded!")
