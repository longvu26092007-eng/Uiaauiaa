-- =============================================================
-- DRACO HUB - DRAGON WIZARD (3-STEP DIRECT INVOKE)
-- Lộ trình: NPC -> Craft -> Dragon Heart
-- Style: Bắt chước 100% logic Invoke liên hoàn của Vũ Nguyễn
-- =============================================================

repeat task.wait() until game:IsLoaded()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

-- 1. KHAI BÁO REMOTE (Dùng ngoặc vuông để tránh lỗi Table Index is Nil)
local RFInteract = ReplicatedStorage
    :WaitForChild("Modules")
    :WaitForChild("Net")["RF/InteractDragonQuest"]

-- 2. GIAO DIỆN MONITOR GỌN NHẸ
if CoreGui:FindFirstChild("DracoWizardStep") then CoreGui.DracoWizardStep:Destroy() end
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "DracoWizardStep"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 280, 0, 150)
Main.Position = UDim2.new(0.5, -140, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(255, 200, 0)
Instance.new("UICorner", Main)

local StatusLabel = Instance.new("TextLabel", Main)
StatusLabel.Size = UDim2.new(1, -20, 0, 60); StatusLabel.Position = UDim2.new(0, 10, 0, 10)
StatusLabel.Text = "Sẵn sàng lộ trình:\nNPC -> Craft -> Dragon Heart"; StatusLabel.TextColor3 = Color3.new(1, 1, 1)
StatusLabel.BackgroundTransparency = 1; StatusLabel.Font = Enum.Font.GothamBold; StatusLabel.TextSize = 13; StatusLabel.TextWrapped = true

-- 3. HÀM THỰC THI LỘ TRÌNH 3 BƯỚC
local function executeDragonPath()
    -- BƯỚC 1: Nhấn NPC (Mở hội thoại)
    StatusLabel.Text = "⚡ Step 1: Interacting with NPC..."
    StatusLabel.TextColor3 = Color3.new(1, 1, 0)
    pcall(function() RFInteract:InvokeServer({}) end)
    
    task.wait(0.3) -- Delay ngắn theo phong cách của Vũ
    
    -- BƯỚC 2: Chọn mục Craft
    StatusLabel.Text = "⚡ Step 2: Selecting 'Craft'..."
    StatusLabel.TextColor3 = Color3.new(1, 0.5, 0)
    pcall(function() RFInteract:InvokeServer({"Craft"}) end)
    
    task.wait(0.3)
    
    -- BƯỚC 3: Chọn Dragon Heart (Hoặc Dragon Heart tùy theo Spy của cậu)
    StatusLabel.Text = "🔥 Step 3: Selecting 'Dragon Heart'..."
    StatusLabel.TextColor3 = Color3.new(0, 1, 0)
    local ok, res = pcall(function() 
        return RFInteract:InvokeServer({"Dragon Heart"}) 
    end)
    
    if ok then
        StatusLabel.Text = "✅ THÀNH CÔNG!\nServer phản hồi: " .. tostring(res)
        warn("[Draco] Path executed successfully")
    else
        StatusLabel.Text = "❌ THẤT BẠI: " .. tostring(res)
        warn("[Draco] Path failed")
    end
end

-- 4. NÚT BẤM TEST
local TestBtn = Instance.new("TextButton", Main)
TestBtn.Size = UDim2.new(0, 200, 0, 40); TestBtn.Position = UDim2.new(0.5, -100, 0.65, 0)
TestBtn.Text = "START 3-STEP HATCH"; TestBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
TestBtn.TextColor3 = Color3.new(1, 1, 1); TestBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", TestBtn)

TestBtn.MouseButton1Click:Connect(function()
    task.spawn(executeDragonPath)
end)
