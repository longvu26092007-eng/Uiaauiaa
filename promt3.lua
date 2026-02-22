-- ======================================================================
-- REMOTE SPY V10 - GIAO DIỆN TRÊN MÀN HÌNH (ANTI-FLOOD & FILTER)
-- ======================================================================

local ScreenGui = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local Scroll = Instance.new("ScrollingFrame")
local UIList = Instance.new("UIListLayout")
local ControlFrame = Instance.new("Frame")
local PauseBtn = Instance.new("TextButton")
local ClearBtn = Instance.new("TextButton")

-- Cấu hình UI
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Name = "FishermanSpyV10"

Main.Parent = ScreenGui
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0, 50, 0.5, -150)
Main.Size = UDim2.new(0, 400, 0, 300)
Main.Active = true
Main.Draggable = true

Title.Parent = Main
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Title.Text = "FISHERMAN REMOTE SPY - V10"
Title.TextColor3 = Color3.new(1, 1, 1)

Scroll.Parent = Main
Scroll.Position = UDim2.new(0, 5, 0, 35)
Scroll.Size = UDim2.new(1, -10, 1, -80)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 10, 0)
UIList.Parent = Scroll
UIList.Padding = UDim.new(0, 5)

ControlFrame.Parent = Main
ControlFrame.Position = UDim2.new(0, 0, 1, -40)
ControlFrame.Size = UDim2.new(1, 0, 0, 40)
ControlFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

-- Logic biến hệ thống
local isPaused = false

PauseBtn.Parent = ControlFrame
PauseBtn.Size = UDim2.new(0.5, -10, 0.8, 0)
PauseBtn.Position = UDim2.new(0, 5, 0.1, 0)
PauseBtn.Text = "PAUSE LOGGING"
PauseBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
PauseBtn.TextColor3 = Color3.new(1, 1, 1)

ClearBtn.Parent = ControlFrame
ClearBtn.Size = UDim2.new(0.5, -10, 0.8, 0)
ClearBtn.Position = UDim2.new(0.5, 5, 0.1, 0)
ClearBtn.Text = "CLEAR LOGS"
ClearBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
ClearBtn.TextColor3 = Color3.new(1, 1, 1)

-- Hàm xử lý Log
local function CreateLogEntry(method, remoteName, args)
    if isPaused then return end
    
    local argTbl = {}
    for i, v in pairs(args) do
        table.insert(argTbl, type(v) == "string" and '"'..v..'"' or tostring(v))
    end
    local argString = table.concat(argTbl, ", ")
    
    -- Lọc chỉ hiện Fisherman hoặc Bait
    if not string.find(argString:lower(), "fisherman") and not string.find(argString:lower(), "bait") then
        return
    end

    local Log = Instance.new("TextBox")
    Log.Parent = Scroll
    Log.Size = UDim2.new(1, -10, 0, 50)
    Log.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Log.TextColor3 = Color3.fromRGB(0, 255, 150)
    Log.TextSize = 12
    Log.ClearTextOnFocus = false
    Log.TextWrapped = true
    Log.TextXAlignment = Enum.TextXAlignment.Left
    
    local fullCmd = "CommF_:InvokeServer(" .. argString .. ")"
    Log.Text = "[" .. method .. "] " .. remoteName .. "\nArgs: " .. argString
    
    -- Tự động cuộn xuống
    Scroll.CanvasPosition = Vector2.new(0, UIList.AbsoluteContentSize.Y)
end

-- HOOK NAME CALL
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if (method == "InvokeServer" or method == "FireServer") then
        task.spawn(function()
            CreateLogEntry(method, self.Name, args)
        end)
    end
    return old(self, ...)
end)

setreadonly(mt, true)

-- Nút điều khiển
PauseBtn.MouseButton1Click:Connect(function()
    isPaused = not isPaused
    PauseBtn.Text = isPaused and "RESUME LOGGING" or "PAUSE LOGGING"
    PauseBtn.BackgroundColor3 = isPaused and Color3.fromRGB(200, 100, 0) or Color3.fromRGB(0, 100, 200)
end)

ClearBtn.MouseButton1Click:Connect(function()
    for _, v in pairs(Scroll:GetChildren()) do
        if v:IsA("TextBox") then v:Destroy() end
    end
end)

print("--- V10 ĐÃ CHẠY - HÃY ĐI CRAFT MỒI ---")
