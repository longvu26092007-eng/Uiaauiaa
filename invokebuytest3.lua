-- ======================================================================
-- SCRIPT FISHERMAN V4 - SILENT INVOKE (KHÔNG DỊCH CHUYỂN - CHỐNG KILL)
-- ======================================================================

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")

-- Tạo GUI nhỏ để bạn theo dõi
local TestGui = Instance.new("ScreenGui")
TestGui.Name = "FishermanV4"
TestGui.Parent = lp.PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 100)
MainFrame.Position = UDim2.new(0.5, -125, 0.8, 0) -- Để sát dưới cùng để không vướng màn hình farm
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 0.5
MainFrame.Parent = TestGui

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 1, 0)
StatusLabel.Text = "Status: Đang đợi Test (Silent)"
StatusLabel.TextColor3 = Color3.new(1, 1, 1)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Parent = MainFrame

-- HÀM GỬI LỆNH TRỰC TIẾP (SILENT)
local function SilentCraft()
    StatusLabel.Text = "Đang gửi lệnh Silent..."
    StatusLabel.TextColor3 = Color3.new(0, 1, 1)

    -- Thay vì dịch chuyển, ta dùng pcall để gửi chuỗi lệnh mồi liên tục
    -- Việc này ép Server mở luồng dữ liệu cho bạn mà không cần check khoảng cách quá gắt
    task.spawn(function()
        pcall(function()
            -- Gửi đồng thời các bước để "ép" server phản hồi
            CommF:InvokeServer("Fisherman", "Shop")
            task.wait(0.1)
            CommF:InvokeServer("Fisherman", "Buy Bait")
            task.wait(0.1)
            -- Lệnh cuối cùng để mở khung Craft hoặc thực hiện mua
            local result = CommF:InvokeServer("Fisherman", "Basic Bait")
            
            if result then
                StatusLabel.Text = "XONG! Đã gửi lệnh Craft thành công."
                StatusLabel.TextColor3 = Color3.new(0, 1, 0)
            else
                StatusLabel.Text = "Done! Nếu không thấy bảng hãy đứng gần NPC hơn một chút."
                StatusLabel.TextColor3 = Color3.new(1, 0.5, 0)
            end
        end)
    end)
end

-- Tự động kích hoạt khi bạn nhấn nút (hoặc bạn có thể gọi hàm này từ script Farm của bạn)
local Btn = Instance.new("TextButton")
Btn.Size = UDim2.new(1, 0, 0.4, 0)
Btn.Position = UDim2.new(0, 0, 0.6, 0)
Btn.Text = "CRAFT BAIT (SILENT)"
Btn.Parent = MainFrame
Btn.MouseButton1Click:Connect(SilentCraft)
