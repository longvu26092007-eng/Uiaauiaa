-- =============================================================
-- DRACO ANTI-STALKER V16 - __ServerBrowser HOP
-- Cơ chế: Chọn Team -> Quét 3 lần -> Bỏ qua bản thân -> Hop __ServerBrowser
-- =============================================================

repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.Players and game.Players.LocalPlayer
repeat task.wait() until game.Players.LocalPlayer:FindFirstChild("PlayerGui")

local Players             = game:GetService("Players")
local ReplicatedStorage   = game:GetService("ReplicatedStorage")
local CoreGui             = game:GetService("CoreGui")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TeleportService     = game:GetService("TeleportService")
local GuiService          = game:GetService("GuiService")
local LocalPlayer         = Players.LocalPlayer
local PlaceId, JobId      = game.PlaceId, game.JobId

-- ==========================================
-- [ PHẦN 0 ] AUTO CHỌN TEAM
-- ==========================================
getgenv().Team = getgenv().Team or "Marines"

if LocalPlayer.Team == nil then
    repeat
        task.wait()
        for _, v in pairs(LocalPlayer.PlayerGui:GetChildren()) do
            if string.find(v.Name, "Main") then
                pcall(function()
                    local teamBtn = v.ChooseTeam.Container[getgenv().Team].Frame.TextButton
                    teamBtn.Size                   = UDim2.new(0, 10000, 0, 10000)
                    teamBtn.Position               = UDim2.new(-4, 0, -5, 0)
                    teamBtn.BackgroundTransparency = 1
                    task.wait(0.5)
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true,  game, 1)
                    task.wait(0.05)
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                    task.wait(0.05)
                end)
            end
        end
    until LocalPlayer.Team ~= nil and game:IsLoaded()
    task.wait(3)
end

repeat task.wait() until LocalPlayer.Character
    and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

-- ==========================================
-- [ PHẦN 1 ] BLACKLIST
-- ==========================================
local RawBlacklist = {
    "GabrielaCain9", "XxEllieDancerSkyxX", "DerrickBanana51", "ZAP_Craft200826",
    "CalebBranch587", "BrittneyMorrow08", "AustinCruz9431", "BethanyStrong575",
    "ViperEpicBac0n", "LeahMendoza9056", "NovaKingTurbo2018", "MiaArr0w65",
    "HenrySummers9", "BunnyCarr438", "GabriellaHaley93530", "MikeKline8234",
    "OmarLee75", "AdrianJordan4945", "HollyMccoy86000", "SamuelPrimal201678",
    "Xx_ShadowStreamPanda", "HarryRoss382", "MikaylaHuang02168", "JoanneHolden25736",
    "MeghanCooke79235", "AlejandraHunter23165", "ShariDavidson8449", "FleurCook5",
    "PeggySantiago9", "HeidiLowe946", "StaceyMcpherson6", "VickiPeterson327",
    "TraceyPatterson29", "AimeeBurnett96066", "VeronicaOpal307", "RiftAceBear2005",
    "TravisReed18864", "GeorgeHaas7", "AlbertMunoz5", "MelindaMathews5",
    "DinoAllison72761", "RobynBlanchard27", "TheodoreBeck832", "RocketChaseMagic2019",
    "BarbaraKlein01932", "ButtercupGarcia76", "TimothyFrancis642", "NeilTerry98",
    "KristinStewart72218", "GinaHardin98107", "ShelbyRowland39239", "DanaSchneider75581",
    "AnnetteKey520", "MarciaBenton6595", "OwenBlastZoom2005", "ButtercupMoore18308",
    "JeremyWare0621", "XxLavaWraithxX45", "LeviBond492", "CactiIngram31"
}

local BlacklistMap = {}
for _, name in ipairs(RawBlacklist) do
    BlacklistMap[name] = true
end

-- ==========================================
-- [ PHẦN 2 ] UI
-- ==========================================
local SafeGuiParent = pcall(function() return gethui() end) and gethui()
    or CoreGui:FindFirstChild("RobloxGui") or CoreGui
if SafeGuiParent:FindFirstChild("AntiStalkerUI") then
    SafeGuiParent.AntiStalkerUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name   = "AntiStalkerUI"
ScreenGui.Parent = SafeGuiParent

local MiniFrame = Instance.new("Frame", ScreenGui)
MiniFrame.Size             = UDim2.new(0, 220, 0, 40)
MiniFrame.Position         = UDim2.new(1, -230, 1, -50)
MiniFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UIStroke", MiniFrame).Color = Color3.fromRGB(255, 0, 0)
Instance.new("UICorner", MiniFrame)

