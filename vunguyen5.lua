-- [[ CONFIG ]]
getgenv().Team = "Marines"

-- ==========================================
-- [ PHAN 0 : AUTO JOIN TEAM & LOAD GAME ]
-- ==========================================
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Luong spam chon team cho den khi thanh cong
task.spawn(function()
    local Player = game.Players.LocalPlayer
    while task.wait(0.5) do
        if Player.Team ~= nil then
            break
        end
        pcall(function()
            -- Gui lenh chon team
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", getgenv().Team)
            
            -- An bang ChooseTeam de tranh ket giao dien
            if Player:FindFirstChild("PlayerGui") and Player.PlayerGui:FindFirstChild("Main") then
                local ct = Player.PlayerGui.Main:FindFirstChild("ChooseTeam")
                if ct then ct.Visible = false end
            end
        end)
    end
end)

-- Doi nhan vat spawn
repeat task.wait() until game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
task.wait(2)

-- ==========================================
-- [ PHAN 1 : DRGTL ] LOI LOGIC (CORE)
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
    return (character and character:FindFirstChild("Dragon Talon")) or (backpack and backpack:FindFirstChild("Backpack"):FindFirstChild("Dragon Talon")) or (backpack and backpack:FindFirstChild("Dragon Talon"))
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
-- [ PHAN 2 : Check Mastery Dragon Talon ]
-- ==========================================
local function GetWeaponMastery(weaponName)
    local character = Player.Character
    local backpack = Player:WaitForChild("Backpack")
    local item = (character and character:FindFirstChild(weaponName)) or (backpack and backpack:FindFirstChild(weaponName))
    if item and item:FindFirstChild("Level") then
        return item.Level.Value
    end
    return 0 
end

-- ==========================================
-- [ PHAN 3 ] GIAO DIEN MONITOR (VANG - DEN)
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
SpawnLabel.Text = "Dragon Talon: Checking..."
SpawnLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpawnLabel.Font = Enum.Font.GothamBold
SpawnLabel.BackgroundTransparency = 1
SpawnLabel.TextSize = 13

local ActionStatus = Instance.new("TextLabel", InfoPanel)
ActionStatus.Size = UDim2.new(1, 0, 0, 25)
ActionStatus.Position = UDim2.new(0, 0, 0, 25)
ActionStatus.Text = "Action: Starting..."
ActionStatus.TextColor3 = Color3.fromRGB(200, 200, 200)
ActionStatus.Font = Enum.Font.Gotham
ActionStatus.BackgroundTransparency = 1
ActionStatus.TextSize = 12

local MasteryLabel = Instance.new("TextLabel", InfoPanel)
MasteryLabel.Size = UDim2.new(1, 0, 0, 25)
MasteryLabel.Position = UDim2.new(0, 0, 0, 50)
MasteryLabel.Text = "Mastery: Waiting..."
MasteryLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
MasteryLabel.Font = Enum.Font.GothamBold
MasteryLabel.BackgroundTransparency = 1
MasteryLabel.TextSize = 13

-- ==========================================
-- [ PHAN 4 ] MAIN AUTO LOGIC
-- ==========================================

TPTradeBtn.MouseButton1Click:Connect(function()
    task.spawn(function()
        ActionStatus.Text = "Hanh dong: Dang bay den ban Trade..."
        TweenTo(Trade_CFrame)
        ActionStatus.Text = "Hanh dong: Da den khu Trade!"
    end)
end)

task.spawn(function()
    while true do
        if CheckDragonTalon() then
            SpawnLabel.Text = "Dragon Talon: Da so huu"
            SpawnLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            break 
        else
            SpawnLabel.Text = "Dragon Talon: Chua co"
            SpawnLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
            ActionStatus.Text = "Hanh dong: Dang bay den NPC Uzoth..."
            TweenTo(Uzoth_CFrame)
            task.wait(0.5)
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDragonTalon")
            task.wait(5)
        end
        task.wait(1)
    end
end)

local bananaLoaded = false
task.spawn(function()
    while not bananaLoaded do
        if CheckDragonTalon() then
            local currentMastery = GetWeaponMastery("Dragon Talon")
            MasteryLabel.Text = "Mastery: " .. currentMastery .. "/500"
            task.wait(3)
            
            getgenv().Key = "51e126ee832d3c4fff7b6178" 
            getgenv().NewUI = true
            getgenv().Config = {
                ["Select Method Farm"] = "Farm Bones",
                ["Start Farm"] = (currentMastery < 500),
                ["Auto Quest Dojo Trainer"] = (currentMastery >= 500)
            }
            loadstring(game:HttpGet("https://raw.githubusercontent.com/obiiyeuem/vthangsitink/main/BananaHub.lua"))()
            bananaLoaded = true
            break 
        end
        task.wait(2)
    end
end)
