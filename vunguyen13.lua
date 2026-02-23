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

task.spawn(function()
    repeat task.wait(1) until CheckDragonTalon()
    local initialMastery = GetWeaponMastery("Dragon Talon")
    
    if initialMastery >= 500 then
        return 
    end

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
TPTradeBtn.Position = UDim2.new(1, -80, 1, -30)
TPTradeBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TPTradeBtn.Text = "TP Trade"
TPTradeBtn.TextColor3 = Color3.fromRGB(255, 200, 0)
TPTradeBtn.Font = Enum.Font.GothamBold
TPTradeBtn.TextSize = 12
Instance.new("UICorner", TPTradeBtn).CornerRadius = UDim.new(0, 4)
Instance.new("UIStroke", TPTradeBtn).Color = Color3.fromRGB(255, 200, 0)

local ManualDojoBtn = Instance.new("TextButton", MainFrame)
ManualDojoBtn.Size = UDim2.new(0, 105, 0, 25)
ManualDojoBtn.Position = UDim2.new(1, -195, 1, -30)
ManualDojoBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
ManualDojoBtn.Text = "Bật Script Dojo"
ManualDojoBtn.TextColor3 = Color3.fromRGB(255, 200, 0)
ManualDojoBtn.Font = Enum.Font.GothamBold
ManualDojoBtn.TextSize = 12
ManualDojoBtn.Visible = false
Instance.new("UICorner", ManualDojoBtn).CornerRadius = UDim.new(0, 4)
Instance.new("UIStroke", ManualDojoBtn).Color = Color3.fromRGB(255, 200, 0)

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
-- [ PHẦN 5 ] DETECT DOJO BELT & MATERIAL
-- CHỈNH SỬA & NÂNG CẤP BỞI VŨ NGUYỄN
-- ==========================================

-- 1. Hàm kiểm tra Đai (Belt)
local function CheckDojoBelt(beltName)
    local p = game.Players.LocalPlayer
    if p.Character and p.Character:FindFirstChild(beltName) then return true end
    if p:WaitForChild("Backpack"):FindFirstChild(beltName) then return true end
    
    local ok, inv = pcall(function() return game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("getInventory") end)
    if ok and type(inv) == "table" then
        for _, v in pairs(inv) do
            if type(v) == "table" and v.Name == beltName then
                return true
            end
        end
    end
    return false
end

-- 2. Hàm đếm số lượng nguyên liệu (Dinosaur Bones)
local function GetMaterialCount(matName)
    local ok, inv = pcall(function() return game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("getInventory") end)
    if ok and type(inv) == "table" then
        for _, v in pairs(inv) do
            if type(v) == "table" and v.Name == matName then
                return v.Count or 1
            end
        end
    end
    return 0
end

-- ==========================================
-- [ PHẦN 4 ] MAIN AUTO LOGIC (TÍCH HỢP ĐIỀU KIỆN PHẦN 5)
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

_G.hubLoaded = false

-- Hàm chạy kịch bản Banana Dojo (Tím, Hoặc khi đủ Xương)
local function LoadBananaHubDojo()
    if not _G.hubLoaded then
        _G.hubLoaded = true
        ActionStatus.Text = "Hành động: Đang tải Banana Hub (Dojo)..."
        task.wait(2)
        
        repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer 
        getgenv().Key = "51e126ee832d3c4fff7b6178" 
        getgenv().NewUI = true
        getgenv().Config = {
            ["Select Method Farm"] = "Farm Bones",
            ["Start Farm"] = false,
            ["Auto Quest Dojo Trainer"] = true,
            ["Select Zone"] = "Zone 6",
            ["Select Boat"] = "Brigade",
            ["Select Sea Events"] = {
                ["Shark"] = true,
                ["Terrorshark"] = true,
                ["Piranha"] = true,
                ["Ship"] = true
            }
        }
        
        loadstring(game:HttpGet("https://raw.githubusercontent.com/obiiyeuem/vthangsitink/main/BananaHub.lua"))()
        ActionStatus.Text = "Hành động: Banana Hub (Dojo) đã load xong!"
        ManualDojoBtn.Visible = false
    end
end

-- Hàm chạy kịch bản Golem Event (Săn xương / Khi đã có Black Belt)
local function LoadBananaHubGolem()
    if not _G.hubLoaded then
        _G.hubLoaded = true
        ActionStatus.Text = "Hành động: Đang tải Banana Hub (Golem)..."
        getgenv().Key = "51e126ee832d3c4fff7b6178" 
        getgenv().NewUI = true
        getgenv().Config = {
            ["Select Weapon Kill Golem"] = "Melee",
            ["Select Method Kill Golem"] = "Click M1",
            ["Auto Collect Bone"] = true,
            ["Auto Collect Egg"] = true,
            ["Ignore Craft Volcanic Magnet"] = true,
            ["Fully Event Prehistoric Island"] = true,
            ["Select Weapons Fix Lava"] = {
                ["Melee"] = true,
                ["Sword"] = true
            }
        }
        loadstring(game:HttpGet("https://raw.githubusercontent.com/obiiyeuem/vthangsitink/main/BananaHub.lua"))()
        ActionStatus.Text = "Hành động: Banana Hub Event (Golem) đã Load!"
    end
end

ManualDojoBtn.MouseButton1Click:Connect(LoadBananaHubDojo)

-- LUỒNG KIỂM TRA CHÍNH LỒNG GHÉP LOGIC PHẦN 5
task.spawn(function()
    repeat task.wait(1) until CheckDragonTalon()
    
    local currentMastery = GetWeaponMastery("Dragon Talon")
    
    if currentMastery < 500 then
        -- AUTO FARM BONE NẾU CHƯA ĐỦ MASTERY
        if not _G.hubLoaded then
            _G.hubLoaded = true
            ActionStatus.Text = "Hành động: Đang khởi tạo Banana Hub (Farm Bone)..."
            task.wait(3)
            
            repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer 
            getgenv().Key = "51e126ee832d3c4fff7b6178" 
            getgenv().NewUI = true
            getgenv().Config = {
                ["Select Method Farm"] = "Farm Bones",
                ["Start Farm"] = true
            }
            loadstring(game:HttpGet("https://raw.githubusercontent.com/obiiyeuem/vthangsitink/main/BananaHub.lua"))()
            ActionStatus.Text = "Hành động: Banana Hub (Farm Bone) đã load xong!"
        end
    else
        -- KHI ĐÃ ĐẠT 500 MASTERY: VÒNG LẶP KIỂM TRA ĐAI VÀ NGUYÊN LIỆU (PHẦN 5)
        while task.wait(1) do
            local hasWhite = CheckDojoBelt("Dojo Belt (White)")
            local hasYellow = CheckDojoBelt("Dojo Belt (Yellow)")
            local hasOrange = CheckDojoBelt("Dojo Belt (Orange)")
            local hasPurple = CheckDojoBelt("Dojo Belt (Purple)")
            local hasRed = CheckDojoBelt("Dojo Belt (Red)")
            local hasBlack = CheckDojoBelt("Dojo Belt (Black)")

            -- 1. NẾU ĐÃ CÓ BLACK BELT: KÍCH HOẠT GOLEM LẦN CUỐI
            if hasBlack then
                ActionStatus.Text = "Hành động: Đã có Black Belt! Đang chờ 5s chạy Golem..."
                task.wait(5)
                LoadBananaHubGolem()
                break -- Kết thúc hoàn toàn vòng lặp

            -- 2. NẾU CÓ RED NHƯNG CHƯA CÓ BLACK
            elseif hasRed and not hasBlack then
                local boneCount = GetMaterialCount("Dinosaur Bones")
                
                -- TRƯỜNG HỢP A: ĐÃ CÓ 3 ĐẾN 5 XƯƠNG -> CHẠY DOJO NHƯ LÚC PURPLE & CHECK BLACK
                if boneCount >= 3 then
                    ActionStatus.Text = "Hành động: Red Belt + " .. boneCount .. " Bones! Farm Dojo & Check Black (4s)..."
                    LoadBananaHubDojo()

                    -- Vòng lặp check đai Đen mỗi 4 giây
                    repeat
                        task.wait(4)
                        hasBlack = CheckDojoBelt("Dojo Belt (Black)")
                    until hasBlack or not game.Players.LocalPlayer

                    if hasBlack then
                        ActionStatus.Text = "Hành động: ĐÃ CÓ BLACK BELT! ĐANG KICK..."
                        ActionStatus.TextColor3 = Color3.fromRGB(0, 255, 0)
                        task.wait(2)
                        game.Players.LocalPlayer:Kick("\n[ Draco Hub ]\nChúc mừng! Bạn đã sở hữu Black Belt.\nLý do: Đã đủ điều kiện, Kick để Rejoin chạy Golem Event.")
                        break
                    end
                
                -- TRƯỜNG HỢP B: CHƯA ĐỦ 3 XƯƠNG -> CHẠY GOLEM & CHECK XƯƠNG MỖI 10 GIÂY
                else
                    ActionStatus.Text = "Hành động: Red Belt! Khởi chạy Script Golem săn Bones..."
                    task.wait(5)
                    LoadBananaHubGolem()

                    -- Vòng lặp check Xương Khủng Long mỗi 10 giây
                    repeat
                        task.wait(10)
                        boneCount = GetMaterialCount("Dinosaur Bones")
                        if ActionStatus then 
                            ActionStatus.Text = "Hành động: Đang săn Dinosaur Bones (" .. boneCount .. "/3)..." 
                        end
                    until boneCount >= 3 or not game.Players.LocalPlayer

                    if boneCount >= 3 then
                        ActionStatus.Text = "Hành động: ĐÃ ĐỦ 3 DINOSAUR BONES! ĐANG KICK..."
                        ActionStatus.TextColor3 = Color3.fromRGB(0, 255, 0)
                        task.wait(2)
                        game.Players.LocalPlayer:Kick("\n[ Draco Hub ]\nĐã thu thập đủ Dinosaur Bones (" .. boneCount .. "/3).\nLý do: Kick để Rejoin chuyển sang Farm Black Belt.")
                        break
                    end
                end

            -- 3. NẾU CÓ PURPLE NHƯNG CHƯA CÓ RED (Vòng lặp check Red mỗi 15s)
            elseif hasPurple and not hasRed then
                ActionStatus.Text = "Hành động: Đã có Purple! Đang đợi săn Red Belt (Check 15s)..."
                ActionStatus.TextColor3 = Color3.fromRGB(255, 255, 0)
                LoadBananaHubDojo()

                repeat 
                    task.wait(15) 
                    hasRed = CheckDojoBelt("Dojo Belt (Red)")
                until hasRed or not game.Players.LocalPlayer

                if hasRed then
                    ActionStatus.Text = "Hành động: ĐÃ CÓ RED BELT! ĐANG KICK..."
                    ActionStatus.TextColor3 = Color3.fromRGB(0, 255, 0)
                    task.wait(2)
                    game.Players.LocalPlayer:Kick("\n[ Draco Hub ]\nChúc mừng! Đã sở hữu Red Belt.\nLý do: Kick để Rejoin nhận diện đai mới.\nScript sẽ tự động chạy cấu hình Golem sau 5 giây.")
                    break
                end

            -- 4. BẢO VỆ ORANGE BELT
            elseif hasWhite and hasYellow and not hasOrange then
                ActionStatus.Text = "Tạm dừng Auto Dojo vì thiếu Orange Belt. Hãy bật thủ công!"
                ActionStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
                ManualDojoBtn.Visible = true
                break

            -- 5. CÁC TRƯỜNG HỢP CÒN LẠI (Chưa có gì, Green, Blue)
            else
                LoadBananaHubDojo()
                task.wait(5) -- Tránh lag vòng lặp khi đang chạy các đai thấp
            end
        end
    end
end)
