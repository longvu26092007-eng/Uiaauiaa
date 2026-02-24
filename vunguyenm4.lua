-- ==========================================
-- [ PHẦN 0 : CHỌN TEAM & ĐỢI GAME LOAD ]
-- ==========================================
-- FIX #1: Dùng VirtualInputManager click thực sự thay vì CommF_ SetTeam
-- Lý do: CommF_ SetTeam thường bị server reject nếu UI ChooseTeam chưa active
-- Tham khảo: autobuydraco.txt (pattern đúng được xác nhận hoạt động)

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
    local backpack  = Player:WaitForChild("Backpack")
    return (character and character:FindFirstChild("Dragon Talon"))
        or (backpack  and backpack:FindFirstChild("Dragon Talon"))
end

-- FIX #2: TweenTo kiểm tra character còn sống trước và sau khi tween
-- Lý do: Nếu chết giữa chừng, hrp cũ bị destroy → tween "complete" giả
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

    -- Kiểm tra character vẫn còn sau tween
    if humanoid and humanoid.Parent and humanoid.Health > 0 then
        humanoid:ChangeState(8)
        return true
    end
    return false -- Trả về false nếu chết giữa chừng
end

-- Helper: Check character còn sống
local function IsAlive()
    local char = Player.Character
    if not char then return false end
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return false end
    return hum.Health > 0
end

-- ==========================================
-- [ PHẦN 2 : Check Mastery Dragon Talon & Smart Kick ]
-- ==========================================

-- FIX #3: Khai báo ActionStatus là local TRƯỚC khi dùng ở task.spawn phía dưới
-- Lý do: Phần 2 chạy song song với Phần 3, nếu Phần 3 chưa tạo UI thì ActionStatus = nil
local ActionStatus  -- sẽ được gán giá trị ở Phần 3

-- FIX #5-NEW: Flag để mastery kick loop biết khi nào KHÔNG nên kick
-- Lý do: Loop Phần 2 chạy độc lập, có thể kick giữa lúc LEARN_TETHER
local _pastFarmBone = false  -- true = đã qua giai đoạn farm mastery, đừng kick nữa

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
    if initialMastery >= 500 then
        _pastFarmBone = true  -- đã đủ mastery từ đầu, không cần kick
        return
    end

    while task.wait(3) do
        -- FIX #5-NEW: Nếu state machine đã chuyển qua giai đoạn khác, dừng loop này
        if _pastFarmBone then break end

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
MainFrame.Size            = UDim2.new(0, 450, 0, 160)
MainFrame.Position        = UDim2.new(0.5, -225, 0.5, -80)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Active          = true

-- FIX #4-DRAG: Tự viết drag thay vì Draggable (deprecated)
do
    local dragging, dragStart, startPos
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            dragStart = input.Position
            startPos  = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    MainFrame.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

Instance.new("UIStroke", MainFrame).Color     = Color3.fromRGB(255, 200, 0)
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
Line.Size            = UDim2.new(1, 0, 0, 1)
Line.Position        = UDim2.new(0, 0, 1, 0)
Line.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
Line.BorderSizePixel = 0

local TPTradeBtn = Instance.new("TextButton", MainFrame)
TPTradeBtn.Size            = UDim2.new(0, 70, 0, 25)
TPTradeBtn.Position        = UDim2.new(1, -80, 1, -30)
TPTradeBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TPTradeBtn.Text            = "TP Trade"
TPTradeBtn.TextColor3      = Color3.fromRGB(255, 200, 0)
TPTradeBtn.Font            = Enum.Font.GothamBold
TPTradeBtn.TextSize        = 12
Instance.new("UICorner", TPTradeBtn).CornerRadius = UDim.new(0, 4)
Instance.new("UIStroke", TPTradeBtn).Color        = Color3.fromRGB(255, 200, 0)

