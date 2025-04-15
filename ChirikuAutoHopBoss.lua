-- Boss Hop Ultimate | By Chiriku Roblox
repeat wait() until game:IsLoaded()

-- Auto chọn team
getgenv().Team = "Marines" -- hoặc "Pirates"

spawn(function()
    pcall(function()
        repeat wait() until game:GetService("Players").LocalPlayer.Team ~= nil or game:GetService("ReplicatedStorage"):FindFirstChild("Team")
        wait(1)
        if game:GetService("Players").LocalPlayer.Team == nil then
            for i,v in pairs(game:GetService("Workspace").Camera:GetChildren()) do
                if v:FindFirstChild("ChooseTeam") then
                    local args = {[1] = getgenv().Team}
                    game:GetService("ReplicatedStorage").Remotes["ChooseTeam"]:InvokeServer(unpack(args))
                end
            end
        end
    end)
end)

-- UI giống Banana Cat
local CoreGui = game:GetService("CoreGui")
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "BananaCatUI"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

local ToggleButton = Instance.new("ImageButton", ScreenGui)
ToggleButton.Name = "OpenUI"
ToggleButton.Size = UDim2.new(0, 60, 0, 60)
ToggleButton.Position = UDim2.new(0, 10, 0, 200)
ToggleButton.Image = "rbxassetid://16763867033" -- logo Banana Cat
ToggleButton.BackgroundTransparency = 1

local UI = Instance.new("Frame", ScreenGui)
UI.Name = "MainUI"
UI.Size = UDim2.new(0, 250, 0, 400)
UI.Position = UDim2.new(0, 80, 0, 100)
UI.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
UI.Visible = false
UI.BorderSizePixel = 0

local UITitle = Instance.new("TextLabel", UI)
UITitle.Size = UDim2.new(1, 0, 0, 40)
UITitle.Text = "Banana Cat Clone Hub"
UITitle.TextColor3 = Color3.fromRGB(255, 255, 255)
UITitle.TextSize = 18
UITitle.BackgroundTransparency = 1
UITitle.TextAlign = Enum.TextXAlignment.Center
UITitle.TextStrokeTransparency = 0.8

local BossSelection = Instance.new("Frame", UI)
BossSelection.Size = UDim2.new(1, 0, 0, 120)
BossSelection.Position = UDim2.new(0, 0, 0, 40)
BossSelection.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
BossSelection.BorderSizePixel = 0

local BossLabel = Instance.new("TextLabel", BossSelection)
BossLabel.Size = UDim2.new(0, 100, 1, 0)
BossLabel.Text = "Chọn Boss"
BossLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
BossLabel.TextSize = 14
BossLabel.TextAlign = Enum.TextXAlignment.Center
BossLabel.BackgroundTransparency = 1

local BossButton1 = Instance.new("TextButton", BossSelection)
BossButton1.Size = UDim2.new(0, 150, 1, 0)
BossButton1.Position = UDim2.new(0, 100, 0, 0)
BossButton1.Text = "Dough King"
BossButton1.TextColor3 = Color3.fromRGB(255, 255, 255)
BossButton1.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
BossButton1.TextSize = 14
BossButton1.BorderSizePixel = 0

local BossButton2 = Instance.new("TextButton", BossSelection)
BossButton2.Size = UDim2.new(0, 150, 1, 0)
BossButton2.Position = UDim2.new(0, 100, 0, 0)
BossButton2.Text = "Rip Indra"
BossButton2.TextColor3 = Color3.fromRGB(255, 255, 255)
BossButton2.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
BossButton2.TextSize = 14
BossButton2.BorderSizePixel = 0

local BossButton3 = Instance.new("TextButton", BossSelection)
BossButton3.Size = UDim2.new(0, 150, 1, 0)
BossButton3.Position = UDim2.new(0, 100, 0, 0)
BossButton3.Text = "Soul Reaper"
BossButton3.TextColor3 = Color3.fromRGB(255, 255, 255)
BossButton3.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
BossButton3.TextSize = 14
BossButton3.BorderSizePixel = 0

local BossButton4 = Instance.new("TextButton", BossSelection)
BossButton4.Size = UDim2.new(0, 150, 1, 0)
BossButton4.Position = UDim2.new(0, 100, 0, 0)
BossButton4.Text = "Dark Beard"
BossButton4.TextColor3 = Color3.fromRGB(255, 255, 255)
BossButton4.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
BossButton4.TextSize = 14
BossButton4.BorderSizePixel = 0

-- Thông báo giới thiệu
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Boss Hop Hub",
    Text = "By Chiriku Roblox - Full Auto Boss + Team + Logo UI",
    Duration = 7
})

-- Khai báo
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")

local PlaceId = game.PlaceId
local Sea = (PlaceId == 7449423635 and 3) or (PlaceId == 4442272183 and 2) or 1

getgenv().AutoHopBoss = {
    DoughKing = false,
    RipIndra = false,
    SoulReaper = false,
    DarkBeard = false,
}

