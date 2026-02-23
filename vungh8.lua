-- =============================================================
-- DRACO HUB - DRAGON WIZARD (TRIPLE INVOKE SYSTEM)
-- Lộ trình: NPC ({}) -> Dragon Tether ({"Dragon Tether"}) -> Yes ({"Yes"})
-- Style: Bắt chước 100% logic Invoker của Vũ Nguyễn
-- =============================================================

repeat task.wait() until game:IsLoaded()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

-- 1. KHAI BÁO REMOTE (Dùng ngoặc vuông để tránh lỗi Table Index)
local RFInteract = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net")["RF/InteractDragonQuest"]

-- 2. TẠO UI MONITOR
if CoreGui:FindFirstChild("DracoWizardTriple") then CoreGui.DracoWizardTriple:Destroy() end
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "DracoWizardTriple"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 280, 0, 160)
Main.Position = UDim2.new(0.5, -140, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(255, 200, 0)
Instance.new("UICorner", Main)

local StatusLabel = Instance.new("TextLabel", Main)
StatusLabel.Size = UDim2.new(1, -20, 0, 60); StatusLabel.Position = UDim2.new(0, 10, 0, 10)
StatusLabel.Text = "Sẵn sàng lộ trình:\nNPC -> Tether -> Yes"; StatusLabel.TextColor3 = Color3.new(1, 1, 1)
StatusLabel.BackgroundTransparency = 1; StatusLabel.Font = Enum.Font.GothamBold; StatusLabel.TextSize = 13; StatusLabel.TextWrapped = true

-- 3. HÀM INTERACT LIÊN HOÀN (Đóng gói như hàm craftByRF của cậu)
local function DragonTetherAction()
    -- Bước 1: Nhấn vào NPC
    StatusLabel.Text = "⚡ Step 1: Interacting with NPC..."
    StatusLabel.TextColor3 = Color3.new(1, 1, 0)
    pcall(function() RFInteract:InvokeServer({}) end)
    
    task.wait(0.3) -- Delay chuẩn phong cách Lua của Vũ
    
    -- Bước 2: Chọn Dragon Tether
    StatusLabel.Text = "⚡ Step 2: Selecting 'Dragon Tether'..."
    StatusLabel.TextColor3 = Color3.new(1, 0.5, 0)
    pcall(function() RFInteract:InvokeServer({"Dragon Tether"}) end)
    
    task.wait(0.3)
    
    -- Bước 3: Chốt lệnh Yes
    StatusLabel.Text = "🔥 Step 3: Confirming 'Yes'..."
    StatusLabel.TextColor3 = Color3.new(0, 1, 0)
    local ok, res = pcall(function() 
        return RFInteract:InvokeServer({"Yes"}) 
    end)
    
    if ok then
        StatusLabel.Text = "✅ THÀNH CÔNG!\nĐã chốt xong Dragon Tether."
        warn("[Draco] Dragon Tether executed successfully")
    else
        StatusLabel.Text = "❌ THẤT BẠI: " .. tostring(res)
        warn("[Draco] Dragon Tether failed")
    end
end

-- 4. NÚT BẤM TEST
local TestBtn = Instance.new("TextButton", Main)
TestBtn.Size = UDim2.new(0, 200, 0, 45); TestBtn.Position = UDim2.new(0.5, -100, 0.65, 0)
TestBtn.Text = "START TETHER ACTION"; TestBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
TestBtn.TextColor3 = Color3.new(1, 1, 1); TestBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", TestBtn)

TestBtn.MouseButton1Click:Connect(function()
    task.spawn(DragonTetherAction)
end)
