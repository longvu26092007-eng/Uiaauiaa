-- ======================================================================
-- DRACO REMOTE DEBUGGER V1.0 (ADVANCED TRACING)
-- Công dụng: Theo dõi Remote, ghi log tham số và tìm vị trí code gọi lệnh
-- ======================================================================

local LogService = game:GetService("LogService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

print("🛰️ [SYSTEM] Remote Debugger đang khởi động...")

-- 1. BỘ LỌC CÁC REMOTE RÁC (Tránh tràn Console)
local IgnoreList = {
    ["CharacterMounted"] = true,
    ["MoveCharacter"] = true,
    ["Ping"] = true
}

-- 2. HÀM PHÂN TÍCH SOURCE (Tìm xem script nào gọi)
local function GetCallerInfo()
    local s, e = pcall(function()
        -- Lấy thông tin từ stack trace của Lua
        local info = debug.info(3, "s") -- Lấy nguồn (source) ở cấp độ 3 trong stack
        return info or "Unknown Script"
    end)
    return s and e or "Unknown"
end

-- 3. HOOK METATABLE (Kỹ thuật từ Remote_Spy.lua)
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    -- Kiểm tra nếu là FireServer (RemoteEvent) hoặc InvokeServer (RemoteFunction)
    if (method == "FireServer" or method == "InvokeServer") and not IgnoreList[self.Name] then
        local caller = GetCallerInfo()
        
        -- In thông tin chi tiết ra Console (F9)
        warn("📡 [REMOTE CALL DETECTED]")
        print("📍 Tên Remote:", self.Name)
        print("🔗 Đường dẫn:", self:GetFullName())
        print("🛠️ Phương thức:", method)
        print("📜 Script gọi lệnh:", caller)
        
        -- Chuyển tham số sang dạng JSON để dễ đọc (Kỹ thuật từ Dex)
        pcall(function()
            local formattedArgs = "No arguments"
            if #args > 0 then
                -- Thử format bảng dữ liệu
                formattedArgs = HttpService:JSONEncode(args)
            end
            print("📦 Dữ liệu gửi đi:", formattedArgs)
        end)
        print("------------------------------------------")
    end

    return oldNamecall(self, ...)
end)

setreadonly(mt, true)

-- 4. TÍCH HỢP DEX EXPLORER NHANH (Phím tắt để soi vị trí Remote)
print("✅ [SUCCESS] Debugger đã hoạt động. Bấm F9 để xem Logs.")
warn("💡 Gợi ý: Nếu thấy Remote lạ, hãy dùng Dex Explorer tìm đường dẫn đó.")

-- Tự động gọi Dex Explorer nếu bạn đã nạp file
local function LoadDex()
    -- Link script Dex Explorer gốc (tương tự file bạn gửi)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
end

-- Bạn có thể gọi LoadDex() ở đây nếu muốn mở giao diện ngay
-- LoadDex()
