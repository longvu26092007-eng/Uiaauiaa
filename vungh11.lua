-- =============================================================
-- DRACO HUB - DRAGON WIZARD (ADVANCED INTERACT)
-- Lộ trình: Speak -> LearnTether
-- Style: Bám sát cấu trúc Table Dictionary của Vũ Nguyễn
-- =============================================================

repeat task.wait() until game:IsLoaded()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

-- 1. ĐỊNH NGHĨA REMOTE (Dùng ngoặc vuông để tránh lỗi Table Index)
local NetFolder = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net")
local RFInteract = NetFolder:WaitForChild("RF/InteractDragonQuest")

-- 2. GIAO DIỆN MONITOR (VÀNG - ĐEN)
if CoreGui:FindFirstChild("DracoWizardHatch") then CoreGui.DracoWizardHatch:Destroy() end
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "DracoWizardHatch"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 300, 0, 160)
Main.Position = UDim2.new(0.5, -150, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Active = true; Main.Draggable = true
Instance.new("UIStroke", Main).Color = Color3.fromRGB(255, 200, 0)
Instance.new("UICorner", Main)

local StatusLabel = Instance.new("TextLabel", Main)
StatusLabel.Size = UDim2.new(1, -20, 0, 60); StatusLabel.Position = UDim2.new(0, 10, 0, 10)
StatusLabel.Text = "Hệ thống: Sẵn sàng...\nLộ trình: Speak -> LearnTether"; StatusLabel.TextColor3 = Color3.new(1, 1, 1)
StatusLabel.BackgroundTransparency = 1; StatusLabel.Font = Enum.Font.GothamBold; StatusLabel.TextSize = 13; StatusLabel.TextWrapped = true

-- 3. HÀM THỰC THI (SỬ DỤNG CẤU TRÚC DICTIONARY CỦA VŨ)
local function executeDragonTether()
    -- Lệnh 1: Speak
    StatusLabel.Text = "⚡ Bước 1: Đang gửi lệnh Speak..."
    StatusLabel.TextColor3 = Color3.new(1, 1, 0)
    
    local cmdSpeak = {
        [1] = {
            ["NPC"] = "Dragon Wizard",
            ["Command"] = "Speak"
        }
    }
    pcall(function() RFInteract:InvokeServer(unpack(cmdSpeak)) end)

    task.wait(0.5) -- Delay ngắn cho mượt

    -- Lệnh 2: LearnTether
    StatusLabel.Text = "⚡ Bước 2: Đang gửi lệnh LearnTether..."
    StatusLabel.TextColor3 = Color3.new(1, 0.5, 0)
    
    local cmdLearn = {
        [1] = {
            ["NPC"] = "Dragon Wizard",
            ["Command"] = "LearnTether"
        }
    }
    
    local ok, res = pcall(function() 
        return RFInteract:InvokeServer(unpack(cmdLearn)) 
    end)

    if ok then
        StatusLabel.Text = "✅ THÀNH CÔNG!\nĐã chốt xong LearnTether."
        StatusLabel.TextColor3 = Color3.new(0, 1, 0)
        warn("[Draco] Dragon Tether Success: ", res)
    else
        StatusLabel.Text = "❌ THẤT BẠI!\nLỗi: " .. tostring(res)
        StatusLabel.TextColor3 = Color3.new(1, 0, 0)
        warn("[Draco] Dragon Tether Failed")
    end
end

-- 4. NÚT BẤM TEST
local TestBtn = Instance.new("TextButton", Main)
TestBtn.Size = UDim2.new(0, 200, 0, 45); TestBtn.Position = UDim2.new(0.5, -100, 0.65, 0)
TestBtn.Text = "START LEARN TETHER"; TestBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
TestBtn.TextColor3 = Color3.new(1, 1, 1); TestBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", TestBtn)

TestBtn.MouseButton1Click:Connect(function()
    task.spawn(executeDragonTether)
end)
