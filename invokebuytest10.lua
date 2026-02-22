-- =============================================================
-- FISHERMAN SILENT CRAFT V12 - AUTO SCAN REMOTE
-- Tự động tìm kiếm Remote trong toàn bộ ReplicatedStorage
-- =============================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local lp = Players.LocalPlayer

-- 1. TẠO UI (Luôn hiện để báo cáo tình hình)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FishermanScanner"
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = lp.PlayerGui end

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 300, 0, 180)
Main.Position = UDim2.new(0.5, -150, 0.4, -90)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

local StatusLabel = Instance.new("TextLabel", Main)
StatusLabel.Size = UDim2.new(1, -20, 0, 80)
StatusLabel.Position = UDim2.new(0, 10, 0, 40)
StatusLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
StatusLabel.TextColor3 = Color3.new(1, 1, 1)
StatusLabel.Text = "Đang quét tìm Remote..."
StatusLabel.TextWrapped = true

-- 2. HÀM TÌM REMOTE XUYÊN THƯ MỤC
local function FindRemote(name)
    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
        if v.Name == name and (v:IsA("RemoteFunction") or v:IsA("RemoteEvent")) then
            return v
        end
    end
    return nil
end

-- 3. LOGIC CHÍNH
local function ExecuteCraft()
    local JobsRemote = FindRemote("JobsRemoteFunction")
    local CraftRemote = FindRemote("Craft")

    if not JobsRemote or not CraftRemote then
        StatusLabel.Text = "❌ Vẫn không tìm thấy Remote! Game có thể đã ẩn hoặc đổi tên."
        StatusLabel.TextColor3 = Color3.new(1, 0, 0)
        return
    end

    StatusLabel.Text = "✅ Đã thấy Remote! Đang gửi lệnh..."
    StatusLabel.TextColor3 = Color3.new(0, 1, 0)

    task.spawn(function()
        -- Gửi chuỗi lệnh như Log bạn bắt được
        pcall(function() JobsRemote:InvokeServer("FishingNPC", "Bait", "Check", "Fisherman") end)
        task.wait(0.2)
        pcall(function() CraftRemote:InvokeServer("Check", "Basic Bait") end)
        task.wait(0.2)
        local s, r = pcall(function() return CraftRemote:InvokeServer("Craft", "Basic Bait", nil) end)
        
        if s then
            StatusLabel.Text = "🎉 THÀNH CÔNG! Đã gửi lệnh Craft mồi."
        else
            StatusLabel.Text = "Lỗi Server: " .. tostring(r)
        end
    end)
end

-- 4. NÚT KÍCH HOẠT
local Btn = Instance.new("TextButton", Main)
Btn.Size = UDim2.new(0.8, 0, 0, 40)
Btn.Position = UDim2.new(0.1, 0, 0.7, 0)
Btn.Text = "START SILENT CRAFT"
Btn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
Btn.TextColor3 = Color3.new(1, 1, 1)
Btn.MouseButton1Click:Connect(ExecuteCraft)

-- Nút đóng
local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -30, 0, 0)
Close.Text = "X"
Close.TextColor3 = Color3.new(1, 0, 0)
Close.BackgroundTransparency = 1
Close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
