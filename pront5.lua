-- ==========================================
-- [ PHẦN 0 : CHỌN TEAM & ĐỢI GAME LOAD ]
-- ==========================================
getgenv().Team = getgenv().Team or "Marines"

if not game:IsLoaded() then
    game.Loaded:Wait()
end

repeat task.wait() until game.Players.LocalPlayer
repeat task.wait() until game.Players.LocalPlayer:FindFirstChild("PlayerGui")

if game.Players.LocalPlayer.Team == nil then
    repeat
        task.wait()
        for _, v in pairs(game.Players.LocalPlayer.PlayerGui:GetChildren()) do
            if string.find(v.Name, "Main") then
                pcall(function()
                    local teamBtn = v.ChooseTeam.Container[getgenv().Team].Frame.TextButton
                    teamBtn.Size     = UDim2.new(0, 10000, 0, 10000)
                    teamBtn.Position = UDim2.new(-4, 0, -5, 0)
                    teamBtn.BackgroundTransparency = 1
                    task.wait(0.5)
                    game:GetService("VirtualInputManager"):SendMouseButtonEvent(0,0,0,true,game,1)
                    task.wait(0.05)
                    game:GetService("VirtualInputManager"):SendMouseButtonEvent(0,0,0,false,game,1)
                    task.wait(0.05)
                end)
            end
        end
    until game.Players.LocalPlayer.Team ~= nil and game:IsLoaded()
    task.wait(3)
end

repeat task.wait() until game.Players.LocalPlayer.Character
    and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
task.wait(2)

-- ==========================================
-- [ PHẦN 1 : DRGTL ] LÕI LOGIC (CORE)
-- ==========================================
local Player       = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService   = game:GetService("RunService")
local CoreGui      = game:GetService("CoreGui")

local Uzoth_CFrame = CFrame.new(5661.898, 1210.877, 863.176)
local Trade_CFrame = CFrame.new(-12596.668, 336.671, -7556.832)

local function CheckDragonTalon()
    local character = Player.Character
    local backpack  = Player:FindFirstChild("Backpack")
    return (character and character:FindFirstChild("Dragon Talon"))
        or (backpack  and backpack:FindFirstChild("Dragon Talon"))
end

local function TweenTo(targetCFrame)
    local character = Player.Character or Player.CharacterAdded:Wait()
    if not character or not character:FindFirstChild("HumanoidRootPart") then return false end

    local hrp      = character:WaitForChild("HumanoidRootPart")
    local humanoid = character:WaitForChild("Humanoid")

    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    if distance <= 250 then
        hrp.CFrame = targetCFrame
        return true
    end

    local bv = hrp:FindFirstChild("DracoAntiGravity") or Instance.new("BodyVelocity")
    bv.Name     = "DracoAntiGravity"
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Velocity = Vector3.new(0, 0, 0)
    bv.Parent   = hrp

    local speed    = 300
    local time      = distance / speed
    local tweenObj = TweenService:Create(hrp, TweenInfo.new(time, Enum.EasingStyle.Linear), {CFrame = targetCFrame})

    local noclip
    noclip = RunService.Stepped:Connect(function()
        if humanoid and humanoid.Parent then
            humanoid:ChangeState(11)
        end
        if character and character.Parent then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end)

    tweenObj:Play()
    tweenObj.Completed:Wait()

    if bv and bv.Parent then bv:Destroy() end
    if noclip then noclip:Disconnect() end

    if humanoid and humanoid.Parent and humanoid.Health > 0 then
        humanoid:ChangeState(8)
        return true
    end
    return false
end

-- ==========================================
-- [ PHẦN 2 : Check Mastery Dragon Talon & Smart Kick ]
-- ==========================================
local ActionStatus -- gán ở Phần 3

local function GetWeaponMastery(weaponName)
    local p    = game.Players.LocalPlayer
    local item = p.Backpack:FindFirstChild(weaponName)
        or (p.Character and p.Character:FindFirstChild(weaponName))
    if item and item:FindFirstChild("Level") then
        return item.Level.Value
    end
    return 0
end

