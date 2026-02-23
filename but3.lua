local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function OpenServerBrowser()
    -- 1. Xác định đường dẫn chuẩn từ thông tin Vũ cung cấp
    local browserUI = PlayerGui:FindFirstChild("ServerBrowser")
    
    if browserUI then
        print("🔓 Đang mở bảng Server Browser...")
        
        -- 2. Ép hiện bảng chính và Frame bên trong
        browserUI.Enabled = true -- Nếu nó là ScreenGui thì dùng Enabled
        if browserUI:FindFirstChild("Frame") then
            browserUI.Frame.Visible = true
        end

        -- 3. CỰC KỲ QUAN TRỌNG: Gọi Remote để đổ dữ liệu vào bảng
        -- Nếu chỉ hiện UI mà không gọi Remote thì bảng sẽ bị trống (Empty)
        task.spawn(function()
            local ok = pcall(function()
                ReplicatedStorage.__ServerBrowser:InvokeServer(1)
            end)
            if ok then
                print("📡 Đã load danh sách Server thành công!")
            else
                warn("❌ Remote __ServerBrowser không phản hồi, nhưng bảng đã mở.")
            end
        end)
    else
        warn("❌ Không tìm thấy ServerBrowser trong PlayerGui của cậu!")
    end
end

-- Chạy lệnh
OpenServerBrowser()
