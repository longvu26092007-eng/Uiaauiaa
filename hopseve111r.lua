-- ======================================================================
-- DRACO HUNTER V18.0 - KaitunBoss __ServerBrowser Only
-- Xóa hết V16 hook/UI + hop cũ
-- Chỉ dùng __ServerBrowser (KaitunBoss) để hop
-- ======================================================================

local GuiService        = game:GetService("GuiService")

local LocalPlayer = Players.LocalPlayer
local PlaceId, JobId = game.PlaceId, game.JobId

-- ==========================================
-- CẤU HÌNH
-- ==========================================
local targetRegion    = "Singapore"
local targetCountMin  = 1
local targetCountMax  = 4
local isHopping       = false

-- ==========================================
-- HOP SERVER (__ServerBrowser KaitunBoss - EXACT COPY)
-- ==========================================
local LastServersDataPulled, CachedServers

local function IfTableHaveIndex(j)
    for _ in j do return true end
end

local function GetServers()
    if LastServersDataPulled then
        if os.time() - LastServersDataPulled < 60 then
            return CachedServers
        end
    end

    for i = 1, 100, 1 do
        local data = ReplicatedStorage:WaitForChild("__ServerBrowser"):InvokeServer(i)
        if IfTableHaveIndex(data) then
            LastServersDataPulled = os.time()
            CachedServers = data
            return data
        end
    end
end

local function HopServer()
    if isHopping then return end
    warn("🔄 [HOP] Scan servers...")

    local Servers = GetServers()
    if not Servers then warn("❌ Không lấy được server list") return end

    local ArrayServers = {}
    for i, v in Servers do
        if i ~= JobId then
            table.insert(ArrayServers, {
                JobId = i,
                Players = v.Count,
                LastUpdate = v.__LastUpdate,
                Region = v.Region
            })
        end
    end
    warn("📊 " .. #ArrayServers .. " servers received")

    -- Ưu tiên 1: Đúng region + đúng count (1-4)
    for _, s in ipairs(ArrayServers) do
        if string.find(s.Region, targetRegion) and s.Players >= targetCountMin and s.Players <= targetCountMax then
            isHopping = true
            warn("🚀 [T1] " .. s.Region .. " (" .. s.Players .. "p) → Teleport!")
            ReplicatedStorage:WaitForChild("__ServerBrowser"):InvokeServer('teleport', s.JobId)
            return
        end
    end

    -- Ưu tiên 2: Đúng region + lỏng hơn (1-8)
    for _, s in ipairs(ArrayServers) do
        if string.find(s.Region, targetRegion) and s.Players >= 1 and s.Players <= 8 then
            isHopping = true
            warn("🚀 [T2] " .. s.Region .. " (" .. s.Players .. "p) → Teleport!")
            ReplicatedStorage:WaitForChild("__ServerBrowser"):InvokeServer('teleport', s.JobId)
            return
        end
    end

    -- Ưu tiên 3: Bất kỳ server < 5 người
    for _, s in ipairs(ArrayServers) do
        if s.Players >= 1 and s.Players < 5 then
            isHopping = true
            warn("🚀 [T3] " .. s.Region .. " (" .. s.Players .. "p) → Teleport!")
            ReplicatedStorage:WaitForChild("__ServerBrowser"):InvokeServer('teleport', s.JobId)
            return
        end
    end

    warn("❌ Không tìm thấy server phù hợp → Clear cache, thử lại...")
    CachedServers = nil
    LastServersDataPulled = nil
end

-- ==========================================
-- ANTI-DISCONNECT (KaitunBoss)
-- ==========================================
TeleportService.TeleportInitFailed:Connect(function(player, teleportResult, message)
    if teleportResult == Enum.TeleportResult.GameFull then
        isHopping = false
        CachedServers = nil
        LastServersDataPulled = nil
        warn("⚠ Server full → Retry...")
    elseif teleportResult == Enum.TeleportResult.IsTeleporting and message:find("previous teleport") then
        StarterGui:SetCore("SendNotification", {Title = "Hop Error", Text = message, Duration = 8})
        task.delay(10, function() game:Shutdown() end)
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
-- MAIN
-- ==========================================
print("⏳ Đợi 3s ổn định...")
task.wait(3)
warn("🛰️ DRACO HUNTER V18.0 START (__ServerBrowser only)")
warn("🎯 Region: " .. targetRegion .. " | Count: " .. targetCountMin .. "-" .. targetCountMax)

-- Loop: hop cho đến khi thành công
task.spawn(function()
    while not isHopping do
        HopServer()
        if not isHopping then
            warn("⏳ Chờ 5s rồi thử lại...")
            task.wait(5)
        end
    end
end)
