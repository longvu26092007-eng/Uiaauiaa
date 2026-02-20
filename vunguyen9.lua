-- ==========================================
-- [ PHẦN 0 : CHỌN TEAM & ĐỢI GAME LOAD ]
-- ==========================================
getgenv().Team = "Marines" 

if not game:IsLoaded() then
    game.Loaded:Wait()
end

task.spawn(function()
    local Player = game.Players.LocalPlayer
    while task.wait(0.5) do
        if Player.Team ~= nil then
            break 
        end
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", getgenv().Team)
            if Player:FindFirstChild("PlayerGui") and Player.PlayerGui:FindFirstChild("Main") then
                local chooseTeamUI = Player.PlayerGui.Main:FindFirstChild("ChooseTeam")
                if chooseTeamUI then
                    chooseTeamUI.Visible = false
                end
            end
        end)
    end
end)

repeat task.wait() until game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
task.wait(2)

-- ==========================================
-- [ PHẦN 1 : DRGTL ] LÕI LOGIC (CORE)
-- ==========================================
local Player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local Uzoth_CFrame = CFrame.new(5661.898, 1210.877, 863.176)
local Trade_CFrame = CFrame.new(-12596.668, 336.671, -7556.832)

local function CheckDragonTalon()
    local character = Player.Character
    local backpack = Player:WaitForChild("Backpack")
    return (character and character:FindFirstChild("Dragon Talon")) or (backpack and backpack:FindFirstChild("Dragon Talon"))
end

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
-- [ PHẦN 2 : Check Mastery Dragon Talon & Smart Kick ]
-- ==========================================
local function GetWeaponMastery(weaponName)
    local masteryValue = 0
    local p = game.Players.LocalPlayer
    local item = p.Backpack:FindFirstChild(weaponName) or (p.Character and p.Character:FindFirstChild(weaponName))
    
    if item and item:FindFirstChild("Level") then
        masteryValue = item.Level.Value
    end
    return masteryValue
end

-- Module kiểm tra thông minh: Chỉ Kick nếu đạt mốc 500 khi đang farm
task.spawn(function()
    -- Chờ có vũ khí để kiểm tra chỉ số ban đầu
    repeat task.wait(1) until CheckDragonTalon()
    local initialMastery = GetWeaponMastery("Dragon Talon")
    
    -- Nếu ngay khi vào game đã >= 500 thì dừng Module Kick luôn để không bị lặp
    if initialMastery >= 500 then
        return 
    end

    -- Nếu vào game mà chưa đủ 500, bắt đầu theo dõi quá trình tăng trưởng
    while task.wait(3) do
        local currentMastery = GetWeaponMastery("Dragon Talon")
        if currentMastery >= 500 then
            if ActionStatus then ActionStatus.Text = "Hành động: ĐÃ ĐẠT 500 MASTERY! ĐANG KICK..." end
            task.wait(2)
            Player:Kick("\n[ Draco Hub ]\nĐã đủ mastery đang tiến hành Kick\nLý do: Đạt mốc 500/500 khi farm. Hãy Rejoin để script nhận diện Dojo Trainer!")
            break
        end
    end
end)

-- ==========================================
-- [ PHẦN 3 ] GIAO DIỆN MONITOR (VÀNG - ĐEN)
-- ==========================================
if CoreGui:FindFirstChild("DracoHubUI") then
    CoreGui.DracoHubUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "DracoHubUI"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 450, 0, 160)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -80)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Active = true
