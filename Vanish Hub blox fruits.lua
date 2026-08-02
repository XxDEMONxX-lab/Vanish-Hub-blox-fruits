--[[
    ====================================================
    VANISH HUB | BLOX FRUITS
    UI Library: Elerium UI Library V2
    Features: Auto Farm, Boss Farm, Fruit Gacha, Chest Farm,
              Auto Stats, World Teleports, ESP, Character Mods,
              and Integrated Anti-AFK
    ====================================================
--]]

-- Load Elerium UI Library
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/memejames/elerium-v2-ui-library/main/Library", true))()

-- Create Main Window
local window = library:AddWindow("Vanish Hub | Blox Fruits", {
    main_color = Color3.fromRGB(138, 43, 226), -- Signature Purple Theme
    min_size = Vector2.new(500, 380),
    toggle_key = Enum.KeyCode.RightControl,
    can_resize = true,
})

---------------------------------------------------------
-- FLOATING MINIMIZE / TOGGLE BUTTON GUI (PC & MOBILE)
---------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Name = "VanishHubMobileToggle"
ScreenGui.Parent = game:GetService("CoreGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
ToggleButton.BorderColor3 = Color3.fromRGB(138, 43, 226)
ToggleButton.Position = UDim2.new(0, 15, 0.4, 0)
ToggleButton.Size = UDim2.new(0, 110, 0, 38)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Text = "Vanish Hub"
ToggleButton.TextColor3 = Color3.fromRGB(138, 43, 226)
ToggleButton.TextSize = 15.000
ToggleButton.Active = true
ToggleButton.Draggable = true

UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = ToggleButton

-- Minimize/Maximize Trigger
ToggleButton.MouseButton1Click:Connect(function()
    local vim = game:GetService("VirtualInputManager")
    vim:SendKeyEvent(true, Enum.KeyCode.RightControl, false, game)
    vim:SendKeyEvent(false, Enum.KeyCode.RightControl, false, game)
end)

---------------------------------------------------------
-- GLOBAL VARIABLES & SERVICES
---------------------------------------------------------
_G.AutoFarmLevel = false
_G.AutoFastAttack = false
_G.AutoCollectFruits = false
_G.AutoChestFarm = false
_G.AutoBossFarm = false
_G.AutoStoreFruits = false
_G.AutoBusoHaki = false

_G.AutoStatsMelee = false
_G.AutoStatsDefense = false
_G.AutoStatsSword = false
_G.AutoStatsGun = false
_G.AutoStatsFruit = false

_G.PlayerESP = false
_G.FruitESP = false
_G.ChestESP = false

_G.InfiniteEnergy = false
_G.NoClip = false
_G.InfiniteJump = false
_G.WaterWalk = false
_G.FullBright = false

_G.SelectedIsland = "Starter Island"
_G.SelectedBoss = "Gorilla King"

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

---------------------------------------------------------
-- TAB 1: MAIN / FARMING
---------------------------------------------------------
local MainTab = window:AddTab("Main / Farm")
MainTab:Show() -- Default open tab

MainTab:AddLabel("--- Auto Farming & Combat ---")

MainTab:AddSwitch("Auto Farm Level", function(bool)
    _G.AutoFarmLevel = bool
end)

MainTab:AddSwitch("Fast Attack", function(bool)
    _G.AutoFastAttack = bool
end)

MainTab:AddSwitch("Auto Chest Farm", function(bool)
    _G.AutoChestFarm = bool
end)

MainTab:AddSwitch("Auto Collect Dropped Fruits", function(bool)
    _G.AutoCollectFruits = bool
end)

MainTab:AddSwitch("Auto Enable Buso Haki", function(bool)
    _G.AutoBusoHaki = bool
end)

MainTab:AddButton("Bring Nearest Enemies", function()
    pcall(function()
        local myPos = LocalPlayer.Character.HumanoidRootPart.Position
        for _, enemy in pairs(workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                if (enemy.HumanoidRootPart.Position - myPos).Magnitude < 300 then
                    enemy.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
                end
            end
        end
    end)
end)

---------------------------------------------------------
-- TAB 2: BOSS & FRUIT UTILITIES
---------------------------------------------------------
local BossTab = window:AddTab("Boss & Fruits")
BossTab:AddLabel("--- Boss Farming & Fruit Actions ---")

local bossDropdown = BossTab:AddDropdown("Select Boss", function(text)
    _G.SelectedBoss = text
end)

local bossList = {"Gorilla King", "Bobby", "Yeti", "Vice Admiral", "Swann", "Magma Admiral", "Fishman Lord", "Wysper", "Thunder God", "Cyborg"}
for _, b in ipairs(bossList) do
    bossDropdown:Add(b)
end

BossTab:AddSwitch("Auto Farm Selected Boss", function(bool)
    _G.AutoBossFarm = bool
end)

BossTab:AddSwitch("Auto Store Fruits in Inventory", function(bool)
    _G.AutoStoreFruits = bool
end)

BossTab:AddButton("Buy Random Fruit (Gacha)", function()
    pcall(function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("Cousin", "Buy")
    end)
end)

---------------------------------------------------------
-- TAB 3: AUTO STATS
---------------------------------------------------------
local StatsTab = window:AddTab("Auto Stats")
StatsTab:AddLabel("--- Auto Allocate Points ---")

StatsTab:AddSwitch("Auto Melee", function(bool)
    _G.AutoStatsMelee = bool
end)

StatsTab:AddSwitch("Auto Defense", function(bool)
    _G.AutoStatsDefense = bool
end)

StatsTab:AddSwitch("Auto Sword", function(bool)
    _G.AutoStatsSword = bool
end)

StatsTab:AddSwitch("Auto Gun", function(bool)
    _G.AutoStatsGun = bool
end)

StatsTab:AddSwitch("Auto Blox Fruit", function(bool)
    _G.AutoStatsFruit = bool
end)

---------------------------------------------------------
-- TAB 4: TELEPORTS
---------------------------------------------------------
local TeleportTab = window:AddTab("Teleports")
TeleportTab:AddLabel("--- Island & World Teleports ---")

local islandLocations = {
    ["Starter Island"] = Vector3.new(1089, 16, 1402),
    ["Jungle"] = Vector3.new(-1612, 36, 148),
    ["Pirate Village"] = Vector3.new(-1182, 4, 3843),
    ["Desert"] = Vector3.new(1094, 6, 4192),
    ["Middle Town"] = Vector3.new(-690, 15, 1582),
    ["Marine Ford"] = Vector3.new(-4915, 20, 4260),
    ["Skypiea"] = Vector3.new(-4832, 717, -2622),
    ["Colosseum"] = Vector3.new(-1428, 7, -2792),
    ["Magma Village"] = Vector3.new(-5242, 8, 8527),
    ["Underwater City"] = Vector3.new(61163, 11, 1819),
    ["Fountain City"] = Vector3.new(5258, 38, 4050)
}

local islandDropdown = TeleportTab:AddDropdown("Select Island", function(text)
    _G.SelectedIsland = text
end)

for name, _ in pairs(islandLocations) do
    islandDropdown:Add(name)
end

TeleportTab:AddButton("Teleport to Selected Island", function()
    if islandLocations[_G.SelectedIsland] and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(islandLocations[_G.SelectedIsland])
    end
end)

TeleportTab:AddButton("Teleport to First Sea", function()
    ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelMain")
end)

TeleportTab:AddButton("Teleport to Second Sea", function()
    ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelDressrosa")
end)

TeleportTab:AddButton("Teleport to Third Sea", function()
    ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelZou")
end)

TeleportTab:AddButton("Safe Zone Sky Teleport", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 5000, 0)
    end
end)

---------------------------------------------------------
-- TAB 5: VISUALS & ESP
---------------------------------------------------------
local VisualsTab = window:AddTab("Visuals & ESP")
VisualsTab:AddLabel("--- World Vision & ESP ---")

VisualsTab:AddSwitch("Player ESP", function(bool)
    _G.PlayerESP = bool
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            if bool then
                local hl = Instance.new("Highlight")
                hl.Name = "VanishPlayerESP"
                hl.FillColor = Color3.fromRGB(138, 43, 226)
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.Parent = plr.Character
            else
                if plr.Character:FindFirstChild("VanishPlayerESP") then
                    plr.Character.VanishPlayerESP:Destroy()
                end
            end
        end
    end
end)

VisualsTab:AddSwitch("Fruit ESP", function(bool)
    _G.FruitESP = bool
    for _, item in pairs(workspace:GetChildren()) do
        if item:IsA("Tool") and string.find(item.Name, "Fruit") then
            if bool then
                local hl = Instance.new("Highlight")
                hl.Name = "VanishFruitESP"
                hl.FillColor = Color3.fromRGB(0, 255, 120)
                hl.Parent = item
            else
                if item:FindFirstChild("VanishFruitESP") then
                    item.VanishFruitESP:Destroy()
                end
            end
        end
    end
end)

VisualsTab:AddSwitch("Chest ESP", function(bool)
    _G.ChestESP = bool
    for _, chest in pairs(workspace:GetDescendants()) do
        if string.find(chest.Name, "Chest") and chest:IsA("BasePart") then
            if bool then
                local hl = Instance.new("Highlight")
                hl.Name = "VanishChestESP"
                hl.FillColor = Color3.fromRGB(255, 215, 0)
                hl.Parent = chest
            else
                if chest:FindFirstChild("VanishChestESP") then
                    chest.VanishChestESP:Destroy()
                end
            end
        end
    end
end)

VisualsTab:AddSwitch("FullBright", function(bool)
    _G.FullBright = bool
    if bool then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    else
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
    end
end)

VisualsTab:AddButton("Remove Fog", function()
    Lighting.FogEnd = 9e9
    for _, v in pairs(Lighting:GetChildren()) do
        if v:IsA("Atmosphere") or v:IsA("PostEffect") then
            v:Destroy()
        end
    end
end)

---------------------------------------------------------
-- TAB 6: PLAYER MODS & MOVEMENT
---------------------------------------------------------
local MiscTab = window:AddTab("Player Mods")
MiscTab:AddLabel("--- Character Modifiers ---")

local walkSlider = MiscTab:AddSlider("WalkSpeed", function(v)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = v
    end
end, { ["min"] = 16, ["max"] = 350 })
walkSlider:Set(16)

local jumpSlider = MiscTab:AddSlider("JumpPower", function(v)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = v
    end
end, { ["min"] = 50, ["max"] = 300 })
jumpSlider:Set(50)

MiscTab:AddSwitch("Infinite Energy", function(bool)
    _G.InfiniteEnergy = bool
end)

MiscTab:AddSwitch("NoClip", function(bool)
    _G.NoClip = bool
end)

MiscTab:AddSwitch("Infinite Jump", function(bool)
    _G.InfiniteJump = bool
end)

MiscTab:AddSwitch("Water Walk", function(bool)
    _G.WaterWalk = bool
    if workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("WaterBoundary") then
        workspace.Map.WaterBoundary.CanCollide = bool
    end
end)

---------------------------------------------------------
-- TAB 7: UTILITIES & ANTI-AFK
---------------------------------------------------------
local UtilityTab = window:AddTab("Utility & Anti-AFK")
UtilityTab:AddLabel("--- Anti-AFK & Server Tools ---")

-- Dedicated button loading your specific Anti-AFK repository script
UtilityTab:AddButton("Execute Vanish Hub Anti-AFK", function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XxDEMONxX-lab/Vanish-Hub-universel-anti-afk/refs/heads/main/Vanish%20Hub%20universel%20anti%20afk"))()
    end)
end)

