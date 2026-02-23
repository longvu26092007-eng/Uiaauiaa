-- =============================================================
-- DRACO HUB - DRAGON WIZARD (FULL AUTO VERSION)
-- Tính năng: Auto Team, Tween NPC, Scan Menu Options (Check Learn)
-- Style: Vàng - Đen (Bám sát phong cách Vũ Nguyễn)
-- =============================================================

repeat task.wait() until game:IsLoaded()

-- 1. CẤU HÌNH & KHỞI TẠO
getgenv().Config = {
    TEAM = "Pirates", -- Pirates hoặc Marines
    SPEED = 240,
    NPC_Pos = CFrame.new(5773.936035, 1209.442871, 809.224548)
}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local lp = Players.LocalPlayer

-- 2. AUTO CHỌN TEAM (STYLE VŨ NGUYỄN)
if lp.Team == nil then
    repeat task.wait()
        for i, v in pairs(lp.PlayerGui:GetChildren()) do
            if string.find(v.Name, "Main") then
                pcall(function()
                    v.ChooseTeam.Container[getgenv().Config.TEAM].Frame.TextButton.Size = UDim2.new(0, 10000, 0, 10000)
                    v.ChooseTeam.Container[getgenv().Config.TEAM].Frame.TextButton.Position = UDim2.new(-4, 0, -5, 0)
                    v.ChooseTeam.Container[getgenv().Config.TEAM].Frame.TextButton.BackgroundTransparency = 1
                    task.wait(.5)
                    game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 1); task.wait(0.05)
                    game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, game, 1)
                end)
            end
        end
    until lp.Team ~= nil
    task.wait(3)
end

-- 3. GIAO DIỆN MONITOR
if CoreGui:FindFirstChild("DracoWizardMaster") then CoreGui.DracoWizardMaster:Destroy() end
local ScreenGui = Instance.new("ScreenGui", CoreGui); ScreenGui.Name = "DracoWizardMaster"
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 320, 0, 180); Main.Position = UDim2.new(0.5, -160, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Main.Active = true; Main.Draggable = true
Instance.new("UIStroke", Main).Color = Color3.fromRGB(255, 200, 0)
Instance.new("UICorner", Main)

local LearnLabel = Instance.new("TextLabel", Main)
LearnLabel.Size = UDim2.new(1, -20, 0, 40); LearnLabel.Position = UDim2.new(0, 10, 0, 10)
LearnLabel.Text = "Dragon Tether: ĐANG QUÉT..."; LearnLabel.TextColor3 = Color3.new(1, 1, 0)
LearnLabel.BackgroundTransparency = 1; LearnLabel.Font = Enum.Font.GothamBold; LearnLabel.TextSize = 14

local StatusLabel = Instance.new("TextLabel", Main)
StatusLabel.Size = UDim2.new(1, -20, 0, 50); StatusLabel.Position = UDim2.new(0, 10, 0, 50)
StatusLabel.Text = "Hệ thống: Sẵn sàng"; StatusLabel.TextColor3 = Color3.new(1, 1, 1)
StatusLabel.BackgroundTransparency = 1; StatusLabel.Font = Enum.Font.Gotham; StatusLabel.TextSize = 12; StatusLabel.TextWrapped = true

-- 4. HÀM GỌI REMOTE AN TOÀN
local function SafeInvoke(cmd)
    local Net = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net")
    local RF = Net:WaitForChild("RF/InteractDragonQuest", 5)
    if not RF then return nil end
    local v371 = {[1] = {NPC = "Dragon Wizard", Command = cmd}}
    return pcall(function() return RF:InvokeServer(unpack(v371)) end)
end

-- 5. HÀM CHECK STATUS (Dựa trên Options như Vũ yêu cầu)
local function UpdateLearnStatus()
    local ok, res = SafeInvoke("Speak")
    if ok and type(res) == "table" then
        local hasLearnOption = false
        local function scan(t)
            for k, v in pairs(t) do
                if v == "LearnTether" or k == "LearnTether" then hasLearnOption = true return end
                if type(v) == "table" then scan(v) end
            end
        end
        scan(res)
        
        if hasLearnOption then
            LearnLabel.Text = "Dragon Tether: ❌ CHƯA SỞ HỮU"
            LearnLabel.TextColor3 = Color3.new(1, 0, 0)
            return false -- Chưa học
        else
            LearnLabel.Text = "Dragon Tether: ✅ ĐÃ SỞ HỮU"
            LearnLabel.TextColor3 = Color3.new(0, 1, 0)
            return true -- Đã học
        end
    end
    return false
end

-- 6. HÀM TWEEN (CỦA VŨ NGUYỄN)
local function toposition(Pos, onDone)
    local char = lp.Character or lp.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("Root")
    
    if not root then
        local K = Instance.new("Part")
        K.Size = Vector3.new(20, 0.5, 20); K.Name = "Root"; K.Anchored = true; K.Transparency = 1; K.CanCollide = false
        K.CFrame = hrp.CFrame * CFrame.new(0, 0.6, 0)
        K.Parent = char
        root = K
    end

    local distance = (Pos.Position - hrp.Position).Magnitude
    if distance <= 10 then
        hrp.CFrame = Pos; if onDone then onDone() end return
    end

    if hum and hum.Sit then hum.Sit = false end
    local tweenObj = TweenService:Create(root, TweenInfo.new(distance / getgenv().Config.SPEED, Enum.EasingStyle.Linear), { CFrame = Pos })
    tweenObj:Play()

    local running = true
    task.spawn(function()
        while running do
            task.wait()
            pcall(function() hrp.CFrame = root.CFrame end)
        end
    end)

    tweenObj.Completed:Connect(function()
        running = false
        hrp.CFrame = root.CFrame
        if onDone then onDone() end
    end)
end

-- 7. THỰC THI CHÍNH
local function startExecution()
    StatusLabel.Text = "⚡ Đang kiểm tra menu NPC..."
    if UpdateLearnStatus() then
        StatusLabel.Text = "Thông báo: Bạn đã học chiêu này rồi!"
        return
    end

    StatusLabel.Text = "🚀 Đang bay đến Dragon Wizard..."
    toposition(getgenv().Config.NPC_Pos, function()
        task.wait(0.3)
        StatusLabel.Text = "⚡ Đang thực hiện chuỗi lệnh học..."
        SafeInvoke("Speak")
        task.wait(0.6)
        local ok, _ = SafeInvoke("LearnTether")
        if ok then
            StatusLabel.Text = "✅ Đã gửi lệnh Learn! Chờ cập nhật..."
            task.wait(1.5)
            UpdateLearnStatus()
        end
    end)
end

-- 8. NÚT BẤM & TỰ ĐỘNG
local ActionBtn = Instance.new("TextButton", Main)
ActionBtn.Size = UDim2.new(0, 220, 0, 45); ActionBtn.Position = UDim2.new(0.5, -110, 0.65, 0)
ActionBtn.Text = "CHECK & LEARN"; ActionBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
ActionBtn.TextColor3 = Color3.new(1, 1, 1); ActionBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", ActionBtn)

ActionBtn.MouseButton1Click:Connect(function()
    task.spawn(startExecution)
end)

-- Quét trạng thái ngay khi chạy
task.spawn(UpdateLearnStatus)
