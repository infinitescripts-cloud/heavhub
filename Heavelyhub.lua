--========================================================--
-- HEAVELY HUB
-- TOTAL ROBLOX DRAMA • CAMP
-- COMPLETE UI SKELETON
--
-- Uses:
-- Luna-Interface-Suite/source.lua_no_interface_hidden.lua
--
-- CAMP ONLY
-- NO MOVIES
-- NO EXPEDITION
-- NO AUTOPLAY
-- NO ASCII
--========================================================--

--========================================================--
-- LUNA
--========================================================--

local Luna = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/infinitescripts-cloud/Luna-Interface-Suite/master/source.lua_no_interface_hidden.lua",
    true
))()

--========================================================--
-- WINDOW
--========================================================--

local Window = Luna:CreateWindow({
    Name = "Heavely Hub",
    Subtitle = "Total Roblox Drama • Camp",
    LogoID = "117588015510601",

    LoadingEnabled = true,
    LoadingTitle = "Heavely Hub (Camp)",
    LoadingSubtitle = "Loading Assets..",

    ConfigSettings = {
        RootFolder = "HeavelyHub",
        ConfigFolder = "Camp"
    },

    KeySystem = false
})

--========================================================--
-- DASHBOARD
--========================================================--
-- Dashboard uses Luna's built-in Home component.
-- Icon 2 = Dashboard.
--========================================================--

Window:CreateHomeTab({
    Icon = 2,
    SupportedExecutors = {},
    DiscordInvite = ""
})

--========================================================--
-- TABS
--========================================================--

local Main = Window:CreateTab({
    Name = "Main",
    Icon = "sports_esports",
    ImageSource = "Material",
    ShowTitle = true
})

local Challenges = Window:CreateTab({
    Name = "Challenges",
    Icon = "emoji_events",
    ImageSource = "Material",
    ShowTitle = true
})

local Characters = Window:CreateTab({
    Name = "Characters",
    Icon = "people",
    ImageSource = "Material",
    ShowTitle = true
})

local Universal = Window:CreateTab({
    Name = "Universal",
    Icon = "public",
    ImageSource = "Material",
    ShowTitle = true
})

local Tools = Window:CreateTab({
    Name = "Tools",
    Icon = "build",
    ImageSource = "Material",
    ShowTitle = true
})

local Visuals = Window:CreateTab({
    Name = "Visuals",
    Icon = "visibility",
    ImageSource = "Material",
    ShowTitle = true
})

local Settings = Window:CreateTab({
    Name = "Settings",
    Icon = "settings",
    ImageSource = "Material",
    ShowTitle = true
})

--========================================================--
-- MAIN
--========================================================--

Main:CreateSection("Votes")

Main:CreateToggle({
    Name = "Notify Votes",
    CurrentValue = false,

    Callback = function(Value)
        disconnect(voteConn)
        voteConn = nil

        if not Value then
            return
        end

        local votes = RS.Season.Voting:FindFirstChild("Votes")

        if votes then
            voteConn = votes.ChildAdded:Connect(function(vote)
                local voter, target = getVoteText(vote)

                notify(
                    "Vote",
                    voter .. " voted for " .. target
                )
            end)
        end
    end
})

Main:CreateToggle({
    Name = "Expose Votes",
    CurrentValue = false,

    Callback = function(Value)
        if Value then
            local RS = game:GetService("ReplicatedStorage")
            local season = RS:FindFirstChild("Season")
            local voting = season and season:FindFirstChild("Voting")
            local votes = voting and voting:FindFirstChild("Votes")

            if votes then
                exposeVotesConn = votes.ChildAdded:Connect(function(v)
                    local r_val = season.Players:FindFirstChild(v.Value)
                    local d_val = season.Players:FindFirstChild(v.Name)

                    local r = r_val and r_val.Value or v.Value
                    local d = d_val and d_val.Value or v.Name

                    local TextChatService = game:GetService("TextChatService")
                    local channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")

                    if channel then
                        channel:SendAsync(
                            r .. " voted for " .. d
                        )
                    end
                end)
            end
        else
            if exposeVotesConn then
                exposeVotesConn:Disconnect()
                exposeVotesConn = nil
            end
        end
    end
})

