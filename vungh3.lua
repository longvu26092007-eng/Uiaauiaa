-- =============================================================
-- DRACO HUB - DRAGON WIZARD (FIXED TABLE INDEX)
-- Style: Bám sát Modules.Net - Dùng ngoặc vuông để gọi Remote
-- =============================================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- 1. TẠO GIAO DIỆN NHỎ GỌN
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 250, 0, 120)
Main.Position = UDim2.new(0.5, -125, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.Active = true
Main.Draggable = true 
Instance.new("UICorner", Main)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(255, 200, 0)

local StatusLabel = Instance.new("TextLabel", Main)
StatusLabel.Size = UDim2.new(1, -20, 0, 40)
StatusLabel.Position = UDim2.new(0, 10, 0, 10)
StatusLabel.Text = "Đứng gần NPC rồi bấm mua"
StatusLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Font = Enum.Font.Gotham

-- 2. ĐỊNH NGHĨA NET INVOKER (FIX LỖI DẤU GẠCH CHÉO /)
-- Thay vì gọi .RF/Interact... ta dùng ["RF/InteractDragonQuest"]
local NetFolder = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net")
local InteractRF = NetFolder:WaitForChild("RF/InteractDragonQuest")

local function FastPurchase()
    -- Lần 1: Mở bảng hội thoại
    StatusLabel.Text = "⚡ Đang mở bảng..."
    pcall(function() 
        InteractRF:InvokeServer({}) 
    end)
    
    task.wait(0.8) -- Đợi bảng hiện
    
    -- Lần 2: Chốt lệnh Mua/Học
    StatusLabel.Text = "🔥 Đang chốt mua..."
    local ok, res = pcall(function() 
        return InteractRF:InvokeServer({}) 
    end)
    
    if ok then
        StatusLabel.Text = "✅ Thành công!"
        StatusLabel.TextColor3 = Color3.new(0, 1, 0)
    else
        StatusLabel.Text = "❌ Lỗi: " .. tostring(res)
        StatusLabel.TextColor3 = Color3.new(1, 0, 0)
    end
    
    task.wait(2)
    StatusLabel.Text = "Sẵn sàng cho lần tiếp"
    StatusLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
end

-- 3. NÚT BẤM MUA
local BuyBtn = Instance.new("TextButton", Main)
BuyBtn.Size = UDim2.new(0, 180, 0, 40)
BuyBtn.Position = UDim2.new(0.5, -90, 0.55, 0)
BuyBtn.Text = "MUA / HATCH"
BuyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
BuyBtn.TextColor3 = Color3.new(1, 1, 1)
BuyBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", BuyBtn)

BuyBtn.MouseButton1Click:Connect(function()
    FastPurchase()
end)
