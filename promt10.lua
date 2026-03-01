-- ======================================================================
-- REMOTE SPY V13.0 - DIALOG & NPC SNIFFER (PHIÊN BẢN VŨ NPC)
-- Tối ưu: Bắt mọi Remote khi bấm nút Archive/Training/Speak/Learn
-- ======================================================================

if rconsolestatus then rconsolestatus("NPC SNIFFER - BY GEMINI") end
local UIS = game:GetService("UserInputService")

print("====================================================")
print("🚀 [V13.0] NPC SNIFFER - ĐÃ SẴN SÀNG")
print("👉 Vũ chỉ cần bấm các nút: Archive, Training, v.v.")
print("👉 Script sẽ tự lọc các lệnh liên quan đến Hội thoại/NPC.")
print("====================================================")

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

local function FormatArgs(args)
    local out = {}
    for i, v in pairs(args) do
        if type(v) == "table" then table.insert(out, TableToString(v))
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
    
    if (method == "InvokeServer" or method == "FireServer") then
        local isTarget = false
        local checkKeywords = {"archive", "training", "speak", "learn", "race", "draco", "dragon", "npc", "dialog"}
        
        -- 1. Kiểm tra tên Remote
        local nameLower = tostring(self.Name):lower()
        for _, k in pairs(checkKeywords) do
            if nameLower:find(k) then isTarget = true break end
        end
        
        -- 2. Kiểm tra nội dung Args (Quan trọng để bắt lệnh khi bấm nút)
        if not isTarget then
            for _, arg in pairs(args) do
                local strArg = typeof(arg) == "table" and TableToString(arg):lower() or tostring(arg):lower()
                for _, k in pairs(checkKeywords) do
                    if strArg:find(k) then isTarget = true break end
                end
                if isTarget then break end
            end
        end

        if isTarget then
            task.spawn(function()
                local argString = FormatArgs(args)
                local finalCmd = string.format('game.%s:%s(%s)', self:GetFullName(), method, argString)
                
                warn("🎯 PHÁT HIỆN TƯƠNG TÁC NPC 🎯")
                print("🐲 Remote: " .. self.Name)
                print("🚀 LỆNH CỦA VŨ:")
                print("------------------------------------------")
                print(finalCmd)
                print("------------------------------------------")
                if setclipboard then setclipboard(finalCmd) end
            end)
        end
    end
    return oldNamecall(self, ...)
end)

setreadonly(mt, true)