Main:CreateToggle({
    Name = "See Jury Votes (Wait for Finale)",
    CurrentValue = false,

    Callback = function(Value)
        if _G.HeavelyJuryConns then
            for _, connection in ipairs(_G.HeavelyJuryConns) do
                disconnect(connection)
            end
        end

        _G.HeavelyJuryConns = {}

        if not Value then
            return
        end

        local jury = RS.Season:FindFirstChild("Jury")

        if not jury then
            return
        end

        for _, juryMember in ipairs(jury:GetChildren()) do
            local list = juryMember:FindFirstChild("List")

            if list then
                table.insert(
                    _G.HeavelyJuryConns,
                    list.ChildAdded:Connect(function(vote)
                        notify(
                            "Jury Vote",
                            tostring(juryMember.Value)
                                .. " voted for "
                                .. tostring(vote.Value)
                        )
                    end)
                )
            end
        end
    end
})

Main:CreateToggle({
    Name = "Notify Exile Votes",
    CurrentValue = false,

    Callback = function(Value)
        disconnect(exileVotesConn)
        exileVotesConn = nil

        if not Value then
            return
        end

        local twists = RS:FindFirstChild("Season")
            and RS.Season:FindFirstChild("Twists")

        local exileVoting = twists
            and twists:FindFirstChild("ExileVoting")

        local votes = exileVoting
            and exileVoting:FindFirstChild("Votes")

        if votes then
            exileVotesConn = votes.ChildAdded:Connect(function(vote)
                local season = RS.Season

                local voterValue =
                    season.Players:FindFirstChild(vote.Value)

                local targetValue =
                    season.Players:FindFirstChild(vote.Name)

                local voter =
                    voterValue and voterValue.Value
                    or vote.Value

                local target =
                    targetValue and targetValue.Value
                    or vote.Name

                notify(
                    "Exile Vote",
                    voter .. " voted to exile " .. target
                )
            end)
        end
    end
})

Main:CreateToggle({
    Name = "Print Votes in Console",
    CurrentValue = false,

    Callback = function(Value)
        disconnect(printVotesConn)
        printVotesConn = nil

        if not Value then
            return
        end

        local votes = RS.Season.Voting:FindFirstChild("Votes")

        if votes then
            printVotesConn = votes.ChildAdded:Connect(function(vote)
                local voter, target = getVoteText(vote)

                print(
                    "[Heavely Hub] "
                    .. voter
                    .. " voted for "
                    .. target
                )
            end)
        end
    end
})

Main:CreateSection("Statue")

Main:CreateButton({
    Name = "Find Statue (60% Spawn)",
    Callback = function()
    end
})

Main:CreateButton({
    Name = "Find Statue Immediately",
    Callback = function()
    end
})

Main:CreateButton({
    Name = "Detect who has Statue",
    Callback = function()
    end
})

Main:CreateToggle({
    Name = "Bag ESP",
    CurrentValue = false,
    Callback = function(Value)
    end
})

Main:CreateToggle({
    Name = "Safety Statue ESP",
    CurrentValue = false,
    Callback = function(Value)
    end
})

Main:CreateSection("Extras")

Main:CreateButton({
    Name = "Fling / Restart Day",
    Callback = function()
    end
})

Main:CreateToggle({
    Name = "Auto Detect Round",
    CurrentValue = false,
    Callback = function(Value)
    end
})

Main:CreateToggle({
    Name = "Detect Teamers",
    CurrentValue = false,
    Callback = function(Value)
    end
})

--========================================================--
-- CHALLENGES
--========================================================--

Challenges:CreateSection("Challenges")

Challenges:CreateButton({
    Name = "Win Obby",
    Callback = function()
    end
})

Challenges:CreateToggle({
    Name = "Auto Win Obby",
    CurrentValue = false,
    Callback = function(Value)
    end
})

Challenges:CreateToggle({
    Name = "No Spinner/Sweeper Parts",
    CurrentValue = false,
    Callback = function(Value)
    end
})

