-- =============================================================
-- DRACO ANTI-STALKER V15.4 - UPDATED BLACKLIST
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
    -- ── Danh sách mới ──
    "LiamDancerG0lden64",
    "GVU_RdmI1",
    "FGR_rfM42",
    "GlitchBearGamer2016",
    "RogueThunder202443",
    "KJJ_svE95",
    "FNA_q7LM2",
    "FirePixelCircuit2005",
    "HRD_Iw8v0",
    "SophiaPlayzPulse2005",
    "XxLiamFr0stC0dexX",
    "XXAQUA_CodexX2024",
    "GraceIceRift2002",
    "Danc3rW0lfGh0st2017",
    "ToxicBeastEcho2012",
    "JWH_0VHv2",
    "XxChas3WraithxX42",
    "Sab3rIc3Ac3",
    "YZE_XN7T2",
    "CircuitPulsePhoenix2",
    "JacksonWraith200976",
    "truong264tt",
    "DVW_jTgK5",
    "NoahFlameAqua2013",
    "MinerMysticCraze14",
    "truong272t",
    "Cooki3_BUILD3R75",
    "DXC_A0IZ5",
    "UYU_oTAH1",
    "Hunt3rFrostZ3ro2009",
    "MasterCha0sChase2021",
    "MaxSkyChase2019",
    "XxWyattLegendNovaxX2",
    "XxToxicCodexX202179",
    "EHM_yhUx1",
    "Chl0e_Miner35",
    "VictoriaRogu3202148",
    "ZapTurbo202130",
    "XxNovaLionxX37",
    "MoonMaxMagic99",
    "VPP_avyk4",
    "UCS_LssU3",
    "XxWilliamFusi0nxX21",
    "UTM_y5Oh2",
    "ChaosStarMagic2013",
    "XxEzraTurboBaconxX79",
    "KXY_XRRX0",
    "XxBearWraithSkyxX",
    "MAP_Jb892",
    "StealthLegendF0x2021",
    "OliviaFlam3Blast2006",
    "LucasEchoPrimal18",
    "OLIVIA_C00kie41",
    "CookieStarryDark2020",
    "truong249t",
    "SilverM00n201038",
    "WOA_VM8f0",
    "HAZE_Hero50",
    "truong294t",
    "WVJ_L70h2",
    "PixelAceChase52",
    "CodeBuilderCraze2017",
    "KEK_xkzz3",
    "XxAbigailGh0stSkyxX",
    "XKG_Gfr84",
    "Build3rWolfClaw2024",
    "XxAmeliaBeastSkyxX20",
    "NOT_Hs6P3",
    "HAI_iIjM2",
    "N0VA_C00kie67",
    "LavaPowerTurbo2019",
    "RBV_gI7S4",
    "DXD_Aurb1",
    "YIW_imUG1",
    "ChillZ3r0Blaz3",
    "XxPanda_CraftxX20129",
    "PBS_3WmM1",
    "JHT_H6EK3",
    "CKE_uo6x1",
    "FlameNovaCookie2005",
    "XxW0lfFlashxX30",
    "NZE_7l921",
    "ChillCooki3Gam3r",
    "MAST3R_V3nom39YT",
    "OJF_0THM1",
    "XxTurb0Build3rxX2021",
    "RXY_AcrV2",
    "AubreyRiftAlpha86",
    "Brooklynn_Hawk92",
    "Paisley_Hyper201741",
    "AOT_ELhl4",
    "AriaCookieGhost2002",
    "FusionBuild3rEpic201",
    "Elli3LuckyN30n",
    "IVU_ebh45",
    "Arrow_Legend40",
    "Br00klyn_P0wer201562",
    "Xx_AddisonGlitchBaco",
    "Ph03nixFlam3202086",
    "XxNoraBytexX80",
    "PLA_2iDt0",
    "NOVA_Zoom201510",
    "ThunderBladeM00n",
    "FDQ_9P1h4",
    "Ow3n_Prism202464",
    "Paisl3yAquaRogu3",
    "XxOmegaPh0enixMinerx",
    "XxSamu3lSlim3StarxX",
    "SparklyPix3lVoid2018",
    "XxGh0stFlam3xX2017",
    "BaconNightSpark2002",
    "AmeliaSky202247",
    "BMN_vd310",
    "PlayzPuls361",
    "Samu3lDanc3rStar2022",
    "Golden_Power32",
    "LiamFireMiner202076",
    "XxVictoriaArrowBearx",
    "Elli3Pho3nix201752",
    "PixelVoidStormy2018",
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
