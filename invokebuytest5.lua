-- ======================================================================
-- SCRIPT FISHERMAN V5.1 - FIX THEO LOGIC REMOTE "ORDER"
-- ======================================================================

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Tìm Remote đúng như trong file Order_System.lua
local CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")

-- 1. GUI TEST
local ScreenGui = Instance.new("ScreenGui", lp.PlayerGui)
ScreenGui.Name = "FishermanCraftFix"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 260, 0, 150)
Main.Position = UDim2.new(0.5, -130, 0.4, -75)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "FISHERMAN CRAFT FIX"
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.TextColor3 = Color3.new(1, 1, 1)

local Label = Instance.new("TextLabel", Main)
Label.Size = UDim2.new(1, 0, 0, 40)
Label.Position = UDim2.new(0, 0, 0.25, 0)
Label.Text = "Status: Sẵn sàng"
Label.TextColor3 = Color3.new(1, 1, 1)
Label.BackgroundTransparency = 1

-- 2. LOGIC SỬA ĐỔI
local function ExecuteFishermanCraft()
    Label.Text = "Đang thực thi chuỗi lệnh..."
    Label.TextColor3 = Color3.new(1, 1, 0)

    -- SỬA ĐỔI QUAN TRỌNG: 
    -- Trong Blox Fruits, một số NPC yêu cầu lệnh "Talk" hoặc "Initial" trước
    -- Sau đó mới đến các lựa chọn con.
    
    task.spawn(function()
        pcall(function()
            -- Bước 1: Gọi hội thoại gốc
            CommF:InvokeServer("Fisherman", "Talk") 
            task.wait(0.2)
            
            -- Bước 2: Chọn Shop/Dịch vụ
            CommF:InvokeServer("Fisherman", "Shop")
            task.wait(0.2)
            
            -- Bước 3: Lệnh để bật khung Craft (Thường là tên loại mồi)
            -- Nếu mồi bạn muốn là "Basic Bait", server cần nhận lệnh xác nhận lựa chọn đó
            local result = CommF:InvokeServer("Fisherman", "Basic Bait")
            
            -- Kiểm tra thực tế trong PlayerGui.Main (Theo yêu cầu của bạn)
            task.wait(0.1)
            local MainGui = lp.PlayerGui:FindFirstChild("Main")
            if MainGui then
                local CraftFrame = MainGui:FindFirstChild("Craft")
                if CraftFrame then
                    CraftFrame.Visible = true -- ÉP HIỆN KHUNG CRAFT
                    Label.Text = "DONE: Khung Craft đã mở!"
                    Label.TextColor3 = Color3.new(0, 1, 0)
                else
                    Label.Text = "LỖI: Không tìm thấy 'Craft' trong Main"
                    Label.TextColor3 = Color3.new(1, 0, 0)
                end
            end
        end)
    end)
end

-- 3. NÚT TEST
local ActionBtn = Instance.new("TextButton", Main)
ActionBtn.Size = UDim2.new(0.8, 0, 0, 40)
ActionBtn.Position = UDim2.new(0.1, 0, 0.65, 0)
ActionBtn.Text = "MỞ BẢNG CRAFT (FIXED)"
ActionBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
ActionBtn.TextColor3 = Color3.new(1, 1, 1)

ActionBtn.MouseButton1Click:Connect(ExecuteFishermanCraft)