local Status = Instance.new("TextLabel", MiniFrame)
Status.Size                   = UDim2.new(1, 0, 1, 0)
Status.BackgroundTransparency = 1
Status.Text                   = "✅ Team: " .. getgenv().Team .. " | Chờ 5s..."
Status.TextColor3             = Color3.new(1, 1, 1)
Status.Font                   = Enum.Font.GothamBold
Status.TextSize               = 11

-- ==========================================
-- [ PHẦN 3 ] HOP SERVER (__ServerBrowser)
-- Y chang Purple Belt script
-- ==========================================
local LastPull, CachedSrv

local function GetServers()
    if LastPull and os.time() - LastPull < 60 then return CachedSrv end
    for i = 1, 100 do
        local ok, data = pcall(function()
            return ReplicatedStorage:WaitForChild("__ServerBrowser"):InvokeServer(i)
        end)
        if ok and data then
            local h = false
            for _ in data do h = true; break end
            if h then
                LastPull = os.time()
                CachedSrv = data
                return data
            end
        end
    end
    return nil
end

local function HopServer(reason)
    Status.Text = "🔄 Hop: " .. tostring(reason)
    Status.TextColor3 = Color3.new(1, 1, 0)

    local Servers = GetServers()
    if not Servers then
        Status.Text = "❌ Không lấy được server list"
        return false
    end

    local arr = {}
    for jid, v in Servers do
        arr[#arr + 1] = {JobId = jid, Players = v.Count, Region = v.Region}
    end

    for _ = 1, math.min(#arr, 20) do
        local sd = arr[math.random(1, #arr)]
        if sd and sd.Players < 5 then
            Status.Text = "🚀 → " .. string.sub(sd.JobId, 1, 12) .. " (" .. sd.Players .. "p)"
            pcall(function()
                ReplicatedStorage:WaitForChild("__ServerBrowser"):InvokeServer("teleport", sd.JobId)
            end)
            task.wait(10)
            return true
        end
    end

    Status.Text = "❌ Không tìm server phù hợp"
    return false
end

-- ==========================================
-- [ PHẦN 4 ] ANTI-DISCONNECT (từ Purple Belt)
-- ==========================================
TeleportService.TeleportInitFailed:Connect(function(_, teleportResult, message)
    if teleportResult == Enum.TeleportResult.IsTeleporting and message:find("previous teleport") then
        task.delay(10, function() game:Shutdown() end)
    end
end)

GuiService.ErrorMessageChanged:Connect(newcclosure(function()
    if GuiService:GetErrorType() == Enum.ConnectionError.DisconnectErrors then
        while true do
            TeleportService:TeleportToPlaceInstance(PlaceId, JobId, LocalPlayer)
            task.wait(5)
        end
    end
end))

-- ==========================================
-- [ PHẦN 5 ] ANTI-STALKER LOGIC
-- ==========================================
local PlayerAddedConnection
local isHopping = false

local function DoHop(detectedName)
    if isHopping then return end
    isHopping = true
    if PlayerAddedConnection then PlayerAddedConnection:Disconnect() end
    Status.Text       = "🚨 PHÁT HIỆN: " .. detectedName
    Status.TextColor3 = Color3.new(1, 0, 0)
    task.wait(0.5)
    HopServer("Stalker: " .. detectedName)
end

local function CheckPlayers()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and BlacklistMap[p.Name] then
            return p.Name
        end
    end
    return nil
end

local function DestructScript()
    if isHopping then return end
    Status.Text       = "✅ An toàn! Tự hủy script..."
    Status.TextColor3 = Color3.new(0, 1, 0)
    if PlayerAddedConnection then PlayerAddedConnection:Disconnect() end
    task.wait(1)
    if ScreenGui then ScreenGui:Destroy() end
end

-- Theo dõi player mới join
PlayerAddedConnection = Players.PlayerAdded:Connect(function(p)
    if p ~= LocalPlayer and BlacklistMap[p.Name] then
        DoHop(p.Name)
    end
end)

-- Quét 3 lần
task.spawn(function()
    task.wait(1)
    for i = 1, 3 do
        if isHopping then break end
        Status.Text = "🔍 Quét Lần " .. i .. "/3..."
        local detected = CheckPlayers()
        if detected then
            DoHop(detected)
            return
        end
        if i < 3 then task.wait(5) end
    end
    DestructScript()
end)
