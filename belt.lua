-- ==========================================
-- [ PHẦN 0 : CHỌN TEAM & ĐỢI GAME LOAD ]
-- ==========================================
getgenv().Team = getgenv().Team or "Marines"

getgenv().fragment = getgenv().fragment ~= false and true or false

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
local Wizard_CFrame = CFrame.new(5773.936035, 1209.442871, 809.224548)

local FRAGMENT_MIN = 12000

local function GetFragments()
    local val = 0
    pcall(function() val = Player.Data.Fragments.Value end)
    return val
end

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
    if distance <= 250 then hrp.CFrame = targetCFrame return true end
    local bv = hrp:FindFirstChild("DracoAntiGravity") or Instance.new("BodyVelocity")
    bv.Name = "DracoAntiGravity"; bv.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
    bv.Velocity = Vector3.new(0,0,0); bv.Parent = hrp
    local speed = 300; local time = distance / speed
    local tweenObj = TweenService:Create(hrp, TweenInfo.new(time, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
    local noclip
    noclip = RunService.Stepped:Connect(function()
        if humanoid and humanoid.Parent then humanoid:ChangeState(11) end
        if character and character.Parent then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
            end
        end
    end)
    tweenObj:Play(); tweenObj.Completed:Wait()
    if bv and bv.Parent then bv:Destroy() end
    if noclip then noclip:Disconnect() end
    if humanoid and humanoid.Parent and humanoid.Health > 0 then humanoid:ChangeState(8) return true end
    return false
end

-- ==========================================
-- [ PHẦN 2 : Check Mastery Dragon Talon & Smart Kick ]
-- ==========================================
local ActionStatus

local function GetWeaponMastery(weaponName)
    local p = game.Players.LocalPlayer
    local item = p.Backpack:FindFirstChild(weaponName) or (p.Character and p.Character:FindFirstChild(weaponName))
    if item and item:FindFirstChild("Level") then return item.Level.Value end
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
-- [ PHẦN 3 ] GIAO DIỆN MONITOR
-- ==========================================
if CoreGui:FindFirstChild("DracoHubUI") then CoreGui.DracoHubUI:Destroy() end

local ScreenGui = Instance.new("ScreenGui", CoreGui); ScreenGui.Name = "DracoHubUI"
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0,450,0,185); MainFrame.Position = UDim2.new(0.5,-225,0.5,-92)
MainFrame.BackgroundColor3 = Color3.fromRGB(15,15,15); MainFrame.Active = true; MainFrame.Draggable = true
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(255,200,0)
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,8)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1,0,0,35); Title.Text = " Draco Hub VuNguyen - V2 (4/4 Egg = Final)"
Title.TextColor3 = Color3.fromRGB(255,200,0); Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold; Title.TextSize = 14; Title.TextXAlignment = Enum.TextXAlignment.Center
local Line = Instance.new("Frame", Title); Line.Size = UDim2.new(1,0,0,1); Line.Position = UDim2.new(0,0,1,0)
Line.BackgroundColor3 = Color3.fromRGB(255,200,0); Line.BorderSizePixel = 0

local TPTradeBtn = Instance.new("TextButton", MainFrame)
TPTradeBtn.Size = UDim2.new(0,70,0,25); TPTradeBtn.Position = UDim2.new(1,-80,1,-30)
TPTradeBtn.BackgroundColor3 = Color3.fromRGB(15,15,15); TPTradeBtn.Text = "TP Trade"
TPTradeBtn.TextColor3 = Color3.fromRGB(255,200,0); TPTradeBtn.Font = Enum.Font.GothamBold; TPTradeBtn.TextSize = 12
Instance.new("UICorner", TPTradeBtn).CornerRadius = UDim.new(0,4)
Instance.new("UIStroke", TPTradeBtn).Color = Color3.fromRGB(255,200,0)

local ManualDojoBtn = Instance.new("TextButton", MainFrame)
ManualDojoBtn.Size = UDim2.new(0,105,0,25); ManualDojoBtn.Position = UDim2.new(1,-195,1,-30)
ManualDojoBtn.BackgroundColor3 = Color3.fromRGB(15,15,15); ManualDojoBtn.Text = "Bật Script Dojo"
ManualDojoBtn.TextColor3 = Color3.fromRGB(255,200,0); ManualDojoBtn.Font = Enum.Font.GothamBold
ManualDojoBtn.TextSize = 12; ManualDojoBtn.Visible = false
Instance.new("UICorner", ManualDojoBtn).CornerRadius = UDim.new(0,4)
Instance.new("UIStroke", ManualDojoBtn).Color = Color3.fromRGB(255,200,0)