MainFrame.Draggable = true 

Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(255, 200, 0)
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = " Draco Hub VuNguyen - V1 (Auto Mode)"
Title.TextColor3 = Color3.fromRGB(255, 200, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Center

local Line = Instance.new("Frame", Title)
Line.Size = UDim2.new(1, 0, 0, 1)
Line.Position = UDim2.new(0, 0, 1, 0)
Line.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
Line.BorderSizePixel = 0

local TPTradeBtn = Instance.new("TextButton", MainFrame)
TPTradeBtn.Size = UDim2.new(0, 70, 0, 25)
TPTradeBtn.Position = UDim2.new(1, -75, 0, 5)
TPTradeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TPTradeBtn.Text = "TP Trade"
TPTradeBtn.TextColor3 = Color3.fromRGB(255, 200, 0)
TPTradeBtn.Font = Enum.Font.GothamBold
TPTradeBtn.TextSize = 12
Instance.new("UICorner", TPTradeBtn).CornerRadius = UDim.new(0, 4)
Instance.new("UIStroke", TPTradeBtn).Color = Color3.fromRGB(255, 200, 0)

local InfoPanel = Instance.new("Frame", MainFrame)
InfoPanel.Size = UDim2.new(1, -20, 1, -50)
InfoPanel.Position = UDim2.new(0, 10, 0, 40)
InfoPanel.BackgroundTransparency = 1

local SpawnLabel = Instance.new("TextLabel", InfoPanel)
SpawnLabel.Size = UDim2.new(1, 0, 0, 25)
SpawnLabel.Text = "Dragon Talon: Đang kiểm tra..."
SpawnLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpawnLabel.Font = Enum.Font.GothamBold
SpawnLabel.BackgroundTransparency = 1
SpawnLabel.TextSize = 13
SpawnLabel.TextXAlignment = Enum.TextXAlignment.Left

ActionStatus = Instance.new("TextLabel", InfoPanel)
ActionStatus.Size = UDim2.new(1, 0, 0, 25)
ActionStatus.Position = UDim2.new(0, 0, 0, 25)
ActionStatus.Text = "Hành động: Khởi động kịch bản..."
ActionStatus.TextColor3 = Color3.fromRGB(200, 200, 200)
ActionStatus.Font = Enum.Font.Gotham
ActionStatus.BackgroundTransparency = 1
ActionStatus.TextSize = 12
ActionStatus.TextXAlignment = Enum.TextXAlignment.Left

local MasteryLabel = Instance.new("TextLabel", InfoPanel)
MasteryLabel.Size = UDim2.new(1, 0, 0, 25)
MasteryLabel.Position = UDim2.new(0, 0, 0, 50)
MasteryLabel.Text = "Mastery: Chờ xác nhận vũ khí..."
MasteryLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
MasteryLabel.Font = Enum.Font.GothamBold
MasteryLabel.BackgroundTransparency = 1
MasteryLabel.TextSize = 13
MasteryLabel.TextXAlignment = Enum.TextXAlignment.Left

-- ==========================================
-- [ PHẦN 4 ] MAIN AUTO LOGIC
-- ==========================================

TPTradeBtn.MouseButton1Click:Connect(function()
    task.spawn(function()
        ActionStatus.Text = "Hành động: Đang bay đến bàn Trade..."
        TPTradeBtn.Text = "Đang bay..."
        TweenTo(Trade_CFrame)
        TPTradeBtn.Text = "TP Trade"
        ActionStatus.Text = "Hành động: Đã đến khu Trade!"
    end)
end)

task.spawn(function()
    while true do
        if CheckDragonTalon() then
            local currentMastery = GetWeaponMastery("Dragon Talon")
            MasteryLabel.Text = "Mastery: " .. currentMastery .. "/500"
            if currentMastery >= 500 then
                MasteryLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            else
                MasteryLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
            end
        else
            MasteryLabel.Text = "Mastery: Đang đợi lấy vũ khí..."
            MasteryLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        end
        task.wait(1)
    end
end)

task.spawn(function()
    while true do
        if CheckDragonTalon() then
            SpawnLabel.Text = "Dragon Talon: Đã sở hữu"
            SpawnLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            break 
        else
            SpawnLabel.Text = "Dragon Talon: Chưa có"
            SpawnLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
            ActionStatus.Text = "Hành động: Đang bay đến mua Dragon Talon..."
            TweenTo(Uzoth_CFrame)
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDragonTalon")
        end
        task.wait(5)
    end
end)

local hubLoaded = false
task.spawn(function()
    repeat task.wait(1) until CheckDragonTalon()
    if not hubLoaded then
        hubLoaded = true
        local currentMastery = GetWeaponMastery("Dragon Talon")
        ActionStatus.Text = "Hành động: Đang khởi tạo Banana Hub..."
        task.wait(3)
        
        getgenv().Key = "51e126ee832d3c4fff7b6178" 
        getgenv().NewUI = true
        
        if currentMastery < 500 then
            getgenv().Config = {
                ["Select Method Farm"] = "Farm Bones",
                ["Start Farm"] = true
            }
        else
            getgenv().Config = {
                ["Select Method Farm"] = "Farm Bones",
                ["Start Farm"] = false,
                ["Auto Quest Dojo Trainer"] = true,
                ["Select Zone"] = "Zone 6",
                ["Select Boat"] = "Brigade"
                ["Select Sea Events"] = {
                         ["Shark"] = true,
                         ["Terrorshark"] = true,
                         ["Piranha"] = true,
                         ["Ship"] = true,
                    }
            }
        end
        loadstring(game:HttpGet("https://raw.githubusercontent.com/obiiyeuem/vthangsitink/main/BananaHub.lua"))()
        ActionStatus.Text = "Hành động: Banana Hub đã load xong!"
    end
end)