getgenv().AutoGetItems = {
    GodChalice = true,
    HallowEssence = true,
    CakeChalice = true
}

-- Notify
local function Notify(txt)
    StarterGui:SetCore("SendNotification", {
        Title = "Thông báo",
        Text = txt,
        Duration = 4,
    })
end

-- Server hop
local function HopServer()
    local servers = {}
    local req = game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
    local decoded = HttpService:JSONDecode(req)
    for _, v in pairs(decoded.data) do
        if v.playing < v.maxPlayers and v.id ~= game.JobId then
            table.insert(servers, v.id)
        end
    end
    if #servers > 0 then
        TeleportService:TeleportToPlaceInstance(PlaceId, servers[math.random(1, #servers)], LocalPlayer)
    end
end

-- Tìm boss
local function FindBoss(name)
    for _, mob in pairs(Workspace.Enemies:GetChildren()) do
        if string.find(mob.Name, name) then
            return mob
        end
    end
end

-- Đi qua cổng dịch chuyển (nếu có)
local function UsePortal(boss)
    local portals = {}
    for _, portal in pairs(Workspace:GetChildren()) do
        if portal:IsA("Model") and portal.Name == "Portal" then
            table.insert(portals, portal)
        end
    end
    if #portals > 0 then
        local closestPortal = portals[1]
        local minDist = (LocalPlayer.Character.HumanoidRootPart.Position - closestPortal.Position).magnitude
        for _, portal in pairs(portals) do
            local dist = (LocalPlayer.Character.HumanoidRootPart.Position - portal.Position).magnitude
            if dist < minDist then
                closestPortal = portal
                minDist = dist
            end
        end
        if closestPortal then
            LocalPlayer.Character.HumanoidRootPart.CFrame = closestPortal.CFrame
        end
    end
end

-- Bay nhanh đến boss
local function FlyToBoss(boss)
    spawn(function()
        pcall(function()
            local speed = 500  -- Tăng tốc độ bay
            while boss and boss:FindFirstChild("HumanoidRootPart") do
                local dist = (LocalPlayer.Character.HumanoidRootPart.Position - boss.HumanoidRootPart.Position).magnitude
                if dist > 50 then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame:Lerp(boss.HumanoidRootPart.CFrame, speed * 0.1)
                else
                    break
                end
                wait(0.1)
            end
        end)
    end)
end

-- Đánh boss
local function AttackBoss(boss)
    spawn(function()
        pcall(function()
            repeat wait()
                if boss and boss:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = boss.HumanoidRootPart.CFrame * CFrame.new(0, 25, 0)
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, "Z", false, game)
                    game:GetService("VirtualInputManager"):SendKeyEvent(false, "Z", false, game)
                end
            until not boss or boss.Humanoid.Health <= 0
        end)
    end)
end

-- Vòng lặp boss
local function BossLoop()
    while wait(6) do
        if getgenv().AutoHopBoss.DoughKing then
            local boss = FindBoss("Dough King")
            if boss then
                Notify("Dough King xuất hiện!")
                UsePortal(boss) -- Đi qua cổng dịch chuyển nếu có
                FlyToBoss(boss)
                AttackBoss(boss)
            else
                HopServer()
            end
        end
        if getgenv().AutoHopBoss.RipIndra then
            local boss = FindBoss("rip_indra")
            if boss then
                Notify("Rip Indra xuất hiện!")
                UsePortal(boss) -- Đi qua cổng dịch chuyển nếu có
                FlyToBoss(boss)
                AttackBoss(boss)
            else
                HopServer()
            end
        end
        if getgenv().AutoHopBoss.SoulReaper then
            local boss = FindBoss("Soul Reaper")
            if boss then
                Notify("Soul Reaper xuất hiện!")
                FlyToBoss(boss)
                AttackBoss(boss)
            else
                HopServer()
            end
        end
        if getgenv().AutoHopBoss.DarkBeard then
            local boss = FindBoss("Darkbeard")
            if boss then
                Notify("Dark Beard xuất hiện!")
                FlyToBoss(boss)
                AttackBoss(boss)
            else
                HopServer()
            end
        end
    end
end

-- UI toggle mở/tắt
ToggleButton.MouseButton1Click:Connect(function()
    UI.Visible = not UI.Visible
end)

-- Xử lý lựa chọn boss
BossButton1.MouseButton1Click:Connect(function()
    getgenv().AutoHopBoss.DoughKing = true
    Notify("Đã chọn Dough King!")
end)

BossButton2.MouseButton1Click:Connect(function()
    getgenv().AutoHopBoss.RipIndra = true
    Notify("Đã chọn Rip Indra!")
end)

BossButton3.MouseButton1Click:Connect(function()
    getgenv().AutoHopBoss.SoulReaper = true
    Notify("Đã chọn Soul Reaper!")
end)

BossButton4.MouseButton1Click:Connect(function()
    getgenv().AutoHopBoss.DarkBeard = true
    Notify("Đã chọn Dark Beard!")
end)

-- Chạy vòng lặp boss
BossLoop()
