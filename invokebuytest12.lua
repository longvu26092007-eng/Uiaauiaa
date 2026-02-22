-- =============================================================
-- FISHERMAN PRO TESTER - VERSION 2026
-- Mix: Source Pro của Vũ + Logic Net/Modules
-- =============================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local lp = Players.LocalPlayer

-- 1. TẠO GIAO DIỆN TEST
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FishermanProTest"
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = lp.PlayerGui end

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 320, 0, 250)
Main.Position = UDim2.new(0.5, -160, 0.4, -125)
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Main.Active = true
Main.Draggable = true

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Title.Text = "FISHERMAN PRO TESTER"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.SourceSansBold

local StatusLabel = Instance.new("TextLabel", Main)
StatusLabel.Size = UDim2.new(1, -20, 0, 100)
StatusLabel.Position = UDim2.new(0, 10, 0, 50)
StatusLabel.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
StatusLabel.Text = "Đang chờ cậu bấm Test..."
StatusLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
StatusLabel.TextWrapped = true
StatusLabel.TextSize = 14

-- 2. HÀM THỰC THI (DỰA TRÊN FILE CẬU GỬI)
local function RunProTest()
    local function Log(msg, color)
        StatusLabel.Text = msg
        StatusLabel.TextColor3 = color or Color3.new(1, 1, 1)
        print("[Pro-Test]: " .. msg)
    end

    -- Tìm Remote theo đường dẫn trong file cậu gửi
    local Net = ReplicatedStorage:FindFirstChild("Modules") 
                and ReplicatedStorage.Modules:FindFirstChild("Net")
    
    if not Net then
        Log("❌ LỖI: Không thấy thư mục Modules/Net!", Color3.new(1, 0, 0))
        return
    end

    local CraftRF = Net:FindFirstChild("RF/Craft")
    local JobsRF = Net:FindFirstChild("RF/JobsRemoteFunction")

    if not CraftRF then
        Log("❌ LỖI: Không thấy Remote RF/Craft!", Color3.new(1, 0, 0))
        return
    end

    task.spawn(function()
        -- Bước 1: Xin phép Entrance (Dựa trên code cậu gửi)
        Log("⚡ Bước 1: Sending requestEntrance...", Color3.new(1, 1, 0))
        pcall(function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(5661.5, 1013.1, -334.9))
        end)
        task.wait(0.3)

        -- Bước 2: Gửi lệnh Check Fisherman (Dựa trên Log V11)
        Log("⚡ Bước 2: Checking NPC Fisherman...", Color3.new(1, 0.5, 0))
        if JobsRF then
            pcall(function() JobsRF:InvokeServer("FishingNPC", "Bait", "Check", "Fisherman") end)
        end
        task.wait(0.3)

        -- Bước 3: Lệnh Craft chốt (Dùng cấu trúc {} từ file mới)
        Log("⚡ Bước 3: Gửi lệnh Craft chuẩn...", Color3.new(0, 1, 1))
        local args = {
            [1] = "Craft",
            [2] = "Basic Bait",
            [3] = {} 
        }
        
        local ok, res = pcall(function()
            return CraftRF:InvokeServer(unpack(args))
        end)

        if ok then
            Log("✅ THÀNH CÔNG!\nServer phản hồi: " .. tostring(res), Color3.new(0, 1, 0))
        else
            Log("❌ THẤT BẠI!\nLỗi: " .. tostring(res), Color3.new(1, 0, 0))
        end
    end)
end

-- 3. NÚT BẤM
local TestBtn = Instance.new("TextButton", Main)
TestBtn.Size = UDim2.new(0.8, 0, 0, 45)
TestBtn.Position = UDim2.new(0.1, 0, 0.75, 0)
TestBtn.Text = "START PRO TEST"
TestBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
TestBtn.TextColor3 = Color3.new(1, 1, 1)
TestBtn.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", TestBtn)

TestBtn.MouseButton1Click:Connect(RunProTest)

-- Nút thoát
local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -35, 0, 5)
Close.Text = "X"
Close.TextColor3 = Color3.new(1, 0, 0)
Close.BackgroundTransparency = 1
Close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
