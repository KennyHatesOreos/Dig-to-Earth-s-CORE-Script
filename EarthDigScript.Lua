-- Load Luna UI safely
local lunaSource = game:HttpGet("https://raw.githubusercontent.com/Nebula-Softworks/Luna-Interface-Suite/refs/heads/main/source.lua", true)
local LunaFunc, err = loadstring(lunaSource)
if not LunaFunc then error("Failed to load Luna UI: ".. tostring(err)) end

local Luna = LunaFunc()
if not Luna then error("Luna UI returned nil") end

-- Create Window
local Window = Luna:CreateWindow({
    Name = "Digging Script",
    Subtitle = "OreoScripts",
    LoadingEnabled = true,
    LoadingTitle = "Loading OreoHub!",
    LoadingSubtitle = "Powered by Oreos",
    ConfigSettings = {
        RootFolder = nil,
        ConfigFolder = "OreoHubDiggingConfigs"
    },
    KeySystem = false,
})

local Player = game.Players.LocalPlayer

-- === MAIN TAB ===
local MainTab = Window:CreateTab({
    Name = "Main",
})

local AutoDig = false
local AutoClaimQuest = false

-- Auto Dig function
local function AutoDigFunc()
    while AutoDig do
        local args = {"hello"}
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("DigEvent"):FireServer(unpack(args))

        wait(0.5)
        local gemArgs = {14, "bye"}
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("GemEvent"):FireServer(unpack(gemArgs))

        wait(0.2)
    end
end

-- Auto Claim Quest function
local function AutoClaimQuestFunc()
    while AutoClaimQuest do
        local args = {"1Win"}
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ClaimQuestEvent"):FireServer(unpack(args))
        wait(3)
    end
end

-- Auto Dig Toggle
MainTab:CreateToggle({
    Name = "Auto Dig",
    Flag = "AutoDigToggle",
    CurrentValue = false,
    Callback = function(value)
        AutoDig = value
        if AutoDig then
            spawn(AutoDigFunc)
        end
    end,
})

MainTab:CreateDivider()

-- Auto Claim Quest Toggle
MainTab:CreateToggle({
    Name = "AutoClaimQuest",
    Flag = "AutoClaimQuestToggle",
    CurrentValue = false,
    Callback = function(value)
        AutoClaimQuest = value
        if AutoClaimQuest then
            spawn(AutoClaimQuestFunc)
        end
    end,
})

MainTab:CreateDivider()

-- Night Mode Toggle
MainTab:CreateToggle({
    Name = "Night Mode",
    Flag = "NightModeToggle",
    CurrentValue = false,
    Callback = function(value)
        local args = {"NightMode", value}
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SettingsEvent"):FireServer(unpack(args))
    end,
})

MainTab:CreateDivider()

-- Buy All Pickaxes Button in Main Tab
local pickaxes = {
    "Admin", "Angel", "Anime", "Cake", "Cosmic", "Crystal", "Diamond", "Easter", "Emoji",
    "Firework", "Future", "Glitch", "Gold", "Ice", "Iron", "Lava", "Lunar", "Neon",
    "Nuke", "Pinata", "Plushie", "Rainbow", "Stone", "Thunder", "Toy", "Unicorn",
    "Void", "Wood",
}

MainTab:CreateButton({
    Name = "Buy All Pickaxes",
    Callback = function()
        for _, pickaxeName in ipairs(pickaxes) do
            local args = {pickaxeName}
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("BuyPickaxeEvent"):FireServer(unpack(args))
            wait(0.1) -- slight delay to avoid flooding
        end
    end,
})

-- Upgrades Tab
local UpgradesTab = Window:CreateTab({
    Name = "Upgrades",
})

local validUpgrades = {
    "GemChance",
    "Strength",
    "PetLuck",
    "WalkSpeed",
}

local toggles = {}

for _, upgrade in ipairs(validUpgrades) do
    toggles[upgrade] = false
    UpgradesTab:CreateToggle({
        Name = upgrade,
        Flag = upgrade .. "Toggle",
        CurrentValue = false,
        Callback = function(value)
            toggles[upgrade] = value
            if value then
                spawn(function()
                    while toggles[upgrade] do
                        local args = {upgrade, 1}
                        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("UpgradeEvent"):FireServer(unpack(args))
                        wait(0.5)
                    end
                end)
            end
        end,
    })
