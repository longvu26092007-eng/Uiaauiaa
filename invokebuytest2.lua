-- ======================================================================
-- SCRIPT FISHERMAN V3 - BYPASS & FORCE OPEN CRAFT UI
-- ======================================================================

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local CommF = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_")

-- 1. GUI QUẢN LÝ
local TestGui = Instance.new("ScreenGui")
TestGui.Name = "FishermanV3"
TestGui.Parent = lp.PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 150)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.Parent = TestGui

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 50)
StatusLabel.Text = "Status: Sẵn sàng test"
StatusLabel.TextColor3 = Color3.new(1, 1, 1)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Parent = MainFrame

-- 2. HÀM FIX LỖI "DONE ẢO"
local function ForceCraftBait()
    -- LẤY THÔNG TIN NPC (Bạn cần đứng gần Fisherman)
    local FishermanNPC = game.Workspace.NPCs:FindFirstChild("Fisherman") 
    if not FishermanNPC then
        StatusLabel.Text = "LỖI: Không tìm thấy NPC Fisherman trong Workspace!"
        StatusLabel.TextColor3 = Color3.new(1, 0, 0)
        return
    end

    StatusLabel.Text = "Đang Bypass Khoảng cách..."
    
    -- Bước quan trọng: Đưa tọa độ nhân vật đến sát NPC để Server không chặn
    local oldCFrame = lp.Character.HumanoidRootPart.CFrame
    lp.Character.HumanoidRootPart.CFrame = FishermanNPC:GetModelCFrame()
    task.wait(0.2)

    -- CHUỖI LỆNH MỒI (Phải đúng thứ tự game mới mở bảng Craft)
    pcall(function()
        StatusLabel.Text = "Đang kích hoạt Shop..."
        CommF:InvokeServer("Fisherman", "Shop") -- Mở menu chính
        task.wait(0.3)
        
        StatusLabel.Text = "Đang vào menu Buy Bait..."
        CommF:InvokeServer("Fisherman", "Buy Bait") -- Vào tầng 2
        task.wait(0.3)
        
        StatusLabel.Text = "Đang yêu cầu mở Khung Craft..."
        -- Đây là lệnh quan trọng để cái BẢNG CRAFT hiện lên màn hình
        CommF:InvokeServer("Fisherman", "Basic Bait") 
    end)

    -- KIỂM TRA BẢNG CRAFT ĐÃ HIỆN CHƯA
    task.spawn(function()
        local CraftUI = lp.PlayerGui.Main:FindFirstChild("Craft")
        if CraftUI then
            CraftUI.Visible = true -- Ép nó hiện lên nếu nó bị ẩn
            StatusLabel.Text = "THÀNH CÔNG: Đã mở khung Craft!"
            StatusLabel.TextColor3 = Color3.new(0, 1, 0)
        else
            StatusLabel.Text = "LỖI: Server không gửi dữ liệu UI Craft!"
            StatusLabel.TextColor3 = Color3.new(1, 0, 0)
        end
    end)
    
    -- Trả nhân vật về chỗ cũ (nếu muốn)
    -- task.wait(0.5)
    -- lp.Character.HumanoidRootPart.CFrame = oldCFrame
end

-- 3. NÚT BẤM
local Btn = Instance.new("TextButton")
Btn.Size = UDim2.new(0.8, 0, 0, 40)
Btn.Position = UDim2.new(0.1, 0, 0.6, 0)
Btn.Text = "MỞ KHUNG CRAFT BAIT"
Btn.Parent = MainFrame
Btn.MouseButton1Click:Connect(ForceCraftBait)
