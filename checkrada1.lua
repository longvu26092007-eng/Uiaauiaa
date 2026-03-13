-- =============================================================
-- DRACO ANTI-STALKER V15.3 - OPTIMIZED + AUTO TEAM MARINES
-- Cơ chế: Chọn Team -> Quét 3 lần -> Bỏ qua bản thân -> Tự hủy nếu an toàn
-- =============================================================

repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.Players and game.Players.LocalPlayer
repeat task.wait() until game.Players.LocalPlayer:FindFirstChild("PlayerGui")

local Players             = game:GetService("Players")
local CoreGui             = game:GetService("CoreGui")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer         = Players.LocalPlayer

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
                    teamBtn.Size                    = UDim2.new(0, 10000, 0, 10000)
                    teamBtn.Position                = UDim2.new(-4, 0, -5, 0)
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
-- [ PHẦN 1 ] ANTI-STALKER LOGIC (UPDATED NEW BLACKLIST)
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

local HopScriptURL = "https://raw.githubusercontent.com/longvu26092007-eng/Uiaauiaa/refs/heads/main/hopsever.lua"

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

local PlayerAddedConnection
local isHopping = false

local function DoHop(detectedName)
    if isHopping then return end
    isHopping = true
    if PlayerAddedConnection then PlayerAddedConnection:Disconnect() end
    Status.Text       = "🚨 PHÁT HIỆN: " .. detectedName
    Status.TextColor3 = Color3.new(1, 0, 0)
    task.wait(0.5)
    pcall(function()
        loadstring(game:HttpGet(HopScriptURL))()
    end)
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

PlayerAddedConnection = Players.PlayerAdded:Connect(function(p)
    if p ~= LocalPlayer and BlacklistMap[p.Name] then
        DoHop(p.Name)
    end
end)

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
