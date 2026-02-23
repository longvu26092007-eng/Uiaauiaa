-- =============================================================
-- DRACO HUB - DRAGON WIZARD (ADVANCED INVOKER)
-- Style: Sử dụng cấu trúc Table v371 chuẩn từ source của Vũ
-- =============================================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

-- 1. KHAI BÁO REMOTE (Dùng ngoặc vuông để tránh lỗi /)
local NetFolder = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net")
local RFInteract = NetFolder:WaitForChild("RF/InteractDragonQuest")

-- 2. GIAO DIỆN MONITOR
if CoreGui:FindFirstChild("DragonRaceTest") then CoreGui.DragonRaceTest:Destroy() end
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "DragonRaceTest"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 280, 0, 150)
Main.Position = UDim2.new(0.5, -140, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(255, 200, 0)
Instance.new("UICorner", Main)

local StatusLabel = Instance.new("TextLabel", Main)
StatusLabel.Size = UDim2.new(1, -20, 0, 60); StatusLabel.Position = UDim2.new(0, 10, 0, 10)
StatusLabel.Text = "Hệ thống: Sẵn sàng...\nNPC: Dragon Wizard | Cmd: DragonRace"; StatusLabel.TextColor3 = Color3.new(1, 1, 1)
StatusLabel.BackgroundTransparency = 1; StatusLabel.Font = Enum.Font.GothamBold; StatusLabel.TextSize = 13; StatusLabel.TextWrapped = true

-- 3. HÀM THỰC THI (SỬ DỤNG CẤU TRÚC V371 CỦA VŨ)
local function executeDragonRace()
    StatusLabel.Text = "🚀 Đang gửi lệnh DragonRace..."
    StatusLabel.TextColor3 = Color3.new(255/255, 200/255, 0)

    -- Cấu trúc bảng y hệt cái Lua cậu gửi
    local v371 = {
        [1] = {
            ["NPC"] = "Dragon Wizard",
            ["Command"] = "DragonRace" -- Cậu có thể đổi thành DragonTether nếu cần
        }
    }

    local ok, res = pcall(function()
        -- unpack(v371) sẽ giải nén table thành tham số cho InvokeServer
        return RFInteract:InvokeServer(unpack(v371))
    end)

    if ok then
        StatusLabel.Text = "✅ THÀNH CÔNG!\nServer phản hồi: " .. tostring(res)
        StatusLabel.TextColor3 = Color3.new(0, 1, 0)
        warn("[DragonRace] Sent successfully")
    else
        StatusLabel.Text = "❌ THẤT BẠI!\nLỗi: " .. tostring(res)
        StatusLabel.TextColor3 = Color3.new(1, 0, 0)
        warn("[DragonRace] Failed: " .. tostring(res))
    end
end

-- 4. NÚT BẤM TEST
local TestBtn = Instance.new("TextButton", Main)
TestBtn.Size = UDim2.new(0, 200, 0, 40); TestBtn.Position = UDim2.new(0.5, -100, 0.65, 0)
TestBtn.Text = "START DRAGON RACE"; TestBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
TestBtn.TextColor3 = Color3.new(1, 1, 1); TestBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", TestBtn)

TestBtn.MouseButton1Click:Connect(function()
    task.spawn(executeDragonRace)
end)
