-- ======================================================================
-- DRACO HUNTER V16.0 - ADVANCED SINGAPORE SNIPER (FALLBACK INTEGRATED)
-- Quy trình: Chạy -> Đợi 3s -> Mở UI -> Nhập Region -> Lọc -> Tự sửa lỗi nếu kẹt
-- ======================================================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService") -- Thêm Service kiểm tra Tab

local LocalPlayer = Players.LocalPlayer
local targetCountMin = 2
local targetCountMax = 5
local targetRegion = "United States"
local isHopping = false
local startTime = tick() -- Bộ đếm thời gian cho Module Fallback

-- 1. Hàm giả lập Click nút Refresh (Chỉ chạy khi Tab đang mở)
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
            warn("🔄 [PHYSICAL] Đã click Refresh trên giao diện...")
        end
    end)
end

-- 2. Bộ lọc thông minh (Giữ nguyên logic của Vũ)
local function FilterAndJump(serverList)
    if isHopping or type(serverList) ~= "table" then return end
    
    local bestJobId = nil

    for jobId, info in pairs(serverList) do
        if type(info) == "table" then
            local pCount = tonumber(info.Count) or 0
            local pRegion = tostring(info.Region) or ""

            -- LỌC: Đúng Singapore và (2 đến 4 người)
            if jobId ~= game.JobId and string.find(pRegion, targetRegion) and (pCount >= targetCountMin and pCount <= targetCountMax) then
                bestJobId = jobId
                break -- Tìm thấy là chốt luôn để nhảy
            end
        end
    end

    if bestJobId then
        isHopping = true
        warn("🚀 MỤC TIÊU XÁC ĐỊNH! Đang nhảy đến server " .. targetRegion .. "...")
        pcall(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, bestJobId, LocalPlayer)
        end)
    end
end

-- 3. Hook ngầm bắt gói tin (GIỮ NGUYÊN HOÀN TOÀN CÁCH BẮT JOBID TỪ REMOTE)
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    
    local response = oldNamecall(self, ...)
    
    -- Lắng nghe các server trả về từ Remote __ServerBrowser
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

-- 4. Quy trình khởi động tự động an toàn & Module Fallback
local function StartProcess()
    print("⏳ Đang đợi 3 giây để hệ thống ổn định...")
    task.wait(3)
    
    warn("🛰️ BẮT ĐẦU QUY TRÌNH SNIPER V16.0...")
    
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
        warn("❌ Lỗi: Không tìm thấy UI ServerBrowser!")
        return
    end
    
    startTime = tick() -- Bắt đầu tính giờ
    
    -- Vòng lặp quét Server
    task.spawn(function()
        while not isHopping do
            -- Gọi Remote ngầm (Hoạt động kể cả khi ẩn tab)
            pcall(function()
                local remote = ReplicatedStorage:FindFirstChild("__ServerBrowser")
                if remote then
                    remote:InvokeServer(1, targetRegion)
                end
            end)
            
            task.wait(3)
            
            if not isHopping then
                local timeElapsed = tick() - startTime
                
                -- [MODULE FALLBACK 10 GIÂY]: Nếu kẹt quá lâu
                if timeElapsed >= 10 then
                    warn("⏳ [FALLBACK] Quá 10s không thấy server. Reset UI và ép quét lại Console...")
                    pcall(function()
                        if ui then
                            ui.Enabled = false -- Tắt UI
                            task.wait(0.5)
                            ui.Enabled = true  -- Mở lại UI
                            if ui:FindFirstChild("Frame") then ui.Frame.Visible = true end
                            
                            -- Ép gọi lại Remote một lần nữa ngay sau khi mở UI
                            local remote = ReplicatedStorage:FindFirstChild("__ServerBrowser")
                            if remote then remote:InvokeServer(1, targetRegion) end
                        end
                    end)
                    startTime = tick() -- Reset lại bộ đếm 10 giây
                
                -- Chưa tới 10 giây, tiến hành xử lý Refresh bình thường
                else
                    -- [CẢI TIẾN TRẠNG THÁI TAB]: Chỉ click vật lý khi Tab Roblox đang mở
                    if UserInputService.WindowFocused then
                        ClickRefresh()
                    else
                        warn("🪟 [SYSTEM] Tab Roblox đang chạy nền, bỏ qua click vật lý để chống lỗi kẹt phím...")
                    end
                end
            end
        end
    end)
end

-- THỰC THI
StartProcess()
