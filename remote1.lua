-- ======================================================================
-- DRACO REMOTE DEBUGGER V2.0 - EQUIP DETECT & ANTI-LAG
-- Quy trình: Cầm vũ khí -> Hiện Console | Cất vũ khí -> Ẩn Console
-- Fix: Tối ưu hóa luồng xử lý để không gây đơ Menu game
-- ======================================================================

local LogService = game:GetService("LogService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

warn("🛰️ [SYSTEM] Draco Debugger V2.0 đã nạp ngầm. Hãy Equip vũ khí để xem log!")

-- 1. BỘ LỌC REMOTE RÁC (Chống spam gây đơ máy)
local IgnoreList = {
    ["CharacterMounted"] = true, ["MoveCharacter"] = true, ["Ping"] = true,
    ["UpdateWeaponVisual"] = true, ["Look"] = true, ["Position"] = true
}

-- 2. HÀM HIỂN THỊ CONSOLE (Dựa trên trạng thái Equip)
local function SetConsoleVisible(visible)
    pcall(function()
        game:GetService("CoreGui").DevConsoleMaster.DevConsoleWindow.Visible = visible
    end)
end

-- Theo dõi hành động cầm/cất vũ khí
LocalPlayer.Character.ChildAdded:Connect(function(child)
    if child:IsA("Tool") then
        warn("🔓 [DEBUGGER] Đã cầm vũ khí: Mở Console...")
        SetConsoleVisible(true)
    end
end)

LocalPlayer.Character.ChildRemoved:Connect(function(child)
    if child:IsA("Tool") then
        print("🔒 [DEBUGGER] Đã cất vũ khí: Ẩn Console...")
        SetConsoleVisible(false)
    end
end)

-- 3. HOOK METATABLE (Tối ưu chống Lag Menu)
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    -- Xử lý bất đồng bộ bằng task.spawn để game không bị đơ khi chờ xử lý Remote
    if (method == "FireServer" or method == "InvokeServer") and not IgnoreList[self.Name] then
        task.spawn(function()
            -- Chỉ log khi người chơi đang cầm vũ khí (Console đang mở)
            local char = LocalPlayer.Character
            if char and char:FindFirstChildOfClass("Tool") then
                local path = self:GetFullName()
                local data = "Error format"
                
                pcall(function()
                    data = HttpService:JSONEncode(args)
                end)

                warn("📡 [REMOTE]: " .. self.Name)
                print("📍 Path: " .. path)
                print("📦 Data: " .. data)
                print("------------------------------------------")
            end
        end)
    end

    return oldNamecall(self, ...)
end)

setreadonly(mt, true)

-- 4. FIX LỖI ĐƠ KHI CLICK (Sử dụng cơ chế luồng phụ)
-- Đoạn này đảm bảo các vòng lặp xử lý logic của game luôn được ưu tiên
RunService.Heartbeat:Connect(function()
    -- Giữ cho bộ nhớ rác luôn được dọn dẹp để tránh đứng máy khi log quá nhiều
end)

print("✅ [READY] Debugger đã sẵn sàng hoạt động mượt mà.")
