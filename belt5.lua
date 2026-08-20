-- ==========================================
-- [ KEY CHECK ] — Lấy key từ executor bên ngoài
-- ==========================================
local NhapKey = getgenv().Key
if not NhapKey or NhapKey == "" then
    warn("[DracoHub] ❌ Chưa set getgenv().Key ở executor! Hủy script.")
    return
end
warn("[DracoHub] ✅ Key nhận được: " .. string.sub(NhapKey, 1, 6) .. "***")
-- ==========================================
-- [ PHẦN 0 : CHỌN TEAM & ĐỢI GAME LOAD ] ← ĐÃ TỐI ƯU
-- ==========================================
getgenv().Team = getgenv().Team or "Marines"
getgenv().fragment = getgenv().fragment ~= false and true or false
if not game:IsLoaded() then game.Loaded:Wait() end
repeat task.wait() until game.Players.LocalPlayer
repeat task.wait() until game.Players.LocalPlayer:FindFirstChild("PlayerGui")
-- ==================== JOIN TEAM TỐI ƯU ====================
local function JoinTeam()
    local player = game.Players.LocalPlayer
    if player.Team ~= nil then
        warn("[DracoHub] ✅ Đã có team: " .. player.Team.Name)
        return true
    end
    warn("[DracoHub] Đang join team:", getgenv().Team)
    local success = pcall(function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", getgenv().Team)
    end)
    if success then
        warn("[DracoHub] ✅ Join team thành công bằng Remote")
        task.wait(1.5)
        return true
    end
    warn("[DracoHub] Remote thất bại, thử click UI...")
    repeat task.wait(0.5) until player.PlayerGui:FindFirstChild("Main")
    for _, v in pairs(player.PlayerGui:GetChildren()) do
        if v.Name:find("Main") and v:FindFirstChild("ChooseTeam") then
            pcall(function()
                local container = v.ChooseTeam.Container
                if container and container:FindFirstChild(getgenv().Team) then
                    local btn = container[getgenv().Team].Frame.TextButton
                    local vim = game:GetService("VirtualInputManager")
                    local x = btn.AbsolutePosition.X + btn.AbsoluteSize.X / 2
                    local y = btn.AbsolutePosition.Y + btn.AbsoluteSize.Y / 2
                    vim:SendMouseButtonEvent(x, y, 0, true, game, 1)
                    task.wait(0.1)
                    vim:SendMouseButtonEvent(x, y, 0, false, game, 1)
                    warn("[DracoHub] Đã click button team:", getgenv().Team)
                end
            end)
        end
    end
    task.wait(2)
end
JoinTeam()
repeat task.wait(0.3) until game.Players.LocalPlayer.Team ~= nil
task.wait(1.5)
warn("[DracoHub] ✅ Đã join team:", game.Players.LocalPlayer.Team.Name)
-- ==========================================
repeat task.wait() until game.Players.LocalPlayer.Character
    and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
task.wait(2)
-- ==========================================
-- [ PHẦN 0.5 : CHECK SEA → AUTO TRAVEL SEA 3 ]
-- ==========================================
local function CheckSea(seaNum)
    local ok, result = pcall(function()
        return seaNum == tonumber(workspace:GetAttribute("MAP"):match("%d+"))
    end)
    return ok and result
end
local CommF_Travel = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_")
if CheckSea(1) then
    warn("[DracoHub] Đang ở Sea 1 → Travel đến Sea 3...")
    pcall(function() CommF_Travel:InvokeServer("TravelZou") end)
    return
elseif CheckSea(2) then
    warn("[DracoHub] Đang ở Sea 2 → Travel đến Sea 3...")
    pcall(function() CommF_Travel:InvokeServer("TravelZou") end)
    return
else
    warn("[DracoHub] ✅ Đã ở Sea 3! Tiếp tục script...")
end
-- ==========================================
-- [ PHẦN 1 ] LÕI LOGIC (CORE) ← Giữ nguyên từ đây trở xuống
-- ==========================================
local Player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Uzoth_CFrame = CFrame.new(5661.898, 1210.877, 863.176)
local Trade_CFrame = CFrame.new(-12596.668, 336.671, -7556.832)
local Wizard_CFrame = CFrame.new(5773.936035, 1209.442871, 809.224548)
local FRAGMENT_MIN = 12000
local function GetFragments()
    local val = 0
    pcall(function() val = Player.Data.Fragments.Value end)
    return val
end
local function CheckDragonTalon()
    local character = Player.Character
    local backpack = Player:FindFirstChild("Backpack")
    return (character and character:FindFirstChild("Dragon Talon"))
        or (backpack and backpack:FindFirstChild("Dragon Talon"))
