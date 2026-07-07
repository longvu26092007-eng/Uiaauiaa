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
    "zepherydg9", "InfernoAlphaFlame42", "Xx_Pix3lat3dBlaz3Dri", "UltraLuckySpark2010", "StreamChaosBlast2015",
    "xbradel7", "KylePower8650", "Aqua_Pho3nix11", "orocket7", "PrismPr065", "exclanz7", "buddiezweaver13",
    "XxHazelPowerGoldenxX", "ZaherWarden5377", "XxHeroFoxDragonxXYT", "obluefilm9", "Gh0stCyb3rN0va",
    "J3llySt3althPanda200", "GamerR0cket16", "CodeSlime200954", "zwaveo6", "Stream_Chase201717",
    "InfernoCircuit201576", "Talal_Jelly2505", "SkyKingC00kieYT", "DawnIc3Pix3l2014", "zaannec7",
    "SamuelPandaStar20067", "1draven7", "busityrx8", "F0x_INFERN0202440", "AddisonStarPixel11",
    "ZapMast3r202432", "devonwo7", "WillieGallagher299", "kiwiox6", "GlitchHyp3rFlash2023",
    "Y0un3s_A3th3r1709", "VenomWraithMax2016", "XxAvaDanc3rxX26", "F0xHawkPh03nix2015", "ZoeEchoHunter418",
    "XxL3g3ndShad0wxX2011", "SparklyWraithSky2012", "ZapInferno90", "GlitchPow3rMax", "ngoc125nn",
    "Zah3rFlash2247", "XxMoonSaberxX2021YT", "XxToxicVort3xxX2016Y", "AbbasN3bulon7674", "Thuraya_Echo7865",
    "PlayzCookie2015YT", "RocketBlockDark35", "EagleAlphaOmega2020", "Sharon_Bolt4615", "EchoPlayzSlime2005",
    "WraithLavaBlast2014", "Wraith_Smash9383", "Isaac_Striker3237", "PowerHero9830", "XxGlitchMagicSaberxX",
    "XxEzraGlitchSonicxX", "Gamer_Miner2790", "Fr0st_Eagl3201279", "ngoc121n", "ZaraT3chno3192", "1warmethe9",
    "ngoc119n", "CarterStealth201743", "ChloeThunderStorm201", "StarryChaos200457", "JellyFusionUltra2005",
    "LionStream200347", "SparklyC00kieMax2004", "Skater_Galaxy200318", "ngoc097nn", "ZapPandaTurbo57",
    "SaberCrystalRift2003", "GalaxyGiga2822", "zmyhero7", "AvaRavenEcho2012", "zintincr8", "stixypla19",
    "poshyo6", "XxChillWolfKnightxX8", "AubreyNightDuckYT", "Xx_AlexanderNovaEpic", "XX_Fusi0nBlizzardLi0",
    "Sara_Miner8182", "Playz_Lucky57", "oryoth6", "Harp3rQu33nFir32013", "Spark_Nova81", "XxGhostToxicZoomxX25",
    "XxLight_ZoomxX202279", "GraceFlameStarry2024", "LuckyF0x200950", "RavenHazeFox2016", "MarkSynth6776",
    "citeen17", "Xx_CircuitFr0stS0nic", "LujainRogueX848", "V3nomMin3rLava93", "SCARLETT_Raven201152",
    "W0lfSparkly202144", "dispanz7", "Specter_EchoBlade374", "MysticHunt3r_EchoX22", "Scarl3tt_Blast2014YT",
    "LaylaFoxHyp3r16", "Br00klynMystic201354", "GAMER_Playz202139", "BUILD3R_Zoom201548", "XxStream_WraithxX45",
    "Salma_NebulaX5783", "S0nicRaven70", "MasonCyb3rIc311", "Rania_Rider728", "EvelynF0xFlick2013",
    "Silver_Star202349", "Harp3rSlim3Block2018", "BuilderTurboHaze68", "NoahMin3r50", "LunaHawk201847",
    "Anthony_EchoX3488", "EmmaSparklyFire20132", "xcusivest9", "GigaRogu37981", "zrestport9", "Fury_Haze202419",
    "XxKayl33LavaSparklyx", "XxCraftBac0nxX50", "Skat3r_Dragon47", "Hunter_Spark200329", "Dani3lGold3nLight",
    "XxMicha3lSonicSparkx", "Inf3rn0St0rmyPh03nix", "XxCarterCrazeKingxX", "V0rtexG0ldenC0de2008",
    "Isaac_Cha0s31", "Mast3r_Hunt3r53", "XxVoid_DawnxX201745", "BeastSparkR0cket2012", "IsabellaDuckNeon2003",
    "Hyp3rSonicVort3x2002", "PixelOblivi0n7551", "Scarlett_Queen201035", "Drift_M00n200588",
    "CharlotteCyberRift75", "XxKayleeCookieThunde", "XxHyp3rTurboNovaxX20", "Cookie_Silver201135",
    "Levi_GOLDEN201836", "Isab3llaMagicEpic200", "XxHunt3rMoonPuls3xX", "Gam3r_Rav3n200758", "LavaNinja201740",
    "hipuro6", "EchoX_Sonic8346", "XXHAZEL_OmegaxX15", "Hassan_Mystic2407", "1artsyner9", "XxH3ro_STARRYXX20051",
    "Xx_ThunderShad0wLi0n", "zetters7", "Charlotte_Raven2007Y", "zgollsona9", "ostronger9", "murteateo9",
    "ineveidx8", "Qays_Master2582", "GH0ST_Slime28", "Frost_Blizzard201042", "ngoc101n", "tenstor18",
    "oanime6", "1ntwork7", "ScottAlpha6013", "Dorothy_Quantum5179", "XxBear_LuckyxX73", "zspuffy7",
    "onotday7", "XxNoraLegendxX2021YT", "Xx_SEBASTIANFUSIONPA", "InfernoRiderTiger202", "Ech0Bac0nViper14",
    "BilalAether6769", "XxAbigailRocketFlash", "H3r0Ech0200511", "Blast_Pixelated20224", "XxEthanProRiftxX22YT",
    "AshenCha0s4992", "Aur0ra_St0rmy201355", "XxLucasBaconIc3xX", "xstrytack9", "Dark_Viral2172",
    "GracePhoenixHero2017", "CircuitLightBear2015", "thinkernz9", "JaydenHeroNinja2010", "XxHaz3S0nicxX2016",
    "HannahEchoEagle2010", "AriSolarRunner5625", "Br00klynFr0st201629", "FUSIONZEROGLITCH85_Y",
    "KayleeFireVortexYT", "Grays0n_Shad0w201127", "AbedFrost891", "1enistech9", "Skat3rLuckyKnight202",
    "XXDRIFT_Turb0xX99", "Void_Smash2737", "1stanni7", "EllieMoonStarry65", "XxC00ki3_Inf3rn0xX78",
    "XxNe0nStarBytexX", "V0rtex_R0gue97", "XxOliviaFrostxX63", "FusionKingMax2020", "oksidjima9",
    "zantumlz8", "Flash_Ghost40", "BryanCircuit8926", "xmower6", "Dark_NE0N87", "Inf3rno_Pho3nix80YT",
    "JaxonBlaz3Orbit75", "postur17", "Rider_Ninja202362", "RashadHollow569", "Haz3lMin3r23",
    "NebulaX_Rift4707", "XxSkat3rNovaFrostxX", "Zoom_Pulse202247", "ocyber6", "XxMoonNovaClawxX",
    "phobicz7", "days1o6", "xkentros8", "JaniceZoom7785", "XxDanielZapxX200424", "CraftSkaterCode2012",
    "ZeroPlayz202376", "JudithFlick1782", "Adel_Turbo8729", "bug1updates11", "Frost_Shift3r6796",
    "EagleGamerJelly64", "L3g3ndPrimalBac0n", "LunaGigaLi0n2007", "GeorgePixel9022", "rob3rtHz31884",
    "P0wer_Flick27", "ClawGhostPixelated57", "TamaraChill6208", "Eagle_Sky201311", "V0rtexRunnerEpic3568",
    "Rock3tCooki3Claw", "GalaxyEpicPlayz2002", "GlitchDarkPanda70", "Munir_Panda288", "FrostLightCode2023",
    "DayanaBlanchardmz2rq", "JackPandaVortex2003", "xzippoo7", "WillowMagicNeon2002", "Z3r0UltraHaz3",
    "AlphaBearHero2004", "LinaTurb02238", "ngoc098nn", "olatime7", "NovaOrbit200949", "CrystalZapCod3201156",
    "FrostHunterRogue4718", "Xx_TigerC00kieStream", "LucasChas3200299", "oilower7", "CharlotteWraith2684",
    "PulseMasterZoom2017", "BearLavaPixel2023", "Warp_EchoBlade1199", "JamalAlpha2887", "Storm_Ban367",
    "XxChloeBanexX95", "MoonBlast200749", "ngoc134n", "AubreyDawnEcho201240", "WilliamG0ldenUltra20",
    "L3viKingBlast2006", "HannahMoon201645", "S0nicChill201679", "XxStormZ3roAquaxX200",
    "Xx_VICTORIAVIP3RSAB3", "XXEAGLE_V0idxX23", "1cist5", "olead5", "Vict0riaPh0enixFire2",
    "HannahHyperLight2020", "1iatems7"
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
