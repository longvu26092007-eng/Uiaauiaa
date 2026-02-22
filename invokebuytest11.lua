-- Cách viết này gộp cả ý tưởng từ file cậu gửi và Log thực tế
local function SilentCraftV13()
    -- Tự tìm Remote "Craft" dù nó nằm ở bất cứ đâu trong ReplicatedStorage
    local CraftRF = game:GetService("ReplicatedStorage"):FindFirstChild("Craft", true) 
    local JobsRF = game:GetService("ReplicatedStorage"):FindFirstChild("JobsRemoteFunction", true)

    if CraftRF and JobsRF then
        -- Gửi chuỗi lệnh chuẩn 100% từ Log của cậu
        task.spawn(function()
            JobsRF:InvokeServer("FishingNPC", "Bait", "Check", "Fisherman")
            task.wait(0.1)
            CraftRF:InvokeServer("Check", "Basic Bait")
            task.wait(0.1)
            CraftRF:InvokeServer("Craft", "Basic Bait", nil)
        end)
        return "Đã gửi lệnh thành công!"
    else
        return "Lỗi: Không tìm thấy cửa ngõ RF!"
    end
end
