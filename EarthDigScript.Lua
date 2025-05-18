-- Load Luna UI safely
local lunaSource = game:HttpGet("https://raw.githubusercontent.com/Nebula-Softworks/Luna-Interface-Suite/refs/heads/main/source.lua", true)
local LunaFunc, err = loadstring(lunaSource)
if not LunaFunc then error("Failed to load Luna UI: ".. tostring(err)) end

local Luna = LunaFunc()
if not Luna then error("Luna UI returned nil") end

-- Create Window
local Window = Luna:CreateWindow({
    Name = "Digging Script Ver 1.1",
    Subtitle = "By YourName",
    LoadingEnabled = true,
    LoadingTitle = "Loading Digging Script...",
    LoadingSubtitle = "Powered by Luna UI",
    ConfigSettings = {
        RootFolder = nil,
        ConfigFolder = "DiggingScriptConfigs"
    },
    KeySystem = false,
})

-- Create Tabs
local DigTab = Window:CreateTab({
    Name = "Main",
})

local UpgradeTab = Window:CreateTab({
    Name = "Upgrades",
})

-- State variables
local AutoDig = false
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

-- Reference to the upgrade remote (update this path if different)
local UpgradeEvent = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("UpgradeEvent")

-- Function to simulate digging action
local function Dig()
    print("Digging...")
    -- Your actual digging logic here (e.g. fire remote, tool activation, etc)
end

-- Auto Dig toggle
DigTab:CreateToggle({
    Name = "Auto Dig",
    CurrentValue = false,
    Flag = "AutoDigToggle",
    Callback = function(value)
        AutoDig = value
        if AutoDig then
            spawn(function()
                while AutoDig do
                    Dig()
                    wait(1) -- fixed 1 second between digs, no speed slider as requested
                end
            end)
        end
    end
})

-- Info label
DigTab:CreateLabel("Use Auto Dig for automatic digging every 1 second.")

-- Helper function to auto upgrade continuously while toggle is on
local function AutoUpgrade(statName, toggleFlag)
    spawn(function()
        while Window.Flags[toggleFlag] do
            UpgradeEvent:FireServer(statName, 1) -- fixed price parameter
            print("Upgrading", statName)
            wait(0.5) -- delay between upgrades
        end
    end)
end

-- Auto Upgrades toggles
UpgradeTab:CreateToggle({
    Name = "Auto Upgrade PetLuck",
    Flag = "AutoUpgradePetLuck",
    CurrentValue = false,
    Callback = function(value)
        if value then
            AutoUpgrade("PetLuck", "AutoUpgradePetLuck")
        end
    end
})

UpgradeTab:CreateToggle({
    Name = "Auto Upgrade GemChance",
    Flag = "AutoUpgradeGemChance",
    CurrentValue = false,
    Callback = function(value)
        if value then
            AutoUpgrade("GemChance", "AutoUpgradeGemChance")
        end
    end
})

UpgradeTab:CreateToggle({
    Name = "Auto Upgrade Strength",
    Flag = "AutoUpgradeStrength",
    CurrentValue = false,
    Callback = function(value)
        if value then
            AutoUpgrade("Strength", "AutoUpgradeStrength")
        end
    end
})

UpgradeTab:CreateToggle({
    Name = "Auto Upgrade WalkSpeed",
    Flag = "AutoUpgradeWalkSpeed",
    CurrentValue = false,
    Callback = function(value)
        if value then
            AutoUpgrade("WalkSpeed", "AutoUpgradeWalkSpeed")
        end
    end
})

UpgradeTab:CreateLabel("Enable any upgrade toggle to continuously upgrade that stat.")

-- Show window
Window:Ready()
