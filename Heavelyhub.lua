--// Surreal Hub
--// Total Roblox Drama - Camp
--// UI: Luna Interface Suite

local Luna = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/infinitescripts-cloud/Luna-Interface-Suite/master/source.lua_no_interface_hidden.lua",
    true
))()

--==================================================
-- WINDOW
--==================================================

local Window = Luna:CreateWindow({
    Name = "Surreal Hub (Camp)",
    Subtitle = "Inspired by DW and Syla Hub!",
    LogoID = "108950683571835",

    LoadingEnabled = true,
    LoadingTitle = "Surreal Hub",
    LoadingSubtitle = "Loading Surreal Hub...",

    ConfigSettings = {
        RootFolder = nil,
        ConfigFolder = "Surreal Hub"
    },

    KeySystem = false,

    KeySettings = {
        Title = "Surreal Hub",
        Subtitle = "Key System",
        Note = "",
        SaveInRoot = false,
        SaveKey = false,
        Key = {""},

        SecondAction = {
            Enabled = false,
            Type = "Link",
            Parameter = ""
        }
    }
})

--==================================================
-- HOME / DASHBOARD
--==================================================

Window:CreateHomeTab({
    SupportedExecutors = {},
    DiscordInvite = "",
    Icon = 2
})

--==================================================
-- MAIN
--==================================================

local Main = Window:CreateTab({
    Name = "Main",
    Icon = "view_in_ar",
    ImageSource = "Material",
    ShowTitle = true
})

Main:CreateSection("Votes")

Main:CreateToggle({
    Name = "Notify Votes",
    CurrentValue = false,
    Callback = function(Value)
        -- FUNCTION: Notify Votes
    end
}, "NotifyVotes")

Main:CreateToggle({
    Name = "Expose Votes",
    CurrentValue = false,
    Callback = function(Value)
        -- FUNCTION: Expose Votes
    end
}, "ExposeVotes")

Main:CreateToggle({
    Name = "View Jury Votes",
    CurrentValue = false,
    Callback = function(Value)
        -- FUNCTION: View Jury Votes
    end
}, "ViewJuryVotes")

Main:CreateToggle({
    Name = "View Exile Votes",
    CurrentValue = false,
    Callback = function(Value)
        -- FUNCTION: View Exile Votes
    end
}, "ViewExileVotes")

Main:CreateToggle({
    Name = "Print Votes",
    CurrentValue = false,
    Callback = function(Value)
        -- FUNCTION: Print Jury / Exile / Notify Votes
    end
}, "PrintVotes")

Main:CreateSection("Statue")

Main:CreateButton({
    Name = "Find Statue (60% Spawn)",
    Callback = function()
        -- FUNCTION: Find Statue
    end
})

Main:CreateButton({
    Name = "Get Statue on Spawn",
    Callback = function()
        -- FUNCTION: Get Statue on Spawn
    end
})

Main:CreateButton({
    Name = "Detect Who has Statue",
    Callback = function()
        -- FUNCTION: Detect Who Has Statue
    end
})

Main:CreateToggle({
    Name = "Bag ESP",
    CurrentValue = false,
    Callback = function(Value)
        -- FUNCTION: Bag ESP
    end
}, "BagESP")

Main:CreateToggle({
    Name = "Safety Statue ESP",
    CurrentValue = false,
    Callback = function(Value)
        -- FUNCTION: Safety Statue ESP
    end
}, "SafetyStatueESP")

Main:CreateSection("Extras")

Main:CreateToggle({
    Name = "Auto Detect Round",
    CurrentValue = false,
    Callback = function(Value)
        -- FUNCTION: Auto Detect Round
    end
}, "AutoDetectRound")

Main:CreateButton({
    Name = "Detect Teamers",
    Callback = function()
        -- FUNCTION: Detect Teamers
    end
})

Main:CreateButton({
    Name = "Remove Cutscenes",
    Callback = function()
        -- FUNCTION: Remove Cutscenes
    end
})

Main:CreateButton({
    Name = "Destroy Extravagant Names",
    Callback = function()
        -- FUNCTION: Destroy Extravagant Names
    end
})

--==================================================
-- CHALLENGES
--==================================================

local Challenges = Window:CreateTab({
    Name = "Challenges",
    Icon = "emoji_events",
    ImageSource = "Material",
    ShowTitle = true
})

Challenges:CreateSection("Challenges")

Challenges:CreateButton({
    Name = "Win Obby",
    Callback = function()
        -- FUNCTION: Win Obby
    end
})

