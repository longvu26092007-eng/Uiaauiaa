-- ======================================================================
-- REMOTE DEBUGGER V13.1 - REAL-TIME TEXT DETECTOR
-- Mục tiêu: Bắt lệnh Search ngay khi vừa gõ phím (No Enter Needed)
-- ======================================================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")

if rconsolestatus then rconsolestatus("REAL-TIME DETECTOR - BY GEMINI") end
if rconsoleclear then rconsoleclear() end

print("====================================================")
print("🔍 [V13.1] BẮT LỆNH SEARCH THỜI GIAN THỰC")
print("👉 Cậu chỉ cần gõ vài chữ vào ô Region (không nhấn Enter).")
print("👉 Script sẽ hiện ra cái 'Chuỗi' mà game vừa gửi lên Server.")
print("====================================================")

local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    local response = oldNamecall(self, ...)

    -- Kiểm tra nếu đúng là Remote của Server Browser
    if (method == "InvokeServer" or method == "FireServer") and self.Name == "__ServerBrowser" then
        task.spawn(function()
            -- Duyệt qua các đối số (Arguments) để tìm xem có cái nào là String (văn bản) không
            for i, arg in pairs(args) do
                if type(arg) == "string" and #arg > 0 then
                    -- Loại bỏ các JobId (thường rất dài) để tránh bắt nhầm
                    if #arg < 30 then 
                        warn("⌨️ PHÁT HIỆN GÕ PHÍM: " .. arg)
                        print("📍 Vị trí tham số (Index): [" .. i .. "]")
                        print("🛠️ Full Lệnh: game.ReplicatedStorage." .. self.Name .. ":" .. method .. "(unpack(args))")
                        
                        -- Tự động copy lệnh hiện tại vào Clipboard
                        if setclipboard then
                            setclipboard(arg)
                        end
                    end
                end
            end
        end)
    end

    return response
end)

setreadonly(mt, true)
