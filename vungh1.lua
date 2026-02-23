-- =============================================================
-- DRACO HUB - DRAGON WIZARD (DOUBLE INTERACT VERSION)
-- Tối ưu: Portal -> Tween -> Nhấn 2 lần vào Remote
-- =============================================================

repeat task.wait() until game:IsLoaded()

-- 1. CẤU HÌNH
getgenv().Config = {
    TEAM = "Pirates", 
    SPEED = 240,
    NPC_CFrame = CFrame.new(5864.833, 1209.483, 811.329),
    EntrancePos = Vector3.new(5661.532, 1013.090, -334.964)
}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local lp = Players.LocalPlayer

-- 2. GIAO DIỆN (Status & Button)
local ScreenGui = Instance.new("ScreenGui", lp.PlayerGui)
ScreenGui.Name = "DracoWizardV2"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 320, 0, 220)
Main.Position = UDim2.new(0.5, -160, 0.4, -110)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.Active = true
Main.Draggable = true
Instance.new("UIStroke", Main).Color = Color3.fromRGB(255, 200, 0)
Instance.new("UICorner", Main)

local StatusLabel = Instance.new("TextLabel", Main)
StatusLabel.Size = UDim2.new(1, -20, 0, 80)
StatusLabel.Position = UDim2.new(0, 10, 0, 10)
StatusLabel.Text = "Sẵn sàng... Bấm START để chạy quy trình 2 bước."
StatusLabel.TextColor3 = Color3.new(1, 1, 1)
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextWrapped = true

local function UpdateStatus(msg, color)
    StatusLabel.Text = msg
    StatusLabel.TextColor3 = color or Color3.new(1, 1, 1)
end

-- 3. LOGIC DI CHUYỂN (Hàm toposition từ source cậu gửi)
local function toposition(Pos, onDone)
    local char = lp.Character or lp.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local root = char:FindFirstChild("Root") or Instance.new("Part")
    
    if not char:FindFirstChild("Root") then
        root.Size = Vector3.new(20, 0.5, 20); root.Name = "Root"; root.Anchored = true; root.Transparency = 1
        root.Parent = char; root.CFrame = hrp.CFrame
    end

    local distance = (Pos.Position - hrp.Position).Magnitude
    local tween = TweenService:Create(root, TweenInfo.new(distance / getgenv().Config.SPEED, Enum.EasingStyle.Linear), {CFrame = Pos})
    
    local running = true
    task.spawn(function()
        while running do task.wait(); hrp.CFrame = root.CFrame end
    end)

    tween:Play()
    tween.Completed:Connect(function() running = false; if onDone then onDone() end end)
end

-- 4. HÀM THỰC THI INTERACT 2 LẦN
local function StartDragonProcess()
    local InteractRF = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/InteractDragonQuest")
    
    task.spawn(function()
        -- Bước 1: Xin Portal
        UpdateStatus("⚡ Bước 1: Gửi requestEntrance...", Color3.new(0, 1, 1))
        pcall(function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", getgenv().Config.EntrancePos)
        end)
        task.wait(0.3)

        -- Bước 2: Tween đến NPC
        UpdateStatus("⚡ Bước 2: Đang bay đến Dragon Wizard...", Color3.new(1, 1, 0))
        toposition(getgenv().Config.NPC_CFrame, function()
            
            -- Bước 3: NHẤN LẦN 1 (Mở bảng)
            UpdateStatus("⚡ Bước 3: Interact lần 1 (Mở bảng)...", Color3.new(1, 0.5, 0))
            pcall(function() InteractRF:InvokeServer({}) end)
            
            task.wait(1.5) -- Đợi bảng hiện ra ổn định

            -- Bước 4: NHẤN LẦN 2 (Học/Nở)
            UpdateStatus("⚡ Bước 4: Interact lần 2 (Học võ/Nở)...", Color3.new(0, 1, 0))
            local ok, res = pcall(function()
                return InteractRF:InvokeServer({})
            end)

            if ok then
                UpdateStatus("✅ HOÀN THÀNH!\nĐã gửi 2 lệnh nhấn liên tiếp.", Color3.new(0, 1, 0))
            else
                UpdateStatus("❌ LỖI: " .. tostring(res), Color3.new(1, 0, 0))
            end
        end)
    end)
end

-- 5. NÚT BẤM START
local StartBtn = Instance.new("TextButton", Main)
StartBtn.Size = UDim2.new(0.8, 0, 0, 50)
StartBtn.Position = UDim2.new(0.1, 0, 0.65, 0)
StartBtn.Text = "START DOUBLE INTERACT"
StartBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
StartBtn.TextColor3 = Color3.new(1, 1, 1)
StartBtn.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", StartBtn)

StartBtn.MouseButton1Click:Connect(function()
    StartBtn.Text = "Đang thực hiện..."
    StartBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    StartDragonProcess()
end)
