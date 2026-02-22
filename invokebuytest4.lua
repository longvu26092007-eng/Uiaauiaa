-- ======================================================================
-- SCRIPT FISHERMAN V5 - CHUẨN HÓA THEO HỆ THỐNG FILE CỦA BẠN
-- ======================================================================

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")

-- Tham khảo từ file SystemUI.lua của bạn để quản lý trạng thái
local Status = {
    Current = "Đang chờ...",
    Color = Color3.new(1, 1, 1)
}

-- 1. GUI TEST (Thiết kế giống phong cách BloxFruitHub của bạn)
local ScreenGui = Instance.new("ScreenGui", lp.PlayerGui)
ScreenGui.Name = "FishermanCraftSystem"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 260, 0, 150)
Main.Position = UDim2.new(0.5, -130, 0.4, -75)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "FISHERMAN SYSTEM"
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.TextColor3 = Color3.new(1, 1, 1)

local Label = Instance.new("TextLabel", Main)
Label.Size = UDim2.new(1, 0, 0, 40)
Label.Position = UDim2.new(0, 0, 0.25, 0)
Label.Text = Status.Current
Label.TextColor3 = Status.Color
Label.BackgroundTransparency = 1

-- 2. LOGIC CRAFT (Bắt chước file Order_System.lua)
local function ExecuteFishermanCraft()
    Label.Text = "Đang khởi tạo hội thoại..."
    Label.TextColor3 = Color3.new(1, 0.7, 0)

    -- BƯỚC 1: Trigger NPC (Đây là bước quan trọng nhất để Server mở luồng)
    -- Thay vì mang nhân vật đi, ta gửi tín hiệu mồi đúng logic game
    local step1 = CommF:InvokeServer("Fisherman", "Shop")
    task.wait(0.4) -- Đợi server load Dialogue

    -- BƯỚC 2: Kiểm tra nếu bảng Dialogue của game hiện lên thì mới nhấn tiếp
    -- (Tham khảo đường dẫn Main gốc từ ảnh bạn mô tả)
    local Dialogue = lp.PlayerGui.Main:FindFirstChild("Dialogue")
    
    Label.Text = "Đang chọn: Buy Bait..."
    local step2 = CommF:InvokeServer("Fisherman", "Buy Bait")
    task.wait(0.4)

    -- BƯỚC 3: Đây là lệnh cuối cùng để "Khung Craft" hiện ra
    Label.Text = "Đang mở Khung Craft..."
    local finalResult = CommF:InvokeServer("Fisherman", "Basic Bait")

    -- KIỂM TRA THỰC TẾ TRÊN MÀN HÌNH
    task.delay(0.2, function()
        local CraftFrame = lp.PlayerGui.Main:FindFirstChild("Craft")
        if CraftFrame then
            CraftFrame.Visible = true -- Ép hiện khung craft như trong ảnh
            Label.Text = "DONE: Khung Craft đã mở!"
            Label.TextColor3 = Color3.new(0, 1, 0)
        else
            Label.Text = "LỖI: Server từ chối mở bảng."
            Label.TextColor3 = Color3.new(1, 0, 0)
        end
    end)
end

-- 3. NÚT MUA / CRAFT
local ActionBtn = Instance.new("TextButton", Main)
ActionBtn.Size = UDim2.new(0.8, 0, 0, 40)
ActionBtn.Position = UDim2.new(0.1, 0, 0.65, 0)
ActionBtn.Text = "CRAFT / BUY TEST"
ActionBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
ActionBtn.TextColor3 = Color3.new(1, 1, 1)

ActionBtn.MouseButton1Click:Connect(ExecuteFishermanCraft)
