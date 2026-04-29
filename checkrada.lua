-- =============================================================
-- DRACO ANTI-STALKER V15.5 - UPDATED NEW BLACKLIST
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
-- [ PHẦN 1 ] BLACKLIST MỚI (ĐÃ CẬP NHẬT)
-- ==========================================
local RawBlacklist = {
    "LeeStevens2399", "EmilyClements8643", "ToniShaffer28", "BethFoley86", "JansKieu2005",
    "XxNoahQueenCyberxX", "AlejandraWilkins84", "AdrienneBradford071", "RicardoLambert9077", "HollyShelton3656",
    "TylerBrooks155", "BethanyCurry4211", "BloomFlynn225", "EduardoBowers1125", "SarahDorsey755",
    "LydiaPhillips36", "WilliamHodge0", "BrentMartinez2603", "CalebMyers368", "JonathonRandall2088",
    "LoganGoodman816", "KatherineBishop59273", "DaleSalazar8660", "HaleyPalmer0657", "BrendaNewton5557",
    "BethanyLinen73", "CaitlynPadilla759", "TamaraKelly88224", "GlendaPeters35728", "CarolineCook515",
    "KaylaValencia395", "RileyStephens6832", "RobinMatthews72399", "SamuelGarner393", "CoreyWalls983",
    "SergioMccullough96", "LanceTran9652", "AprilKhaki4939", "BradleyBaker47219", "CarolynCruz614",
    "MatthewHester8", "ErikaLeblanc752", "JeanneRed7623", "WhitneyMyers72", "LucasLarson70",
    "VincentSalinas28", "DinosaurRojas6659", "BethanyBranch312", "BoerWilma2008", "CameronJones00",
    "MeganHooper02", "JanetUmber632", "BridgetWheeler040", "AliciaYang9977", "EllenEllis0759",
    "KimberlyRandolph299", "CharlesJennings5878", "KendraMora7509", "SheriLyons5150", "GlendaDaniels352",
    "SheliaPitts76334", "PaulHerrera779", "DinosaurRogers61357", "SheliaLyons44385", "CoryMullen2331",
    "KristyJarvis78965", "AlanSims642", "XavierCowan0796", "LindaHunt54323", "AngelaRoth00",
    "JesseGraham874", "OliviaWalton2", "AartPetik98", "AllenCrane40635", "SlothWoods805",
    "DakotaDavidson6895", "ColeKey56500", "StaceyAlvarez5683", "RubenMerritt779", "JosephBriggs779",
    "JonathanPugh826", "DianeOrange9", "LukeGolden202181", "ZaydenFlickKing2024", "PamelaKnapp04476",
    "CynthiaFoster366", "JoelDonaldson71335", "RichardCollins29981", "JoannaMoody442", "MeganHall85217",
    "CliffordAshley0428", "PatrickMurillo7729", "WilliamFitzgerald217", "TerriEdwards4", "BettyAllen5506",
    "ShelbyMauve51", "FlowerJordan8503", "MooHaney00", "MothSosa3574", "AngelCarroll63316",
    "KrystalCruz71526", "FrancesCarrillo7", "Giga_Omega201771", "MauriceKnapp4502", "CarolMccoy66",
    "Giant_Bee667681", "DanielBryant04700", "AlexanderEmerald9", "DawnRoguePhoenix2015", "SeanPatterson8667",
    "JeanShepherd300", "ErnestAguilar2", "RebekahPrice12132", "BlossomAcevedo744", "DarrylBowers051",
    "MelindaVelazquez099", "KelliSuarez58", "SelenaMills954", "GarrettFoley7814", "MistyAtkinson9649",
    "AngieWeiss657", "SusanRios10", "LouisBell91221", "TracyBaker09", "TinaNoble39174",
    "DeanRoman304", "MarciaArias571", "TomRoth020", "GlennGreene3951", "SamuelGray2763",
    "TashaReilly860", "FernandoHaynes23", "NormanMason111", "JeromeLawson43", "QuintarBodil1999",
    "RonnieAndrews688", "LoganKline4724", "GeraldDominguez30551", "JoseDecker531", "RickMaldonado30531",
    "BobbyClayton9491", "WillTram2008", "CatherineBell21397", "BruceGarrett66024", "JerryHouse16005",
    "StefanieSchmitt39", "SharonGilmore327", "BelindaGreene0050", "SharonEstrada01959", "JimmyRichard37981",
    "CesarHill5196", "DarrylGaines41", "FredGillespie57895", "GlennBenjamin449", "AndreaPhillips04432",
    "JesseHansen5654", "BearBright970", "FranciscoNichols4924", "ACELIGHTSKATER_YT", "CarlosHazel601",
    "JimmyAlvarez9", "MakaylaPerez3928", "TaylorStout6", "KristinBrooks07807", "Jacks0nFr0st66",
    "JoanBranch13456", "DaffodilGarcia454", "JaniceJennings665", "HageLiesbeth2008", "BoeronEelke2007",
    "BradyCraig208", "ElijahSchwartz596", "BrendanBowen7", "LaurenBolton13", "ClaudiaCarter329",
    "EileenKelley051", "MichelleBarrett205", "WilliamNova95", "AnnaRay519", "WandaMckinney0621",
    "GraceMassey475", "AlexandriaMoyer63514", "BrianaBennett47", "JasmineHammond33", "MelindaSimmons91233",
    "AmyNicholson569", "NeilBurnett8730", "LeviMontgomery371", "LoriNguyen4119", "VioletPennington2",
    "JoannHoffman154", "FloweryBooker0", "CurtisBuck0464", "JeanetteTran4257", "AaronCraig4223",
    "KrystalGrey217", "RobertaStafford4", "AimeeFowler0994", "PattyReid6719", "TaylorStanton76725",
    "LatoyaHolloway5775", "StefanieWells071", "KellyGolden83122", "CheyenneLyons29329", "NeilNunez88490",
    "BradleyAzure6497", "LucasGilbert1060", "JudithVanilla153", "Damon_C3cilia2015", "AlexandriaHardy26657",
    "TotoroWalls7158", "LindsayHartman7", "PrestonMcbride02298", "BeastCha0s31", "LukeCampbell63991",
    "MauriceReyes43279", "RobertAvila5015", "RobinHerrera273", "CarolynSimpson7", "DonnaDyer0",
    "JeanLucas51921", "DianaOwens7896", "PaulaDavenport15935", "MeowThomas4803", "MicheleKaufman87",
    "JaclynHoffman18", "BillCuevas8", "TraciCarrillo24205", "VictoriaRandolph7", "CarlaStein9286",
    "CarolMayer8423", "ChadGraves416", "KendraSchneider45", "GloriaAdams925", "JaimeCervantes7",
    "RonaldNolan262", "AlexisBautista5", "FlashGigaFlame2020", "JonathanElliott0002", "ClaudiaLeon27494",
    "DarleneBennett0", "HarryBenson32847", "TicoClaes00", "MariaGlass42131", "JamesMaddox290",
    "AshleyRoberts7226", "XxSilverHyperxX20198", "DerrickLucas105", "PennyHendrix481", "ThomasShannon42201",
    "FernBryan1468", "CourtneyNguyen105", "GregoryLynn20954", "YeseniaDavila8628", "TriciaMadden71006",
    "L3vi_J3lly21", "FleurFlynn9", "MiffyMiller5", "AllisonBishop8026", "HazelInfern0201443",
    "CarlSharp8466", "SeanBarker12321", "FaithEaton77151", "NicoleRowland94878", "IvanBrewer574",
    "MichaelHer0Ace79", "AngieLivingston36308", "AlexanderLozano740", "LeonardAzure041", "AlejandraHansen3721",
    "XavierAguilar33245", "JohnFisher118", "ClarenceMcguire545", "CliffordBonilla85", "KristaGraham3789",
    "LavenderRose215", "HannahCampos6464", "RodneyHickman745", "TonyLove29652", "ChrisMcmahon26093",
    "DianeRush8139", "BonnieWong45649", "Jaxon_Orbit201721", "JudyNeal76", "KathleenHorn40173",
    "DwayneBlanchard15999", "TreeBlevins574", "SummerLarsen9577", "MikeDay19152", "BaileyMcdonald4530",
    "MauriceNovak2905", "DarrenKelly87158", "HeroLegendClaw2015", "JordanLavender02792", "AntonioRoberts501",
    "BradyDonovan5", "AlexandraWillis07054", "KaitlynWhitaker3", "StarryC00ki3Bac0n25", "IsaacPerry5148"
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
Status.Text = "✅ Team: " .. getgenv().Team .. " | Chờ 5s..."
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