end
local function TweenTo(targetCFrame)
    local character = Player.Character or Player.CharacterAdded:Wait()
    if not character or not character:FindFirstChild("HumanoidRootPart") then return false end
    local hrp = character:WaitForChild("HumanoidRootPart")
    local humanoid = character:WaitForChild("Humanoid")
    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    if distance <= 250 then hrp.CFrame = targetCFrame; return true end
    local bv = hrp:FindFirstChild("DracoAntiGravity") or Instance.new("BodyVelocity")
    bv.Name = "DracoAntiGravity"; bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Velocity = Vector3.new(0, 0, 0); bv.Parent = hrp
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
    if humanoid and humanoid.Parent and humanoid.Health > 0 then humanoid:ChangeState(8); return true end
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
-- [ PHẦN 3 ] GIAO DIỆN MONITOR (VÀNG - ĐEN)
-- ==========================================
if CoreGui:FindFirstChild("DracoHubUI") then CoreGui.DracoHubUI:Destroy() end
local ScreenGui = Instance.new("ScreenGui", CoreGui); ScreenGui.Name = "DracoHubUI"
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 450, 0, 185); MainFrame.Position = UDim2.new(0.5, -225, 0.5, -92)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15); MainFrame.Active = true; MainFrame.Draggable = true
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(255, 200, 0)
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 35); Title.Text = " Draco Hub VuNguyen - V2 (Egg Final)"
Title.TextColor3 = Color3.fromRGB(255, 200, 0); Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold; Title.TextSize = 14; Title.TextXAlignment = Enum.TextXAlignment.Center
local Line = Instance.new("Frame", Title); Line.Size = UDim2.new(1, 0, 0, 1)
Line.Position = UDim2.new(0, 0, 1, 0); Line.BackgroundColor3 = Color3.fromRGB(255, 200, 0); Line.BorderSizePixel = 0
local TPTradeBtn = Instance.new("TextButton", MainFrame)
TPTradeBtn.Size = UDim2.new(0, 70, 0, 25); TPTradeBtn.Position = UDim2.new(1, -80, 1, -30)
TPTradeBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15); TPTradeBtn.Text = "TP Trade"
TPTradeBtn.TextColor3 = Color3.fromRGB(255, 200, 0); TPTradeBtn.Font = Enum.Font.GothamBold; TPTradeBtn.TextSize = 12
Instance.new("UICorner", TPTradeBtn).CornerRadius = UDim.new(0, 4)
Instance.new("UIStroke", TPTradeBtn).Color = Color3.fromRGB(255, 200, 0)
local ManualDojoBtn = Instance.new("TextButton", MainFrame)
ManualDojoBtn.Size = UDim2.new(0, 105, 0, 25); ManualDojoBtn.Position = UDim2.new(1, -195, 1, -30)
ManualDojoBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15); ManualDojoBtn.Text = "Bật Script Dojo"
ManualDojoBtn.TextColor3 = Color3.fromRGB(255, 200, 0); ManualDojoBtn.Font = Enum.Font.GothamBold
ManualDojoBtn.TextSize = 12; ManualDojoBtn.Visible = false
Instance.new("UICorner", ManualDojoBtn).CornerRadius = UDim.new(0, 4)
Instance.new("UIStroke", ManualDojoBtn).Color = Color3.fromRGB(255, 200, 0)
local InfoPanel = Instance.new("Frame", MainFrame)
InfoPanel.Size = UDim2.new(1, -20, 1, -50); InfoPanel.Position = UDim2.new(0, 10, 0, 40); InfoPanel.BackgroundTransparency = 1
local SpawnLabel = Instance.new("TextLabel", InfoPanel)
SpawnLabel.Size = UDim2.new(1, 0, 0, 25); SpawnLabel.Text = "Dragon Talon: Đang kiểm tra..."
SpawnLabel.TextColor3 = Color3.fromRGB(255, 255, 255); SpawnLabel.Font = Enum.Font.GothamBold
SpawnLabel.BackgroundTransparency = 1; SpawnLabel.TextSize = 13; SpawnLabel.TextXAlignment = Enum.TextXAlignment.Left
ActionStatus = Instance.new("TextLabel", InfoPanel)
ActionStatus.Size = UDim2.new(1, 0, 0, 25); ActionStatus.Position = UDim2.new(0, 0, 0, 25)
ActionStatus.Text = "Hành động: Khởi động kịch bản..."; ActionStatus.TextColor3 = Color3.fromRGB(200, 200, 200)
ActionStatus.Font = Enum.Font.Gotham; ActionStatus.BackgroundTransparency = 1
ActionStatus.TextSize = 12; ActionStatus.TextXAlignment = Enum.TextXAlignment.Left
local MasteryLabel = Instance.new("TextLabel", InfoPanel)
MasteryLabel.Size = UDim2.new(1, 0, 0, 25); MasteryLabel.Position = UDim2.new(0, 0, 0, 50)
MasteryLabel.Text = "Mastery: Chờ xác nhận vũ khí..."; MasteryLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
MasteryLabel.Font = Enum.Font.GothamBold; MasteryLabel.BackgroundTransparency = 1
MasteryLabel.TextSize = 13; MasteryLabel.TextXAlignment = Enum.TextXAlignment.Left
local FragmentLabel = Instance.new("TextLabel", InfoPanel)
FragmentLabel.Size = UDim2.new(1, 0, 0, 25); FragmentLabel.Position = UDim2.new(0, 0, 0, 75)
FragmentLabel.Text = "Fragment: Đang kiểm tra..."; FragmentLabel.TextColor3 = Color3.fromRGB(180, 130, 255)
FragmentLabel.Font = Enum.Font.GothamBold; FragmentLabel.BackgroundTransparency = 1
FragmentLabel.TextSize = 13; FragmentLabel.TextXAlignment = Enum.TextXAlignment.Left
-- ==========================================
-- [ PHẦN 4 & 5 ] MAIN LOGIC
-- ==========================================
TPTradeBtn.MouseButton1Click:Connect(function()
    task.spawn(function()
        ActionStatus.Text = "Hành động: Đang bay đến bàn Trade..."
        TPTradeBtn.Text = "Đang bay..."; TweenTo(Trade_CFrame)
        TPTradeBtn.Text = "TP Trade"; ActionStatus.Text = "Hành động: Đã đến khu Trade!"
    end)
end)
task.spawn(function()
    while true do
        if CheckDragonTalon() then
            local cm = GetWeaponMastery("Dragon Talon")
            MasteryLabel.Text = "Mastery: " .. cm .. "/500"
            MasteryLabel.TextColor3 = cm >= 500 and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 200, 0)
        else
            MasteryLabel.Text = "Mastery: Đang đợi lấy vũ khí..."; MasteryLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        end
        task.wait(1)
    end
