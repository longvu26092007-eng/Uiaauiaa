-- =============================================================
-- DRACO HUB - NPC DATA SCANNER (F9 DEBUG VERSION)
-- Mục tiêu: Quét phản hồi từ Dragon Wizard để check LearnStatus
-- =============================================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

-- 1. ĐỊNH NGHĨA REMOTE
local Net = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net")
local RF = Net["RF/InteractDragonQuest"]

-- 2. GIAO DIỆN CHECK NHANH
if CoreGui:FindFirstChild("DracoScanner") then CoreGui.DracoScanner:Destroy() end
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "DracoScanner"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 350, 0, 100)
Main.Position = UDim2.new(0.5, -175, 0.1, 0) -- Hiện ở phía trên màn hình
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(255, 200, 0)
Instance.new("UICorner", Main)

local StatusTxt = Instance.new("TextLabel", Main)
StatusTxt.Size = UDim2.new(1, -20, 1, -20); StatusTxt.Position = UDim2.new(0, 10, 0, 10)
StatusTxt.Text = "Nhấn F9 để xem log chi tiết\nĐang chờ quét..."; StatusTxt.TextColor3 = Color3.new(1, 1, 1)
StatusTxt.BackgroundTransparency = 1; StatusTxt.Font = Enum.Font.GothamBold; StatusTxt.TextSize = 13; StatusTxt.TextWrapped = true

-- 3. HÀM QUÉT DỮ LIỆU
local function ScanNPC()
    print("--------------------------------------------------")
    print("🚀 [DRACO SCANNER] ĐANG GỬI REQUEST KIỂM TRA...")
    StatusTxt.Text = "⏳ Đang quét dữ liệu từ Server..."
    StatusTxt.TextColor3 = Color3.new(1, 1, 0)

    -- Gửi lệnh Speak ngầm
    local ok, res = pcall(function()
        return RF:InvokeServer({[1] = {NPC = "Dragon Wizard", Command = "Speak"}})
    end)

    if ok then
        -- IN RA F9 (CONSOLE) ĐỂ VŨ XEM
        warn("🔥 PHẢN HỒI TỪ SERVER (DỮ LIỆU GỐC):")
        print(res) 
        
        if type(res) == "table" then
            for i, v in pairs(res) do
                print("Field: " .. tostring(i) .. " | Value: " .. tostring(v))
            end
        end

        -- PHÂN TÍCH TỪ KHÓA ĐỂ HIỆN LÊN STATUS UI
        local resStr = tostring(res):lower()
        if resStr:find("learned") or resStr:find("already") or res == true then
            StatusTxt.Text = "Trạng thái: ✅ ĐÃ LEARN TETHER\n(Xem chi tiết trong F9)"
            StatusTxt.TextColor3 = Color3.new(0, 1, 0)
        else
            StatusTxt.Text = "Trạng thái: ❌ CHƯA LEARN HOẶC DỮ LIỆU MỚI\n(Xem chi tiết trong F9)"
            StatusTxt.TextColor3 = Color3.new(1, 0, 0)
        end
        warn("✅ ĐÃ QUÉT XONG!")
    else
        print("❌ LỖI KHI GỌI REMOTE: " .. tostring(res))
        StatusTxt.Text = "Lỗi: Server không phản hồi.\nKiểm tra lại tên Remote/NPC."
        StatusTxt.TextColor3 = Color3.new(1, 0, 0)
    end
    print("--------------------------------------------------")
end

-- 4. NÚT QUÉT NHANH
local ScanBtn = Instance.new("TextButton", Main)
ScanBtn.Size = UDim2.new(0, 100, 0, 25); ScanBtn.Position = UDim2.new(1, -110, 1, -30)
ScanBtn.Text = "RE-SCAN"; ScanBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ScanBtn.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", ScanBtn)

ScanBtn.MouseButton1Click:Connect(ScanNPC)

-- Chạy quét luôn khi vừa dán script
task.spawn(ScanNPC)
