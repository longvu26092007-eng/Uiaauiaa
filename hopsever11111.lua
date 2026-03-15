-- ======================================================================
-- DRACO HUNTER V17.0 - V16 SNIPER + KAITUNBOSS FALLBACK HOP
-- Flow: V16 sniper chạy trước (hook + UI + filter region)
--       → 5s không tìm thấy → chạy thêm KaitunBoss GetServers hop
-- ======================================================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local GuiService = game:GetService("GuiService")

local LocalPlayer = Players.LocalPlayer
local targetCountMin = 1
local targetCountMax = 4
local targetRegion = "Singapore"
local isHopping = false
local startTime = tick()

-- ==========================================
-- 1. CLICK REFRESH (từ V16)
-- ==========================================
local function ClickRefresh()
    pcall(function()
        local gui = LocalPlayer.PlayerGui:FindFirstChild("ServerBrowser")
        if not gui then return end
        local frame = gui:FindFirstChild("Frame")
        if not frame then return end
        local refreshBtn = frame:FindFirstChild("Refresh")
        if refreshBtn and refreshBtn.Visible then
            local x = refreshBtn.AbsolutePosition.X + (refreshBtn.AbsoluteSize.X / 2)
            local y = refreshBtn.AbsolutePosition.Y + (refreshBtn.AbsoluteSize.Y / 2) + 58
            VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 1)
            task.wait(0.05)
            VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 1)
            warn("🔄 [V16] Click Refresh")
        end
    end)
end

-- ==========================================
-- 2. BỘ LỌC V16 (Region + Player count)
-- ==========================================
local function FilterAndJump(serverList)
    if isHopping or type(serverList) ~= "table" then return false end

    for jobId, info in pairs(serverList) do
        if type(info) == "table" then
            local pCount = tonumber(info.Count) or 0
            local pRegion = tostring(info.Region) or ""

            if jobId ~= game.JobId and string.find(pRegion, targetRegion) and pCount >= targetCountMin and pCount <= targetCountMax then
                isHopping = true
                warn("🚀 [V16] Tìm thấy " .. targetRegion .. " (" .. pCount .. "p) → Teleport!")
                pcall(function()
                    ReplicatedStorage:WaitForChild("__ServerBrowser"):InvokeServer('teleport', jobId)
                end)
                return true
            end
        end
    end
    return false
end

-- ==========================================
-- 3. HOOK __NAMECALL (từ V16)
-- ==========================================
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local response = oldNamecall(self, ...)

    if not isHopping and (method == "InvokeServer" or method == "FireServer") and tostring(self.Name) == "__ServerBrowser" then
        if type(response) == "table" then
            task.defer(function()
                FilterAndJump(response)
            end)
        end
    end

    return response
end)
setreadonly(mt, true)

-- ==========================================
-- 4. KAITUNBOSS HOP (GetServers multi-page)
-- Chạy sau 5s nếu V16 chưa tìm thấy
-- ==========================================
local function IfTableHaveIndex(j)
    for _ in j do return true end
end

local LastServersDataPulled, CachedServers
local function GetServers()
    if LastServersDataPulled and os.time() - LastServersDataPulled < 60 then
        return CachedServers
    end
    for i = 1, 100 do
        local ok, data = pcall(function()
            return ReplicatedStorage:WaitForChild("__ServerBrowser"):InvokeServer(i)
        end)
        if ok and type(data) == "table" and IfTableHaveIndex(data) then
            LastServersDataPulled = os.time()
            CachedServers = data
            return data
        end
    end
    return nil
end

