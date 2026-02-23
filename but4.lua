-- ======================================================================
-- REMOTE DEBUGGER V12.9 - REGION & PLAYER SNIPER
-- Ưu tiên: Region (Singapore) -> Số người (7) -> Auto Join
-- ======================================================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local targetCount = 7        -- Mốc người chơi cậu muốn
local targetRegion = "Singapore" -- Ưu tiên khu vực này (Sửa thành "United States", "Germany"... nếu muốn)
local isHopping = false

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
                warn("📡 [HUNTER] ĐANG LỌC SERVER: REGION [" .. targetRegion .. "] - PLAYERS [" .. targetCount .. "]")
                
                local bestJobId = nil
                local fallbackJobId = nil
                local minDiff = 100

                for jobId, info in pairs(response) do
                    -- Lấy dữ liệu pCount và pRegion từ table info cậu gửi
                    local pCount = 0
                    local pRegion = "Unknown"
                    
                    if type(info) == "table" then
                        pCount = tonumber(info.Count) or 0
                        pRegion = tostring(info.Region) or "Unknown"
                    end

                    -- Kiểm tra xem có phải server hiện tại không
                    if jobId ~= game.JobId and pCount > 0 then
                        
                        -- KIỂM TRA ĐIỀU KIỆN LÝ TƯỞNG: Đúng Region VÀ Đúng số người
                        if pRegion:find(targetRegion) and pCount == targetCount then
                            bestJobId = jobId
                            break -- Thấy server hoàn hảo thì dừng quét và nhảy luôn
                        end

                        -- LOGIC DỰ PHÒNG: Vẫn ưu tiên Region Singapore, nhưng số người gần mốc 7 nhất
                        if pRegion:find(targetRegion) then
                            local diff = math.abs(pCount - targetCount)
                            if diff < minDiff then
                                minDiff = diff
                                fallbackJobId = jobId
                            end
                        end
                    end
                end

                local finalId = bestJobId or fallbackJobId

                if finalId then
                    isHopping = true
                    warn("🚀 MỤC TIÊU ĐÃ XÁC ĐỊNH! ĐANG NHẢY...")
                    print("📍 Region: " .. targetRegion .. " | Target: " .. (bestJobId and targetCount or "Gần mốc 7"))
                    
                    pcall(function()
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, finalId, Players.LocalPlayer)
                    end)
                    
                    task.delay(10, function() isHopping = false end)
                else
                    warn("⏳ Không tìm thấy server nào ở " .. targetRegion .. " phù hợp. Hãy thử Refresh lại!")
                end
            end)
        end
    end

    return response
end)

setreadonly(mt, true)
