-- ======================================================================
-- DRACO AUTO-EQUIP DRAGONSTORM (FIXED EDITION)
-- Fix lỗi: Tên vật phẩm, lag menu, và tự động đồng bộ Backpack
-- ======================================================================

local Player = game.Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")

local weaponTarget = "Dragonstorm" -- Tên vũ khí Vũ muốn dùng

local function GetEquippedWeapon()
    if Player.Character then
        return Player.Character:FindFirstChildOfClass("Tool")
    end
    return nil
end

local function SafeEquip()
    local char = Player.Character
    if not char or not char:FindFirstChild("Humanoid") then return end
    
    -- 1. Nếu đã cầm đúng món đó rồi thì dừng, không gọi Remote nữa để tránh lag
    local current = GetEquippedWeapon()
    if current and (current.Name == weaponTarget or string.find(current.Name, weaponTarget)) then
        return 
    end

    -- 2. Kiểm tra trong Backpack (Túi đồ)
    local tool = Player.Backpack:FindFirstChild(weaponTarget) or nil
    if not tool then
        -- Tìm kiếm thông minh (nếu tên có khoảng trắng hoặc viết hoa khác biệt)
        for _, v in pairs(Player.Backpack:GetChildren()) do
            if v:IsA("Tool") and string.find(v.Name, weaponTarget) then
                tool = v
                break
            end
        end
    end

    -- 3. Thực thi trang bị
    if tool then
        char.Humanoid:EquipTool(tool)
    else
        -- Nếu không có trong Backpack, mới gọi Server lấy ra
        pcall(function()
            RS.Remotes.CommF_:InvokeServer("LoadItem", weaponTarget)
        end)
    end
end

-- Vòng lặp duy trì mượt mà
task.spawn(function()
    while task.wait(1.5) do -- Tăng delay lên 1.5s để tránh bị kick/lag menu
        if getgenv().AutoEquipEnabled then
            pcall(SafeEquip)
        end
    end
end)

getgenv().AutoEquipEnabled = true
warn("⚔️ [FIXED] Auto Equip đã sẵn sàng!")
