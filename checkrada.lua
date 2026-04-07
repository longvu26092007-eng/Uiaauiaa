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
    "RaymondBest012",
    "JaclynLawson02",
    "OliviaHunter57YT",
    "JaniceHahn66",
    "MarcoVelasquez19",
    "AnnBranch545",
    "SylviaCervantes212",
    "FrankHoover2",
    "JasmineGibson98583",
    "SlothLloyd40",
    "LisaKirk05013",
    "FrancesSerrano62",
    "JasmineSilver3096",
    "BaconMast3r81",
    "DakotaHiggins53731",
    "KristinHenry5",
    "AngieCarroll725",
    "SherryKim7489",
    "ScottShields49640",
    "ColeTravis12802",
    "dung343a",
    "ElineBakke08",
    "DaisyWatts85936",
    "JohnSmall27397",
    "FernandoBray8",
    "GloriaGordon90",
    "JoyceCarr289",
    "VickieStanton1142",
    "DawnRiggs0",
    "NormaAyala461",
    "BradleyTrujillo0",
    "GlennContreras49769",
    "ToddSilver55043",
    "MatthewLeblanc278",
    "ShaunNichols9",
    "CassandraRomero6",
    "MichaelFrey0",
    "BloomHumphrey173",
    "GinaCurtis97002",
    "FlashLi0n90",
    "FlowerShaw1620",
    "BethFields15995",
    "AlisonAlmond03",
    "ToddBruce3218",
    "CarolynZavala546",
    "BrookeHunter295",
    "LeahHuff952",
    "IsaiahGriffith667",
    "IsabellaAdams94744",
    "JudithPonce4",
    "PedroVaughn7592",
    "JackieAcevedo39963",
    "AlbertOrange03",
    "CandaceCantu23495",
    "BossKoos2001",
    "ChrisGrant4281",
    "AndreaArias528",
    "KyleGuerrero8",
    "KarlGallegos369",
    "SaraCarney3581",
    "RoseCortez418",
    "DinoPratt51",
    "ChunhuaTeunon03",
    "Br00klynB3arSpark200",
    "DevonHarvey1131",
    "CarolynLivingston604",
    "JimMason634",
    "MartinRodriguez17734",
    "FaithHensley598",
    "DannyCaldwell6225",
    "CindyBruce85414",
    "AlexandriaNunez1125",
    "AngelaBlanchard37232",
    "areluspz8",
    "JimCook205",
    "BiancaVance78481",
    "DonHartman480",
    "MarcusSaffron48226",
    "JackGold3n200983",
    "ChloeHeath91",
    "JeremyDorsey62255",
    "BethMoore0",
    "YvonneMayer8",
    "xategicom9",
    "CurtisPittman8",
    "StaceyStanton45150",
    "VanessaAlvarado961",
    "StacyForbes8",
    "BobbyPotts63565",
    "SierraTorres889",
    "SylviaRobbins4440",
    "KristyLong74",
    "TanyaPowers852",
    "DeniseMclean4964",
    "CactiMorse6646",
    "XxZayd3nCha0sxX2011",
    "JoJefferson526",
    "BrycePadilla90",
    "JudyCarter6",
    "PamFrench3191",
    "DakotaAllen5724",
    "RonnieSawyer643",
    "CrystalCannon62485",
    "Fr0stC00ki3200560",
    "JacobBlevins62",
    "BaneSky201170",
    "TonyaContreras96691",
    "MoniqueClements6",
    "CaitlynWade674",
    "KoenePleun96",
    "TraciRubio221",
    "NatalieNavarro021",
    "KristyAguilar640",
    "AnnetteMosley409",
    "MeganZhang1",
    "RyanFlores2653",
    "ColleenDay9",
    "LouisKaufman621",
    "RavenGriffin8964",
    "MeghanHenry4377",
    "RandallMann2407",
    "LauraFaulkner4",
    "LeviOomik99",
    "JorgeRyan4874",
    "AlvinGilbert5427",
    "JayNavy3414",
    "S0nic_Dawn11",
    "WillowBuckley88818",
    "MadisonBennett38",
    "GregoryWeiss0484",
    "AustinOchre908",
    "ChaosMast3r201551",
    "WalterCooke83394",
    "JoanneHoover241",
    "RandallCooke61",
    "TraceyShields87",
    "ErikaTapia56",
    "KarinaWilkins93",
    "CourtneyBrass918",
    "WilliamCampbell57199",
    "LoganConway5",
    "DillonMccoy5",
    "MandyCarr6082",
    "CollinPayne3",
    "JanetMorrison4159",
    "CarolynChavez60",
    "EileenMiddleton6",
    "AngelaKnapp263",
    "KaitlynTaylor92694",
    "LoganMorrison13100",
    "thien195tt",
    "MeganWilliams47402",
    "Om3ga_R0ck3t60",
    "SethBurton95038",
    "JoyNelson666",
    "SherryColeman21048",
    "LindaFarrell88232",
    "SierraFrye37",
    "CliffordMcdaniel806",
    "RaymondMacdonald9033",
    "PaulaRay87062",
    "ArielConley490",
    "ChadSmith8309",
    "SarahRhodes71608",
    "zstatedic9",
    "CarolineFrancis90454",
    "MikaylaEstrada5351",
    "JohnHahn3769",
    "MirandaSimpson200",
    "AnnDelgado4",
    "HaileyHicks75386",
    "MiffyMoore1166",
    "SomsakGerra95",
    "dung078a",
    "JanetGibbs1369",
    "ShaneOpal18",
    "AmberPage0408",
    "KiaraBerger2330",
    "operyoner9",
    "JohnathanMadden2",
    "BAM_kioz3",
    "EmilyVasquez56840",
    "sirfewa18",
    "ideazio7",
    "pyxieldlo9",
    "RebekahBailey78408",
    "VeronicaEspinoza2",
    "ArthurMcmillan61",
    "MistyKeith5331",
    "RonniePearson38261",
    "CandiceMcguire6172",
    "HeatherGoodman57274",
    "CaseyChase4",
    "MeghanGreen45",
    "Vort3x_Duck18",
    "ZoomCookie202317",
    "KristenConrad9",
    "MerlijnLangon2001",
    "JohnnyMcmillan98",
    "PrismOrbitZap23"
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
