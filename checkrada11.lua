-- =============================================================
-- DRACO ANTI-STALKER V15.5 - UPDATED BLACKLIST
-- =============================================================

repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.Players and game.Players.LocalPlayer
repeat task.wait() until game.Players.LocalPlayer:FindFirstChild("PlayerGui")

local Players             = game:GetService("Players")
local CoreGui             = game:GetService("CoreGui")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer         = Players.LocalPlayer

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
                    teamBtn.Size                   = UDim2.new(0, 10000, 0, 10000)
                    teamBtn.Position               = UDim2.new(-4, 0, -5, 0)
                    teamBtn.BackgroundTransparency = 1
                    task.wait(0.5)
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true,  game, 1)
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
    "KentHernandez327",
    "EdwardNeon12658",
    "MathewNickel1",
    "HollyMosley02",
    "XxAm3liaNinjaxX22",
    "RyanPennington1183",
    "XxF0x_DARKXX2009",
    "JuliaStokes6",
    "ChaseHammond64",
    "ZaydenDawnViper14",
    "EvanHiggins446",
    "DanielGamerTurbo2003",
    "BusyClaw903327",
    "FumiyaDeanna2002",
    "MarissaMcdaniel665",
    "Tart_God728166",
    "R3nEastonElisa95",
    "St0rmyChase52",
    "AlishaSantana6",
    "WillowPittman714",
    "JellyOrbitBlade25",
    "WarrenNewman68489",
    "Calvin_Cody2004",
    "CaseyHarris3061",
    "XXQUEEN_CodexX2008",
    "TerukoTeunon07",
    "AnnStewart77547",
    "DexDejons03",
    "RileyWraithP0wer",
    "ChelseaArcher19352",
    "SmitSawyer2008",
    "MartarDaaniel95",
    "MelindaHaynes6465",
    "BiancaTownsend20",
    "DianaCal3bClara",
    "DarkWizard265278",
    "ColtonSantiago56973",
    "XxSkat3r_FlickxX97",
    "MelvinMurillo3319",
    "XxWillowVortexxX2013",
    "Dancer_St0rm24",
    "TabithaRose276",
    "WolfSlimeDark",
    "MariaIndigo966",
    "JillFrederick500",
    "Wise_Car111960",
    "Grays0nLightJelly",
    "L3g3ndPh03nixFr0st50",
    "StreamDrag0n202442",
    "FroggyWright7858",
    "GiskeNoord96",
    "Slow_Troll890171",
    "NatalieHorton98520",
    "ChrisAllison1",
    "Fake_Jet471148",
    "EndoDragon367888",
    "LIGHT_Pixel200633",
    "KristenBradley14",
    "JasonSpencer2097",
    "Grac3Rid3rBlizzard23",
    "JustGem960455",
    "Fury_Echo200386YT",
    "MarieRiggs73",
    "SiebeGeert10",
    "HaicoGerri96",
    "Mas0nQu33nSilv3r",
    "VissorFlorence09",
    "TracyBranch32",
    "Flam3DawnLion",
    "NoortjePostur07",
    "AutumnMullins193",
    "DarinBates8664",
    "LydiaMorales7",
    "XxNovaTurboxX2015",
    "UitronRik96",
    "BryanKnight7676",
    "XxDrift_StreamxX59",
    "AlejandraPham112",
    "HannahLopez063",
    "LorettaMartin1",
    "VickiKidd198",
    "XxAlphaDawnChaosxX",
    "XxLunaUltraRock3txX",
    "RobertOrr82765",
    "JerryHensley562",
    "RainforestHester672",
    "ErikaVelasquez4",
    "XxFire_ZoomxX2011",
    "AlanFrost745",
    "VictoriaStarryDrift",
    "Star_Chase2016YT",
    "CristinaPaul38",
    "SandraBray55",
    "AnnStokes43440",
    "FlowersRios201",
    "LindsayMeyers2279",
    "BrettMueller1133",
    "PatrickRomero58040",
    "MichelleHammond04769",
    "KoenarDion04",
    "RavenFranco2",
    "AuroraHyperMax82",
    "DanielToxic200890",
    "OscarPope70391",
    "RileyBlockCookie97",
    "Aria_Galaxy201013",
    "BonnieMccullough5478",
    "TrevorLee6474",
    "CeciliaHeatherElena",
    "KarinaPayne4",
    "LenTeunor06",
    "IsabellaSavage9",
    "XxPanda_VOIDXX2005",
    "TOXIC_Chase2002",
    "ValerieGreen067",
    "KelseyBrennan620",
    "1netvic7",
    "BradHolland13166",
    "LouisPace28",
    "NoordorFlo05",
    "ForestChase421",
    "KristiNixon18",
    "ChloePowerBacon2020",
    "MerelClaes97",
    "SeanCampos816",
    "PatrickHood8457",
    "MelanieOneal031",
    "CurtisLozano0457",
    "Ic3SkyFir32020",
    "200hotmail",
    "Jax0nGigaHaz3200374",
    "LauraHuffman14863",
    "DerrickPace3431",
    "ShawnSimpson480",
    "Alpha_Wraith201485",
    "BethAyers85704",
    "XxJayden_HeroxX2015",
    "AlejandraChang4598",
    "milkyme830",
    "ViperDriftKnight",
    "Wide_Cyborg507304",
    "EdgarGross4588",
    "KerryWall45067",
    "WolfB3ast200426",
    "W0lf_Ven0m2009",
    "BrandonFrazier90141",
    "Tiny_God807682",
    "IanBullock0101",
    "Zero_Pixel15",
    "BradyStanley97732",
    "NicholeHenry7359",
    "JessicaAdams129",
    "JackWelch0010",
    "PandaBladeDark2009",
    "TylerUnderwood4",
    "JacksonMinerQueen65",
    "DinosaurChapman6",
    "FroggieBradley05303",
    "Charlott3_Circuit15",
    "AmyMcneil89198",
    "WanderPetor03",
    "CircuitChaosFlash202",
    "AlexandriaPeach63382",
    "JulianFisher47",
    "GigaEpic202266",
    "SlimeGalaxyFr0st2017",
    "TheresaWest54394",
    "HibiscusLozano7",
    "AustinMcguire8200",
    "PastMind344810",
    "DriftR0cketAqua",
    "CarrieArias4285",
    "JamesPrimalChill2003",
    "MackenzieEvans157",
    "DustinNicholson710",
    "XxVictoriaInf3rnoxX6",
    "DaleGibson2",
    "EricEdwards86763",
    "PostKhang2001",
    "RebekahBerger03",
    "KaitlynSnow8230",
    "L3viH3roStorm2018",
    "JoseHensley8645",
    "TammieKemp8",
    "AndreaPotts387",
    "JoanneWatts9407",
    "XxSamu3lNovaxX2018",
    "NoordonTiny05",
    "ErikPark62833",
    "STEALTH_Drift200591",
    "LydiaCardenas8470",
    "TonyWheat183",
    "XxVoidSonicCodexX",
    "WideRat274266",
    "BaconEagl368",
    "MichealHogan630",
    "LanceCarson33038",
    "Willow_Mystic201071",
    "espioki214",
    "XxSilverEpicxX12_YT",
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
ScreenGui.Name   = "AntiStalkerUI"
ScreenGui.Parent = SafeGuiParent

local MiniFrame = Instance.new("Frame", ScreenGui)
MiniFrame.Size             = UDim2.new(0, 220, 0, 40)
MiniFrame.Position         = UDim2.new(1, -230, 1, -50)
MiniFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UIStroke", MiniFrame).Color = Color3.fromRGB(255, 0, 0)
Instance.new("UICorner", MiniFrame)

local Status = Instance.new("TextLabel", MiniFrame)
Status.Size                   = UDim2.new(1, 0, 1, 0)
Status.BackgroundTransparency = 1
Status.Text                   = "✅ Team: " .. getgenv().Team .. " | Chờ 5s..."
Status.TextColor3             = Color3.new(1, 1, 1)
Status.Font                   = Enum.Font.GothamBold
Status.TextSize               = 11

local PlayerAddedConnection
local isHopping = false

local function DoHop(detectedName)
    if isHopping then return end
    isHopping = true
    if PlayerAddedConnection then PlayerAddedConnection:Disconnect() end
    Status.Text       = "🚨 PHÁT HIỆN: " .. detectedName
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
    Status.Text       = "✅ An toàn! Tự hủy script..."
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
