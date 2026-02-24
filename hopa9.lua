-- ======================================================================
-- DRACO HUNTER V15.1 - OPTIMIZED SINGAPORE SNIPER
-- Quy trình: Chạy -> Đợi 3s -> Mở UI -> Nhập Singapore -> Lọc 2-4 người -> Auto Refresh
-- ======================================================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer
local targetCountMin = 2
local targetCountMax = 4
local targetRegion = "Singapore"
local isHopping = false

-- 1. Hàm giả lập Click nút Refresh (Đã thêm check an toàn UI)
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
            warn("🔄 [SYSTEM] Không thấy server phù hợp, đang Refresh...")
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

-- 3. Hook ngầm bắt gói tin (Tối ưu chống crash)
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    
    -- Lấy response gốc trước
    local response = oldNamecall(self, ...)
    
    -- Chỉ xử lý nếu chưa nhảy server và đúng Remote cần tìm
    if not isHopping and (method == "InvokeServer" or method == "FireServer") and tostring(self.Name) == "__ServerBrowser" then
        if type(response) == "table" then
            -- Dùng task.defer thay vì task.spawn để không làm nghẽn luồng chính của game
            task.defer(function()
                FilterAndJump(response)
            end)
        end
    end
    
    return response
end)
setreadonly(mt, true)

-- 4. Quy trình khởi động tự động an toàn
local function StartProcess()
    print("⏳ Đang đợi 3 giây để hệ thống ổn định...")
    task.wait(3)
    
    warn("🛰️ BẮT ĐẦU QUY TRÌNH SNIPER...")
    
    -- Kiểm tra UI an toàn bằng WaitForChild thay vì gọi trực tiếp (tránh lỗi nil nếu máy yếu load chậm)
    local ui = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("ServerBrowser", 5)
    if ui then
        ui.Enabled = true
        local frame = ui:FindFirstChild("Frame")
        if frame then 
            frame.Visible = true 
            
            -- Nhập TextBox an toàn
            local filters = frame:FindFirstChild("Filters")
            if filters and filters:FindFirstChild("SearchRegion") and filters.SearchRegion:FindFirstChild("TextBox") then
                filters.SearchRegion.TextBox.Text = targetRegion
            end
        end
    else
        warn("❌ Lỗi: Không tìm thấy UI ServerBrowser!")
        return
    end
    
    -- Vòng lặp quét Server (Đã xử lý chống Spam Remote)
    task.spawn(function()
        while not isHopping do
            pcall(function()
                local remote = ReplicatedStorage:FindFirstChild("__ServerBrowser")
                if remote then
                    remote:InvokeServer(1, targetRegion)
                end
            end)
            
            -- Delay 3 giây đúng như yêu cầu của cậu, gom cả ClickRefresh vào đây
            task.wait(3)
            
            if not isHopping then
                ClickRefresh()
            end
        end
    end)
end

-- THỰC THI
StartProcess()
