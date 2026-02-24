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
-- [ PHẦN 4 & 5 ] MAIN LOGIC & DETECT DOJO BELT (ĐÃ THÊM FAILSAFE 3 PHÚT)
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

-- BỘ CÔNG CỤ XỬ LÝ INVENTORY KHÔNG GÂY LAG
local function GetInventoryData()
    local ok, inv = pcall(function() 
        return game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("getInventory") 
    end)
    if ok and type(inv) == "table" then return inv end
    return {}
end

local function CheckItemInInv(invData, itemName)
    local p = game.Players.LocalPlayer
    if p.Character and p.Character:FindFirstChild(itemName) then return true, 1 end
    if p:WaitForChild("Backpack"):FindFirstChild(itemName) then return true, 1 end
    for _, v in pairs(invData) do
        if type(v) == "table" and v.Name == itemName then return true, (v.Count or 1) end
    end
    return false, 0
end

-- ==========================================
-- BỘ XỬ LÝ FILE JSON (DRAGON WIZARD & FAILSAFE BLACK BELT)
-- ==========================================
local HttpService = game:GetService("HttpService")
local JsonFileName = "DRCHUB_" .. Player.Name .. ".json"

local function ReadJson()
    if isfile and isfile(JsonFileName) then
        local ok, data = pcall(function() return HttpService:JSONDecode(readfile(JsonFileName)) end)
        if ok and type(data) == "table" then return data end
    end
    return {}
end

local function SaveLearnStatus()
    local data = ReadJson()
    data.Status = "StatusLearnDone"
    pcall(function() writefile(JsonFileName, HttpService:JSONEncode(data)) end)
end

local function IsLearnDone()
    local data = ReadJson()
    return data.Status == "StatusLearnDone"
end

-- Lưu trạng thái 3 phút tạch Black Belt
local function SaveBlackBeltFailed(bCount)
    local data = ReadJson()
    data.NotDoneBlack = bCount
    pcall(function() writefile(JsonFileName, HttpService:JSONEncode(data)) end)
end

local function GetBlackBeltFailed()
    local data = ReadJson()
    return data.NotDoneBlack
end

local function ClearBlackBeltFailed()
    local data = ReadJson()
    if data.NotDoneBlack then
        data.NotDoneBlack = nil
        pcall(function() writefile(JsonFileName, HttpService:JSONEncode(data)) end)
    end
end

-- TRÌNH QUẢN LÝ LOAD SCRIPT BANANA HUB
_G.HubLoadedType = _G.HubLoadedType or "None"
local function LoadBananaHub(typeStr)
    if _G.HubLoadedType == typeStr then return end
    _G.HubLoadedType = typeStr
    
    task.spawn(function()
        getgenv().Key = "51e126ee832d3c4fff7b6178" 
        getgenv().NewUI = true
        
        if typeStr == "Dojo" then
            getgenv().Config = {
                ["Select Method Farm"] = "Farm Bones", ["Start Farm"] = false, ["Auto Quest Dojo Trainer"] = true,
                ["Select Zone"] = "Zone 6", ["Select Boat"] = "Brigade",
                ["Select Sea Events"] = {["Shark"] = true, ["Terrorshark"] = true, ["Piranha"] = true, ["Ship"] = true}
            }
        elseif typeStr == "Golem" then
            getgenv().Config = {
                ["Select Weapon Kill Golem"] = "Melee", ["Select Method Kill Golem"] = "Click M1",
                ["Auto Collect Bone"] = true, ["Auto Collect Egg"] = true, ["Ignore Craft Volcanic Magnet"] = true,
                ["Fully Event Prehistoric Island"] = true,
                ["Select Weapons Fix Lava"] = {["Melee"] = true, ["Sword"] = true}
            }
        elseif typeStr == "Bone" then
            getgenv().Config = {["Select Method Farm"] = "Farm Bones", ["Start Farm"] = true}
        end
        
        pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/obiiyeuem/vthangsitink/main/BananaHub.lua"))() end)
        if ManualDojoBtn then ManualDojoBtn.Visible = false end
    end)
end

