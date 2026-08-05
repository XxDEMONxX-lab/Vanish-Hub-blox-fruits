--[[
    ========================================================
             VANISH HUB | +1 KEYBOARD ESCAPE (ULTIMATE)
    ========================================================
    UI Library : Elerium UI Library v2
    Supported  : All PC & Mobile Executors (Delta, Codex, Wave, Solara, Hydrogen, Fluxus, Xeno, etc.)
--]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

-- Global Settings Table
getgenv().VanishHub = getgenv().VanishHub or {
    -- Automation
    AutoClick = false,
    FarmDelay = 0.05,
    AutoCollect = false,
    AutoWin = false,
    TweenWin = false,
    TweenSpeed = 50,
    AutoRebirth = false,
    AutoBuyUpgrades = false,
    
    -- Eggs & Pets
    SelectedEgg = "Common Egg",
    AutoHatch = false,
    AutoCraft = false,
    
    -- Rewards
    AutoClaimGifts = false,
    AutoClaimDaily = false,
    AutoSpinWheel = false,
    
    -- Movement Mods
    WalkSpeedEnabled = false,
    WalkSpeedValue = 16,
    JumpPowerEnabled = false,
    JumpPowerValue = 50,
    InfiniteJump = false,
    Noclip = false,
    GhostMode = false,
    Fly = false,
    FlySpeed = 50,
    
    -- Teleports & Waypoints
    SelectedTeleport = "Spawn / Lobby",
    SelectedPlayerTP = "",
    SavedWaypoint = nil,
    SpectatingPlayer = false,
    
    -- Safety & World
    DisableKillParts = false,
    FOVValue = 70,
    
    -- Visuals & ESP
    PlayerESP = false,
    ESPColor = Color3.fromRGB(138, 43, 226),
    TracerESP = false,
    Fullbright = false,
    RemoveFog = false,
    
    -- Webhook
    WebhookURL = "https://discord.com/api/webhooks/1534388075751407636/U6CbHHIQSKoGle1qHG7Ss1IV3sLhvow0wl9JFnMhfLqDYB94t_tAF79bFUx5ka-DEFJF",
    AutoWebhookTracker = false,
    
    -- UI Control
    GuiVisible = true
}

local Hub = getgenv().VanishHub

-- Helper Character Getters
local function getCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function getRoot()
    local char = getCharacter()
    return char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 5)
end

local function getHumanoid()
    local char = getCharacter()
    return char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 5)
end

-- Load Elerium Library v2
local librarySuccess, library = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/memejames/elerium-v2-ui-library/main/Library", true))()
end)

if not librarySuccess or not library then
    warn("[Vanish Hub] Failed to load Elerium UI Library!")
    return
end

-- Create Window
local window = library:AddWindow("Vanish Hub | +1 Keyboard Escape", {
    main_color = Color3.fromRGB(138, 43, 226),
    min_size = Vector2.new(340, 480),
    can_resize = true,
    toggle_key = Enum.KeyCode.RightControl
})

-- Create Tabs
local mainTab = window:AddTab("Main / Farm")
mainTab:Show()

local petTab = window:AddTab("Eggs & Pets")
local rewardTab = window:AddTab("Rewards & Claims")
local playerTab = window:AddTab("Player Mods")
local teleportTab = window:AddTab("Teleports & Waypoints")
local worldTab = window:AddTab("World & Safety")
local visualsTab = window:AddTab("Visuals & ESP")
local webhookTab = window:AddTab("Webhook Tracker")
local miscTab = window:AddTab("Misc & UI Controls")

-- =========================================================
-- 1. MAIN / FARM TAB
-- =========================================================
mainTab:AddLabel("--- AUTOMATION TOGGLES ---")

mainTab:AddSwitch("Auto Click / Gain Speed", function(state)
    Hub.AutoClick = state
    task.spawn(function()
        while Hub.AutoClick and task.wait(Hub.FarmDelay or 0.05) do
            pcall(function()
                VirtualUser:Button1Down(Vector2.new(0, 0))
                VirtualUser:Button1Up(Vector2.new(0, 0))

                local char = LocalPlayer.Character
                if char then
                    local tool = char:FindFirstChildOfClass("Tool")
                    if tool then tool:Activate() end
                end

                for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
                    if obj:IsA("RemoteEvent") then
                        local name = obj.Name:lower()
                        if name:find("click") or name:find("tap") or name:find("keyboard") or name:find("gain") or name:find("speed") or name:find("add") then
                            obj:FireServer()
                        end
                    end
                end
            end)
        end
    end)
end)

