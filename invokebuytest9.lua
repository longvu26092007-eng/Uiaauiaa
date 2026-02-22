-- =============================================================
-- FISHERMAN SILENT CRAFT (NO-HANG VERSION)
-- Tự động hiện UI kể cả khi không tìm thấy Remote
-- =============================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local lp = Players.LocalPlayer

-- 1. TẠO UI NGAY LẬP TỨC (KHÔNG ĐỢI BẤT CỨ AI)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FishermanFixSystem"
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = lp.PlayerGui end

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 320, 0, 220)
MainFrame.Position = UDim2.new(0.5, -160, 0.4, -110)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "FISHERMAN RE-FIX"
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.TextColor3 = Color3.new(1, 1, 1)

local StatusLabel = Instance.new("TextLabel", MainFrame)
StatusLabel.Size = UDim2.new(1, -20, 0, 100)
StatusLabel.Position = UDim2.new(0, 10, 0, 40)
StatusLabel.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
StatusLabel.Text = "Đang kiểm tra hệ thống..."
StatusLabel.TextColor3 = Color3.new(1, 1, 1)
StatusLabel.TextWrapped = true

-- 2. HÀM KIỂM TRA REMOTE THÔNG MINH (KHÔNG DÙNG WAITFORCHILD)
local function CheckSystem()
    local rf = ReplicatedStorage:FindFirstChild("RF")
    if not rf then
        StatusLabel.Text = "❌ LỖI: Không tìm thấy thư mục 'RF' trong ReplicatedStorage.\n\nGame này có thể đã đổi cấu trúc Remote."
        StatusLabel.TextColor3 = Color3.new(1, 0, 0)
        return false
    end
    
    local craft = rf:FindFirstChild("Craft")
    if not craft then
        StatusLabel.Text = "❌ LỖI: Tìm thấy RF nhưng không có Remote 'Craft'."
        StatusLabel.TextColor3 = Color3.new(1, 0, 0)
        return false
    end

    StatusLabel.Text = "✅ HỆ THỐNG SẴN SÀNG!\nĐã tìm thấy Remote Craft."
    StatusLabel.TextColor3 = Color3.new(0, 1, 0)
    return true
end

-- 3. NÚT TEST
local TestBtn = Instance.new("TextButton", MainFrame)
TestBtn.Size = UDim2.new(0.8, 0, 0, 40)
TestBtn.Position = UDim2.new(0.1, 0, 0.75, 0)
TestBtn.Text = "BẤM ĐỂ THỬ CRAFT"
TestBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
TestBtn.TextColor3 = Color3.new(1, 1, 1)

TestBtn.MouseButton1Click:Connect(function()
    local rf = ReplicatedStorage:FindFirstChild("RF")
    if rf then
        local jobs = rf:FindFirstChild("JobsRemoteFunction")
        local craft = rf:FindFirstChild("Craft")
        
        if jobs and craft then
            StatusLabel.Text = "Đang gửi lệnh..."
            pcall(function() jobs:InvokeServer("FishingNPC", "Bait", "Check", "Fisherman") end)
            task.wait(0.2)
            pcall(function() craft:InvokeServer("Check", "Basic Bait") end)
            task.wait(0.2)
            local s, r = pcall(function() return craft:InvokeServer("Craft", "Basic Bait", nil) end)
            StatusLabel.Text = s and "Thành công!" or "Lỗi: "..tostring(r)
        end
    else
        StatusLabel.Text = "Không có Remote để gửi!"
    end
end)

CheckSystem()