-- LUỒNG KIỂM SOÁT TỐI THƯỢNG
task.spawn(function()
    repeat task.wait(1) until CheckDragonTalon()
    
    local initialInv = GetInventoryData()
    local startRed, _ = CheckItemInInv(initialInv, "Dojo Belt (Red)")
    local startBlack, _ = CheckItemInInv(initialInv, "Dojo Belt (Black)")
    local _, startBones = CheckItemInInv(initialInv, "Dinosaur Bones")
    
    local eggFileCreated = false 
    local dojoStartTime = 0 -- Bộ đếm 3 phút Dojo
    
    while task.wait(4) do
        local currentMastery = GetWeaponMastery("Dragon Talon")
        
        if currentMastery < 500 then
            LoadBananaHub("Bone")
        else
            local inv = GetInventoryData()
            local hasWhite = CheckItemInInv(inv, "Dojo Belt (White)")
            local hasYellow = CheckItemInInv(inv, "Dojo Belt (Yellow)")
            local hasOrange = CheckItemInInv(inv, "Dojo Belt (Orange)")
            local hasPurple = CheckItemInInv(inv, "Dojo Belt (Purple)")
            local hasRed = CheckItemInInv(inv, "Dojo Belt (Red)")
            local hasBlack = CheckItemInInv(inv, "Dojo Belt (Black)")
            local _, boneCount = CheckItemInInv(inv, "Dinosaur Bones")
            local _, eggCount = CheckItemInInv(inv, "Dragon Egg") 
            
            -- SMART KICK
            if hasRed and not startRed then task.wait(1); Player:Kick("\n[ Draco Hub ]\nSở hữu Red Belt."); break end
            if hasRed and boneCount >= 3 and startBones < 3 then task.wait(1); Player:Kick("\n[ Draco Hub ]\nĐủ 3 Bones."); break end
            if hasBlack and not startBlack then task.wait(1); Player:Kick("\n[ Draco Hub ]\nSở hữu Black Belt."); break end

            startRed = hasRed; startBones = boneCount; startBlack = hasBlack
            
            -- ======================================
            -- ĐIỀU HƯỚNG SCRIPT
            -- ======================================
            if hasBlack then
                ClearBlackBeltFailed() -- Đã lấy được thì xóa biến fail (nếu có)
                if IsLearnDone() then
                    if eggCount >= 4 then
                        ActionStatus.Text = "Hành động: Đã đủ 4/4 Dragon Egg! Đã tạo file txt."
                        if not eggFileCreated then
                            pcall(function() writefile(Player.Name .. ".txt", "Completed-Draegg") end)
                            eggFileCreated = true
                        end
                    else
                        ActionStatus.Text = "Hành động: Săn Dragon Egg (" .. eggCount .. "/4)... Chạy Golem"
                        LoadBananaHub("Golem")
                    end
                else
                    if boneCount >= 3 then
                        ActionStatus.Text = "Hành động: Đủ Black Belt & Bones! Delay 3s Tween..."
                        task.wait(3)
                        
                        TweenTo(CFrame.new(5773.936035, 1209.442871, 809.224548))
                        
                        ActionStatus.Text = "Hành động: Đã tới NPC. Delay 3s trước khi Speak..."
                        task.wait(3)
                        
                        local Net = game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net")
                        local RF = Net:FindFirstChild("RF/InteractDragonQuest") or Net["RF/InteractDragonQuest"]
                        
                        if RF then
                            local v371_Speak = { [1] = { NPC = "Dragon Wizard", Command = "Speak" } }
                            pcall(function() RF:InvokeServer(unpack(v371_Speak)) end)
                            
                            task.wait(3)
                            
                            local v371_Learn = { [1] = { NPC = "Dragon Wizard", Command = "LearnTether" } }
                            local ok, _ = pcall(function() return RF:InvokeServer(unpack(v371_Learn)) end)
                            
                            if ok then
                                ActionStatus.Text = "Hành động: Học thành công! Delay 3s lưu file..."
                                task.wait(3)
                                SaveLearnStatus()
                                ActionStatus.Text = "Hành động: Đã lưu! Chuyển sang check Dragon Egg..."
                            end
                        end
                    else
                        ActionStatus.Text = "Hành động: Có Black Belt nhưng thiếu xương ("..boneCount.."/3). Farm tiếp..."
                        LoadBananaHub("Golem")
                    end
                end
            elseif hasRed then
                local failedBones = GetBlackBeltFailed()
                
                if failedBones then
                    -- Rejoin đang bù Bone vì quá 3 phút tạch Black Belt
                    if boneCount >= failedBones + 3 then
                        ClearBlackBeltFailed()
                        task.wait(1)
                        Player:Kick("\n[ Draco Hub ]\nĐã farm đủ Bone bù. Tiến hành Kick để bật lại Banana Dojo!")
                        break
                    else
                        dojoStartTime = 0 -- Tránh bị đếm lại thời gian lúc bù
                        ActionStatus.Text = "Hành động: Bù Bone vì Dojo fail ("..boneCount.."/"..(failedBones + 3).."). Chạy Golem..."
                        LoadBananaHub("Golem")
                    end
                else
                    -- Farm Dojo bình thường
                    if boneCount >= 3 then 
                        if dojoStartTime == 0 then dojoStartTime = tick() end -- Bắt đầu bấm giờ
                        
                        if tick() - dojoStartTime >= 180 then -- QUÁ 3 PHÚT (180 GIÂY)
                            SaveBlackBeltFailed(boneCount)
                            task.wait(1)
                            Player:Kick("\n[ Draco Hub ]\nFarm Dojo 3 phút không ra Black Belt. Kick để farm bù Bone!")
                            break
                        else
                            local timeLeft = math.max(0, math.floor(180 - (tick() - dojoStartTime)))
                            ActionStatus.Text = "Hành động: Farm Dojo & Check Black (" .. timeLeft .. "s)..."
                            LoadBananaHub("Dojo")
                        end
                    else 
                        dojoStartTime = 0 -- Reset bộ đếm nếu xương bị tụt dưới 3
                        ActionStatus.Text = "Hành động: Săn Dinosaur Bones (" .. boneCount .. "/3)..."
                        LoadBananaHub("Golem") 
                    end
                end
            elseif hasPurple then 
                ActionStatus.Text = "Hành động: Săn Red Belt..."; LoadBananaHub("Dojo")
            elseif hasWhite and hasYellow and not hasOrange then
                ActionStatus.Text = "Thiếu Orange Belt. Bật thủ công!"; if ManualDojoBtn then ManualDojoBtn.Visible = true end
            else 
                LoadBananaHub("Dojo") 
            end
        end
    end
end)
