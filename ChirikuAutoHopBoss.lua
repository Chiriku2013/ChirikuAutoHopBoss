--// Chiriku Auto Hop Boss

-- Cấu hình ban đầu
getgenv().Mode = "TOTS" -- "rip_indra", "Dough King", "TOTS", "Soul Reaper", "Darkbeard"
getgenv().Team = "Marines"

repeat task.wait() until game:IsLoaded() and game.Players and game.Players.LocalPlayer and game.Players.LocalPlayer:FindFirstChild("PlayerGui")

-- Cấu hình boss và các tính năng cần thiết
local BossName = tostring(getgenv().Mode or "")
local AllowedBosses = {
    ["rip_indra"] = "rip_indra",
    ["Dough King"] = "Dough King",
    ["TOTS"] = "Tyrant Of The Skies", -- "TOTS" giờ là "Tyrant Of The Skies"
    ["Soul Reaper"] = "Soul Reaper",
    ["Darkbeard"] = "Darkbeard"
}

if not AllowedBosses[BossName] then
    warn("Sai tên boss! Phải là: rip_indra, Dough King, TOTS, Soul Reaper, Darkbeard")
    return
end

local TeamName = getgenv().Team or "Marines"
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local UsedServer = {}

-- Auto team
pcall(function()
    if Players.LocalPlayer.Team == nil then
        repeat
            task.wait(0.5)
            for i,v in pairs(Players.LocalPlayer.PlayerGui:GetChildren()) do
                if v:FindFirstChild("Team") then
                    for _,b in pairs(v.Team:GetChildren()) do
                        if b.Name == TeamName then
                            firetouchinterest(Players.LocalPlayer.Character.HumanoidRootPart, b, 0)
                            firetouchinterest(Players.LocalPlayer.Character.HumanoidRootPart, b, 1)
                        end
                    end
                end
            end
        until Players.LocalPlayer.Team and Players.LocalPlayer.Team.Name == TeamName
    end
end)

-- Anti AFK
pcall(function()
    local vu = game:GetService("VirtualUser")
    Players.LocalPlayer.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    end)
end)

-- Fast Attack
local function FastAttack()
    pcall(function()
        local plr = Players.LocalPlayer
        local Combat = require(plr.PlayerScripts.CombatFramework)
        local CombatFramework = debug.getupvalues(Combat)
        local CF = CombatFramework[2]
        local rig = CF.activeController
        if rig and rig.equipped then
            rig.timeToNextAttack = 0
            rig.humanoid.AutoRotate = false
            rig:attack()
        end
    end)
end

-- Tween tới boss
local function TweenTo(pos)
    local hrp = Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
    local ts = game:GetService("TweenService")
    local info = TweenInfo.new((hrp.Position - pos).Magnitude / 350, Enum.EasingStyle.Linear)
    local tween = ts:Create(hrp, info, {CFrame = CFrame.new(pos)})
    tween:Play()
    tween.Completed:Wait()
end

-- Tìm boss chính xác tên
local function FindExactBoss()
    for _,v in pairs(workspace.Enemies:GetChildren()) do
        if v.Name == AllowedBosses[BossName] and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            return v
        end
    end
    return nil
end

-- Đánh boss
local function KillBoss(boss)
    repeat task.wait()
        if boss and boss:FindFirstChild("HumanoidRootPart") and boss.Humanoid.Health > 0 then
            TweenTo(boss.HumanoidRootPart.Position + Vector3.new(0,20,0))
            FastAttack()
        end
    until not boss or boss.Humanoid.Health <= 0 or not boss:FindFirstChild("Humanoid")
end

-- Smart Hop
local function HopServer()
    local cursor = ""
    while true do
        local url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?limit=100"..(cursor ~= "" and "&cursor="..cursor or "")
        local success, result = pcall(function() return HttpService:JSONDecode(game:HttpGet(url)) end)
        if success then
            for _, server in pairs(result.data) do
                if server.playing < server.maxPlayers and not UsedServer[server.id] then
                    UsedServer[server.id] = true
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id)
                    return
                end
            end
            if result.nextPageCursor then
                cursor = result.nextPageCursor
            else
                break
            end
        else
            break
        end
    end
end

-- Main Loop
while true do
    task.wait(2)
    local boss = FindExactBoss()
    if boss then
        warn("Boss Found: "..boss.Name)
        KillBoss(boss)
    else
        warn("Boss not found, hopping...")
        HopServer()
        task.wait(7)
    end
end
