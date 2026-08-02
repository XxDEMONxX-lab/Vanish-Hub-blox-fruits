--[[
    ====================================================
    VANISH HUB | BLOX FRUITS (OPTIMIZED & REFIXED)
    UI Library: Elerium UI Library V2
    Credits: Made by XxDEMONxX
    ====================================================
--]]

-- Load Elerium UI Library
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/memejames/elerium-v2-ui-library/main/Library", true))()

-- Create Window (Set width to 580 to prevent tab overflow)
local window = library:AddWindow("Vanish Hub | Blox Fruits", {
    main_color = Color3.fromRGB(138, 43, 226),
    min_size = Vector2.new(580, 420),
    toggle_key = Enum.KeyCode.RightControl,
    can_resize = true,
})

---------------------------------------------------------
-- FLOATING MINIMIZE / TOGGLE BUTTON (PC & MOBILE)
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
-- SERVICES & GLOBAL STATES
---------------------------------------------------------
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")

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

---------------------------------------------------------
-- HELPER FUNCTIONS
---------------------------------------------------------
local currentTween = nil

local function smoothMoveTo(targetCFrame, speed)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local distance = (hrp.Position - targetCFrame.Position).Magnitude
        if distance < 3 then return end
        local duration = distance / (speed or 220)
        
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

-- Function to create Billboard ESP (100% stable in Roblox)
local function createBillboardESP(parent, name, color)
    if not parent or parent:FindFirstChild("VanishBillboard") then return end
    
    local bgui = Instance.new("BillboardGui")
    bgui.Name = "VanishBillboard"
    bgui.Adornee = parent
    bgui.AlwaysOnTop = true
    bgui.Size = UDim2.new(0, 100, 0, 30)
    bgui.StudsOffset = Vector3.new(0, 3, 0)
    bgui.Parent = parent

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = name
    textLabel.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    textLabel.TextStrokeTransparency = 0
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextSize = 14
    textLabel.Parent = bgui
end

---------------------------------------------------------
-- TAB CREATION (4 CLEAN TABS TO PREVENT OVERFLOW & MISSING CREDITS)
---------------------------------------------------------

-- TAB 1: FARMING & BOSSES
local FarmTab = window:AddTab("Farm & Bosses")
FarmTab:Show() -- Show default tab

FarmTab:AddLabel("--- Auto Combat & Level Farming ---")

FarmTab:AddSwitch("Auto Farm Level", function(bool)
    _G.AutoFarmLevel = bool
    if not bool and currentTween then currentTween:Cancel() end
end)

FarmTab:AddSwitch("Fast Attack (Auto Clicker)", function(bool)
    _G.AutoFastAttack = bool
end)

FarmTab:AddSwitch("Auto Chest Farm", function(bool)
    _G.AutoChestFarm = bool
    if not bool and currentTween then currentTween:Cancel() end
end)

FarmTab:AddSwitch("Auto Enable Buso Haki", function(bool)
    _G.AutoBusoHaki = bool
end)

FarmTab:AddLabel("--- Boss & Fruit Actions ---")

local bossDropdown = FarmTab:AddDropdown("Select Boss", function(text)
    _G.SelectedBoss = text
end)

local bossList = {"Gorilla King", "Bobby", "Yeti", "Vice Admiral", "Swann", "Magma Admiral", "Fishman Lord", "Wysper", "Thunder God", "Cyborg"}
for _, b in ipairs(bossList) do
    bossDropdown:Add(b)
end

FarmTab:AddSwitch("Auto Farm Selected Boss", function(bool)
    _G.AutoBossFarm = bool
    if not bool and currentTween then currentTween:Cancel() end
end)

FarmTab:AddSwitch("Auto Collect Dropped Fruits", function(bool)
    _G.AutoCollectFruits = bool
end)

FarmTab:AddSwitch("Auto Store Fruits", function(bool)
    _G.AutoStoreFruits = bool
end)

FarmTab:AddButton("Buy Random Fruit (Gacha)", function()
    pcall(function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("Cousin", "Buy")
    end)
end)

-- TAB 2: TELEPORTS & STATS
local WorldTab = window:AddTab("Teleports & Stats")

WorldTab:AddLabel("--- Island & Sea Teleports ---")

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

local islandDropdown = WorldTab:AddDropdown("Select Island", function(text)
    _G.SelectedIsland = text
end)

for name, _ in pairs(islandLocations) do
    islandDropdown:Add(name)
end

