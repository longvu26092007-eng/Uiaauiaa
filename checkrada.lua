-- =============================================================
-- DRACO ANTI-STALKER V15.5 - FULL NEW BLACKLIST UPDATED
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
-- [ PHẦN 1 ] DANH SÁCH BLACKLIST MỚI
-- ==========================================
local RawBlacklist = {
    "ReneeCortez222", "CraigBerry1", "KatelynHolmes1524", "CourtneySteele1797", "MarisaMata8243",
    "ErinWilliamson78", "NicholeDorsey52", "DarrellMorales673", "JohnStanley53611", "SheliaGreen4",
    "AustinLyons2404", "JuniperMata5", "RavenZeroGamer2006", "JessicaRose615", "KlaasrMadon2006",
    "AngelicaTrevino582", "SharonLucas982", "SherriMclean1273", "LindseyBlevins61", "MarieCurry886",
    "Noah_Ban315", "RhondaLe06", "RebekahOrtiz31", "MistyMaldonado7389", "AlecCopeland99",
    "DianeYang5753", "FloweredGold8", "CaitlynRitter0189", "Derek_Grant95", "Clear_Admin563552",
    "LoriWinters102", "RileyKeller24352", "RebeccaBarajas485", "KentGarcia7847", "DianeBronze81",
    "AntonioDay13", "CrystalOsborne00131", "OwenViperLight201783", "CherylMcconnell2", "MarvinRose45",
    "Atto_Neck376778", "CarolynMoreno274", "BillyNewton0433", "LisaBailey70525", "MeghanOrange5",
    "BonnieVincent7850", "MarilynBonilla443", "ZacharyCharles753", "ShannonDavis3909", "XavierSapphire5",
    "IanMiranda321", "MariaFerguson676", "KaylaBanana13", "AshleyBerger8650", "DorisMejia903",
    "Charl0tteStealth90", "ErnestSnow79554", "CactusSalinas58", "BrooklynnSkater20122", "ReneeDark520",
    "PigletMorton3", "LaurieCarson1537", "LindsayKramer3", "NeilKnight68292", "KariHuang74939",
    "PatrickGold0", "JamesChristian7362", "SharonDalton4891", "YvetteDonovan3713", "GaryMejia5443",
    "ReginaLucas0281", "KarenLutz96", "BunnyStafford1", "PamelaZavala41380", "JudyGuerra9",
    "JulianFrazier16", "EricaWright22967", "RileyParker146", "MackenzieHickman33", "TammyNavarro7449",
    "MathewWard86188", "GoldBaron786386", "ZacharyArroyo97984", "CharlotteCasey1", "BlossomJennings856",
    "JasminAyala5248", "GlendaGoodwin3108", "DeannaShepard62244", "LynnBranch4657", "NicolasHubbard2001",
    "GammaSamurai362792", "ColleenMcknight76468", "XxShadowMinerxX38", "HarperC00kieEch02002", "BettyJacobson19822",
    "BrandonWatkins79107", "SlothHarrington72328", "JeromePeriwinkle3643", "KatrinaMunoz3145", "DillonBuckley3627",
    "JudithHumphrey2", "NicoleGolden431", "RichardTownsend11404", "KerriCooke31", "XxEmmaS0nicxX71",
    "RogueLightStar2013", "JasminWhite13612", "MadelineCarr3", "AsherHyper35YT", "DamonRainbow7",
    "LaurieYang215", "MeredithOneal889", "CharleneRiddle498", "Z0eBladeRift2011", "GlennLogan832",
    "PlantedMckee53318", "XxJulianLuckySonicxX", "PicoRacer365921", "ArielRollins04", "ShaunHenderson46",
    "BryanWalsh9866", "Li0nRider200498", "Super_Fox86993", "LorettaFinley38", "ColtonJacobs2",
    "GabrielMcgee19", "DawnBallard44710", "WarrenOwen38571", "NormaCarey50", "RuthPeterson6624",
    "CarlaApricot37404", "WarrenRowland67796", "AngieGomez9033", "R0ng_Hug02007", "NiceEar907783",
    "PigHenry115", "VanessaJordan7166", "HaoAidenFreya", "LeeMcbride9728", "KimberlyHoover351",
    "KerryGates50540", "XxFoxPlayzBearxXYT", "JanetShields1416", "LarryWilliamson1232", "LeahVelazquez709",
    "KristenRogers042", "KatherineTerry91865", "RonnieMahoney35502", "PurrNunez853", "DeanMcbride490",
    "JorgeShannon071", "ClaireCurtis806", "SonyaGuzman24097", "BlazeGlitchDragon42", "EliteRobot620607",
    "DorothyBennett3", "ReginaPark951", "RickyPearson37552", "Turbo_Prism200351", "TamiLozano7511",
    "AimeeBartlett5073", "Skater_Circuit50", "PhillipParrish35", "CodeSparklyLucky2010", "CherylColeman00",
    "Odd_Prince323328", "JillianBarr5", "LindseyBradshaw51674", "ChloeRogers7495", "AngelicaJordan95148",
    "JoelWeiss481", "BillyMorris453", "Chrono_Sky201790", "BrentCalderon439", "FeliciaWood5174",
    "GloriaMccormick44899", "BoBrettChristopher", "WayneSnow6664", "Lucky_Fox401822", "Sab3rStarryCyb3r2010",
    "LouisMccoy8551", "BethStrawberry55578", "PhillipKeller05179", "KaitlynMacdonald1", "PrestonDunlap2597",
    "PlantedMcguire9875", "AzaleaShah7176", "NathanBarker3651", "RussellMauve5483", "KelliMoreno5",
    "BrianaCervantes74477", "NeonInfernoCraft2007", "DarleneGillespie3236", "RebekahCarlson89052", "HenryGreene4103",
    "ClaytonHenry04553", "StaceyBlackburn99", "ClarenceBuck2581", "MaryGardner0", "MyriamEvers02",
    "PamelaWeber848", "BarryLe24", "GloriaBerger6524", "VissStefanie2002", "DaltonMullen7562",
    "KatrinaMcmahon58", "CathyGallegos191", "SamuelOsborn5", "LaceyLopez12944", "ColleenCrane87117",
    "BradleyKeith1", "DouglasPantone00", "CesarCruz598", "Orbit_Lucky28", "KarenWhite74555",
    "HaileyRoberson52571", "BrookeFoley133", "LeeAndersen32401", "JackMcbride56", "CherylVazquez401",
    "PrimalRiftHaze200780", "S0phiaLuckyHyper2013", "ErinLyons25235", "DuaneMatthews4238", "DylanMccarty7951",
    "XxElla_StarryxX20078", "JacobLewis2627", "BernardOlive39", "BrittneyDudley66327", "CarlaWoodward984",
    "SquirrelGraham592", "AshleeCalhoun1", "HunterLavender86", "KurtWalton9802", "StaceyPaul85374",
    "AntonioOwens392", "Haz3Cyb3r201280", "SamuelZeroDuck51", "MarioDiaz89000", "RobertoShaffer268",
    "ShelbyOdom7222", "StanleyHanson33", "SlothCarlson7396", "GardenEsparza2031", "RobertCallahan4771",
    "LouisEcru25563", "JudyReed22148", "ZeroPulse201789", "MeghanMcpherson67", "Gabri3l_Dark10",
    "Loud_Dew349264", "SpencerAlvarado00", "EthanSharp360", "TroyMora19", "WillieHuynh476",
    "MauriceDodson78363", "HeatherCotton1086", "SherryRay00", "BaileyTeagreen20607", "ErnestYang7423",
    "GloriaCarlson3436", "KathleenPetersen332", "CoryGutierrez3", "GlendaOlson9", "LarryCoffey9436",
    "AnneHurst3", "FrogHebert743", "JaniceReid8159", "HunterStarrySparkly7", "ArthurAtkins332",
    "RonnieHays83728", "XavierCmyk3", "ReneeWright9342", "JaniceRitter3367", "GiantToe178650",
    "ScottFerrell811", "XxAur0raClawxX2015", "VictorCrosby26774", "XxLiamGamerxX62", "AttoMane536672",
    "ArianaHammond363", "NormanKing41342", "RuthRyan53402", "CameronPadilla9153", "JasmineFaulkner66",
    "DannyDorothy2018", "BruceAlmond1", "JoannWebb17", "AndrewVargas1922", "Azure_Gem274098",
    "Ev3lynByt3Drag0n2017", "KristinaFrazier667", "SusanWalton7091", "KathrynAustin4361", "BenjaminBurton2257",
    "MaureenCarr784", "GaryYork15", "GeorgeNorton64", "WalterMathis09", "SylviaBurnett72447"
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
Status.Text = "✅ Team: " .. getgenv().Team .. " | Đang quét..."
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
