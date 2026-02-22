-- =============================================================
-- FISHERMAN SILENT CRAFT SYSTEM (OFFICIAL FINAL)
-- Dựa trên dữ liệu Log: RF/JobsRemoteFunction & RF/Craft
-- =============================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local lp = Players.LocalPlayer

-- Khai báo Remote chính xác từ Log của bạn
local JobsRemote = ReplicatedStorage:WaitForChild("RF"):WaitForChild("JobsRemoteFunction")
local CraftRemote = ReplicatedStorage:WaitForChild("RF"):WaitForChild("Craft")

-- 1. KHỞI TẠO UI (Thiết kế theo chuẩn Hub của bạn)
local ScreenGui = Instance.new("ScreenGui", lp.PlayerGui)
ScreenGui.Name = "FishermanDebugSystem"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 320, 0, 220)
MainFrame.Position = UDim2.new(0.5, -160, 0.4, -110)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.Text = "FISHERMAN DEBUGGER"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.SourceSansBold

-- Nhãn báo Status (Sẽ cập nhật khi bấm nút)
local StatusLabel = Instance.new("TextLabel", MainFrame)
StatusLabel.Size = UDim2.new(1, -20, 0, 80)
StatusLabel.Position = UDim2.new(0, 10, 0, 45)
StatusLabel.Text = "Status: Đang chờ lệnh..."
StatusLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
StatusLabel.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
StatusLabel.TextWrapped = true
StatusLabel.TextSize = 13
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.TextYAlignment = Enum.TextYAlignment.Top

-- 2. HÀM THỰC THI & GHI LOG
local function ExecuteTestCraft()
    local function UpdateLog(msg, color)
        StatusLabel.Text = "Status: " .. msg
        if color then StatusLabel.TextColor3 = color end
        print("[Fisherman-Debug]: " .. msg) -- In ra F9 để đối chiếu
    end

    task.spawn(function()
        -- Bước 1: Gửi lệnh hội thoại NPC
        UpdateLog("Đang gửi JobsRemoteFunction (Check Fisherman)...", Color3.new(1, 1, 0))
        local s1, r1 = pcall(function()
            return JobsRemote:InvokeServer("FishingNPC", "Bait", "Check", "Fisherman")
        end)
        task.wait(0.3)

        -- Bước 2: Gửi lệnh kiểm tra mồi
        UpdateLog("Đang gửi Craft Remote (Check Basic Bait)...", Color3.new(1, 0.6, 0))
        local s2, r2 = pcall(function()
            return CraftRemote:InvokeServer("Check", "Basic Bait")
        end)
        task.wait(0.3)

        -- Bước 3: Gửi lệnh Craft chốt
        UpdateLog("Đang gửi Craft Remote (Action: Craft)...", Color3.new(1, 0.3, 1))
        local s3, r3 = pcall(function()
            return CraftRemote:InvokeServer("Craft", "Basic Bait", nil)
        end)

        -- Kết quả cuối cùng
        if s3 then
            UpdateLog("Thành công! Đã gửi lệnh Craft cuối cùng.\nCheck F9 để xem phản hồi từ Server.", Color3.new(0, 1, 0))
        else
            UpdateLog("Lỗi thực thi: " .. tostring(r3), Color3.new(1, 0, 0))
        end
    end)
end

-- 3. NÚT BẤM TEST
local TestBtn = Instance.new("TextButton", MainFrame)
TestBtn.Size = UDim2.new(0.8, 0, 0, 45)
TestBtn.Position = UDim2.new(0.1, 0, 0.7, 0)
TestBtn.Text = "START SILENT CRAFT TEST"
TestBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
TestBtn.TextColor3 = Color3.new(1, 1, 1)
TestBtn.Font = Enum.Font.SourceSansBold

local Corner = Instance.new("UICorner", TestBtn)
Corner.CornerRadius = UDim.new(0, 8)

TestBtn.MouseButton1Click:Connect(function()
    ExecuteTestCraft()
end)

-- Nút đóng UI
local Close = Instance.new("TextButton", MainFrame)
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -30, 0, 0)
Close.Text = "X"
Close.BackgroundTransparency = 1
Close.TextColor3 = Color3.new(1, 0, 0)
Close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
