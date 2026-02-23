local VirtualInputManager = game:GetService("VirtualInputManager")
local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local function AutoClickServerBrowser()
    -- 1. Tìm cái nút ServerBrowser trong PlayerGui
    -- Tớ dùng tìm kiếm đệ quy (true) để chắc chắn thấy nó dù nó nằm sâu trong folder nào
    local btn = PlayerGui:FindFirstChild("ServerBrowser", true) or PlayerGui:FindFirstChild("Server Browser", true)
    
    if btn and btn:IsA("GuiObject") and btn.Visible then
        print("🎯 Đã tìm thấy nút: " .. btn:GetFullName())
        
        -- 2. Lấy vị trí tâm của nút trên màn hình
        -- AbsolutePosition là tọa độ góc trên bên trái, AbsoluteSize là kích thước nút
        local x = btn.AbsolutePosition.X + (btn.AbsoluteSize.X / 2)
        local y = btn.AbsolutePosition.Y + (btn.AbsoluteSize.Y / 2) + 36 -- +36 để bù trừ cho thanh TopBar của Roblox
        
        -- 3. Thực hiện giả lập Click chuột vào đúng tọa độ đó
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 1) -- Nhấn xuống
        task.wait(0.05)
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 1) -- Thả ra
        
        print("✅ Đã click vào tọa độ: " .. x .. ", " .. y)
    else
        warn("❌ Không tìm thấy nút ServerBrowser hoặc nút đang bị ẩn!")
    end
end

-- Chạy thử lệnh
AutoClickServerBrowser()
