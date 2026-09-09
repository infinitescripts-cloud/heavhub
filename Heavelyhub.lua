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
