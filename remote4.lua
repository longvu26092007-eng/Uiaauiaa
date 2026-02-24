-- ======================================================================
-- DRACO REMOTE DEBUGGER V6.0 - BLOX FRUITS DEEP TRACING
-- Fix: Hiện đầy đủ lệnh gọi (Args) ngay khi bấm Equip trong Inventory
-- ======================================================================

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

warn("🛰️ [TRACE ACTIVE] Hãy mở Inventory và Equip vũ khí để xem lệnh...")

-- 1. DANH SÁCH CHẶN RÁC (Chỉ chặn những thứ cực kỳ loãng để không sót lệnh)
local IgnoreList = {
    ["CharacterMounted"] = true, ["MoveCharacter"] = true, ["Ping"] = true,
    ["Look"] = true, ["Position"] = true, ["ArriveCheck"] = true, ["UpdateHealth"] = true
}

-- 2. HÀM ÉP MỞ CONSOLE (F9)
local function OpenConsole()
    pcall(function()
        local coreGui = game:GetService("CoreGui")
        local devConsole = coreGui:FindFirstChild("DevConsoleMaster")
        local isVisible = devConsole and devConsole.DevConsoleWindow.Visible or false
        
        if not isVisible then
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F9, false, game)
            task.wait(0.01)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F9, false, game)
        end
    end)
end

-- 3. HOOK METATABLE CẤP ĐỘ THẤP (Giống Remote_Spy.lua)
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    local remoteName = tostring(self.Name)
    
    if (method == "FireServer" or method == "InvokeServer") then
        
        -- PHÁT HIỆN LỆNH EQUIP (Thường là CommF_ với arg1 là "LoadItem")
        local isEquipCall = (remoteName == "CommF_" and args[1] == "LoadItem") or remoteName == "LoadItem"
        
        if isEquipCall then
            task.defer(function()
                OpenConsole()
                warn("⚔️ [EQUIP DETECTED]: " .. tostring(args[2] or "Unknown Item"))
                print("📍 Remote Path: " .. self:GetFullName())
                
                -- FORMAT DỮ LIỆU LỆNH (Đây là phần cậu cần để làm Lua)
                local success, formattedArgs = pcall(function() 
                    return HttpService:JSONEncode(args) 
                end)
                
                if success then
                    print("📜 Lệnh gọi đầy đủ: game." .. self:GetFullName() .. ":" .. method .. "(" .. formattedArgs:sub(2, #formattedArgs-1) .. ")")
                else
                    print("📜 Lệnh gọi (Raw): Không thể format JSON")
                end
                print("------------------------------------------")
            end)
        
        -- LOG CÁC LỆNH KHÁC (Skill, Click...)
        elseif not IgnoreList[remoteName] then
            task.defer(function()
                -- Nếu Console đang mở thì mới log các lệnh phụ để tránh đơ máy
                local devConsole = game:GetService("CoreGui"):FindFirstChild("DevConsoleMaster")
                if devConsole and devConsole.DevConsoleWindow.Visible then
                    local success, data = pcall(function() return HttpService:JSONEncode(args) end)
                    warn("📡 [CALL]: " .. remoteName)
                    print("📑 Args: " .. (success and data or "Complex Data"))
                    print("------------------------------------------")
                end
            end)
        end
    end

    return oldNamecall(self, ...)
end)

setreadonly(mt, true)

print("✅ [V6.0 READY] Đã sẵn sàng bắt lệnh từ Inventory.")
