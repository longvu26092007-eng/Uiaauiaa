-- =========================================================
-- 🔥 REMOTE DEBUGGER PRO - SERVER BROWSER TRACKER
-- =========================================================

repeat task.wait() until game:IsLoaded()

local ReplicatedStorage = game:GetService("ReplicatedStorage")

print("====================================================")
print("🛰️ REMOTE DEBUGGER PRO - ACTIVE")
print("👉 Bấm Server Browser / Refresh để bắt nguồn")
print("====================================================")

-- =========================================================
-- 📦 Pretty print table
-- =========================================================
local function TableToString(t, indent)
    if type(t) ~= "table" then return tostring(t) end
    indent = indent or ""
    local s = "{\n"
    for k, v in pairs(t) do
        s = s .. indent .. "    [" .. tostring(k) .. "] = "
        if type(v) == "table" then
            s = s .. TableToString(v, indent .. "    ") .. ",\n"
        else
            s = s .. tostring(v) .. ",\n"
        end
    end
    return s .. indent .. "}"
end

-- =========================================================
-- 🔍 Scan ReplicatedStorage for suspicious remotes
-- =========================================================
task.spawn(function()
    task.wait(2)
    print("\n🔎 SCANNING REMOTES...")

    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            local name = v.Name:lower()

            if name:find("server")
            or name:find("browser")
            or name:find("refresh")
            or name:find("list")
            or name:find("page") then

                warn("📡 FOUND REMOTE:", v:GetFullName())
            end
        end
    end
end)

-- =========================================================
-- 🧠 Hook require() → biết module nào load
-- =========================================================
local oldRequire = require
getgenv().require = function(module)
    local ok, result = pcall(oldRequire, module)

    if typeof(module) == "Instance" then
        local name = module.Name:lower()

        if name:find("server")
        or name:find("browser")
        or name:find("list") then
            warn("📦 MODULE REQUIRED:", module:GetFullName())
        end
    end

    return result
end

-- =========================================================
-- 🚨 Hook __namecall
-- =========================================================
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    local response = oldNamecall(self, ...)

    if method == "InvokeServer" or method == "FireServer" then
        local remoteName = tostring(self.Name):lower()

        if remoteName:find("server")
        or remoteName:find("browser")
        or remoteName:find("refresh")
        or remoteName:find("list")
        or remoteName:find("page") then

            task.spawn(function()
                warn("🚨 SERVER BROWSER DETECTED")

                print("📍 Remote:", self:GetFullName())
                print("📩 Args:")
                print(TableToString(args))

                if response then
                    print("📥 Response:")
                    print(TableToString(response))
                end

                -- copy command
                if setclipboard then
                    local cmd = string.format(
                        '%s:%s(unpack(%s))',
                        self:GetFullName(),
                        method,
                        TableToString(args)
                    )
                    setclipboard(cmd)
                end
            end)
        end
    end

    return response
end)

setreadonly(mt, true)

print("✅ Debugger Ready.")
