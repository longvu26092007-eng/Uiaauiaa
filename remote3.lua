-- ======================================================================
-- DRACO REMOTE DEBUGGER V5.0 - BLOX FRUITS INVENTORY EDITION
-- Fix: Tự động hiện Console khi trang bị vũ khí từ Inventory (Hòm đồ)
-- ======================================================================

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

warn("🛰️ [INVENTORY DEBUG] Đang chờ bạn trang bị vũ khí từ hòm đồ...")

-- 1. DANH SÁCH CHẶN (Chặn các Remote di chuyển, máu để tránh đơ)
local IgnoreList = {
    ["CharacterMounted"] = true, ["MoveCharacter"] = true, ["Ping"] = true,
    ["Look"] = true, ["Position"] = true, ["ArriveCheck"] = true
}

-- 2. HÀM ĐIỀU KHIỂN CONSOLE (F9)
local function SetConsole(state)
    pcall(function()
        local coreGui = game:GetService("CoreGui")
        local devConsole = coreGui:FindFirstChild("DevConsoleMaster")
        local isVisible = devConsole and devConsole.DevConsoleWindow.Visible or false
        
        if state ~= isVisible then
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F9, false, game)
            task.wait(0.01)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F9, false, game)
        end
    end)
end

-- 3. THEO DÕI LỆNH TRANG BỊ TỪ INVENTORY (Hook Metatable)
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    local remoteName = tostring(self.Name)
    
    -- Blox Fruits dùng Remote "LoadItem" hoặc "Equip" tùy phiên bản để lấy đồ từ Inventory
    if (method == "FireServer" or method == "InvokeServer") then
        
        -- Phát hiện lệnh trang bị đồ
        if remoteName == "LoadItem" or remoteName == "EquipItem" or (remoteName == "CommF_" and args[1] == "LoadItem") then
            warn("📦 [INVENTORY EVENT] Bạn vừa trang bị: " .. tostring(args[2] or "Unknown"))
            task.defer(SetConsole, true)
        end

        -- Ghi log chi tiết nếu không nằm trong danh sách chặn
        if not IgnoreList[remoteName] then
            task.defer(function()
                -- Chỉ log khi nhân vật đang cầm vũ khí (đã trang bị xong)
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool") then
                    local data = "Data too complex"
                    pcall(function() data = HttpService:JSONEncode(args) end)

                    warn("📡 [CALL]: " .. remoteName)
                    print("📂 Path: " .. self:GetFullName())
                    print("📑 Args: " .. data)
                    print("------------------------------------------")
                end
            end)
        end
    end

    return oldNamecall(self, ...)
end)

setreadonly(mt, true)

-- 4. TỰ ĐỘNG ẨN KHI CẤT ĐỒ (Check trạng thái Tool trong nhân vật)
task.spawn(function()
    while task.wait(1) do
        local char = LocalPlayer.Character
        if char then
            local hasTool = char:FindFirstChildOfClass("Tool")
            if not hasTool then
                -- Nếu không cầm gì trên tay thì ẩn Console để dễ thao tác menu
                pcall(function()
                    local devConsole = game:GetService("CoreGui").DevConsoleMaster
                    if devConsole.DevConsoleWindow.Visible then
                        SetConsole(false)
                    end
                end)
            end
        end
    end
end)

print("✅ [V5.0 READY] Mở Inventory và trang bị vũ khí để xem lệnh gọi!")