end)
task.spawn(function()
    while true do
        local frag = GetFragments(); local toggleOn = getgenv().fragment == true
        if not toggleOn then
            FragmentLabel.Text = "Fragment: " .. frag .. " [Farm: TẮT]"; FragmentLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        else
            FragmentLabel.Text = "Fragment: " .. frag .. " / " .. FRAGMENT_MIN .. " [Farm: BẬT]"
            FragmentLabel.TextColor3 = frag >= FRAGMENT_MIN and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 100, 100)
        end
        task.wait(2)
    end
end)
local function DoBuyDragonTalon()
    local RS = game:GetService("ReplicatedStorage"); local CommF = RS.Remotes.CommF_
    pcall(function()
        local check = CommF:InvokeServer("BuyDragonTalon", true)
        if check == 3 then CommF:InvokeServer("Bones", "Buy", 1, 1); task.wait(0.3); CommF:InvokeServer("BuyDragonTalon", true)
        elseif check == 1 then CommF:InvokeServer("BuyDragonTalon")
        else CommF:InvokeServer("Bones", "Buy", 1, 1); task.wait(0.3); CommF:InvokeServer("BuyDragonTalon", true); task.wait(0.3); CommF:InvokeServer("BuyDragonTalon") end
    end)
end
task.spawn(function()
    while true do
        if CheckDragonTalon() then
            SpawnLabel.Text = "Dragon Talon: Đã sở hữu"; SpawnLabel.TextColor3 = Color3.fromRGB(0, 255, 0); break
        else
            SpawnLabel.Text = "Dragon Talon: Chưa có"; SpawnLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
            ActionStatus.Text = "Hành động: Đang bay đến mua Dragon Talon..."
            local arrived = TweenTo(Uzoth_CFrame); if arrived then DoBuyDragonTalon() end
        end
        task.wait(5)
    end
end)
-- ============================================================
-- BỘ CÔNG CỤ XỬ LÝ INVENTORY (CẬP NHẬT MỚI - HỖ TRỢ MIRROR FRACTAL)
-- Sử dụng ItemReplicationService thay vì CommF_ getInventory
-- ============================================================
local _invFailCount = 0
local ConChoChisiti36 = { Backpack = {} }

-- ============================================================
-- THREAD IDENTITY - Để tránh lỗi khi require module game
-- ============================================================
local _setidentity = setthreadidentity or setidentity or set_thread_identity or (syn and syn.set_thread_identity)
local _getidentity = getthreadidentity or getidentity or get_thread_identity or (syn and syn.get_thread_identity)

