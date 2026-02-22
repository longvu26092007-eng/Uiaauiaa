-- ======================================================================
-- FISHERMAN SILENT SYSTEM - CRAFT & CONFIRM VERSION
-- Tham chiếu logic: Order_System.lua (Silent Invoke)
-- ======================================================================

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local CommF = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_")

-- 1. GUI THÔNG BÁO TRẠNG THÁI (SILENT)
local ScreenGui = Instance.new("ScreenGui", lp.PlayerGui)
ScreenGui.Name = "FishermanSilentSystem"

local StatusLabel = Instance.new("TextLabel", ScreenGui)
StatusLabel.Size = UDim2.new(0, 250, 0, 30)
StatusLabel.Position = UDim2.new(0.5, -125, 0, 80)
StatusLabel.BackgroundColor3 = Color3.new(0, 0, 0)
StatusLabel.BackgroundTransparency = 0.6
StatusLabel.TextColor3 = Color3.new(1, 1, 1)
StatusLabel.Text = "Fisherman: Standby"

-- 2. HÀM CRAFT SILENT (GỬI CẢ CRAFT LẪN CONFIRM)
local function SilentFishermanCraft()
    task.spawn(function()
        StatusLabel.Text = "Đang gửi lệnh Craft..."
        StatusLabel.TextColor3 = Color3.new(1, 1, 0)

        pcall(function()
            -- BƯỚC 1: Mở luồng hội thoại
            CommF:InvokeServer("Fisherman", "Shop") 
            task.wait(0.1)

            -- BƯỚC 2: Gửi lệnh CHẾ TẠO (Craft)
            -- Đây là lệnh quan trọng nhất để Server kiểm tra nguyên liệu và bắt đầu chế tạo
            CommF:InvokeServer("Fisherman", "Basic Bait", "Craft")
            
            task.wait(0.1)

            -- BƯỚC 3: Gửi lệnh XÁC NHẬN (Confirm)
            -- Đảm bảo giao dịch được hoàn tất ngay cả khi game yêu cầu xác nhận lại
            local result = CommF:InvokeServer("Fisherman", "Basic Bait", "Confirm")

            -- Kết thúc
            if result then
                StatusLabel.Text = "CRAFT THÀNH CÔNG!"
                StatusLabel.TextColor3 = Color3.new(0, 1, 0)
            else
                StatusLabel.Text = "CRAFT Xong (Kiểm tra mồi)"
                StatusLabel.TextColor3 = Color3.new(0, 0.8, 1)
            end
        end)

        task.wait(2)
        StatusLabel.Text = "Fisherman: Standby"
        StatusLabel.TextColor3 = Color3.new(1, 1, 1)
    end)
end

-- 3. NÚT TEST (SILENT)
local ActionBtn = Instance.new("TextButton", ScreenGui)
ActionBtn.Size = UDim2.new(0, 250, 0, 40)
ActionBtn.Position = UDim2.new(0.5, -125, 0, 115)
ActionBtn.Text = "START SILENT CRAFT"
ActionBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ActionBtn.TextColor3 = Color3.new(1, 1, 1)

ActionBtn.MouseButton1Click:Connect(SilentFishermanCraft)
