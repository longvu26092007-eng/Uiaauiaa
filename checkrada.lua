-- =============================================================
-- DRACO ANTI-STALKER V15.5 - UPDATED BLACKLIST
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
-- [ PHẦN 1 ] BLACKLIST (CẬP NHẬT MỚI)
-- ==========================================
local RawBlacklist = {
    "zinstant8",
    "OscarDekkik2008",
    "PrismCooki3Thund3r",
    "SheliaDavidson411",
    "MoniqueMonroe883",
    "Ech0PandaW0lf",
    "AlexisWisteria525",
    "FrancesBarry4786",
    "EthanMcmillan73",
    "WarrenGordon2",
    "WilliamNorman152",
    "PamKemp04",
    "JacobWheeler0494",
    "JuanVaughn6",
    "GabriellaAlvarez3",
    "RubenWeiss9727",
    "dung013d",
    "HibiscusPowell293",
    "AllisonLambert5054",
    "HaydenGuerrero44283",
    "CesarSalinas887",
    "PlantedSalinas20",
    "JoanHays888",
    "ShuxianMeiju01",
    "FloralKeith4837",
    "DragonBan3202469",
    "dung342d",
    "LatoyaJennings28422",
    "JoseBender66",
    "AllisonSpencer3427",
    "FemkeBakke09",
    "HollyStokes5176",
    "CaseyKramer02",
    "KatherineMorrison4",
    "thien321ttt",
    "JensBeens02",
    "OscarMatthews870",
    "RubenMontgomery244",
    "LynnNorman6385",
    "MorganMiddleton05",
    "atictroz8",
    "IanRollins9358",
    "AlexisAlvarado0",
    "RoseAustin04",
    "GrantChaney40017",
    "JimBond2341",
    "MichaelaClayton24",
    "WarrenBenton16563",
    "PamNunez29005",
    "DorothyMason73961",
    "RoseRoss305",
    "KittiEdwards9",
    "JorgeRaymond5",
    "dungk249t",
    "TheresaPetersen4287",
    "ColtonBowen00",
    "PattyJensen207",
    "CindyNewton12",
    "SheriDavies7",
    "StanleyPatterson2267",
    "TheresaMcmahon2",
    "ReneePayne919",
    "DorisJarvis425",
    "LeonardKramer98",
    "RachaelOlive9285",
    "ElaineScott53",
    "MarisaBowen7628",
    "TreeThornton7621",
    "MonicaGonzales6563",
    "CassandraCurtis2",
    "LangunSunwoo99",
    "thien42ttt",
    "AnaStrickland0556",
    "SoniaSims5",
    "PhilipFlynn02939",
    "JanetLittle6574",
    "MonicaBenjamin711",
    "ColleenRandolph682",
    "GlenPorter92728",
    "truong318t",
    "AdrianaCline96052",
    "DominiqueFarrell813",
    "KayleeJensen04963",
    "EarlAvila188",
    "SabrinaMaxwell22040",
    "JoelFerrell38727",
    "ConnorChurch2",
    "FrederickAdkins0169",
    "JoanneGardner3101",
    "JulieCampos284",
    "dung077a",
    "MandyFitzgerald28",
    "mountain1o10",
    "CharlottePadilla01",
    "AnnetteBlackburn65",
    "CrystalBerry42249",
    "Isaac_BLIZZARD94",
    "RobinHerrera3263",
    "HollyStanley8901",
    "MauriceTearose17",
    "RonnieHarrell160",
    "CassidyMartinez3373",
    "KristyMendoza495",
    "dungk444h",
    "ShirleyStewart0",
    "JudyShepherd42",
    "1skunky7",
    "StacyAvila61",
    "KathrynNixon187",
    "NicholasHernandez559",
    "CynthiaMurphy3812",
    "HibiscusHoffman646",
    "RichardHunt56599",
    "HaileyCarson84",
    "thien209tt",
    "LoriLivingston12",
    "BethanyRussell3687",
    "ShawnFitzgerald554",
    "VictoriaMarks8491",
    "VeronicaOwen95513",
    "HollyLight151",
    "AlexisAlmond675",
    "BrendaStrawberry324",
    "LaurieColeman8",
    "SarahWillis70970",
    "VickiBrennan6197",
    "AlexisHendricks6148",
    "EduardoRust8",
    "EarlJennings6",
    "JohnnyGray826",
    "RickyGonzales943",
    "AbigailVenom200761",
    "KatrinaPittman5621",
    "DeanBarker414",
    "JamieNickel3570",
    "AndreMurray38316",
    "KarlEcru241",
    "RichardPurple4564",
    "dung063d",
    "JoanBraun49",
    "dung439a",
    "VictorDavidson157",
    "MargaretJarvis73",
    "LeafLong3",
    "ViperM00nG0lden",
    "VioletGeorge0083",
    "KathrynWright7788",
    "PhoenixEpicBane68",
    "KristinaPeterson952",
    "StuartKlein37159",
    "ShawnMeyers99882",
    "XxEmmaClawLionxX",
    "dung219d",
    "JuliaVaughan853",
    "DouglasSage78515",
    "DebraBlue10224",
    "GeraldMaxwell861",
    "RicardoDaugherty95",
    "MeijerJinling1995",
    "ClintonSimmons40833",
    "LauraStrawberry39037",
    "AngelHatfield4",
    "dung368d",
    "AnthonyPace0435",
    "KrystalJimenez95278",
    "BrendanFrank54",
    "BrentHolland215",
    "RandallButler54587",
    "CharleneShepard28",
    "AllisonReese66503",
    "StephenLarsen15",
    "LeeWilliams09691",
    "EarlJohnson173",
    "DerrickJacobs275",
    "TiffanyGarrison5314",
    "AndreBridges747",
    "JillianFischer93000",
    "DustinSalas8860",
    "KelliFarmer28676",
    "PedroFoley4385",
    "IsaacTate970",
    "BelindaWeiss0217",
    "ToddBarr396",
    "GregoryBurke23580",
    "SusanMyers060",
    "JasmineCraig95079",
    "KristiShort2881",
    "DesireeShah7301",
    "MikeBeasley6",
    "XxByte_N0vaxX2009",
    "AlexDiaz36199",
    "TinaMcconnell16",
    "MarkCannon52786",
    "JeanneMcbride182",
    "EbonyWinters604",
    "ChadRamsey805",
    "WesleyDuran51205",
    "LisaWoods288",
    "BlossomAllison7",
    "JamieWaller8988",
    "dung090d",
    "AnnetteMccarty17271",
    "KerryDoyle1202",
    "SkyProKnight2005",
    "LindaRobles45954",
    "SarahRowland5460",
    "JoelBray27456",
    "RachelVaughn750",
    "AndresRosy01852",
    "CliffordWard95",
    "MarcGuerrero38",
    "AngelObrien34540",
    "1withaball10",
    "HeidiDiaz33817",
    "MercedesHoover007",
    "xrazuz6",
    "MistyMonroe68255",
    "xndergy7",
    "ColinAqua72342",
    "CherylFrench63365",
    "onsmile7",
    "MelissaMcintosh32538",
    "ShirleyMerritt60674",
    "PlantHarvey0",
    "KevinGrimes825",
    "JuanMurray06",
    "MasahiroHeidiElizabe",
    "VickiSantos8",
    "JanetIbarra0",
    "truong132t",
    "JuliePerry88417",
    "HeatherJenkins03458",
    "LaurenAllison10101",
    "TimothyClark610",
    "KayleeJennings4362",
    "LauraFinley43594",
    "FoxHarvey724",
    "fleaz5",
    "RoyLawson77138",
    "zakadri7",
    "RickyPierce6",
    "JoanneLeblanc272",
    "dung398d",
    "ChillStreamWraith29",
    "JulianHammond45",
    "JoelFernandez74274",
    "RonnieConley1",
    "BettyHammond280",
    "PhillipAlvarado98",
    "OmarReed76088",
    "MuldonNiels03",
    "XxSkater_W0lfxX24",
    "BambooPark2",
    "FrogPearly3627",
    "MooReid04",
    "JeffViolet1685",
    "SharonAbbott731",
    "VCR_VFtO1",
    "AllisonPetik04",
    "DaltonSchwartz4",
    "DanielleHays4",
    "CrystalCrawford672",
    "TylerPatton7549",
    "XxElijahLightEchoxX2",
    "MariaGilmore51",
    "dung393d",
    "RussellChoi4",
    "KrystalDillon4766",
    "VossorSabine06",
    "dung107dd",
    "AngelaGrimes42",
    "LatashaFox6",
    "GeraldPadilla13",
    "JonLane22",
    "TeresaBerg2687",
    "JonathonMoss253",
    "JasmineCruz3021",
    "TracieDecker6",
    "FrancesHogan9",
    "thien169tt",
    "TerriHinton5575",
    "CalvinVelez14865",
    "PamValentine3404",
    "BunniAcevedo03",
    "dung291d",
    "bhakadez8",
    "CarolynRay63862",
    "BrandiLavender172",
    "SteveMeyers0909",
    "ToddWarm2",
    "KaitlynTurquoise1",
    "ArianaVanilla348",
    "PedroWebster804",
    "HollyHorton91697",
    "AdamEmerald8",
    "xershca7",
    "GlennFoster78",
    "SherriGlass7",
    "KarinaEverett4957",
    "CrabWeeks842"
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