local InfoPanel = Instance.new("Frame", MainFrame)
InfoPanel.Size = UDim2.new(1,-20,1,-50); InfoPanel.Position = UDim2.new(0,10,0,40); InfoPanel.BackgroundTransparency = 1

local SpawnLabel = Instance.new("TextLabel", InfoPanel)
SpawnLabel.Size = UDim2.new(1,0,0,25); SpawnLabel.Text = "Dragon Talon: Đang kiểm tra..."
SpawnLabel.TextColor3 = Color3.fromRGB(255,255,255); SpawnLabel.Font = Enum.Font.GothamBold
SpawnLabel.BackgroundTransparency = 1; SpawnLabel.TextSize = 13; SpawnLabel.TextXAlignment = Enum.TextXAlignment.Left

ActionStatus = Instance.new("TextLabel", InfoPanel)
ActionStatus.Size = UDim2.new(1,0,0,25); ActionStatus.Position = UDim2.new(0,0,0,25)
ActionStatus.Text = "Hành động: Khởi động kịch bản..."; ActionStatus.TextColor3 = Color3.fromRGB(200,200,200)
ActionStatus.Font = Enum.Font.Gotham; ActionStatus.BackgroundTransparency = 1
ActionStatus.TextSize = 12; ActionStatus.TextXAlignment = Enum.TextXAlignment.Left

local MasteryLabel = Instance.new("TextLabel", InfoPanel)
MasteryLabel.Size = UDim2.new(1,0,0,25); MasteryLabel.Position = UDim2.new(0,0,0,50)
MasteryLabel.Text = "Mastery: Chờ xác nhận vũ khí..."; MasteryLabel.TextColor3 = Color3.fromRGB(255,200,0)
MasteryLabel.Font = Enum.Font.GothamBold; MasteryLabel.BackgroundTransparency = 1
MasteryLabel.TextSize = 13; MasteryLabel.TextXAlignment = Enum.TextXAlignment.Left

local FragmentLabel = Instance.new("TextLabel", InfoPanel)
FragmentLabel.Size = UDim2.new(1,0,0,25); FragmentLabel.Position = UDim2.new(0,0,0,75)
FragmentLabel.Text = "Fragment: Đang kiểm tra..."; FragmentLabel.TextColor3 = Color3.fromRGB(180,130,255)
FragmentLabel.Font = Enum.Font.GothamBold; FragmentLabel.BackgroundTransparency = 1
FragmentLabel.TextSize = 13; FragmentLabel.TextXAlignment = Enum.TextXAlignment.Left

-- ==========================================
-- [ PHẦN 4 & 5 ] MAIN LOGIC
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
            local m = GetWeaponMastery("Dragon Talon")
            MasteryLabel.Text = "Mastery: " .. m .. "/500"
            MasteryLabel.TextColor3 = m >= 500 and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,200,0)
        else
            MasteryLabel.Text = "Mastery: Đang đợi lấy vũ khí..."
            MasteryLabel.TextColor3 = Color3.fromRGB(255,0,0)
        end
        task.wait(1)
    end
end)

task.spawn(function()
    while true do
        local frag = GetFragments(); local toggleOn = getgenv().fragment == true
        if not toggleOn then
            FragmentLabel.Text = "Fragment: " .. frag .. " [Farm: TẮT]"
            FragmentLabel.TextColor3 = Color3.fromRGB(150,150,150)
        else
            FragmentLabel.Text = "Fragment: " .. frag .. " / " .. FRAGMENT_MIN .. " [Farm: BẬT]"
            FragmentLabel.TextColor3 = frag >= FRAGMENT_MIN and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,100,100)
        end
        task.wait(2)
    end
end)

local function DoBuyDragonTalon()
    local CommF = game:GetService("ReplicatedStorage").Remotes.CommF_
    pcall(function()
        local check = CommF:InvokeServer("BuyDragonTalon", true)
        if check == 3 then CommF:InvokeServer("Bones","Buy",1,1); task.wait(0.3); CommF:InvokeServer("BuyDragonTalon",true)
        elseif check == 1 then CommF:InvokeServer("BuyDragonTalon")
        else CommF:InvokeServer("Bones","Buy",1,1); task.wait(0.3); CommF:InvokeServer("BuyDragonTalon",true); task.wait(0.3); CommF:InvokeServer("BuyDragonTalon") end
    end)
