-- ======================================================================
-- DRACO AUTO-EQUIP V9.0 - ANTI-ERROR & SMART SYNC
-- Giải quyết lỗi: Báo lỗi đỏ, đơ menu, không cầm được đồ
-- ======================================================================

local Player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function SmartEquip(itemName)
    local char = Player.Character
    if not char or not char:FindFirstChild("Humanoid") then return end
    
    -- 1. Nếu đang cầm đúng món đó rồi thì thoát (Chống spam gây lỗi)
    if char:FindFirstChild(itemName) then return end

    -- 2. Tìm trong túi (Backpack) trước
    local tool = Player.Backpack:FindFirstChild(itemName)
    
    if tool then
        -- Nếu có trong túi, cầm lên ngay
        char.Humanoid:EquipTool(tool)
    else
        -- 3. Nếu không có trong túi, gọi lệnh lấy từ Inventory
        -- Dùng pcall để nếu Server từ chối lệnh cũng không bị văng script
        local success, result = pcall(function()
            return ReplicatedStorage.Remotes.CommF_:InvokeServer("LoadItem", itemName)
        end)
        
        if not success then
            warn("⚠️ [ERROR] Server từ chối lệnh LoadItem cho: " .. itemName)
        end
    end
end

-- Vòng lặp kiểm tra thông minh
task.spawn(function()
    while task.wait(1) do -- Delay 1s là khoảng cách an toàn nhất cho Blox Fruits
        if getgenv().AutoEquipEnabled then
            -- Thay "Dragonstorm" bằng tên món đồ Vũ muốn
            SmartEquip("Dragonstorm") 
        end
    end
end)

getgenv().AutoEquipEnabled = true
print("✅ [FIXED] Script đã chạy. Hãy kiểm tra nếu còn báo lỗi!")
