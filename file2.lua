-- [[ HYDRA CHECK - VU NGUYEN ]]
-- Chức năng: Check Hydra Status -> Hiển thị UI -> Ghi file khi hoàn thành

-- ==========================================
-- [ PHẦN 0 : ĐỢI GAME LOAD ]
-- ==========================================
if not game:IsLoaded() then
    game.Loaded:Wait()
end
repeat task.wait() until game.Players.LocalPlayer
repeat task.wait() until game.Players.LocalPlayer.Character
    and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

local Player = game.Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- ==========================================
-- [ HYDRA REMOTE ]
-- ==========================================
local HydraRemote = workspace:WaitForChild("HydraIslandClient"):WaitForChild("RemoteFunction")

-- ==========================================
-- [ UI - GOLD/BLACK STYLE ]
-- ==========================================
if CoreGui:FindFirstChild("HydraCheckUI") then
    CoreGui.HydraCheckUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "HydraCheckUI"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 280, 0, 130)
MainFrame.Position = UDim2.new(1, -290, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(255, 200, 0)
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "VuNguyen Hydra Check"
Title.TextColor3 = Color3.fromRGB(255, 200, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14

local Line = Instance.new("Frame", Title)
Line.Size = UDim2.new(1, 0, 0, 1)
Line.Position = UDim2.new(0, 0, 1, 0)
Line.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
Line.BorderSizePixel = 0

local StatusLabel = Instance.new("TextLabel", MainFrame)
StatusLabel.Size = UDim2.new(1, -20, 0, 70)
StatusLabel.Position = UDim2.new(0, 10, 0, 35)
StatusLabel.Text = "Đang khởi động..."
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextWrapped = true
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 12
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

-- ==========================================
-- [ LOGIC CHECK HYDRA LOOP ]
-- ==========================================
task.spawn(function()
    local checkCount = 0

    while true do
        checkCount = checkCount + 1
        StatusLabel.Text = "🔍 Đang check Hydra... (Lần " .. checkCount .. ")"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)

        local ok, status = pcall(function()
            return HydraRemote:InvokeServer("Interacted")
        end)

        if ok and status == 4 then
            -- ĐÃ HOÀN THÀNH
            StatusLabel.Text = "✅ Hydra: ĐÃ HOÀN THÀNH!\nĐang ghi file..."
            StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            warn("[HydraCheck] Status = 4 → Completed!")

            pcall(function()
                writefile(Player.Name .. ".txt", "Completed-draco4")
            end)
            warn("[HydraCheck] Đã ghi file " .. Player.Name .. ".txt → Completed-draco4")

            task.wait(1)
            StatusLabel.Text = "✅ Hydra: HOÀN THÀNH!\n📄 File: " .. Player.Name .. ".txt\n→ Completed-draco4"
            StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            break
        else
            -- CHƯA ĐẠT → delay 15 giây rồi check lại
            local statusText = ok and tostring(status) or "error"
            warn("[HydraCheck] Lần " .. checkCount .. " → Status: " .. statusText .. " → Chờ 15s...")

            for i = 15, 1, -1 do
                StatusLabel.Text = string.format(
                    "❌ Hydra: Chưa đạt (Lần %d)\nStatus: %s\nCheck lại sau %ds...",
                    checkCount, statusText, i
                )
                StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
                task.wait(1)
            end
        end
    end
end)
