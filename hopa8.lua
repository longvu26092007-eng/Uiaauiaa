-- ======================================================================
-- DRACO HUNTER V15.0 - SINGAPORE SNIPER (TARGET 2-4 PLAYERS)
-- Quy trình: Chạy -> Đợi 3s -> Mở UI -> Nhập Singapore -> Lọc 2-4 người -> Auto Refresh
-- ======================================================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- CẤU HÌNH CỦA VŨ
local targetCount = 2 -- Cậu muốn 2-4 người (Ưu tiên 2)
local targetRegion = "Singapore"
local isHopping = false

-- 1. Hàm giả lập Click nút Refresh (Đã fix tọa độ cho Vũ)
local function ClickRefresh()
    local frame = Players.LocalPlayer.PlayerGui.ServerBrowser.Frame
    local refreshBtn = frame:FindFirstChild("Refresh")
    if refreshBtn and refreshBtn.Visible then
        local x = refreshBtn.AbsolutePosition.X + (refreshBtn.AbsoluteSize.X / 2)
        local y = refreshBtn.AbsolutePosition.Y + (refreshBtn.AbsoluteSize.Y / 2) + 58
        
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 1)
        task.wait(0.05)
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 1)
        warn("🔄 [SYSTEM] Không thấy server 2-4 người, đang Refresh...")
    end
end

-- 2. Bộ lọc thông minh (Target 2-4 người)
local function FilterAndJump(serverList)
    if isHopping then return end
    
    local bestJobId = nil
    local found = false

    for jobId, info in pairs(serverList) do
        local pCount = 0
        local pRegion = ""
        
        if type(info) == "table" then
            pCount = tonumber(info.Count) or 0
            pRegion = tostring(info.Region) or ""
        end

        -- LỌC: Đúng Singapore và (2 đến 4 người)
        if jobId ~= game.JobId and pRegion:find(targetRegion) and (pCount >= 2 and pCount <= 4) then
            bestJobId = jobId
            found = true
            break -- Ưu tiên hàng đầu, thấy là nhảy luôn
        end
    end

    if found then
        isHopping = true
        warn("🚀 MỤC TIÊU XÁC ĐỊNH! Đang nhảy đến server " .. targetRegion .. "...")
        pcall(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, bestJobId, Players.LocalPlayer)
        end)
    else
        -- Delay 3 giây trước khi Refresh như cậu yêu cầu
        task.wait(3)
        ClickRefresh()
    end
end

-- 3. Debugger rình rập Remote
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    local response = oldNamecall(self, ...)

    if (method == "InvokeServer" or method == "FireServer") and self.Name == "__ServerBrowser" then
        if response and type(response) == "table" then
            task.spawn(function()
                FilterAndJump(response)
            end)
        end
    end
    return response
end)
setreadonly(mt, true)

-- 4. Quy trình khởi động tự động
local function StartProcess()
    print("⏳ Đang đợi 3 giây để hệ thống ổn định...")
    task.wait(3)
    
    warn("🛰️ BẮT ĐẦU QUY TRÌNH SNIPER...")
    
    -- Mở UI
    local ui = Players.LocalPlayer.PlayerGui:FindFirstChild("ServerBrowser")
    if ui then
        ui.Enabled = true
        if ui:FindFirstChild("Frame") then ui.Frame.Visible = true end
    end
    
    -- Nhập Singapore vào TextBox
    local tb = Players.LocalPlayer.PlayerGui.ServerBrowser.Frame.Filters.SearchRegion.TextBox
    tb.Text = targetRegion
    
    -- Gọi lệnh Search đầu tiên
    ReplicatedStorage.__ServerBrowser:InvokeServer(1, targetRegion)

    -- 🚨 THÊM: Spam Refresh mỗi 1 giây sau khi mở UI (Kết hợp Click vật lý và gọi Remote ngầm để chống lỗi Focus Tab)
    task.spawn(function()
        while not isHopping do
            ClickRefresh()
            pcall(function()
                ReplicatedStorage.__ServerBrowser:InvokeServer(1, targetRegion)
            end)
            task.wait(1)
        end
    end)
end

-- THỰC THI
StartProcess()
