repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.Players.LocalPlayer
repeat task.wait() until game.Players.LocalPlayer:FindFirstChild("PlayerGui")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- Remote Dragon Quest
local RFDragonQuest = ReplicatedStorage
    :WaitForChild("Modules")
    :WaitForChild("Net")
    :WaitForChild("RF/InteractDragonQuest")

-- ===== GUI =====
local gui = Instance.new("ScreenGui")
gui.Name = "DragonQuestTest"
gui.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 150)
frame.Position = UDim2.new(0.5, -125, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Parent = gui

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 200, 0, 50)
button.Position = UDim2.new(0.5, -100, 0, 20)
button.Text = "Nhận Dragon Quest"
button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
button.TextColor3 = Color3.new(1,1,1)
button.Parent = frame

local status = Instance.new("TextLabel")
status.Size = UDim2.new(0, 220, 0, 40)
status.Position = UDim2.new(0.5, -110, 0, 90)
status.Text = "Status: Idle"
status.TextColor3 = Color3.new(1,1,1)
status.BackgroundTransparency = 1
status.Parent = frame

-- ===== FUNCTION =====
local function interactDragonQuest()
    status.Text = "Status: Sending..."

    local ok, res = pcall(function()
        return RFDragonQuest:InvokeServer({})
    end)

    if ok then
        status.Text = "Status: Success"
    else
        status.Text = "Status: Failed"
        warn("[RF/InteractDragonQuest] Failed:", res)
    end
end

-- ===== BUTTON CLICK =====
button.MouseButton1Click:Connect(function()
    status.Text = "Status: Running..."

    interactDragonQuest()
    task.wait(1)
    interactDragonQuest()

    status.Text = "Status: Done"
end)
