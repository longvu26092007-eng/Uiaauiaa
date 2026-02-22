-- ======================================================================
-- REMOTE SPY V11.2 - CHUYÊN DỤNG CHO FISHERMAN (CẢI THIỆN TẦM NHÌN)
-- Tự động lọc, làm sạch Console và hỗ trợ Auto Copy
-- ======================================================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LogService = game:GetService("LogService")

-- 1. Làm sạch Terminal trước khi chạy (Dành cho Executor hỗ trợ)
if rconsolestatus then rconsolestatus("FISHERMAN SPY BY GEMINI") end
if rconsoleclear then rconsoleclear() end

print("====================================================")
print("🚀 [V11.2] REMOTE SPY FISHERMAN - ĐANG LẮNG NGHE...")
print("👉 HƯỚNG DẪN: Cậu cứ đi mua mồi/craft như bình thường.")
print("👉 Hệ thống sẽ tự lọc và hiện lệnh quan trọng nhất ở đây.")
print("====================================================")

-- Hàm định dạng tham số cực chuẩn
local function FormatArgs(args)
    local out = {}
    for i, v in pairs(args) do
        if type(v) == "string" then
            table.insert(out, '"' .. v .. '"')
        elseif type(v) == "number" or type(v) == "boolean" then
            table.insert(out, tostring(v))
        elseif v == nil then
            table.insert(out, "nil")
        else
            table.insert(out, tostring(v)) -- Tránh lỗi "nil" khi gặp Object bí mật
        end
    end
    return table.concat(out, ", ")
end

-- HOOK HỆ THỐNG
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if (method == "InvokeServer" or method == "FireServer") then
        local argString = FormatArgs(args)
        local lowerArgs = argString:lower()
        
        -- BỘ LỌC THÔNG MINH: Chỉ bắt các lệnh chứa từ khóa quan trọng
        if lowerArgs:find("fisherman") or lowerArgs:find("bait") or lowerArgs:find("fishing") or lowerArgs:find("craft") then
            
            -- Lệnh hoàn chỉnh để dán vào Lua
            local finalCmd = string.format('game.%s:%s(%s)', self:GetFullName(), method, argString)
            
            -- IN RA F9 (MÀU VÀNG ĐỂ DỄ NHÌN)
            warn("✨ PHÁT HIỆN LỆNH MỚI ✨")
            print("💎 Remote: " .. self.Name)
            print("🔧 Cách gọi: " .. method)
            print("📝 Args: " .. argString)
            print("🚀 DÙNG LỆNH NÀY:")
            print("   " .. finalCmd)
            warn("------------------------------------------")

            -- TỰ ĐỘNG COPY VÀO CLIPBOARD (Dễ dàng nhất cho Vũ)
            if setclipboard then
                setclipboard(finalCmd)
                -- Thông báo nhỏ trên màn hình game
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Fisherman Spy",
                    Text = "Đã tự động Copy lệnh vào Clipboard!",
                    Duration = 2
                })
            end
        end
    end

    return oldNamecall(self, ...)
end)

setreadonly(mt, true)
