--[[
    ====================================================
    VANISH HUB | BLOX FRUITS (ACCURATE FIXED VERSION)
    UI Library: Elerium UI Library V2
    Credits: Made by XxDEMONxX
    ====================================================
--]]

-- Load Elerium UI Library
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/memejames/elerium-v2-ui-library/main/Library", true))()

-- Create Main Window
local window = library:AddWindow("Vanish Hub | Blox Fruits", {
    main_color = Color3.fromRGB(138, 43, 226),
    min_size = Vector2.new(520, 420),
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

ToggleButton.MouseButton1Click:Connect(function()
    local vim = game:GetService("VirtualInputManager")
    vim:SendKeyEvent(true, Enum.KeyCode.RightControl, false, game)
    vim:SendKeyEvent(false, Enum.KeyCode.RightControl, false, game)
end)

---------------------------------------------------------
-- GLOBAL ACCURATE VARIABLES & SERVICES
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

_G.WalkSpeedToggle = false
_G.WalkSpeedValue = 16
_G.JumpPowerToggle = false
_G.JumpPowerValue = 50

_G.SelectedIsland = "Starter Island"
_G.SelectedBoss = "Gorilla King"

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")

---------------------------------------------------------
-- ACCURATE TWEEN & HELPER FUNCTIONS
---------------------------------------------------------
local currentTween = nil

local function smoothMoveTo(targetCFrame, speed)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local distance = (hrp.Position - targetCFrame.Position).Magnitude
        if distance < 5 then return end -- already close
        local duration = distance / (speed or 250)
        
        if currentTween then
            currentTween:Cancel()
        end

        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
        currentTween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
        currentTween:Play()
        return currentTween
    end
end

local function autoEquipWeapon()
    pcall(function()
        if LocalPlayer.Character and not LocalPlayer.Character:FindFirstChildOfClass("Tool") then
            local backpack = LocalPlayer:FindFirstChild("Backpack")
            if backpack then
                local tool = backpack:FindFirstChildOfClass("Tool")
                if tool then
                    LocalPlayer.Character.Humanoid:EquipTool(tool)
                end
            end
        end
    end)
end

---------------------------------------------------------
-- TAB 1: MAIN / FARMING
---------------------------------------------------------
local MainTab = window:AddTab("Main / Farm")
MainTab:Show()

MainTab:AddLabel("--- Auto Farming & Combat ---")

MainTab:AddSwitch("Auto Farm Level", function(bool)
    _G.AutoFarmLevel = bool
    if not bool and currentTween then
        currentTween:Cancel()
    end
end)

MainTab:AddSwitch("Fast Attack (Auto Click)", function(bool)
    _G.AutoFastAttack = bool
end)

MainTab:AddSwitch("Auto Chest Farm (Accurate)", function(bool)
    _G.AutoChestFarm = bool
    if not bool and currentTween then
        currentTween:Cancel()
    end
end)

MainTab:AddSwitch("Auto Collect Fruits", function(bool)
    _G.AutoCollectFruits = bool
end)

MainTab:AddSwitch("Auto Enable Buso Haki", function(bool)
    _G.AutoBusoHaki = bool
end)

MainTab:AddButton("Bring Nearest Enemies", function()
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local myPos = LocalPlayer.Character.HumanoidRootPart.Position
            if workspace:FindFirstChild("Enemies") then
                for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                    if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                        if (enemy.HumanoidRootPart.Position - myPos).Magnitude < 350 then
                            enemy.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
                            enemy.HumanoidRootPart.CanCollide = false
                        end
                    end
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
    if not bool and currentTween then
        currentTween:Cancel()
    end
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
    if islandLocations[_G.SelectedIsland] then
        smoothMoveTo(CFrame.new(islandLocations[_G.SelectedIsland]), 300)
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
    smoothMoveTo(CFrame.new(0, 5000, 0), 300)
end)

---------------------------------------------------------
-- TAB 5: VISUALS & ESP
---------------------------------------------------------
local VisualsTab = window:AddTab("Visuals & ESP")
VisualsTab:AddLabel("--- World Vision & ESP ---")

VisualsTab:AddSwitch("Player ESP", function(bool)
    _G.PlayerESP = bool
end)

VisualsTab:AddSwitch("Fruit ESP", function(bool)
    _G.FruitESP = bool
end)

VisualsTab:AddSwitch("Chest ESP", function(bool)
    _G.ChestESP = bool
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
-- TAB 6: PLAYER MODS (ACCURATE SLIDABLE WALKSPEED & JUMPPOWER)
---------------------------------------------------------
local MiscTab = window:AddTab("Player Mods")
MiscTab:AddLabel("--- Character Modifiers ---")

MiscTab:AddSwitch("Enable Custom WalkSpeed", function(bool)
    _G.WalkSpeedToggle = bool
    if not bool and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)

local walkSlider = MiscTab:AddSlider("WalkSpeed Value", function(v)
    _G.WalkSpeedValue = tonumber(v) or 16
    if _G.WalkSpeedToggle and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = _G.WalkSpeedValue
    end
end, { ["min"] = 16, ["max"] = 350 })
walkSlider:Set(16)

MiscTab:AddSwitch("Enable Custom JumpPower", function(bool)
    _G.JumpPowerToggle = bool
    if not bool and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = 50
    end
end)

local jumpSlider = MiscTab:AddSlider("JumpPower Value", function(v)
    _G.JumpPowerValue = tonumber(v) or 50
    if _G.JumpPowerToggle and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.UseJumpPower = true
        LocalPlayer.Character.Humanoid.JumpPower = _G.JumpPowerValue
    end
end, { ["min"] = 50, ["max"] = 350 })
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
-- TAB 8: CREDITS
---------------------------------------------------------
local CreditsTab = window:AddTab("Credits")
CreditsTab:AddLabel("--- Vanish Hub Information ---")
CreditsTab:AddLabel("Made by: XxDEMONxX")
CreditsTab:AddLabel("UI Library: Elerium UI V2")
CreditsTab:AddLabel("Target Game: Blox Fruits")
CreditsTab:AddLabel("Version: 4.0 Accurate")

CreditsTab:AddButton("Copy Creator Name", function()
    if setclipboard then
        setclipboard("XxDEMONxX")
        print("Creator name copied to clipboard!")
    end
end)

---------------------------------------------------------
-- BACKGROUND LOOPS & ACCURATE REPEAT HANDLERS
---------------------------------------------------------

-- Continuous Speed & Jump Enforcement Loop
RunService.RenderStepped:Connect(function()
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            local hum = LocalPlayer.Character.Humanoid
            if _G.WalkSpeedToggle then
                hum.WalkSpeed = _G.WalkSpeedValue
            end
            if _G.JumpPowerToggle then
                hum.UseJumpPower = true
                hum.JumpPower = _G.JumpPowerValue
            end
        end
    end)
end)

-- Auto Fast Attack & Auto Click
task.spawn(function()
    while task.wait(0.1) do
        if _G.AutoFastAttack then
            pcall(function()
                autoEquipWeapon()
                local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool then
                    tool:Activate()
                end
            end)
        end
    end
end)

-- Auto Level Farm (Accurate Mob Farming)
task.spawn(function()
    while task.wait(0.3) do
        if _G.AutoFarmLevel then
            pcall(function()
                if workspace:FindFirstChild("Enemies") then
                    for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                        if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                autoEquipWeapon()
                                enemy.HumanoidRootPart.CanCollide = false
                                -- Position directly above mob for safe auto farming
                                LocalPlayer.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
                                if _G.AutoFastAttack == false then
                                    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                                    if tool then tool:Activate() end
                                end
                                break
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Chest Farm (Accurate Distance Check & Safe Touch)
task.spawn(function()
    while task.wait(0.5) do
        if _G.AutoChestFarm then
            pcall(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = LocalPlayer.Character.HumanoidRootPart
                    local closestChest = nil
                    local shortestDist = math.huge

                    for _, chest in pairs(workspace:GetDescendants()) do
                        if string.find(chest.Name, "Chest") and chest:IsA("BasePart") and chest:FindFirstChild("TouchInterest") then
                            local dist = (hrp.Position - chest.Position).Magnitude
                            if dist < shortestDist then
                                shortestDist = dist
                                closestChest = chest
                            end
                        end
                    end

                    if closestChest then
                        local tween = smoothMoveTo(closestChest.CFrame, 220)
                        if tween then
                            tween.Completed:Wait()
                            firetouchinterest(hrp, closestChest, 0)
                            firetouchinterest(hrp, closestChest, 1)
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Boss Farm
task.spawn(function()
    while task.wait(0.5) do
        if _G.AutoBossFarm and _G.SelectedBoss then
            pcall(function()
                if workspace:FindFirstChild("Enemies") then
                    for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                        if enemy.Name == _G.SelectedBoss and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                autoEquipWeapon()
                                LocalPlayer.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
                                local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                                if tool then tool:Activate() end
                            end
                        end
                    end
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

-- Auto Store Fruits
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

-- ESP Refresh Loop
task.spawn(function()
    while task.wait(2) do
        -- Player ESP
        if _G.PlayerESP then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and not plr.Character:FindFirstChild("VanishPlayerESP") then
                    local hl = Instance.new("Highlight")
                    hl.Name = "VanishPlayerESP"
                    hl.FillColor = Color3.fromRGB(138, 43, 226)
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.Parent = plr.Character
                end
            end
        else
            for _, plr in pairs(Players:GetPlayers()) do
                if plr.Character and plr.Character:FindFirstChild("VanishPlayerESP") then
                    plr.Character.VanishPlayerESP:Destroy()
                end
            end
        end

        -- Fruit ESP
        if _G.FruitESP then
            for _, item in pairs(workspace:GetChildren()) do
                if item:IsA("Tool") and string.find(item.Name, "Fruit") and not item:FindFirstChild("VanishFruitESP") then
                    local hl = Instance.new("Highlight")
                    hl.Name = "VanishFruitESP"
                    hl.FillColor = Color3.fromRGB(0, 255, 120)
                    hl.Parent = item
                end
            end
        else
            for _, item in pairs(workspace:GetChildren()) do
                if item:FindFirstChild("VanishFruitESP") then
                    item.VanishFruitESP:Destroy()
                end
            end
        end

        -- Chest ESP
        if _G.ChestESP then
            for _, chest in pairs(workspace:GetDescendants()) do
                if string.find(chest.Name, "Chest") and chest:IsA("BasePart") and not chest:FindFirstChild("VanishChestESP") then
                    local hl = Instance.new("Highlight")
                    hl.Name = "VanishChestESP"
                    hl.FillColor = Color3.fromRGB(255, 215, 0)
                    hl.Parent = chest
                end
            end
        else
            for _, chest in pairs(workspace:GetDescendants()) do
                if chest:FindFirstChild("VanishChestESP") then
                    chest.VanishChestESP:Destroy()
                end
            end
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

-- Infinite Jump Request
UserInputService.JumpRequest:Connect(function()
    if _G.InfiniteJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- Noclip Stepped Loop
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
                        smoothMoveTo(v.Handle.CFrame, 250)
                    end
                end
            end
        end
    end
end)

print("Vanish Hub | Blox Fruits (Accurate V4) loaded successfully!")
