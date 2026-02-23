-- =============================================================
-- DRACO HUB - DRAGON WIZARD (DOUBLE INTERACT FIXED)
-- Style: Sử dụng đúng Invoker hệ thống của Vũ
-- =============================================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local lp = game.Players.LocalPlayer

-- 1. TẠO UI STATUS NHỎ GỌN
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 260, 0, 140)
Main.Position = UDim2.new(0.5, -130, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(255, 200, 0)

local StatusLabel = Instance.new("TextLabel", Main)
StatusLabel.Size = UDim2.new(1, -20, 0, 50)
StatusLabel.Position = UDim2.new(0, 10, 0, 10)
StatusLabel.Text = "Sẵn sàng... Hãy đứng sát NPC"
StatusLabel.TextColor3 = Color3.new(0.9, 0.9, 0.9)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.TextSize = 14

-- 2. KHAI BÁO REMOTE THEO ĐÚNG KIỂU CỦA VŨ (FIX LỖI NIL)
local NetFolder = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net")
local RFInteract = NetFolder:WaitForChild("RF/InteractDragonQuest")

local function DragonWizardInteract()
    -- Lần 1: Gọi Remote để hiện bảng hội thoại
    StatusLabel.Text = "⚡ Bước 1: Mở bảng hội thoại..."
    StatusLabel.TextColor3 = Color3.new(1, 1, 0)
    
    local ok1 = pcall(function() 
        RFInteract:InvokeServer({}) 
    end)
    
    task.wait(1) -- Đợi bảng hiện ra
    
    -- Lần 2: Gọi Remote để chốt lệnh (Học võ/Nở trứng)
    StatusLabel.Text = "🔥 Bước 2: Chốt lệnh Mua..."
    StatusLabel.TextColor3 = Color3.new(1, 0.5, 0)
    
    local ok2, res = pcall(function() 
        return RFInteract:InvokeServer({}) 
    end)
    
    if ok2 then
        StatusLabel.Text = "✅ THÀNH CÔNG!\nĐã xong quy trình 2 lần nhấn."
        StatusLabel.TextColor3 = Color3.new(0, 1, 0)
    else
        StatusLabel.Text = "❌ LỖI: " .. tostring(res)
        StatusLabel.TextColor3 = Color3.new(1, 0, 0)
    end
    
    task.wait(3)
    StatusLabel.Text = "Đã sẵn sàng cho lần tiếp theo"
    StatusLabel.TextColor3 = Color3.new(0.9, 0.9, 0.9)
end

-- 3. NÚT BẤM TEST
local TestBtn = Instance.new("TextButton", Main)
TestBtn.Size = UDim2.new(0, 180, 0, 45)
TestBtn.Position = UDim2.new(0.5, -90, 0.6, 0)
TestBtn.Text = "MUA / HATCH (2 HIT)"
TestBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
TestBtn.TextColor3 = Color3.new(1, 1, 1)
TestBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", TestBtn)

TestBtn.MouseButton1Click:Connect(function()
    DragonWizardInteract()
end)
