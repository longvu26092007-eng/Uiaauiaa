-- ==========================================
-- [ PHẦN 1 ] LÕI LOGIC (CORE)
-- ==========================================
local Player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local Uzoth_CFrame = CFrame.new(5661.898, 1210.877, 863.176)

-- Hàm kiểm tra Dragon Talon (tách riêng để UI có thể gọi)
local function CheckDragonTalon()
    local character = Player.Character
    local backpack = Player:WaitForChild("Backpack")
    return (character and character:FindFirstChild("Dragon Talon")) or backpack:FindFirstChild("Dragon Talon")
end

-- Hàm Tween siêu mượt (State 11 + BodyVelocity)
local function TweenTo(targetCFrame)
    local character = Player.Character or Player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")
    local humanoid = character:WaitForChild("Humanoid")
    
    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    if distance <= 250 then
        hrp.CFrame = targetCFrame
        return
    end

    local bv = hrp:FindFirstChild("DracoAntiGravity") or Instance.new("BodyVelocity")
    bv.Name = "DracoAntiGravity"
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Velocity = Vector3.new(0, 0, 0)
    bv.Parent = hrp
    
    local speed = 300 
    local time = distance / speed
    local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
    
    local noclip
    noclip = RunService.Stepped:Connect(function()
        humanoid:ChangeState(11) 
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end)
    
    tween:Play()
    tween.Completed:Wait() 
    
    if bv then bv:Destroy() end
    if noclip then noclip:Disconnect() end
    humanoid:ChangeState(8) 
end

-- ==========================================
-- [ PHẦN 2 ] GIAO DIỆN MONITOR (VÀNG - ĐEN)
-- ==========================================
-- Chống trùng lặp UI khi Execute nhiều lần
if CoreGui:FindFirstChild("DracoHubUI") then
    CoreGui.DracoHubUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "DracoHubUI"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 450, 0, 150)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -75)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Active = true
MainFrame.Draggable = true -- Cho phép kéo thả bảng UI!

Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(255, 200, 0)
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = " Draco Hub VuNguyen - V1"
Title.TextColor3 = Color3.fromRGB(255, 200, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Center

-- Dòng kẻ dưới Title
local Line = Instance.new("Frame", Title)
Line.Size = UDim2.new(1, 0, 0, 1)
Line.Position = UDim2.new(0, 0, 1, 0)
Line.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
Line.BorderSizePixel = 0

-- Cột Trái: Trạng thái
local LeftPanel = Instance.new("Frame", MainFrame)
LeftPanel.Size = UDim2.new(0.5, -15, 1, -50)
LeftPanel.Position = UDim2.new(0, 10, 0, 40)
LeftPanel.BackgroundTransparency = 1

local SpawnLabel = Instance.new("TextLabel", LeftPanel)
SpawnLabel.Size = UDim2.new(1, 0, 0, 30)
local isDone = CheckDragonTalon()
SpawnLabel.Text = "Dragon Talon: " .. (isDone and "Đã có" or "Chưa có")
SpawnLabel.TextColor3 = isDone and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
SpawnLabel.Font = Enum.Font.GothamBold
SpawnLabel.BackgroundTransparency = 1
SpawnLabel.TextSize = 14
SpawnLabel.TextXAlignment = Enum.TextXAlignment.Left

local ActionStatus = Instance.new("TextLabel", LeftPanel)
ActionStatus.Size = UDim2.new(1, 0, 0, 30)
ActionStatus.Position = UDim2.new(0, 0, 0, 30)
ActionStatus.Text = "Trạng thái: Đang chờ..."
ActionStatus.TextColor3 = Color3.fromRGB(200, 200, 200)
ActionStatus.Font = Enum.Font.Gotham
ActionStatus.BackgroundTransparency = 1
ActionStatus.TextSize = 12
ActionStatus.TextXAlignment = Enum.TextXAlignment.Left

-- Cột Phải: Nút Action
local RightPanel = Instance.new("Frame", MainFrame)
RightPanel.Size = UDim2.new(0.5, -15, 1, -50)
RightPanel.Position = UDim2.new(0.5, 5, 0, 40)
RightPanel.BackgroundTransparency = 1

local RunButton = Instance.new("TextButton", RightPanel)
RunButton.Size = UDim2.new(1, -10, 0, 35)
RunButton.Position = UDim2.new(0, 5, 0, 15)
RunButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
RunButton.Text = "Lấy Dragon Talon"
RunButton.TextColor3 = Color3.fromRGB(255, 200, 0)
RunButton.Font = Enum.Font.GothamBold
RunButton.TextSize = 14
Instance.new("UICorner", RunButton).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", RunButton).Color = Color3.fromRGB(255, 200, 0)

-- ==========================================
-- [ PHẦN 3 ] KẾT NỐI NÚT BẤM VÀ LOGIC
-- ==========================================
RunButton.MouseButton1Click:Connect(function()
    -- Bọc trong task.spawn để game không bị đứng khi bấm nút
    task.spawn(function()
        if CheckDragonTalon() then
            ActionStatus.Text = "Trạng thái: Đã có sẵn vũ khí này!"
            return
        end
        
        ActionStatus.Text = "Trạng thái: Đang bay đến Uzoth..."
        TweenTo(Uzoth_CFrame)
        
        task.wait(0.5)
        ActionStatus.Text = "Trạng thái: Đang mua..."
        local args = {[1] = "BuyDragonTalon"}
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
        
        ActionStatus.Text = "Trạng thái: Hoàn tất!"
        -- Cập nhật lại UI hiển thị
        task.wait(1)
        local doneNow = CheckDragonTalon()
        SpawnLabel.Text = "Dragon Talon: " .. (doneNow and "Đã có" or "Chưa có")
        SpawnLabel.TextColor3 = doneNow and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    end)
end)
