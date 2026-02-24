-- ==========================================
-- STAT GUN / STAT SWORD SCRIPT
-- Remote sources:
--   Reset  : CommF_ > BlackbeardReward, "Refund", "1" + "2"
--   AddPoint: CommF_ > AddPoint, "StatName", amount
-- Tham khảo: MaruCrack_lua, Min-Vip, MinGamingNew
-- ==========================================

local RS        = game:GetService("ReplicatedStorage")
local CommF_    = RS.Remotes.CommF_
local CoreGui   = game:GetService("CoreGui")
local Player    = game.Players.LocalPlayer

-- ==========================================
-- HÀM CORE
-- ==========================================
local function ResetStat()
    -- Cần gọi cả "1" và "2" như các script tham khảo
    pcall(function() CommF_:InvokeServer("BlackbeardReward", "Refund", "1") end)
    task.wait(0.3)
    pcall(function() CommF_:InvokeServer("BlackbeardReward", "Refund", "2") end)
    task.wait(0.5)
end

local function AddPoint(statName, amount)
    pcall(function()
        CommF_:InvokeServer("AddPoint", statName, amount)
    end)
end

-- Stat Gun  : Reset → Melee 4000 → Defense 4000 → Gun 4000
local function DoStatGun()
    ResetStat()
    task.wait(0.5)
    AddPoint("Melee",   4000)
    task.wait(0.3)
    AddPoint("Defense", 4000)
    task.wait(0.3)
    AddPoint("Gun",     4000)
end

-- Stat Sword: Reset → Melee 4000 → Defense 4000 → Sword 4000
local function DoStatSword()
    ResetStat()
    task.wait(0.5)
    AddPoint("Melee",   4000)
    task.wait(0.3)
    AddPoint("Defense", 4000)
    task.wait(0.3)
    AddPoint("Sword",   4000)
end

-- ==========================================
-- UI
-- ==========================================
if CoreGui:FindFirstChild("StatToolUI") then
    CoreGui.StatToolUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name            = "StatToolUI"
ScreenGui.ResetOnSpawn    = false

-- Main Frame
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size            = UDim2.new(0, 220, 0, 130)
MainFrame.Position        = UDim2.new(0.5, -110, 0.5, -65)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.Active          = true
MainFrame.Draggable       = true
Instance.new("UICorner",  MainFrame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke",  MainFrame).Color        = Color3.fromRGB(255, 200, 0)

-- Title bar
local TitleBar = Instance.new("Frame", MainFrame)
TitleBar.Size            = UDim2.new(1, 0, 0, 32)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TitleBar.BorderSizePixel = 0
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 8)

local TitleLabel = Instance.new("TextLabel", TitleBar)
TitleLabel.Size               = UDim2.new(1, 0, 1, 0)
TitleLabel.Text               = "⚔️  Stat Tool"
TitleLabel.TextColor3         = Color3.fromRGB(255, 200, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font               = Enum.Font.GothamBold
TitleLabel.TextSize           = 14

-- Status label
local StatusLabel = Instance.new("TextLabel", MainFrame)
StatusLabel.Size               = UDim2.new(1, -16, 0, 20)
StatusLabel.Position           = UDim2.new(0, 8, 0, 38)
StatusLabel.Text               = "Sẵn sàng"
StatusLabel.TextColor3         = Color3.fromRGB(180, 180, 180)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Font               = Enum.Font.Gotham
StatusLabel.TextSize           = 12
StatusLabel.TextXAlignment     = Enum.TextXAlignment.Left

-- Helper: tạo button
local function MakeButton(parent, text, color, posY)
    local btn = Instance.new("TextButton", parent)
    btn.Size            = UDim2.new(1, -16, 0, 36)
    btn.Position        = UDim2.new(0, 8, 0, posY)
    btn.BackgroundColor3 = color
    btn.Text            = text
    btn.TextColor3      = Color3.fromRGB(255, 255, 255)
    btn.Font            = Enum.Font.GothamBold
    btn.TextSize        = 13
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

local GunBtn   = MakeButton(MainFrame, "🔫  Stat Gun",  Color3.fromRGB(30, 100, 180), 62)
local SwordBtn = MakeButton(MainFrame, "⚔️  Stat Sword", Color3.fromRGB(160, 40,  40), 104)

-- ==========================================
-- BUTTON LOGIC
-- ==========================================
local isBusy = false

local function SetBusy(state, msg)
    isBusy            = state
    StatusLabel.Text  = msg
    GunBtn.TextColor3   = state and Color3.fromRGB(120,120,120) or Color3.fromRGB(255,255,255)
    SwordBtn.TextColor3 = state and Color3.fromRGB(120,120,120) or Color3.fromRGB(255,255,255)
end

GunBtn.MouseButton1Click:Connect(function()
    if isBusy then return end
    task.spawn(function()
        SetBusy(true, "Đang Reset Stat...")
        GunBtn.Text = "Đang xử lý..."
        DoStatGun()
        GunBtn.Text = "🔫  Stat Gun"
        SetBusy(false, "✅ Stat Gun xong!")
        task.wait(3)
        if StatusLabel.Text == "✅ Stat Gun xong!" then
            StatusLabel.Text = "Sẵn sàng"
        end
    end)
end)

SwordBtn.MouseButton1Click:Connect(function()
    if isBusy then return end
    task.spawn(function()
        SetBusy(true, "Đang Reset Stat...")
        SwordBtn.Text = "Đang xử lý..."
        DoStatSword()
        SwordBtn.Text = "⚔️  Stat Sword"
        SetBusy(false, "✅ Stat Sword xong!")
        task.wait(3)
        if StatusLabel.Text == "✅ Stat Sword xong!" then
            StatusLabel.Text = "Sẵn sàng"
        end
    end)
end)

-- Hover effect
for _, btn in pairs({GunBtn, SwordBtn}) do
    local baseColor = btn.BackgroundColor3
    btn.MouseEnter:Connect(function()
        if not isBusy then
            btn.BackgroundColor3 = Color3.fromRGB(
                math.min(baseColor.R * 255 + 25, 255),
                math.min(baseColor.G * 255 + 25, 255),
                math.min(baseColor.B * 255 + 25, 255)
            )
        end
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = baseColor
    end)
end
