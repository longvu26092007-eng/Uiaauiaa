-- =============================================================
-- DRACO HUB - DRAGON WIZARD MODULE (PURCHASE LOGIC)
-- Style: Giống hệt cách mua Dragon Talon trong source chính
-- =============================================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- 1. Định nghĩa Invoker chuẩn (Fix lỗi dấu gạch chéo bằng ngoặc vuông)
local NetFolder = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net")
local RFInteract = NetFolder:WaitForChild("RF/InteractDragonQuest")

-- 2. Hàm thực thi 3 bước (NPC -> Tether -> Yes)
local function DragonWizardHatch()
    if ActionStatus then 
        ActionStatus.Text = "Hành động: Đang gửi lệnh Hatch (Bước 1/3)..." 
        ActionStatus.TextColor3 = Color3.fromRGB(255, 200, 0)
    end

    -- Bước 1: Mở hội thoại
    pcall(function() 
        RFInteract:InvokeServer({}) 
    end)
    
    task.wait(0.3) -- Delay ngắn theo phong cách của Vũ

    -- Bước 2: Chọn Dragon Tether
    if ActionStatus then ActionStatus.Text = "Hành động: Đang chọn Dragon Tether (Bước 2/3)..." end
    pcall(function() 
        RFInteract:InvokeServer({"Dragon Tether"}) 
    end)
    
    task.wait(0.3)

    -- Bước 3: Xác nhận YES để chốt mua
    if ActionStatus then ActionStatus.Text = "Hành động: Đang xác nhận YES (Bước 3/3)..." end
    local ok, res = pcall(function() 
        return RFInteract:InvokeServer({"Yes"}) 
    end)

    -- Hiển thị kết quả lên bảng Draco Hub UI
    if ok then
        if ActionStatus then 
            ActionStatus.Text = "Hành động: ĐÃ HATCH THÀNH CÔNG!" 
            ActionStatus.TextColor3 = Color3.fromRGB(0, 255, 0)
        end
        warn("[Draco Hub] Hatch Success: " .. tostring(res))
    else
        if ActionStatus then 
            ActionStatus.Text = "Hành động: Lỗi Hatch: " .. tostring(res)
            ActionStatus.TextColor3 = Color3.fromRGB(255, 0, 0)
        end
        warn("[Draco Hub] Hatch Failed")
    end
end

-- =============================================================
-- VÍ DỤ TÍCH HỢP VÀO NÚT BẤM TEST TRÊN UI CỦA CẬU
-- =============================================================
local TestHatchBtn = Instance.new("TextButton", MainFrame) -- Gắn vào MainFrame của cậu
TestHatchBtn.Size = UDim2.new(0, 105, 0, 25)
TestHatchBtn.Position = UDim2.new(1, -310, 1, -30)
TestHatchBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TestHatchBtn.Text = "Test Hatch"
TestHatchBtn.TextColor3 = Color3.fromRGB(0, 255, 0)
TestHatchBtn.Font = Enum.Font.GothamBold
TestHatchBtn.TextSize = 12
Instance.new("UICorner", TestHatchBtn).CornerRadius = UDim.new(0, 4)
Instance.new("UIStroke", TestHatchBtn).Color = Color3.fromRGB(0, 255, 0)

TestHatchBtn.MouseButton1Click:Connect(function()
    task.spawn(DragonWizardHatch)
end)
