-- ======================================================================
-- REMOTE SPY V13.1 - TOTAL CAPTURE (KHÔNG BỘ LỌC)
-- Mục tiêu: Bắt tất cả lệnh khi Vũ tương tác với NPC/GUI
-- ======================================================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")
if rconsoleclear then rconsoleclear() end

print("====================================================")
print("🚀 [V13.1] TOTAL CAPTURE - ĐANG QUÉT TẤT CẢ")
print("👉 Vũ bấm vào nút bất kỳ, lệnh sẽ hiện ngay lập tức.")
print("👉 Không lọc từ khóa để tránh sót lệnh NPC ẩn.")
print("====================================================")

-- Hàm giải mã Table cực sâu
local function DeepTable(t, indent)
    indent = indent or ""
    local s = "{\n"
    local count = 0
    for k, v in pairs(t) do
        count = count + 1
        s = s .. indent .. "    [" .. (type(k) == "string" and '"'..k..'"' or k) .. "] = "
        if type(v) == "table" then
            s = s .. DeepTable(v, indent .. "    ") .. ",\n"
        elseif type(v) == "string" then
            s = s .. '"' .. v .. '",\n'
        else
            s = s .. tostring(v) .. ",\n"
        end
    end
    return (count == 0) and "{}" or s .. indent .. "}"
end

local function FormatArgs(args)
    local out = {}
    for i, v in pairs(args) do
        if type(v) == "table" then table.insert(out, DeepTable(v))
        elseif type(v) == "string" then table.insert(out, '"' .. v .. '"')
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
    
    -- Bắt tất cả InvokeServer và FireServer
    if (method == "InvokeServer" or method == "FireServer") then
        task.spawn(function()
            local argString = FormatArgs(args)
            local remotePath = self:GetFullName()
            local finalCmd = string.format('game.%s:%s(%s)', remotePath, method, argString)
            
            warn("📡 PHÁT HIỆN LỆNH MỚI 📡")
            print("📦 Remote Path: " .. remotePath)
            print("📝 Method: " .. method)
            print("🚀 LỆNH CHUẨN:")
            print("------------------------------------------")
            print(finalCmd)
            print("------------------------------------------")
            
            if setclipboard then setclipboard(finalCmd) end
        end)
    end
    
    return oldNamecall(self, ...)
end)

setreadonly(mt, true)