local farmSpeedDropdown = mainTab:AddDropdown("Auto Click Speed", function(selected)
    if selected == "Legit (0.1s)" then Hub.FarmDelay = 0.1
    elseif selected == "Insane (0.05s)" then Hub.FarmDelay = 0.05
    elseif selected == "God Mode (0.01s)" then Hub.FarmDelay = 0.01 end
end)
farmSpeedDropdown:Add("Legit (0.1s)")
farmSpeedDropdown:Add("Insane (0.05s)")
farmSpeedDropdown:Add("God Mode (0.01s)")

mainTab:AddSwitch("Auto Collect Keyboards", function(state)
    Hub.AutoCollect = state
    task.spawn(function()
        while Hub.AutoCollect and task.wait(0.3) do
            pcall(function()
                local root = getRoot()
                if not root then return end
                for _, item in ipairs(Workspace:GetDescendants()) do
                    if not Hub.AutoCollect then break end
                    local lowerName = item.Name:lower()
                    if (lowerName:find("keyboard") or lowerName:find("key") or lowerName:find("pickup") or lowerName:find("collect")) and (item:IsA("BasePart") or item:IsA("Model")) then
                        local part = item:IsA("BasePart") and item or item:FindFirstChildWhichIsA("BasePart")
                        if part then
                            if firetouchinterest and item:FindFirstChildWhichIsA("TouchTransmitter") then
                                firetouchinterest(root, part, 0)
                                firetouchinterest(root, part, 1)
                            else
                                root.CFrame = part.CFrame + Vector3.new(0, 2, 0)
                                task.wait(0.1)
                            end
                        end
                    end
                end
            end)
        end
    end)
end)

mainTab:AddSwitch("Instant TP Auto Win", function(state)
    Hub.AutoWin = state
    task.spawn(function()
        while Hub.AutoWin and task.wait(0.5) do
            pcall(function()
                local root = getRoot()
                if not root then return end
                for _, item in ipairs(Workspace:GetDescendants()) do
                    if not Hub.AutoWin then break end
                    local lowerName = item.Name:lower()
                    if lowerName:find("win") or lowerName:find("finish") or lowerName:find("endzone") or lowerName:find("escape") or lowerName:find("victory") then
                        local part = item:IsA("BasePart") and item or item:FindFirstChildWhichIsA("BasePart")
                        if part then
                            if firetouchinterest and part:FindFirstChildWhichIsA("TouchTransmitter") then
                                firetouchinterest(root, part, 0)
                                firetouchinterest(root, part, 1)
                            else
                                root.CFrame = part.CFrame + Vector3.new(0, 3, 0)
                            end
                            task.wait(0.5)
                        end
                    end
                end
            end)
        end
    end)
end)

mainTab:AddSwitch("Smooth Tween Auto Win (Anti-Cheat Bypass)", function(state)
    Hub.TweenWin = state
    task.spawn(function()
        while Hub.TweenWin and task.wait(1) do
            pcall(function()
                local root = getRoot()
                if not root then return end
                for _, item in ipairs(Workspace:GetDescendants()) do
                    if not Hub.TweenWin then break end
                    local lowerName = item.Name:lower()
                    if lowerName:find("win") or lowerName:find("finish") or lowerName:find("escape") then
                        local part = item:IsA("BasePart") and item or item:FindFirstChildWhichIsA("BasePart")
                        if part then
                            local dist = (root.Position - part.Position).Magnitude
                            local tweenInfo = TweenInfo.new(dist / (Hub.TweenSpeed or 50), Enum.EasingStyle.Linear)
                            local tween = TweenService:Create(root, tweenInfo, {CFrame = part.CFrame})
                            tween:Play()
                            tween.Completed:Wait()
                        end
                    end
                end
            end)
        end
    end)
end)

