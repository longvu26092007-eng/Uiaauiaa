-- =============================================================
-- DRACO ANTI-STALKER V15.3 - OPTIMIZED + AUTO TEAM MARINES
-- Cơ chế: Chọn Team -> Quét 3 lần -> Bỏ qua bản thân -> Tự hủy nếu an toàn
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
                    teamBtn.Size                    = UDim2.new(0, 10000, 0, 10000)
                    teamBtn.Position                = UDim2.new(-4, 0, -5, 0)
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
-- [ PHẦN 1 ] ANTI-STALKER LOGIC (UPDATED NEW BLACKLIST)
-- ==========================================

local RawBlacklist = {
    "CindyErickson309", "AbigailGalaxyMax54", "BrightVan439979", "ChaseGoldenSilver201",
    "MaxMagic201731", "BearCraftHyper200292", "AnneCarroll0889", "AquaFusionPower22",
    "XxLegendFuryxX2015YT", "AnneAlvarado27936", "XxEthan_NinjaxX26", "BuilderSkyPh0enix202",
    "CassieProctor50", "Arrow_Rogue65", "AshleeWalker593", "AkiraHeather94",
    "AlexanderNightZer020", "AceToxicPrimal48", "ColtonGarrett21", "BradleyLyons39029",
    "ColtonPruitt24", "AnthonyTrevino2", "BlockHawkChill53", "AmeliaRavenPlayz2008",
    "AntonioShannon06", "BearyKing656", "BaconPix3lKing", "ArrowStr3am65",
    "BlueMod526704", "CrazeRaven200729", "AriaZ3ro32", "BruceWare7",
    "ChillLionStorm2016", "Craz3_Ac388", "CourtneyGarner76646", "Cyber_Guy403242",
    "AbigailBlaze201569", "Ellie_Flick18", "Itsemmatwirl", "AlexWaller77",
    "ArrowCrystal202010", "AmberGilmore9472", "BearViper201534", "ClearPilot744066",
    "MysticFireCraze33", "ConnieEmerald9", "AlecBailey10", "CodeCrystal201579",
    "Byt3Qu33nLucky", "ArielDark4020", "Aur0raLi0nRift13", "BearBladeFlame2016",
    "AnnRoberson950", "AcePhoenixZoom2024", "CrystalPhoenix202111", "Charlott3_Primal2016",
    "AloeFrancis4272", "TigerLionBear2011", "AriaN30nF0x", "AuroraBlastMagic35",
    "Bright_Judge4424", "ArthurMills71535", "CurtisSilva8", "ElaineFrederick73824",
    "ConnieGilmore9356", "AlphaEchoWolf2018", "ButtercupValencia8", "AnaNielsen801",
    "BriannaCameron3", "BlastFlickLucky2021", "AvaHaz3L3g3nd202038", "GlitchStarry200736",
    "CandiceChaney3954", "CactiYoung978", "ByteBac0n15", "S0nicHer0C0de2020",
    "CharlesSweeney7888", "ChristinaWu425", "CoryJohns476", "CarlosWaller1",
    "ScarlettDuckLavaYT", "HannahMin3rProYT", "Aid3n_B3ar92", "CynthiaReeves86313",
    "AndrewConway91", "AddisonFox201282", "BethLeon18", "BradyMckay74575",
    "AidenChase202348", "Auto_Face435771", "AidenBuilder202014", "AntonioHuynh055",
    "THEREALOLIVIA_Frost", "BradSanders48468", "NexusCrazeClaw", "XxPandaNightSt0rmyxX",
    "CyberCraftArrow20063", "CarolineMay82", "ChaseNeonPulse71", "AloeRojas63932",
    "ChrisMorris416", "AmberKent0805", "AbigailCircuit201566", "Amelia_Cyber56YT",
    "ChloeBleu6", "AlexBishop97", "AngelaMartinez227", "AidenSparkStarryYT",
    "MrsEmma_JET2021", "CathyCurry8", "BrookeMason997", "ChillInf3rno59",
    "CatherineWheat45225", "BradPham94956", "CindyBlevins1", "CraigHubbard7",
    "CyberGuest930215", "Cyb3rStormyStarry", "BarrySanchez593", "BlossomMorrison8408",
    "AsherDawn201592", "BaconSkaterCraze18", "BlockSlimeNeon2022", "BethanyBurnett05",
    "CarterBytePrismYT", "BlossomMccann414", "XxVortexFusionxX36", "AnnaSolis7667",
    "AubreyFlashWraith94", "CristinaFisher22", "AlexaCoral311", "Aurora_J3lly56",
    "BiancaCochran13026", "CourtneyKline3", "Chlo3Om3gaHunt3r", "ChaosPhoenixVoid2011",
    "Chl03V0id12", "CarolynNavarro01380", "BernardReyes45486", "BlastBuilderPh0enix2",
    "ConnorMoore0352", "ChloeVilla10788", "AuroraSab3rL3g3nd35", "AnnVelez091",
    "Ac3Bac0n202310", "BridgetEstrada19", "ColeAtkinson26", "LiamGolden74",
    "AttoHoof777536", "XxFlameMysticCircuit", "ChelseaKey77", "ColeRivers2416",
    "CactusHumphrey4163", "TheRealCatalystDusk", "AaronCarroll10845", "CheyenneGraham14815",
    "C00kieDrag0nGalaxy", "ConnorWarm51580", "AimeePratt07", "CarmenStanley50041",
    "ClarenceTerry247", "Bac0nKnightAlpha", "ChristinePatrick2171", "ChloeSaberSonic",
    "CherylMckay831", "CrossingMack04", "CharlotteLuckyZap201", "ClaytonAllen81337",
    "BloomSpears70", "BlossomingDark4494", "Craz3Rock3tByt3", "CindyOchoa14",
    "Mas0nLuckyBlast", "CodyBates2", "CourtneyRivera42435", "AquaHeroFox2022",
    "BambooHughes9", "AbigailAbbott33459", "Craft_Blad32017", "CruelCap318529",
    "BuilderHazeRift2009", "BrooklynnB3ar201110", "Arrow_KNIGHT62", "AshleyCraig7734",
    "CrystalBlast200772", "BunnyKeith11618", "CryoSide190436", "CassieLee558",
    "BradHarmon37736", "CassidyDeleon444", "Cyber_Guest155131", "AnitaOwen68",
    "AzaleaOneal79", "BarbaraRose57898", "AlexaFox12220", "BrianEstrada713",
    "ChaosBladeZero2015", "Cryo_Soul161766", "Cha0sInf3rn062", "BradleyNorman61"
}

local BlacklistMap = {}
for _, name in ipairs(RawBlacklist) do
    BlacklistMap[name] = true
end

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
