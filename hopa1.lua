-- =============================================================
-- DRACO HUB - SMART SERVER HOPPER (FIXED VERSION)
-- Tính năng: Tự tìm Remote chuẩn để lấy danh sách server
-- =============================================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local function SmartHop()
    -- Danh sách các tên Remote khả nghi dựa trên file cậu gửi
    local suspectRemotes = {"__ServerBrowser", "GetServerList", "RequestServers", "ServerBrowser"}
    local targetRemote = nil

    for _, name in pairs(suspectRemotes) do
        if ReplicatedStorage:FindFirstChild(name) then
            targetRemote = ReplicatedStorage[name]
            break
        end
    end

    if not targetRemote then
        warn("❌ Không tìm thấy Remote lấy danh sách Server! Hãy kiểm tra lại F9.")
        return
    end

    print("🛰️ Đang gọi Remote: " .. targetRemote.Name)
    
    -- Gọi Remote với tham số Page 1
    local ok, serverList = pcall(function()
        return targetRemote:InvokeServer(1)
    end)

    if ok and type(serverList) == "table" then
        local bestServer = nil
        local minPlayers = 12 -- Giả sử max 12

        for jobId, info in pairs(serverList) do
            -- Kiểm tra xem info có phải là table chứa Count không
            local count = 0
            if type(info) == "table" and info.Count then
                count = info.Count
            elseif type(info) == "number" then
                count = info
            end

            if jobId ~= game.JobId and count > 0 and count < minPlayers then
                minPlayers = count
                bestServer = jobId
            end
        end

        if bestServer then
            print("🚀 Tìm thấy server: " .. minPlayers .. " người. Đang vọt...")
            TeleportService:TeleportToPlaceInstance(game.PlaceId, bestServer, Players.LocalPlayer)
        else
            warn("❌ Tìm thấy Remote nhưng dữ liệu bên trong không có Server phù hợp.")
        end
    else
        warn("❌ Lỗi thực thi InvokeServer hoặc dữ liệu trả về không phải Table.")
    end
end

-- Thực thi
SmartHop()
