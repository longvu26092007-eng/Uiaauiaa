-- ======================================================================
-- REMOTE DEBUGGER V13.2 - SEARCH FRAME SNIPER
-- Chuyên trị: Real-time Search trong SearchRegion Frame
-- ======================================================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")

if rconsolestatus then rconsolestatus("SEARCH SNIPER - BY GEMINI") end
if rconsoleclear then rconsoleclear() end

print("====================================================")
print("🔍 [V13.2] ĐANG RÌNH RẬP FRAME: SearchRegion")
print("👉 Vũ hãy gõ chữ vào ô Search (không cần Enter).")
print("👉 Script sẽ hiện cấu trúc lệnh chuẩn để cậu làm Auto.")
print("====================================================")

local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    local response = oldNamecall(self, ...)

    -- Kiểm tra Remote Server Browser
    if (method == "InvokeServer" or method == "FireServer") and self.Name == "__ServerBrowser" then
        task.spawn(function()
            -- Tìm kiếm trong mảng Arguments xem có String nào không
            for i, v in pairs(args) do
                if type(v) == "string" and #v > 0 and #v < 30 then
                    warn("🎯 BẮT ĐƯỢC LỆNH FILTER!")
                    print("📍 Từ khóa: " .. v)
                    print("📍 Vị trí tham số (Index): [" .. i .. "]")
                    print("🛠️ Code để cậu dùng: ")
                    
                    -- Tạo luôn đoạn code mẫu cho Vũ
                    local code = string.format('game:GetService("ReplicatedStorage").__ServerBrowser:%s(1, "%s")', method, v)
                    print(code)
                    
                    if setclipboard then setclipboard(code) end
                end
            end
        end)
    end

    return response
end)

setreadonly(mt, true)
