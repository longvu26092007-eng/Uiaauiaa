-- ======================================================================
-- REMOTE SPY V13.2 - INTERACTION TRACKER (BẮT VÙNG TƯƠNG TÁC)
-- Chuyên trị: Các vùng Interact, ProximityPrompt, NPC ẩn danh
-- ======================================================================

if rconsoleclear then rconsoleclear() end
print("====================================================")
print("🚀 [V13.2] INTERACTION TRACKER - ĐÃ KÍCH HOẠT")
print("👉 Vũ hãy đi vào vùng tương tác và nhấn nút Interact.")
print("👉 Script sẽ lọc bỏ các lệnh rác để tìm đúng lệnh Race.")
print("====================================================")

local function DeepTable(t, indent)
    indent = indent or ""
    local s = "{\n"
    local count = 0
    for k, v in pairs(t) do
        count = count + 1
        s = s .. indent .. "    [" .. (type(k) == "string" and '"'..k..'"' or k) .. "] = "
        if type(v) == "table" then s = s .. DeepTable(v, indent .. "    ") .. ",\n"
        elseif type(v) == "string" then s = s .. '"' .. v .. '",\n'
        else s = s .. tostring(v) .. ",\n" end
    end
    return (count == 0) and "{}" or s .. indent .. "}"
end

local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if (method == "InvokeServer" or method == "FireServer") then
        local remoteName = tostring(self.Name):lower()
        
        -- Bỏ qua các lệnh rác hay gây loãng console
        local blackList = {"move", "dash", "look", "heartbeat", "checkpatch"}
        for _, word in pairs(blackList) do
            if remoteName:find(word) then return oldNamecall(self, ...) end
        end

        task.spawn(function()
            local out = {}
            for i, v in pairs(args) do
                if type(v) == "table" then table.insert(out, DeepTable(v))
                elseif type(v) == "string" then table.insert(out, '"' .. v .. '"')
                else table.insert(out, tostring(v)) end
            end
            local argString = table.concat(out, ", ")
            local finalCmd = string.format('game.%s:%s(%s)', self:GetFullName(), method, argString)
            
            -- Chỉ hiện lệnh nếu nó có chứa thông tin (không phải lệnh trống)
            if #argString > 0 then
                warn("📍 PHÁT HIỆN TƯƠNG TÁC VÙNG 📍")
                print("📦 Path: " .. self:GetFullName())
                print("🚀 LỆNH: " .. finalCmd)
                print("------------------------------------------")
                if setclipboard then setclipboard(finalCmd) end
            end
        end)
    end
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)
