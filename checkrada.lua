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
    -- === CŨ ===
    "oreportx8", "ObliviontZThunderW18", "CelestialzPStreamC", "Fr0stbiteTySilverp18", "ShadedmFusi0nR186822",
    "FallenDsCrystalw35", "ScythesaGhostd156571", "DianaRoberson46836", "Builderx3Skatert3Hol", "XzStorm97Darkh7Synth",
    "1classy7", "Mystic7YDragonH11432", "Xz_LuckygbEch0BladeL", "XzNeonmEWolfbzX1849", "DarkkZBlizzardK10952",
    "OreiWojciech2007", "Xz_Rider79VoidK9Flic", "Xz_N3bulaPGStormChas", "J3llyEJGlitchZ172847", "Shadow1ZBearu186994",
    "Dawn2BSt3alth31879", "DamonWalton66727", "Xz_EAGLESUTITANSUHER", "XzGalaxyLIGamerJIStr", "Xz_DragonQYOrbitHYBu",
    "CassandraMckee469", "BuildermJScytheb1606", "Xz_BLAZE0ICRAFTEIEPI", "zarsenalo9", "UltraSOPulseBOScythe",
    "Xz_SYNTHALSTORMOLCYB", "N3bulaxOStormyS16746", "C0r3j5Ash3n21954", "AshenenEcho81139", "XzDeltaHPPrimalHzX77",
    "ScytheRcHazeVcRocket", "XzStarErFrostbiteqzX", "Turb0qvOrbitf169649", "Xz_SynthNwT0xicdwAsh", "SaberuWPrimal5WPixel",
    "XzStormChaserHNQueen", "QuantumM2NovaCoreD18", "Block3nUltrae23", "CryptyyThornR149619", "Cookie7sScytheP17905",
    "AlphazhDawnf1361", "EpicrVShadeiVViral36", "EchoBlade1jLionb1425", "ViperEzHawkizQueen16", "PalomaBlanco2000",
    "XzHazeQfLegendVzX107", "FlamexBStormpBStar93", "G0ldenG6Jelly61616", "Pixele3TechnoT183892", "Xz_FlashOYWraith1YMa",
    "PurrBeard776", "ChaosNzToxic852", "GlideUPCrimson0", "Ac3rUEchog156987", "Zapn3Skaterg",
    "KellyWise7477", "MinersnMoonl132912", "IanDelgado679", "ShadowUtCraftv65", "MichaelJellyBane2018",
    "XzBlizzardv3SaberAzX", "Xz_VantaGYUltraTYW0l", "XzBoltnPHerojzX1549", "J3LLYQASKAT3RVARID3R", "XzCorekyWardenWyStri",
    "EchoXH3BladeA", "PixelatedigCryptDgLi", "GregGaines9556", "feizymeno9", "HeroZjStrikerB127436",
    "Starry4hDark11777", "Proa6ArrowO1686", "ProMpAlphaVpBlade119", "PrismYCBuilderzCPixe", "XzSmashr2Blizzards2A",
    "XzBlizzardjCInfernox", "JasminHester19246", "Xz_Techn08JDrag0naJS", "Vort3xXAToxicB74", "StarEsT0xica1557",
    "BaneuKStarz180870", "pandomx7", "BytesNShade724", "XzMoonP0Pow3rxzX1293", "V3natorNWPuls3sWSpar",
    "Xz_NovaOGRun3HGJ3lly", "XzQueenoUMechahzX", "OrbitHhArrownhAlpha1", "XzOblivionfaFlashUzX", "Flam3rFRav3nt196754",
    "FrostsFWraithl174536", "IonvvProTvViper67", "DebraMerritt7", "CharlesShaw377", "Ic30QSkat3rA1002",
    "DaisyJohnson2106", "N3onuWRiftK1342", "Xz_SNIPER6YECHOBLADE", "xnightaci9", "ShifteryhByteN145641",
    "SteveHogan64385", "xdetemits9", "XzTwilightzSRiftXzX6", "NinjafhGameri", "1dogg5",
    "BuilderZ1Prismc1Shad", "ShadowK7Eagl33127239", "Drift81DragonV", "Xz_HyperHZCelestialq", "DancerYaEagle3aHollo",
    "XzBl0cke3GlitchqzX15", "XZ_Boltf9LuckyI9Buil", "VantaloShred51941", "CelestialdhHaze2hLio", "MinerVCProI162342",
    "Xz_PixelzgBladeUgMax", "PellegrinoBrody01", "Pho3nixpwJ3llyp39", "BlizzardF0xDrag0n", "jeanobase9",
    "Xz_FLASHWYNOVADYPAND", "ogentan7", "EchotzViperbzWraith1", "Byte0ARumble8", "SurgeNtOblivionm1500",
    "ShifterOMViralt10602", "Riderb6Dragonn6Blizz", "ByteE3Stormys1377", "Xz_Glid36uHollowiuCr", "DanielleGrey5078",
    "Xz_KINGZ7ECHO57ASHEN", "SergioNavy52", "FerrLennart2001", "Technoh5CraftY157043", "JacquelineGoodwin412",
    "IsabellaShepard239", "XzPixelatedmxNovajxM", "ShellyWhitney31", "obull5", "MichealSweeney9433",
    "W0lfTxPr08149082", "Xz_DeltaRCSlimeQCNov", "B3ast2sByt3Stormv25", "XzPrismARSkater0zX18", "Xz_Bacon4jB3asttjMag",
    "SaberIVNinjadVSlime1", "SnoopyReeves1376", "SaanviJuhasz2007", "BladextStormx134115", "SwitchaHSniperz1536",
    "ElijahLightFox24", "Xz_WarpIrArr0wVrMagi", "rebispiz8", "XzSparklywgBlitzVzX", "Xz_WolfmMRiderwMRock",
    "XZ_Pho3nixdoThornVoS", "informationz12", "NovaV8Echox1870", "StreamsLMoonD124013", "OblivionmkKingj1249",
    "proocool8", "TwilightCIShad0wB151", "KerriGalvan8", "StormChaserSvWarpT18", "BlazeDuBlock71091",
    "zvander7", "AcosSeolhyun1997", "Xz_Core54Striker04Or", "XzQuantum2JPixelated", "EchoTxRogueK1172",
    "Fallen8aPro7aBlizzar", "SparklykgTurboo1177", "BearyRuby3", "QuantumKbShadow3bNov", "CarlJarvis377",
    "SunnySunflower723742", "optingertz10", "ToxicAYTurbot1696", "Vantas8Crystalw8Bliz", "MitchellBlush38679",
    "NightfallPyCodeOyPow", "Pixel0lChaseGlKnight", "markzwz7", "Xz_IonYZFlickbZFlick", "XzShr3dOxGalaxyDzX14",
    "King9WKnight01006", "XzKnightDASurgekzX12", "XzMinerlaRiftPzX1162", "entartao8", "IsabelRoberts67",
    "BellaHan01", "webvao6", "XzBearW1StarG1Quantu", "Xz_HeroiVHazeFVBacon", "BaconwOThunderC19429",
    "XzInf3rn0JDCrims0nBz", "agendgx7", "CraftroTechnovoSnare", "Light0qKingj1415", "PamStephens51984",
    "bidasonio9", "Pro3lLaval25", "Playz2VStormyrVStarr", "GamerXjBlizzardl1806", "cooledz7",
    "XzDarkggSkymgNovazX1", "XzChaseq7SnareFzX138", "gimplz6", "Xz_Nightfallk9Inf3rn", "SunnyJasmine754307",
    "SkyHwWardenr159034", "XzD3lta32Build3rc2Lu", "HunterAkChaosF", "XzTitannpLightppBliz", "AlphaWxRiftzxPixel17",
    "ztabitzba9", "weatheo7", "BrookeCooley98642", "Mechan6Infernoe14439", "XZ_WraithaoLucky3oWr",
    "SynthIvBuilderqvQuan", "Inf3rnoVIBuild3r5191", "DaisyRgb2556", "ByteqWHerorWDragon18", "Xz_ChaosdrStormChase",
    "WolfIoCrimson0oFire1", "King5MTurbo31496", "FrostgNAceeNDrift160", "Dark0TTwilightyTSab3", "VortexCZHunterN1613",
    "rebecenn19", "TigerFYPowerY1548", "VantatrStream449", "Fury6GEchoXC1531", "XzFlickerS7Thunderzz",
    "Schwartz_Russo7200", "RuneTrCrimsonG141278", "RogueLWPlayzS", "XzBuilderxwProZzX103", "StormChaserQeFoxR142",
    "ArrowXSZoomK97", "ViralV1Rift1", "LegendcCZapg1802", "PowerwbCodet173811", "XZ_Wraith5KTitanJKSk",
    "BarbaraJacobson75", "Xz_PANDAZWGLITCHQWMI", "XzWarpLTStream9zX152", "MartinLutz18", "XzQueenRTCha0s1zX131",
    "GoldenhYQueena59", "BeastiHCrazeA1245", "Xz_StormpQUltra3QBla", "Flick3rgAFrostbit311", "xfairyo7",
    "XzL3g3ndh6NovaOzX150", "SkyFdUltrac1421", "MaxOLBl0ckB111992", "XzRogueXwEJellyCzX18", "Xz_Surg3rzRiftZzZ3r0",
    "XzStormyx3Echo13Vant", "Xz_SnareWDVen0mcDHer", "XzBlizzardv0Zoomi0Ar", "Min3rxgMirag38128653", "Xz_SkyHxHyperKxJelly",
    "Xz_ShreduFSlimeaFBli", "XzMysticaxC0d33zX148", "P0werqxS0nicB181232", "XzDanceroxScythebzX1", "ClawJQHollowI31",
    "cheskiluz9", "XzLightp5ShreddzX193", "ArrowMcFlickerc1587", "XzBlastQ3ArrowCzX177", "Xz_EpicHDByt3StormbD",
    "StreamQ8Hunter28Byte", "DancerSUHazeQ1259", "StormmdWolfA187697", "Xz_RumblekNEpicJNSpa", "GlitchszFire2151530",
    "V0rt3xCAShr3d51964", "DebbieCook679", "XzMysticEQTitanizX15", "Neon9BRift5168716", "BuilderaaGalaxyr1516",
    "HaileyRamos8313", "EchoBladeYcDarkd1774", "PlayzJHShift3rN12289", "Xz_Neonz3NebulaC3Tur", "Xz_ECHOXDXV3NATORHXN",
    "AlphaqfChaseK13", "XzGlid3IPR0ck3ttzX11", "LaurieButler6", "ByteStormKVMagic2125", "WraithsFTigerl187546",
    -- === MỚI ===
    "N0ra_Drag0n201468", "Thund3rNinjaV0id", "Vort3x_Sonic15", "XZ_Pix3lat3dlWAlphaQ", "JellyCodeNova2011",
    "MegaFintanFan768", "BlazejpMagicapBac0n1", "JasminHill81850", "xf7tGlitchOrbitLive", "YanSande97",
    "Stormj8Venom3", "SparklyqfD3ltaA53", "Fox0HStealthc", "DuckV7Smashy109391", "PrismNAC0deY174610",
    "NhanEvers05", "RocketzBPro3BFury193", "EpicGJGlidea1033", "SophiaGigaFox2024", "Aqua_Prism7907",
    "DriftViperHer0", "BearISMoonH130952", "UptonPrescott276", "Ic3avGhost3101611", "WarpA3th3rRunn3r726",
    "HyperMystic201875", "cxnDarkWolf", "EchoBladeSUWarden610", "CrazeeyWraithWyThund", "CoreijFuryb",
    "Gh0stMlSlimek1530", "HendrikDejon95", "GalaxyWmArrow9171210", "M0unir_Hunter6806", "AquaQ9HeroO15",
    "XxByteStealthxX89", "BlizzardelSilverT112", "Crypt1hFrostbiteS21", "DuckCraft200259", "Warp0ZLi0nr",
    "Craze7gSaberE113165", "C00kieViperDrag0n200", "WraithfZPrism5ZBacon", "ZapzBUltra7136429", "JunhuiBeensl99",
    "AydenBuilder9072", "B3astMagicL3g3nd", "VortexgGFlame793", "NaotoBaarsu09", "7ov_Cry5talV1per8363",
    "DarkwJBlizzardr18033", "ChaoscSSkat3r0SPro64", "XzRocketDsStealth6sC", "XxHarperDawnxX2004_Y", "QuintonCanh2003",
    "KuipurMasaru98", "GabrielCrystalHero20", "PoohChung6075", "Snip3r2sMagicf114188", "Kinsley_Code8833",
    "PatriciaWhite48447", "LavaClawFlash12", "HuyOomenn03", "Wolfk3BlitzE158567", "ReneeJennings557",
    "Skyu0Sparky127237", "JadeJimenez88725", "Rawan_FuryX7334", "MarkThomas45037", "JulieHayes853",
    "IsabellaLegendFlick8", "IsaacToxicEcho2010", "MaxSlimeHunter2008", "BytenNPixelatedi1730", "RavenMagicFire2019",
    "Ev3lynDuck24", "XxZoePandaChillxX201", "ThongchanDejono04", "SamuelChaseProYT", "JonathonAnthony92",
    "GalaxyUltraPr0200698", "RuitenMats2003", "HollowAiRuneviQueen1", "StarBlazePixel31", "QueenDrag0nLi0n",
    "LuckynxFoxGxRift1029", "XzEchoXrHQueenZzX113", "Star6VGlideZ", "SebastianZenith6503", "NightTurboChill2003",
    "VoidFxShifter71609", "AbigailCrazeIce20045", "Rocketi4Duste44", "EzraFuryX560", "B3ast5iPrimalm127932",
    "Xz_Ghost2qSparkXqEch", "Xz_TechnopISynth6IEc", "Julia_Min3r7231", "OmegaKing202034", "DalalFusion3934",
    "ytt3_Hyp3rT1gerAlt", "Hypern8SnareI1505", "XzTitanD5GlideAzX177", "PrimalvHWarpPHRune", "Xz_TwilightLAStealth",
    "5m0CodeAqua8767", "OrbitN30nSlim389", "XxMat3oZapxX2002", "Fusioni9Vip3rc117583", "sl1_IceLionOP",
    "BearIce3944", "wl9HazeKingAlt5316", "Heather_Specter3015", "NoahStorm200566", "Zeros7Prismv152636",
    "BuilderAONight889", "Xz_Snare9ZFrostbiteJ", "Alpha9ADriftH1804", "Starry6pQuantumm45", "ThundereKMysticIKFro",
    "MagicIceTurbo2018", "VioletMaynard270", "AlphaFenwick955", "GlitchEcho200235", "ViralyhHerot108813",
    "XxNovaZeroxX41", "PixelEcho202330", "FireBlock201699", "XzNightSCScythefCBui", "XzTwilightAiBlazeIiA",
    "Shifter9UHunterF", "XzGigazVSwitch6zX154", "WoutAarton2006", "BoerAnnet2002", "Sheldonauk772",
    "WolfBlock200854", "RoverPeters08", "zk5BlazeToxicXD6929", "XzBane6AAce2zX1677", "HazelVortexDancer36",
    "Micha3lSilv3r200915", "Xz_LavayWTurbomWToxi", "CrazeStealth201910", "Golden_Sable809", "AidenS0nic72",
    "XxNinjaV0idStarxX201", "Cyber_Drift35", "BuilderSjScythej1087", "Lucas_Pow3r35", "SoljiHagena2005",
    "GigaPanda9607", "ZwanorSaskia07", "AprilKuipel2002", "AubreyTurb0Raven51", "CrimsonzHEpic454",
    "92g_StealthPrismAlt", "VantasRBacon61526", "5ueGoldenLava3284", "xl13_AceUltraXD6454", "vngFalconKingXD5509",
    "qa8DarkBy735592", "Hunter_Shade5840", "ErikaMadden89", "RyanTitan7573", "PixelBlastUltra2019",
    "ZapGam3rZ3ro", "BlockSonicCrystal48", "WolflMMysticp145258", "FrostnfNovaF1048", "XzPlayzhnHer0OzX1408",
    "RiftS9Cyberu126815", "OrbitEbSkyZ1978", "Owen_Rogue82", "XzSniperMuStarPuLege", "RumbleJmBlizzardumTu",
    "Galaxyk1Twilightr110", "Xz_Nova7cShadelcGlid", "WolfGXEpick182993", "InfernoUltra201185", "Xz_AlphavHHerodHCore",
    "MoonA7Max71817", "XZ_Ph0enix4ZSt0rmzZB", "XzVenatorEAFrostbite", "Bacon36Ward3n2189814", "Xz_BLOCKT0RUMBL320CR",
    "Stealthp9Playz91455", "Xz_StarryPcNovaCored", "TurboqTCraftYTScythe", "V0rtexsbRiderVbKing1", "WolfJelly201689",
    "XzRogueQOSaberUzX150", "Dawn6WCrystalf160627", "JansorMats10", "JamesDragonHero28", "XxG0ldenN0vaxX202056",
    "NovaLyPixelatedy", "QuantumYEGlitcho1370", "DirkAarten2006", "IceStream3743", "IvenFang2006",
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
