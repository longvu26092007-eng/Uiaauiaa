-- =============================================================
-- DRACO HUB - SMART SERVER HOPPER (TARGET 7 PLAYERS)
-- Tính năng: Tự gọi Remote, quét nhanh bảng dữ liệu, Join server 7 người
-- =============================================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local function SmartHopToSeven()
    -- Tự động tìm Remote __ServerBrowser (Search đệ quy như bản V12.6)
    local targetRemote = ReplicatedStorage:FindFirstChild("__ServerBrowser", true)

    if not targetRemote then
        warn("❌ Không tìm thấy Remote __ServerBrowser! Hãy kiểm tra lại Dex.")
        return
    end

    print("🛰️ Đang quét danh sách server từ " .. targetRemote:GetFullName() .. "...")
    
    -- Gọi Remote lấy trang 1
    local ok, serverList = pcall(function()
        return targetRemote:InvokeServer(1)
    end)

    if ok and type(serverList) == "table" then
        local bestJobId = nil
        local targetCount = 7 -- Mốc 7 người theo ý cậu
        local fallbackServer = nil -- Để dự phòng nếu không có đúng server 7 người
        local minDiff = 100

        for jobId, info in pairs(serverList) do
            -- Kiểm tra cấu trúc Table từ file log của cậu {Count = x, Region = y}
            local currentCount = 0
            if type(info) == "table" and info.Count then
                currentCount = info.Count
            elseif type(info) == "number" then
                currentCount = info
            end

            -- Nếu thấy đúng server 7 người và không phải server hiện tại
            if jobId ~= game.JobId and currentCount == targetCount then
                bestJobId = jobId
                break -- Ưu tiên hàng đầu, thấy là vọt luôn không quét tiếp
            end

            -- Logic dự phòng: Tìm server có số người gần với mốc 7 nhất (nhưng phải < 12)
            if jobId ~= game.JobId and currentCount < 12 then
                local diff = math.abs(currentCount - targetCount)
                if diff < minDiff then
                    minDiff = diff
                    fallbackServer = jobId
                end
            end
        end

        -- Ưu tiên 1: Server đúng 7 người | Ưu tiên 2: Server gần mốc 7 nhất
        local finalJobId = bestJobId or fallbackServer

        if finalJobId then
            print("🚀 Đã tìm thấy server mục tiêu. Đang vọt đi...")
            TeleportService:TeleportToPlaceInstance(game.PlaceId, finalJobId, Players.LocalPlayer)
        else
            warn("❌ Không tìm thấy server nào phù hợp!")
        end
    else
        warn("❌ Lỗi dữ liệu trả về hoặc InvokeServer thất bại!")
    end
end

-- Thực thi ngay lập tức
SmartHopToSeven()