Challenges:CreateToggle({
    Name = "Auto Win Obby",
    CurrentValue = false,
    Callback = function(Value)
        -- FUNCTION: Auto Win Obby
    end
}, "AutoWinObby")

Challenges:CreateButton({
    Name = "Remove all Spleef Studs",
    Callback = function()
        -- FUNCTION: Remove all Spleef Studs
    end
})

Challenges:CreateButton({
    Name = "Finish Pancake",
    Callback = function()
        -- FUNCTION: Finish Pancake
    end
})

Challenges:CreateToggle({
    Name = "Cliff Diving ESP",
    CurrentValue = false,
    Callback = function(Value)
        -- FUNCTION: Cliff Diving ESP
    end
}, "CliffDivingESP")

Challenges:CreateToggle({
    Name = "Auto Get All Coins",
    CurrentValue = false,
    Callback = function(Value)
        -- FUNCTION: Auto Get All Coins
    end
}, "AutoGetCoins")

Challenges:CreateToggle({
    Name = "Answer Math Mania",
    CurrentValue = false,
    Callback = function(Value)
        -- FUNCTION: Answer Math Mania
    end
}, "AnswerMathMania")

Challenges:CreateSlider({
    Name = "Math Mania Setback",
    Range = {0, 100},
    Increment = 1,
    CurrentValue = 0,
    Callback = function(Value)
        -- FUNCTION: Math Mania Setback
    end
}, "MathManiaSetback")

Challenges:CreateButton({
    Name = "Win Blockpush",
    Callback = function()
        -- FUNCTION: Win Blockpush
    end
})

Challenges:CreateToggle({
    Name = "Dodgeball Invincibility",
    CurrentValue = false,
    Callback = function(Value)
        -- FUNCTION: Dodgeball Invincibility
    end
}, "DodgeballInvincibility")

Challenges:CreateButton({
    Name = "Get Dodgeballs",
    Callback = function()
        -- FUNCTION: Get Dodgeballs
    end
})

Challenges:CreateToggle({
    Name = "Paintball Invincibility",
    CurrentValue = false,
    Callback = function(Value)
        -- FUNCTION: Paintball Invincibility
    end
}, "PaintballInvincibility")

Challenges:CreateButton({
    Name = "Kill Everyone in Swordfight",
    Callback = function()
        -- FUNCTION: Kill Everyone in Swordfight
    end
})

--==================================================
-- MORPHS
--==================================================

local Morphs = Window:CreateTab({
    Name = "Morphs",
    Icon = "accessibility_new",
    ImageSource = "Material",
    ShowTitle = true
})

Morphs:CreateSection("Comebacks")

Morphs:CreateButton({
    Name = "Comeback as Male",
    Callback = function()
        -- FUNCTION: Comeback as Male
    end
})

Morphs:CreateButton({
    Name = "Comeback as Female",
    Callback = function()
        -- FUNCTION: Comeback as Female
    end
})

Morphs:CreateSection("Paid")

Morphs:CreateInput({
    Name = "Character Name",
    PlaceholderText = "Enter character name...",
    CurrentValue = "",
    Numeric = false,
    MaxCharacters = nil,
    Enter = false,
    Callback = function(Value)
        -- FUNCTION: Character Name
    end
})

Morphs:CreateButton({
    Name = "Buy Character (@60)",
    Callback = function()
        -- FUNCTION: Buy Character
    end
})

Morphs:CreateDropdown({
    Name = "Select Symbol",
    Options = {},
    CurrentOption = {},
    MultipleOptions = false,
    Callback = function(Value)
        -- FUNCTION: Select Symbol
    end
})

Morphs:CreateButton({
    Name = "Buy Symbol (@60)",
    Callback = function()
        -- FUNCTION: Buy Symbol
    end
})

Morphs:CreateSection("Extras")

Morphs:CreateButton({
    Name = "Get all Skins (client)",
    Callback = function()
        -- FUNCTION: Get all Skins
    end
})

Morphs:CreateDropdown({
    Name = "Skins",
    Options = {},
    CurrentOption = {},
    MultipleOptions = false,
    Callback = function(Value)
        -- FUNCTION: Skins Dropdown
    end
})

Morphs:CreateDropdown({
    Name = "Marshmallows",
    Options = {},
    CurrentOption = {},
    MultipleOptions = false,
    Callback = function(Value)
        -- FUNCTION: Marshmallows Dropdown
    end
})

