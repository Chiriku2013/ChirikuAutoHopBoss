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

-- Toggle UI bằng nút ảnh
local CoreGui = game:GetService("CoreGui")
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "ToggleLogoUI"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

local ToggleButton = Instance.new("ImageButton", ScreenGui)
ToggleButton.Name = "OpenUI"
ToggleButton.Size = UDim2.new(0, 60, 0, 60)
ToggleButton.Position = UDim2.new(0, 10, 0, 200)
ToggleButton.Image = "rbxassetid://16763867033" -- logo Banana Cat
ToggleButton.BackgroundTransparency = 1

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
            if boss then Notify("Dough King xuất hiện!") AttackBoss(boss) else HopServer() end
        end
        if getgenv().AutoHopBoss.RipIndra then
            local boss = FindBoss("rip_indra")
            if boss then Notify("Rip Indra xuất hiện!") AttackBoss(boss) else HopServer() end
        end
        if getgenv().AutoHopBoss.SoulReaper then
            local boss = FindBoss("Soul Reaper")
            if boss then Notify("Soul Reaper xuất hiện!") AttackBoss(boss) else HopServer() end
        end
        if getgenv().AutoHopBoss.DarkBeard then
            local boss = FindBoss("Darkbeard")
            if boss then Notify("Dark Beard xuất hiện!") AttackBoss(boss) else HopServer() end
        end
    end
end

-- Nhặt vật phẩm mở boss
spawn(function()
    while wait(10) do
        if Sea == 3 then
            for _, v in pairs(Workspace:GetChildren()) do
                if v:IsA("Tool") then
                    if v.Name == "God Chalice" and getgenv().AutoGetItems.GodChalice then
                        fireclickdetector(v:FindFirstChildWhichIsA("ClickDetector"))
                        Notify("Nhặt God Chalice!")
                    end
                    if v.Name == "Hallow Essence" and getgenv().AutoGetItems.HallowEssence then
                        fireclickdetector(v:FindFirstChildWhichIsA("ClickDetector"))
                        Notify("Nhặt Hallow Essence!")
                    end
                    if v.Name == "Cake Chalice" and getgenv().AutoGetItems.CakeChalice then
                        fireclickdetector(v:FindFirstChildWhichIsA("ClickDetector"))
                        Notify("Nhặt Cake Chalice!")
                    end
                end
            end
        end
    end
end)

-- UI chính
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Boss Hop | Chiriku", "Midnight")

local isUIVisible = true
ToggleButton.MouseButton1Click:Connect(function()
    isUIVisible = not isUIVisible
    for _, v in pairs(CoreGui:GetChildren()) do
        if v.Name == "KavoUI" then
            v.Enabled = isUIVisible
        end
    end
end)

local Tab = Window:NewTab("Auto Boss")
local Section = Tab:NewSection("Chọn Boss để Auto Hop")

Section:NewToggle("Dough King (Sea 3)", "Auto Hop & Kill", function(state)
    getgenv().AutoHopBoss.DoughKing = state
end)
Section:NewToggle("Rip Indra (Sea 3)", "Auto Hop & Kill", function(state)
    getgenv().AutoHopBoss.RipIndra = state
end)
Section:NewToggle("Soul Reaper (Sea 3)", "Auto Hop & Kill", function(state)
    getgenv().AutoHopBoss.SoulReaper = state
end)
Section:NewToggle("Dark Beard (Sea 2)", "Auto Hop & Kill", function(state)
    getgenv().AutoHopBoss.DarkBeard = state
end)

-- Chạy
spawn(BossLoop)
