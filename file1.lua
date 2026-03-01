local HydraRemote = workspace:WaitForChild("HydraIslandClient"):WaitForChild("RemoteFunction")

-- Hàm kiểm tra trạng thái tương tác dựa trên logic của Vũ
local function CheckHydraStatus()
    print("------------------------------------------")
    print("🔍 Đang gửi lệnh Interacted để check...")
    
    local status = HydraRemote:InvokeServer("Interacted")
    
    if status == 4 then
        warn("✅ KẾT QUẢ: 4 (ĐÃ HOÀN THÀNH / ĐÃ ĐƯỢC)")
        -- Cậu có thể thêm code thông báo UI tại đây
    elseif status == nil then
        print("❌ KẾT QUẢ: nil (CHƯA ĐẠT / CHƯA ĐƯỢC)")
    else
        print("❓ KẾT QUẢ LẠ: ", tostring(status))
    end
    print("------------------------------------------")
end

-- Chạy thử ngay
CheckHydraStatus()

-- Nếu Vũ muốn nó tự động nhắc khi nào "Đạt" (Loop check)
-- task.spawn(function()
--     while task.wait(5) do
--         local s = HydraRemote:InvokeServer("Interacted")
--         if s == 4 then
--             warn("🔥 THÔNG BÁO: VÙNG HYDRA ĐÃ SẴN SÀNG!")
--             break
--         end
--     end
-- end)
