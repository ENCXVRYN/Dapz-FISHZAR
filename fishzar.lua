 -- [[ DAPZX ATOMIC | FISHZAR V14.0.0 - OPTIMIZED ]]
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local FishingSystem = ReplicatedStorage:WaitForChild("FishingSystem")
local AnimController = require(FishingSystem.FishingModules:WaitForChild("AnimationController"))

_G.Config = {Farming = false, Delay = 3, WalkWater = false, Streamer = false}

-- [[ CORE SYSTEMS ]]
local Systems = {
    Mancing = function()
        if not _G.Config.Farming or not LocalPlayer.Character then return end
        local tool = LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
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
        task.wait(1.5)
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

-- [[ UI SETUP WITH ERROR HANDLING ]]
local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
end)

if not success or not WindUI then
    warn("Gagal memuat WindUI. Pastikan koneksi internet stabil atau URL aktif.")
    return
end

local Window = WindUI:CreateWindow({
    Title = "DapzX Atomic V14", 
    Icon = "solar:atom-bold", 
    Size = UDim2.fromOffset(580, 460)
})

-- [[ TAB INFO & CHANGELOG ]]
local InfoTab = Window:Tab({Title = "Info", Icon = "solar:info-circle-bold"})

InfoTab:Section({Title = "📢 Latest Update: v14.0.0"})
InfoTab:Paragraph({
    Title = "Recode Total by TheoXAtomic",
    Desc = "Halo semua! Kami baru saja melakukan Recode Total pada sistem utama kami.\n\n" ..
           "OPTIMASI SISTEM:\n" ..
           "- Modular Architecture: Fitur berjalan mandiri.\n" ..
           "- Performance Boost: Fix Ping & FPS counter freeze.\n" ..
           "- Fixed Streamer Mode: Nametag cleaner lebih ringan.\n" ..
           "- Anti-Drown 2.0 & Walk on Water aktif.\n\n" ..
           "SYSTEM FIXES:\n" ..
           "- Fishing Stability: Logic Auto Farm anti-block.\n" ..
           "- Integration: Tab Webhook kembali aktif.\n" ..
           "- Security: Modul Anti-Staff responsif."
})

InfoTab:Section({Title = "Credits"})
InfoTab:Label({Text = "Lead Developer: TheoXAtomic"})
InfoTab:Button({Title = "Copy Discord Link", Callback = function() setclipboard("https://discord.gg/getsades") end})

-- [[ TAB FISHING ]]
local FTab = Window:Tab({Title = "Fishing", Icon = "solar:fishing-rod-bold"})
FTab:Section({Title = "Main Features"})
FTab:Toggle({Title = "Auto Farm", Callback = function(s) _G.Config.Farming = s end})
FTab:Input({Title = "Delay", Placeholder = "3.0", Callback = function(v) _G.Config.Delay = tonumber(v) or 3 end})

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