UtilityTab:AddButton("FPS Boost (Lag Reducer)", function()
    pcall(function()
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and not v:IsA("MeshPart") then
                v.Material = Enum.Material.SmoothPlastic
            elseif v:IsA("Texture") or v:IsA("Decal") then
                v:Destroy()
            end
        end
    end)
end)

UtilityTab:AddButton("Rejoin Current Server", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
end)

UtilityTab:AddButton("Server Hop", function()
    local HttpService = game:GetService("HttpService")
    local TeleportService = game:GetService("TeleportService")
    local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/0?sortOrder=Asc&limit=100"))
    for _, s in pairs(servers.data) do
        if s.playing ~= s.maxPlayers and s.id ~= game.JobId then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
            break
        end
    end
end)

---------------------------------------------------------
-- LOOPS & BACKGROUND LOGIC
---------------------------------------------------------

-- Fast Attack Loop
task.spawn(function()
    while task.wait(0.1) do
        if _G.AutoFastAttack then
            pcall(function()
                local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool then
                    tool:Activate()
                end
            end)
        end
    end
end)

-- Auto Buso Haki Loop
task.spawn(function()
    while task.wait(2) do
        if _G.AutoBusoHaki and LocalPlayer.Character and not LocalPlayer.Character:FindFirstChild("HasBuso") then
            ReplicatedStorage.Remotes.CommF_:InvokeServer("HasBuso")
        end
    end
end)

