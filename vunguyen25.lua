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

local Uzoth_CFrame  = CFrame.new(5661.898, 1210.877, 863.176)
local Trade_CFrame  = CFrame.new(-12596.668, 336.671, -7556.832)
-- Tọa độ từ autobuydraco.txt
local Wizard_CFrame = CFrame.new(5773.936035, 1209.442871, 809.224548)
-- Tọa độ từ autobuy2items.txt
local Craft_CFrame  = CFrame.new(5864.833008, 1209.483032, 811.329224)

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
    local time     = distance / speed
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
local _lastValidInv = nil
local _invFailCount = 0
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

local function SaveDoneChangeRace()
    local data = ReadJson()
    data.DoneChangeRace = true
    pcall(function() writefile(JsonFileName, HttpService:JSONEncode(data)) end)
end

local function IsDoneChangeRace()
    local data = ReadJson()
    return data.DoneChangeRace == true
end

local function SaveDoneCraft()
    local data = ReadJson()
    data.DoneCraft = true
    pcall(function() writefile(JsonFileName, HttpService:JSONEncode(data)) end)
end

local function IsDoneCraft()
    local data = ReadJson()
    return data.DoneCraft == true
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

local function IsDracoDetected()
    local race = GetDragonRace()
    return string.find(race, "Draco") ~= nil or string.find(race, "Dragon") ~= nil
end

-- === ĐỌC STAT HIỆN TẠI TỪ Player.Data ===
local function GetStatValue(statName)
    local val = 0
    pcall(function()
        local d = Player:FindFirstChild("Data")
        if d and d:FindFirstChild(statName) then
            val = d[statName].Value
        end
    end)
    return val
end

-- [SỬA Ở ĐÂY] Kiểm tra chuẩn mốc 2800 (Max Stats hiện hành)
local function IsStatSwordBuild()
    return GetStatValue("Melee") >= 2800
       and GetStatValue("Defense") >= 2800
       and GetStatValue("Sword") >= 2800
end

local function IsStatGunBuild()
    return GetStatValue("Melee") >= 2800
       and GetStatValue("Defense") >= 2800
       and GetStatValue("Gun") >= 2800
end

-- === STAT RESET & ADD POINT ===
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

-- [SỬA Ở ĐÂY] Nếu stats đã đúng chuẩn, bỏ qua quá trình Reset và return luôn
local function DoStatSword()
    if IsStatSwordBuild() then 
        warn("[Draco Hub] Stats Kiếm đã Max (2800). Bỏ qua Reset Stats!")
        return 
    end
    warn("[Draco Hub] Stats chưa đúng bộ Kiếm. Tiến hành Reset...")
    ResetStat()
    task.wait(0.5)
    AddStatPoint("Melee",   2800)
    task.wait(0.3)
    AddStatPoint("Defense", 2800)
    task.wait(0.3)
    AddStatPoint("Sword",   2800)
end

local function DoStatGun()
    if IsStatGunBuild() then 
        warn("[Draco Hub] Stats Súng đã Max (2800). Bỏ qua Reset Stats!")
        return 
    end
    warn("[Draco Hub] Stats chưa đúng bộ Súng. Tiến hành Reset...")
    ResetStat()
    task.wait(0.5)
    AddStatPoint("Melee",   2800)
    task.wait(0.3)
    AddStatPoint("Defense", 2800)
    task.wait(0.3)
    AddStatPoint("Gun",     2800)
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
        local chr = Player.Character
        if chr and chr:FindFirstChild(weaponName) then return end
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LoadItem", weaponName)
    end)
end

-- === GHI BLAZE EMBER ===
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
-- [ PHẦN 6 ACTIONS ] ĐỔI RACE & CRAFT
-- ==========================================

local function DoChangeRace()
    local success = false
    local ok, err = pcall(function()
        local Net = game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net")
        local RF  = Net:FindFirstChild("RF/InteractDragonQuest") or Net:WaitForChild("RF/InteractDragonQuest")
        local v371 = { [1] = { NPC = "Dragon Wizard", Command = "DragonRace" } }
        RF:InvokeServer(unpack(v371))
        success = true
    end)
    if ok and success then
        warn("[DracoHub] DoChangeRace: Thành công!")
        return true
    else
        warn("[DracoHub] DoChangeRace: Thất bại!", err)
        return false
    end
end

