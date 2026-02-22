-- ======================================================================
-- CHƯƠNG TRÌNH BẮT LỆNH REMOTE (REMOTE SPY) CHUYÊN DỤNG
-- Dùng để tìm chính xác tham số cho tính năng Silent Craft
-- ======================================================================

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ScrollingFrame = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")

-- 1. GIAO DIỆN HIỂN THỊ
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Name = "RemoteSpy_Fisherman"

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Position = UDim2.new(0, 10, 0.5, -150)
MainFrame.Size = UDim2.new(0, 350, 0, 300)
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 25)
Title.Text = "REMOTE DEBUGGER (FISHERMAN)"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

ScrollingFrame.Parent = MainFrame
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.Position = UDim2.new(0, 5, 0, 30)
ScrollingFrame.Size = UDim2.new(1, -10, 1, -40)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 5, 0)
ScrollingFrame.ScrollBarThickness = 4

UIListLayout.Parent = ScrollingFrame
UIListLayout.Padding = UDim.new(0, 5)

-- 2. HÀM GHI LOG
local function LogRemote(remote, method, args)
    local argText = ""
    for i, v in pairs(args) do
        local val = tostring(v)
        if type(v) == "string" then val = '"' .. val .. '"' end
        argText = argText .. val .. (i < #args and ", " or "")
    end

    local logLabel = Instance.new("TextBox")
    logLabel.Size = UDim2.new(1, 0, 0, 40)
    logLabel.BackgroundTransparency = 0.8
    logLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    logLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
    logLabel.TextSize = 10
    logLabel.TextWrapped = true
    logLabel.ClearTextOnFocus = false
    logLabel.Text = string.format("[%s] %s\nArgs: %s", method, remote.Name, argText)
    logLabel.Parent = ScrollingFrame
    
    -- Tự động xuống dòng cuối
    ScrollingFrame.CanvasPosition = Vector2.new(0, 9999)
end

-- 3. HOOK HỆ THỐNG (TRÁI TIM CỦA SCRIPT)
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    -- Chỉ bắt các lệnh liên quan đến CommF_ (Remote chính trong Blox Fruit)
    if (method == "InvokeServer" or method == "FireServer") and self.Name == "CommF_" then
        task.spawn(function()
            LogRemote(self, method, args)
        end)
    end

    return oldNamecall(self, ...)
end)

setreadonly(mt, true)

-- Nút xóa log
local ClearBtn = Instance.new("TextButton", MainFrame)
ClearBtn.Size = UDim2.new(0, 50, 0, 20)
ClearBtn.Position = UDim2.new(1, -55, 0, 2)
ClearBtn.Text = "Clear"
ClearBtn.BackgroundColor3 = Color3.new(0.5, 0, 0)
ClearBtn.TextColor3 = Color3.new(1, 1, 1)
ClearBtn.MouseButton1Click:Connect(function()
    for _, v in pairs(ScrollingFrame:GetChildren()) do
        if v:IsA("TextBox") then v:Destroy() end
    end
end)

print("--- REMOTE SPY ĐÃ SẴN SÀNG ---")
