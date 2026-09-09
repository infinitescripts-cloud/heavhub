--========================================================--
-- HEAVELY HUB
-- Total Roblox Drama
-- CAMP ONLY
-- Full LunaUI Skeleton
-- UI + Safe Callback Wrapper
-- NO FEATURE IMPLEMENTATIONS
--========================================================--

--// LunaUI
local Luna = loadstring(game:HttpGet(
    "https://raw.nebulasoftworks.xyz/luna",
    true
))()

--========================================================--
-- SERVICES
--========================================================--

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

--========================================================--
-- NOTIFICATION WRAPPER
--========================================================--

local function notify(title, content)
    -- Feature notification implementation goes here.
end

--========================================================--
-- SAFE CALLBACK WRAPPER
--========================================================--

local function SafeCallback(name, callback)
    if type(callback) ~= "function" then
        return function()
            warn("[Heavely Hub] Missing callback: " .. tostring(name))
        end
    end

    return function(...)
        local args = table.pack(...)

        local success, err = xpcall(function()
            callback(table.unpack(args, 1, args.n))
        end, debug.traceback)

        if not success then
            warn(
                "[Heavely Hub] "
                .. tostring(name)
                .. " Callback Error:\n"
                .. tostring(err)
            )
        end
    end
end

--========================================================--
-- TAB WRAPPER
--========================================================--

local function WrapTab(tab)
    local Wrapped = {}

    function Wrapped:CreateSection(name)
        return tab:CreateSection(name)
    end

    function Wrapped:CreateDivider()
        return tab:CreateDivider()
    end

    function Wrapped:CreateLabel(settings)
        return tab:CreateLabel(settings)
    end

    local function wrap(method)
        return function(self, settings)
            settings = settings or {}

            local copy = {}

            for key, value in pairs(settings) do
                copy[key] = value
            end

            copy.Callback = SafeCallback(
                copy.Name or method,
                copy.Callback
            )

            return tab[method](tab, copy)
        end
    end

    Wrapped.CreateButton = wrap("CreateButton")
    Wrapped.CreateToggle = wrap("CreateToggle")
    Wrapped.CreateDropdown = wrap("CreateDropdown")
    Wrapped.CreateSlider = wrap("CreateSlider")
    Wrapped.CreateInput = wrap("CreateInput")
    Wrapped.CreateColorPicker = wrap("CreateColorPicker")
    Wrapped.CreateKeybind = wrap("CreateKeybind")

    return Wrapped
end

--========================================================--
-- WINDOW
--========================================================--

local Window = Luna:CreateWindow({
    Name = "Heavely Hub",
    Subtitle = "Total Roblox Drama",
})

--========================================================--
-- MAIN
--========================================================--

local MainTab = WrapTab(Window:CreateTab({
    Name = "Main",
    Icon = "layout-dashboard",
}))

MainTab:CreateSection("Votes")

