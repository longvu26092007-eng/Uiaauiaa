local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local function OpenServerBrowserUI()
    -- Tìm bảng Main UI của game (thường tên là Main hoặc Hud)
    local mainGui = PlayerGui:FindFirstChild("Main") or PlayerGui:FindFirstChild("Hud")
    
    if mainGui then
        -- Vũ hãy kiểm tra tên cái nút Server Browser trong Dex nhé
        -- Ở đây tớ ví dụ tên nút là 'ServerButton' nằm trong khung 'Left' hoặc 'Container'
        local btn = mainGui:FindFirstChild("ServerButton", true) -- Tìm sâu trong các folder con
        
        if btn and btn:IsA("TextButton") or btn:IsA("ImageButton") then
            print("🚀 Đã tìm thấy nút, đang tự động Click...")
            
            -- Cách 1: Dùng lệnh click ảo của Roblox
            local events = {"MouseButton1Click", "MouseButton1Down", "Activated"}
            for _, event in pairs(events) do
                if btn[event] then
                    for _, connection in pairs(getconnections(btn[event])) do
                        connection:Fire()
                    end
                end
            end
        else
            -- Nếu không tìm thấy nút, ta ép lệnh Invoke luôn cho nhanh
            warn("⚠️ Không tìm thấy nút UI, dùng cách gọi Remote trực tiếp...")
            game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer(1)
        end
    end
end

-- Chạy lệnh mở
OpenServerBrowserUI()