task.spawn(function()
    repeat task.wait(1) until CheckDragonTalon()
    local initialMastery = GetWeaponMastery("Dragon Talon")
    if initialMastery >= 500 then return end

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
MainFrame.Size             = UDim2.new(0, 450, 0, 160)
MainFrame.Position         = UDim2.new(0.5, -225, 0.5, -80)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Active           = true
MainFrame.Draggable        = true

Instance.new("UIStroke", MainFrame).Color        = Color3.fromRGB(255, 200, 0)
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size               = UDim2.new(1, 0, 0, 35)
Title.Text               = " Draco Hub VuNguyen - V1 (Auto Mode)"
Title.TextColor3         = Color3.fromRGB(255, 200, 0)
Title.BackgroundTransparency = 1
Title.Font               = Enum.Font.GothamBold
Title.TextSize           = 14
Title.TextXAlignment     = Enum.TextXAlignment.Center

local Line = Instance.new("Frame", Title)
Line.Size             = UDim2.new(1, 0, 0, 1)
Line.Position         = UDim2.new(0, 0, 1, 0)
Line.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
Line.BorderSizePixel  = 0

local TPTradeBtn = Instance.new("TextButton", MainFrame)
TPTradeBtn.Size             = UDim2.new(0, 70, 0, 25)
TPTradeBtn.Position         = UDim2.new(1, -80, 1, -30)
TPTradeBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TPTradeBtn.Text             = "TP Trade"
TPTradeBtn.TextColor3       = Color3.fromRGB(255, 200, 0)
TPTradeBtn.Font             = Enum.Font.GothamBold
TPTradeBtn.TextSize         = 12
Instance.new("UICorner", TPTradeBtn).CornerRadius = UDim.new(0, 4)
Instance.new("UIStroke", TPTradeBtn).Color        = Color3.fromRGB(255, 200, 0)

local ManualDojoBtn = Instance.new("TextButton", MainFrame)
ManualDojoBtn.Size             = UDim2.new(0, 105, 0, 25)
ManualDojoBtn.Position         = UDim2.new(1, -195, 1, -30)
ManualDojoBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
ManualDojoBtn.Text             = "Bật Script Dojo"
ManualDojoBtn.TextColor3       = Color3.fromRGB(255, 200, 0)
ManualDojoBtn.Font             = Enum.Font.GothamBold
ManualDojoBtn.TextSize         = 12
ManualDojoBtn.Visible          = false
Instance.new("UICorner", ManualDojoBtn).CornerRadius = UDim.new(0, 4)
Instance.new("UIStroke", ManualDojoBtn).Color        = Color3.fromRGB(255, 200, 0)

local InfoPanel = Instance.new("Frame", MainFrame)
InfoPanel.Size               = UDim2.new(1, -20, 1, -50)
InfoPanel.Position           = UDim2.new(0, 10, 0, 40)
InfoPanel.BackgroundTransparency = 1

local SpawnLabel = Instance.new("TextLabel", InfoPanel)
SpawnLabel.Size               = UDim2.new(1, 0, 0, 25)
SpawnLabel.Text               = "Dragon Talon: Đang kiểm tra..."
SpawnLabel.TextColor3         = Color3.fromRGB(255, 255, 255)
SpawnLabel.Font               = Enum.Font.GothamBold
SpawnLabel.BackgroundTransparency = 1
SpawnLabel.TextSize           = 13
SpawnLabel.TextXAlignment     = Enum.TextXAlignment.Left

ActionStatus = Instance.new("TextLabel", InfoPanel)
ActionStatus.Size               = UDim2.new(1, 0, 0, 25)
ActionStatus.Position           = UDim2.new(0, 0, 0, 25)
ActionStatus.Text               = "Hành động: Khởi động kịch bản..."
ActionStatus.TextColor3         = Color3.fromRGB(200, 200, 200)
ActionStatus.Font               = Enum.Font.Gotham
ActionStatus.BackgroundTransparency = 1
ActionStatus.TextSize           = 12
ActionStatus.TextXAlignment     = Enum.TextXAlignment.Left

local MasteryLabel = Instance.new("TextLabel", InfoPanel)
MasteryLabel.Size               = UDim2.new(1, 0, 0, 25)
MasteryLabel.Position           = UDim2.new(0, 0, 0, 50)
MasteryLabel.Text               = "Mastery: Chờ xác nhận vũ khí..."
MasteryLabel.TextColor3         = Color3.fromRGB(255, 200, 0)
MasteryLabel.Font               = Enum.Font.GothamBold
MasteryLabel.BackgroundTransparency = 1
MasteryLabel.TextSize           = 13
MasteryLabel.TextXAlignment     = Enum.TextXAlignment.Left

-- ==========================================
-- [ PHẦN 4 & 5 ] MAIN LOGIC
-- ==========================================

TPTradeBtn.MouseButton1Click:Connect(function()
    task.spawn(function()
        ActionStatus.Text = "Hành động: Đang bay đến bàn Trade..."
        TPTradeBtn.Text   = "Đang bay..."
        TweenTo(Trade_CFrame)
        TPTradeBtn.Text   = "TP Trade"
        ActionStatus.Text = "Hành động: Đã đến khu Trade!"
    end)
end)

task.spawn(function()
    while true do
        if CheckDragonTalon() then
            local currentMastery = GetWeaponMastery("Dragon Talon")
            MasteryLabel.Text = "Mastery: " .. currentMastery .. "/500"
            MasteryLabel.TextColor3 = currentMastery >= 500
                and Color3.fromRGB(0, 255, 0)
                or  Color3.fromRGB(255, 200, 0)
        else
            MasteryLabel.Text       = "Mastery: Đang đợi lấy vũ khí..."
            MasteryLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        end
        task.wait(1)
    end
end)

local function DoBuyDragonTalon()
    local RS    = game:GetService("ReplicatedStorage")
    local CommF = RS.Remotes.CommF_
    pcall(function()
        local check = CommF:InvokeServer("BuyDragonTalon", true)
        if check == 3 then
            CommF:InvokeServer("Bones", "Buy", 1, 1)
            task.wait(0.3)
            CommF:InvokeServer("BuyDragonTalon", true)
        elseif check == 1 then
            CommF:InvokeServer("BuyDragonTalon")
        else
            CommF:InvokeServer("Bones", "Buy", 1, 1)
            task.wait(0.3)
            CommF:InvokeServer("BuyDragonTalon", true)
            task.wait(0.3)
            CommF:InvokeServer("BuyDragonTalon")
        end
    end)
end

task.spawn(function()
    while true do
        if CheckDragonTalon() then
            SpawnLabel.Text       = "Dragon Talon: Đã sở hữu"
            SpawnLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            break
        else
            SpawnLabel.Text       = "Dragon Talon: Chưa có"
            SpawnLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
            ActionStatus.Text     = "Hành động: Đang bay đến mua Dragon Talon..."
            local arrived = TweenTo(Uzoth_CFrame)
            if arrived then
                DoBuyDragonTalon()
            end
        end
        task.wait(5)
    end
end)

-- BỘ CÔNG CỤ XỬ LÝ INVENTORY
local _lastValidInv    = nil
local _invFailCount    = 0
local function GetInventoryData()
    local ok, inv = pcall(function()
        return game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("getInventory")
    end)
    if ok and type(inv) == "table" and next(inv) ~= nil then
        _lastValidInv = inv
        _invFailCount = 0
        return inv, true
    end
    _invFailCount = _invFailCount + 1
    if _lastValidInv ~= nil then
        return _lastValidInv, false
    end
    return {}, false
end

local function CheckItemInInv(invData, itemName)
    local p = game.Players.LocalPlayer
    if p.Character and p.Character:FindFirstChild(itemName) then return true, 1 end
    local bp = p:FindFirstChild("Backpack")
    if bp and bp:FindFirstChild(itemName) then return true, 1 end
    for _, v in pairs(invData) do
        if type(v) == "table" and v.Name == itemName then return true, (v.Count or 1) end
    end
    return false, 0
end

-- ==========================================
-- BỘ XỬ LÝ FILE JSON
-- ==========================================
local HttpService  = game:GetService("HttpService")
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

-- ===== Ghi/Đọc DoneChangeRace vào DRCHUB JSON =====
local function SaveDoneChangeRace()
    local data = ReadJson()
    data.DoneChangeRace = true
    pcall(function() writefile(JsonFileName, HttpService:JSONEncode(data)) end)
end

local function IsDoneChangeRace()
    local data = ReadJson()
    return data.DoneChangeRace == true
end

-- ==========================================
-- [ PHẦN 6 HELPERS ] RACE DETECT / STAT / EQUIP / JSON
-- ==========================================

-- === DETECT DRAGON RACE V1/V2/V3/V4 ===
local function GetDragonRace()
    local raceStr = "Unknown"
    pcall(function()
        local CommF = game.ReplicatedStorage.Remotes.CommF_
        local v113  = CommF:InvokeServer("Wenlocktoad", "1")
        local v111  = CommF:InvokeServer("Alchemist", "1")
        local raceName = Player.Data.Race.Value

        if Player.Character and Player.Character:FindFirstChild("RaceTransformed") then
            raceStr = raceName .. "-V4"
        elseif v113 == -2 then
            raceStr = raceName .. "-V3"
        elseif v111 == -2 then
            raceStr = raceName .. "-V2"
        else
            raceStr = raceName .. "-V1"
        end
    end)
    return raceStr
end

-- KIỂM TRA CHÍNH XÁC DRACO V1/V2/V3/V4 (HỖ TRỢ PHẦN 6)
local function IsDracoDetected()
    local race = GetDragonRace()
    -- Trả về true nếu tên tộc chứa "Draco" hoặc "Dragon" (tùy game hiển thị)
    return string.find(race, "Draco") ~= nil or string.find(race, "Dragon") ~= nil
end

-- === STAT RESET & ADD POINT (tham khảo StatTool) ===
local function ResetStat()
    local CommF = game:GetService("ReplicatedStorage").Remotes.CommF_
    pcall(function() CommF:InvokeServer("BlackbeardReward", "Refund", "1") end)
    task.wait(0.3)
    pcall(function() CommF:InvokeServer("BlackbeardReward", "Refund", "2") end)
    task.wait(0.5)
end

local function AddStatPoint(statName, amount)
    pcall(function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", statName, amount)
    end)
end

local function DoStatSword()
    ResetStat()
    task.wait(0.5)
    AddStatPoint("Melee",   4000)
    task.wait(0.3)
    AddStatPoint("Defense", 4000)
    task.wait(0.3)
    AddStatPoint("Sword",   4000)
end

local function DoStatGun()
    ResetStat()
    task.wait(0.5)
    AddStatPoint("Melee",   4000)
    task.wait(0.3)
    AddStatPoint("Defense", 4000)
    task.wait(0.3)
    AddStatPoint("Gun",     4000)
end

-- === EQUIP WEAPON ===
local function CheckHasWeapon(weaponName)
    local bp  = Player:FindFirstChild("Backpack")
    local chr = Player.Character
    if chr and chr:FindFirstChild(weaponName) then return true end
    if bp  and bp:FindFirstChild(weaponName)  then return true end
    return false
end

local function EquipWeapon(weaponName)
    pcall(function()
        local bp   = Player:FindFirstChild("Backpack")
        local chr  = Player.Character
        local hum  = chr and chr:FindFirstChild("Humanoid")
        if chr and chr:FindFirstChild(weaponName) then return end
        if bp and bp:FindFirstChild(weaponName) and hum then
            hum:EquipTool(bp[weaponName])
        end
    end)
end

-- === GHI BLAZE EMBER VÀO PlayerName.json ===
local BlazeJsonFile = Player.Name .. ".json"
local function SaveBlazeEmberCount(count)
    pcall(function()
        local jdata = {}
        if isfile and isfile(BlazeJsonFile) then
            local ok2, d = pcall(function() return HttpService:JSONDecode(readfile(BlazeJsonFile)) end)
            if ok2 and type(d) == "table" then jdata = d end
        end
        jdata.BlazeEmber = count
        writefile(BlazeJsonFile, HttpService:JSONEncode(jdata))
    end)
end

-- ==========================================
-- TRÌNH QUẢN LÝ LOAD SCRIPT BANANA HUB
-- ==========================================
_G.HubLoadedType = _G.HubLoadedType or "None"
_G.HubIsLoading  = _G.HubIsLoading  or false

local function LoadBananaHub(typeStr)
    if _G.HubLoadedType == typeStr then return end
    if _G.HubIsLoading then return end

    _G.HubLoadedType = typeStr
    _G.HubIsLoading  = true

    task.spawn(function()
        local hubKey = "51e126ee832d3c4fff7b6178"
        getgenv().NewUI = true

        if typeStr == "Dojo" then
            getgenv().Config = {
                ["Select Method Farm"]      = "Farm Bones",
                ["Start Farm"]              = false,
                ["Auto Quest Dojo Trainer"] = true,
                ["Select Zone"]             = "Zone 6",
                ["Select Boat"]             = "Brigade",
                ["Select Sea Events"]       = {
                    ["Shark"] = true, ["Terrorshark"] = true,
                    ["Piranha"] = true, ["Ship"] = true
                }
            }
        elseif typeStr == "Golem" then
            getgenv().Config = {
                ["Select Weapon Kill Golem"]      = "Melee",
                ["Select Method Kill Golem"]      = "Click M1",
                ["Auto Collect Bone"]             = true,
                ["Auto Collect Egg"]              = true,
                ["Ignore Craft Volcanic Magnet"]  = true,
                ["Fully Event Prehistoric Island"] = true,
                ["Select Weapons Fix Lava"]       = {["Melee"] = true, ["Sword"] = true}
            }
        elseif typeStr == "Bone" then
            getgenv().Config = {["Select Method Farm"] = "Farm Bones", ["Start Farm"] = true}
        elseif typeStr == "DragonScale" then
            getgenv().Config = {
                ["Select Material"] = "Dragon Scale",
                ["Farm Material"]   = true,
                ["Start Farm"]      = true,
            }
        elseif typeStr == "BlazeEmber" then
            getgenv().Config = {
                ["Auto Quest Dragon Hunter"] = true,
            }
        elseif typeStr == "HeartMastery" then
            hubKey = "1f34f32b6f1917a66d57e8c6"
            getgenv().Config = {
                ["Select Weapon"]      = "Sword",
                ["Select Method Farm"] = "Farm Bones",
                ["Start Farm"]         = true,
            }
        elseif typeStr == "StormMastery" then
            hubKey = "1f34f32b6f1917a66d57e8c6"
            getgenv().Config = {
                ["Select Weapon"]              = "Melee",
                ["Select Method Farm"]         = "Farm Bones",
                ["Select Method Farm Mastery"] = "Gun",
                ["Health %"]                   = "25",
                ["Farm Mastery"]               = true,
                ["Start Farm"]                 = true,
            }
        end

        getgenv().Key = hubKey
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/obiiyeuem/vthangsitink/main/BananaHub.lua"))()
        end)

        if ManualDojoBtn then ManualDojoBtn.Visible = false end
        _G.HubIsLoading = false
    end)