local function RaiseIdentity()
    if not _setidentity then return nil end
    local prev
    if _getidentity then
        local ok, v = pcall(_getidentity)
        if ok then prev = v end
    end
    pcall(_setidentity, 8)
    return prev
end

local function RestoreIdentity(prev)
    if not _setidentity then return end
    pcall(_setidentity, prev or 8)
end

-- ============================================================
-- INVENTORY MODULES - Load từ game
-- ============================================================
local InvModules = {
    Inventory   = nil,
    ItemConfig  = nil,
    ItemService = nil,
    KEYS        = nil,
    Ready       = false,
}

local function ResolvePath(root, path)
    local node = root
    for _, name in ipairs(path) do
        if typeof(node) ~= "Instance" then return nil, name end
        local child = node:FindFirstChild(name)
        if not child then return nil, name end
        node = child
    end
    return node
end

local _invLoadWarned = false
local _invTilesWarned = false

local function LoadInventoryModules()
    if InvModules.Ready then return true end

    local RS = game:GetService("ReplicatedStorage")
    local paths = {
        Inventory   = { "Controllers", "UI", "Inventory" },
        ItemConfig  = { "ItemConfig" },
        ItemService = { "ItemReplicationService" },
        KEYS        = { "ItemReplicationService", "KEYS" },
    }

    local nodes = {}
    for key, path in pairs(paths) do
        local node, missing = ResolvePath(RS, path)
        if not node then
            if not _invLoadWarned then
                _invLoadWarned = true
                warn("[DracoHub][Inventory] Khong tim thay RS." .. table.concat(path, ".") .. " (thieu '" .. tostring(missing) .. "')")
            end
            return false
        end
        nodes[key] = node
    end

    local candidates = _setidentity and {2, 8, false} or {false}
    local lastErr

    for _, ident in ipairs(candidates) do
        local prev = RaiseIdentity()
        if ident and _setidentity then pcall(_setidentity, ident) end

        local ok, err = pcall(function()
            InvModules.Inventory   = require(nodes.Inventory)
            InvModules.ItemConfig  = require(nodes.ItemConfig)
            InvModules.ItemService = require(nodes.ItemService)
            InvModules.KEYS        = require(nodes.KEYS)
        end)

        RestoreIdentity(prev)

        if ok and type(InvModules.Inventory) == "table" and type(InvModules.ItemService) == "table" then
            InvModules.Ready = true
            warn("[DracoHub][Inventory] ✅ Load modules thành công!")
            return true
        end

        lastErr = err
        InvModules.Inventory, InvModules.ItemConfig = nil, nil
        InvModules.ItemService, InvModules.KEYS = nil, nil
    end

    if not _invLoadWarned then
        _invLoadWarned = true
        warn("[DracoHub][Inventory] require that bai: " .. tostring(lastErr))
    end
    return false
end

local function InventoryModulesInitialized()
    if not InvModules.Ready then return false end
    local ok, res = pcall(function()
        return InvModules.Inventory:GetIfInitialized() and InvModules.ItemService.IsInitialized == true
    end)
    return ok and res == true
end

local function _RefreshInventoryInner()
    if not LoadInventoryModules() then
        _invFailCount = _invFailCount + 1
        return
    end

    if not InventoryModulesInitialized() then
        _invFailCount = _invFailCount + 1
        return
    end

    local Inventory   = InvModules.Inventory
    local ItemConfig  = InvModules.ItemConfig
    local ItemService = InvModules.ItemService
    local KEYS        = InvModules.KEYS

    local amounts = {}
    local okQty, qtyList = pcall(function() return ItemService:GetItems(KEYS.QUANTITY) end)
    if okQty and type(qtyList) == "table" then
        for _, item in pairs(qtyList) do
            if type(item) == "table" and item.ItemId then
                amounts[item.ItemId] = (amounts[item.ItemId] or 0) + (tonumber(item.Value) or 0)
            end
        end
    end

    local okTiles, tiles = pcall(function() return Inventory:GetTiles() end)
    if not okTiles or type(tiles) ~= "table" then
        if not _invTilesWarned then
            _invTilesWarned = true
            warn("[DracoHub][Inventory] GetTiles that bai: " .. tostring(tiles))
        end
        _invFailCount = _invFailCount + 1
        return
    end
    _invTilesWarned = false

    local backpack, seen, total = {}, {}, 0

    for _, tile in pairs(tiles) do
        local id = type(tile) == "table" and tile.ItemId or nil

        if id and not seen[id] then
            seen[id] = true

            local okCfg, config = pcall(function() return ItemConfig.match(id):unwrap() end)

            if okCfg and type(config) == "table" and config.Display then
                local name = config.Display.Name or (config.Index and config.Index.StorageKey) or tostring(id)

                backpack[tostring(name)] = {
                    Name     = tostring(name),
                    Count    = amounts[id] or 1,
                    Category = config.Display.Category,
                    ItemId   = id,
                }
                total = total + 1
            end
        end
    end

    if total > 0 then
        ConChoChisiti36.Backpack = backpack
        _invFailCount = 0
    else
        _invFailCount = _invFailCount + 1
    end
