-- ======================================================================
-- DRACO REMOTE DEBUGGER V4.0 - BLOX FRUITS SPECIAL EDITION
-- Fix: Equip phát hiện ngay lập tức | Không gây đơ Menu | Auto-Reconnect
-- ======================================================================

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

warn("🛰️ [SYSTEM] Debugger V4.0 Blox Fruits đang chạy ngầm...")

-- 1. DANH SÁCH CHẶN REMOTE RÁC (Tránh spam gây đơ máy)
local IgnoreList = {
    ["CharacterMounted"] = true, ["MoveCharacter"] = true, ["Ping"] = true,
    ["UpdateWeaponVisual"] = true, ["Look"] = true, ["Position"] = true,
    ["UpdateHealth"] = true, ["SetCFrame"] = true, ["ArriveCheck"] = true
}

-- 2. HÀM ÉP HIỆN/ẨN CONSOLE (Dùng VirtualInput để bypass lỗi chặn UI)
local function ToggleConsole(state)
    pcall(function()
        local coreGui = game:GetService("CoreGui")
        local devConsole = coreGui:FindFirstChild("DevConsoleMaster")
        local isCurrentlyVisible = false
        
        if devConsole and devConsole:FindFirstChild("DevConsoleWindow") then
            isCurrentlyVisible = devConsole.DevConsoleWindow.Visible
        end

        -- Nếu trạng thái yêu cầu khác với trạng thái hiện tại thì mới bấm F9
        if state ~= isCurrentlyVisible then
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F9, false, game)
            task.wait(0.01)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F9, false, game)
        end
    end)
end

-- 3. LOGIC THEO DÕI EQUIP VŨ KHÍ (Blox Fruits Style)
local function MonitorEquip()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    
    -- Kiểm tra ngay lúc vừa load
    if character:FindFirstChildOfClass("Tool") then
        ToggleConsole(true)
    end

    -- Lắng nghe khi nhân vật cầm vũ khí
    character.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            warn("🔓 [EQUIP] " .. child.Name .. " -> Mở bảng Log")
            ToggleConsole(true)
        end
    end)

    -- Lắng nghe khi nhân vật cất vũ khí (về Backpack)
    character.ChildRemoved:Connect(function(child)
        if child:IsA("Tool") then
            -- Delay nhỏ để check xem có phải đang đổi vũ khí nhanh không
            task.delay(0.1, function()
                if not character:FindFirstChildOfClass("Tool") then
                    print("🔒 [UNEQUIP] Đã cất vũ khí -> Ẩn bảng Log")
                    ToggleConsole(false)
                end
            end)
        end
    end)
end

-- Tự động chạy lại khi chết hoặc đổi Sea
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1) -- Đợi nhân vật ổn định
    MonitorEquip()
end)
task.spawn(MonitorEquip)

-- 4. HOOK METATABLE CỰC NHẸ (Kỹ thuật từ SimpleSpy)
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if (method == "FireServer" or method == "InvokeServer") and not IgnoreList[self.Name] then
        -- Xử lý log trong luồng defer để tuyệt đối không gây đơ game (Anti-Lag)
        task.defer(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChildOfClass("Tool") then
                local data = "{Table quá lớn}"
                pcall(function() 
                    -- Chỉ encode nếu table không quá phức tạp
                    data = HttpService:JSONEncode(args) 
                end)

                warn("📡 [REMOTE]: " .. self.Name)
                print("📍 Path: " .. self:GetFullName())
                print("📦 Data: " .. data)
                print("------------------------------------------")
            end
        end)
    end

    return oldNamecall(self, ...)
end)

setreadonly(mt, true)
print("✅ [READY] Debugger V4.0 đã sẵn sàng. Hãy cầm kiếm/trái ác quỷ lên!")
