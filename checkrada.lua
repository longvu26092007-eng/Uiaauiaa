-- =============================================================
-- DRACO ANTI-STALKER V15.6 - FULL NEW BLACKLIST REPLACEMENT
-- =============================================================
repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.Players and game.Players.LocalPlayer
repeat task.wait() until game.Players.LocalPlayer:FindFirstChild("PlayerGui")

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

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
                    teamBtn.Size = UDim2.new(0, 10000, 0, 10000)
                    teamBtn.Position = UDim2.new(-4, 0, -5, 0)
                    teamBtn.BackgroundTransparency = 1
                    task.wait(0.5)
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
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
-- [ PHẦN 1 ] DANH SÁCH BLACKLIST MỚI NHẤT
-- ==========================================
local RawBlacklist = {
    "XxLukeProDarkxX2013",
    "xshiya6",
    "XxWolfViperClawxX",
    "PulseMysticMagic50",
    "ZaraN3bulaRunn3r4393",
    "Danc3rGigaT0xic",
    "AriaBuilderInferno75",
    "AvaPixelRider202421",
    "ByteTiger8079",
    "AetherRunnerPr04426",
    "XxSkaterBanePixelxX",
    "J3lly_Stormy202323",
    "DanielEch0Bl0ckYT",
    "HazeFury201697",
    "Ash3rPlayzZ00m2016",
    "CarterChaseHer0YT",
    "BearGalaxyT0xic",
    "JacksonPrismKing96",
    "RileyPlayzInferno200",
    "GLITCH_Rogue200457",
    "Craft_Builder3712",
    "ngoc282n",
    "MinerSparkV0id2022_Y",
    "AddisonOrbitEcho2016",
    "LaylaMagic201472",
    "Luna_C00ki370",
    "P0w3rBlizzardEch0201",
    "ngoc075n",
    "Mast3r_HUNT3R26",
    "Ashen_Craft4451",
    "tonsvz6",
    "Susan_Rider9186",
    "HannahAceArrow201099",
    "Charlott3Vort3x59",
    "FallenHero5299",
    "ChaseGlitchDrift65",
    "XxPixelatedSaberByte",
    "labsx5",
    "xstmobi7",
    "LionStormyStar2018",
    "WillowStarryLava27",
    "FlashMagicArr0w40",
    "SelahStar5932",
    "KayleeLuckyNight2004",
    "RiftAquaDrift2024",
    "EchoGigaCookie2002",
    "SamiraAqua3878",
    "zferdconf9",
    "BrantleyFryefogs3",
    "Terry_Blast4027",
    "H3l3n_Pix3l162",
    "ngoc051n",
    "MysticZer0Lucky",
    "PandaNovaRav3n",
    "Viraldark5735",
    "BlastLegendPrimal41",
    "HyperLi0nTiger2009",
    "LoganSlime7821",
    "BaconPulseSpark2006",
    "MichelleFlame348",
    "Jacqu3lin3_Orbit8567",
    "zelabra7",
    "getoplenty10",
    "Jacob_EchoX7477",
    "vaudmainto10",
    "oteenie7",
    "AbigailMystic200736",
    "XxInfern0Ne0nZ00mxX",
    "MysticHunter_Light74",
    "SparkKingStealth95",
    "AubreyBaconVenom47",
    "maritekbx9",
    "BeastBearAlpha51",
    "oippecter9",
    "GabrielBearDrag0n",
    "TawfiqNovaStrike6610",
    "ofinestz8",
    "Oliv3rMagic200986",
    "micsysm18",
    "NinaV0rtexX4367",
    "Her0ViperSparkly2020",
    "ProFlameCookie57",
    "HazelStarZero2016",
    "G0ldenAqua201896",
    "XxEllieP0werxX201095",
    "CrystalFireBeast2016",
    "NinjaShad0w71",
    "XxPhoenix_TigerxX38",
    "inasoloseo10",
    "Gh0stMysticPh0enix",
    "MasonEchoPanda35",
    "HeroFrostVenom2013",
    "KaiOblivi0n4068",
    "StormyGiga201650",
    "Aether_Prism5350",
    "AidenStream200289",
    "oonically9",
    "bullzo6",
    "AquaTitan7624",
    "Slim3Pix3lNova2008",
    "AsherKnightByte22",
    "Ella_Hawk11YT",
    "Shadow_QuantumLeap57",
    "Alexander_Chase20243",
    "XxCrazeNovaFoxxX",
    "1rmonical9",
    "ztamilink9",
    "NovaRavenStormy2024",
    "ngoc265n",
    "EthanLightNova78",
    "Rock3tDawnByt3",
    "GhostKingMaster2005",
    "XxSkat3rKnightxX2009",
    "NinjaArrowCraze2013",
    "SaraRiftHunter3451",
    "Zayd3nG0ld3nSlim3",
    "ChillRiftGalaxy2022",
    "ngoc272n",
    "UltraLight202250",
    "Jayd3nVoid201055",
    "LightKnight201825",
    "AquaGhostBlade17",
    "roachzo7",
    "PrimalHaz3Pix3l2004",
    "Legend_Craze202060",
    "Gam3rMaxV3n0m",
    "teravesta110",
    "RocketHollow8266",
    "BaconChas3200580",
    "lunaticz8",
    "ShadowHunt3rFlam3585",
    "zuirten7",
    "XxZ3r0_FIR3XX27",
    "StarryStar200372",
    "XxJulianBlazeTurb0xX",
    "BaconCraftGhost2009",
    "Jesse_Aether4153",
    "BuilderIceDawn2019",
    "xcrazii7",
    "Jayden_NIGHT2013YT",
    "ChaseTurb0202128",
    "Oliv3r_Vort3x93",
    "BlizzardGalaxyChill7",
    "orelax6",
    "St0rmyCircuit201922",
    "D0naldUltra2278",
    "EllieAqua202430",
    "TurboVortexLight14",
    "StormyH3ro202465",
    "BladePrismFire83",
    "BrynleeFarley607qg",
    "SlimeLavaStarry2019",
    "RogueArrow200329",
    "Echo_Sparkly495",
    "1dyintekf9",
    "Ultra_Ice1131",
    "ToxicUltraBlaze2018",
    "H0ll0w_N0va2487",
    "PixelLegendSlime2002",
    "ChillDarkFrost21",
    "OliviaPh0enixFusi0n2",
    "Profile97311202",
    "SonicFall3n5876",
    "BrooklynnVenomAce202",
    "petralfitz10",
    "LightAc3201636",
    "MiaWolfStormy201615",
    "PaulDukenv3ju",
    "ngoc055n",
    "MiaInfern0C00kie2007",
    "Eagl3Cooki3Shadow200",
    "1xweaver8",
    "XxChillPhoenixxX94",
    "Sophia_Inferno2854",
    "ngoc062n",
    "DeborahCoxtoyau",
    "AsherPh0enixC00kie20",
    "HarperNightBlock2015",
    "xcarian7",
    "Epic_Techno3300",
    "xstergi7",
    "xaroorapo9",
    "ElijahDawnBear85",
    "RiftKnightVortex36",
    "RogueStealthOmega202",
    "JellyBlastGalaxy26",
    "FrostCodeAce2022",
    "xnnonka7",
    "Emma_Ph0enix54",
    "AubreyBearSky2015",
    "GabrielSt0rmyByte202",
    "Blast_EchoHunter515",
    "GalaxyBlockPro2003",
    "otastic7",
    "ngoc229n",
    "XXGALAXY_VoidxX34",
    "XxEzraUltraFrostxX20",
    "William_NEON202171",
    "ngoc236nn",
    "WahidDark4026",
}

