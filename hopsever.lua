-- ======================================================================
-- DRACO HUNTER V17.3 - CẢI TIẾN HOP SERVER
-- Tích hợp: lọc ít người + region từ Source_SG
-- Giữ nguyên: error handling từ V17.2
-- Sửa bug: Regoin → Region
-- ======================================================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService   = game:GetService("TeleportService")
local Players           = game:GetService("Players")
local StarterGui        = game:GetService("StarterGui")
local GuiService        = game:GetService("GuiService")
local LocalPlayer = Players.LocalPlayer
local PlaceId     = game.PlaceId
local JobId       = game.JobId

-- ==========================================
-- CẤU HÌNH HOP (CHỈNH Ở ĐÂY)
-- ==========================================
local HOP_CONFIG = {
    MaxPlayers    = 4,       -- Chỉ hop vào server < 5 người (đặt nil để bỏ qua)
    ForcedRegion  = nil,     -- Ép region, VD: "US", "EU", "AP" (đặt nil để bỏ qua)
    MaxRetries    = 5,      -- Số lần thử tối đa khi không tìm được server phù hợp
    RetryDelay    = 2,       -- Giây chờ giữa mỗi lần thử
    CacheDuration = 60,      -- Giây cache danh sách server
    MaxPages      = 100,     -- Số trang tối đa khi lấy danh sách server
}

-- ==========================================
-- HOP SERVER (CẢI TIẾN)
-- ==========================================
local function IfTableHaveIndex(j)
    for _ in j do
        return true
    end
end

local LastServersDataPulled, CachedServers

local function GetServers()
    if LastServersDataPulled then
        if os.time() - LastServersDataPulled < HOP_CONFIG.CacheDuration then
            return CachedServers
        end
    end

    for i = 1, HOP_CONFIG.MaxPages do
        local ok, data = pcall(function()
            return ReplicatedStorage:WaitForChild("__ServerBrowser"):InvokeServer(i)
        end)

        if ok and data and IfTableHaveIndex(data) then
            LastServersDataPulled = os.time()
            CachedServers = data
            return data
        end
    end

    warn("[HOP] Không lấy được danh sách server!")
    return nil
end

local function HopServer(Reason, MaxPlayers, ForcedRegion)
    -- Ưu tiên tham số truyền vào, nếu không thì lấy từ config
    MaxPlayers   = MaxPlayers   or HOP_CONFIG.MaxPlayers
    ForcedRegion = ForcedRegion or HOP_CONFIG.ForcedRegion

    local Servers = GetServers()
    if not Servers then
        warn("[HOP] Không có dữ liệu server, thử hop random bằng TeleportService...")
        TeleportService:Teleport(PlaceId, LocalPlayer)
        return
    end

    -- Chuyển dictionary → mảng, loại bỏ server hiện tại
    local ArrayServers = {}
    for id, v in Servers do
        if id ~= JobId then
            table.insert(ArrayServers, {
                JobId      = id,
                Players    = v.Count,
                LastUpdate = v.__LastUpdate,
                Region     = v.Region   -- ĐÃ SỬA: Regoin → Region
            })
        end
    end

    print("[HOP] Nhận được", #ArrayServers, "servers")

    if #ArrayServers == 0 then
        warn("[HOP] Danh sách server rỗng, hop random...")
        TeleportService:Teleport(PlaceId, LocalPlayer)
        return
    end

    -- Lọc server theo điều kiện
    local FilteredServers = {}
    for _, server in ipairs(ArrayServers) do
        local passPlayers = true
        local passRegion  = true

        if MaxPlayers and server.Players >= MaxPlayers then
            passPlayers = false
        end

        if ForcedRegion and server.Region ~= ForcedRegion then
            passRegion = false
        end

        if passPlayers and passRegion then
            table.insert(FilteredServers, server)
        end
    end

    print("[HOP] Sau lọc:", #FilteredServers, "servers phù hợp",
        "(MaxPlayers <", tostring(MaxPlayers) .. ",",
        "Region:", tostring(ForcedRegion) .. ")")

    -- Nếu không có server nào phù hợp, nới lỏng điều kiện
    if #FilteredServers == 0 then
        warn("[HOP] Không có server nào khớp filter, thử bỏ filter region...")
        for _, server in ipairs(ArrayServers) do
            if not MaxPlayers or server.Players < MaxPlayers then
                table.insert(FilteredServers, server)
            end
        end
    end

    -- Vẫn không có → dùng toàn bộ
    if #FilteredServers == 0 then
        warn("[HOP] Vẫn không có server phù hợp, dùng toàn bộ danh sách...")
        FilteredServers = ArrayServers
    end

    -- Chọn random từ danh sách đã lọc
    local ServerData = FilteredServers[math.random(1, #FilteredServers)]

    print("[HOP] Đã chọn server:", ServerData.JobId,
        "| Players:", ServerData.Players,
        "| Region:", ServerData.Region)

    if Reason then
        print("[HOP] Lý do:", Reason)
    end

    -- Teleport
    print("[HOP] Đang teleport đến", ServerData.JobId, "...")
    ReplicatedStorage:WaitForChild("__ServerBrowser"):InvokeServer('teleport', ServerData.JobId)
end

-- ==========================================
-- ERROR HANDLING (GIỮ NGUYÊN TỪ V17.2)
-- ==========================================
TeleportService.TeleportInitFailed:Connect(function(player, teleportResult, message)
    if teleportResult == Enum.TeleportResult.GameFull then
        warn("[HOP] Server đầy, thử hop lại...")
        task.delay(2, function()
            HopServer("Retry - Server đầy")
        end)
    elseif teleportResult == Enum.TeleportResult.IsTeleporting
        and (message:find("previous teleport")) then
        StarterGui:SetCore("SendNotification", {
            Title    = "Death Hop Found",
            Text     = message,
            Duration = 8
        })
        task.delay(10, function() game:Shutdown() end)
    else
        warn("[HOP] Teleport thất bại:", tostring(teleportResult), message)
        task.delay(3, function()
            HopServer("Retry - Teleport fail")
        end)
    end
end)

GuiService.ErrorMessageChanged:Connect(newcclosure(function()
    if GuiService:GetErrorType() == Enum.ConnectionError.DisconnectErrors then
        while true do
            TeleportService:TeleportToPlaceInstance(PlaceId, JobId, LocalPlayer)
            task.wait(5)
        end
    end
end))

-- ==========================================
-- THỰC THI
-- ==========================================
HopServer("Khởi động")
