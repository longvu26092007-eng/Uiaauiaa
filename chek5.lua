-- =============================================================
-- DRACO HUB - DRAGON WIZARD (OPTION SCANNER VERSION)
-- Cơ chế: Kiểm tra sự tồn tại của nút "LearnTether" trong Options
-- Style: Vàng - Đen (Draco Hub Standard)
-- =============================================================

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local lp = Players.LocalPlayer

-- 1. CẤU HÌNH
local TargetNPC = CFrame.new(5773.936035, 1209.442871, 809.224548)
local SPEED = 240

-- 2. GIAO DIỆN MONITOR
if CoreGui:FindFirstChild("DracoWizardOptionCheck") then CoreGui.DracoWizardOptionCheck:Destroy() end
local ScreenGui = Instance.new("ScreenGui", CoreGui); ScreenGui.Name = "DracoWizardOptionCheck"
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 300, 0, 180); Main.Position = UDim2.new(0.5, -150, 0.4, 0)
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

-- 3. HÀM GỌI REMOTE AN TOÀN
local function SafeInvoke(cmd)
    local ok, Net = pcall(function() return ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net") end)
    if not ok then return nil end
    local RF = Net:WaitForChild("RF/InteractDragonQuest", 5)
    if not RF then return nil end
    
    local v371 = {[1] = {NPC = "Dragon Wizard", Command = cmd}}
    local success, response = pcall(function() return RF:InvokeServer(unpack(v371)) end)
    return success, response
end

-- 4. HÀM CHECK STATUS DỰA TRÊN OPTIONS (CÁCH MỚI CỦA VŨ)
local function UpdateLearnStatus()
    local ok, res = SafeInvoke("Speak")
    
    if ok then
        -- In ra F9 để cậu soi cấu trúc bảng Options nếu cần
        print("[Draco Debug] NPC Data:", res)
        
        local hasLearnOption = false
        
        -- Quét trong bảng trả về để tìm mục "Options" hoặc "Commands"
        if type(res) == "table" then
            -- Duyệt qua toàn bộ table để tìm chữ "LearnTether"
            local function findOption(t)
                for k, v in pairs(t) do
                    if tostring(v) == "LearnTether" or tostring(k) == "LearnTether" then
                        hasLearnOption = true
                        return true
                    end
                    if type(v) == "table" then
                        if findOption(v) then return true end
                    end
                end
                return false
            end
            findOption(res)
        end

        -- XÉT KẾT QUẢ:
        -- Nếu CÒN nút LearnTether -> CHƯA HỌC
        if hasLearnOption then
            LearnLabel.Text = "Dragon Tether: ❌ CHƯA SỞ HỮU"
            LearnLabel.TextColor3 = Color3.new(1, 0, 0)
            return false -- Trả về false để script biết cần phải đi học
        else
            -- Nếu KHÔNG CÒN nút LearnTether -> ĐÃ SỞ HỮU
            LearnLabel.Text = "Dragon Tether: ✅ ĐÃ SỞ HỮU"
            LearnLabel.TextColor3 = Color3.new(0, 1, 0)
            return true
        end
    end
    return false
end

-- 5. TWEEN DI CHUYỂN GỐC
local function toposition(Pos, onDone)
    local char = lp.Character or lp.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local root = char:FindFirstChild("Root") or Instance.new("Part", char)
    root.Name = "Root"; root.Size = Vector3.new(20, 0.5, 20); root.Anchored = true; root.Transparency = 1; root.CanCollide = false
    local distance = (Pos.Position - hrp.Position).Magnitude
    local tween = TweenService:Create(root, TweenInfo.new(distance / SPEED, Enum.EasingStyle.Linear), {CFrame = Pos})
    local running = true
    task.spawn(function() while running do task.wait(); pcall(function() hrp.CFrame = root.CFrame end) end end)
    tween:Play()
    tween.Completed:Connect(function()
        running = false; hrp.CFrame = root.CFrame
        if onDone then onDone() end
    end)
end

-- 6. THỰC THI CHÍNH
local function start()
    StatusLabel.Text = "⚡ Đang kiểm tra danh sách menu của NPC..."
    if UpdateLearnStatus() then
        StatusLabel.Text = "Thông báo: Menu NPC không còn nút Learn. Bạn đã học rồi!"
        return
    end
    
    StatusLabel.Text = "🚀 Đang bay đến Dragon Wizard..."
    toposition(TargetNPC, function()
        task.wait(0.3)
        SafeInvoke("Speak") 
        task.wait(0.5)
        local ok, res = SafeInvoke("LearnTether")
        if ok then 
            StatusLabel.Text = "✅ Đã gửi lệnh Learn!" 
            task.wait(1.5)
            UpdateLearnStatus()
        end
    end)
end

-- 7. NÚT BẤM
local ActionBtn = Instance.new("TextButton", Main)
ActionBtn.Size = UDim2.new(0, 220, 0, 45); ActionBtn.Position = UDim2.new(0.5, -110, 0.65, 0)
ActionBtn.Text = "CHECK & LEARN TETHER"; ActionBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
ActionBtn.TextColor3 = Color3.new(1, 1, 1); ActionBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", ActionBtn)
ActionBtn.MouseButton1Click:Connect(function() task.spawn(start) end)

-- Quét trạng thái ngay khi chạy script
task.spawn(UpdateLearnStatus)
