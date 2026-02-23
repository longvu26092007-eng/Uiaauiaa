-- =============================================================
-- DRACO HUB - DRAGON WIZARD (PORTAL + TWEEN + DOUBLE COMMAND)
-- Lộ trình: Entrance -> Tween -> Speak -> LearnTether
-- Style: Bám sát cấu trúc Dictionary & Invoker của Vũ Nguyễn
-- =============================================================

repeat task.wait() until game:IsLoaded()

-- 1. CẤU HÌNH HỆ THỐNG
getgenv().Config = {
    TEAM = "Pirates", -- Marines
    SPEED = 240,
    NPC_Pos = CFrame.new(5773.936, 1209.443, 809.225), -- Tọa độ chuẩn của cậu
    Entrance_Pos = Vector3.new(5661.532, 1013.091, -334.965) -- Tọa độ Portal
}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local lp = Players.LocalPlayer

-- 2. GIAO DIỆN MONITOR (VÀNG - ĐEN)
local CoreGui = game:GetService("CoreGui")
if CoreGui:FindFirstChild("DracoWizardHatch") then CoreGui.DracoWizardHatch:Destroy() end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "DracoWizardHatch"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 320, 0, 180)
Main.Position = UDim2.new(0.5, -160, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Active = true; Main.Draggable = true
Instance.new("UIStroke", Main).Color = Color3.fromRGB(255, 200, 0)
Instance.new("UICorner", Main)

local StatusLabel = Instance.new("TextLabel", Main)
StatusLabel.Size = UDim2.new(1, -20, 0, 70); StatusLabel.Position = UDim2.new(0, 10, 0, 10)
StatusLabel.Text = "Hệ thống: Sẵn sàng...\nChờ lệnh: Portal -> Tween -> Learn"; StatusLabel.TextColor3 = Color3.new(1, 1, 1)
StatusLabel.BackgroundTransparency = 1; StatusLabel.Font = Enum.Font.GothamBold; StatusLabel.TextSize = 13; StatusLabel.TextWrapped = true

-- 3. HÀM HỖ TRỢ (TWEEN & TEAM)
local function AutoTeam()
    if lp.Team == nil then
        for i, v in pairs(lp.PlayerGui:GetChildren()) do
            if string.find(v.Name, "Main") then
                pcall(function()
                    v.ChooseTeam.Container[getgenv().Config.TEAM].Frame.TextButton.Size = UDim2.new(0, 10000, 0, 10000)
                    task.wait(.5)
                    game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 1);task.wait(0.05)
                    game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, game, 1)
                end)
            end
        end
        repeat task.wait() until lp.Team ~= nil
    end
end

local function toposition(Pos, onDone)
    local char = lp.Character or lp.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local root = char:FindFirstChild("Root") or Instance.new("Part", char)
    if root.Name ~= "Root" then
        root.Size = Vector3.new(20, 0.5, 20); root.Name = "Root"; root.Anchored = true; root.Transparency = 1; root.CanCollide = false
    end

    local distance = (Pos.Position - hrp.Position).Magnitude
    local tween = TweenService:Create(root, TweenInfo.new(distance / getgenv().Config.SPEED, Enum.EasingStyle.Linear), { CFrame = Pos })
    
    local running = true
    task.spawn(function()
        while running do task.wait(); pcall(function() hrp.CFrame = root.CFrame end) end
    end)

    tween:Play()
    tween.Completed:Connect(function()
        running = false; hrp.CFrame = root.CFrame
        if typeof(onDone) == "function" then onDone() end
    end)
end

-- 4. HÀM THỰC THI CHÍNH (INVOKER)
local function executeDragonWizardFull()
    StatusLabel.TextColor3 = Color3.new(1, 1, 1)
    
    -- Bước 1: Chọn Team
    AutoTeam()
    
    -- Bước 2: Request Entrance (Portal)
    StatusLabel.Text = "⚡ Bước 1: Đang gửi Request Entrance (Portal)..."
    pcall(function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", getgenv().Config.Entrance_Pos)
    end)
    task.wait(0.5)

    -- Bước 3: Tween đến NPC
    StatusLabel.Text = "⚡ Bước 2: Đang bay đến Dragon Wizard..."
    toposition(getgenv().Config.NPC_Pos, function()
        task.wait(0.3)
        
        -- Bước 4: Speak (Interact Lần 1)
        StatusLabel.Text = "⚡ Bước 3: Gửi lệnh Speak (NPC Interact)..."
        local Net = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net")
        local RF = Net["RF/InteractDragonQuest"]
        
        local cmdSpeak = {[1] = {NPC = "Dragon Wizard", Command = "Speak"}}
        pcall(function() RF:InvokeServer(unpack(cmdSpeak)) end)
        
        task.wait(0.5)

        -- Bước 4: LearnTether (Interact Lần 2)
        StatusLabel.Text = "⚡ Bước 4: Đang gửi lệnh LearnTether..."
        local cmdLearn = {[1] = {NPC = "Dragon Wizard", Command = "LearnTether"}}
        local ok, res = pcall(function() return RF:InvokeServer(unpack(cmdLearn)) end)

        if ok then
            StatusLabel.Text = "✅ THÀNH CÔNG!\nĐã chốt xong LearnTether."
            StatusLabel.TextColor3 = Color3.new(0, 1, 0)
        else
            StatusLabel.Text = "❌ THẤT BẠI!\nLỗi: " .. tostring(res)
            StatusLabel.TextColor3 = Color3.new(1, 0, 0)
        end
    end)
end

-- 5. NÚT BẤM
local TestBtn = Instance.new("TextButton", Main)
TestBtn.Size = UDim2.new(0, 220, 0, 45); TestBtn.Position = UDim2.new(0.5, -110, 0.65, 0)
TestBtn.Text = "START FULL PROCESS"; TestBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
TestBtn.TextColor3 = Color3.new(1, 1, 1); TestBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", TestBtn)

TestBtn.MouseButton1Click:Connect(function()
    task.spawn(executeDragonWizardFull)
end)
