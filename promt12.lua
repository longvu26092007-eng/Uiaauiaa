-- ======================================================================
-- REMOTE SPY V13.3 - CHUYÊN TRỊ VÙNG TƯƠNG TÁC (NPC/AREA)
-- Tối ưu: Bắt ProximityPrompt & Remote ẩn không tên
-- ======================================================================

local ProximityPromptService = game:GetService("ProximityPromptService")
if rconsoleclear then rconsoleclear() end

print("====================================================")
print("🚀 [V13.3] AREA SCANNER - ĐÃ KÍCH HOẠT")
print("👉 Vũ hãy đi vào vùng tương tác, thực hiện hành động.")
print("👉 Script sẽ bắt cả ProximityPrompt và Remote ẩn.")
print("====================================================")

-- Hàm giải mã Table sâu (Deep Decoder)
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

-- Bắt sự kiện ProximityPrompt (Các nút E hiện lên trong vùng)
ProximityPromptService.PromptButtonHoldFinished:Connect(function(prompt)
    warn("🎯 VŨ VỪA TƯƠNG TÁC NÚT (Prompt): " .. prompt.Name)
    print("📍 Object: " .. prompt.Parent:GetFullName())
end)

local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if (method == "InvokeServer" or method == "FireServer") then
        local remoteName = tostring(self.Name):lower()
        
        -- Mở rộng Blacklist để tránh spam lệnh di chuyển/hệ thống
        local blackList = {"move", "dash", "look", "heartbeat", "checkpatch", "setspawn", "requestfruit"}
        for _, word in pairs(blackList) do
            if remoteName:find(word) then return oldNamecall(self, ...) end
        end

        task.spawn(function()
            local out = {}
            local isSpecial = false
            for i, v in pairs(args) do
                local strVal = tostring(v):lower()
                -- Tìm các từ khóa quan trọng trong tham số (Args)
                if strVal:find("dragon") or strVal:find("race") or strVal:find("v2") or strVal:find("v3") or strVal:find("draco") then
                    isSpecial = true
                end
                
                if type(v) == "table" then table.insert(out, DeepTable(v))
                elseif type(v) == "string" then table.insert(out, '"' .. v .. '"')
                else table.insert(out, tostring(v)) end
            end
            
            local argString = table.concat(out, ", ")
            local finalCmd = string.format('game.%s:%s(%s)', self:GetFullName(), method, argString)
            
            -- Hiện lệnh nếu chứa từ khóa hoặc có dữ liệu đặc biệt
            if isSpecial or (#argString > 5 and not remoteName:find("event")) then
                warn("📍 PHÁT HIỆN LỆNH TỪ VÙNG INTERACT 📍")
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