local function DoCraftItems()
    -- Bước 1: requestEntrance
    pcall(function()
        local entrancePos = Vector3.new(5661.5322265625, 1013.0907592773438, -334.9649963378906)
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", entrancePos)
    end)
    task.wait(0.5)

    -- Bước 2: Craft bằng RF/Craft + unpack
    local RFCraft
    pcall(function()
        RFCraft = game:GetService("ReplicatedStorage")
            :WaitForChild("Modules")
            :WaitForChild("Net")
            :WaitForChild("RF/Craft")
    end)

    if not RFCraft then
        warn("[DracoHub] DoCraftItems: Không tìm thấy RF/Craft!")
        return false
    end

    -- Craft Dragonheart
    pcall(function()
        local args = { [1] = "Craft", [2] = "Dragonheart", [3] = {} }
        RFCraft:InvokeServer(unpack(args))
    end)
    task.wait(3)

    -- Craft Dragonstorm
    pcall(function()
        local args = { [1] = "Craft", [2] = "Dragonstorm", [3] = {} }
        RFCraft:InvokeServer(unpack(args))
    end)
    task.wait(2)

    return true
end

-- ==========================================
-- TRÌNH QUẢN LÝ LOAD SCRIPT BANANA HUB
-- ==========================================
_G.HubLoadedType = _G.HubLoadedType or "None"
_G.HubIsLoading  = _G.HubIsLoading  or false

