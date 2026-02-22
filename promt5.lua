-- ======================================================================
-- REMOTE SPY V11 - DÀNH RIÊNG CHO FISHERMAN (LOG TO F9)
-- Dựa trên logic hệ thống bạn gửi và tối ưu hóa chống trôi log
-- ======================================================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LogService = game:GetService("LogService")

-- Xóa sạch Console cũ để dễ nhìn (nếu Executor hỗ trợ)
if printconsole then printconsole("--- ĐANG ĐỢI LỆNH TỪ FISHERMAN ---") end

print("==============================================")
print("🚀 [V11] REMOTE SPY FISHERMAN ĐÃ KÍCH HOẠT")
print("👉 HƯỚNG DẪN: Bấm phím F9 (hoặc gõ /console)")
print("👉 Tìm những dòng có dấu ⭐⭐⭐")
print("==============================================")

-- Hàm định dạng Arguments để bạn copy dán vào script luôn được
local function FormatArgs(args)
    local out = {}
    for i, v in pairs(args) do
        if type(v) == "string" then
            table.insert(out, '"' .. v .. '"')
        elseif type(v) == "number" or type(v) == "boolean" then
            table.insert(out, tostring(v))
        else
            table.insert(out, "nil") -- Hoặc tostring(v) nếu cần soi Object
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
        
        -- BỘ LỌC CỰC MẠNH: Chỉ bắt những gì liên quan đến Fisherman hoặc Bait
        if string.find(lowerArgs, "fisherman") or string.find(lowerArgs, "bait") then
            
            -- In ra F9 với định dạng nổi bật nhất
            warn("⭐⭐⭐ PHÁT HIỆN LỆNH GỬI LÊN SERVER ⭐⭐⭐")
            print("▶️ Remote: " .. self.Name)
            print("▶️ Method: " .. method)
            print("▶️ Cấu trúc Args chuẩn:")
            print("   " .. argString)
            print("▶️ Câu lệnh dùng cho Script Silent:")
            print('   game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(' .. argString .. ')')
            warn("------------------------------------------")
        end
    end

    return oldNamecall(self, ...)
end)

setreadonly(mt, true)
