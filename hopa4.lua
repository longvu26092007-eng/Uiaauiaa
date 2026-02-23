-- ======================================================================
-- DRACO SNIPER HUB - UI EDITION (TEST BUTTON)
-- Quy trình: Bấm nút -> Search Singapore -> Target 2-3 người -> Auto Refresh
-- ======================================================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")

local targetCount = 2 -- Ưu tiên 2-3 người
local targetRegion = "Singapore"
local isHopping = false

-- 1. TẠO GIAO DIỆN NÚT BẤM (UI)
local ScreenGui = Instance.new("ScreenGui")
local MainButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")

ScreenGui.Name = "DracoSniperUI"
ScreenGui.Parent = game:GetService("CoreGui") -- Hiện trên cả UI game
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MainButton.Name = "MainButton"
MainButton.Parent = ScreenGui
MainButton.BackgroundColor3 = Color3.fromRGB(255, 45, 45)
MainButton.Position = UDim2.new(0.05, 0, 0.4, 0) -- Vị trí bên trái màn hình
MainButton.Size = UDim2.new(0, 60, 0, 60)
MainButton.Font = Enum.Font.FredokaOne
MainButton.Text = "HOP"
MainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MainButton.TextSize = 18
MainButton.Draggable = true -- Cậu có thể kéo nút đi chỗ khác

UICorner.CornerRadius = UDim.new(1, 0) -- Làm nút tròn
UICorner.Parent = MainButton

UIStroke.Color = Color3.fromRGB(255, 255, 255)
UIStroke.Thickness = 2
UIStroke.Parent = MainButton

-- 2. LOGIC XỬ LÝ
local function ClickRefresh()
    local frame = Players.LocalPlayer.PlayerGui.ServerBrowser.Frame
    local refreshBtn = frame:FindFirstChild("Refresh")
    if refreshBtn and refreshBtn.Visible then
        local x = refreshBtn.AbsolutePosition.X + (refreshBtn.AbsoluteSize.X / 2)
        local y = refreshBtn.AbsolutePosition.Y + (refreshBtn.AbsoluteSize.Y / 2) + 58
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 1)
        task.wait(0.05)
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 1)
        warn("🔄 [SYSTEM] Refreshing...")
    end
end

local function FilterAndJump(serverList)
    if isHopping then return end
    local found = false
    for jobId, info in pairs(serverList) do
        local pCount = (type(info) == "table" and tonumber(info.Count)) or 0
        local pRegion = (type(info) == "table" and tostring(info.Region)) or ""

        if jobId ~= game.JobId and pRegion:find(targetRegion) and (pCount == 2 or pCount == 3) then
            isHopping = true
            MainButton.Text = "JUMP!"
            MainButton.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
            pcall(function()
                TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId, Players.LocalPlayer)
            end)
            found = true; break
        end
    end
    if not found then
        task.wait(2) -- Đợi 2s để danh sách load xong
        ClickRefresh()
    end
end

-- Hook vào Remote
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local response = oldNamecall(self, ...)
    if (method == "InvokeServer" or method == "FireServer") and self.Name == "__ServerBrowser" then
        if response and type(response) == "table" then
            task.spawn(function() FilterAndJump(response) end)
        end
    end
    return response
end)
setreadonly(mt, true)

-- 3. SỰ KIỆN KHI BẤM NÚT
MainButton.MouseButton1Click:Connect(function()
    warn("🛰️ ĐANG BẮT ĐẦU QUY TRÌNH HOP TEST...")
    MainButton.Text = "WAIT"
    MainButton.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
    
    -- Mở UI game
    local ui = Players.LocalPlayer.PlayerGui:FindFirstChild("ServerBrowser")
    if ui then 
        ui.Enabled = true
        if ui:FindFirstChild("Frame") then ui.Frame.Visible = true end
    end
    
    -- Nhập Singapore và Gọi Remote
    local tb = Players.LocalPlayer.PlayerGui.ServerBrowser.Frame.Filters.SearchRegion.TextBox
    tb.Text = targetRegion
    ReplicatedStorage.__ServerBrowser:InvokeServer(1, targetRegion)
    
    task.delay(5, function() 
        if not isHopping then 
            MainButton.Text = "HOP" 
            MainButton.BackgroundColor3 = Color3.fromRGB(255, 45, 45)
        end 
    end)
end)

print("✅ Đã thêm nút HOP TEST. Hãy bấm nút đỏ trên màn hình!")