end

task.spawn(function()
    while true do
        if CheckDragonTalon() then
            SpawnLabel.Text = "Dragon Talon: Đã sở hữu"; SpawnLabel.TextColor3 = Color3.fromRGB(0,255,0); break
        else
            SpawnLabel.Text = "Dragon Talon: Chưa có"; SpawnLabel.TextColor3 = Color3.fromRGB(255,0,0)
            ActionStatus.Text = "Hành động: Đang bay đến mua Dragon Talon..."
            if TweenTo(Uzoth_CFrame) then DoBuyDragonTalon() end
        end
        task.wait(5)
    end
end)

-- BỘ CÔNG CỤ XỬ LÝ INVENTORY
local _lastValidInv = nil; local _invFailCount = 0
local function GetInventoryData()
    local ok, inv = pcall(function() return game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("getInventory") end)
    if ok and type(inv) == "table" and next(inv) ~= nil then _lastValidInv = inv; _invFailCount = 0; return inv, true end
    _invFailCount = _invFailCount + 1
    if _lastValidInv ~= nil then return _lastValidInv, false end
    return {}, false
end

local function CheckItemInInv(invData, itemName)
    local p = game.Players.LocalPlayer
    if p.Character and p.Character:FindFirstChild(itemName) then return true, 1 end
    local bp = p:FindFirstChild("Backpack")
    if bp and bp:FindFirstChild(itemName) then return true, 1 end
    for _, v in pairs(invData) do if type(v) == "table" and v.Name == itemName then return true, (v.Count or 1) end end
    return false, 0
end

-- BỘ XỬ LÝ FILE JSON
local HttpService = game:GetService("HttpService")
local JsonFileName = "DRCHUB_" .. Player.Name .. ".json"

local function ReadJson()
    if isfile and isfile(JsonFileName) then
        local ok, data = pcall(function() return HttpService:JSONDecode(readfile(JsonFileName)) end)
        if ok and type(data) == "table" then return data end
    end
    return {}
end
local function WriteJson(data) pcall(function() writefile(JsonFileName, HttpService:JSONEncode(data)) end) end
local function SaveLearnStatus() local data = ReadJson(); data.Status = "StatusLearnDone"; WriteJson(data) end
local function IsLearnDone() local data = ReadJson(); return data.Status == "StatusLearnDone" end
local function ClearBlackBeltFailed() local data = ReadJson(); if data.NotDoneBlack then data.NotDoneBlack = nil; WriteJson(data) end end

-- CHECK FILE COMPLETED-EGG
local function IsEggCompleted()
    local ok, c = pcall(function()
        if readfile and isfile and isfile(Player.Name .. ".txt") then return readfile(Player.Name .. ".txt") end
        return nil
    end)
    return ok and c == "Completed-egg"
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
                ["Select Method Farm"] = "Farm Bones", ["Start Farm"] = false,
                ["Auto Quest Dojo Trainer"] = true, ["Select Zone"] = "Zone 6",
                ["Select Boat"] = "Brigade",
                ["Select Sea Events"] = {["Shark"]=true,["Terrorshark"]=true,["Piranha"]=true,["Ship"]=true}
            }
        elseif typeStr == "Golem" then
            getgenv().Config = {
                ["Select Weapon Kill Golem"] = "Melee", ["Select Method Kill Golem"] = "Click M1",
                ["Auto Collect Bone"] = true, ["Auto Collect Egg"] = true,
                ["Ignore Craft Volcanic Magnet"] = true, ["Fully Event Prehistoric Island"] = true,
                ["Select Weapons Fix Lava"] = {["Melee"]=true,["Sword"]=true}
            }
        elseif typeStr == "Bone" then
            getgenv().Config = {["Select Method Farm"] = "Farm Bones", ["Start Farm"] = true}
        elseif typeStr == "FarmFragment" then
            hubKey = "1f34f32b6f1917a66d57e8c6"
            getgenv().Config = {["Select Method Farm"] = "Farm Katakuri", ["Hop Find Katakuri"] = true, ["Start Farm"] = true}
        end
        getgenv().Key = hubKey
        local ok, err = pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/obiiyeuem/vthangsitink/main/BananaHub.lua"))() end)
        if ok then _G.HubLoadedType = typeStr; warn("[BananaHub] Load: " .. typeStr)
        else _G.HubLoadedType = "None"; warn("[BananaHub] Fail: " .. tostring(err)) end
        _G.HubIsLoading = false
        if ManualDojoBtn then ManualDojoBtn.Visible = false end
    end)
