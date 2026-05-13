-- =============================================================
-- DRACO ANTI-STALKER V15.5 - FULL NEW BLACKLIST REPLACEMENT
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
    "Drift_Sky6485", "SylviaArmstrong30792", "VantahCRaveny184790", "ShirleyRich329", "JoannCollins5892",
    "KatrinaCollins45553", "LeeChandler45", "MandyBuck81471", "XxHazelEpicxX85", "XxNoraMaxxX31",
    "Ethan_B3AST61", "Br00klynnFlick2009YT", "EmilyPh0enix9390", "AnthonyCore6431", "Br00klynn_ST0RMY58",
    "LukeBlush15", "JanetMcneil612", "ShirleyLevy85", "XX_Am3liaC00ki3Night", "ShelbyPennington35",
    "IsaacSparklyWraith23", "BrandiJordan1810", "MarcusLeblanc90", "TheresaLee232", "LeahHiggins2248",
    "RubenYellow06", "HendriCharlie99", "PamelaStokes82", "XxElijahEch0OmegaxX", "XXSAVANNAH_RiderxX40",
    "NeilRich843", "Aisha_Chill7280", "CraftGlitchCraze2007", "ConnieMejia3", "EvanChase7",
    "JulieRomero105", "TwilighturPixelP1758", "TjallingGeerte2000", "MichelleFarrell85737", "BalqisC3l3stial7523",
    "JellySaberChaos2024", "TraciCarr915", "GaryReid5", "ShirleyShea6", "LuckyCraftSkater2013",
    "ChadCooke082", "HannahGigaPho3nix202", "RobynDeleon7", "NanneDirke03", "L0uis_R0gue4443",
    "YolandaJennings10", "AnthonyRussell6674", "ErinMiddleton9", "BeeBaldwin1893", "TanyaBenjamin8247",
    "Xx_SparkPhoenixSlime", "UltraAlphaDrift2011", "ToniDominguez2047", "Charl0tteSkater58", "Xz_GLITCHMGCRAZ3TGEC",
    "HarperAquaIce2024", "ScarlettArrowRocket9", "MalikHull718", "LuisFitzgerald752", "JillianCotton76",
    "NeonHero202416", "BradleyHobbs263", "RaoulRuite98", "KristiCarney08", "DerekAndersen67606",
    "JoeUnderwood4360", "ThomasReynolds4178", "EthanAceSparkly20063", "EbonyCarter6", "Wraith_Eagl3201293",
    "XxDawnCircuitFrostxX", "StormVoid201819", "JanicePrice41616", "RebekahKrause5", "MarioHawkins58251",
    "Xx_VictoriaBlastSkat", "DawnGalaxy201564", "R0gueRider5857", "XxHazel_DuckxX25", "JonVelazquez20085",
    "Shad0wSilverAce2002", "ColleenBerry830", "VictoriaBaker188", "WilliamHarper5304", "JenniferRoman873",
    "LawrenceDuran74166", "KyleLinen94643", "BeastRiftSt0rm2003", "TrevorHughes76961", "AlexisShepard4",
    "LoriKing1391", "LarryHuffman25622", "RonnieSullivan75426", "MelanieSingleton17", "XxAm3liaByt3xX63",
    "NatashaMullen75", "ShawnKoch0855", "SilverBlast200463", "KlaaseDongxue06", "CalebLong7205",
    "DeannaVincent521", "CactiPeck45994", "AshleyBautista84831", "ReginaldRussell82429", "XxChillC00kiexX2013",
    "BearyPace6491", "TamiDominguez10", "KarlMorse3528", "PhillipKnight27", "XxZer0_S0nicxX200431",
    "ButterflyPantone1129", "MelissaSeashell80643", "TamaraColeman3675", "HawkHunter5347", "Emma_Pho3nix201339",
    "Claw_Bl0ck34", "CodyJohnston35102", "ClydeWille00", "SparkPhoenixAqua29", "MonicaWeber64",
    "FabrenBoudewijn97", "Zo3Sky37", "ClaytonVelasquez59", "MaxLionGalaxy2005", "RoseMarks2",
    "CheyenneCarr625", "Bacon_Miner61", "BaneRiftNova71", "QuintenZoey1999", "AustinSellers222",
    "LuisBush0540", "GilbertRiggs1713", "JayKaufman6979", "GailClayton10301", "DarrenSullivan461",
    "BriannaSutton60", "GabriellaPotts2", "QU33N_Dark32", "Byte_Nebulon4396", "StefanieMorgan2702",
    "WalterGonzales50918", "KristinaHickman7050", "JorisLex2004", "BethPitts55", "VickieRosales54823",
    "Charlott3PlayzKing20", "TanyaBenton4", "LydiaJohnston0648", "TimothyWilliams116", "Cooki3_Starry82",
    "DeanWalters32076", "BrianCunningham3997", "BrookeNorton22", "SaberPrimal201283", "ShawnJordan2503",
    "KentHarrington62616", "SonyaBridges4", "Luk3Inf3rno51", "LoganCooki321", "V0rtexDawn28",
    "PlayzNe0n202052", "DahyunWill95", "G0ld3nB3ast25", "MatthewDunlap5079", "Sami_Void3946",
    "ZapTurboSky2012", "eluTigerSilverCore", "TannerCream5670", "XxEch0Li0nTigerxX", "XxLaylaBanexX65",
    "H3roChas390", "XxPix3lL3g3ndxX79", "GregRose05", "ReginaHernandez52008", "KathrynGolden4",
    "AndreaHoward47197", "PamMason71914", "ViralCtMiragea111294", "ShaunHamilton87156", "NeilMason5493",
    "XxDanielWolfFlashxX2", "SheriVelasquez686", "Aid3nSonicAc3", "RussellLowery519", "Rabab_M3cha4478",
    "CarolynDodson5973", "MercedesRoy46", "Xx_CHARL0TTEWRAITHFL", "PowerHazeRocket22", "Charl0tt3GlitchWrait",
    "PhilipLion9680", "FabrMel2003", "TamaraMeyer39", "RitaWaters6", "Qu33nLight96",
    "ScottButler114", "Inf3rno_Playz37", "FlameLegendMystic33", "AaronPowell913", "SelenaNelson6811",
    "LatashaDuncan96281", "LindaFreeman4", "Aur0ra_C0re9807", "BuilderSaber9707", "HunterWebb3771",
    "YolandaReid485", "Abdul_EchoRunner4780", "PlantKnapp67", "KristenPotts534", "SherryAndersen42",
    "Pho3nixOrbitEagl388", "JerryCampbell8339", "ParkerMcmillan83328", "ParkerOdom20659", "MeredithNunez7703",
    "AceMagicOrbit2004", "DerekMooney15933", "BlossomingNguyen0039", "LeroyBuckley3248", "LegendStarryCraft77",
    "RichardBishop06", "VeronicaMadden6667", "FlowersPerez636", "CynthiaMalone63576", "XxLaylaEagleClawxX",
    "XXSPARK_IcexX97", "VortexFireRider2017", "CalvinSage6", "TracieSnow12246", "XxS0phiaRiftViperxX",
    "CraigHowell04508", "IsaacDaniels9492", "Harp3rBuild3r201191", "RandyBurch1705", "MarcusWarner0200",
    "DerekRandall083", "StacieVance066", "WraithRocketRider24", "TomObrien0", "BrandonHenderson2290",
    "MorganErickson132", "AlexanderEspinoza414", "LubnaLegend2099", "AllisonBranch58", "NicoleSellers99125",
    "SierraRobles2289", "LukeSimmons095", "CollinKing951", "BaneSkyDrift2021", "EllieShad0wN0va",
    "JoshuaCaldwell68429", "Pix3lV3n0mOrbit2017", "GabrielEch049", "JAXONMOONPHOENIX_YT", "GilbertPetty020",
    "VictoriaLarsen216", "IguanaPowell481", "MaryLarsen04", "EwoudZwanu01", "RandyBridges3477",
    "SebastianHazeStarry5", "AdrianRangel6241", "MelindaValentine9988", "natalieAuric4497", "CheyenneBlack6",
    "IceEagleShadow2004", "BlizzardtLDancersLCo", "MiaToxicVenom49", "SierraCollins13899", "WendyYork28294",
    "ByteCookieSparkly95", "PrismPowerCraze2016", "ThomasWiley45899", "DawnHiggins16183", "LanceBrown05",
    "JoanAlvarez86538", "Chlo3B3arCraz32009", "DeannaMcdaniel54842", "TommyBurgess17", "XxJax0nArr0wBlizzard",
    "StevePale1524", "JasmineCampbell551", "VioletRodgers7", "PatriciaPatel2508", "PixelFrostRaven2009",
    "AlyssaBeard0", "AngelicaThompson2230", "XxWolfStreamPixelxX", "ShannonSpears96", "AlanPlum7533",
    "SallyKemp7655", "JennaMcdonald1210", "Her0Bac0n48", "Jacks0nFr0st66", "ErikaHicks57553"
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
