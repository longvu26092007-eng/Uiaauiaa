local Player = game.Players.LocalPlayer
local TextBox = Player.PlayerGui.ServerBrowser.Frame.Filters.SearchRegion.TextBox

local function AutoSearchRegion(regionName)
    print("⌨️ Đang tự động nhập vùng: " .. regionName)
    
    -- 1. Tập trung vào TextBox
    TextBox:CaptureFocus() 
    
    -- 2. Gán chữ "Singapore" vào
    TextBox.Text = regionName
    
    -- 3. Giải phóng (giả lập hành động gõ xong)
    -- Một số game sẽ tự trigger lệnh khi thuộc tính Text thay đổi
    TextBox:ReleaseFocus(true) 
    
    -- 4. Nếu game cứng đầu không tự load, mình gọi thẳng Remote luôn
    task.wait(0.2)
    game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer(1, regionName)
end

-- Chạy thử
AutoSearchRegion("Singapore")
