local HydraRemote = workspace:WaitForChild("HydraIslandClient"):WaitForChild("RemoteFunction")

-- 1. Lệnh Tương Tác (Giả lập việc nhấn E/Interact)
local function InteractHydra()
    local success, result = pcall(function()
        return HydraRemote:InvokeServer("Interacted")
    end)
    if success then
        print("✅ Đã gửi lệnh Interacted!")
    else
        warn("❌ Lỗi tương tác: ", result)
    end
end

-- 2. Lệnh Kiểm Tra Tiến Độ (Xem điều kiện nâng cấp)
local function CheckProgress()
    local success, result = pcall(function()
        return HydraRemote:InvokeServer("progress")
    end)
    if success then
        print("📊 Tiến độ hiện tại: ", result) -- Kết quả trả về thường hiện ở đây
    else
        warn("❌ Lỗi check progress: ", result)
    end
end

-- Thực hiện thử cả 2 lệnh
InteractHydra()
task.wait(0.5)
CheckProgress()
