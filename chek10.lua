-- =============================================================
-- DRACO ANTI-STALKER (INDEPENDENT - AUTO DESTRUCT)
-- Cơ chế: Đợi 5s -> Quét 3 lần (mỗi lần cách 5s) -> Không thấy = Hủy script
-- =============================================================

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

-- 1. DANH SÁCH ĐEN CỦA VŨ
local Blacklist = {
    "AshleeCrawford426", "EmilyHazel62", "JasminAyers92717", "JohnnyHuynh857",
    "SherryCarroll491", "MadelinePatton378", "AzaleaSchmidt2", "StacyMagnolia55519",
    "LatashaBarber882", "PennyWade86503", "MackenzieSchultz1", "LindseyRosales1",
    "KathrynCampos6603", "MadisonGiles6618", "AlisonMerritt2541", "RoseMcfarland5",
    "MariahBradford76", "KristinOdom58", "NatalieWalsh8016", "LarryKeller10"
}

-- 2. LINK SCRIPT SERVER HOP CỦA VŨ
local HopScriptURL = "https://raw.githubusercontent.com/longvu26092007-eng/Uiaauiaa/refs/heads/main/hopa5.lua"

-- 3. GIAO DIỆN THÔNG BÁO
if CoreGui:FindFirstChild("AntiStalkerUI") then CoreGui.AntiStalkerUI:Destroy() end
local ScreenGui = Instance.new("ScreenGui", CoreGui); ScreenGui.Name = "AntiStalkerUI"
local MiniFrame = Instance.new("Frame", ScreenGui)
MiniFrame.Size = UDim2.new(0, 200, 0, 40); MiniFrame.Position = UDim2.new(1, -210, 1, -50)
MiniFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UIStroke", MiniFrame).Color = Color3.fromRGB(255, 0, 0)
Instance.new("UICorner", MiniFrame)

local Status = Instance.new("TextLabel", MiniFrame)
Status.Size = UDim2.new(1, 0, 1, 0); Status.BackgroundTransparency = 1
Status.Text = "🛡️ Chờ 5s khởi động..."; Status.TextColor3 = Color3.new(1, 1, 1)
Status.Font = Enum.Font.GothamBold; Status.TextSize = 11

-- Biến quản lý sự kiện PlayerAdded để có thể ngắt kết nối (Disconnect)
local PlayerAddedConnection

-- 4. HÀM THỰC THI HOP
local function DoHop()
    Status.Text = "🚨 BLACKLIST! ĐANG HOP..."
    Status.TextColor3 = Color3.new(1, 0, 0)
    task.wait(1)
    pcall(function()
        loadstring(game:HttpGet(HopScriptURL))()
    end)
end

-- 5. HÀM QUÉT
local function CheckPlayers()
    for _, p in pairs(Players:GetPlayers()) do
        for _, name in pairs(Blacklist) do
            if p.Name == name then return true end
        end
    end
    return false
end

-- 6. HÀM HỦY SCRIPT (Tự hủy sạch sẽ)
local function DestructScript()
    Status.Text = "✅ An toàn! Tự hủy script..."
    Status.TextColor3 = Color3.new(0, 1, 0)
    
    if PlayerAddedConnection then
        PlayerAddedConnection:Disconnect() -- Ngừng theo dõi người chơi mới
    end
    
    task.wait(2)
    ScreenGui:Destroy() -- Xóa UI
    script:Destroy() -- Hủy script (nếu chạy từ file)
end

-- 7. LUỒNG TỰ ĐỘNG QUÉT CHÍNH
task.spawn(function()
    -- Lần đầu vào game: Delay 5 giây
    task.wait(9)
    
    for i = 1, 3 do
        Status.Text = "🔍 Quét Lần " .. i .. "/3 (Nghỉ 5s)..."
        
        if CheckPlayers() then
            DoHop()
            return -- Dừng luồng nếu đã hop
        end
        
        -- Nếu chưa phải lần cuối thì đợi 5 giây mới quét tiếp
        if i < 3 then 
            task.wait(5) 
        end
    end
    
    -- Sau 3 lần quét không thấy ai -> Tự hủy
    DestructScript()
end)

-- 8. THEO DÕI NẾU CÓ THẰNG NÀO JOIN TRONG LÚC ĐANG QUÉT
PlayerAddedConnection = Players.PlayerAdded:Connect(function(p)
    for _, name in pairs(Blacklist) do
        if p.Name == name then DoHop() end
    end
end)