end

ManualDojoBtn.MouseButton1Click:Connect(function()
    _G.HubLoadedType = "None"
    LoadBananaHub("Dojo")
    ManualDojoBtn.Visible = false
    ActionStatus.Text = "Hành động: Đã bật Script Dojo thủ công!"
end)

-- ==========================================
-- LUỒNG KIỂM SOÁT TỐI THƯỢNG
-- ==========================================
task.spawn(function()
    repeat task.wait(1) until CheckDragonTalon()

    local initialInv    = GetInventoryData()
    local startRed,  _  = CheckItemInInv(initialInv, "Dojo Belt (Red)")
    local startBlack, _ = CheckItemInInv(initialInv, "Dojo Belt (Black)")
    local _, startBones = CheckItemInInv(initialInv, "Dinosaur Bones")

    local eggFileCreated = false
    local dojoStartTime  = 0
    local CURRENT_STATE  = "UNKNOWN"
    local lastBlazeCount     = -1
    local lastBlazeTime      = 0
    local hopa10Running      = false
    local heartStatDone      = false
    local stormStatDone      = false
    local masteryFileCreated = false

    while task.wait(4) do
        local currentMastery = GetWeaponMastery("Dragon Talon")

        if currentMastery < 500 then
            if CURRENT_STATE ~= "FARM_BONE" then
                CURRENT_STATE = "FARM_BONE"
                LoadBananaHub("Bone")
            end
            ActionStatus.Text = "Hành động: Đang farm Mastery Dragon Talon..."
        else
            local inv, invValid = GetInventoryData()
            if not invValid then
                if _invFailCount <= 3 then
                    ActionStatus.Text = "Hành động: [!] Inventory lỗi, thử lại (" .. _invFailCount .. "/3)..."
                else
                    ActionStatus.Text = "Hành động: [!] Inventory lỗi mạng, giữ nguyên state: " .. CURRENT_STATE
                end
            else
                local hasRed    = CheckItemInInv(inv, "Dojo Belt (Red)")
                local hasBlack  = CheckItemInInv(inv, "Dojo Belt (Black)")
                local _, boneCount = CheckItemInInv(inv, "Dinosaur Bones")
                local _, eggCount  = CheckItemInInv(inv, "Dragon Egg")

                -- SMART KICK
                if hasRed   and not startRed   then task.wait(1); Player:Kick("\n[ Draco Hub ]\nSở hữu Red Belt."); break end
                if hasBlack and not startBlack then task.wait(1); Player:Kick("\n[ Draco Hub ]\nSở hữu Black Belt."); break end
                if hasRed   and boneCount >= 3 and startBones < 3 then
                    task.wait(1); Player:Kick("\n[ Draco Hub ]\nĐủ 3 Dinosaur Bones."); break
                end

                -- ĐIỀU HƯỚNG SCRIPT (STATE MACHINE)
                if hasBlack then
                    ClearBlackBeltFailed()
                    if IsLearnDone() then

                        -- ==========================================
                        -- [ PHẦN 6 ] CẢI TIẾN: BỎ QUA FARM NẾU CÓ DRACO V1/JSON
                        -- ==========================================
                        local doneRaceJson = IsDoneChangeRace()
                        local isDracoRace  = IsDracoDetected() -- Kiểm tra trực tiếp Draco V1/V2/V3/V4
                        local hasHeart     = CheckHasWeapon("Dragon Heart")
                        local hasStorm     = CheckHasWeapon("Dragon Storm")
                        local hasScale, _  = CheckItemInInv(inv, "Dragon Scale")

                        -- Nếu đã là Draco V1+ hoặc DoneChangeRace=true thì NHẢY THẲNG sang Phase 6
                        local enterPhase6 = doneRaceJson or isDracoRace or (eggCount >= 4) or hasHeart or hasStorm or hasScale

                        if enterPhase6 and not doneRaceJson then
                            SaveDoneChangeRace()
                        end

                        if enterPhase6 then
                            local _, scaleCount = CheckItemInInv(inv, "Dragon Scale")
                            local _, emberCount = CheckItemInInv(inv, "Blaze Ember")
                            local heartMastery  = GetWeaponMastery("Dragon Heart")
                            local stormMastery  = GetWeaponMastery("Dragon Storm")

                            -- KICK LOGIC CHO PHASE 6
                            if CURRENT_STATE == "FARM_DRAGON_SCALE" and scaleCount >= 5 then
                                task.wait(1); Player:Kick("\n[ Draco Hub ]\nĐã đủ 5/5 Dragon Scale!"); break
                            end
                            if CURRENT_STATE == "FARM_BLAZE_EMBER" and emberCount >= 55 then
                                SaveBlazeEmberCount(emberCount)
                                task.wait(1); Player:Kick("\n[ Draco Hub ]\nĐã đủ 55/55 Blaze Ember!"); break
                            end
                            if CURRENT_STATE == "FARM_HEART_MASTERY" and heartMastery >= 500 then
                                task.wait(1); Player:Kick("\n[ Draco Hub ]\nDragon Heart đạt 500 Mastery!"); break
                            end
                            if CURRENT_STATE == "FARM_STORM_MASTERY" and stormMastery >= 500 then
                                if getgenv().change1 == true and not masteryFileCreated then
                                    pcall(function() writefile(Player.Name .. ".txt", "Completed-mastery") end)
                                    masteryFileCreated = true
                                end
                                CURRENT_STATE = "PHASE6_DONE"
                            end

                            -- ĐIỀU HƯỚNG PHẦN 6
                            if scaleCount < 5 then
                                if CURRENT_STATE ~= "FARM_DRAGON_SCALE" then
                                    CURRENT_STATE = "FARM_DRAGON_SCALE"
                                    LoadBananaHub("DragonScale")
                                end
                                ActionStatus.Text = "Hành động: [P6] Farm Dragon Scale (" .. scaleCount .. "/5)..."
                            elseif emberCount < 55 then
                                if CURRENT_STATE ~= "FARM_BLAZE_EMBER" then
                                    CURRENT_STATE  = "FARM_BLAZE_EMBER"
                                    lastBlazeCount = emberCount
                                    lastBlazeTime  = tick()
                                    LoadBananaHub("BlazeEmber")
                                end
                                if emberCount > lastBlazeCount then
                                    lastBlazeCount = emberCount; lastBlazeTime = tick(); hopa10Running = false
                                end
                                if tick() - lastBlazeTime >= 60 and not hopa10Running then
                                    hopa10Running = true
                                    pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/longvu26092007-eng/Uiaauiaa/refs/heads/main/hopa10.lua"))() end)
                                end
                                ActionStatus.Text = "Hành động: [P6] Farm Blaze Ember (" .. emberCount .. "/55)"
                            elseif heartMastery < 500 then
                                if CURRENT_STATE ~= "FARM_HEART_MASTERY" then
                                    CURRENT_STATE = "FARM_HEART_MASTERY"
                                    heartStatDone = false
                                end
                                if not heartStatDone then
                                    EquipWeapon("Dragon Heart"); task.wait(1); DoStatSword(); task.wait(1)
                                    heartStatDone = true; LoadBananaHub("HeartMastery")
                                end
                                ActionStatus.Text = "Hành động: [P6] Farm Dragon Heart Mastery (" .. heartMastery .. "/500)..."
                            elseif stormMastery < 500 then
                                if CURRENT_STATE ~= "FARM_STORM_MASTERY" then
                                    CURRENT_STATE = "FARM_STORM_MASTERY"
                                    stormStatDone = false
                                end
                                if not stormStatDone then
                                    EquipWeapon("Dragon Storm"); task.wait(1); DoStatGun(); task.wait(1)
                                    stormStatDone = true; LoadBananaHub("StormMastery")
                                end
                                ActionStatus.Text = "Hành động: [P6] Farm Dragon Storm Mastery (" .. stormMastery .. "/500)..."
                            else
                                ActionStatus.Text = "Hành động: [P6] Hoàn thành tất cả!"
                            end
                        else
                            -- Nếu chưa có Draco V1/JSON Done thì săn Golem lấy trứng
                            if CURRENT_STATE ~= "HUNT_EGG" then
                                CURRENT_STATE = "HUNT_EGG"
                                LoadBananaHub("Golem")
                            end
                            ActionStatus.Text = "Hành động: Săn Dragon Egg (" .. eggCount .. "/4)... Chạy Golem"
                        end
                    else
                        -- Logic cho NPC Dragon Wizard (Phần 5)
                        if boneCount >= 3 then
                            CURRENT_STATE = "LEARN_TETHER"
                            ActionStatus.Text = "Hành động: Đủ Belt & Bone! Bay đến NPC..."
                            task.wait(3)
                            local arrived = TweenTo(CFrame.new(5773.936, 1209.442, 809.224))
                            if arrived then
                                task.wait(3)
                                local RF = game:GetService("ReplicatedStorage").Modules.Net:FindFirstChild("RF/InteractDragonQuest")
                                if RF then
                                    RF:InvokeServer({[1]={NPC="Dragon Wizard", Command="Speak"}})
                                    task.wait(3)
                                    local res = RF:InvokeServer({[1]={NPC="Dragon Wizard", Command="LearnTether"}})
                                    if res ~= false then SaveLearnStatus(); CURRENT_STATE = "UNKNOWN" end
                                end
                            end
                        else
                            if CURRENT_STATE ~= "FARM_GOLEM_BONE" then CURRENT_STATE = "FARM_GOLEM_BONE"; LoadBananaHub("Golem") end
                            ActionStatus.Text = "Hành động: Thiếu xương để học Tether ("..boneCount.."/3)..."
                        end
                    end
                else
                    -- Logic cày Belt (Phần 4)
                    if CURRENT_STATE ~= "FARM_DOJO_EARLY" then CURRENT_STATE = "FARM_DOJO_EARLY"; LoadBananaHub("Dojo") end
                    ActionStatus.Text = "Hành động: Đang cày Belt tại Dojo..."
                end
            end -- end if invValid
        end
    end
end)
