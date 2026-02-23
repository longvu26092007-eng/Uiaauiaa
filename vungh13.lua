-- =============================================================
-- DRACO HUB - DRAGON WIZARD (FULL PATH: PORTAL + TWEEN + LEARN)
-- Lộ trình: Speak -> LearnTether
-- Style: Bám sát cấu trúc Dictionary Table của Vũ Nguyễn
-- =============================================================

repeat task.wait() until game:IsLoaded()

-- 1. CẤU HÌNH
getgenv().Config = {
    TEAM = "Pirates", -- Marines
    SPEED = 240,
    NPC_CFrame = CFrame.new(5773.936035, 1209.442871, 809.224548),
    Entrance_Pos = Vector3.new(5661.5322265625, 1013.0907592773438, -334.9649963378906)
}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local lp = Players.LocalPlayer

-- 2. AUTO CHỌN TEAM
if lp.Team == nil then
    repeat task.wait()
        for i, v in pairs(lp.PlayerGui:GetChildren()) do
            if string.find(v.Name, "Main") then
                pcall(function()
                    v.ChooseTeam.Container[getgenv().Config.TEAM].Frame.TextButton.Size = UDim2.new(0, 10000, 0, 10000)
                    v.ChooseTeam.Container[getgenv().Config.TEAM].Frame.TextButton.Position = UDim2.new(-4, 0, -5, 0)
                    v.ChooseTeam.Container[getgenv().Config.TEAM].Frame.TextButton.BackgroundTransparency = 1
                    task.wait(.5)
                    game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 1);task.wait(0.05)
                    game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, game, 1)
                end)
            end
        end
    until lp.Team ~= nil
    task.wait(3)
end

-- 3. HÀM TWEEN (TOPOSITION)
local function toposition(Pos, onDone)
    local char = lp.Character or lp.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")

    local root = char:FindFirstChild("Root")
    if not root then
        local K = Instance.new("Part")
        K.Size = Vector3.new(20, 0.5, 20); K.Name = "Root"; K.Anchored = true; K.Transparency = 1; K.CanCollide = false
        K.CFrame = hrp.CFrame * CFrame.new(0, 0.6, 0)
        K.Parent = char
        root = K
    end

    local distance = (Pos.Position - hrp.Position).Magnitude
    if distance <= 10 then
        root.CFrame = Pos; hrp.CFrame = Pos
        if typeof(onDone) == "function" then onDone() end
        return
    end

    if hum and hum.Sit then hum.Sit = false end

    local tweenObj = TweenService:Create(root, TweenInfo.new(distance / getgenv().Config.SPEED, Enum.EasingStyle.Linear), { CFrame = Pos })
    tweenObj:Play()

    local running = true
    task.spawn(function()
        while running do
            task.wait()
            pcall(function() hrp.CFrame = root.CFrame end)
        end
    end)

    tweenObj.Completed:Connect(function()
        running = false
        hrp.CFrame = root.CFrame
        if typeof(onDone) == "function" then onDone() end
    end)
end

-- 4. HÀM INTERACT (SPEAK & LEARN TETHER)
local function executeDragonWizard_Full()
    -- Bước 1: Gửi Request Entrance (Portal)
    pcall(function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", getgenv().Config.Entrance_Pos)
    end)
    task.wait(0.5)

    -- Bước 2: Tween đến NPC
    toposition(getgenv().Config.NPC_CFrame, function()
        task.wait(0.3)
        
        local Net = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net")
        local RF = Net:FindFirstChild("RF/InteractDragonQuest") or Net:WaitForChild("RF/InteractDragonQuest")

        -- Lệnh 1: Speak (Mồi hội thoại)
        local cmdSpeak = {
            [1] = {
                NPC = "Dragon Wizard",
                Command = "Speak"
            }
        }
        pcall(function() RF:InvokeServer(unpack(cmdSpeak)) end)
        
        task.wait(0.5)

        -- Lệnh 2: LearnTether (Chốt học)
        local cmdLearn = {
            [1] = {
                NPC = "Dragon Wizard",
                Command = "LearnTether"
            }
        }
        local ok, err = pcall(function() return RF:InvokeServer(unpack(cmdLearn)) end)

        if ok then
            warn("[InteractDragonQuest] Successfully Learned Dragon Tether")
        else
            warn("[InteractDragonQuest] Failed at Step 2:", err)
        end
    end)
end

-- 5. THỰC THI
executeDragonWizard_Full()