mainTab:AddSwitch("Auto Rebirth / Prestige", function(state)
    Hub.AutoRebirth = state
    task.spawn(function()
        while Hub.AutoRebirth and task.wait(1) do
            pcall(function()
                for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
                    if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                        local name = obj.Name:lower()
                        if name:find("rebirth") or name:find("prestige") or name:find("ascend") then
                            if obj:IsA("RemoteEvent") then obj:FireServer() else obj:InvokeServer() end
                        end
                    end
                end
            end)
        end
    end)
end)

mainTab:AddSwitch("Auto Buy Upgrades", function(state)
    Hub.AutoBuyUpgrades = state
    task.spawn(function()
        while Hub.AutoBuyUpgrades and task.wait(1.5) do
            pcall(function()
                for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
                    if obj:IsA("RemoteEvent") then
                        local name = obj.Name:lower()
                        if name:find("upgrade") or name:find("buy") or name:find("multiplier") then
                            obj:FireServer()
                        end
                    end
                end
            end)
        end
    end)
end)

-- =========================================================
-- 2. EGGS & PETS TAB
-- =========================================================
petTab:AddLabel("--- EGG HATCHING & PET AUTOMATION ---")

local eggDropdown = petTab:AddDropdown("Select Egg Type", function(selected)
    Hub.SelectedEgg = selected
end)
eggDropdown:Add("Common Egg")
eggDropdown:Add("Rare Egg")
eggDropdown:Add("Epic Egg")
eggDropdown:Add("Legendary Egg")
eggDropdown:Add("Mythic Egg")
eggDropdown:Add("Void Egg")

petTab:AddSwitch("Auto Hatch Selected Egg", function(state)
    Hub.AutoHatch = state
    task.spawn(function()
        while Hub.AutoHatch and task.wait(0.5) do
            pcall(function()
                for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
                    if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                        local name = obj.Name:lower()
                        if name:find("hatch") or name:find("egg") or name:find("buyegg") then
                            if obj:IsA("RemoteEvent") then obj:FireServer(Hub.SelectedEgg, 1) else obj:InvokeServer(Hub.SelectedEgg, 1) end
                        end
                    end
                end
            end)
        end
    end)
end)

petTab:AddButton("Equip Best Pets Automatically", function()
    pcall(function()
        for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
            if obj:IsA("RemoteEvent") then
                local name = obj.Name:lower()
                if name:find("equipbest") or name:find("autoequip") or name:find("equip_best") then
                    obj:FireServer()
                end
            end
        end
    end)
end)

petTab:AddSwitch("Auto Craft / Fuse Golden Pets", function(state)
    Hub.AutoCraft = state
    task.spawn(function()
        while Hub.AutoCraft and task.wait(2) do
            pcall(function()
                for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
                    if obj:IsA("RemoteEvent") and (obj.Name:lower():find("craft") or obj.Name:lower():find("fuse") or obj.Name:lower():find("golden")) then
                        obj:FireServer()
                    end
                end
            end)
        end
    end)
end)

-- =========================================================
-- 3. REWARDS & CLAIMS TAB
-- =========================================================
rewardTab:AddLabel("--- REWARDS AUTOMATION ---")

rewardTab:AddSwitch("Auto Claim Playtime Gifts", function(state)
    Hub.AutoClaimGifts = state
    task.spawn(function()
        while Hub.AutoClaimGifts and task.wait(2) do
            pcall(function()
                for i = 1, 12 do
                    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
                        if obj:IsA("RemoteEvent") and (obj.Name:lower():find("gift") or obj.Name:lower():find("reward") or obj.Name:lower():find("playtime")) then
                            obj:FireServer(i)
                        end
                    end
                end
            end)
        end
    end)
end)

rewardTab:AddSwitch("Auto Claim Daily Chests", function(state)
    Hub.AutoClaimDaily = state
    task.spawn(function()
        while Hub.AutoClaimDaily and task.wait(3) do
            pcall(function()
                for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
                    if obj:IsA("RemoteEvent") and (obj.Name:lower():find("daily") or obj.Name:lower():find("chest")) then
                        obj:FireServer()
                    end
                end
            end)
        end
    end)
end)

rewardTab:AddSwitch("Auto Spin Daily Prize Wheel", function(state)
    Hub.AutoSpinWheel = state
    task.spawn(function()
        while Hub.AutoSpinWheel and task.wait(2) do
            pcall(function()
                for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
                    if obj:IsA("RemoteEvent") and (obj.Name:lower():find("spin") or obj.Name:lower():find("wheel")) then
                        obj:FireServer()
                    end
                end
            end)
        end
    end)
end)

