-- =============================================================
-- DRACO HUB - DRAGON WIZARD (STATUS CHECKER)
-- Cơ chế: Quét phản hồi từ Server thông qua lệnh Speak
-- Style: Bám sát cấu trúc Dictionary của Vũ Nguyễn
-- =============================================================

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local lp = Players.LocalPlayer

-- 1. THIẾT LẬP
local TargetNPC = CFrame.new(5773.936035, 1209.442871, 809.224548)
local SPEED = 240

-- 2. GIAO DIỆN MONITOR (VÀNG - ĐEN)
if CoreGui:FindFirstChild("DracoWizardStatus") then CoreGui.DracoWizardStatus:Destroy() end
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "DracoWizardStatus"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 300, 0, 180)
Main.Position = UDim2.new(0.5, -150, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Active = true; Main.Draggable = true
Instance.new("UIStroke", Main).Color = Color3.fromRGB(255, 200, 0)
Instance.new("UICorner", Main)

-- Label hiển thị trạng thái đã học hay chưa
local LearnLabel = Instance.new("TextLabel", Main)
LearnLabel.Size = UDim2.new(1, -20, 0, 40); LearnLabel.Position = UDim2.new(0, 10, 0, 10)
LearnLabel.Text = "Dragon Tether: ĐANG QUÉT..."; LearnLabel.TextColor3 = Color3.new(1, 1, 0)
LearnLabel.BackgroundTransparency = 1; LearnLabel.Font = Enum.Font.GothamBold; LearnLabel.TextSize = 14

local StatusLabel = Instance.new("TextLabel", Main)
StatusLabel.Size = UDim2.new(1, -20, 0, 50); StatusLabel.Position = UDim2.new(0, 10, 0, 50)
StatusLabel.Text = "Hệ thống: Sẵn sàng"; StatusLabel.TextColor3 = Color3.new(1, 1, 1)
StatusLabel.BackgroundTransparency = 1; StatusLabel.Font = Enum.Font.Gotham; StatusLabel.TextSize = 12; StatusLabel.TextWrapped = true

-- 3. HÀM CHECK TRẠNG THÁI TỪ SERVER (F9 DEBUG)
local function CheckNPCData()
    local Net = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net")
    local RF = Net["RF/InteractDragonQuest"]
    
    local ok, res = pcall(function()
        return RF:InvokeServer({[1] = {NPC = "Dragon Wizard", Command = "Speak"}})
    end)

    if ok then
        -- Chuyển kết quả về String để quét từ khóa
        local dataStr = tostring(res):lower()
        -- In ra console F9 để Vũ theo dõi dữ liệu gốc
        print("[Draco Debug] Server Response:", res)

        -- Nếu server trả về kết quả chứa từ khóa "đã học"
        if dataStr:find("learned") or dataStr:find("already") or res == true then
            LearnLabel.Text = "Dragon Tether: ✅ ĐÃ SỞ HỮU"
            LearnLabel.TextColor3 = Color3.new(0, 1, 0)
            return true
        else
            LearnLabel.Text = "Dragon Tether: ❌ CHƯA HỌC"
            LearnLabel.TextColor3 = Color3.new(1, 0, 0)
            return false
        end
    else
        LearnLabel.Text = "Dragon Tether: ⚠️ LỖI KẾT NỐI"
        return false
    end
end

-- Luồng tự động quét mỗi 5 giây
task.spawn(function()
    while task.wait(5) do
        CheckNPCData()
    end
end)

-- 4. HÀM TWEEN GỐC (CỦA VŨ)
local function toposition(Pos, onDone)
    local char = lp.Character or lp.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local root = char:FindFirstChild("Root") or Instance.new("Part", char)
    if root.Name ~= "Root" then
        root.Size = Vector3.new(20, 0.5, 20); root.Name = "Root"; root.Anchored = true; root.Transparency = 1; root.CanCollide = false
    end
    local distance = (Pos.Position - hrp.Position).Magnitude
    local tweenObj = TweenService:Create(root, TweenInfo.new(distance / SPEED, Enum.EasingStyle.Linear), { CFrame = Pos })
    tweenObj:Play()
    local running = true
    task.spawn(function()
        while running do task.wait(); pcall(function() hrp.CFrame = root.CFrame end) end
    end)
    tweenObj.Completed:Connect(function()
        running = false; hrp.CFrame = root.CFrame
        if typeof(onDone) == "function" then onDone() end
    end)
end

-- 5. NÚT BẤM THỰC THI
local ActionBtn = Instance.new("TextButton", Main)
ActionBtn.Size = UDim2.new(0, 220, 0, 45); ActionBtn.Position = UDim2.new(0.5, -110, 0.65, 0)
ActionBtn.Text = "TWEEN & LEARN"; ActionBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
ActionBtn.TextColor3 = Color3.new(1, 1, 1); ActionBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", ActionBtn)

ActionBtn.MouseButton1Click:Connect(function()
    StatusLabel.Text = "⚡ Đang kiểm tra dữ liệu..."; task.wait(0.2)
    
    -- Nếu đã học rồi thì không bay nữa
    if LearnLabel.Text:find("ĐÃ SỞ HỮU") then
        StatusLabel.Text = "Thông báo: Bạn đã học chiêu này rồi!"
        return
    end

    StatusLabel.Text = "🚀 Đang bay đến NPC..."
    toposition(TargetNPC, function()
        task.wait(0.3)
        local Net = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net")
        local RF = Net["RF/InteractDragonQuest"]

        pcall(function() RF:InvokeServer({[1] = {NPC = "Dragon Wizard", Command = "Speak"}}) end)
        task.wait(0.5)
        
        local ok, res = pcall(function() 
            return RF:InvokeServer({[1] = {NPC = "Dragon Wizard", Command = "LearnTether"}}) 
        end)

        if ok then StatusLabel.Text = "✅ Đã gửi lệnh học!" else StatusLabel.Text = "❌ Lỗi: " .. tostring(res) end
        CheckNPCData() -- Cập nhật trạng thái ngay sau khi học
    end)
end)

-- Quét lần đầu khi bật script
task.spawn(CheckNPCData)
