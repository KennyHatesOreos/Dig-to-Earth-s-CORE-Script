-- Load Luna UI safely
local lunaSource = game:HttpGet("https://raw.githubusercontent.com/Nebula-Softworks/Luna-Interface-Suite/refs/heads/main/source.lua", true)
local LunaFunc, err = loadstring(lunaSource)
if not LunaFunc then error("Failed to load Luna UI: ".. tostring(err)) end

local Luna = LunaFunc()
if not Luna then error("Luna UI returned nil") end

-- Create Window
local Window = Luna:CreateWindow({
    Name = "Digging Script",
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

-- Create a Tab
local DigTab = Window:CreateTab({
    Name = "Main",
})

-- State variables
local AutoDig = false
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

-- Function to fire the digging remote event
local function FireDigEvent()
    local args = {
        "hello"
    }
    local remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")
    local digEvent = remotes:WaitForChild("DigEvent")
    digEvent:FireServer(unpack(args))
    print("Fired DigEvent")
end

-- Function to fire the gem remote event
local function FireGemEvent()
    local args = {
        14,
        "bye"
    }
    local remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")
    local gemEvent = remotes:WaitForChild("GemEvent")
    gemEvent:FireServer(unpack(args))
    print("Fired GemEvent")
end

-- Auto Dig toggle
DigTab:CreateToggle({
    Name = "Auto Dig",
    CurrentValue = false,
    Flag = "AutoDigToggle",
    Callback = function(value)
        AutoDig = value
        if AutoDig then
            -- Start auto firing DigEvent every 0.5 seconds
            spawn(function()
                while AutoDig do
                    FireDigEvent()
                    wait(0.5)
                end
            end)
            -- Start auto firing GemEvent every 0.2 seconds
            spawn(function()
                while AutoDig do
                    FireGemEvent()
                    wait(0.2)
                end
            end)
        end
    end
})

-- Info label
DigTab:CreateLabel("Use Auto Dig to automatically fire Dig and Gem events.")

-- Show window
Window:Ready()

