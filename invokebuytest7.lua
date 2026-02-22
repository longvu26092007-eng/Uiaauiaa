-- ======================================================================
-- FISHERMAN SILENT CRAFT - BẢN CHÍNH THỨC (BASED ON LOG V11)
-- ======================================================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Khai báo các Remote bí mật từ Log của bạn
local JobsRemote = ReplicatedStorage:WaitForChild("RF"):WaitForChild("JobsRemoteFunction")
local CraftRemote = ReplicatedStorage:WaitForChild("RF"):WaitForChild("Craft")

local function SilentCraftBait()
    print("--- Đang thực hiện Silent Craft... ---")
    
    -- Bước 1: Mồi nhử hội thoại (Dựa trên Log 11:37:05)
    -- Giúp Server xác nhận bạn đang tương tác với NPC Fisherman
    pcall(function()
        JobsRemote:InvokeServer("FishingNPC", "Bait", "Check", "Fisherman")
    end)
    
    task.wait(0.3) -- Chờ server nhận session hội thoại

    -- Bước 2: Gửi lệnh kiểm tra món đồ (Dựa trên Log 11:37:14)
    pcall(function()
        CraftRemote:InvokeServer("Check", "Basic Bait")
    end)

    task.wait(0.3)

    -- Bước 3: LỆNH CHỐT - THỰC HIỆN CRAFT (Dựa trên Log 11:37:17)
    -- Lệnh này sẽ trừ nguyên liệu và cho bạn mồi ngay lập tức
    local success, result = pcall(function()
        return CraftRemote:InvokeServer("Craft", "Basic Bait", nil)
    end)

    if success then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Fisherman System",
            Text = "Đã Craft mồi thành công!",
            Duration = 3,
            Button1 = "OK"
        })
    else
        warn("Lỗi khi gửi lệnh Craft: ", result)
    end
end

-- Chạy thử nghiệm ngay lập tức
SilentCraftBait()
