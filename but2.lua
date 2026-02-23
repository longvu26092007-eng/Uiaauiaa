local VirtualInputManager = game:GetService("VirtualInputManager")
local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Hàm quét tìm Object theo tên (không quan tâm nằm ở đâu)
local function FindObjectByName(parent, name)
    for _, child in pairs(parent:GetDescendants()) do
        if child.Name == name then
            return child
        end
    end
    return nil
end

local function SmartClickServerBrowser()
    -- 1. Quét toàn bộ PlayerGui để tìm nút
    local btn = FindObjectByName(PlayerGui, "ServerBrowser") 
              or FindObjectByName(PlayerGui, "Server Browser") 
              or FindObjectByName(PlayerGui, "ServerList")

    if btn and btn:IsA("GuiObject") then
        print("🎯 Đã bắt được mục tiêu tại: " .. btn:GetFullName())
        
        -- Đợi 1 xíu nếu nút chưa hiển thị hẳn
        if not btn.Visible then
            warn("⚠️ Nút tìm thấy nhưng đang bị ẩn (Visible = false)!")
        end

        -- 2. Lấy tọa độ thực (AbsolutePosition)
        local x = btn.AbsolutePosition.X + (btn.AbsoluteSize.X / 2)
        local y = btn.AbsolutePosition.Y + (btn.AbsoluteSize.Y / 2) + 58 -- Tăng lên 58 để bù trừ chuẩn cho nhiều dòng máy

        -- 3. Click
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 1)
        task.wait(0.1)
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 1)
        
        print("✅ Đã click ảo vào tâm nút!")
    else
        warn("❌ Vẫn không thấy nút nào tên là ServerBrowser. Hãy kiểm tra lại tên trong Dark Dex!")
    end
end

-- Chạy lệnh
SmartClickServerBrowser()