local ManualDojoBtn = Instance.new("TextButton", MainFrame)
ManualDojoBtn.Size            = UDim2.new(0, 105, 0, 25)
ManualDojoBtn.Position        = UDim2.new(1, -195, 1, -30)
ManualDojoBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
ManualDojoBtn.Text            = "Bật Script Dojo"
ManualDojoBtn.TextColor3      = Color3.fromRGB(255, 200, 0)
ManualDojoBtn.Font            = Enum.Font.GothamBold
ManualDojoBtn.TextSize        = 12
ManualDojoBtn.Visible         = false
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

-- FIX #3 tiếp: Gán vào biến local đã khai báo từ Phần 2
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
        ActionStatus.Text  = "Hành động: Đang bay đến bàn Trade..."
        TPTradeBtn.Text    = "Đang bay..."
        TweenTo(Trade_CFrame)
        TPTradeBtn.Text    = "TP Trade"
        ActionStatus.Text  = "Hành động: Đã đến khu Trade!"
    end)
end)

-- FIX #4-BTN: Thêm click handler cho ManualDojoBtn
ManualDojoBtn.MouseButton1Click:Connect(function()
    task.spawn(function()
        LoadBananaHub("Dojo")
        ActionStatus.Text = "Hành động: Đã bật Dojo thủ công!"
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

-- FIX #4: BuyDragonTalon - gọi Bones Buy trước, sau đó mới BuyDragonTalon (không argument)
-- Lý do: Server yêu cầu check Bones trước khi unlock Dragon Talon
-- Tham khảo: Bone Hub (New_Text_Document__3_.txt) dòng 11341
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
                pcall(function()
                    local RS = game:GetService("ReplicatedStorage")
                    RS.Remotes.CommF_:InvokeServer("Bones", "Buy", 1, 1) -- Mua bone trước
                    task.wait(0.3)
                    RS.Remotes.CommF_:InvokeServer("BuyDragonTalon")     -- Sau đó mới unlock
                end)
            end
        end
        task.wait(5)
    end
end)

-- BỘ CÔNG CỤ XỬ LÝ INVENTORY
-- FIX #5: Cache inventory hợp lệ cuối cùng, tránh execute sai branch khi remote fail
local _lastValidInv = {}
local function GetInventoryData()
    local ok, inv = pcall(function()
        return game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("getInventory")
    end)
    if ok and type(inv) == "table" and next(inv) ~= nil then
        _lastValidInv = inv
        return inv, true  -- trả về inv + flag isValid
    end
    return _lastValidInv, false  -- trả về cache + flag isValid=false
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

-- ==========================================
-- [ PHẦN 6 HELPER ] GHI BLAZE EMBER VÀO JSON
-- ==========================================
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

-- FIX #6: LoadBananaHub - thêm bảo vệ chống 2 hub chạy song song
-- Lý do: Gọi "Dojo" rồi 4s sau gọi "Golem" → cả hai cùng chạy, xung đột _G
_G.HubLoadedType   = _G.HubLoadedType or "None"
_G.HubIsLoading    = _G.HubIsLoading  or false  -- FIX: flag đang load

local function LoadBananaHub(typeStr)
    if _G.HubLoadedType == typeStr then return end
    if _G.HubIsLoading then return end  -- FIX: đang load dở, bỏ qua

    _G.HubLoadedType = typeStr
    _G.HubIsLoading  = true

    task.spawn(function()
        getgenv().Key   = "51e126ee832d3c4fff7b6178"
        getgenv().NewUI = true

        if typeStr == "Dojo" then
            getgenv().Config = {
                ["Select Method Farm"]     = "Farm Bones",
                ["Start Farm"]             = false,
                ["Auto Quest Dojo Trainer"] = true,
                ["Select Zone"]            = "Zone 6",
                ["Select Boat"]            = "Brigade",
                ["Select Sea Events"]      = {
                    ["Shark"] = true, ["Terrorshark"] = true,
                    ["Piranha"] = true, ["Ship"] = true
                }
            }
        elseif typeStr == "Golem" then
            getgenv().Config = {
                ["Select Weapon Kill Golem"]  = "Melee",
                ["Select Method Kill Golem"]  = "Click M1",
                ["Auto Collect Bone"]         = true,
                ["Auto Collect Egg"]          = true,
                ["Ignore Craft Volcanic Magnet"] = true,
                ["Fully Event Prehistoric Island"] = true,
                ["Select Weapons Fix Lava"]   = {["Melee"] = true, ["Sword"] = true}
            }
        elseif typeStr == "Bone" then
            getgenv().Config = {["Select Method Farm"] = "Farm Bones", ["Start Farm"] = true}

        -- ========== PHẦN 6: CÁC CONFIG MỚI ==========
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
        end

        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/obiiyeuem/vthangsitink/main/BananaHub.lua"))()
        end)

        if ManualDojoBtn then ManualDojoBtn.Visible = false end
        _G.HubIsLoading = false  -- FIX: reset flag sau khi load xong
    end)