WorldTab:AddButton("Teleport to Selected Island", function()
    if islandLocations[_G.SelectedIsland] then
        smoothMoveTo(CFrame.new(islandLocations[_G.SelectedIsland]), 300)
    end
end)

WorldTab:AddButton("First Sea", function()
    ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelMain")
end)

WorldTab:AddButton("Second Sea", function()
    ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelDressrosa")
end)

WorldTab:AddButton("Third Sea", function()
    ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelZou")
end)

WorldTab:AddLabel("--- Auto Stats Allocator ---")

WorldTab:AddSwitch("Auto Melee", function(b) _G.AutoStatsMelee = b end)
WorldTab:AddSwitch("Auto Defense", function(b) _G.AutoStatsDefense = b end)
WorldTab:AddSwitch("Auto Sword", function(b) _G.AutoStatsSword = b end)
WorldTab:AddSwitch("Auto Gun", function(b) _G.AutoStatsGun = b end)
WorldTab:AddSwitch("Auto Blox Fruit", function(b) _G.AutoStatsFruit = b end)

-- TAB 3: VISUALS & PLAYER MODS
local VisualsTab = window:AddTab("Visuals & Player Mods")

VisualsTab:AddLabel("--- World Vision & ESP ---")

VisualsTab:AddSwitch("Player ESP", function(b) _G.PlayerESP = b end)
VisualsTab:AddSwitch("Fruit ESP", function(b) _G.FruitESP = b end)
VisualsTab:AddSwitch("Chest ESP", function(b) _G.ChestESP = b end)

VisualsTab:AddSwitch("FullBright", function(bool)
    _G.FullBright = bool
    if bool then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
    else
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
    end
end)

VisualsTab:AddLabel("--- Character Movement Modifiers ---")

VisualsTab:AddSwitch("Enable Custom WalkSpeed", function(bool)
    _G.WalkSpeedToggle = bool
    if not bool and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)

local walkSlider = VisualsTab:AddSlider("WalkSpeed Value", function(v)
    _G.WalkSpeedValue = tonumber(v) or 16
end, { ["min"] = 16, ["max"] = 350 })
walkSlider:Set(16)

VisualsTab:AddSwitch("Enable Custom JumpPower", function(bool)
    _G.JumpPowerToggle = bool
    if not bool and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = 50
        LocalPlayer.Character.Humanoid.JumpHeight = 7.2
    end
end)

local jumpSlider = VisualsTab:AddSlider("JumpPower Value", function(v)
    _G.JumpPowerValue = tonumber(v) or 50
end, { ["min"] = 50, ["max"] = 350 })
jumpSlider:Set(50)

VisualsTab:AddSwitch("Infinite Energy", function(b) _G.InfiniteEnergy = b end)
VisualsTab:AddSwitch("NoClip", function(b) _G.NoClip = b end)
VisualsTab:AddSwitch("Infinite Jump", function(b) _G.InfiniteJump = b end)

-- TAB 4: UTILITY & CREDITS (GUARANTEED VISIBLE)
local CreditsTab = window:AddTab("Utility & Credits")

CreditsTab:AddLabel("--- Anti-AFK & Tools ---")

CreditsTab:AddButton("Execute Vanish Hub Anti-AFK", function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XxDEMONxX-lab/Vanish-Hub-universel-anti-afk/refs/heads/main/Vanish%20Hub%20universel%20anti%20afk"))()
    end)
end)

CreditsTab:AddButton("Rejoin Server", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
end)

CreditsTab:AddButton("Server Hop", function()
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

CreditsTab:AddLabel("--- Vanish Hub Credits ---")
CreditsTab:AddLabel("Script Creator: XxDEMONxX")
CreditsTab:AddLabel("UI Engine: Elerium UI Library V2")
CreditsTab:AddLabel("Target Game: Blox Fruits")
CreditsTab:AddLabel("Version: 5.0 Final Release")

CreditsTab:AddButton("Copy Creator Name", function()
    if setclipboard then
        setclipboard("XxDEMONxX")
    end
end)

---------------------------------------------------------
-- BACKGROUND LOOPS & REAL-TIME ENFORCEMENT
---------------------------------------------------------

-- Real-Time WalkSpeed & JumpPower Enforcement (RenderStepped & Heartbeat)
RunService.Stepped:Connect(function()
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            local hum = LocalPlayer.Character.Humanoid
            if _G.WalkSpeedToggle then
                hum.WalkSpeed = _G.WalkSpeedValue
            end
            if _G.JumpPowerToggle then
                hum.UseJumpPower = true
                hum.JumpPower = _G.JumpPowerValue
                hum.JumpHeight = (_G.JumpPowerValue / 50) * 7.2
            end
        end
    end)
end)

