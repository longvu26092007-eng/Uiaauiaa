-- ======================================================================
-- REMOTE DEBUGGER V14.0 - CHUYÊN TRỊ HYDRA & DRACO
-- Tính năng: Bắt lệnh -> Chỉnh sửa -> Chạy thử (Run)
-- ======================================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HydraDebugger"
ScreenGui.Parent = game:GetService("CoreGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 400, 0, 300)
Main.Position = UDim2.new(0.5, -200, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "🛡️ HYDRA REMOTE DEBUGGER"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
Title.Parent = Main

local LogScroll = Instance.new("ScrollingFrame")
LogScroll.Size = UDim2.new(1, -20, 1, -80)
LogScroll.Position = UDim2.new(0, 10, 0, 40)
LogScroll.BackgroundTransparency = 1
LogScroll.CanvasSize = UDim2.new(0, 0, 2, 0)
LogScroll.Parent = Main

local UIList = Instance.new("UIListLayout")
UIList.Padding = UDim.new(0, 5)
UIList.Parent = LogScroll

-- Hàm gửi lệnh Debug (Dành cho Vũ thử nghiệm)
local function RunDebug(cmdName)
    local Remote = workspace:WaitForChild("HydraIslandClient"):WaitForChild("RemoteFunction")
    warn("🚀 Đang gửi lệnh Debug: " .. cmdName)
    local result = Remote:InvokeServer(cmdName)
    print("📊 Phản hồi từ Server cho ["..cmdName.."]: ", result)
end

-- Tạo nút bấm Debug nhanh cho các lệnh Vũ tìm thấy
local function CreateDebugButton(name, cmd)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -10, 0, 35)
    Btn.Text = "RUN: " .. name
    Btn.BackgroundColor3 = Color3.fromRGB(60, 120, 60)
    Btn.TextColor3 = Color3.new(1, 1, 1)
    Btn.Font = Enum.Font.GothamBold
    Btn.Parent = LogScroll
    
    Btn.MouseButton1Click:Connect(function()
        RunDebug(cmd)
    end)
end

-- Khởi tạo các nút từ Log của Vũ
CreateDebugButton("Interacted (Tương tác vùng)", "Interacted")
CreateDebugButton("Progress (Check tiến độ)", "progress")

-- Hệ thống Spy tự động để bắt thêm lệnh mới
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if self.Name == "RemoteFunction" and self.Parent.Name == "HydraIslandClient" then
        print("🔍 Debugger bắt được lệnh mới: ", args[1])
    end
    
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

print("✅ Hydra Debugger đã sẵn sàng! Chúc Vũ debug thành công.")