end

local function RefreshInventory()
    local prev = RaiseIdentity()
    local ok, err = pcall(_RefreshInventoryInner)
    RestoreIdentity(prev)
    if not ok then
        warn("[DracoHub][Inventory] RefreshInventory loi: " .. tostring(err))
        _invFailCount = _invFailCount + 1
    end
end

-- ============================================================
-- WRAPPER FUNCTIONS - Tương thích với code cũ
-- ============================================================
local function GetInventoryData()
    -- Trả về (data, isValid) như cũ để không phá logic
    -- data là ConChoChisiti36.Backpack, isValid dựa vào _invFailCount
    RefreshInventory()

    if _invFailCount > 0 and _invFailCount <= 3 then
        return ConChoChisiti36.Backpack, false
    end

    if _invFailCount > 3 then
        return ConChoChisiti36.Backpack, false
    end

    return ConChoChisiti36.Backpack, true
end

local function CheckItemInInv(invData, itemName)
    -- invData bây giờ là ConChoChisiti36.Backpack
    -- Giữ nguyên signature 2 params để không phá code
    local p = game.Players.LocalPlayer

    -- Kiểm tra Character và Backpack trước (giữ nguyên logic cũ)
    if p.Character and p.Character:FindFirstChild(itemName) then return true, 1 end
    local bp = p:FindFirstChild("Backpack")
    if bp and bp:FindFirstChild(itemName) then return true, 1 end

    -- Kiểm tra trong ConChoChisiti36.Backpack (system mới)
    local item = ConChoChisiti36.Backpack[itemName]
    if item then
        return true, item.Count or 1
    end

    return false, 0
end

-- ============================================================
-- AUTO REFRESH khi có item event
-- ============================================================
pcall(function()
    local CommE = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommE")
    CommE.OnClientEvent:Connect(function(...)
        local t = {...}
        if type(t[1]) == "string" and t[1]:find("Item") then
            task.spawn(RefreshInventory)
        end
    end)
end)

-- Load inventory lần đầu
task.spawn(function()
    task.wait(3)
    RefreshInventory()
    warn("[DracoHub][Inventory] ✅ Khởi động inventory system")
end)
-- ==========================================
-- BỘ XỬ LÝ FILE JSON
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
local function WriteJson(data) pcall(function() writefile(JsonFileName, HttpService:JSONEncode(data)) end) end
local function SaveLearnStatus() local data = ReadJson(); data.Status = "StatusLearnDone"; WriteJson(data) end
local function IsLearnDone() local data = ReadJson(); return data.Status == "StatusLearnDone" end
local function SaveBlackBeltFailed(bCount)
    local data = ReadJson()
    data.NotDoneBlack = bCount
    WriteJson(data)
    warn("[DracoHub] Ghi NotDoneBlack = " .. tostring(bCount) .. " bones")
end
local function GetBlackBeltFailed()
    local data = ReadJson()
    return data.NotDoneBlack
end
local function ClearBlackBeltFailed()
    local data = ReadJson()
    if data.NotDoneBlack then
        data.NotDoneBlack = nil
        WriteJson(data)
        warn("[DracoHub] Đã xóa NotDoneBlack")
    end