local function KaitunBossHop()
    if isHopping then return end
    warn("🔄 [KAITUN] Scan multi-page...")

    local servers = GetServers()
    if not servers then warn("❌ [KAITUN] Không lấy được server list") return end

    local arr = {}
    for jobId, v in pairs(servers) do
        if type(v) == "table" and jobId ~= game.JobId then
            table.insert(arr, {
                JobId = jobId,
                Players = tonumber(v.Count) or 0,
                Region = tostring(v.Region or "")
            })
        end
    end
    warn("📊 [KAITUN] " .. #arr .. " servers")

    -- Ưu tiên 1: Đúng region + đúng count (1-4)
    for _, s in ipairs(arr) do
        if string.find(s.Region, targetRegion) and s.Players >= targetCountMin and s.Players <= targetCountMax then
            isHopping = true
            warn("🚀 [KAITUN T1] " .. s.Region .. " (" .. s.Players .. "p) → Teleport!")
            pcall(function() ReplicatedStorage:WaitForChild("__ServerBrowser"):InvokeServer('teleport', s.JobId) end)
            return
        end
    end

    -- Ưu tiên 2: Đúng region + lỏng hơn (1-8)
    for _, s in ipairs(arr) do
        if string.find(s.Region, targetRegion) and s.Players >= 1 and s.Players <= 8 then
            isHopping = true
            warn("🚀 [KAITUN T2] " .. s.Region .. " (" .. s.Players .. "p) → Teleport!")
            pcall(function() ReplicatedStorage:WaitForChild("__ServerBrowser"):InvokeServer('teleport', s.JobId) end)
            return
        end
    end

    -- Ưu tiên 3: Bất kỳ server < 5 người
    for _, s in ipairs(arr) do
        if s.Players >= 1 and s.Players < 5 then
            isHopping = true
            warn("🚀 [KAITUN T3] " .. s.Region .. " (" .. s.Players .. "p) → Teleport!")
            pcall(function() ReplicatedStorage:WaitForChild("__ServerBrowser"):InvokeServer('teleport', s.JobId) end)
            return
        end
    end

    warn("❌ [KAITUN] Không tìm thấy server phù hợp")
end

-- ==========================================
-- 5. MAIN PROCESS
-- V16 chạy trước → 5s → KaitunBoss backup
-- ==========================================
local function StartProcess()
    print("⏳ Đợi 3s ổn định...")
    task.wait(3)
    warn("🛰️ DRACO HUNTER V17.0 START")

    -- Mở UI ServerBrowser + nhập region (V16)
    local ui = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("ServerBrowser", 5)
    if ui then
        ui.Enabled = true
        local frame = ui:FindFirstChild("Frame")
        if frame then
            frame.Visible = true
            local filters = frame:FindFirstChild("Filters")
            if filters and filters:FindFirstChild("SearchRegion") and filters.SearchRegion:FindFirstChild("TextBox") then
                filters.SearchRegion.TextBox.Text = targetRegion
            end
        end
    else
        warn("❌ Không tìm thấy UI ServerBrowser! Chạy thẳng KaitunBoss hop...")
        KaitunBossHop()
        return
    end

    startTime = tick()

    -- V16 loop: gọi remote mỗi 3s + hook bắt response
    task.spawn(function()
        while not isHopping do
            pcall(function()
                local remote = ReplicatedStorage:FindFirstChild("__ServerBrowser")
                if remote then remote:InvokeServer(1, targetRegion) end
            end)

            task.wait(3)

            if not isHopping then
                local elapsed = tick() - startTime

                -- === 5 GIÂY: Chạy KaitunBoss hop song song ===
                if elapsed >= 5 then
                    warn("⏳ [5s] V16 chưa tìm thấy → Chạy KaitunBoss hop!")
                    task.spawn(function()
                        KaitunBossHop()
                    end)

                    -- Nếu vẫn chưa hop → đợi thêm 5s rồi fallback
                    if not isHopping then
                        task.wait(5)

                        if not isHopping then
                            -- Fallback 10s: Reset UI (V16 style)
                            warn("⏳ [FALLBACK 10s] Reset UI + clear cache...")
                            pcall(function()
                                if ui then
                                    ui.Enabled = false
                                    task.wait(0.5)
                                    ui.Enabled = true
                                    if ui:FindFirstChild("Frame") then ui.Frame.Visible = true end
                                    local remote = ReplicatedStorage:FindFirstChild("__ServerBrowser")
                                    if remote then remote:InvokeServer(1, targetRegion) end
                                end
                            end)

                            -- Clear cache KaitunBoss để scan fresh
                            CachedServers = nil
                            LastServersDataPulled = nil
                            startTime = tick()
                        end
                    end
                else
                    -- Chưa tới 5s → click Refresh (V16)
                    if UserInputService.WindowFocused then
                        ClickRefresh()
                    end
                end
            end
        end
    end)
end

-- ==========================================
-- 6. ERROR HANDLING (từ KaitunBoss)
-- ==========================================
TeleportService.TeleportInitFailed:Connect(function(player, teleportResult, message)
    if teleportResult == Enum.TeleportResult.GameFull then
        isHopping = false
        startTime = tick()
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
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
            task.wait(5)
        end
    end
end))

-- THỰC THI
StartProcess()
