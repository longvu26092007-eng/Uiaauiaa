-- ======================================================================
-- REMOTE SPY V12.2 - DEEP DEBUGGER (PHIÊN BẢN GIẢI MÃ TABLE)
-- Tối ưu: Đọc sâu dữ liệu Table v371 để bắt chính xác Command
-- ======================================================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")

if rconsolestatus then rconsolestatus("DRAGON DEEP DEBUGGER - BY GEMINI") end
if rconsoleclear then rconsoleclear() end

print("====================================================")
print("🚀 [V12.2] DEEP DEBUGGER - ĐÃ SẴN SÀNG")
print("👉 Chuyên trị các lệnh dạng Table phức tạp của Dragon Wizard.")
print("👉 Hệ thống sẽ tự phân tích nội dung bên trong { ... }")
print("====================================================")

-- Hàm giải mã Table (Deep Table Decoder)
local function TableToString(t, indent)
    indent = indent or ""
    local s = "{\n"
    for k, v in pairs(t) do
        s = s .. indent .. "    [" .. (type(k) == "string" and '"'..k..'"' or k) .. "] = "
        if type(v) == "table" then
            s = s .. TableToString(v, indent .. "    ") .. ",\n"
        elseif type(v) == "string" then
            s = s .. '"' .. v .. '",\n'
        else
            s = s .. tostring(v) .. ",\n"
        end
    end
    return s .. indent .. "}"
end

-- Hàm định dạng tham số chuẩn để Vũ chỉ việc Paste
local function FormatArgs(args)
    local out = {}
    for i, v in pairs(args) do
        if type(v) == "table" then
            table.insert(out, TableToString(v))
        elseif type(v) == "string" then
            table.insert(out, '"' .. v .. '"')
        elseif type(v) == "number" or type(v) == "boolean" then
            table.insert(out, tostring(v))
        else
            table.insert(out, tostring(v))
        end
    end
    return table.concat(out, ", ")
end

local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    local response = oldNamecall(self, ...)

    if (method == "InvokeServer" or method == "FireServer") then
        task.spawn(function()
            -- Kiểm tra xem trong Args có dữ liệu liên quan đến Dragon không
            local isDragonRelated = false
            local rawStr = ""
            
            -- Quét sâu vào table để tìm từ khóa
            for _, arg in pairs(args) do
                local strArg = typeof(arg) == "table" and TableToString(arg):lower() or tostring(arg):lower()
                if strArg:find("dragon") or strArg:find("wizard") or strArg:find("race") then
                    isDragonRelated = true
                    break
                end
            end

            if isDragonRelated or tostring(self.Name):lower():find("dragon") then
                local argString = FormatArgs(args)
                local finalCmd = string.format('game.%s:%s(%s)', self:GetFullName(), method, argString)
                
                warn("🔥 PHÁT HIỆN LỆNH TABLE (DEEP SCAN) 🔥")
                print("🐲 Remote: " .. self.Name)
                print("🚀 LỆNH CHUẨN ĐỂ VŨ COPY:")
                print("------------------------------------------")
                print(finalCmd)
                print("------------------------------------------")

                if setclipboard then setclipboard(finalCmd) end
            end
        end)
    end

    return response
end)

setreadonly(mt, true)
