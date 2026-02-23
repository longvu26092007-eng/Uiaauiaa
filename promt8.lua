-- ======================================================================
-- REMOTE SPY V12.1 - DRAGON WIZARD (PHIÊN BẢN CHỐNG TREO NPC)
-- Tối ưu hóa: Xử lý dữ liệu ngầm để không làm kẹt hội thoại
-- ======================================================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")

if rconsolestatus then rconsolestatus("DRAGON WIZARD SPY - FIX BY GEMINI") end
if rconsoleclear then rconsoleclear() end

print("====================================================")
print("🚀 [V12.1] SPY DRAGON WIZARD - ĐÃ FIX KẸT NPC")
print("👉 Hệ thống sẽ xử lý lệnh ngầm, đảm bảo hội thoại mượt mà.")
print("====================================================")

local function FormatArgs(args)
    local out = {}
    for i, v in pairs(args) do
        if type(v) == "string" then table.insert(out, '"' .. v .. '"')
        elseif type(v) == "number" or type(v) == "boolean" then table.insert(out, tostring(v))
        elseif type(v) == "table" then table.insert(out, "{}")
        elseif typeof(v) == "Vector3" then table.insert(out, string.format("Vector3.new(%.2f, %.2f, %.2f)", v.X, v.Y, v.Z))
        elseif v == nil then table.insert(out, "nil")
        else table.insert(out, tostring(v)) end
    end
    return table.concat(out, ", ")
end

local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    -- TRẢ VỀ KẾT QUẢ NGAY LẬP TỨC CHO GAME ĐỂ KHÔNG KẸT NPC
    local response = oldNamecall(self, ...)

    -- XỬ LÝ SOÌ LỆNH TRONG LUỒNG RIÊNG (TASK.SPAWN)
    if (method == "InvokeServer" or method == "FireServer") then
        task.spawn(function()
            local argString = FormatArgs(args)
            local lowerArgs = argString:lower()
            local selfName = tostring(self.Name):lower()
            
            if lowerArgs:find("dragon") or lowerArgs:find("wizard") or lowerArgs:find("egg") or 
               lowerArgs:find("hatch") or selfName:find("dragon") or selfName:find("hatch") then
                
                local finalCmd = string.format('game.%s:%s(%s)', self:GetFullName(), method, argString)
                
                warn("🔥 PHÁT HIỆN LỆNH DRAGON WIZARD 🔥")
                print("🐲 NPC/Remote: " .. self.Name)
                print("🔧 Method: " .. method)
                print("🚀 LỆNH: " .. finalCmd)
                warn("------------------------------------------")

                if setclipboard then setclipboard(finalCmd) end
            end
        end)
    end

    return response
end)

setreadonly(mt, true)