Challenges:CreateToggle({
    Name = "Cliff Diving ESP",
    CurrentValue = false,
    Callback = function(Value)
    end
})

Challenges:CreateButton({
    Name = "Finish Pancake",
    Callback = function()
    end
})

Challenges:CreateButton({
    Name = "Remove all Spleef Fragments",
    Callback = function()
    end
})

Challenges:CreateButton({
    Name = "Win Block push",
    Callback = function()
    end
})

Challenges:CreateToggle({
    Name = "Auto Take Dodgeballs",
    CurrentValue = false,
    Callback = function(Value)
    end
})

Challenges:CreateToggle({
    Name = "Dodgeball Invincibility",
    CurrentValue = false,
    Callback = function(Value)
    end
})

Challenges:CreateToggle({
    Name = "Paintball Invincibility",
    CurrentValue = false,
    Callback = function(Value)
    end
})

Challenges:CreateButton({
    Name = "Auto Get all Coins & Gems",
    Callback = function()
    end
})

Challenges:CreateButton({
    Name = "Answer Math Mania",
    Callback = function()
    end
})

Challenges:CreateSlider({
    Name = "Math Mania Setback",
    Range = {0, 10},
    Increment = 0.1,
    Suffix = "s",
    CurrentValue = 0,

    Callback = function(Value)
    end
})

Challenges:CreateButton({
    Name = "Kill Everyone in Swordfight",
    Callback = function()
    end
})

--========================================================--
-- CHARACTERS
--========================================================--

Characters:CreateSection("Comeback")

Characters:CreateButton({
    Name = "Comeback as Male",
    Callback = function()
    end
})

Characters:CreateButton({
    Name = "Comeback as Female",
    Callback = function()
    end
})

Characters:CreateSection("Paid")

Characters:CreateInput({
    Name = "Name Character",
    CurrentValue = "",
    PlaceholderText = "Character Name Here...",
    ClearTextAfterFocusLost = false,

    Callback = function(Value)
    end
})

Characters:CreateButton({
    Name = "Buy Character (@60)",
    Callback = function()
    end
})

Characters:CreateDropdown({
    Name = "Select Character Symbol",

    Options = {
        "None",
        "Verified",
        "Premium",
        "Robux"
    },

    CurrentOption = {
        "None"
    },

    MultipleOptions = false,

    Callback = function(Value)
    end
})

Characters:CreateButton({
    Name = "Buy Symbol Character (@60)",
    Callback = function()
    end
})

--========================================================--
-- UNIVERSAL
--========================================================--

Universal:CreateSection("Player")

Universal:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,

    Callback = function(Value)
    end
})

Universal:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,

    Callback = function(Value)
    end
})

Universal:CreateToggle({
    Name = "Fly",
    CurrentValue = false,

    Callback = function(Value)
    end
})

Universal:CreateSlider({
    Name = "Fly Setback (Fly Speed)",
    Range = {1, 250},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 50,

    Callback = function(Value)
    end
})

Universal:CreateSlider({
    Name = "Speed Power",
    Range = {1, 350},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 16,

    Callback = function(Value)
    end
})

Universal:CreateSlider({
    Name = "Jumppower",
    Range = {1, 350},
    Increment = 1,
    Suffix = "Power",
    CurrentValue = 50,

    Callback = function(Value)
    end
})

Universal:CreateSection("Randoms")

Universal:CreateButton({
    Name = "Shaders",
    Callback = function()
    end
})

Universal:CreateButton({
    Name = "Infinite Yield",
    Callback = function()
    end
})

Universal:CreateButton({
    Name = "Energize R6",
    Callback = function()
    end
})

--========================================================--
-- TOOLS
--========================================================--

Tools:CreateSection("Utility")

Tools:CreateButton({
    Name = "FE Genesis Sniper",
    Callback = function()
    end
})

Tools:CreateSection("Teleports")

Tools:CreateButton({
    Name = "Teleport to Main Island",
    Callback = function()
    end
})

Tools:CreateButton({
    Name = "Teleport to Voting Area",
    Callback = function()
    end
})

Tools:CreateButton({
    Name = "Teleport to Spectator Island",
    Callback = function()
    end
})

