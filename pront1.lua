-- ======================================================================
-- REMOTE SPY V12.6 - DEX EXPLORER EDITION
-- Mục tiêu: Đồng bộ hóa đường dẫn với Dark Dex để Vũ dễ tra cứu.
-- Tính năng: Deep Scan Table + Full Dex Path + Auto Script Generator
-- ======================================================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")

if rconsolestatus then rconsolestatus("DEX-SPY V12.6: SYNCHRONIZED") end
if rconsoleclear then rconsoleclear() end

print("====================================================")
print("🔍 [V12.6] DEX-SPY - ĐÃ ĐỒNG BỘ VỚI DARK DEX")
print("👉 Đường dẫn in ra sẽ khớp 100% với Explorer của Dex.")
print("👉 Chỉ tập trung vào các Remote liên quan đến Server/Browser.")
print("====================================================")

-- Hàm lấy đường dẫn chuẩn như trong Dark Dex
local function GetDexPath(obj)
    local parts = {}
    local current = obj
    while current and current ~= game do
        table.insert(parts, 1, current.Name)
        current = current.Parent
    end
    return "game." .. table.concat(parts, ".")
end

-- Hàm giải mã Table sâu (Deep Decoder)
local function DeepTable(t, indent)
    if type(t) ~= "table" then return tostring(t) end
    indent = indent or ""
    local s = "{\n"
    for k, v in pairs(t) do
        s = s .. indent .. "    [" .. (type(k) == "string" and '"'..k..'"' or k) .. "] = "
        if type(v) == "table" then
            s = s .. DeepTable(v, indent .. "    ") .. ",\n"
        elseif type(v) == "string" then
            s = s .. '"' .. v .. '",\n'
        else
            s = s .. tostring(v) .. ",\n"
        end
    end
    return s .. indent .. "}"
end

local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    local response = oldNamecall(self, ...)

    if (method == "InvokeServer" or method == "FireServer") then
        local name = self.Name:lower()
        -- Lọc đúng đối tượng Server Browser
        if name:find("server") or name:find("browser") or name:find("__") or name:find("list") then
            task.spawn(function()
                local dexPath = GetDexPath(self)
                warn("📦 [DEX DETECTED] " .. self.Name)
                print("📍 Dex Path: " .. dexPath)
                print("📩 Args: " .. DeepTable(args))
                
                if response then
                    print("📥 Return Data: " .. DeepTable(response))
                end

                -- Tạo luôn đoạn code mẫu để Vũ dùng
                local scriptGen = string.format('-- Script của Vũ Nguyễn\nlocal Remote = %s\nRemote:%s(unpack(%s))', dexPath, method, DeepTable(args))
                
                if setclipboard then setclipboard(scriptGen) end
                print("🚀 Đã copy Script Generator vào Clipboard!")
            end)
        end
    end

    return response
end)

setreadonly(mt, true)
