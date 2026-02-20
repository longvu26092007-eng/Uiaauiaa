-- Tải thư viện giao diện OrionLib
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexsoftware/Orion/main/source')))()

-- Tạo cửa sổ Hub
local Window = OrionLib:MakeWindow({
    Name = "Draco Hub VuNguyen", 
    HidePremium = false, 
    SaveConfig = true, 
    ConfigFolder = "DracoHubVuNguyen"
})

-- Khởi tạo các biến cơ bản của game
local Player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Tọa độ NPC Uzoth lấy từ ảnh của bạn
local Uzoth_CFrame = CFrame.new(5661.898, 1210.877, 863.176)

-------------------------------------------------------------------------
-- [HÀM HỖ TRỢ] - Di chuyển (Tween) an toàn
-------------------------------------------------------------------------
local function TweenTo(targetCFrame)
    local character = Player.Character or Player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")
    
    -- Tính toán khoảng cách và thời gian bay (Tốc độ bay: 300 studs/giây)
    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    local speed = 300 
    local time = distance / speed
    
    -- Cấu hình Tween
    local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
    
    -- Chống rơi (Noclip) cơ bản trong lúc bay để không kẹt tường
    local noclip
    noclip = RunService.Stepped:Connect(function()
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end)
    
    tween:Play()
    tween.Completed:Wait() -- Đợi bay đến nơi
    noclip:Disconnect()    -- Tắt noclip khi đến nơi
end

-------------------------------------------------------------------------
-- [HÀM CHÍNH] - Nhận diện và Mua Dragon Talon
-------------------------------------------------------------------------
local function CheckAndGetDragonTalon()
    local hasDragonTalon = false
    local character = Player.Character
    local backpack = Player:WaitForChild("Backpack")
    
    -- 1. Detect melee đang sử dụng (Kiểm tra trong Tay và trong Balo)
    if (character and character:FindFirstChild("Dragon Talon")) or backpack:FindFirstChild("Dragon Talon") then
        hasDragonTalon = true
    end
    
    -- 2. Xử lý Logic
    if hasDragonTalon then
        -- Nếu đã có Dragon Talon -> Dừng lại, để sau làm tiếp
        OrionLib:MakeNotification({
            Name = "Thông báo",
            Content = "Bạn đang sử dụng Dragon Talon! Bỏ qua bước này.",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
        print("[Draco Hub] Đã sở hữu Dragon Talon. Chờ lệnh tiếp theo...")
    else
        -- Nếu chưa có -> Tween đến NPC và mua
        OrionLib:MakeNotification({
            Name = "Thông báo",
            Content = "Chưa có Dragon Talon. Đang bay đến NPC Uzoth...",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
        print("[Draco Hub] Bắt đầu Tween đến: ", Uzoth_CFrame)
        
        -- Chạy lệnh bay
        TweenTo(Uzoth_CFrame)
        
        -- Đợi 1 chút cho nhân vật ổn định vị trí
        task.wait(0.5) 
        
        -- Gọi lệnh (RemoteEvent) mua Dragon Talon từ Server
        -- CommF_ là Remote Event gốc của Blox Fruits dùng để giao dịch/nhận nhiệm vụ
        local args = {
            [1] = "BuyDragonTalon"
        }
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
        
        OrionLib:MakeNotification({
            Name = "Thành công",
            Content = "Đã chạy lệnh mua Dragon Talon!",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    end
end

-------------------------------------------------------------------------
-- [GIAO DIỆN] - Thêm Tab và Nút Bấm
-------------------------------------------------------------------------
local MainTab = Window:MakeTab({
    Name = "Auto Melee",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Thêm Button để Test (Theo đúng yêu cầu)
MainTab:AddButton({
    Name = "Check & Mua Dragon Talon",
    Callback = function()
        -- Bọc trong task.spawn để không làm lag giao diện UI khi đang bay
        task.spawn(function()
            CheckAndGetDragonTalon()
        end)
    end    
})

-- Lệnh này để khởi tạo hoàn chỉnh giao diện
OrionLib:Init()
