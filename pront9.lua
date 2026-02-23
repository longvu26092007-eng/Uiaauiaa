-- ======================================================================
-- REMOTE SPY V12.4 - SERVER BROWSER & REFRESH SNIPER
-- Chuyên trị: Lệnh lấy danh sách Server, JobId và lệnh Refresh list.
-- ======================================================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")

if rconsolestatus then rconsolestatus("SERVER SNIPER - BY GEMINI") end
if rconsoleclear then rconsoleclear() end

print("====================================================")
print("🛰️ [V12.4] BROWSER & REFRESH SNIPER - ACTIVE")
print("👉 Hãy bấm Icon Server Browser hoặc Refresh trong game.")
print("👉 Script sẽ bắt cả Lệnh Gửi Đi và Dữ Liệu Trả Về.")
print("====================================================")

-- Hàm giải mã Table chuẩn Vũ Nguyễn
local function TableToString(t, indent)
    if type(t) ~= "table" then return tostring(t) end
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

local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    local response = oldNamecall(self, ...) -- Lấy dữ liệu trả về từ Server

    if (method == "InvokeServer" or method == "FireServer") then
        local remoteName = tostring(self.Name):lower()
        local searchTerms = {"server", "browser", "refresh", "list", "get", "page"}
        local isMatch = false

        for _, term in pairs(searchTerms) do
            if remoteName:find(term) then isMatch = true break end
        end

        if isMatch then
            task.spawn(function()
                warn("📡 [DETECTION] PHÁT HIỆN CALL SERVER BROWSER 📡")
                print("🕹️ Remote Name: " .. self.Name)
                print("📩 Lệnh gửi đi: ")
                print(TableToString(args))
                
                -- ĐÂY LÀ PHẦN QUAN TRỌNG: Dữ liệu Server trả về (Danh sách ID Server)
                if response then
                    print("📥 Dữ liệu Server trả về (Return Value):")
                    print("------------------------------------------")
                    print(TableToString(response))
                    print("------------------------------------------")
                end
                
                -- Tự động lưu lệnh gửi đi vào Clipboard để Vũ test
                if setclipboard then 
                    local cmd = string.format('game:GetService("ReplicatedStorage").%s:%s(unpack(%s))', self.Name, method, TableToString(args))
                    -- Lưu ý: Cậu cần chỉnh lại đường dẫn Net chuẩn nếu game dùng Modules/Net
                    setclipboard(cmd) 
                end
            end)
        end
    end

    return response
end)

setreadonly(mt, true)