MainTab:CreateButton({
    Name = "Notify Votes",
    Callback = function()
        function(Value)
    if Value then
        local season = game.ReplicatedStorage:FindFirstChild("Season")
        local voting = season and season:FindFirstChild("Voting")
        local votes = voting and voting:FindFirstChild("Votes")

        if not votes then
            return
        end

        if NotifyVotesConnection then
            NotifyVotesConnection:Disconnect()
        end

        NotifyVotesConnection = votes.ChildAdded:Connect(function(vote)
            local players = season:FindFirstChild("Players")

            local voter = players and players:FindFirstChild(tostring(vote.Value))
            local target = players and players:FindFirstChild(tostring(vote.Name))

            local voterName = voter and tostring(voter.Value) or tostring(vote.Value)
            local targetName = target and tostring(target.Value) or tostring(vote.Name)

            notify(
                "Vote Update",
                voterName .. " voted for " .. targetName
            )
        end)
    else
        if NotifyVotesConnection then
            NotifyVotesConnection:Disconnect()
            NotifyVotesConnection = nil
        end
    end
end

MainTab:CreateButton({
    Name = "Expose Votes",
    Callback = function()
        if Value then
        local RS = game:GetService("ReplicatedStorage")
        local season = RS:FindFirstChild("Season")
        local voting = season and season:FindFirstChild("Voting")
        local votes = voting and voting:FindFirstChild("Votes")

        if votes then
            exposeVotesConn = votes.ChildAdded:Connect(function(v)
                local players = season:FindFirstChild("Players")

                local r_val = players and players:FindFirstChild(tostring(v.Value))
                local d_val = players and players:FindFirstChild(tostring(v.Name))

                local r = r_val and r_val.Value or v.Value
                local d = d_val and d_val.Value or v.Name

                pcall(function()
                    local channels = game:GetService("TextChatService"):FindFirstChild("TextChannels")
                    local channel = channels and channels:FindFirstChild("RBXGeneral")

                    if channel then
                        channel:SendAsync(
                            tostring(r) .. " voted for " .. tostring(d)
                        )
                    end
                end)
            end)
        end
    else
        if exposeVotesConn then
            exposeVotesConn:Disconnect()
            exposeVotesConn = nil
        end
    end
end

MainTab:CreateButton({
    Name = "See Jury Votes",
    Callback = function()
        function(v)
    if _G.HeavelyJuryConns then
        for _, c in ipairs(_G.HeavelyJuryConns) do
            pcall(function()
                c:Disconnect()
            end)
        end
    end

    _G.HeavelyJuryConns = {}

    if not v then
        return
    end

    local season = RS:FindFirstChild("Season")
    local jury = season and season:FindFirstChild("Jury")

    if not jury then
        return
    end

    for _, j in ipairs(jury:GetChildren()) do
        local list = j:FindFirstChild("List")

        if list then
            table.insert(
                _G.HeavelyJuryConns,
                list.ChildAdded:Connect(function(x)
                    notify(
                        "Jury Vote",
                        tostring(j.Value)
                            .. " voted for "
                            .. tostring(x.Value)
                    )
                end)
            )
        end
    end
end

MainTab:CreateButton({
    Name = "Notify Exile Votes",
    Callback = function()
        function(v)
    disconnect(exileVotesConn)
    exileVotesConn = nil

    if not v then
        return
    end

    local season = RS:FindFirstChild("Season")
    local twists = season and season:FindFirstChild("Twists")
    local exileVoting = twists and twists:FindFirstChild("ExileVoting")
    local votes = exileVoting and exileVoting:FindFirstChild("Votes")

    if not votes then
        return
    end

    exileVotesConn = votes.ChildAdded:Connect(function(vote)
        local players = season and season:FindFirstChild("Players")

        local voterValue = players and players:FindFirstChild(tostring(vote.Value))
        local targetValue = players and players:FindFirstChild(tostring(vote.Name))

        local voter = voterValue and voterValue.Value or vote.Value
        local target = targetValue and targetValue.Value or vote.Name

        notify(
            "Exile Vote",
            tostring(voter) .. " voted to exile " .. tostring(target)
        )
    end)
end

MainTab:CreateButton({
    Name = "Print Votes in Console",
    Callback = function()
        function(v)
    disconnect(printVotesConn)
    printVotesConn = nil

    if not v then
        return
    end

    local season = RS:FindFirstChild("Season")
    local voting = season and season:FindFirstChild("Voting")
    local votes = voting and voting:FindFirstChild("Votes")

    if not votes then
        return
    end

    printVotesConn = votes.ChildAdded:Connect(function(x)
        local players = season:FindFirstChild("Players")

        local voterValue = players and players:FindFirstChild(tostring(x.Value))
        local targetValue = players and players:FindFirstChild(tostring(x.Name))

        local voter = voterValue and voterValue.Value or x.Value
        local target = targetValue and targetValue.Value or x.Name

        print(tostring(voter) .. " voted for " .. tostring(target))
    end)
end

MainTab:CreateSection("Statue")

MainTab:CreateButton({
    Name = "Find Statue (60% Spawn Rate)",
    Callback = function()
        function()
    for _, v in pairs(workspace.Idols:GetDescendants()) do
        if v.Name == "Bag" or v.Name == "SafetyStatue" then
            if v:FindFirstChild("hit") and root() then
                v.hit.CanCollide = false
                v.hit.Transparency = 1
                task.wait()
                v.hit.Position = root().Position
                task.wait()
            end
        end
    end
end

MainTab:CreateButton({
    Name = "Auto Get Statue",
    Callback = function()
        function()
    local function tryGrab(v)
        if v:IsA("BasePart") and v.Name == "hit" then
            local parent = v.Parent

            if parent and (parent.Name == "Bag" or parent.Name == "SafetyStatue") then
                task.wait(0.1)

                v.CanCollide = false
                v.Transparency = 1

                task.spawn(function()
                    while v and v.Parent do
                        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            v.CFrame = player.Character.HumanoidRootPart.CFrame
                        end

                        task.wait(0.05)
                    end
                end)
            end
        end
    end

    if not _G.StatueGrabConn then
        _G.StatueGrabConn = workspace.DescendantAdded:Connect(function(v)
            tryGrab(v)
        end)
    end

    for _, v in pairs(workspace:GetDescendants()) do
        tryGrab(v)
    end
end

MainTab:CreateButton({
    Name = "Detect Who Has Statue",
    Callback = function()
        function()
    pcall(function()
        local idol = game.ReplicatedStorage.Season.Twists.Idol

        if idol.Value == "" then
            notify(
                "Statue Owner",
                "No one currently has the statue, or it did not spawn."
            )
        else
            local playerData = game.ReplicatedStorage.Season.Players:FindFirstChild(idol.Value)

            if playerData then
                notify(
                    "Statue Owner",
                    tostring(playerData.Value) .. " has the statue"
                )
            end
        end
    end)
end

MainTab:CreateToggle({
    Name = "Bag ESP",
    Callback = function()
        function(Value)
    if Value then
        local idols = workspace:FindFirstChild("Idols")
        if not idols then
            return
        end

        for _, bag in ipairs(idols:GetDescendants()) do
            if bag.Name == "Bag" and bag:IsA("Model") then
                local part = bag.PrimaryPart or bag:FindFirstChildWhichIsA("BasePart")

                if part then
                    if not bag:FindFirstChild("BagHighlight") then
                        local highlight = Instance.new("Highlight")
                        highlight.Name = "BagHighlight"
                        highlight.FillTransparency = 1
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        highlight.Parent = bag
                    end

                    if not bag:FindFirstChild("BagESP") then
                        local billboard = Instance.new("BillboardGui")
                        billboard.Name = "BagESP"
                        billboard.Size = UDim2.new(0, 220, 0, 60)
                        billboard.StudsOffset = Vector3.new(0, 3, 0)
                        billboard.AlwaysOnTop = true
                        billboard.Adornee = part
                        billboard.Parent = bag

                        local text = Instance.new("TextLabel")
                        text.Size = UDim2.new(1, 0, 1, 0)
                        text.BackgroundTransparency = 1
                        text.Text = "BAG"
                        text.TextColor3 = Color3.fromRGB(255, 255, 255)
                        text.TextStrokeTransparency = 0
                        text.TextScaled = true
                        text.Font = Enum.Font.GothamBold
                        text.Parent = billboard
                    end
                end
            end
        end
    else
        for _, bag in ipairs(workspace:GetDescendants()) do
            if bag.Name == "Bag" then
                local highlight = bag:FindFirstChild("BagHighlight")
                local esp = bag:FindFirstChild("BagESP")

                if highlight then
                    highlight:Destroy()
                end

                if esp then
                    esp:Destroy()
                end
            end
        end
    end
end

MainTab:CreateToggle({
    Name = "Safety Statue ESP",
    Callback = function()
        function(Value)
    if Value then
        for _, statue in ipairs(workspace.Idols:GetDescendants()) do
            if statue.Name == "SafetyStatue" and statue:IsA("Model") then
                local part = statue.PrimaryPart
                    or statue:FindFirstChildWhichIsA("BasePart")

                if part then
                    if not statue:FindFirstChild("StatueHighlight") then
                        local highlight = Instance.new("Highlight")
                        highlight.Name = "StatueHighlight"
                        highlight.FillTransparency = 1
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        highlight.Parent = statue
                    end

                    if not statue:FindFirstChild("StatueESP") then
                        local billboard = Instance.new("BillboardGui")
                        billboard.Name = "StatueESP"
                        billboard.Size = UDim2.new(0, 260, 0, 70)
                        billboard.StudsOffset = Vector3.new(0, 4, 0)
                        billboard.AlwaysOnTop = true
                        billboard.Adornee = part
                        billboard.Parent = statue

                        local text = Instance.new("TextLabel")
                        text.Size = UDim2.new(1, 0, 1, 0)
                        text.BackgroundTransparency = 1
                        text.Text = "SAFETY STATUE"
                        text.TextColor3 = Color3.fromRGB(255, 255, 255)
                        text.TextStrokeTransparency = 0
                        text.TextScaled = true
                        text.Font = Enum.Font.GothamBold
                        text.Parent = billboard
                    end
                end
            end
        end
    else
        for _, statue in ipairs(workspace:GetDescendants()) do
            if statue.Name == "SafetyStatue" then
                local highlight = statue:FindFirstChild("StatueHighlight")
                local esp = statue:FindFirstChild("StatueESP")

                if highlight then
                    highlight:Destroy()
                end

                if esp then
                    esp:Destroy()
                end
            end
        end
    end
end

MainTab:CreateSection("Round")

MainTab:CreateButton({
    Name = "Fling/Restart Day",
    Callback = function()
        function()
    loadstring(game:HttpGet(
        "https://raw.githubusercontent.com/robloxcheatck/reanimatescript/main/script.lua",
        true
    ))()
end

MainTab:CreateToggle({
    Name = "Auto Detect Round",
    Callback = function()
        function(Value)
    if Value then
        local t = game.ReplicatedStorage.Season.Twists:FindFirstChild("CurrentTwist")

        if not t then
            return
        end

        if autoDetectRoundConn then
            autoDetectRoundConn:Disconnect()
            autoDetectRoundConn = nil
        end

        autoDetectRoundConn = t:GetPropertyChangedSignal("Value"):Connect(function()
            local roundNames = {
                normal = "Normal Round - nothing special yet.",
                purge = "Special Round! - This will be a purge round.",
                ["double"] = "Special Round! - Two people will be eliminated.",
                singleswap = "Special Round! - SIKE! Eliminated player gets swapped to another team.",
                exile = "Special Round! - There will be an exile vote.",
                votereveal = "Special Round! - Kyle will expose the votes this round.",
            }

            local content = roundNames[t.Value]

            if content then
                notify("Round Detected", content)
            end
        end)
    else
        if autoDetectRoundConn then
            autoDetectRoundConn:Disconnect()
            autoDetectRoundConn = nil
        end
    end
end

MainTab:CreateButton({
    Name = "Detect Teamers",
    Callback = function()
        function()
    local Players = game:GetService("Players")
    local RS = game:GetService("ReplicatedStorage")

    local season = RS:FindFirstChild("Season")
    if not season then
        return
    end

    local playersFolder = season:FindFirstChild("Players")
    if not playersFolder then
        return
    end

    local function getInGameName(player)
        local data = playersFolder:FindFirstChild(player.Name)

        if data and data.Value ~= "" then
            return tostring(data.Value)
        end

        return player.DisplayName
    end

    local function getRoot(player)
        local character = player.Character
        return character and character:FindFirstChild("HumanoidRootPart")
    end

    local teams = {}

    for _, player in ipairs(Players:GetPlayers()) do
        local team = player.Team

        if team then
            teams[team] = teams[team] or {}
            table.insert(teams[team], player)
        end
    end

    local suspects = {}

    for team, members in pairs(teams) do
        if #members >= 2 then
            for i = 1, #members - 1 do
                for j = i + 1, #members do
                    local a = getRoot(members[i])
                    local b = getRoot(members[j])

                    if a and b then
                        local distance = (a.Position - b.Position).Magnitude

                        if distance <= 12 then
                            table.insert(
                                suspects,
                                getInGameName(members[i])
                                    .. " is teaming with "
                                    .. getInGameName(members[j])
                            )
                        end
                    end
                end
            end
        end
    end

    if #suspects == 0 then
        notify("Teamers", "No possible teamers detected.")
    else
        notify("Possible Teamers", table.concat(suspects, "\n"))
    end
end

--========================================================--
-- CHALLENGES
--========================================================--

local ChallengesTab = WrapTab(Window:CreateTab({
    Name = "Challenges",
    Icon = "trophy",
}))

ChallengesTab:CreateSection("Challenges")

-- Challenge controls go here.
-- No feature implementations.

--========================================================--
-- CHARACTERS
--========================================================--

local CharactersTab = WrapTab(Window:CreateTab({
    Name = "Characters",
    Icon = "user-round",
}))

CharactersTab:CreateSection("Comeback")

CharactersTab:CreateButton({
    Name = "Comeback as Male",
    Callback = function()
        -- Function goes here.
    end,
})

CharactersTab:CreateButton({
    Name = "Comeback as Female",
    Callback = function()
        -- Function goes here.
    end,
})

CharactersTab:CreateSection("Paid")

CharactersTab:CreateInput({
    Name = "Name Character",
    PlaceholderText = "Character Name",
    Callback = function()
        -- Function goes here.
    end,
})

CharactersTab:CreateButton({
    Name = "Buy Character (@60)",
    Callback = function()
        -- Function goes here.
    end,
})

CharactersTab:CreateDropdown({
    Name = "Select Character Symbol",
    Options = {},
    CurrentOption = {},
    Callback = function()
        -- Function goes here.
    end,
})

CharactersTab:CreateButton({
    Name = "Buy Symbol Character (@60)",
    Callback = function()
        -- Function goes here.
    end,
})

--========================================================--
-- UNIVERSAL
--========================================================--

local UniversalTab = WrapTab(Window:CreateTab({
    Name = "Universal",
    Icon = "globe",
}))

UniversalTab:CreateSection("Player")

UniversalTab:CreateToggle({
    Name = "Infinite Jump",
    Callback = function()
        -- Function goes here.
    end,
})

UniversalTab:CreateToggle({
    Name = "Noclip",
    Callback = function()
        -- Function goes here.
    end,
})

UniversalTab:CreateToggle({
    Name = "Fly",
    Callback = function()
        -- Function goes here.
    end,
})

UniversalTab:CreateSlider({
    Name = "Fly Setback",
    Range = {1, 500},
    Increment = 1,
    CurrentValue = 50,
    Callback = function()
        -- Function goes here.
    end,
})

UniversalTab:CreateSlider({
    Name = "Speed Power",
    Range = {1, 500},
    Increment = 1,
    CurrentValue = 16,
    Callback = function()
        -- Function goes here.
    end,
})

UniversalTab:CreateSlider({
    Name = "JumpPower",
    Range = {1, 500},
    Increment = 1,
    CurrentValue = 50,
    Callback = function()
        -- Function goes here.
    end,
})

UniversalTab:CreateSection("Randoms")

UniversalTab:CreateToggle({
    Name = "Shaders",
    Callback = function()
        -- Function goes here.
    end,
})

UniversalTab:CreateButton({
    Name = "Infinite Yield",
    Callback = function()
        -- Function goes here.
    end,
})

UniversalTab:CreateButton({
    Name = "Energize R6",
    Callback = function()
        -- Function goes here.
    end,
})

--========================================================--
-- TOOLS
--========================================================--

local ToolsTab = WrapTab(Window:CreateTab({
    Name = "Tools",
    Icon = "wrench",
}))

ToolsTab:CreateSection("Utility")

ToolsTab:CreateButton({
    Name = "FE Genesis Sniper",
    Callback = function()
        -- Function goes here.
    end,
})

ToolsTab:CreateSection("Teleports")

ToolsTab:CreateButton({
    Name = "Teleport to Main Island",
    Callback = function()
        -- Function goes here.
    end,
})

ToolsTab:CreateButton({
    Name = "Teleport to Voting Area",
    Callback = function()
        -- Function goes here.
    end,
})

ToolsTab:CreateButton({
    Name = "Teleport to Spectator Island",
    Callback = function()
        -- Function goes here.
    end,
})

ToolsTab:CreateButton({
    Name = "Teleport to Bathroom",
    Callback = function()
        -- Function goes here.
    end,
})

--========================================================--
-- VISUALS
--========================================================--

local VisualsTab = WrapTab(Window:CreateTab({
    Name = "Visuals",
    Icon = "eye",
}))

VisualsTab:CreateSection("Typefaces")

VisualsTab:CreateButton({
    Name = "Starborn Typeface",
    Callback = function()
        -- Function goes here.
    end,
})

VisualsTab:CreateButton({
    Name = "Minecraft Typeface",
    Callback = function()
        -- Function goes here.
    end,
})

VisualsTab:CreateButton({
    Name = "Typeface 3",
    Callback = function()
        -- Function goes here.
    end,
})

VisualsTab:CreateButton({
    Name = "Typeface 4",
    Callback = function()
        -- Function goes here.
    end,
})

VisualsTab:CreateButton({
    Name = "Reset Typeface",
    Callback = function()
        -- Function goes here.
    end,
})

VisualsTab:CreateSection("Clients")

VisualsTab:CreateInput({
    Name = "Custom Name",
    PlaceholderText = "Enter name",
    Callback = function()
        -- Function goes here.
    end,
})

VisualsTab:CreateToggle({
    Name = "Rainbow Name",
    Callback = function()
        -- Function goes here.
    end,
})

VisualsTab:CreateSlider({
    Name = "Rainbow Name Setback",
    Range = {1, 100},
    Increment = 1,
    CurrentValue = 10,
    Callback = function()
        -- Function goes here.
    end,
})

VisualsTab:CreateToggle({
    Name = "Rainbow Marshmallow",
    Callback = function()
        -- Function goes here.
    end,
})

VisualsTab:CreateColorPicker({
    Name = "Color Name",
    Color = Color3.fromRGB(255, 255, 255),
    Callback = function()
        -- Function goes here.
    end,
})

VisualsTab:CreateButton({
    Name = "Fake #1 Leaderboard",
    Callback = function()
        -- Function goes here.
    end,
})

VisualsTab:CreateSection("Skins")

VisualsTab:CreateDropdown({
    Name = "Skins",
    Options = {},
    CurrentOption = {},
    Callback = function()
        -- Function goes here.
    end,
})

VisualsTab:CreateDropdown({
    Name = "Marshmallows",
    Options = {},
    CurrentOption = {},
    Callback = function()
        -- Function goes here.
    end,
})

VisualsTab:CreateButton({
    Name = "Get all Skins",
    Callback = function()
        -- Function goes here.
    end,
})

VisualsTab:CreateSection("Custom")

VisualsTab:CreateInput({
    Name = "Name Custom Skin",
    PlaceholderText = "Custom Skin Name",
    Callback = function()
        -- Function goes here.
    end,
})

VisualsTab:CreateDropdown({
    Name = "Shirts",
    Options = {},
    CurrentOption = {},
    Callback = function()
        -- Function goes here.
    end,
})

VisualsTab:CreateDropdown({
    Name = "Pants",
    Options = {},
    CurrentOption = {},
    Callback = function()
        -- Function goes here.
    end,
})

VisualsTab:CreateDropdown({
    Name = "Accessories",
    Options = {},
    CurrentOption = {},
    Callback = function()
        -- Function goes here.
    end,
})

VisualsTab:CreateButton({
    Name = "Save Custom Skin",
    Callback = function()
        -- Function goes here.
    end,
})

VisualsTab:CreateDropdown({
    Name = "Load Custom Skin",
    Options = {},
    CurrentOption = {},
    Callback = function()
        -- Function goes here.
    end,
})

--========================================================--
-- SETTINGS
--========================================================--

local SettingsTab = WrapTab(Window:CreateTab({
    Name = "Settings",
    Icon = "settings",
}))

SettingsTab:CreateSection("Information")

SettingsTab:CreateLabel({
    Text = "Heavily inspired by Syla Hub and Dramaware ♥️",
    Style = 1,
})

SettingsTab:CreateLabel({
    Text = "V1.0 Soon Autoplay ♥️",
    Style = 1,
})

--========================================================--
-- END
--========================================================--