rewardTab:AddButton("Claim All VIP & Group Rewards", function()
    pcall(function()
        for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
            if obj:IsA("RemoteEvent") then
                local name = obj.Name:lower()
                if name:find("vip") or name:find("group") or name:find("claim") then
                    obj:FireServer()
                end
            end
        end
    end)
end)

-- =========================================================
-- 4. PLAYER MODS TAB
-- =========================================================
playerTab:AddLabel("--- MOVEMENT & GHOST MODS ---")

local speedSlider = playerTab:AddSlider("WalkSpeed Value", function(val) Hub.WalkSpeedValue = val end, {["min"] = 16, ["max"] = 500})
speedSlider:Set(16)
playerTab:AddSwitch("Enable Custom WalkSpeed", function(state) Hub.WalkSpeedEnabled = state end)

local jumpSlider = playerTab:AddSlider("JumpPower Value", function(val) Hub.JumpPowerValue = val end, {["min"] = 50, ["max"] = 500})
jumpSlider:Set(50)
playerTab:AddSwitch("Enable Custom JumpPower", function(state) Hub.JumpPowerEnabled = state end)

RunService.RenderStepped:Connect(function()
    pcall(function()
        local hum = getHumanoid()
        if hum then
            if Hub.WalkSpeedEnabled then hum.WalkSpeed = Hub.WalkSpeedValue end
            if Hub.JumpPowerEnabled then hum.UseJumpPower = true; hum.JumpPower = Hub.JumpPowerValue end
        end
    end)
end)

