-- ======================================================================
-- DRACO HUNTER V17.2 - KAITUNBOSS HOP (Y HỆT)
-- ======================================================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService   = game:GetService("TeleportService")
local Players           = game:GetService("Players")
local StarterGui        = game:GetService("StarterGui")
local GuiService        = game:GetService("GuiService")

local LocalPlayer = Players.LocalPlayer
local PlaceId     = game.PlaceId
local JobId       = game.JobId

-- ==========================================
-- HOP SERVER (Y HỆT KAITUNBOSS)
-- ==========================================
local function IfTableHaveIndex(j)
    for _ in j do
        return true
    end
end

local LastServersDataPulled, CachedServers
local function GetServers()
    if LastServersDataPulled then
        if os.time() - LastServersDataPulled < 60 then
            return CachedServers
        end
    end

    for i = 1, 100, 1 do
        local data = game:GetService("ReplicatedStorage"):WaitForChild("__ServerBrowser"):InvokeServer(i)
        if IfTableHaveIndex(data) then
            LastServersDataPulled = os.time()
            CachedServers = data
            return data
        end
    end
end

local HopServer = function(Reason, MaxPlayers, ForcedRegion)
    local Servers = GetServers()
    local ArrayServers = {}

    for i, v in Servers do
        table.insert(ArrayServers, {
            JobId = i,
            Players = v.Count,
            LastUpdate = v.__LastUpdate,
            Region = v.Region
        })
    end
    print(#ArrayServers, 'servers received')
    local ServerData
    for i = 1, #ArrayServers do
        while task.wait() do
            local Index = math.random(1, #ArrayServers)
            ServerData = ArrayServers[Index]
            if ServerData then
                if not MaxPlayers or ServerData.Players < 5 then
                    if not ForcedRegion or ServerData.Regoin == ForcedRegion then
                        print("Found Server:", ServerData.JobId, 'Player Count:', ServerData.Players, "Region:",
                            ServerData.Region)
                        break
                    end
                end
            end
        end

        print('Teleporting to', ServerData.JobId, '...')
        game:GetService("ReplicatedStorage"):WaitForChild("__ServerBrowser"):InvokeServer('teleport', ServerData.JobId)
    end
end

-- ==========================================
-- ERROR HANDLING (Y HỆT KAITUNBOSS)
-- ==========================================
TeleportService.TeleportInitFailed:Connect(function(player, teleportResult, message)
    if teleportResult == Enum.TeleportResult.GameFull then inHopPP = false
    elseif teleportResult == Enum.TeleportResult.IsTeleporting and (message:find("previous teleport")) then
        StarterGui:SetCore("SendNotification", {Title = "Death Hop Found", Text = message, Duration = 8})
        task.delay(10, function() game:Shutdown() end)
    end
end)

GuiService.ErrorMessageChanged:Connect(newcclosure(function()
    if GuiService:GetErrorType() == Enum.ConnectionError.DisconnectErrors then
        while true do TeleportService:TeleportToPlaceInstance(PlaceId, JobId, LocalPlayer) task.wait(5) end
    end
end))

-- ==========================================
-- THỰC THI
-- ==========================================
HopServer()
