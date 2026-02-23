-- =============================================================
-- DRAGON WIZARD BUYER (STYLE: BUY DRAGON TALON)
-- =============================================================

-- 1. Khai báo Remote gọn gàng
local Net = game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net")
local RFInteract = Net["RF/InteractDragonQuest"]

-- 2. Hàm mua thẳng (Bắn 3 lệnh liên tiếp cực nhanh)
local function BuyDragonTether()
    ActionStatus.Text = "Hành động: Đang mua Dragon Tether..."
    ActionStatus.TextColor3 = Color3.fromRGB(255, 200, 0)
    
    pcall(function()
        -- Bắn liên hoàn 3 tham số để chốt giao dịch
        RFInteract:InvokeServer({})
        task.wait(0.1)
        RFInteract:InvokeServer({"Dragon Tether"})
        task.wait(0.1)
        RFInteract:InvokeServer({"Yes"})
    end)
    
    ActionStatus.Text = "Hành động: Đã gửi lệnh mua Dragon Tether!"
    ActionStatus.TextColor3 = Color3.fromRGB(0, 255, 0)
end

-- 3. Tạo nút bấm trên UI Draco Hub của Vũ
local BuyTetherBtn = Instance.new("TextButton", MainFrame)
BuyTetherBtn.Size = UDim2.new(0, 105, 0, 25)
BuyTetherBtn.Position = UDim2.new(1, -310, 1, -30) -- Đặt cạnh nút Dojo của cậu
BuyTetherBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
BuyTetherBtn.Text = "Buy Tether"
BuyTetherBtn.TextColor3 = Color3.fromRGB(255, 200, 0)
BuyTetherBtn.Font = Enum.Font.GothamBold
BuyTetherBtn.TextSize = 12
Instance.new("UICorner", BuyTetherBtn).CornerRadius = UDim.new(0, 4)
Instance.new("UIStroke", BuyTetherBtn).Color = Color3.fromRGB(255, 200, 0)

-- Kết nối nút bấm
BuyTetherBtn.MouseButton1Click:Connect(function()
    task.spawn(BuyDragonTether)
end)