playerTab:AddSwitch("Infinite Jump", function(state) Hub.InfiniteJump = state end)
UserInputService.JumpRequest:Connect(function()
    if Hub.InfiniteJump then
        local hum = getHumanoid()
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

playerTab:AddSwitch("Noclip (Walk Through Walls)", function(state) Hub.Noclip = state end)
RunService.Stepped:Connect(function()
    if Hub.Noclip then
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
    end
end)

playerTab:AddSwitch("Ghost / Invisible Mode", function(state)
    Hub.GhostMode = state
    pcall(function()
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.LocalTransparencyModifier = state and 0.8 or 0
                end
            end
        end
    end)
end)

local flyBodyVel, flyBodyGyro
playerTab:AddSwitch("Fly Mode", function(state)
    Hub.Fly = state
    local root = getRoot()
    local camera = Workspace.CurrentCamera

    if Hub.Fly and root then
        flyBodyVel = Instance.new("BodyVelocity")
        flyBodyVel.MaxForce = Vector3.new(4e5, 4e5, 4e5)
        flyBodyVel.Velocity = Vector3.new(0, 0, 0)
        flyBodyVel.Parent = root

        flyBodyGyro = Instance.new("BodyGyro")
        flyBodyGyro.MaxTorque = Vector3.new(4e5, 4e5, 4e5)
        flyBodyGyro.CFrame = root.CFrame
        flyBodyGyro.Parent = root

        task.spawn(function()
            while Hub.Fly and root and flyBodyVel and flyBodyGyro do
                local moveDir = Vector3.new(0, 0, 0)
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end

                flyBodyVel.Velocity = moveDir * Hub.FlySpeed
                flyBodyGyro.CFrame = camera.CFrame
                task.wait()
            end
            if flyBodyVel then flyBodyVel:Destroy() end
            if flyBodyGyro then flyBodyGyro:Destroy() end
        end)
    else
        if flyBodyVel then flyBodyVel:Destroy() end
        if flyBodyGyro then flyBodyGyro:Destroy() end
    end
end)

local flySlider = playerTab:AddSlider("Fly Speed", function(val) Hub.FlySpeed = val end, {["min"] = 10, ["max"] = 300})
flySlider:Set(50)

-- =========================================================
-- 5. TELEPORTS & WAYPOINTS TAB
-- =========================================================
teleportTab:AddLabel("--- STAGE & WORLD TELEPORTS ---")

local tpDropdown = teleportTab:AddDropdown("Select Location", function(selected)
    Hub.SelectedTeleport = selected
end)
tpDropdown:Add("Spawn / Lobby")
tpDropdown:Add("Win / Escape Door")
tpDropdown:Add("Safe Sky Zone")
for i = 1, 20 do tpDropdown:Add("Stage " .. i) end

teleportTab:AddButton("Teleport To Selected", function()
    pcall(function()
        local root = getRoot()
        if not root then return end
        local sel = Hub.SelectedTeleport

        if sel == "Spawn / Lobby" then
            local spawnPart = Workspace:FindFirstChild("SpawnLocation") or Workspace:FindFirstChild("Lobby") or Workspace:FindFirstChild("Spawn")
            if spawnPart then root.CFrame = (spawnPart:IsA("BasePart") and spawnPart.CFrame or spawnPart:GetModelCFrame()) + Vector3.new(0, 5, 0)
            else root.CFrame = CFrame.new(0, 50, 0) end
        elseif sel == "Win / Escape Door" then
            for _, item in ipairs(Workspace:GetDescendants()) do
                if item.Name:lower():find("win") or item.Name:lower():find("finish") or item.Name:lower():find("escape") then
                    local part = item:IsA("BasePart") and item or item:FindFirstChildWhichIsA("BasePart")
                    if part then root.CFrame = part.CFrame + Vector3.new(0, 4, 0); break end
                end
            end
        elseif sel == "Safe Sky Zone" then
            root.CFrame = root.CFrame + Vector3.new(0, 500, 0)
        else
            for _, item in ipairs(Workspace:GetDescendants()) do
                if item.Name:lower():find(sel:lower()) then
                    local part = item:IsA("BasePart") and item or item:FindFirstChildWhichIsA("BasePart")
                    if part then root.CFrame = part.CFrame + Vector3.new(0, 4, 0); break end
                end
            end
        end
    end)
end)

teleportTab:AddLabel("--- WAYPOINT SAVER ---")

teleportTab:AddButton("Save Current Position", function()
    local root = getRoot()
    if root then
        Hub.SavedWaypoint = root.CFrame
        print("[Vanish Hub] Saved Waypoint Position!")
    end
end)

teleportTab:AddButton("Teleport To Saved Position", function()
    local root = getRoot()
    if root and Hub.SavedWaypoint then
        root.CFrame = Hub.SavedWaypoint
    end
end)

teleportTab:AddLabel("--- PLAYER TELEPORT & SPECTATE ---")

local playerDropdown = teleportTab:AddDropdown("Select Player", function(selected)
    Hub.SelectedPlayerTP = selected
end)

local function refreshPlayerList()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then playerDropdown:Add(plr.Name) end
    end
end
refreshPlayerList()
Players.PlayerAdded:Connect(refreshPlayerList)

teleportTab:AddButton("Teleport To Player", function()
    pcall(function()
        local target = Players:FindFirstChild(Hub.SelectedPlayerTP)
        local root = getRoot()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and root then
            root.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
        end
    end)
end)

teleportTab:AddSwitch("Spectate Selected Player", function(state)
    Hub.SpectatingPlayer = state
    pcall(function()
        local camera = Workspace.CurrentCamera
        local target = Players:FindFirstChild(Hub.SelectedPlayerTP)
        if state and target and target.Character and target.Character:FindFirstChildOfClass("Humanoid") then
            camera.CameraSubject = target.Character:FindFirstChildOfClass("Humanoid")
        else
            local hum = getHumanoid()
            if hum then camera.CameraSubject = hum end
        end
    end)
end)

-- =========================================================
-- 6. WORLD & SAFETY TAB
-- =========================================================
worldTab:AddLabel("--- MAP SAFETY & BYPASSES ---")

worldTab:AddButton("Destroy Kill Parts & Lava", function()
    pcall(function()
        for _, obj in ipairs(Workspace:GetDescendants()) do
            local name = obj.Name:lower()
            if name:find("kill") or name:find("lava") or name:find("hazard") or name:find("acid") or name:find("laser") then
                if obj:IsA("BasePart") then
                    obj.CanTouch = false
                    local tt = obj:FindFirstChildWhichIsA("TouchTransmitter")
                    if tt then tt:Destroy() end
                end
            end
        end
    end)
end)

worldTab:AddButton("Remove Barrier Walls", function()
    pcall(function()
        for _, obj in ipairs(Workspace:GetDescendants()) do
            local name = obj.Name:lower()
            if name:find("barrier") or name:find("invisible") or name:find("wall") then
                if obj:IsA("BasePart") and obj.Transparency > 0.5 then
                    obj:Destroy()
                end
            end
        end
    end)
end)

worldTab:AddLabel("--- CAMERA & SKYBOX ---")

local fovSlider = worldTab:AddSlider("Field of View (FOV)", function(val)
    Hub.FOVValue = val
    Workspace.CurrentCamera.FieldOfView = val
end, {["min"] = 60, ["max"] = 120})
fovSlider:Set(70)

local skyDropdown = worldTab:AddDropdown("Custom Skybox Theme", function(selected)
    pcall(function()
        local sky = Lighting:FindFirstChildOfClass("Sky") or Instance.new("Sky", Lighting)
        if selected == "Purple Galaxy" then
            sky.SkyboxBk = "rbxassetid://159454299"; sky.SkyboxDn = "rbxassetid://159454296"; sky.SkyboxFt = "rbxassetid://159454293"
            sky.SkyboxLf = "rbxassetid://159454286"; sky.SkyboxRt = "rbxassetid://159454300"; sky.SkyboxUp = "rbxassetid://159454288"
        elseif selected == "Cyberpunk" then
            sky.SkyboxBk = "rbxassetid://320921005"; sky.SkyboxDn = "rbxassetid://320921201"; sky.SkyboxFt = "rbxassetid://320920531"
        elseif selected == "Vaporwave" then
            sky.SkyboxBk = "rbxassetid://1417494402"; sky.SkyboxDn = "rbxassetid://1417494444"; sky.SkyboxFt = "rbxassetid://1417494474"
        end
    end)
end)
skyDropdown:Add("Default")
skyDropdown:Add("Purple Galaxy")
skyDropdown:Add("Cyberpunk")
skyDropdown:Add("Vaporwave")

-- =========================================================
-- 7. VISUALS & ESP TAB
-- =========================================================
visualsTab:AddLabel("--- PLAYER ESP & LIGHTING ---")

local espColorDropdown = visualsTab:AddDropdown("ESP Highlight Color", function(selected)
    if selected == "Purple Cyber" then Hub.ESPColor = Color3.fromRGB(138, 43, 226)
    elseif selected == "Cyan Neon" then Hub.ESPColor = Color3.fromRGB(0, 255, 255)
    elseif selected == "Red Fire" then Hub.ESPColor = Color3.fromRGB(255, 50, 50)
    elseif selected == "Green Emerald" then Hub.ESPColor = Color3.fromRGB(50, 255, 100) end
end)
espColorDropdown:Add("Purple Cyber")
espColorDropdown:Add("Cyan Neon")
espColorDropdown:Add("Red Fire")
espColorDropdown:Add("Green Emerald")

visualsTab:AddSwitch("Player Highlight ESP", function(state)
    Hub.PlayerESP = state
    task.spawn(function()
        while Hub.PlayerESP do
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    local hl = plr.Character:FindFirstChild("VanishESP")
                    if not hl then
                        hl = Instance.new("Highlight")
                        hl.Name = "VanishESP"
                        hl.FillColor = Hub.ESPColor or Color3.fromRGB(138, 43, 226)
                        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                        hl.FillTransparency = 0.5
                        hl.Parent = plr.Character
                    else
                        hl.FillColor = Hub.ESPColor or Color3.fromRGB(138, 43, 226)
                    end
                end
            end
            task.wait(1)
        end
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Character and plr.Character:FindFirstChild("VanishESP") then
                plr.Character.VanishESP:Destroy()
            end
        end
    end)
end)

visualsTab:AddSwitch("Fullbright (No Darkness)", function(state)
    Hub.Fullbright = state
    pcall(function()
        if state then
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            Lighting.Brightness = 2
            Lighting.GlobalShadows = false
            Lighting.ClockTime = 14
        else
            Lighting.Ambient = Color3.fromRGB(128, 128, 128)
            Lighting.Brightness = 1
            Lighting.GlobalShadows = true
        end
    end)
end)

visualsTab:AddSwitch("Remove Map Fog", function(state)
    Hub.RemoveFog = state
    pcall(function()
        Lighting.FogEnd = state and 9e9 or 1000
    end)
end)

-- =========================================================
-- 8. DISCORD WEBHOOK TRACKER TAB
-- =========================================================
webhookTab:AddLabel("--- STAT TRACKER DISCORD WEBHOOK ---")

webhookTab:AddTextBox("Enter Discord Webhook URL", function(text)
    Hub.WebhookURL = text
end)

local function sendWebhook(title, description)
    if not Hub.WebhookURL or Hub.WebhookURL == "" then return end
    local req = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
    if req then
        pcall(function()
            local payload = {
                ["embeds"] = {{
                    ["title"] = title or "Vanish Hub | Stat Update",
                    ["description"] = description or ("Player: " .. LocalPlayer.Name),
                    ["color"] = 9044223,
                    ["footer"] = {["text"] = "Vanish Hub | +1 Keyboard Escape"}
                }}
            }
            req({
                Url = Hub.WebhookURL,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode(payload)
            })
        end)
    end
end

webhookTab:AddButton("Send Test Webhook Message", function()
    sendWebhook("Vanish Hub Connected!", "Test notification successfully sent for player: " .. LocalPlayer.Name)
end)

webhookTab:AddSwitch("Auto Send Stat Updates (Every 5 Mins)", function(state)
    Hub.AutoWebhookTracker = state
    task.spawn(function()
        while Hub.AutoWebhookTracker and task.wait(300) do
            sendWebhook("Vanish Hub Automated Stat Update", "Player: " .. LocalPlayer.Name .. "\nStatus: Active Farming in +1 Keyboard Escape!")
        end
    end)
end)

-- =========================================================
-- 9. MISC & UI CONTROLS TAB
-- =========================================================
miscTab:AddLabel("--- GUI MINIMIZE & TOGGLE ---")

-- Floating Draggable Toggle Button (PC & Mobile)
local toggleGui = Instance.new("ScreenGui")
toggleGui.Name = "VanishHubToggleGui"
toggleGui.Parent = (game:GetService("CoreGui"):FindFirstChild("RobloxGui") and game:GetService("CoreGui")) or LocalPlayer:WaitForChild("PlayerGui")

local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "VanishToggleBtn"
toggleBtn.Size = UDim2.new(0, 140, 0, 35)
toggleBtn.Position = UDim2.new(0.02, 0, 0.2, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Text = "Toggle Vanish Hub"
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 15
toggleBtn.Active = true
toggleBtn.Draggable = true
toggleBtn.Parent = toggleGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = toggleBtn

local function toggleUI()
    Hub.GuiVisible = not Hub.GuiVisible
    pcall(function()
        for _, gui in ipairs(game:GetService("CoreGui"):GetChildren()) do
            if gui:IsA("ScreenGui") and (gui.Name:lower():find("elerium") or gui.Name:lower():find("library")) then
                gui.Enabled = Hub.GuiVisible
            end
        end
        if LocalPlayer.PlayerGui:FindFirstChild("Elerium") then
            LocalPlayer.PlayerGui.Elerium.Enabled = Hub.GuiVisible
        end
    end)
end

toggleBtn.MouseButton1Click:Connect(toggleUI)

UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightControl then
        toggleUI()
    end
end)

miscTab:AddButton("Minimize / Hide UI (Key: RightControl)", function()
    toggleUI()
end)

miscTab:AddLabel("--- UNIVERSAL ANTI AFK ---")

miscTab:AddButton("Anti AFK", function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XxDEMONxX-lab/Vanish-Hub-universel-anti-afk/refs/heads/main/Vanish%20Hub%20universel%20anti%20afk"))()
    end)
end)

miscTab:AddLabel("--- SERVER TOOLS ---")

miscTab:AddButton("Server Hop (Find New Server)", function()
    pcall(function()
        local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data
        for _, s in ipairs(servers) do
            if s.playing < s.maxPlayers and s.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
                break
            end
        end
    end)
end)

miscTab:AddButton("Rejoin Current Server", function()
    pcall(function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end)
end)

miscTab:AddButton("Copy Game Place ID", function()
    if setclipboard then setclipboard(tostring(game.PlaceId)) end
end)

print("[Vanish Hub | +1 Keyboard Escape] Ultimate Edition Loaded Successfully!")