local function LoadBananaHub(typeStr)
    if _G.HubLoadedType == typeStr then return end
    if _G.HubIsLoading then return end

    _G.HubIsLoading = true

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
                ["Select Weapon Kill Golem"]       = "Melee",
                ["Select Method Kill Golem"]       = "Click M1",
                ["Auto Collect Bone"]              = true,
                ["Auto Collect Egg"]               = true,
                ["Ignore Craft Volcanic Magnet"]   = true,
                ["Fully Event Prehistoric Island"] = true,
                ["Select Weapons Fix Lava"]        = {["Melee"] = true, ["Sword"] = true}
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
                ["Health %"]                   = "45",
                ["Farm Mastery"]               = true,
                ["Start Farm"]                 = true,
            }
        end

        getgenv().Key = hubKey

        local ok, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/obiiyeuem/vthangsitink/main/BananaHub.lua"))()
        end)

        if ok then
            _G.HubLoadedType = typeStr 
            warn("[BananaHub] Load thành công: " .. typeStr)
        else
            _G.HubLoadedType = "None" 
            warn("[BananaHub] Load thất bại (" .. typeStr .. "): " .. tostring(err))
        end

        _G.HubIsLoading = false

        if ManualDojoBtn then ManualDojoBtn.Visible = false end
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

    local CURRENT_STATE      = "UNKNOWN"
    local lastBlazeCount     = -1
    local lastBlazeTime      = 0
    local hopa10Running      = false
    local heartStatDone      = false
    local stormStatDone      = false
    local masteryFileCreated = false

    while task.wait(4) do
        local currentMastery = GetWeaponMastery("Dragon Talon")

        -- ===== PHASE 1: Farm Dragon Talon Mastery =====
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
                local hasRed       = CheckItemInInv(inv, "Dojo Belt (Red)")
                local hasBlack     = CheckItemInInv(inv, "Dojo Belt (Black)")
                local _, boneCount = CheckItemInInv(inv, "Dinosaur Bones")
                local _, eggCount  = CheckItemInInv(inv, "Dragon Egg")

                -- SMART KICK: Nhận Belt/Bones mới
                if hasRed   and not startRed   then task.wait(1); Player:Kick("\n[ Draco Hub ]\nSở hữu Red Belt."); break end
                if hasBlack and not startBlack then task.wait(1); Player:Kick("\n[ Draco Hub ]\nSở hữu Black Belt."); break end
                if hasRed and boneCount >= 3 and startBones < 3 then
                    task.wait(1); Player:Kick("\n[ Draco Hub ]\nĐủ 3 Dinosaur Bones."); break
                end

                -- ===== ĐIỀU HƯỚNG THEO BELT =====
                if hasBlack then
                    ClearBlackBeltFailed()

                    if IsLearnDone() then
                        -- ==========================================
                        -- [ PHẦN 6 ] SAU KHI HỌC TETHER XONG
                        -- ==========================================
                        local doneRaceJson  = IsDoneChangeRace()
                        local doneCraftJson = IsDoneCraft()
                        local hasHeart      = CheckHasWeapon("Dragonheart")
                        local hasStorm      = CheckHasWeapon("Dragonstorm")

                        if hasHeart and hasStorm and not doneCraftJson then
                            SaveDoneCraft()
                            doneCraftJson = true
                            ActionStatus.Text = "Hành động: [P6] Đã phát hiện Heart+Storm, ghi DoneCraft!"
                        end

                        if not doneRaceJson and IsDracoDetected() then
                            SaveDoneChangeRace()
                            doneRaceJson = true
                            ActionStatus.Text = "Hành động: [P6] Phát hiện tộc Draco, ghi DoneChangeRace!"
                        end

                        if doneRaceJson and doneCraftJson then
                            local heartMastery = GetWeaponMastery("Dragonheart")
                            local stormMastery = GetWeaponMastery("Dragonstorm")

                            if CURRENT_STATE == "FARM_HEART_MASTERY" and heartMastery >= 500 then
                                task.wait(1)
                                Player:Kick("\n[ Draco Hub ]\nDragonheart đạt 500 Mastery! Rejoin để farm Storm.")
                                break
                            end
                            if CURRENT_STATE == "FARM_STORM_MASTERY" and stormMastery >= 500 then
                                if getgenv().change1 == true and not masteryFileCreated then
                                    pcall(function() writefile(Player.Name .. ".txt", "Completed-mastery") end)
                                    masteryFileCreated = true
                                end
                                CURRENT_STATE = "PHASE6_DONE"
                            end

                            if heartMastery < 500 then
                                if CURRENT_STATE ~= "FARM_HEART_MASTERY" then
                                    CURRENT_STATE = "FARM_HEART_MASTERY"
                                    heartStatDone = false
                                end
                                if not heartStatDone then
                                    EquipWeapon("Dragonheart")
                                    task.wait(1)
                                    DoStatSword()
                                    task.wait(1)
                                    heartStatDone = true
                                    LoadBananaHub("HeartMastery")
                                end
                                ActionStatus.Text = "Hành động: [P6] Farm Dragonheart Mastery (" .. heartMastery .. "/500)..."

                            elseif stormMastery < 500 then
                                if CURRENT_STATE ~= "FARM_STORM_MASTERY" then
                                    CURRENT_STATE = "FARM_STORM_MASTERY"
                                    stormStatDone = false
                                end
                                if not stormStatDone then
                                    EquipWeapon("Dragonstorm")
                                    task.wait(1)
                                    DoStatGun()
                                    task.wait(1)
                                    stormStatDone = true
                                    LoadBananaHub("StormMastery")
                                end
                                ActionStatus.Text = "Hành động: [P6] Farm Dragonstorm Mastery (" .. stormMastery .. "/500)..."

                            else
                                CURRENT_STATE = "PHASE6_DONE"
                                ActionStatus.Text = "Hành động: [P6] Hoàn thành tất cả!"
                            end

                        elseif not doneRaceJson then
                            local isDracoRace = IsDracoDetected()
                            local _, scaleCountCheck = CheckItemInInv(inv, "Dragon Scale")
                            local canEnterP6 = isDracoRace or (eggCount >= 4) or hasHeart or hasStorm or (scaleCountCheck > 0)

                            if not canEnterP6 then
                                if CURRENT_STATE ~= "HUNT_EGG" then
                                    CURRENT_STATE = "HUNT_EGG"
                                    LoadBananaHub("Golem")
                                end
                                ActionStatus.Text = "Hành động: Săn Dragon Egg (" .. eggCount .. "/4)..."
                            else
                                if CURRENT_STATE ~= "DO_CHANGE_RACE" then
                                    CURRENT_STATE = "DO_CHANGE_RACE"
                                end
                                ActionStatus.Text = "Hành động: [P6] Đang bay đến Dragon Wizard đổi tộc..."
                                local arrived = TweenTo(Wizard_CFrame)
                                if arrived then
                                    task.wait(0.2)
                                    local raceOk = DoChangeRace()
                                    if raceOk then
                                        task.wait(1)
                                        SaveDoneChangeRace()
                                        ActionStatus.Text = "Hành động: [P6] Xong DragonRace! Đang Kick..."
                                        task.wait(2)
                                        Player:Kick("\n[ Draco Hub ]\nXong DragonRace! Rejoin để tiến hành Craft.")
                                        break
                                    else
                                        ActionStatus.Text = "Hành động: [P6] DragonRace thất bại, thử lại lần sau..."
                                        CURRENT_STATE = "UNKNOWN"
                                    end
                                end
                            end

                        else
                            local _, scaleCount = CheckItemInInv(inv, "Dragon Scale")
                            local _, emberCount = CheckItemInInv(inv, "Blaze Ember")

                            if scaleCount >= 5 then
                                if CURRENT_STATE == "FARM_DRAGON_SCALE" then
                                    task.wait(1)
                                    Player:Kick("\n[ Draco Hub ]\nĐã đủ 5/5 Dragon Scale! Rejoin.")
                                    break
                                end
                            end

                            if CURRENT_STATE == "FARM_BLAZE_EMBER" and emberCount >= 55 then
                                SaveBlazeEmberCount(emberCount)
                                task.wait(1)
                                Player:Kick("\n[ Draco Hub ]\nĐã đủ 55/55 Blaze Ember! Rejoin.")
                                break
                            end

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
                                    pcall(function()
                                        loadstring(game:HttpGet("https://raw.githubusercontent.com/longvu26092007-eng/Uiaauiaa/refs/heads/main/hopa10.lua"))()
                                    end)
                                end
                                ActionStatus.Text = "Hành động: [P6] Farm Blaze Ember (" .. emberCount .. "/55)..."

                            else
                                if CURRENT_STATE ~= "DO_CRAFT" then
                                    CURRENT_STATE = "DO_CRAFT"
                                end
                                ActionStatus.Text = "Hành động: [P6] Đủ nguyên liệu! Đang bay đến Craft NPC..."
                                local arrived = TweenTo(Craft_CFrame)
                                if arrived then
                                    task.wait(0.2)
                                    local craftOk = DoCraftItems()
                                    if craftOk then
                                        task.wait(3)
                                        SaveDoneCraft()
                                        ActionStatus.Text = "Hành động: [P6] Craft xong! Đang Kick..."
                                        task.wait(3)
                                        Player:Kick("\n[ Draco Hub ]\nCraft xong! Rejoin để farm Mastery.")
                                        break
                                    else
                                        ActionStatus.Text = "Hành động: [P6] Craft thất bại, thử lại..."
                                        CURRENT_STATE = "UNKNOWN"
                                    end
                                end
                            end
                        end

                    else
                        if boneCount >= 3 then
                            CURRENT_STATE = "LEARN_TETHER"
                            ActionStatus.Text = "Hành động: Đủ Belt & Bone! Bay đến NPC..."
                            task.wait(3)
                            local arrived = TweenTo(Wizard_CFrame)
                            if arrived then
                                task.wait(3)
                                local ok1, RF1 = pcall(function()
                                    return game:GetService("ReplicatedStorage")
                                        :WaitForChild("Modules")
                                        :WaitForChild("Net")
                                        :WaitForChild("RF/InteractDragonQuest")
                                end)
                                if ok1 and RF1 then
                                    pcall(function()
                                        RF1:InvokeServer(unpack({ [1] = { NPC = "Dragon Wizard", Command = "Speak" } }))
                                    end)
                                    task.wait(3)
                                    local res
                                    pcall(function()
                                        res = RF1:InvokeServer(unpack({ [1] = { NPC = "Dragon Wizard", Command = "LearnTether" } }))
                                    end)
                                    if res ~= false then
                                        SaveLearnStatus()
                                        CURRENT_STATE = "UNKNOWN"
                                        ActionStatus.Text = "Hành động: Đã học Tether! Tiếp tục Phase 6..."
                                    end
                                end
                            end
                        else
                            if CURRENT_STATE ~= "FARM_GOLEM_BONE" then
                                CURRENT_STATE = "FARM_GOLEM_BONE"
                                LoadBananaHub("Golem")
                            end
                            ActionStatus.Text = "Hành động: Thiếu xương để học Tether (" .. boneCount .. "/3)..."
                        end
                    end

                else
                    if CURRENT_STATE ~= "FARM_DOJO_EARLY" then
                        CURRENT_STATE = "FARM_DOJO_EARLY"
                        LoadBananaHub("Dojo")
                    end
                    ActionStatus.Text = "Hành động: Đang cày Belt tại Dojo..."
                end
            end 
        end
    end 
end)
