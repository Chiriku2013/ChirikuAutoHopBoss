--// CONFIG
getgenv().Mode = getgenv().Mode or "rip_indra" -- rip_indra, Dough King, TOTS, Soul Reaper, Darkbeard
getgenv().Team = getgenv().Team or "Marines"

--// SERVICES
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local tpData = game:GetService("TeleportService"):GetLocalPlayerTeleportData()
local lp = Players.LocalPlayer
local hopCooldown, lastHop = 10, 0
local visited = {}

--// BOSS MAP
local BossMap = {
    ["TOTS"] = "Tyrant Of The Skies",
    ["rip_indra"] = "rip_indra",
    ["Dough King"] = "Dough King",
    ["Soul Reaper"] = "Soul Reaper",
    ["Darkbeard"] = "Darkbeard"
}
local BossName = BossMap[getgenv().Mode]

--// AUTO TEAM
pcall(function()
    if lp.Team == nil or lp.Team.Name ~= getgenv().Team then
        for _,v in pairs(game:GetService("Teams"):GetChildren()) do
            if v.Name == getgenv().Team then
                lp.Team = v
                lp:LoadCharacter()
            end
        end
    end
end)

--// HOP FUNCTION
function ServerHop()
    local servers = {}
    local req = game:HttpGet("https://games.roblox.com/v1/games/2753915549/servers/Public?limit=100")
    for _,v in pairs(HttpService:JSONDecode(req).data) do
        if type(v) == "table" and v.playing < v.maxPlayers and not visited[v.id] then
            table.insert(servers, v.id)
        end
    end
    if #servers > 0 then
        visited[servers[1]] = true
        TeleportService:TeleportToPlaceInstance(2753915549, servers[1], lp)
    end
end

--// CHECK BOSS EXIST
function GetBoss()
    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and v.Name == BossName then
            return v
        end
    end
end

--// AUTO BUSO + AUTO RACE
spawn(function()
    while task.wait(1) do
        pcall(function()
            if lp.Character then
                -- Buso
                if not lp.Character:FindFirstChild("HasBuso") and lp.Backpack:FindFirstChild("Buso") then
                    lp.Backpack.Buso:Activate()
                end
                -- Race skill
                for _,v in pairs({"Transform", "AwakeningSkill"}) do
                    local skill = lp.Backpack:FindFirstChild(v) or lp.Character:FindFirstChild(v)
                    if skill then skill:Activate() end
                end
            end
        end)
    end
end)

--// FAST ATTACK
spawn(function()
    local Vim = game:GetService("VirtualInputManager")
    while task.wait(0.1) do
        pcall(function()
            local char = lp.Character
            if not char then return end
            local tool = char:FindFirstChildOfClass("Tool")
            if tool and GetBoss() then
                Vim:SendMouseButton1Down()
                task.wait(0.05)
                Vim:SendMouseButton1Up()
            end
        end)
    end
end)

--// ATTACK BOSS
spawn(function()
    while task.wait() do
        pcall(function()
            local boss = GetBoss()
            if boss and boss:FindFirstChild("Humanoid") and boss:FindFirstChild("HumanoidRootPart") then
                local char = lp.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = boss.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
                end
            end
        end)
    end
end)

--// MAIN LOOP
spawn(function()
    while task.wait(5) do
        local boss = GetBoss()
        if not boss and tick() - lastHop > hopCooldown then
            lastHop = tick()
            ServerHop()
        end
    end
end)
