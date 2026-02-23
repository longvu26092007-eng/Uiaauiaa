-- ======================================================================
-- REMOTE DEBUGGER V12.8 - INSTANT SERVER HOPPER (TARGET: 7 PLAYERS)
-- Tính năng: Tự động bắt list server, quét JobId và Join ngay lập tức
-- ======================================================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local targetCount = 7 -- Mốc ưu tiên của cậu
local isHopping = false -- Chặn việc hop trùng lặp

local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    local response = oldNamecall(self, ...)

    -- 🔍 BẮT LỆNH: Khi bảng Server Browser trả về dữ liệu
    if (method == "InvokeServer" or method == "FireServer") and self.Name == "__ServerBrowser" then
        if response and type(response) == "table" and not isHopping then
            task.spawn(function()
                warn("📡 [SYSTEM] ĐANG QUÉT LIST SERVER ĐỂ TÌM MỐC " .. targetCount .. " NGƯỜI...")
                
                local bestJobId = nil
                local fallbackJobId = nil
                local minDiff = 100

                for jobId, info in pairs(response) do
                    local pCount = 0
                    if type(info) == "table" and info.Count then
                        pCount = tonumber(info.Count)
                    elseif type(info) == "number" then
                        pCount = info
                    end

                    -- Ưu tiên 1: Thấy server đúng 7 người
                    if jobId ~= game.JobId and pCount == targetCount then
                        bestJobId = jobId
                        break -- Thấy hàng ngon là dừng quét, vọt luôn
                    end

                    -- Ưu tiên 2: Server vắng (dưới 10 người) để làm phương án dự phòng
                    if jobId ~= game.JobId and pCount > 0 and pCount < 12 then
                        local diff = math.abs(pCount - targetCount)
                        if diff < minDiff then
                            minDiff = diff
                            fallbackJobId = jobId
                        end
                    end
                end

                local finalId = bestJobId or fallbackJobId

                if finalId then
                    isHopping = true
                    warn("🚀 ĐÃ TÌM THẤY! ĐANG NHẢY ĐẾN JOBID: " .. finalId)
                    print("📊 Số người tại server đó: " .. (bestJobId and targetCount or "Gần mốc 7"))
                    
                    -- Thực hiện Teleport
                    pcall(function()
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, finalId, Players.LocalPlayer)
                    end)
                    
                    -- Nếu sau 10s không hop được thì mở khóa để quét lại
                    task.delay(10, function() isHopping = false end)
                else
                    warn("⏳ Không tìm thấy server nào có " .. targetCount .. " người trong list này.")
                end
            end)
        end
    end

    return response
end)

setreadonly(mt, true)

print("✅ [V12.8] Hopper đã sẵn sàng! Cậu chỉ cần bấm vào icon Server Browser hoặc Refresh là nó tự vọt.")
