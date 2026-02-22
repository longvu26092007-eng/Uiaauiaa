-- ======================================================================
-- SCRIPT TEST CRAFT/BUY BAIT (FISHERMAN NPC)
-- ======================================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local lp = Players.LocalPlayer

-- 1. KHỞI TẠO GUI TEST (Theo phong cách BloxFruitHub của bạn)
local TestGui = Instance.new("ScreenGui")
TestGui.Name = "TestCraftGui"
TestGui.Parent = lp.PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 180)
MainFrame.Position = UDim2.new(0.5, -125, 0.4, -90)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Active = true
MainFrame.Draggable = true -- Hỗ trợ test nhanh
MainFrame.Parent = TestGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "FISHERMAN CRAFT TEST"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Parent = MainFrame

-- Status Label (Báo trạng thái như yêu cầu)
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -20, 0, 40)
StatusLabel.Position = UDim2.new(0, 10, 0, 40)
StatusLabel.Text = "Status: Waiting..."
StatusLabel.TextColor3 = Color3.new(1, 1, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextWrapped = true
StatusLabel.Parent = MainFrame

-- 2. LOGIC TƯƠNG TÁC (Tham chiếu từ Order_System.lua)
local CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")

local function CraftBait()
    StatusLabel.Text = "Status: Đang gửi lệnh tới Fisherman..."
    StatusLabel.TextColor3 = Color3.new(1, 0.5, 0)
    
    -- Quy trình: Fisherman -> Shop -> Buy Bait -> Basic Bait
    -- Lưu ý: Các tham số dưới đây dựa trên quy trình bạn mô tả, 
    -- bạn có thể cần chỉnh sửa tên chính xác của vật phẩm trong game.
    
    local result = CommF:InvokeServer("Fisherman", "Shop", "Buy Bait", "Basic Bait")
    
    -- Xử lý phản hồi từ Server
    if result == "Success" or result == true then
        StatusLabel.Text = "Status: CRAFT THÀNH CÔNG!"
        StatusLabel.TextColor3 = Color3.new(0, 1, 0)
    elseif result == "NotEnoughMaterials" then
        StatusLabel.Text = "Status: THẤT BẠI - Thiếu nguyên liệu!"
        StatusLabel.TextColor3 = Color3.new(1, 0, 0)
    else
        StatusLabel.Text = "Status: Done (Kiểm tra túi đồ)"
        StatusLabel.TextColor3 = Color3.new(0, 0.8, 1)
    end
end

-- 3. NÚT BẤM TEST
local CraftBtn = Instance.new("TextButton")
CraftBtn.Size = UDim2.new(0.8, 0, 0, 40)
CraftBtn.Position = UDim2.new(0.1, 0, 0.65, 0)
CraftBtn.Text = "BUY / CRAFT BAIT"
CraftBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
CraftBtn.TextColor3 = Color3.new(1, 1, 1)
CraftBtn.Parent = MainFrame

CraftBtn.MouseButton1Click:Connect(function()
    CraftBait()
end)

-- Nút đóng GUI
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.new(1, 0, 0)
CloseBtn.Parent = MainFrame
CloseBtn.MouseButton1Click:Connect(function() TestGui:Destroy() end)

print("--- Script Test Fisherman Craft đã sẵn sàng ---")
