-- =============================================================
-- DRACO HUB - DRAGON WIZARD (STATUS CHECKER & LEARN)
-- Cơ chế: Check trạng thái qua phản hồi từ Speak
-- Fix lỗi: Table Index Nil bằng cách bọc pcall và WaitForChild
-- =============================================================

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local lp = Players.LocalPlayer

-- 1. CẤU HÌNH TỌA ĐỘ
local TargetNPC = CFrame.new(5773.936035, 1209.442871, 809.224548)
local SPEED = 240

-- 2. GIAO DIỆN
if CoreGui:FindFirstChild("DracoWizardCheck") then CoreGui.DracoWizardCheck:Destroy() end
local ScreenGui = Instance.new("ScreenGui", CoreGui); ScreenGui.Name = "DracoWizardCheck"
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 300, 0, 180); Main.Position = UDim2.new(0.5, -150, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Main.Active = true; Main.Draggable = true
Instance.new("UIStroke", Main).Color = Color3.fromRGB(255, 200, 0)
Instance.new("UICorner", Main)

local LearnLabel = Instance.new("TextLabel", Main)
LearnLabel.Size = UDim2.new(1, -20, 0, 40); LearnLabel.Position = UDim2.new(0, 10, 0, 10)
LearnLabel.Text = "Dragon Tether: ĐANG CHECK..."; LearnLabel.TextColor3 = Color3.new(1, 1, 0)
LearnLabel.BackgroundTransparency = 1; LearnLabel.Font = Enum.Font.GothamBold; LearnLabel.TextSize = 14

local StatusLabel = Instance.new("TextLabel", Main)
StatusLabel.Size = UDim2.new(1, -20, 0, 50); StatusLabel.Position = UDim2.new(0, 10, 0, 50)
StatusLabel.Text = "Hệ thống: Chờ quét..."; StatusLabel.TextColor3 = Color3.new(1, 1, 1)
StatusLabel.BackgroundTransparency = 1; StatusLabel.Font = Enum.Font.Gotham; StatusLabel.TextSize = 12; StatusLabel.TextWrapped = true

-- 3. HÀM GỌI REMOTE AN TOÀN (CHỐNG NIL)
local function SafeInvoke(cmd)
    local ok, Net = pcall(function() return ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net") end)
    if not ok or not Net then return nil, "Không tìm thấy folder Net" end
    
    -- Dùng WaitForChild cho Remote có tên chứa ký tự đặc biệt /
    local RF = Net:WaitForChild("RF/InteractDragonQuest", 5)
    if not RF then return nil, "Không tìm thấy Remote" end

    local v371 = {[1] = {NPC = "Dragon Wizard", Command = cmd}}
    return pcall(function() return RF:InvokeServer(unpack(v371)) end)
end

-- 4. HÀM CHECK STATUS (Dựa trên phản hồi Speak)
local function UpdateStatus()
    local ok, res = SafeInvoke("Speak")
    if ok then
        local data = tostring(res):lower()
        -- Nếu đã học, Server thường trả về true hoặc text thông báo đã sở hữu
        if data:find("already") or data:find("learned") or res == true then
            LearnLabel.Text = "Dragon Tether: ✅ ĐÃ SỞ HỮU"
            LearnLabel.TextColor3 = Color3.new(0, 1, 0)
            return true
        else
            LearnLabel.Text = "Dragon Tether: ❌ CHƯA HỌC"
            LearnLabel.TextColor3 = Color3.new(1, 0, 0)
            return false
        end
    else
        LearnLabel.Text = "Dragon Tether: ⚠️ LỖI REMOTE"
        return false
    end
end

-- 5. TWEEN & LEARN (PHẦN CỦA VŨ)
local function startLearnProcess()
    StatusLabel.Text = "⚡ Đang check trạng thái..."
    if UpdateStatus() then
        StatusLabel.Text = "Thông báo: Bạn đã học rồi, không cần bay!"
        return
    end

    StatusLabel.Text = "🚀 Đang bay đến Dragon Wizard..."
    -- Gọi toposition của cậu (giữ nguyên logic gốc)
    local char = lp.Character or lp.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local root = char:FindFirstChild("Root") or Instance.new("Part", char)
    root.Name = "Root"; root.Size = Vector3.new(20,0.5,20); root.Anchored = true; root.Transparency = 1; root.CanCollide = false
    
    local distance = (TargetNPC.Position - hrp.Position).Magnitude
    local tween = TweenService:Create(root, TweenInfo.new(distance/SPEED, Enum.EasingStyle.Linear), {CFrame = TargetNPC})
    
    local running = true
    task.spawn(function() while running do task.wait(); pcall(function() hrp.CFrame = root.CFrame end) end end)
    
    tween:Play()
    tween.Completed:Connect(function()
        running = false
        task.wait(0.3)
        StatusLabel.Text = "⚡ Đang gửi lệnh LearnTether..."
        SafeInvoke("Speak") -- Speak mồi
        task.wait(0.5)
        local ok, res = SafeInvoke("LearnTether")
        if ok then 
            StatusLabel.Text = "✅ Đã gửi lệnh Learn thành công!"
            UpdateStatus() -- Cập nhật lại UI
        else 
            StatusLabel.Text = "❌ Lỗi: " .. tostring(res)
        end
    end)
end

-- 6. NÚT BẤM
local ActionBtn = Instance.new("TextButton", Main)
ActionBtn.Size = UDim2.new(0, 220, 0, 45); ActionBtn.Position = UDim2.new(0.5, -110, 0.65, 0)
ActionBtn.Text = "START CHECK & LEARN"; ActionBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
ActionBtn.TextColor3 = Color3.new(1, 1, 1); ActionBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", ActionBtn)

ActionBtn.MouseButton1Click:Connect(function()
    task.spawn(startLearnProcess)
end)

-- Quét ngay khi chạy script
task.spawn(UpdateStatus)
