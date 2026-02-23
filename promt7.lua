-- ======================================================================
-- REMOTE SPY V12.0 - CHUYÊN DỤNG CHO DRAGON WIZARD (PHIÊN BẢN HATCH EGG)
-- Tự động lọc các lệnh liên quan đến Rồng và Nở Trứng
-- ======================================================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- 1. Làm sạch Console để nhìn cho rõ
if rconsolestatus then rconsolestatus("DRAGON WIZARD SPY BY GEMINI") end
if rconsoleclear then rconsoleclear() end

print("====================================================")
print("🚀 [V12.0] REMOTE SPY DRAGON WIZARD - ĐANG LẮNG NGHE...")
print("👉 HƯỚNG DẪN: Cậu hãy tiến hành Nở Trứng hoặc nâng cấp Rồng.")
print("👉 Hệ thống sẽ tự lọc các lệnh Dragon/Egg và Copy cho cậu.")
print("====================================================")

-- Hàm định dạng tham số chuẩn để dán vào script ngay
local function FormatArgs(args)
    local out = {}
    for i, v in pairs(args) do
        if type(v) == "string" then
            table.insert(out, '"' .. v .. '"')
        elseif type(v) == "number" or type(v) == "boolean" then
            table.insert(out, tostring(v))
        elseif type(v) == "table" then
            table.insert(out, "{}") -- Đơn giản hóa table rỗng như phong cách của Vũ
        elseif typeof(v) == "Vector3" then
            table.insert(out, string.format("Vector3.new(%.2f, %.2f, %.2f)", v.X, v.Y, v.Z))
        elseif v == nil then
            table.insert(out, "nil")
        else
            table.insert(out, tostring(v))
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
        local selfName = tostring(self.Name):lower()
        
        -- BỘ LỌC DRAGON WIZARD: Tập trung vào Rồng, Pháp sư, Trứng và Nở
        if lowerArgs:find("dragon") or lowerArgs:find("wizard") or lowerArgs:find("egg") or 
           lowerArgs:find("hatch") or selfName:find("dragon") or selfName:find("hatch") then
            
            -- Lệnh hoàn chỉnh để cậu dán vào Lua chạy ngay
            local finalCmd = string.format('game.%s:%s(%s)', self:GetFullName(), method, argString)
            
            -- IN RA F9 VỚI MÀU SẮC ĐẶC BIỆT
            warn("🔥 PHÁT HIỆN LỆNH DRAGON WIZARD 🔥")
            print("🐲 NPC/Remote: " .. self.Name)
            print("🔧 Method: " .. method)
            print("📝 Tham số: " .. argString)
            print("🚀 SCRIPT ĐỂ CHẠY:")
            print("   " .. finalCmd)
            warn("------------------------------------------")

            -- TỰ ĐỘNG COPY VÀO CLIPBOARD (Phong cách Draco Hub)
            if setclipboard then
                setclipboard(finalCmd)
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Dragon Wizard Spy",
                    Text = "Đã Copy lệnh Nở Trứng!",
                    Duration = 2
                })
            end
        end
    end

    return oldNamecall(self, ...)
end)

setreadonly(mt, true)
