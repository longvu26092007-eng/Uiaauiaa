--=========================================================================
-- [ PHẦN 1 ] LÕI LOGIC (Core Logic) - Load trước để dùng
--=========================================================================
-- Khởi tạo các dịch vụ
local Player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Tọa độ NPC Uzoth
local Uzoth_CFrame = CFrame.new(5661.898, 1210.877, 863.176)

-------------------------------------------------------------------------
-- 1. HÀM BAY (TWEEN) SIÊU MƯỢT (Chuẩn Kaitun Hub - Fix Giật)
-------------------------------------------------------------------------
function _G.TweenTo(targetCFrame)
    local character = Player.Character or Player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")
    local humanoid = character:WaitForChild("Humanoid")
    
    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    
    -- Teleport nếu gần
    if distance <= 250 then
        hrp.CFrame = targetCFrame
        return
    end

    -- Tạo BodyVelocity chống rơi
    local bv = hrp:FindFirstChild("DracoAntiGravity") or Instance.new("BodyVelocity")
    bv.Name = "DracoAntiGravity"
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Velocity = Vector3.new(0, 0, 0)
    bv.Parent = hrp
    
    -- Tốc độ chuẩn (Nếu bị giật ngược, giảm xuống 250-275)
    local speed = 300 
    local time = distance / speed
    local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
    
    -- Vòng lặp Noclip & State 11
    local noclip
    noclip = RunService.Stepped:Connect(function()
        -- Ép Humanoid vào trạng thái không dùng vật lý để bay mượt
        humanoid:ChangeState(11) 
        
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end)
    
    tween:Play()
    tween.Completed:Wait() 
    
    -- Dọn dẹp rác & Trả lại trạng thái bình thường
    if bv then bv:Destroy() end
    if noclip then noclip:Disconnect() end
    -- Trả trạng thái về bình thường
    humanoid:ChangeState(8) 
end

-------------------------------------------------------------------------
-- 2. HÀM KIỂM TRA & MUA DRAGON TALON (Sửa để kết nối với UI)
-------------------------------------------------------------------------
function _G.CheckAndGetDragonTalon()
    local hasDragonTalon = false
    local character = Player.Character
    local backpack = Player:WaitForChild("Backpack")
    
    if (character and character:FindFirstChild("Dragon Talon")) or backpack:FindFirstChild("Dragon Talon") then
        hasDragonTalon = true
    end
    
    if hasDragonTalon then
        OrionLib:MakeNotification({Name = "Thông báo", Content = "Bạn đã có Dragon Talon rồi! Bỏ qua.", Image = "rbxassetid://4483345998", Time = 5})
    else
        OrionLib:MakeNotification({Name = "Thông báo", Content = "Đang bay đến Uzoth...", Image = "rbxassetid://4483345998", Time = 5})
        _G.TweenTo(Uzoth_CFrame)
        task.wait(0.5) 
        
        local args = {[1] = "BuyDragonTalon"}
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
        
        OrionLib:MakeNotification({Name = "Thành công", Content = "Đã chạy lệnh mua Dragon Talon!", Image = "rbxassetid://4483345998", Time = 5})
    end
end


--=========================================================================
-- [ PHẦN 2 ] GIAO DIỆN NGƯỜI DÙNG (UI - OrionLib)
--=========================================================================

-- Tải thư viện Orion
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexsoftware/Orion/main/source')))()

-- Tạo Cửa sổ (Window) và cấu hình màu Đen - Vàng
local Window = OrionLib:MakeWindow({
    Name = "Draco Hub VuNguyen",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "DracoHubVuNguyen"
})

-- Cấu hình Theme Đen Vàng (Dark & Gold)
Window:SetTheme({
    OutlineColor = Color3.fromRGB(50, 50, 50), -- Viền xám đen
    
    WindowBackgroundColor = Color3.fromRGB(20, 20, 20), -- Nền sổ đen thẫm
    WindowBackgroundColor2 = Color3.fromRGB(255, 215, 0), -- Nền phụ Vàng kim

    BackgroundTransparent = 1, -- Trong suốt nền (Không che game)

    TextColor = Color3.fromRGB(255, 255, 255), -- Chữ màu trắng
    TextColor2 = Color3.fromRGB(255, 215, 0),  -- Chữ phụ màu Vàng kim

    ElementBackgroundColor = Color3.fromRGB(35, 35, 35), -- Nền của nút bấm (Đen xám)
    ElementBackgroundColor2 = Color3.fromRGB(255, 215, 0), -- Viền của nút bấm khi bấm (Vàng kim)
})


-------------------------------------------------------------------------
-- [GIAO DIỆN] - Tab và Nút Bấm
-------------------------------------------------------------------------
local MainTab = Window:MakeTab({
    Name = "Auto Melee",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

MainTab:AddSection({
    Name = "Chức năng test"
})

MainTab:AddButton({
    Name = "Check & Mua Dragon Talon (Test Tween)",
    Callback = function()
        -- Gọi hàm trong lõi, bọc trong task.spawn để không lag UI
        task.spawn(function()
            _G.CheckAndGetDragonTalon()
        end)
    end    
})

-- Khởi tạo UI
OrionLib:Init()