Morphs:CreateSection("Custom Morph")

Morphs:CreateInput({
    Name = "Name Morph",
    PlaceholderText = "Enter morph name...",
    CurrentValue = "",
    Numeric = false,
    MaxCharacters = nil,
    Enter = false,
    Callback = function(Value)
        -- FUNCTION: Name Morph
    end
})

Morphs:CreateDropdown({
    Name = "Shirts",
    Options = {},
    CurrentOption = {},
    MultipleOptions = false,
    Callback = function(Value)
        -- FUNCTION: Shirts Dropdown
    end
})

Morphs:CreateDropdown({
    Name = "Pants",
    Options = {},
    CurrentOption = {},
    MultipleOptions = false,
    Callback = function(Value)
        -- FUNCTION: Pants Dropdown
    end
})

Morphs:CreateButton({
    Name = "Save Custom Morph",
    Callback = function()
        -- FUNCTION: Save Custom Morph
    end
})

Morphs:CreateDropdown({
    Name = "Select Saved Custom Morph",
    Options = {},
    CurrentOption = {},
    MultipleOptions = false,
    Callback = function(Value)
        -- FUNCTION: Select Saved Custom Morph
    end
})

--==================================================
-- VISUALS
--==================================================

local Visuals = Window:CreateTab({
    Name = "Visuals",
    Icon = "visibility",
    ImageSource = "Material",
    ShowTitle = true
})

Visuals:CreateSection("Typefaces")

Visuals:CreateButton({
    Name = "Starborn Typeface",
    Callback = function()
        -- FUNCTION: Starborn Typeface
    end
})

Visuals:CreateButton({
    Name = "Minecraft Typeface",
    Callback = function()
        -- FUNCTION: Minecraft Typeface
    end
})

Visuals:CreateButton({
    Name = "Fredoka One Typeface",
    Callback = function()
        -- FUNCTION: Fredoka One Typeface
    end
})

Visuals:CreateSection("Custom")

Visuals:CreateInput({
    Name = "Character Name",
    PlaceholderText = "Enter character name...",
    CurrentValue = "",
    Numeric = false,
    MaxCharacters = nil,
    Enter = false,
    Callback = function(Value)
        -- FUNCTION: Character Name
    end
})

Visuals:CreateToggle({
    Name = "Rainbow Name",
    CurrentValue = false,
    Callback = function(Value)
        -- FUNCTION: Rainbow Name
    end
}, "RainbowName")

Visuals:CreateSlider({
    Name = "Rainbow Setback",
    Range = {0, 100},
    Increment = 1,
    CurrentValue = 0,
    Callback = function(Value)
        -- FUNCTION: Rainbow Setback
    end
}, "RainbowSetback")

Visuals:CreateButton({
    Name = "Rainbow Marshmallow",
    Callback = function()
        -- FUNCTION: Rainbow Marshmallow
    end
})

Visuals:CreateColorPicker({
    Name = "Name Color",
    Color = Color3.fromRGB(255, 255, 255),
    Callback = function(Value)
        -- FUNCTION: Name Color
    end
})

--==================================================
-- UTILITIES
--==================================================

local Utilities = Window:CreateTab({
    Name = "Utilities",
    Icon = "build",
    ImageSource = "Material",
    ShowTitle = true
})

Utilities:CreateSection("Utility")

Utilities:CreateButton({
    Name = "FE Genesis Sniper",
    Callback = function()
        -- FUNCTION: FE Genesis Sniper
    end
})

Utilities:CreateSection("More")

Utilities:CreateButton({
    Name = "Shaders",
    Callback = function()
        -- FUNCTION: Shaders
    end
})

Utilities:CreateButton({
    Name = "Infinite Yield",
    Callback = function()
        -- FUNCTION: Infinite Yield
    end
})

Utilities:CreateButton({
    Name = "Energize R6",
    Callback = function()
        -- FUNCTION: Energize R6
    end
})

Utilities:CreateButton({
    Name = "Christmas Map",
    Callback = function()
        -- FUNCTION: Christmas Map
    end
})

Utilities:CreateButton({
    Name = "Halloween Map",
    Callback = function()
        -- FUNCTION: Halloween Map
    end
})

Utilities:CreateButton({
    Name = "Valentines Map",
    Callback = function()
        -- FUNCTION: Valentines Map
    end
})

--==================================================
-- LOAD CONFIG
--==================================================

Luna:LoadAutoloadConfig()