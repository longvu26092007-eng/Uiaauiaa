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
-- (Copy y chang từ DracoHub_v4 / autobuydraco.txt)
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
-- [ PHẦN 1 ] ANTI-STALKER LOGIC
-- ==========================================

-- 1. DANH SÁCH ĐEN CỦA VŨ (Giữ nguyên dạng mảng để dễ dán thêm)
local RawBlacklist = {
    "AshleeCrawford426", "EmilyHazel62", "JasminAyers92717", "JohnnyHuynh857",
    "SherryCarroll491", "MadelinePatton378", "AzaleaSchmidt2", "StacyMagnolia55519",
    "LatashaBarber882", "PennyWade86503", "MackenzieSchultz1", "LindseyRosales1",
    "KathrynCampos6603", "MadisonGiles6618", "AlisonMerritt2541", "RoseMcfarland5",
    "MariahBradford76", "KristinOdom58", "NatalieWalsh8016", "LarryKeller10",
    "CarlyFleming4785", "ErinConway6863", "ErnestDodson109", "CalvinZamora5428",
    "SheliaFischer9521", "KittyGriffin7", "CharleneNoble22", "DouglasDonovan91604",
    "GreggDouglas79", "RyanHood7937", "KristineSandoval2220", "VickiMccann4399",
    "ChristinaRose427", "BearBurgundy0", "JeanKennedy4884", "NormanArmstrong530",
    "BreannaHall14690", "CarlyBoyle84375", "MarissaKaufman458", "JoyceShelton894",
    "JudyBeasley33420", "TammyNorton2457", "AlexanderDavis34598", "CarlaAdams13",
    "RebekahHensley9575", "AlexaGriffin784", "TristanFerguson4782", "BrittanyEvans8272",
    "RubenPark74529", "CindyPeterson4830", "RuthCooke4072", "JessicaHenry1315",
    "JamieKline4935", "ZoeCarter3307", "DaisyPitts52703", "MackenziePalmer6",
    "JaimePastel16", "AmberMalone203"
}

-- [TỐI ƯU HÓA]: Chuyển Mảng thành Bảng Băm để tra cứu O(1)
local BlacklistMap = {}
for _, name in ipairs(RawBlacklist) do
    BlacklistMap[name] = true
end

-- 2. LINK SCRIPT SERVER HOP
local HopScriptURL = "https://raw.githubusercontent.com/longvu26092007-eng/Uiaauiaa/refs/heads/main/hopa15.lua"

-- 3. GIAO DIỆN THÔNG BÁO
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

-- 4. HÀM THỰC THI HOP
local function DoHop(detectedName)
    if isHopping then return end
    isHopping = true

    if PlayerAddedConnection then PlayerAddedConnection:Disconnect() end

    Status.Text       = "🚨 PHÁT HIỆN: " .. detectedName
    Status.TextColor3 = Color3.new(1, 0, 0)
    warn("🚨 BLACKLIST DETECTED: " .. detectedName .. "! Đang hop...")

    task.wait(0.5)
    pcall(function()
        loadstring(game:HttpGet(HopScriptURL))()
    end)
end

-- 5. HÀM QUÉT
local function CheckPlayers()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and BlacklistMap[p.Name] then
            return p.Name
        end
    end
    return nil
end

-- 6. HÀM HỦY SCRIPT
local function DestructScript()
    if isHopping then return end

    Status.Text       = "✅ An toàn! Tự hủy script..."
    Status.TextColor3 = Color3.new(0, 1, 0)
    if PlayerAddedConnection then PlayerAddedConnection:Disconnect() end

    task.wait(2)
    if ScreenGui then ScreenGui:Destroy() end
end

-- 7. THEO DÕI PLAYER MỚI JOIN
PlayerAddedConnection = Players.PlayerAdded:Connect(function(p)
    if p ~= LocalPlayer and BlacklistMap[p.Name] then
        DoHop(p.Name)
    end
end)

-- 8. LUỒNG TỰ ĐỘNG QUÉT CHÍNH
task.spawn(function()
    task.wait(5)

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