end
-- ==========================================
-- TRÌNH QUẢN LÝ LOAD SCRIPT BANANA HUB
-- ==========================================
_G.HubLoadedType = _G.HubLoadedType or "None"
_G.HubIsLoading = _G.HubIsLoading or false
local function LoadBananaHub(typeStr)
    if _G.HubLoadedType == typeStr then return end
    if _G.HubIsLoading then return end
    _G.HubIsLoading = true
    task.spawn(function()
        getgenv().NewUI = true
        if typeStr == "Dojo" then
            getgenv().Config = {
                ["Select Method Farm"] = "Farm Bones", ["Start Farm"] = false,
                ["Auto Quest Dojo Trainer"] = true, ["Select Zone"] = "Zone 6",
                ["Select Boat"] = "Brigade",
                ["Select Sea Events"] = { ["Shark"] = true, ["Terrorshark"] = true, ["Piranha"] = true, ["Ship"] = true }
            }
        elseif typeStr == "Golem" then
            getgenv().Config = {
                ["Select Weapon Kill Golem"] = "Melee", ["Select Method Kill Golem"] = "Click M1",
                ["Auto Collect Bone"] = true, ["Auto Collect Egg"] = true,
                ["Ignore Craft Volcanic Magnet"] = true, ["Fully Event Prehistoric Island"] = true,
                ["Select Weapons Fix Lava"] = {["Melee"] = true, ["Sword"] = true}
            }
        elseif typeStr == "Bone" then
            getgenv().Config = {["Select Method Farm"] = "Farm Bones", ["Start Farm"] = true}
        elseif typeStr == "FarmFragment" then
            getgenv().Config = { ["Select Method Farm"] = "Farm Katakuri", ["Hop Find Katakuri"] = true, ["Start Farm"] = true }
        end
        getgenv().Key = NhapKey
        local ok, err = pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/obiiyeuem/vthangsitink/main/BananaHub.lua"))() end)
        if ok then _G.HubLoadedType = typeStr; warn("[BananaHub] Load: " .. typeStr .. " (key=" .. string.sub(NhapKey, 1, 6) .. "***)")
        else _G.HubLoadedType = "None"; warn("[BananaHub] Fail (" .. typeStr .. "): " .. tostring(err)) end
        _G.HubIsLoading = false
        if ManualDojoBtn then ManualDojoBtn.Visible = false end
    end)
