-- ======================================================================
-- SUPER REMOTE SPY - BẮT TẤT CẢ CÁC LOẠI LỆNH (COMMF, REMOTEEVENT, ...)
-- ======================================================================

local LogService = game:GetService("LogService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

print("--- Đang khởi tạo Super Spy... ---")

-- Hàm xử lý hiển thị dữ liệu
local function LogData(self, method, args)
    local argStr = ""
    for i, v in pairs(args) do
        argStr = argStr .. tostring(v) .. (i < #args and ", " or "")
    end
    
    local output = string.format("[%s] Name: %s | Args: %s", method, self.Name, argStr)
    
    -- In ra Console (Bấm F9 để xem)
    print(output)
    
    -- Gửi thông báo lên màn hình game
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Remote Detected!",
        Text = self.Name .. " called",
        Duration = 2
    })
end

-- BẮT ĐẦU HOOK
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
local oldIndex = mt.__index
setreadonly(mt, false)

-- Cách 1: Bắt qua Namecall (Phổ biến nhất)
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if method == "InvokeServer" or method == "FireServer" then
        task.spawn(function() LogData(self, method, args) end)
    end
    
    return oldNamecall(self, ...)
end)

-- Cách 2: Bắt qua Index (Dự phòng cho một số Executor đặc biệt)
mt.__index = newcclosure(function(self, key)
    if key == "InvokeServer" or key == "FireServer" then
        -- Khi một script lấy hàm này để gọi, chúng ta ghi nhận lại
        -- Tuy nhiên cách này chỉ để debug sâu
    end
    return oldIndex(self, key)
end)

setreadonly(mt, true)

print("--- SUPER SPY ĐÃ CHẠY - HÃY NHẤN F9 VÀ ĐI CRAFT MỒI ---")
