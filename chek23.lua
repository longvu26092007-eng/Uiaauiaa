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
-- [ PHẦN 1 ] ANTI-STALKER LOGIC (UPDATED BLACKLIST)
-- ==========================================

local RawBlacklist = {
    "PaulaKane069", "ErnestJohns365", "JeremyKrause92419", "ChristieBlevins438",
    "XxCrystalNovaxX2013", "GregLane01813", "JaneJensen03", "DustinErickson962",
    "PaulaIbarra0604", "IsaiahVaughan99557", "AlexisDaniels69808", "KerryMcgee15",
    "RobertoHunter95", "AngelSalas74", "ChristianPonce657", "DennisSpencer8740",
    "CarolynBautista90", "KatelynMorrow88395", "ErnestShort7", "StanleyRose6739",
    "ShaunRust553", "ShelleyAdams308", "AndreaKemp5267", "CarlosBurnett4",
    "AlexandraMendoza7715", "GregNolan3", "CynthiaHines66528", "KathyMadden9534",
    "SaraVivid390", "CrystalPineda84794", "LaceyTapia4532", "LoriSavage51917",
    "ErnestMora42548", "ClintonBarry3", "KeithSavage0", "ShaunCarr70426",
    "KarenCooley5210", "KevinCyan62812", "ShaunMaynard70", "PennyAquamarine72",
    "GlenAustin3", "BrandonKramer955", "PhilipTapia85", "SoniaBarron24",
    "JoseWebb3599", "ColinFreeman43866", "ColtonMcfarland0114", "IvanRubio1279",
    "MalikMack43", "TomRussell998", "ChristianSpencer5722", "KathleenSaffron1772",
    "JodiHardy365", "PrestonDaniels47209", "PamTrevino03169", "KrystalGaines4",
    "ElaineMullen6258", "KaitlinBass3418", "AustinLong276", "TonySheppard2348",
    "ErnestMcpherson01", "DuaneJuarez36", "LeahButler425", "XxMaxMagicUltraxX",
    "RonaldHinton067", "TimReyes7834", "AlyssaWaters662", "KatrinaHouston870",
    "DebbieGould36348", "BruceRangel92689", "StacieCervantes1476", "ChrisOconnor35",
    "LeroyChang842", "AngelicaHarding380", "KatelynRice39", "YolandaMcclain10",
    "ShelbySapphire38549", "ForestJames854", "JeromeBoyd00377", "MeghanDouglas1",
    "StaceyBlue5240", "MarthaParrish502", "JulianTurbo270", "AlexanderOrtiz12686",
    "TiffanyRobinson71690", "SPARKLY_Claw70", "L3viMaxAqua", "JaydenC0deEagle99",
    "Wraith_BLAZE200412", "Layla_Stealth200447", "KyleBanks01", "SparkNova65",
    "XxVict0riaFirexX2005", "Galaxy_RIFT200784", "Paisl3yNovaNight", "Master_ACE201245",
    "SebastianJadexit", "WOLFSKYFROST_YT", "Knight_Infern059", "ZeroCircuit201821",
    "ArrowFox200453", "XxFusi0nBaneBac0nxXY", "XxAsher_NOVAXX2003", "Jax0nTiger201412",
    "OliverQueenBlade2008", "Victoria_Circuit32", "Crystal_Dark30", "Prism_Aqua2017YT",
    "P0werMysticV0rtex", "N0ahBac0nPh0enix", "ZapN0vaC0d3", "Ven0mStarStarry",
    "William_Storm200422", "Z0e_W0LF2013", "HenryHunterdri", "RiderStormDawn2015",
    "CrazeSpark201462", "XxAriaByteBuilderxX2", "GoldenStealthAqua200",
    "LuckyUltraTurbo20031", "NinjaAceTurbo2024", "Ethan_Ghost97", "HazelDancerjqx",
    "EvelynZoomShadowYT", "PixelChaseS0nic2017", "LeviBaneNinja93", "XxLavaCyberEpicxX",
    "HazeBearChill2004", "MelissaForestrdi", "MeganGalaxy527", "XxVenomAceArrowxX202",
    "Harp3rPr098", "XxCrystalEch0xX29"
}

local BlacklistMap = {}
for _, name in ipairs(RawBlacklist) do
    BlacklistMap[name] = true
end

local HopScriptURL = "https://raw.githubusercontent.com/longvu26092007-eng/Uiaauiaa/refs/heads/main/hopa16.lua"

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