-- Fast Attack & Virtual User Clicks
task.spawn(function()
    while task.wait(0.05) do
        if _G.AutoFastAttack then
            pcall(function()
                autoEquipWeapon()
                local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool then
                    tool:Activate()
                    VirtualUser:CaptureController()
                    VirtualUser:Button1Down(Vector2.new(0, 0))
                end
            end)
        end
    end
end)

-- Auto Level Farm
task.spawn(function()
    while task.wait(0.2) do
        if _G.AutoFarmLevel then
            pcall(function()
                if workspace:FindFirstChild("Enemies") then
                    for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                        if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                autoEquipWeapon()
                                enemy.HumanoidRootPart.CanCollide = false
                                LocalPlayer.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
                                break
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Boss Farm
task.spawn(function()
    while task.wait(0.3) do
        if _G.AutoBossFarm and _G.SelectedBoss then
            pcall(function()
                if workspace:FindFirstChild("Enemies") then
                    for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                        if enemy.Name == _G.SelectedBoss and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                autoEquipWeapon()
                                LocalPlayer.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Chest Farm
task.spawn(function()
    while task.wait(0.4) do
        if _G.AutoChestFarm then
            pcall(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = LocalPlayer.Character.HumanoidRootPart
                    local closestChest = nil
                    local shortestDist = math.huge

                    for _, chest in pairs(workspace:GetDescendants()) do
                        if string.find(chest.Name, "Chest") and chest:IsA("BasePart") then
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
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Stats Loop
task.spawn(function()
    while task.wait(0.5) do
        if _G.AutoStatsMelee then ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Melee", 1) end
        if _G.AutoStatsDefense then ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Defense", 1) end
        if _G.AutoStatsSword then ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Sword", 1) end
        if _G.AutoStatsGun then ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Gun", 1) end
        if _G.AutoStatsFruit then ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Demon Fruit", 1) end
    end
end)

-- ESP System Loop (100% Reliable Billboard ESP)
task.spawn(function()
    while task.wait(1.5) do
        -- Player ESP
        if _G.PlayerESP then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    createBillboardESP(plr.Character.HumanoidRootPart, plr.Name, Color3.fromRGB(138, 43, 226))
                end
            end
        else
            for _, plr in pairs(Players:GetPlayers()) do
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character.HumanoidRootPart:FindFirstChild("VanishBillboard") then
                    plr.Character.HumanoidRootPart.VanishBillboard:Destroy()
                end
            end
        end

        -- Fruit ESP
        if _G.FruitESP then
            for _, item in pairs(workspace:GetChildren()) do
                if item:IsA("Tool") and string.find(item.Name, "Fruit") then
                    local handle = item:FindFirstChild("Handle") or item:FindFirstChildOfClass("BasePart")
                    if handle then
                        createBillboardESP(handle, item.Name, Color3.fromRGB(0, 255, 120))
                    end
                end
            end
        else
            for _, item in pairs(workspace:GetChildren()) do
                local handle = item:FindFirstChild("Handle") or item:FindFirstChildOfClass("BasePart")
                if handle and handle:FindFirstChild("VanishBillboard") then
                    handle.VanishBillboard:Destroy()
                end
            end
        end

        -- Chest ESP
        if _G.ChestESP then
            for _, chest in pairs(workspace:GetDescendants()) do
                if string.find(chest.Name, "Chest") and chest:IsA("BasePart") then
                    createBillboardESP(chest, chest.Name, Color3.fromRGB(255, 215, 0))
                end
            end
        else
            for _, chest in pairs(workspace:GetDescendants()) do
                if chest:IsA("BasePart") and chest:FindFirstChild("VanishBillboard") then
                    chest.VanishBillboard:Destroy()
                end
            end
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

-- Infinite Energy
task.spawn(function()
    while task.wait(0.5) do
        if _G.InfiniteEnergy and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Energy") then
            LocalPlayer.Character.Energy.Value = LocalPlayer.Character.Energy.MaxValue
        end
    end
end)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if _G.InfiniteJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- Noclip
RunService.Stepped:Connect(function()
    if _G.NoClip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

print("Vanish Hub | Blox Fruits V5 loaded successfully!")
