-- =============================================================
-- DRACO HUB - DRAGON WIZARD (AUTO INTERACT UI)
-- Logic: Interact -> Select "Dragon Tether" -> Finish
-- =============================================================

repeat task.wait() until game:IsLoaded()

-- 1. TẠO GIAO DIỆN (UI)
local lp = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

-- Xóa UI cũ nếu tồn tại
if CoreGui:FindFirstChild("DracoWizardTest") then
    CoreGui.DracoWizardTest:Destroy()
end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "DracoWizardTest"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 280, 0, 160)
Main.Position = UDim2.new(0.5, -140, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(255, 200, 0)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "DRAGON WIZARD TESTER"
Title.TextColor3 = Color3.fromRGB(255, 200, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14

local StatusLabel = Instance.new("TextLabel", Main)
StatusLabel.Size = UDim2.new(1, -20, 0, 50)
StatusLabel.Position = UDim2.new(0, 10, 0, 40)
StatusLabel.Text = "Trạng thái: Sẵn sàng..."
StatusLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextWrapped = true
StatusLabel.Font = Enum.Font.Gotham

-- 2. ĐỊNH NGHĨA REMOTE INVOKER (Đúng chuẩn cậu Spy)
local InteractRF = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net")["RF/InteractDragonQuest"]

local function StartHatchProcess()
    StatusLabel.Text = "Trạng thái: ⚡ Bước 1 - Đang mở bảng hội thoại..."
    StatusLabel.TextColor3 = Color3.new(1, 1, 0)
    
    -- Gửi lệnh mở hội thoại (Tham số rỗng)
    local ok1 = pcall(function() 
        InteractRF:InvokeServer({}) 
    end)
    
    task.wait(1.2) -- Đợi bảng lựa chọn hiện ra
    
    if ok1 then
        StatusLabel.Text = "Trạng thái: 🔥 Bước 2 - Đang chọn 'Dragon Tether'..."
        StatusLabel.TextColor3 = Color3.new(1, 0.5, 0)
        
        -- Gửi lệnh chọn Dragon Tether (Tham số là table chứa string)
        local ok2, res = pcall(function() 
            return InteractRF:InvokeServer({"Dragon Tether"}) 
        end)
        
        if ok2 then
            StatusLabel.Text = "Trạng thái: ✅ THÀNH CÔNG!\nĐã gửi lệnh học Dragon Tether."
            StatusLabel.TextColor3 = Color3.new(0, 1, 0)
        else
            StatusLabel.Text = "Trạng thái: ❌ Lỗi bước 2: " .. tostring(res)
            StatusLabel.TextColor3 = Color3.new(1, 0, 0)
        end
    else
        StatusLabel.Text = "Trạng thái: ❌ Lỗi mở bảng hội thoại!"
        StatusLabel.TextColor3 = Color3.new(1, 0, 0)
    end
    
    task.wait(3)
    StatusLabel.Text = "Trạng thái: Sẵn sàng cho lần tiếp..."
    StatusLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
end

-- 3. NÚT BẤM TEST
local TestBtn = Instance.new("TextButton", Main)
TestBtn.Size = UDim2.new(0.8, 0, 0, 40)
TestBtn.Position = UDim2.new(0.1, 0, 0.65, 0)
TestBtn.Text = "BẮT ĐẦU TEST HATCH"
TestBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
TestBtn.TextColor3 = Color3.new(1, 1, 1)
TestBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", TestBtn)

TestBtn.MouseButton1Click:Connect(function()
    task.spawn(StartHatchProcess)
end)