end

-- Insane Tab
local InsaneTab = Window:CreateTab({
    Name = "Insane",
})

-- Infinity Symbol Tab (∞) for Infinite Spins
local InfinityTab = Window:CreateTab({
    Name = "∞",
})

local InfinitySpinsToggle = false

InfinityTab:CreateToggle({
    Name = "Infinite Spins,Money,Gems",
    Flag = "InfinitySpinsToggle",
    CurrentValue = false,
    Callback = function(value)
        InfinitySpinsToggle = value
        if value then
            spawn(function()
                while InfinitySpinsToggle do
                    local treasureArgsList = {
                        -- Removed Chest, Barrel, Key, etc. as requested
                        {"CoinStack"},
                        {"CashStack"},
                    }
                    for _, args in ipairs(treasureArgsList) do
                        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("TreasureEvent"):FireServer(unpack(args))
                        wait(0.2)
                    end
                    wait(0.5)
                end
            end)
        end
    end,
})

InsaneTab:CreateDivider()

-- World Teleport Button
InsaneTab:CreateButton({
    Name = "World Teleport (Reset to set location)",
    Callback = function()
        local args = {10}
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("WorldTeleportEvent"):FireServer(unpack(args))
    end,
})

InsaneTab:CreateDivider()

-- Auto Win Toggle
local AutoWinToggle = false
local player = game.Players.LocalPlayer

InsaneTab:CreateToggle({
    Name = "Auto Win",
    Flag = "AutoWinToggle",
    CurrentValue = false,
    Callback = function(value)
        AutoWinToggle = value
        if value then
            spawn(function()
                while AutoWinToggle do
                    local targetCFrame = CFrame.new(1, -412, -9000, 0, 0, -1, 0, 1, 0, 1, 0, 0)
                    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        player.Character.HumanoidRootPart.CFrame = targetCFrame
                    end
                    wait(1)
                end
            end)
        end
    end,
})

-- Pets Tab
local PetsTab = Window:CreateTab({
    Name = "Pets",
})

local Give50xPetToggle = false

PetsTab:CreateToggle({
    Name = "Give 50x Pet",
    Flag = "Give50xPetToggle",
    CurrentValue = false,
    Callback = function(value)
        Give50xPetToggle = value
        if value then
            spawn(function()
                while Give50xPetToggle do
                    local args = {4}
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SpinPrizeEvent"):FireServer(unpack(args))
                    wait(3)
                end
            end)
        end
    end,
})

-- Auto Gold Dominus Toggle
local AutoGoldDominusToggle = false

PetsTab:CreateToggle({
    Name = "Auto Gold Dominus",
    Flag = "AutoGoldDominusToggle",
    CurrentValue = false,
    Callback = function(value)
        AutoGoldDominusToggle = value
        if value then
            spawn(function()
                while AutoGoldDominusToggle do
                    local args = {
                        "Triple Dominus",
                        100
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("PetRemotes"):WaitForChild("GoldPetCraftEvent"):FireServer(unpack(args))
                    wait(15)
                end
            end)
        end
    end,
})

-- Auto Diamond Dominus Toggle
local AutoDiamondDominusToggle = false

PetsTab:CreateToggle({
    Name = "Auto Diamond Dominus",
    Flag = "AutoDiamondDominusToggle",
    CurrentValue = false,
    Callback = function(value)
        AutoDiamondDominusToggle = value
        if value then
            spawn(function()
                while AutoDiamondDominusToggle do
                    local args = {
                        "Gold Triple Dominus",
                        100
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("PetRemotes"):WaitForChild("DiamondPetCraftEvent"):FireServer(unpack(args))
                    wait(60)
                end
            end)
        end
    end,
})

PetsTab:CreateToggle({
    Name = "Auto Void Dominus",
    Flag = "AutoVoidDominusToggle",
    CurrentValue = false,
    Callback = function(value)
        AutoVoidDominusToggle = value
        if value then
            spawn(function()
                while AutoVoidDominusToggle do
                    local args = {
                        "Diamond Triple Dominus",
                        100
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("PetRemotes"):WaitForChild("VoidPetCraftEvent"):FireServer(unpack(args))
                    wait(500)
                end
            end)
        end
    end,
})



-- Finalize UI
Window:Ready()
