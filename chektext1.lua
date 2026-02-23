-- ======================================================================
-- REMOTE DEBUGGER V13.0 - NPS (NETWORK PARAMETER SCANNER)
-- Chuyên trị: TextBox Search, Filter Region, String Arguments
-- ======================================================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")

if rconsolestatus then rconsolestatus("NPS DEBUGGER V13.0 - BY GEMINI") end
if rconsoleclear then rconsoleclear() end

print("====================================================")
print("🔍 [V13.0] NPS DEBUGGER - RÌNH RẬP SEARCH BOX")
print("👉 Hãy gõ 'Singapore' vào ô Search Region rồi nhấn Enter.")
print("👉 Script sẽ bắt chính xác lệnh Filter gửi lên Server.")
print("====================================================")

local function TableToString(t, indent)
    if type(t) ~= "table" then return tostring(t) end
    indent = indent or ""
    local s = "{\n"
    for k, v in pairs(t) do
        s = s .. indent .. "    [" .. (type(k) == "string" and '"'..k..'"' or k) .. "] = "
        if type(v) == "table" then
            s = s .. TableToString(v, indent .. "    ") .. ",\n"
        elseif type(v) == "string" then
            s = s .. '"' .. v .. '",\n' -- Bao chuỗi trong ngoặc kép để dễ nhìn
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

    -- Kiểm tra các Remote liên quan đến Server Browser
    if (method == "InvokeServer" or method == "FireServer") and self.Name == "__ServerBrowser" then
        task.spawn(function()
            local hasString = false
            local searchVal = ""
            
            -- Quét xem trong Args có cái chữ nào cậu vừa nhập không
            for _, arg in pairs(args) do
                if type(arg) == "string" then
                    hasString = true
                    searchVal = arg
                    break
                end
            end

            if hasString then
                warn("🎯 [DETECTED] LỆNH SEARCH/FILTER VỪA ĐƯỢC GỬI!")
                print("🕹️ Remote: " .. self.Name)
                print("⌨️ Nội dung cậu đã nhập: " .. searchVal)
                print("📩 Full Args (Dùng cái này để viết code Auto Search):")
                print(TableToString(args))
                
                -- Copy lệnh chuẩn vào Clipboard
                if setclipboard then
                    setclipboard(string.format('game:GetService("ReplicatedStorage").%s:%s(unpack(%s))', self.Name, method, TableToString(args)))
                end
            end
        end)
    end

    return response
end)

setreadonly(mt, true)
