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