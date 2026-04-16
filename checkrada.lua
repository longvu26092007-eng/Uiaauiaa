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
    "XavierSapphire5",
"KaitlynMacdonald1",
"Turbo_Prism200351",
"R0ng_Hug02007",
"MeredithOneal889",
"ErinWilliamson78",
"NormaCarey50",
"SharonLucas982",
"SheliaGreen4",
"Skater_Circuit50",
"StaceyBlackburn99",
"HaileyRoberson52571",
"CactusSalinas58",
"AustinLyons2404",
"AntonioDay13",
"KlaasrMadon2006",
"GlendaOlson9",
"GaryYork15",
"VanessaJordan7166",
"SamuelZeroDuck51",
"Sab3rStarryCyb3r2010",
"BrittneyDudley66327",
"Odd_Prince323328",
"MarieCurry886",
"MadelineCarr3",
"GoldBaron786386",
"Loud_Dew349264",
"RogueLightStar2013",
"PhillipKeller05179",
"Chrono_Sky201790",
"PlantedMckee53318",
"NicholeDorsey52",
"XavierCmyk3",
"DorothyBennett3",
"FloweredGold8",
"GloriaCarlson3436",
"NormanKing41342",
"AzaleaShah7176",
"ShelbyOdom7222",
"LisaBailey70525",
"NeonInfernoCraft2007",
"Haz3Cyb3r201280",
"GloriaMccormick44899",
"Lucky_Fox401822",
"JacobLewis2627",
"BrianaCervantes74477",
"ArianaHammond363",
"KariHuang74939",
"ColleenMcknight76468",
"TammyNavarro7449",
"MarvinRose45",
"ClaireCurtis806",
"KatrinaMunoz3145",
"CoryGutierrez3",
"CameronPadilla9153",
"Derek_Grant95",
"MistyMaldonado7389",
"NicoleGolden431",
"CaitlynRitter0189",
"PamelaZavala41380",
"NiceEar907783",
"ClaytonHenry04553",
"Azure_Gem274098",
"MauriceDodson78363",
"HeatherCotton1086",
"JohnStanley53611",
"KarenWhite74555",
"RobertoShaffer268",
"WalterMathis09",
"LindseyBlevins61",
"CherylMcconnell2",
"RichardTownsend11404",
"NicolasHubbard2001",
"BrentCalderon439",
"BunnyStafford1",
"GabrielMcgee19",
"LaurieCarson1537",
"ShaunHenderson46",
"BrandonWatkins79107",
"HarperC00kieEch02002",
"HenryGreene4103",
"PigletMorton3",
"BoBrettChristopher",
"CarlaWoodward984",
"Z0eBladeRift2011",
"JaniceRitter3367",
"YvetteDonovan3713",
"DeanMcbride490",
"JoelWeiss481",
"GlennLogan832",
"DianeBronze81",
"RonnieMahoney35502",
"MarioDiaz89000",
"LindseyBradshaw51674",
"BonnieVincent7850",
"PamelaWeber848",
"KarenLutz96",
"DarleneGillespie3236",
"XxFoxPlayzBearxXYT",
"LeeAndersen32401",
"RuthRyan53402",
"JeromePeriwinkle3643",
"BillyNewton0433",
"SquirrelGraham592",
"HaoAidenFreya",
"BenjaminBurton2257",
"KaylaBanana13",
"RebekahOrtiz31",
"LeahVelazquez709",
"FrogHebert743",
"CarlaApricot37404",
"EliteRobot620607",
"LynnBranch4657",
"BaileyTeagreen20607",
"GeorgeNorton64",
"XxLiamGamerxX62",
"VissStefanie2002",
"JasmineFaulkner66",
"XxEmmaS0nicxX71",
"CesarCruz598",
"PrestonDunlap2597",
"DuaneMatthews4238",
"FeliciaWood5174",
"DillonBuckley3627",
"IanMiranda321",
"CharleneRiddle498",
"Clear_Admin563552",
"HunterLavender86",
"GiantToe178650",
"JaniceReid8159",
"JasminWhite13612",
"BryanWalsh9866",
"LindsayKramer3",
"KatherineTerry91865",
"JulianFrazier16",
"BethStrawberry55578",
"BrookeFoley133",
"ErnestYang7423",
"AndrewVargas1922",
"KelliMoreno5",
"BlossomJennings856",
"Orbit_Lucky28",
"BlazeGlitchDragon42",
"AntonioOwens392",
"Noah_Ban315",
"SharonDalton4891",
"JackMcbride56",
"ReneeWright9342",
"SherryRay00",
"PatrickGold0",
"XxJulianLuckySonicxX",
"PhillipParrish35",
"OwenViperLight201783",
"Super_Fox86993",
"S0phiaLuckyHyper2013",
"GloriaBerger6524",
"BruceAlmond1",
"BrooklynnSkater20122",
"CarolynMoreno274",
"EricaWright22967",
"KerriCooke31",
"BradleyKeith1",
"GaryMejia5443",
"JanetShields1416",
"XxElla_StarryxX20078",
"LeeMcbride9728",
"CherylVazquez401",
"Gabri3l_Dark10",
"SherriMclean1273",
"BrandonThomas476",
"Charl0tteStealth90",
"StaceyPaul85374",
"HunterStarrySparkly7",
"SamuelOsborn5",
"JudyGuerra9",
"MeghanOrange5",
"KurtWalton9802",
"KristinaFrazier667",
"StanleyHanson33",
"SusanWalton7091",
"JessicaRose615",
"RobertCallahan4771",
"ErnestSnow79554",
"MariaFerguson676",
"RuthPeterson6624",
"KatrinaMcmahon58",
"BarryLe24",
"SlothCarlson7396",
"DouglasPantone00",
"MarisaMata8243",
"RebeccaBarajas485",
"ReneeDark520",
"PlantedMcguire9875",
"ReginaPark951",
"ZeroPulse201789",
"RhondaLe06",
"PurrNunez853",
"CathyGallegos191",
"WayneSnow6664",
"AngieGomez9033",
"Gia_xklw11",
"Valeria_Master4754",
"HyperAlondraFan184",
"Avayah9z53",
"JohnsFire924",
"Devon_h789",
"ValdaNorville566",
"SavageLeila3907",
"GoldenSanfordBox4851",
"AustinClub39011",
"Umber_Yountville378",
"ShadowRoselyn86909",
"Waltersaz7",
"Barront613",
"SuperAlainaSoul4837",
"Baylora515",
"TheZionQueen025",
"AlphaLewisStorm812",
"ShilohPlayz951",
"Solange_Wellford491",
"Summers_Studio4888",
"ItsMakaiKnight82067",
"JaylinClub7932",
"UltraOrvilleQueen392",
"Ulyana_Gamer300",
"Verop58665",
"Sloan_Pro747",
"Valor_Eastbourne144",
"Vargas_Holt994",
"WaltersGamer92005",
"KamrynBrantley92102",
"Cerys_Playz834",
"SwiftPriya641",
"UltraOrtizIce851",
"Golden_Dario270",
"Urien00627",
"SimonLife962",
"ItsBrittaClub848",
"Cook201207",
"ToxicPaulinaPlayz542",
"Storm_Rochford224",
"Ultra_Warren29",
"SuperRhiannonGame469",
"LightHorton282",
"SuperSotoMaster60390",
"Kaileyzgim",
"Wes0040802",
"Strongehb6",
"ValdezTroy802",
"SuperKassiaBox766",
"EmeryBox308",
"Careyzwa45",
"ToxicHigginsClub1234",
"Uma2017229",
"Karla_yha0",
"ToxicKerensa148",
"Vero_Marlowe818",
"Umaryt8407",
"JourniNyomi7096",
"SkylaJames0798",
"ItsChan27502",
"CantuQueen78083",
"Its_Bjorn549",
"ToxicPhinX466",
"Jimena_Kellan7096",
"Sheldon201262",
"Tallulah_3dq940",
"Torben_Box480",
"TessaPadillaqj56",
"Umar_Fire717",
"SuperWaltersStorm840",
"Cesar_qs45",
"TrevorAutumn4668",
"Victoria_Rivas43246",
"Toxic_Kali30819",
"Uriel_Redfield927",
"Pugh_2ktw6",
"The_Geneva458",
"HuntKing8064",
"Una_Queen645",
"Epic_Davis992",
"Umar_nqd488",
"ColsonHuffqo4",
"OfficialCullenHero66",
"Violette_Avi08770",
"Paxon_Knight955",
"ItsCadenYT496",
"Timon_97t1868",
"Conor_Zuri517",
"ToxicAngeloGame338",
"JaelynnClub096",
"Juarezj914",
"UltraBrynnStorm185",
"Cherry_Giles351",
"Heidi_Morgan9847",
"ItsRamirez899",
"JamirCobbg9",
"UzielHero864",
"CarrilloLola62389",
"Solange_33cm756"
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
