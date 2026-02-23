-- =============================================================
-- DRACO HUB - DRAGON WIZARD (DIRECT TWEEN VERSION)
-- Lộ trình: Tween -> Speak -> LearnTether (Không dùng Portal)
-- Style: Bám sát cấu trúc Dictionary & Tween của Vũ Nguyễn
-- =============================================================

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local lp = Players.LocalPlayer

-- 1. THIẾT LẬP TỌA ĐỘ & CẤU HÌNH
local TargetNPC = CFrame.new(5773.936035, 1209.442871, 809.224548)
local SPEED = 240

-- 2. GIAO DIỆN MONITOR (VÀNG - ĐEN)
if CoreGui:FindFirstChild("DracoWizardDirect") then CoreGui.DracoWizardDirect:Destroy() end
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "DracoWizardDirect"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 300, 0, 160)
Main.Position = UDim2.new(0.5, -150, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Active = true; Main.Draggable = true
Instance.new("UIStroke", Main).Color = Color3.fromRGB(255, 200, 0)
Instance.new("UICorner", Main)

local StatusLabel = Instance.new("TextLabel", Main)
StatusLabel.Size = UDim2.new(1, -20, 0, 60); StatusLabel.Position = UDim2.new(0, 10, 0, 10)
StatusLabel.Text = "Hệ thống: Sẵn sàng...\nChế độ: Bay trực tiếp (No Portal)"; StatusLabel.TextColor3 = Color3.new(1, 1, 1)
StatusLabel.BackgroundTransparency = 1; StatusLabel.Font = Enum.Font.GothamBold; StatusLabel.TextSize = 13; StatusLabel.TextWrapped = true

-- 3. HÀM TWEEN GỐC (ĐÃ TỐI ƯU)
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
        root.CFrame = Pos; hrp.CFrame = Pos
        if typeof(onDone) == "function" then onDone() end
        return
    end

    if hum and hum.Sit then hum.Sit = false end

    local tweenObj = TweenService:Create(root, TweenInfo.new(distance / SPEED, Enum.EasingStyle.Linear), { CFrame = Pos })
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
        if typeof(onDone) == "function" then onDone() end
    end)
end

-- 4. HÀM THỰC THI LỆNH SPEAK & LEARN
local function executeDragonLearn()
    StatusLabel.Text = "⚡ Đang bay trực tiếp đến Dragon Wizard..."
    StatusLabel.TextColor3 = Color3.new(1, 1, 1)

    toposition(TargetNPC, function()
        task.wait(0.3)
        
        local Net = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net")
        local RF = Net["RF/InteractDragonQuest"]

        -- BƯỚC 1: SPEAK
        StatusLabel.Text = "⚡ Bước 1: Gửi lệnh Speak..."
        StatusLabel.TextColor3 = Color3.new(1, 1, 0)
        local cmdSpeak = {[1] = {NPC = "Dragon Wizard", Command = "Speak"}}
        pcall(function() RF:InvokeServer(unpack(cmdSpeak)) end)
        
        task.wait(0.5)

        -- BƯỚC 2: LEARN TETHER
        StatusLabel.Text = "⚡ Bước 2: Gửi lệnh LearnTether..."
        StatusLabel.TextColor3 = Color3.new(1, 0.5, 0)
        local cmdLearn = {[1] = {NPC = "Dragon Wizard", Command = "LearnTether"}}
        local ok, res = pcall(function() return RF:InvokeServer(unpack(cmdLearn)) end)

        if ok then
            StatusLabel.Text = "✅ THÀNH CÔNG!\nĐã học xong Dragon Tether."
            StatusLabel.TextColor3 = Color3.new(0, 1, 0)
        else
            StatusLabel.Text = "❌ THẤT BẠI!\nLỗi: " .. tostring(res)
            StatusLabel.TextColor3 = Color3.new(1, 0, 0)
        end
    end)
end

-- 5. NÚT BẤM TEST
local ActionBtn = Instance.new("TextButton", Main)
ActionBtn.Size = UDim2.new(0, 220, 0, 45); ActionBtn.Position = UDim2.new(0.5, -110, 0.65, 0)
ActionBtn.Text = "TWEEN & LEARN"; ActionBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
ActionBtn.TextColor3 = Color3.new(1, 1, 1); ActionBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", ActionBtn)

ActionBtn.MouseButton1Click:Connect(function()
    task.spawn(executeDragonLearn)
end)
