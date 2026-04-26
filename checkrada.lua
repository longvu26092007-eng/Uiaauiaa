-- =============================================================
-- DRACO ANTI-STALKER V15.5 - UPDATED BLACKLIST (100+ NEW USERS)
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
-- [ PHẦN 1 ] BLACKLIST (CẬP NHẬT MỚI + 100)
-- ==========================================
local RawBlacklist = {
    -- DANH SÁCH CŨ
    "PrestonTucker44238", "ScottPace90795", "RonaldKennedy7483", "NicholasPalmer09144",
    "GreggColor8246", "TotoroDawson74", "KatherineBautista528", "RayGillespie5",
    "PennyBartlett67371", "AnnetteIbarra3808", "KurtReynolds791", "WandaLivingston220",
    "StacySalas33", "SherylGray547", "BillMadden2788", "KimberlyValencia932",
    "KaitlynLarsen416", "MarilynAzure9", "SamuelCooley1", "WhitneyTerracotta335",
    "CurtisPope6632", "AnnetteWoodard287", "DerekLucas846", "KelliSchmidt67257",
    "EbonyParrish357", "OscarGomez002", "DylanHobbs687", "LaurieGraves8158",
    "MelanieGarner3228", "BrandiCabrera82103", "1dignon7", "EdwinCasey0",
    "LindsayFinley46", "NoahSantiago3979", "AlishaTravis083", "CarlyRodriguez3437",
    "RyanClayton83", "DuanePhelps72371", "BakkurClarice09", "AndreWhitehead13175",
    "KathrynGarner851", "CaseyMcdonald14668", "AbigailHopkins089", "SandyYellow59132",
    "CindyBarrera86", "GlennCarlson95392", "KathyBurnett01", "KaylaFox35063",
    "KittiBray11899", "JohnnyLester5", "DerrickEaton38155", "AdrianCobb4481",
    "LouisCedar276", "PoohPollard7", "JodySchmitt76322", "SnailPalmer33930",
    "ZacharyRivers8177", "LeahKeith06", "KimberlyZhang0094", "JorgeZavala648",
    "PamDuran954", "JudySalinas1", "NormaFreeman78811", "MiaFletcher3725",
    "ErikaBradley642", "AshleeBarajas27", "GerrenBertha05", "KatelynKhan070",
    "FrogFarmer85", "JoannHester123", "DwayneJensen29451", "EdwardCampbell15188",
    "MadisonTerry73", "LavenderBradley3112", "LuisPope35798", "LaurenCastaneda5835",
    "FrogFox4870", "ChaseReyes0553", "RandyBaxter342", "BaoyuMulde00",
    "BryanCotton549", "SydneyBlair09848", "UitrelMarit07", "LauraGlover6",
    "CalvinYoder9042", "BethJennings721", "BunnFriedman41831", "PurrMcbride24",
    "WillaTroy98", "MelissaJones489", "Ow3n_Crystal200264", "KristenGolden40363",
    "KristinaFrost259", "ScottSilva470", "KiaraBoyer797", "GeorgeHendrix568",
    "AndresRyan765", "WandaRollins099", "RobertCopeland0139", "WhitneySepia18",
    "JoelStevenson511", "LeviFuentes09", "RebekahBradshaw829", "BeverlyHughes46",
    "YvetteBlanchard21", "TannerRichardson077", "FernandoHorne50864", "DinoCompton57123",
    "IvyDunn87", "CharlesBurke50197", "VeronicaDawson83491", "JackieChurch68345",
    "JudithFrederick51", "BillObrien7540", "JuliaAlvarado5534", "JimFerrell28579",
    "DarrellKaiser48145", "ChrisRuiz8675", "CharlesGraham825", "AdrianPink46",
    "CarolynDawson1796", "BiancaHarrison64", "ChloeStokes0362", "MiffyLucero73",
    "JefferyHerman26899", "OmarBurke77071", "NancyTearose19", "JeffCollins714",
    "ChristineWeeks455", "IsaacHughes80", "MadisonFrederick051", "HibiscusBeasley7",
    "OscarBrooks52708", "AustinCoffey07955", "BlakeWashington321", "MeghanSilva987",
    "AlexRollins2765", "KatrinaMay53", "LaurieMccullough5946", "ArthurDelgado62809",
    "MistyDuke3630", "MistyMckinney65919", "SummerMcguire8", "LukeChapman2",
    "SylviaMoran8236", "CaitlynGriffith4292", "VincentMurphy7821", "MarioBradford1755",
    "KendraApricot3409", "PeggyCompton1", "MalloryBolton966", "IvyHammond81955",
    "MariahSalazar02001", "AmyNguyen3597", "SophiaRivera797", "rasenny18",
    "SnoopyCross2240", "AloeMccullough716", "LilacGutierrez3263", "WalterSummers53110",
    "MarcLopez45426", "NoahMatthews5015", "CynthiaSalazar88158", "TimothyKrueger05258",
    "CherylFreeman95753", "TamiFuller63", "ClintonMorrison00", "JanetEvans612",
    "MandyParsons1", "CraigPhelps97", "RebeccaTate66229", "IvyRichardson97",
    "YolandaMason215", "JamieGibson43769", "TaraAlexander728", "BrookeNorton41",
    "ChristieKeller9", "JoanValencia548", "CarolEsparza03448", "MckenzieWu09816",
    "PennyCarroll340", "MoniqueKelley1193", "JimRoach077", "SoojinMaask99",
    "TreeHall0", "TreeHoffman7275", "ButterflyHinton123", "AloeveraDawson94",
    "BethanyHaney721", "TammieClarke2202", "ChelseySanchez29", "CoreyHarvey98",
    "ShaneVazquez041", "DonEllison13821", "AutumnDay723", "JordanBerry4846",
    "GeraldMalone4134", "CynthiaBlevins70188", "RebekahBooker2", "AmyBarajas810",

    -- 100 TÊN MỚI ĐƯỢC THÊM
    "AlphaLewisStorm812", "AustinClub39011", "Avayah9z53", "Barront613", "Baylora515",
    "CantuQueen78083", "Careyzwa45", "CarrilloLola62389", "Cerys_Playz834", "Cesar_qs45",
    "Cherry_Giles351", "ColsonHuffqo4", "Conor_Zuri517", "Cook201207", "Devon_h789",
    "EmeryBox308", "Epic_Davis992", "Gia_xklw11", "Golden_Dario270", "GoldenSanfordBox4851",
    "Heidi_Morgan9847", "HuntKing8064", "HyperAlondraFan184", "Its_Bjorn549", "ItsBrittaClub848",
    "ItsCadenYT496", "ItsChan27502", "ItsMakaiKnight82067", "ItsRamirez899", "JaelynnClub096",
    "JamirCobbg9", "JaylinClub7932", "Jimena_Kellan7096", "JohnsFire924", "JourniNyomi7096",
    "Juarezj914", "Kaileyzgim", "KamrynBrantley92102", "Karla_yha0", "LightHorton282",
    "OfficialCullenHero66", "Paxon_Knight955", "Pugh_2ktw6", "SavageLeila3907", "ShadowRoselyn86909",
    "Sheldon201262", "ShilohPlayz951", "SimonLife962", "SkylaJames0798", "Sloan_Pro747",
    "Solange_33cm756", "Solange_Wellford491", "Storm_Rochford224", "Strongehb6", "Summers_Studio4888",
    "SuperAlainaSoul4837", "SuperKassiaBox766", "SuperRhiannonGame469", "SuperSotoMaster60390", "SuperWaltersStorm840",
    "SwiftPriya641", "Tallulah_3dq940", "TessaPadillaqj56", "The_Geneva458", "TheZionQueen025",
    "Timon_97t1868", "Torben_Box480", "Toxic_Kali30819", "ToxicAngeloGame338", "ToxicHigginsClub1234",
    "ToxicKerensa148", "ToxicPaulinaPlayz542", "ToxicPhinX466", "TrevorAutumn4668", "Ultra_Warren29",
    "UltraBrynnStorm185", "UltraOrtizIce851", "UltraOrvilleQueen392", "Ulyana_Gamer300", "Uma2017229",
    "Umar_Fire717", "Umar_nqd488", "Umaryt8407", "Umber_Yountville378", "Una_Queen645",
    "Uriel_Redfield927", "Urien00627", "UzielHero864", "ValdaNorville566", "ValdezTroy802",
    "Valeria_Master4754", "Valor_Eastbourne144", "Vargas_Holt994", "Vero_Marlowe818", "Verop58665",
    "Victoria_Rivas43246", "Violette_Avi08770", "Waltersaz7", "WaltersGamer92005", "Wes0040802"
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
