-- ==========================================
-- SCRIPT TẠO FILE JSON TRẠNG THÁI (WORKSPACE)
-- ==========================================

local HttpService = game:GetService("HttpService")
local Player = game.Players.LocalPlayer

-- 1. Thiết lập tên file theo tên người chơi
local FileName = "DRCHUB_" .. Player.Name .. ".json"

-- 2. Tạo bảng dữ liệu (Table)
local DataToSave = {
    ["Status"] = "StatusLearnDone"
}

-- 3. Tiến hành ghi file
local function CreateStatusFile()
    -- Chuyển đổi Table sang định dạng chuỗi JSON
    local JsonString = HttpService:JSONEncode(DataToSave)
    
    -- Ghi file vào thư mục workspace của Executor
    local success, err = pcall(function()
        writefile(FileName, JsonString)
    end)

    if success then
        warn("✅ [SYSTEM] Đã tạo file thành công: " .. FileName)
        print("Nội dung: " .. JsonString)
    else
        warn("❌ [SYSTEM] Lỗi khi tạo file: " .. tostring(err))
    end
end

-- Thực thi hàm
CreateStatusFile()