end

-- ==========================================
-- LUỒNG KIỂM SOÁT TỐI THƯỢNG
-- ==========================================
task.spawn(function()
    repeat task.wait(1) until CheckDragonTalon()

    local initialInv    = GetInventoryData()
    -- FIX #7: startRed/startBlack/startBones KHÔNG được cập nhật trong vòng lặp
    -- Lý do: Chúng là "baseline đầu session" để Smart Kick phát hiện thay đổi MỚI
    local startRed,  _  = CheckItemInInv(initialInv, "Dojo Belt (Red)")
    local startBlack, _ = CheckItemInInv(initialInv, "Dojo Belt (Black)")
    local _, startBones = CheckItemInInv(initialInv, "Dinosaur Bones")

    local eggFileCreated = false
    local dojoStartTime  = 0

    -- [ PHẦN 6 ] Biến theo dõi Blaze Ember stall detection
    local lastBlazeCount = -1   -- số Blaze Ember lần check trước
    local lastBlazeTime  = 0    -- tick() lần cuối Blaze Ember tăng
    local hopa10Running  = false -- flag tránh chạy hopa10 nhiều lần

    -- FIX #8: STATE machine đơn giản - ngăn execute sai nhánh khi inv fail
    local CURRENT_STATE = "UNKNOWN"

    while task.wait(4) do
        local currentMastery = GetWeaponMastery("Dragon Talon")

        if currentMastery < 500 then
            if CURRENT_STATE ~= "FARM_BONE" then
                CURRENT_STATE = "FARM_BONE"
                LoadBananaHub("Bone")
            end
            ActionStatus.Text = "Hành động: Đang farm Mastery Dragon Talon..."

        else
            -- FIX #5-NEW: Báo cho mastery kick loop dừng lại
            _pastFarmBone = true

            -- FIX #1-NEW: Thay continue bằng if/end block
            -- Lý do: continue không tồn tại trên nhiều executor Lua 5.1
            local inv, invValid = GetInventoryData()
            if not invValid then
                ActionStatus.Text = "Hành động: [!] Inventory lỗi mạng, giữ nguyên state: " .. CURRENT_STATE

            else -- invValid = true → xử lý bình thường

            local hasWhite  = CheckItemInInv(inv, "Dojo Belt (White)")
            local hasYellow = CheckItemInInv(inv, "Dojo Belt (Yellow)")
            local hasOrange = CheckItemInInv(inv, "Dojo Belt (Orange)")
            local hasPurple = CheckItemInInv(inv, "Dojo Belt (Purple)")
            local hasRed    = CheckItemInInv(inv, "Dojo Belt (Red)")
            local hasBlack  = CheckItemInInv(inv, "Dojo Belt (Black)")
            local _, boneCount = CheckItemInInv(inv, "Dinosaur Bones")
            local _, eggCount  = CheckItemInInv(inv, "Dragon Egg")

            -- SMART KICK (chỉ so với baseline đầu session - KHÔNG cập nhật startX)
            if hasRed   and not startRed   then task.wait(1); Player:Kick("\n[ Draco Hub ]\nSở hữu Red Belt."); break end
            if hasBlack and not startBlack then task.wait(1); Player:Kick("\n[ Draco Hub ]\nSở hữu Black Belt."); break end
            if hasRed   and boneCount >= 3 and startBones < 3 then
                task.wait(1); Player:Kick("\n[ Draco Hub ]\nĐủ 3 Dinosaur Bones."); break
            end

            -- ==============================
            -- ĐIỀU HƯỚNG SCRIPT (STATE MACHINE)
            -- ==============================
            if hasBlack then
                ClearBlackBeltFailed()
                if IsLearnDone() then
                    if eggCount >= 4 then
                        -- Ghi file egg nếu được phép (giữ nguyên logic cũ)
                        if getgenv().change == true then
                            if not eggFileCreated then
                                pcall(function() writefile(Player.Name .. ".txt", "Completed-Draegg") end)
                                eggFileCreated = true
                            end
                        end

                        -- ==========================================
                        -- [ PHẦN 6 : GET SWORD AND GUN ]
                        -- Sau khi đủ 4 Egg → Check Dragon Scale → Check Blaze Ember
                        -- ==========================================
                        local _, scaleCount = CheckItemInInv(inv, "Dragon Scale")
                        local _, emberCount = CheckItemInInv(inv, "Blaze Ember")

                        -- KICK khi vừa đủ Dragon Scale (đang farm mà đạt 5)
                        if CURRENT_STATE == "FARM_DRAGON_SCALE" and scaleCount >= 5 then
                            task.wait(1)
                            Player:Kick("\n[ Draco Hub ]\nĐã đủ 5/5 Dragon Scale!\nKick để nhận diện bước tiếp theo.")
                            break
                        end

                        -- KICK khi vừa đủ Blaze Ember (đang farm mà đạt 55)
                        if CURRENT_STATE == "FARM_BLAZE_EMBER" and emberCount >= 55 then
                            -- Ghi lần cuối trước khi kick
                            SaveBlazeEmberCount(emberCount)
                            task.wait(1)
                            Player:Kick("\n[ Draco Hub ]\nĐã đủ 55/55 Blaze Ember!\nKick để nhận diện bước tiếp theo.")
                            break
                        end

                        -- ĐIỀU HƯỚNG PHẦN 6
                        if scaleCount < 5 then
                            -- ===== BƯỚC 1: Farm Dragon Scale =====
                            if CURRENT_STATE ~= "FARM_DRAGON_SCALE" then
                                CURRENT_STATE = "FARM_DRAGON_SCALE"
                                LoadBananaHub("DragonScale")
                            end
                            ActionStatus.Text = "Hành động: [P6] Farm Dragon Scale (" .. scaleCount .. "/5)..."

                        elseif emberCount < 55 then
                            -- ===== BƯỚC 2: Farm Blaze Ember =====
                            if CURRENT_STATE ~= "FARM_BLAZE_EMBER" then
                                CURRENT_STATE = "FARM_BLAZE_EMBER"
                                lastBlazeCount = emberCount
                                lastBlazeTime  = tick()
                                hopa10Running  = false
                                LoadBananaHub("BlazeEmber")
                            end

                            -- Ghi số lượng Blaze Ember vào NameAccount.json
                            SaveBlazeEmberCount(emberCount)

                            -- Stall detection: nếu Blaze Ember tăng → reset timer
                            if emberCount > lastBlazeCount then
                                lastBlazeCount = emberCount
                                lastBlazeTime  = tick()
                                hopa10Running  = false -- reset flag vì đã có tiến triển
                            end

                            -- Nếu 1 phút không tăng → chạy hopa10
                            if tick() - lastBlazeTime >= 60 and not hopa10Running then
                                hopa10Running = true
                                ActionStatus.Text = "Hành động: [P6] Blaze Ember kẹt 1 phút! Chạy hopa10..."
                                task.spawn(function()
                                    pcall(function()
                                        loadstring(game:HttpGet("https://raw.githubusercontent.com/longvu26092007-eng/Uiaauiaa/refs/heads/main/hopa10.lua"))()
                                    end)
                                end)
                                -- Reset timer sau khi chạy hopa10, cho 1 phút nữa trước khi chạy lại
                                lastBlazeTime = tick()
                            end

                            local stallSec = math.floor(tick() - lastBlazeTime)
                            ActionStatus.Text = "Hành động: [P6] Farm Blaze Ember (" .. emberCount .. "/55) | Stall: " .. stallSec .. "s"

                        else
                            -- ===== ĐÃ ĐỦ CẢ HAI: Dragon Scale >= 5 & Blaze Ember >= 55 =====
                            CURRENT_STATE = "PHASE6_DONE"
                            ActionStatus.Text = "Hành động: [P6] Đã đủ Dragon Scale & Blaze Ember! Chờ cập nhật Phase tiếp..."
                        end

                    else
                        if CURRENT_STATE ~= "HUNT_EGG" then
                            CURRENT_STATE = "HUNT_EGG"
                            LoadBananaHub("Golem")
                        end
                        ActionStatus.Text = "Hành động: Săn Dragon Egg (" .. eggCount .. "/4)... Chạy Golem"
                    end
                else
                    -- Chưa học tether
                    if boneCount >= 3 then
                        CURRENT_STATE = "LEARN_TETHER"
                        ActionStatus.Text = "Hành động: Đủ Black Belt & Bones! Delay 3s Tween..."
                        task.wait(3)

                        local arrived = TweenTo(CFrame.new(5773.936035, 1209.442871, 809.224548))

                        -- FIX #2 tiếp: Chỉ tiếp tục nếu TweenTo thành công (không chết)
                        if not arrived then
                            ActionStatus.Text = "Hành động: [!] Chết khi di chuyển, thử lại..."
                            CURRENT_STATE = "UNKNOWN"
                            -- FIX #1-NEW: Không dùng continue, để rơi xuống end
                        else
                            -- FIX #6-NEW: Gộp delay + check alive trước Speak & LearnTether
                            -- Cũ: task.wait(3) → Speak → task.wait(3) → Learn (6s gap không check)
                            -- Mới: task.wait(5) → check alive → Speak+Learn liên tiếp
                            ActionStatus.Text = "Hành động: Đã tới NPC. Delay 5s trước khi tương tác..."
                            task.wait(5)

                            if not IsAlive() then
                                ActionStatus.Text = "Hành động: [!] Chết khi đợi NPC, thử lại..."
                                CURRENT_STATE = "UNKNOWN"
                            else
                                local Net = game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net")
                                local RF  = Net:FindFirstChild("RF/InteractDragonQuest") or Net["RF/InteractDragonQuest"]

                                if RF then
                                    -- Speak
                                    local v371_Speak = { [1] = { NPC = "Dragon Wizard", Command = "Speak" } }
                                    pcall(function() RF:InvokeServer(unpack(v371_Speak)) end)
                                    task.wait(1)

                                    -- LearnTether (ngay sau Speak, không delay thêm 3s)
                                    local v371_Learn = { [1] = { NPC = "Dragon Wizard", Command = "LearnTether" } }
                                    local ok, result = pcall(function() return RF:InvokeServer(unpack(v371_Learn)) end)

                                    -- FIX #9: Kiểm tra result thực sự, không chỉ pcall ok
                                    local learnSuccess = ok and result ~= nil and result ~= false
                                    if learnSuccess then
                                        ActionStatus.Text = "Hành động: Học thành công! Delay 3s lưu file..."
                                        task.wait(3)
                                        SaveLearnStatus()
                                        ActionStatus.Text = "Hành động: Đã lưu! Chuyển sang check Dragon Egg..."
                                        CURRENT_STATE = "UNKNOWN"
                                    else
                                        ActionStatus.Text = "Hành động: [!] Server từ chối LearnTether, thử lại sau..."
                                        CURRENT_STATE = "UNKNOWN"
                                    end
                                else
                                    ActionStatus.Text = "Hành động: [!] Không tìm thấy RF/InteractDragonQuest!"
                                end
                            end -- IsAlive check
                        end -- arrived check
                    else
                        if CURRENT_STATE ~= "FARM_GOLEM_BONE" then
                            CURRENT_STATE = "FARM_GOLEM_BONE"
                            LoadBananaHub("Golem")
                        end
                        ActionStatus.Text = "Hành động: Có Black Belt nhưng thiếu xương ("..boneCount.."/3). Farm tiếp..."
                    end
                end

            elseif hasRed then
                local failedBones = GetBlackBeltFailed()

                if failedBones then
                    if boneCount >= failedBones + 3 then
                        ClearBlackBeltFailed()
                        task.wait(1)
                        Player:Kick("\n[ Draco Hub ]\nĐã farm đủ Bone bù. Tiến hành Kick để bật lại Banana Dojo!")
                        break
                    else
                        if CURRENT_STATE ~= "COMPENSATE_BONE" then
                            CURRENT_STATE  = "COMPENSATE_BONE"
                            dojoStartTime  = 0
                            LoadBananaHub("Golem")
                        end
                        ActionStatus.Text = "Hành động: Bù Bone vì Dojo fail ("..boneCount.."/"..(failedBones+3).."). Chạy Golem..."
                    end
                else
                    if boneCount >= 3 then
                        if dojoStartTime == 0 then dojoStartTime = tick() end

                        if tick() - dojoStartTime >= 180 then
                            SaveBlackBeltFailed(boneCount)
                            task.wait(1)
                            Player:Kick("\n[ Draco Hub ]\nFarm Dojo 3 phút không ra Black Belt. Kick để farm bù Bone!")
                            break
                        else
                            if CURRENT_STATE ~= "FARM_DOJO" then
                                CURRENT_STATE = "FARM_DOJO"
                                LoadBananaHub("Dojo")
                            end
                            local timeLeft = math.max(0, math.floor(180 - (tick() - dojoStartTime)))
                            ActionStatus.Text = "Hành động: Farm Dojo & Check Black (" .. timeLeft .. "s)..."
                        end
                    else
                        -- FIX #10: dojoStartTime chỉ reset khi KHÔNG trong mode bù bone
                        if CURRENT_STATE ~= "COMPENSATE_BONE" then
                            dojoStartTime = 0
                        end
                        if CURRENT_STATE ~= "FARM_GOLEM_RED" then
                            CURRENT_STATE = "FARM_GOLEM_RED"
                            LoadBananaHub("Golem")
                        end
                        ActionStatus.Text = "Hành động: Săn Dinosaur Bones (" .. boneCount .. "/3)..."
                    end
                end

            elseif hasPurple then
                if CURRENT_STATE ~= "FARM_DOJO_RED" then
                    CURRENT_STATE = "FARM_DOJO_RED"
                    LoadBananaHub("Dojo")
                end
                ActionStatus.Text = "Hành động: Săn Red Belt..."

            elseif hasWhite and hasYellow and not hasOrange then
                -- FIX #11: Dead end - thêm Dojo để không bị đứng
                CURRENT_STATE = "NEED_ORANGE"
                ActionStatus.Text = "Thiếu Orange Belt. Hãy bật script Dojo thủ công!"
                if ManualDojoBtn then ManualDojoBtn.Visible = true end
                if _G.HubLoadedType ~= "Dojo" then
                    LoadBananaHub("Dojo")
                end

            else
                -- Các belt thấp hơn (White, Yellow, hoặc chưa có gì)
                if CURRENT_STATE ~= "FARM_DOJO_EARLY" then
                    CURRENT_STATE = "FARM_DOJO_EARLY"
                    LoadBananaHub("Dojo")
                end
                ActionStatus.Text = "Hành động: Farm Dojo lên Belt cao hơn..."
            end

            end -- FIX #1-NEW: đóng if invValid
        end -- if currentMastery < 500
    end -- while
end)