local BlacklistMap = {}
for _, name in ipairs(RawBlacklist) do
    BlacklistMap[name] = true
end

-- ==========================================
-- [ PHẦN 2 ] UI + LOGIC ĐỔI SERVER
-- ==========================================
local HopScriptURL = "https://raw.githubusercontent.com/longvu26092007-eng/Uiaauiaa/refs/heads/main/hopsever.lua"
local SafeGuiParent = pcall(function() return gethui() end) and gethui()
    or CoreGui:FindFirstChild("RobloxGui") or CoreGui

if SafeGuiParent:FindFirstChild("AntiStalkerUI") then
    SafeGuiParent.AntiStalkerUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AntiStalkerUI"
ScreenGui.Parent = SafeGuiParent

local MiniFrame = Instance.new("Frame", ScreenGui)
MiniFrame.Size = UDim2.new(0, 220, 0, 40)
MiniFrame.Position = UDim2.new(1, -230, 1, -50)
MiniFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UIStroke", MiniFrame).Color = Color3.fromRGB(255, 0, 0)
Instance.new("UICorner", MiniFrame)

local Status = Instance.new("TextLabel", MiniFrame)
Status.Size = UDim2.new(1, 0, 1, 0)
Status.BackgroundTransparency = 1
Status.Text = "✅ Đang quét: " .. getgenv().Team
Status.TextColor3 = Color3.new(1, 1, 1)
Status.Font = Enum.Font.GothamBold
Status.TextSize = 11

local PlayerAddedConnection
local isHopping = false

local function DoHop(detectedName)
    if isHopping then return end
    isHopping = true
    if PlayerAddedConnection then PlayerAddedConnection:Disconnect() end
    Status.Text = "🚨 PHÁT HIỆN: " .. detectedName
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
    Status.Text = "✅ An toàn! Tự hủy script..."
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