-- Auto Chest Farm Loop
task.spawn(function()
    while task.wait(0.3) do
        if _G.AutoChestFarm then
            for _, chest in pairs(workspace:GetDescendants()) do
                if string.find(chest.Name, "Chest") and chest:IsA("BasePart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = chest.CFrame
                    task.wait(0.2)
                end
            end
        end
    end
end)

-- Auto Boss Farm Loop
task.spawn(function()
    while task.wait(0.5) do
        if _G.AutoBossFarm and _G.SelectedBoss then
            pcall(function()
                for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                    if enemy.Name == _G.SelectedBoss and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4)
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Store Fruits Loop
task.spawn(function()
    while task.wait(2) do
        if _G.AutoStoreFruits then
            pcall(function()
                for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
                    if string.find(tool.Name, "Fruit") then
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("StoreFruit", tool.Name, tool)
                    end
                end
            end)
        end
    end
end)

-- Auto Stats Loop
task.spawn(function()
    while task.wait(0.5) do
        if _G.AutoStatsMelee then
            ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Melee", 1)
        end
        if _G.AutoStatsDefense then
            ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Defense", 1)
        end
        if _G.AutoStatsSword then
            ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Sword", 1)
        end
        if _G.AutoStatsGun then
            ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Gun", 1)
        end
        if _G.AutoStatsFruit then
            ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Demon Fruit", 1)
        end
    end
end)

-- Infinite Energy Loop
task.spawn(function()
    while task.wait(0.5) do
        if _G.InfiniteEnergy and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Energy") then
            LocalPlayer.Character.Energy.Value = LocalPlayer.Character.Energy.MaxValue
        end
    end
end)

-- Infinite Jump Handling
UserInputService.JumpRequest:Connect(function()
    if _G.InfiniteJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- Noclip Loop
RunService.Stepped:Connect(function()
    if _G.NoClip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Auto Collect Dropped Fruit Loop
task.spawn(function()
    while task.wait(1) do
        if _G.AutoCollectFruits then
            for _, v in pairs(workspace:GetChildren()) do
                if v:IsA("Tool") and string.find(v.Name, "Fruit") then
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Handle") then
                        v.Handle.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
                    end
                end
            end
        end
    end
end)

print("Vanish Hub | Blox Fruits loaded successfully!")
