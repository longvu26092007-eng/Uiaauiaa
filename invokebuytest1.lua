-- ======================================================================
-- SCRIPT TEST FISHERMAN V2 - AUTO OPEN & SELECT UI
-- ======================================================================

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local PlayerGui = lp:WaitForChild("PlayerGui")

-- 1. GUI TEST
local TestGui = Instance.new("ScreenGui")
TestGui.Name = "FishermanTestV2"
TestGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 280, 0, 200)
MainFrame.Position = UDim2.new(0.5, -140, 0.4, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = TestGui

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 40)
StatusLabel.Position = UDim2.new(0, 0, 0.1, 0)
StatusLabel.Text = "Status: Đang đợi lệnh..."
StatusLabel.TextColor3 = Color3.new(1, 1, 1)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Parent = MainFrame

-- 2. HÀM TƯƠNG TÁC (KIỂU "THẤY ĐƯỢC")
local function StartTest()
    StatusLabel.Text = "Đang gửi tín hiệu mở bảng..."
    
    -- Bước 1: Gọi NPC Fisherman để mở bảng đầu tiên
    local CommF = game:GetService("ReplicatedStorage").Remotes.CommF_
    CommF:InvokeServer("Fisherman", "Shop") 
    
    task.wait(0.5) -- Đợi bảng hiện lên
    
    -- Bước 2: Tự động chọn "Buy Bait" trên bảng UI của game
    -- (Trong Blox Fruit, bảng này thường nằm trong PlayerGui.Main.Dialogue)
    StatusLabel.Text = "Đang chọn: Buy Bait..."
    CommF:InvokeServer("Fisherman", "Buy Bait")
    
    task.wait(0.5)
    
    -- Bước 3: Chọn loại mồi "Basic Bait"
    StatusLabel.Text = "Đang chọn: Basic Bait..."
    local result = CommF:InvokeServer("Fisherman", "Basic Bait")
    
    -- Kiểm tra kết quả
    if result then
        StatusLabel.Text = "Xong! Kiểm tra PlayerGui.Main.Craft"
        StatusLabel.TextColor3 = Color3.new(0, 1, 0)
    else
        StatusLabel.Text = "Lỗi hoặc thiếu nguyên liệu!"
        StatusLabel.TextColor3 = Color3.new(1, 0, 0)
    end
end

-- 3. NÚT BẤM
local Btn = Instance.new("TextButton")
Btn.Size = UDim2.new(0.8, 0, 0, 45)
Btn.Position = UDim2.new(0.1, 0, 0.6, 0)
Btn.Text = "TEST QUY TRÌNH BAIT"
Btn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
Btn.TextColor3 = Color3.new(1, 1, 1)
Btn.Parent = MainFrame

Btn.MouseButton1Click:Connect(StartTest)