Tools:CreateButton({
    Name = "Teleport to Bathroom",
    Callback = function()
    end
})

--========================================================--
-- VISUALS
--========================================================--

Visuals:CreateSection("Typefaces")

Visuals:CreateButton({
    Name = "Starborn Typeface",
    Callback = function()
    end
})

Visuals:CreateButton({
    Name = "Minecraft Typeface",
    Callback = function()
    end
})

Visuals:CreateButton({
    Name = "Typeface 3",
    Callback = function()
    end
})

Visuals:CreateButton({
    Name = "Typeface 4",
    Callback = function()
    end
})

Visuals:CreateButton({
    Name = "Reset Typeface",
    Callback = function()
    end
})

Visuals:CreateSection("Clients")

Visuals:CreateInput({
    Name = "Custom Name",
    CurrentValue = "",
    PlaceholderText = "Enter custom name...",
    ClearTextAfterFocusLost = false,

    Callback = function(Value)
    end
})

Visuals:CreateToggle({
    Name = "Rainbow Name",
    CurrentValue = false,

    Callback = function(Value)
    end
})

Visuals:CreateSlider({
    Name = "Rainbow Name Setback",
    Range = {0, 5},
    Increment = 0.1,
    CurrentValue = 0.5,

    Callback = function(Value)
    end
})

Visuals:CreateToggle({
    Name = "Rainbow Marshmallow",
    CurrentValue = false,

    Callback = function(Value)
    end
})

Visuals:CreateColorPicker({
    Name = "Color Name",
    Color = Color3.fromRGB(255, 182, 193),

    Callback = function(Value)
    end
})

Visuals:CreateButton({
    Name = "Fake #1 Leaderboard",
    Callback = function()
    end
})

Visuals:CreateSection("Skins")

Visuals:CreateDropdown({
    Name = "Skins (Client)",

    Options = {
        "None"
    },

    CurrentOption = {
        "None"
    },

    MultipleOptions = false,

    Callback = function(Value)
    end
})

Visuals:CreateDropdown({
    Name = "Marshmallows (Client)",

    Options = {
        "None"
    },

    CurrentOption = {
        "None"
    },

    MultipleOptions = false,

    Callback = function(Value)
    end
})

Visuals:CreateButton({
    Name = "Get all Skins (marsh and skins in inventory)",

    Callback = function()
    end
})

Visuals:CreateSection("Custom")

Visuals:CreateInput({
    Name = "Name Custom Skin",
    CurrentValue = "",
    PlaceholderText = "Enter skin name...",
    ClearTextAfterFocusLost = false,

    Callback = function(Value)
    end
})

Visuals:CreateDropdown({
    Name = "Shirts",

    Options = {
        "None"
    },

    CurrentOption = {
        "None"
    },

    MultipleOptions = false,

    Callback = function(Value)
    end
})

Visuals:CreateDropdown({
    Name = "Pants",

    Options = {
        "None"
    },

    CurrentOption = {
        "None"
    },

    MultipleOptions = false,

    Callback = function(Value)
    end
})

Visuals:CreateDropdown({
    Name = "Accessories",

    Options = {
        "None"
    },

    CurrentOption = {
        "None"
    },

    MultipleOptions = false,

    Callback = function(Value)
    end
})

Visuals:CreateButton({
    Name = "Save Custom Skin",

    Callback = function()
    end
})

Visuals:CreateDropdown({
    Name = "Load Custom Skin",

    Options = {
        "None"
    },

    CurrentOption = {
        "None"
    },

    MultipleOptions = false,

    Callback = function(Value)
    end
})

--========================================================--
-- SETTINGS
--========================================================--

Settings:CreateSection("Heavely Hub")

Settings:CreateLabel({
    Name = "Heavily inspired by Syla Hub and Dramaware;"
})

Settings:CreateLabel({
    Name = "V1.0 Soon Autoplay!"
})

Settings:CreateSection("Game Mode")

Settings:CreateLabel({
    Name = "Total Roblox Drama • Camp"
})

--========================================================--
-- END OF UI SKELETON
--========================================================--