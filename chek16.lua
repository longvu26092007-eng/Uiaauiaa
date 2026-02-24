-- =============================================================
-- DRACO ANTI-STALKER V3 (FIXED SELF-DETECT)
-- Cơ chế: Quét 3 lần -> Bỏ qua bản thân -> Tự hủy nếu an toàn
-- =============================================================

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- 1. DANH SÁCH ĐEN CỦA VŨ
local Blacklist = {
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

-- 2. LINK SCRIPT SERVER HOP CỦA VŨ
local HopScriptURL = "https://raw.githubusercontent.com/longvu26092007-eng/Uiaauiaa/refs/heads/main/hopa8.lua"

-- 3. GIAO DIỆN THÔNG BÁO
if CoreGui:FindFirstChild("AntiStalkerUI") then CoreGui.AntiStalkerUI:Destroy() end
local ScreenGui = Instance.new("ScreenGui", CoreGui); ScreenGui.Name = "AntiStalkerUI"
local MiniFrame = Instance.new("Frame", ScreenGui)
MiniFrame.Size = UDim2.new(0, 200, 0, 40); MiniFrame.Position = UDim2.new(1, -210, 1, -50)
MiniFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UIStroke", MiniFrame).Color = Color3.fromRGB(255, 0, 0)
Instance.new("UICorner", MiniFrame)

local Status = Instance.new("TextLabel", MiniFrame)
Status.Size = UDim2.new(1, 0, 1, 0); Status.BackgroundTransparency = 1
Status.Text = "🛡️ Chờ 9s khởi động..."; Status.TextColor3 = Color3.new(1, 1, 1)
Status.Font = Enum.Font.GothamBold; Status.TextSize = 11

local PlayerAddedConnection

-- 4. HÀM THỰC THI HOP
local function DoHop(detectedName)
    Status.Text = "🚨 PHÁT HIỆN: " .. detectedName
    Status.TextColor3 = Color3.new(1, 0, 0)
    warn("🚨 BLACKLIST DETECTED: " .. detectedName .. "! Đang hop...")
    task.wait(1.5)
    pcall(function()
        loadstring(game:HttpGet(HopScriptURL))()
    end)
end

-- 5. HÀM QUÉT (Đã thêm kiểm tra tên mình)
local function CheckPlayers()
    for _, p in pairs(Players:GetPlayers()) do
        -- Kiểm tra: Nếu p không phải là mình thì mới check tiếp
        if p ~= LocalPlayer then 
            for _, name in pairs(Blacklist) do
                if p.Name == name then return p.Name end
            end
        end
    end
    return nil
end

-- 6. HÀM HỦY SCRIPT
local function DestructScript()
    Status.Text = "✅ An toàn! Tự hủy script..."
    Status.TextColor3 = Color3.new(0, 1, 0)
    if PlayerAddedConnection then PlayerAddedConnection:Disconnect() end
    task.wait(2)
    ScreenGui:Destroy()
end

-- 7. LUỒNG TỰ ĐỘNG QUÉT CHÍNH
task.spawn(function()
    task.wait(5) -- Đợi server load
    
    for i = 1, 3 do
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

-- 8. THEO DÕI PLAYER MỚI JOIN (Cũng bỏ qua mình)
PlayerAddedConnection = Players.PlayerAdded:Connect(function(p)
    if p ~= LocalPlayer then
        for _, name in pairs(Blacklist) do
            if p.Name == name then DoHop(p.Name) end
        end
    end
end)