end

ManualDojoBtn.MouseButton1Click:Connect(function()
    _G.HubLoadedType = "None"; LoadBananaHub("Dojo"); ManualDojoBtn.Visible = false
    ActionStatus.Text = "Hành động: Đã bật Script Dojo thủ công!"
end)

-- ==========================================
-- LUỒNG KIỂM SOÁT TỐI THƯỢNG
-- (4/4 Dragon Egg = BƯỚC CUỐI → ghi file + dừng)
-- ==========================================
task.spawn(function()
    -- Check đã hoàn thành egg từ trước
    if IsEggCompleted() then
        ActionStatus.Text = "✅ Đã hoàn thành 4/4 Egg từ trước! (file Completed-egg)"
        ActionStatus.TextColor3 = Color3.fromRGB(0, 255, 0)
        return
    end

    repeat task.wait(1) until CheckDragonTalon()

    local initialInv    = GetInventoryData()
    local startRed,  _  = CheckItemInInv(initialInv, "Dojo Belt (Red)")
    local startBlack, _ = CheckItemInInv(initialInv, "Dojo Belt (Black)")
    local _, startBones = CheckItemInInv(initialInv, "Dinosaur Bones")

    local CURRENT_STATE = "UNKNOWN"

    while task.wait(4) do

        -- ==========================================
        -- [ KIỂM TRA FRAGMENT ]
        -- ==========================================
        if getgenv().fragment == true then
            local currentFrag = GetFragments()
            if currentFrag < FRAGMENT_MIN then
                if CURRENT_STATE ~= "FARM_FRAGMENT" then CURRENT_STATE = "FARM_FRAGMENT"; LoadBananaHub("FarmFragment") end
                ActionStatus.Text = "Hành động: [Fragment] Đang farm (" .. currentFrag .. "/" .. FRAGMENT_MIN .. ")..."
                continue
            else
                if CURRENT_STATE == "FARM_FRAGMENT" then
                    CURRENT_STATE = "UNKNOWN"; _G.HubLoadedType = "None"
                    ActionStatus.Text = "Hành động: Fragment đủ rồi!"; task.wait(2)
                end
            end
        else
            if CURRENT_STATE == "FARM_FRAGMENT" then
                CURRENT_STATE = "UNKNOWN"; _G.HubLoadedType = "None"
                ActionStatus.Text = "Hành động: Farm Fragment TẮT"; task.wait(1)
            end
        end

        -- ==========================================
        -- [ MASTERY DRAGON TALON ]
        -- ==========================================
        local currentMastery = GetWeaponMastery("Dragon Talon")
        if currentMastery < 500 then
            if CURRENT_STATE ~= "FARM_BONE" then CURRENT_STATE = "FARM_BONE"; LoadBananaHub("Bone") end
            ActionStatus.Text = "Hành động: Farm Mastery Dragon Talon (" .. currentMastery .. "/500)..."

        else
            -- ==========================================
            -- [ CHECK INVENTORY ]
            -- ==========================================
            local inv, invValid = GetInventoryData()
            if not invValid then
                ActionStatus.Text = "Hành động: [!] Inventory lỗi (" .. _invFailCount .. ")..."
            else
                local hasRed       = CheckItemInInv(inv, "Dojo Belt (Red)")
                local hasBlack     = CheckItemInInv(inv, "Dojo Belt (Black)")
                local _, boneCount = CheckItemInInv(inv, "Dinosaur Bones")
                local _, eggCount  = CheckItemInInv(inv, "Dragon Egg")

                -- ==========================================
                -- [ SMART KICK: mới nhận item quan trọng ]
                -- ==========================================
                if hasRed   and not startRed   then task.wait(1); Player:Kick("\n[ Draco Hub ]\nSở hữu Red Belt."); break end
                if hasBlack and not startBlack then task.wait(1); Player:Kick("\n[ Draco Hub ]\nSở hữu Black Belt."); break end
                if hasRed and boneCount >= 3 and startBones < 3 then
                    task.wait(1); Player:Kick("\n[ Draco Hub ]\nĐủ 3 Dinosaur Bones."); break
                end

                -- ==========================================
                -- [ CÓ BLACK BELT ]
                -- ==========================================
                if hasBlack then
                    ClearBlackBeltFailed()

                    if IsLearnDone() then
                        -- ========================================
                        -- ĐÃ HỌC TETHER → CHECK EGG (BƯỚC CUỐI)
                        -- ========================================

                        -- 4/4 Dragon Egg = HOÀN THÀNH → ghi file + dừng
                        if eggCount >= 4 then
                            ActionStatus.Text = "🎉 ĐÃ ĐỦ 4/4 DRAGON EGG! GHI FILE..."
                            ActionStatus.TextColor3 = Color3.fromRGB(0, 255, 0)
                            pcall(function()
                                if writefile then
                                    writefile(Player.Name .. ".txt", "Completed-egg")
                                    warn("[DracoHub] GHI FILE: " .. Player.Name .. ".txt → Completed-egg")
                                end
                            end)
                            ActionStatus.Text = "✅ HOÀN THÀNH! File Completed-egg đã ghi. Dừng tất cả."
                            CURRENT_STATE = "COMPLETED_EGG"
                            break -- DỪNG VÒNG LẶP → VÔ HIỆU HÓA TẤT CẢ PHASE SAU
                        end

                        -- Chưa đủ 4 Egg → farm Golem
                        if CURRENT_STATE ~= "HUNT_EGG" then
                            CURRENT_STATE = "HUNT_EGG"
                            LoadBananaHub("Golem")
                        end
                        ActionStatus.Text = "Hành động: Săn Dragon Egg (" .. eggCount .. "/4)..."

                    else
                        -- ========================================
                        -- CHƯA HỌC TETHER
                        -- ========================================
                        if boneCount >= 3 then
                            CURRENT_STATE = "LEARN_TETHER"
                            ActionStatus.Text = "Hành động: Đủ Belt & Bone! Bay đến Dragon Wizard..."
                            task.wait(3)
                            local arrived = TweenTo(Wizard_CFrame)
                            if arrived then
                                task.wait(3)
                                local ok1, RF1 = pcall(function()
                                    return game:GetService("ReplicatedStorage")
                                        :WaitForChild("Modules"):WaitForChild("Net")
                                        :WaitForChild("RF/InteractDragonQuest")
                                end)
                                if ok1 and RF1 then
                                    pcall(function() RF1:InvokeServer(unpack({[1]={NPC="Dragon Wizard",Command="Speak"}})) end)
                                    task.wait(3)
                                    local res
                                    pcall(function() res = RF1:InvokeServer(unpack({[1]={NPC="Dragon Wizard",Command="LearnTether"}})) end)
                                    if res ~= false then
                                        SaveLearnStatus()
                                        CURRENT_STATE = "UNKNOWN"
                                        ActionStatus.Text = "Hành động: Đã học Tether! Tiếp tục farm Egg..."
                                    end
                                end
                            end
                        else
                            -- Thiếu Bones → farm Golem lấy bones
                            if CURRENT_STATE ~= "FARM_GOLEM_BONE" then
                                CURRENT_STATE = "FARM_GOLEM_BONE"
                                LoadBananaHub("Golem")
                            end
                            ActionStatus.Text = "Hành động: Thiếu xương cho Tether (" .. boneCount .. "/3)..."
                        end
                    end

                -- ==========================================
                -- [ CHƯA CÓ BLACK BELT → FARM DOJO ]
                -- ==========================================
                else
                    -- Có Red Belt + đủ Bones → load Dojo Trainer claim Black
                    if hasRed and boneCount >= 3 then
                        if CURRENT_STATE ~= "FARM_DOJO_CLAIM_BLACK" then
                            CURRENT_STATE = "FARM_DOJO_CLAIM_BLACK"
                            LoadBananaHub("Dojo")
                        end
                        ActionStatus.Text = "Hành động: Có Red + 3 Bones → Dojo Trainer claim Black Belt..."

                    -- Có Red Belt + thiếu Bones → farm Golem lấy bones
                    elseif hasRed and boneCount < 3 then
                        if CURRENT_STATE ~= "FARM_GOLEM_FOR_BLACK" then
                            CURRENT_STATE = "FARM_GOLEM_FOR_BLACK"
                            LoadBananaHub("Golem")
                        end
                        ActionStatus.Text = "Hành động: Có Red, thiếu Bones (" .. boneCount .. "/3) → Farm Golem..."

                    -- Chưa có Red → farm Dojo từ đầu
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
    end
end)
