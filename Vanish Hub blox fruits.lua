--[[
    ╔══════════════════════════════════════════════════════════════╗
    ║                                                              ║
    ║              🔥 BLOX FRUITS ULTIMATE HUB 🔥                 ║
    ║                   By: Kyriel Scripts                         ║
    ║                                                              ║
    ║  Features:                                                   ║
    ║  • Auto Farm (Quest + NPC)                                   ║
    ║  • Aimbot / Silent Aim                                       ║
    ║  • Fruit Notifier & Sniper                                   ║
    ║  • Auto Raid & Dungeon                                       ║
    ║  • Race V4 Auto                                              ║
    ║  • Teleport Hub                                              ║
    ║  • ESP (Players, Fruits, Chests, NPCs)                       ║
    ║  • Kill Aura                                                 ║
    ║  • Auto Stats                                                ║
    ║  • And more...                                               ║
    ║                                                              ║
    ╚══════════════════════════════════════════════════════════════╝
--]]

-- ============================================================
--  LOADING & SETUP
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- ============================================================
--  GUI CREATION
-- ============================================================

local function CreateUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VanishHub"
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    MainFrame.BackgroundTransparency = 0.15
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    MainFrame.Size = UDim2.new(0, 600, 0, 400)
    MainFrame.ClipsDescendants = true

    -- Drag functionality
    local Dragging = false
    local DragInput
    local DragStart
    local StartPos

    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            DragStart = input.Position
            StartPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            DragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            local Delta = input.Position - DragStart
            MainFrame.Position = UDim2.new(
                StartPos.X.Scale,
                StartPos.X.Offset + Delta.X,
                StartPos.Y.Scale,
                StartPos.Y.Offset + Delta.Y
            )
        end
    end)

    -- Title
    local Title = Instance.new("TextLabel")
    Title.Parent = MainFrame
    Title.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    Title.BackgroundTransparency = 0.3
    Title.BorderSizePixel = 0
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Font = Enum.Font.GothamBold
    Title.Text = "Vanish Hub | Blox Fruits"
    Title.TextColor3 = Color3.fromRGB(255, 200, 50)
    Title.TextSize = 20
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.TextYAlignment = Enum.TextYAlignment.Center
    Title.Padding = UDim.new(0, 10)

    -- Close Button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Parent = MainFrame
    CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Position = UDim2.new(1, -35, 0, 5)
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.TextSize = 16
    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    -- Minimize Button
    local MinBtn = Instance.new("TextButton")
    MinBtn.Parent = MainFrame
    MinBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    MinBtn.BorderSizePixel = 0
    MinBtn.Position = UDim2.new(1, -70, 0, 5)
    MinBtn.Size = UDim2.new(0, 30, 0, 30)
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.Text = "─"
    MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinBtn.TextSize = 20
    local Minimized = false
    MinBtn.MouseButton1Click:Connect(function()
        Minimized = not Minimized
        MainFrame:TweenSize(
            Minimized and UDim2.new(0, 250, 0, 45) or UDim2.new(0, 600, 0, 400),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quad,
            0.3,
            true
        )
        for _, v in pairs(MainFrame:GetChildren()) do
            if v ~= Title and v ~= CloseBtn and v ~= MinBtn and not Minimized then
                v.Visible = not Minimized
            end
        end
    end)

    -- Tab Buttons
    local TabContainer = Instance.new("Frame")
    TabContainer.Parent = MainFrame
    TabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    TabContainer.BackgroundTransparency = 0.5
    TabContainer.BorderSizePixel = 0
    TabContainer.Position = UDim2.new(0, 0, 0, 40)
    TabContainer.Size = UDim2.new(1, 0, 0, 35)

    local Tabs = {"Farm", "Combat", "Fruits", "Raid", "Race", "Teleport", "ESP", "Misc"}
    local TabButtons = {}
    local CurrentTab = "Farm"

    local function CreateTabButton(name, xPos)
        local btn = Instance.new("TextButton")
        btn.Parent = TabContainer
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        btn.BackgroundTransparency = 0.5
        btn.BorderSizePixel = 0
        btn.Position = UDim2.new(0, xPos, 0, 2)
        btn.Size = UDim2.new(0, 70, 0, 30)
        btn.Font = Enum.Font.GothamSemibold
        btn.Text = name
        btn.TextColor3 = Color3.fromRGB(200, 200, 220)
        btn.TextSize = 12
        return btn
    end

    for i, name in ipairs(Tabs) do
        local btn = CreateTabButton(name, (i - 1) * 75 + 5)
        TabButtons[name] = btn
        btn.MouseButton1Click:Connect(function()
            CurrentTab = name
            for _, v in pairs(TabButtons) do
                v.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
                v.TextColor3 = Color3.fromRGB(200, 200, 220)
            end
            btn.BackgroundColor3 = Color3.fromRGB(70, 70, 120)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            -- Hide all content frames
            for _, v in pairs(MainFrame:GetChildren()) do
                if v.Name == "ContentFrame" then
                    v.Visible = false
                end
            end
            -- Show selected content frame
            local content = MainFrame:FindFirstChild(name .. "Content")
            if content then content.Visible = true end
        end)
    end
    -- Select first tab
    TabButtons["Farm"]:MouseButton1Click:Fire()

    -- ============================================================
    --  CONTENT FRAMES
    -- ============================================================

    local function CreateContentFrame(name)
        local frame = Instance.new("ScrollingFrame")
        frame.Name = name .. "Content"
        frame.Parent = MainFrame
        frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
        frame.BackgroundTransparency = 0.3
        frame.BorderSizePixel = 0
        frame.Position = UDim2.new(0, 5, 0, 80)
        frame.Size = UDim2.new(1, -10, 1, -85)
        frame.CanvasSize = UDim2.new(0, 0, 0, 0)
        frame.ScrollBarThickness = 6
        frame.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 80)
        frame.Visible = false
        frame.AutomaticCanvasSize = Enum.AutomaticSize.Y

        local layout = Instance.new("UIListLayout")
        layout.Parent = frame
        layout.Padding = UDim.new(0, 6)
        layout.SortOrder = Enum.SortOrder.LayoutOrder

        return frame
    end

    -- Helper: Create toggle
    local function CreateToggle(parent, label, default, callback)
        local frame = Instance.new("Frame")
        frame.Parent = parent
        frame.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
        frame.BackgroundTransparency = 0.5
        frame.BorderSizePixel = 0
        frame.Size = UDim2.new(1, -10, 0, 30)

        local lbl = Instance.new("TextLabel")
        lbl.Parent = frame
        lbl.BackgroundTransparency = 1
        lbl.Position = UDim2.new(0, 10, 0, 0)
        lbl.Size = UDim2.new(0.7, 0, 1, 0)
        lbl.Font = Enum.Font.Gotham
        lbl.Text = label
        lbl.TextColor3 = Color3.fromRGB(220, 220, 240)
        lbl.TextSize = 13
        lbl.TextXAlignment = Enum.TextXAlignment.Left

        local btn = Instance.new("TextButton")
        btn.Parent = frame
        btn.BackgroundColor3 = default and Color3.fromRGB(60, 200, 80) or Color3.fromRGB(60, 60, 80)
        btn.BorderSizePixel = 0
        btn.Position = UDim2.new(0.85, 0, 0.15, 0)
        btn.Size = UDim2.new(0, 40, 0, 20)
        btn.Font = Enum.Font.GothamBold
        btn.Text = default and "ON" or "OFF"
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 11

        local state = default
        btn.MouseButton1Click:Connect(function()
            state = not state
            btn.BackgroundColor3 = state and Color3.fromRGB(60, 200, 80) or Color3.fromRGB(60, 60, 80)
            btn.Text = state and "ON" or "OFF"
            if callback then callback(state) end
        end)

        return {
            SetState = function(s)
                state = s
                btn.BackgroundColor3 = state and Color3.fromRGB(60, 200, 80) or Color3.fromRGB(60, 60, 80)
                btn.Text = state and "ON" or "OFF"
                if callback then callback(state) end
            end,
            GetState = function() return state end
        }
    end

    -- Helper: Create button
    local function CreateButton(parent, label, callback)
        local btn = Instance.new("TextButton")
        btn.Parent = parent
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
        btn.BorderSizePixel = 0
        btn.Size = UDim2.new(1, -10, 0, 30)
        btn.Font = Enum.Font.Gotham
        btn.Text = label
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 13
        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    -- Helper: Create dropdown
    local function CreateDropdown(parent, label, options, default, callback)
        local frame = Instance.new("Frame")
        frame.Parent = parent
        frame.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
        frame.BackgroundTransparency = 0.5
        frame.BorderSizePixel = 0
        frame.Size = UDim2.new(1, -10, 0, 30)

        local lbl = Instance.new("TextLabel")
        lbl.Parent = frame
        lbl.BackgroundTransparency = 1
        lbl.Position = UDim2.new(0, 10, 0, 0)
        lbl.Size = UDim2.new(0.4, 0, 1, 0)
        lbl.Font = Enum.Font.Gotham
        lbl.Text = label
        lbl.TextColor3 = Color3.fromRGB(220, 220, 240)
        lbl.TextSize = 13
        lbl.TextXAlignment = Enum.TextXAlignment.Left

        local dropdown = Instance.new("TextButton")
        dropdown.Parent = frame
        dropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        dropdown.BorderSizePixel = 0
        dropdown.Position = UDim2.new(0.45, 0, 0.05, 0)
        dropdown.Size = UDim2.new(0.5, -10, 0, 26)
        dropdown.Font = Enum.Font.Gotham
        dropdown.Text = default or options[1]
        dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
        dropdown.TextSize = 12

        local selected = default or options[1]
        dropdown.MouseButton1Click:Connect(function()
            -- Simple cycle through options
            local idx = table.find(options, selected) or 1
            idx = idx % #options + 1
            selected = options[idx]
            dropdown.Text = selected
            if callback then callback(selected) end
        end)

        return {
            GetValue = function() return selected end,
            SetValue = function(v)
                if table.find(options, v) then
                    selected = v
                    dropdown.Text = v
                    if callback then callback(v) end
                end
            end
        }
    end

    -- ============================================================
    --  FARM TAB
    -- ============================================================

    local FarmContent = CreateContentFrame("Farm")
    FarmContent.Visible = true

    local FarmToggle = CreateToggle(FarmContent, "🔄 Auto Farm", false, function(state)
        _G.AutoFarm = state
    end)

    local FarmMethod = CreateDropdown(FarmContent, "Method", {"Quest", "Nearest", "Boss"}, "Quest")

    CreateToggle(FarmContent, "⚡ Auto Attack", true, function(state)
        _G.AutoAttack = state
    end)

    CreateToggle(FarmContent, "📦 Auto Collect Chests", false, function(state)
        _G.AutoChest = state
    end)

    CreateButton(FarmContent, "📍 Bring Mobs To Me", function()
        _G.BringMobs = true
        task.wait(5)
        _G.BringMobs = false
    end)

    -- ============================================================
    --  COMBAT TAB
    -- ============================================================

    local CombatContent = CreateContentFrame("Combat")

    local AimbotToggle = CreateToggle(CombatContent, "🎯 Aimbot / Silent Aim", false, function(state)
        _G.Aimbot = state
    end)

    CreateDropdown(CombatContent, "Aimbot Mode", {"Nearest", "Lowest HP", "Cursor"}, "Nearest")

    CreateToggle(CombatContent, "💀 Kill Aura", false, function(state)
        _G.KillAura = state
    end)

    CreateToggle(CombatContent, "🛡️ Auto Block", false, function(state)
        _G.AutoBlock = state
    end)

    CreateToggle(CombatContent, "🏃 Auto Dodge", false, function(state)
        _G.AutoDodge = state
    end)

    -- ============================================================
    --  FRUITS TAB
    -- ============================================================

    local FruitContent = CreateContentFrame("Fruits")

    CreateToggle(FruitContent, "🍎 Fruit Notifier (ESP)", true, function(state)
        _G.FruitESP = state
    end)

    CreateToggle(FruitContent, "🏃 Fruit Sniper (Auto-Collect)", false, function(state)
        _G.FruitSniper = state
    end)

    CreateToggle(FruitContent, "🔄 Auto-Store Fruit", false, function(state)
        _G.AutoStoreFruit = state
    end)

    CreateButton(FruitContent, "🗺️ Show All Fruit Locations", function()
        _G.ShowFruits = true
        task.wait(10)
        _G.ShowFruits = false
    end)

    -- ============================================================
    --  RAID TAB
    -- ============================================================

    local RaidContent = CreateContentFrame("Raid")

    CreateToggle(RaidContent, "⚔️ Auto Raid", false, function(state)
        _G.AutoRaid = state
    end)

    CreateDropdown(RaidContent, "Raid Type", {"Flame", "Ice", "Quake", "Buddha", "Dough"}, "Flame")

    CreateToggle(RaidContent, "🔄 Auto Chip Farm", false, function(state)
        _G.AutoChip = state
    end)

    CreateToggle(RaidContent, "👥 Auto Join Raid", false, function(state)
        _G.AutoJoinRaid = state
    end)

    -- ============================================================
    --  RACE TAB
    -- ============================================================

    local RaceContent = CreateContentFrame("Race")

    CreateToggle(RaceContent, "🧬 Auto Race V4", false, function(state)
        _G.AutoRaceV4 = state
    end)

    CreateToggle(RaceContent, "⚡ Auto Gear (Race V4)", false, function(state)
        _G.AutoGear = state
    end)

    CreateButton(RaceContent, "📍 Teleport to Race NPC", function()
        -- Simplified teleport
        local npc = workspace:FindFirstChild("RaceNPC") or workspace:FindFirstChild("RaceGiver")
        if npc and npc:FindFirstChild("HumanoidRootPart") then
            RootPart.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 5, 5)
        end
    end)

    CreateButton(RaceContent, "🔄 Reset Race (V4)", function()
        _G.ResetRace = true
        task.wait(3)
        _G.ResetRace = false
    end)

    -- ============================================================
    --  TELEPORT TAB
    -- ============================================================

    local TeleportContent = CreateContentFrame("Teleport")

    local locations = {
        "Jungle", "Pirate Village", "Desert", "Ice Island", "Sky Islands",
        "Marine Fortress", "Graveyard", "Snow Mountain", "Hot and Cold",
        "Mansion", "Great Tree", "Castle on the Sea", "Port Town", "Kingdom of Rose"
    }

    CreateDropdown(TeleportContent, "📍 Location", locations, "Jungle", function(val)
        _G.TeleportTarget = val
    end)

    CreateButton(TeleportContent, "🚀 Teleport", function()
        local target = _G.TeleportTarget or "Jungle"
        -- Simplified teleport - find matching part
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and v.Name and string.find(string.lower(v.Name), string.lower(target)) then
                RootPart.CFrame = v.CFrame * CFrame.new(0, 5, 0)
                break
            end
        end
    end)

    CreateButton(TeleportContent, "📌 Teleport to Boss", function()
        local bosses = {"Boss", "King", "Marine", "Don", "Diamond"}
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("Model") and v:FindFirstChild("Humanoid") then
                for _, b in ipairs(bosses) do
                    if string.find(string.lower(v.Name), string.lower(b)) then
                        local hrp = v:FindFirstChild("HumanoidRootPart") or v.PrimaryPart
                        if hrp then
                            RootPart.CFrame = hrp.CFrame * CFrame.new(0, 5, 3)
                            return
                        end
                    end
                end
            end
        end
    end)

    -- ============================================================
    --  ESP TAB
    -- ============================================================

    local ESPContent = CreateContentFrame("ESP")

    CreateToggle(ESPContent, "👤 Player ESP", true, function(state)
        _G.PlayerESP = state
    end)

    CreateToggle(ESPContent, "🍎 Fruit ESP", true, function(state)
        _G.FruitESP = state
    end)

    CreateToggle(ESPContent, "📦 Chest ESP", false, function(state)
        _G.ChestESP = state
    end)

    CreateToggle(ESPContent, "👾 NPC ESP", false, function(state)
        _G.NPCESP = state
    end)

    CreateToggle(ESPContent, "💀 Boss ESP", true, function(state)
        _G.BossESP = state
    end)

    -- ============================================================
    --  MISC TAB
    -- ============================================================

    local MiscContent = CreateContentFrame("Misc")

    CreateToggle(MiscContent, "♾️ Infinite Energy", false, function(state)
        _G.InfiniteEnergy = state
    end)
