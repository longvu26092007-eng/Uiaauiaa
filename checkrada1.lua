-- =============================================================
-- DRACO ANTI-STALKER V15.5 - UPDATED BLACKLIST
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
-- [ PHẦN 1 ] BLACKLIST (CẬP NHẬT MỚI)
-- ==========================================
local RawBlacklist = {
    -- ── Danh sách mới ──
    "homeyz6",
    "XxRock3tDarkxX56",
    "IguanaArias5622",
    "XxBlad3B3arxX2021",
    "1roses6",
    "1crournak9",
    "sovkhath19",
    "ErnestKirk576",
    "XxHunt3rBan3MoonxX20",
    "coemplyio9",
    "XxAlpha_HyperxX2023",
    "1twitter8",
    "onetwork8",
    "ToxicHawkSky",
    "YvonneMorrow415",
    "contrumbx9",
    "allorz6",
    "Vict0riaChillPixel_Y",
    "DesireeBlake195",
    "PlantDay92706",
    "ozoom5",
    "ZaydenMagic2019",
    "jurydz6",
    "PamSpencer382",
    "AmandaHarvey89590",
    "arcampx7",
    "ozianteom9",
    "OliviaBuckley01",
    "1xeats6",
    "1yau4",
    "BlossomMejia06128",
    "XxCrystalTurboHawkxX",
    "CliffordGlass86516",
    "lockboux8",
    "Z03Thund3r201910",
    "1eliery7",
    "StanleySalazar24",
    "1herald7",
    "Turbo_Duck51",
    "1nsmile7",
    "1pendbudd9",
    "xoguy5",
    "zarticles9",
    "xmaflagal9",
    "XxLuk3Slim3Min3rxX20",
    "gustionio9",
    "CristinaMoon993",
    "xtantance9",
    "zsk8r5",
    "PoohOneill60220",
    "oulinesyn9",
    "ZoeBacon2014",
    "owaves6",
    "ztionet7",
    "zotheadim9",
    "z1wiz5",
    "broodzsound11",
    "ShelbyParrish2004",
    "ognome6",
    "zwickedtao10",
    "1stooplol9",
    "XXPULSECHAOSXX2013_Y",
    "editorodark11",
    "zamylling9",
    "mans1z6",
    "FrancesTorres2931",
    "vulcalcoz9",
    "intelt17",
    "zdeonut7",
    "kenkao6",
    "KurtCyan94",
    "Turbo_BEAR2007",
    "VeronicaBarr55",
    "DerekSullivan61489",
    "XxNoah_Ac3xX51",
    "oheinesto9",
    "VenomAce2004",
    "WaynePayne84620",
    "1tahood7",
    "truongphak5",
    "XxWolfBladexX2020",
    "JenniferOrozco16187",
    "CandiceLutz3396",
    "BrianMcdowell23339",
    "ouseworz8",
    "kurisu1x8",
    "XxNoahVortexxX2008_Y",
    "truongphak9",
    "Ven0mMaxNight",
    "hufforma19",
    "cunjani18",
    "HeatherVance5",
    "oemediary9",
    "XxZapDragonOm3gaxX",
    "XxZoomFusionxX201466",
    "osameynes9",
    "scannerz8",
    "DebraGeorge51254",
    "JeremiahGonzalez4067",
    "1thedevil9",
    "VIPER_Vortex2011",
    "JillCisneros324",
    "ogodzillashay13",
    "DouglasCervantes10",
    "BelindaWebb95090",
    "truongfha2",
    "JakeCherry410",
    "1woodeert9",
    "TriciaAlvarez37458",
    "XxIsaac_LionxX2011",
    "fruitistx9",
    "featuredz9",
    "1anguris8",
    "inesentz8",
    "ZapSlime2015",
    "XxAddis0nLuckyxX2014",
    "Xx_JaydenSaberWraith",
    "EricaEwing27",
    "truongphak7",
    "zgiggly7",
    "epicohelpful12",
    "hypnonz7",
    "XxIceFlamexX30",
    "zenerne7",
    "oneedgeri9",
    "ShelbyMurillo10",
    "1phobic7",
    "Tig3rAquaBlad32010",
    "RubenBallard23",
    "xcloebile9",
    "1toteeket9",
    "Xx_WilliamCraftHyper",
    "puffx5",
    "ShannonWebster363",
    "cannitx7",
    "DonaldFranco6095",
    "oanneerbu9",
    "hurtwrian110",
    "fischaduz9",
    "ogroup6",
    "1valued7",
    "LeeRice62965",
    "Xx_RocketTurboCookie",
    "angurisz8",
    "nallfoxo8",
    "ificbluz8",
    "XxCyber_GamerxX2012",
    "XxHyperBuilderxX2005",
    "DebraDennis2106",
    "AnneShepherd55",
    "paradnx7",
    "zlaugh6",
    "dashalx7",
    "1choosez8",
    "STORM_Cooki345",
    "AdrienneDuffy2398",
    "1clear6",
    "1dirty6",
    "oserene7",
    "oledger7",
    "xererexci9",
    "angelicz19",
    "XxJamesBlastxX35",
    "EarlHuang4",
    "hackboarz9",
    "XxBlockLegendxX20202",
    "XxDarkSilverxX2023",
    "flookeso8",
    "BearyAyala7012",
    "xseilli7",
    "zoguitarist11",
    "MikePink15",
    "diumbo6",
    "guthmatz8",
    "cancismao9",
    "1inlove7",
    "jabio16",
    "inderato8",
    "XxPulseTurb0AquaxX",
    "JeremiahFrancis58175",
    "TiffanyRogers61183",
    "Turbo_BLAST57",
    "SnoopyPatel8",
    "BugMorton65855",
    "ToxicCircuitLegend20",
    "CaitlynBooker5",
    "XxAmeliaGamerxX2008",
    "bornxtoxic10",
    "XxFlashPandaPr0xX",
    "1snowboard10",
    "JeromeHarrington276",
    "ViperSilverDragon200",
    "XxOrbitEch0xX15",
    "NeilNixon3988",
    "RebekahPalmer2020",
    "xelveil7",
    "AlisonBoyd8289",
    "XxLight_GalaxyxX2014",
    "olocal6",
    "spriumax8",
}

local BlacklistMap = {}
for _, name in ipairs(RawBlacklist) do
    BlacklistMap[name] = true
end

-- ==========================================
-- [ PHẦN 2 ] UI + LOGIC
-- ==========================================
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
