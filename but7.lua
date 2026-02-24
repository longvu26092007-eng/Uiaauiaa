-- ======================================================================
-- DRACO AUTO-EQUIP DRAGONSTORM (PROFESSIONAL EDITION)
-- Tham khảo logic từ Maru Hub & Min Hub
-- ======================================================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 1. Hàm trang bị vũ khí an toàn (Safe Equip)
local function AutoEquipDragonstorm()
    local Character = LocalPlayer.Character
    local Backpack = LocalPlayer:FindFirstChild("Backpack")
    local CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")

    -- Kiểm tra xem trong nhân vật đã cầm Dragonstorm chưa (Tránh spam lệnh)
    if Character and not Character:FindFirstChild("Dragonstorm") then
        
        -- Nếu Dragonstorm đang nằm trong túi đồ (Backpack)
        if Backpack and Backpack:FindFirstChild("Dragonstorm") then
            local tool = Backpack:FindFirstChild("Dragonstorm")
            Character.Humanoid:EquipTool(tool)
            warn("⚔️ [SYSTEM] Đã cầm Dragonstorm từ Backpack!")
            
        else
            -- Nếu không thấy trong túi (do chưa lấy ra từ Inventory), gọi lệnh Remote cậu vừa bắt được
            warn("📦 [SYSTEM] Đang lấy Dragonstorm từ Inventory...")
            pcall(function()
                CommF:InvokeServer("LoadItem", "Dragonstorm")
            end)
        end
    end
end

-- 2. Vòng lặp duy trì (Auto Maintain)
-- Script sẽ luôn đảm bảo cậu cầm Dragonstorm, nếu cất đi nó sẽ tự lôi ra lại
task.spawn(function()
    while task.wait(1) do -- Kiểm tra mỗi 1 giây để không gây lag máy
        if getgenv().AutoEquipEnabled == true then
            pcall(AutoEquipDragonstorm)
        end
    end
end)

-- 3. Bật/Tắt Script
getgenv().AutoEquipEnabled = true -- Đổi thành false nếu muốn dừng

print("✅ [DRC READY] Auto Equip Dragonstorm đã kích hoạt!")