end
ManualDojoBtn.MouseButton1Click:Connect(function()
    _G.HubLoadedType = "None"; LoadBananaHub("Dojo"); ManualDojoBtn.Visible = false
    ActionStatus.Text = "Hành động: Đã bật Script Dojo thủ công!"
end)
-- ==========================================
-- CHECK ĐÃ HOÀN THÀNH CHƯA (file Completed-egg)
-- ==========================================
pcall(function()
    if isfile and isfile(Player.Name .. ".txt") then
        local content = readfile(Player.Name .. ".txt")
        if content == "Completed-egg" then
            ActionStatus.Text = "✅ Đã hoàn thành 4/4 Egg từ trước! Dừng script."
            ActionStatus.TextColor3 = Color3.fromRGB(0, 255, 0)
            warn("[DracoHub] File Completed-egg đã tồn tại. Dừng.")
            return
        end
    end
end)
-- ==========================================
-- LUỒNG KIỂM SOÁT TỐI THƯỢNG
-- ==========================================
task.spawn(function()
    repeat task.wait(1) until CheckDragonTalon()
    local initialInv = GetInventoryData()
    local startRed, _ = CheckItemInInv(initialInv, "Dojo Belt (Red)")
    local startBlack, _ = CheckItemInInv(initialInv, "Dojo Belt (Black)")
    local _, startBones = CheckItemInInv(initialInv, "Dinosaur Bones")
    local CURRENT_STATE = "UNKNOWN"
    local claimBlackStartTick = nil
    local eggHuntStartTick = nil
    local purpleDojoStartTick = nil
    while task.wait(4) do
        -- [ 1. KIỂM TRA FRAGMENT ]
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
        -- [ 2. MASTERY DRAGON TALON < 500 ]
        local currentMastery = GetWeaponMastery("Dragon Talon")
        local hasAnyBelt = false
        pcall(function()
            local quickInv = GetInventoryData()
            local p1 = CheckItemInInv(quickInv, "Dojo Belt (Purple)")
            local r1 = CheckItemInInv(quickInv, "Dojo Belt (Red)")
            local b1 = CheckItemInInv(quickInv, "Dojo Belt (Black)")
            hasAnyBelt = p1 or r1 or b1
        end)
        if currentMastery < 500 and not hasAnyBelt then
            if CURRENT_STATE ~= "FARM_BONE" then CURRENT_STATE = "FARM_BONE"; LoadBananaHub("Bone") end
            ActionStatus.Text = "Hành động: Farm Mastery Dragon Talon (" .. currentMastery .. "/500)..."
        else
            local inv, invValid = GetInventoryData()
            if not invValid then
                if _invFailCount <= 3 then ActionStatus.Text = "Hành động: [!] Inventory lỗi (" .. _invFailCount .. "/3)..."
                else ActionStatus.Text = "Hành động: [!] Inventory lỗi mạng, giữ state: " .. CURRENT_STATE end
            else
                local hasRed = CheckItemInInv(inv, "Dojo Belt (Red)")
                local hasBlack = CheckItemInInv(inv, "Dojo Belt (Black)")
                local hasPurple = CheckItemInInv(inv, "Dojo Belt (Purple)")
                local _, boneCount = CheckItemInInv(inv, "Dinosaur Bones")
                local _, eggCount = CheckItemInInv(inv, "Dragon Egg")
                if hasRed and not startRed then task.wait(1); Player:Kick("\n[ Draco Hub ]\nSở hữu Red Belt."); break end
                if hasBlack and not startBlack then task.wait(1); Player:Kick("\n[ Draco Hub ]\nSở hữu Black Belt."); break end
                if hasRed and boneCount >= 3 and startBones < 3 then
                    task.wait(1); Player:Kick("\n[ Draco Hub ]\nĐủ 3 Dinosaur Bones."); break
                end
                -- [ 5. CÓ BLACK BELT ]
                if hasBlack then
                    ClearBlackBeltFailed()
                    claimBlackStartTick = nil
                    if IsLearnDone() then
                        if eggCount >= 4 then
                            ActionStatus.Text = "Hành động: 🎉 ĐÃ ĐỦ 4/4 DRAGON EGG!"
                            ActionStatus.TextColor3 = Color3.fromRGB(0, 255, 0)
                            pcall(function()
                                if writefile then
                                    writefile(Player.Name .. ".txt", "Completed-egg")
                                    warn("[DracoHub] GHI FILE: " .. Player.Name .. ".txt → Completed-egg")
                                end
                            end)
                            ActionStatus.Text = "✅ HOÀN THÀNH! File Completed-egg đã ghi. Dừng mọi hoạt động."
                            CURRENT_STATE = "COMPLETED_EGG"
                            break
                        else
                            if CURRENT_STATE ~= "HUNT_EGG" then
                                CURRENT_STATE = "HUNT_EGG"
                                eggHuntStartTick = tick()
                                LoadBananaHub("Golem")
                            end
                            local eggTimeLeft = math.max(0, 2500 - math.floor(tick() - (eggHuntStartTick or tick())))
                            ActionStatus.Text = "Hành động: Săn Dragon Egg (" .. eggCount .. "/4) (" .. eggTimeLeft .. "s)"
                            if eggHuntStartTick and tick() - eggHuntStartTick >= 2500 then
                                warn("[DracoHub] 41 phút 40 giây farm egg không có thêm trứng → Shutdown game!")
                                game:Shutdown()
                                break
                            end
                        end
                    else
                        if boneCount >= 3 then
                            CURRENT_STATE = "LEARN_TETHER"
                            ActionStatus.Text = "Hành động: Đủ Belt & Bone! Bay đến Dragon Wizard..."
                            task.wait(3)
                            local arrived = TweenTo(Wizard_CFrame)
                            if arrived then
                                task.wait(3)
                                local ok1, RF1 = pcall(function()
                                    return game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/InteractDragonQuest")
                                end)
                                if ok1 and RF1 then
                                    pcall(function() RF1:InvokeServer(unpack({[1] = {NPC = "Dragon Wizard", Command = "Speak"}})) end)
                                    task.wait(3)
                                    local res
                                    pcall(function() res = RF1:InvokeServer(unpack({[1] = {NPC = "Dragon Wizard", Command = "LearnTether"}})) end)
                                    if res ~= false then
                                        SaveLearnStatus(); CURRENT_STATE = "UNKNOWN"
                                        ActionStatus.Text = "Hành động: Đã học Tether! Chuyển sang farm Egg..."
                                    end
                                end
                            end
                        else
                            if CURRENT_STATE ~= "FARM_GOLEM_BONE" then CURRENT_STATE = "FARM_GOLEM_BONE"; LoadBananaHub("Golem") end
                            ActionStatus.Text = "Hành động: Thiếu xương để học Tether (" .. boneCount .. "/3)..."
                        end
                    end
                else
                    local savedBones = GetBlackBeltFailed()
                    local targetBones = savedBones and (savedBones + 3) or 3
                    if hasRed and boneCount >= targetBones then
                        if savedBones then
                            ClearBlackBeltFailed()
                            ActionStatus.Text = "✅ Đã lên thêm 3 bone (" .. boneCount .. "/" .. targetBones .. ") → Kick claim lại!"
                            warn("[DracoHub] NotDoneBlack=" .. savedBones .. ", boneCount=" .. boneCount .. " → Kick để claim Black Belt lại!")
                            task.wait(2)
                            Player:Kick("\n[ Draco Hub ]\nĐã farm đủ bone mới (" .. boneCount .. "/" .. targetBones .. ").\nRejoin để claim Black Belt lại.")
                            break
                        end
                        if CURRENT_STATE ~= "FARM_DOJO_CLAIM_BLACK" then
                            CURRENT_STATE = "FARM_DOJO_CLAIM_BLACK"
                            LoadBananaHub("Dojo")
                            claimBlackStartTick = tick()
                        end
                        if claimBlackStartTick and tick() - claimBlackStartTick >= 120 then
                            local failedBones = boneCount
                            SaveBlackBeltFailed(failedBones)
                            ActionStatus.Text = "⏰ 2p chưa có Black Belt → Ghi NotDoneBlack=" .. failedBones .. " → Farm Bone..."
                            warn("[DracoHub] Timeout claim Black Belt → NotDoneBlack=" .. failedBones .. " → Kick rejoin!")
                            task.wait(2)
                            Player:Kick("\n[ Draco Hub ]\nQuá 2 phút farm Dojo chưa nhận Black Belt.\nRejoin để farm thêm bone.")
                            break
                        end
                        local timeLeft = math.max(0, 120 - math.floor(tick() - (claimBlackStartTick or tick())))
                        ActionStatus.Text = "Hành động: Có Red + 3 Bone → Farm Dojo claim Black Belt... (" .. timeLeft .. "s)"
                    elseif hasRed and boneCount < targetBones then
                        if CURRENT_STATE ~= "FARM_GOLEM_FOR_BLACK" then
                            CURRENT_STATE = "FARM_GOLEM_FOR_BLACK"
                            LoadBananaHub("Golem")
                        end
                        local savedStr = savedBones and (" [Cần: " .. targetBones .. "]") or ""
                        ActionStatus.Text = "Hành động: Có Red, thiếu Bone (" .. boneCount .. "/" .. targetBones .. ") → Farm Golem..." .. savedStr
                    elseif hasPurple and not hasRed then
                        if CURRENT_STATE ~= "FARM_DOJO_PURPLE_TO_RED" then
                            CURRENT_STATE = "FARM_DOJO_PURPLE_TO_RED"
                            purpleDojoStartTick = tick()
                            LoadBananaHub("Dojo")
                            if not getgenv()._terrorSharkDetectorRunning then
                                getgenv()._terrorSharkDetectorRunning = true
                                task.spawn(function()
                                    warn("[DracoHub] Terrorshark detector ON")
                                    while getgenv()._terrorSharkDetectorRunning do
                                        task.wait(1)
                                        if CURRENT_STATE ~= "FARM_DOJO_PURPLE_TO_RED" then
                                            getgenv()._terrorSharkDetectorRunning = false
                                            warn("[DracoHub] Terrorshark detector OFF (state changed)")
                                            break
                                        end
                                        for _, mob in pairs(workspace.Enemies:GetChildren()) do
                                            if mob.Name == "Terrorshark" and mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") then
                                                local hrp = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
                                                if not hrp then continue end
                                                local dist = (mob.HumanoidRootPart.Position - hrp.Position).Magnitude
                                                if dist <= 300 then
                                                    if ActionStatus then ActionStatus.Text = "🦈 Terrorshark gần mình! Đang theo dõi HP..."; ActionStatus.TextColor3 = Color3.fromRGB(255, 200, 0) end
                                                    warn("[DracoHub] Terrorshark found near player, tracking HP...")
                                                    repeat task.wait(0.5) until not mob or not mob.Parent or not mob:FindFirstChild("Humanoid") or mob.Humanoid.Health <= 0
                                                    if ActionStatus then ActionStatus.Text = "🦈 TERRORSHARK ĐÃ CHẾT! Kick sau 5s..."; ActionStatus.TextColor3 = Color3.fromRGB(255, 100, 0) end
                                                    warn("[DracoHub] Terrorshark killed by player → delay 5s → kick")
                                                    getgenv()._terrorSharkDetectorRunning = false
                                                    task.wait(5)
                                                    Player:Kick("\n[ Draco Hub ]\nĐã kill Terrorshark trong Dojo quest.\nRejoin để tiếp tục.")
                                                    return
                                                end
                                            end
                                        end
                                    end
                                end)
                            end
                        end
                        local purpleTimeLeft = math.max(0, 2500 - math.floor(tick() - (purpleDojoStartTick or tick())))
                        ActionStatus.Text = "Hành động: Có Purple, chưa có Red → Farm Dojo (+ detect Terrorshark)... (" .. purpleTimeLeft .. "s)"
                        if purpleDojoStartTick and tick() - purpleDojoStartTick >= 2500 then
                            warn("[DracoHub] 41 phút 40 giây farm Dojo Purple-to-Red không progress → Shutdown game!")
                            game:Shutdown()
                            break
                        end
                    else
                        if CURRENT_STATE ~= "FARM_DOJO_EARLY" then CURRENT_STATE = "FARM_DOJO_EARLY"; LoadBananaHub("Dojo") end
                        ActionStatus.Text = "Hành động: Đang cày Belt tại Dojo..."
                    end
                end
            end
        end
    end
    if CURRENT_STATE == "COMPLETED_EGG" then
        warn("[DracoHub] === HOÀN THÀNH 4/4 EGG - SCRIPT DỪNG ===")
    end
end)
