local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/infinitescripts-cloud/Luna-Interface-Suite/refs/heads/master/source.lua_no_interface_hidden.lua", true))()

local Window = Luna:CreateWindow({
    Name = "Heavely Hub (Camp)",
    Subtitle = "by travi",
    LogoID = "82795327169782",
    LoadingEnabled = true,
    LoadingTitle = "Heavely Hub is Loading..",
    LoadingSubtitle = "Inspired by Syla Hub!",
    ConfigSettings = {
        RootFolder = nil,
        ConfigFolder = "HeavelyHub"
    },
    KeySystem = false,
    KeySettings = {
        Title = "Luna Key System",
        Subtitle = "Key System",
        Note = "No Key System Link",
        SaveKey = true,
        Key = {"Hello"}
    }
})

-- Home Tab
Window:CreateHomeTab({
    SupportedExecutors = {},
    DiscordInvite = "https://discord.gg/nebula-softworks-1175654067332218930",
    Icon = 1
})

-- Custom Tab
local Tab = Window:CreateTab({
    Name = "Main",
    Icon = "star",
    ImageSource = "Material",
    ShowTitle = true
})

-- Custom Tab
local Tab = Window:CreateTab({
    Name = "Challenges",
    Icon = "emoji_events",
    ImageSource = "Material",
    ShowTitle = true
})

-- Custom Tab
local Tab = Window:CreateTab({
    Name = "Visuals",
    Icon = "visibility",
    ImageSource = "Material",
    ShowTitle = true
})

-- Custom Tab
local Tab = Window:CreateTab({
    Name = "Characters",
    Icon = "person",
    ImageSource = "Material",
    ShowTitle = true
})

-- Custom Tab
local Tab = Window:CreateTab({
    Name = "Universal",
    Icon = "public",
    ImageSource = "Material",
    ShowTitle = true
})

-- Built-in Theme & Config Tab
local SettingsTab = Window:CreateTab({
    Name = "Settings",
    Icon = "settings",
    ImageSource = "Material",
    ShowTitle = true
})

SettingsTab:BuildThemeSection()
SettingsTab:BuildConfigSection()

-- =======================================================
-- SECTION 1: OBBIES
-- =======================================================
MainTab:CreateSection("Obbies")

MainTab:CreateButton({
    Name = "Win Obby",
    Description = "makes you win an Obby challenge",
    Callback = function()
        local assets = workspace:FindFirstChild("Assets")
        if assets then
            local finish = assets:FindFirstChild("Finish", true)
            if finish then
                finish.CanCollide = false
                finish.Transparency = 1
                task.wait()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    finish.Position = LocalPlayer.Character.HumanoidRootPart.Position
                end
            end
        end
    end,
})

MainTab:CreateToggle({
    Name = "Auto Win Obby",
    Description = "makes you win all Obbies easily",
    Callback = function()
        getgenv().autoWinObby = not getgenv().autoWinObby
        
        task.spawn(function()
            while getgenv().autoWinObby do
                local assets = workspace:FindFirstChild("Assets")
                if assets then
                    local finish = assets:FindFirstChild("Finish", true)
                    if finish then
                        finish.CanCollide = false
                        finish.Transparency = 1
                        task.wait()
                        local char = game.Players.LocalPlayer.Character
                        if char and char:FindFirstChild("HumanoidRootPart") then
                            finish.Position = char.HumanoidRootPart.Position
                        end
                    end
                end
                task.wait(0.1)
            end
        end)
    end,
})


