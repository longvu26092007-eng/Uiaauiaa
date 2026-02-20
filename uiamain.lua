-- Khởi tạo các dịch vụ
local Player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Tọa độ NPC Uzoth của cậu
local Uzoth_CFrame = CFrame.new(5661.898, 1210.877, 863.176)

-------------------------------------------------------------------------
-- 1. HÀM BAY (TWEEN) XUYÊN TƯỜNG
-------------------------------------------------------------------------
local function TweenTo(targetCFrame)
    local character = Player.Character or Player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")
    
    -- Tính toán thời gian bay (Tốc độ 300)
    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    local speed = 300 
    local time = distance / speed
    
    local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
    
    -- Tắt va chạm (Noclip) để không kẹt tường
    local noclip
    noclip = RunService.Stepped:Connect(function()
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end)
    
    tween:Play()
    tween.Completed:Wait() 
    noclip:Disconnect()    
end

-------------------------------------------------------------------------
-- 2. HÀM KIỂM TRA & MUA DRAGON TALON
-------------------------------------------------------------------------
local function CheckAndGetDragonTalon()
    local hasDragonTalon = false
    local character = Player.Character
    local backpack = Player:WaitForChild("Backpack")
    
    -- Detect Melee đang xài hoặc cất trong balo
    if (character and character:FindFirstChild("Dragon Talon")) or backpack:FindFirstChild("Dragon Talon") then
        hasDragonTalon = true
    end
    
    if hasDragonTalon then
        print("[Draco Hub] Cậu đang dùng Dragon Talon rồi! Bỏ qua.")
    else
        print("[Draco Hub] Chưa có Dragon Talon. Bắt đầu bay đến Uzoth...")
        TweenTo(Uzoth_CFrame)
        
        -- Nghỉ 0.5s cho nhân vật đứng vững
        task.wait(0.5) 
        
        -- Gửi sự kiện mua hàng lên Server
        local args = {
            [1] = "BuyDragonTalon"
        }
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
        print("[Draco Hub] Đã gửi lệnh mua thành công!")
    end
end

-------------------------------------------------------------------------
-- 3. CHẠY TEST LUÔN KHÔNG CẦN NÚT
-------------------------------------------------------------------------
task.spawn(function()
    CheckAndGetDragonTalon()
end)
