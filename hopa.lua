-- =============================================================
-- DRACO HUB - SMART SERVER HOPPER (BASED ON __ServerBrowser)
-- Tính năng: Lấy danh sách server tươi nhất, chọn server vắng nhất
-- =============================================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local function SmartHop()
    print("🛰️ Đang lấy danh sách server từ __ServerBrowser...")
    
    -- Gọi Remote lấy trang 1 (với tham số [1] = 1 như trong bảng cậu gửi)
    local ok, serverList = pcall(function()
        return ReplicatedStorage:WaitForChild("__ServerBrowser"):InvokeServer(1)
    end)

    if ok and type(serverList) == "table" then
        local bestServer = nil
        local minPlayers = 12 -- Giả sử max là 12 người

        for jobId, info in pairs(serverList) do
            -- Tìm server có ít người nhất nhưng không phải server hiện tại
            if jobId ~= game.JobId and info.Count < minPlayers then
                minPlayers = info.Count
                bestServer = jobId
            end
        end

        if bestServer then
            print("🚀 Tìm thấy server vắng: " .. minPlayers .. " người. Đang chuyển vùng...")
            TeleportService:TeleportToPlaceInstance(game.PlaceId, bestServer, Players.LocalPlayer)
        else
            warn("❌ Không tìm thấy server nào vắng hơn!")
        end
    else
        warn("❌ Lỗi khi gọi Remote __ServerBrowser!")
    end
end

-- Chạy thử luôn
SmartHop()
