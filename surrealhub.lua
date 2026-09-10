--[[
    Surreal Hub
    Total Roblox Drama — Camp
    Interface: Luna
]]

--==================================================
-- LOAD LUNA
--==================================================

local Luna = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/infinitescripts-cloud/Luna-Interface-Suite/master/source.lua_no_interface_hidden.lua",
    true
))()

if not Luna then
    return warn("[Surreal Hub] Failed to load Luna Interface Suite.")
end

--==================================================
-- SERVICES
--==================================================

local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")
local HttpService       = game:GetService("HttpService")
local TextChatService   = game:GetService("TextChatService")
local Lighting          = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local Camera      = workspace.CurrentCamera
local RS          = ReplicatedStorage
local CONFIG_ROOT = "Surreal Hub"

--==================================================
-- EXECUTOR FALLBACKS
--==================================================

local function ensureFunction(name, fallback)
    local env = getfenv(0)
    if type(env[name]) ~= "function" then env[name] = fallback end
end

ensureFunction("writefile",         function() end)
ensureFunction("readfile",          function() return "" end)
ensureFunction("makefolder",        function() end)
ensureFunction("isfile",            function() return false end)
ensureFunction("isfolder",          function() return false end)
ensureFunction("listfiles",         function() return {} end)
ensureFunction("delfile",           function() end)
ensureFunction("getcustomasset",    function() return "" end)
ensureFunction("firetouchinterest", function() end)
ensureFunction("fireclickdetector", function() end)
ensureFunction("getconnections",    function() return {} end)
ensureFunction("request",           http_request or (syn and syn.request) or function() end)

--[[ Part 2/10 — Utilities Module ]]

local Utilities = {}

function Utilities.notify(title, content, duration)
    pcall(function()
        Luna:Notification({
            Title    = title,
            Content  = content,
            Duration = duration or 4,
            Image    = "bell-ring",
        })
    end)
end

function Utilities.forEachDescendant(root, className, callback)
    for _, obj in ipairs(root:GetDescendants()) do
        if obj:IsA(className) then
            pcall(callback, obj)
        end
    end
end

function Utilities.forEachBasePart(callback)
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("MeshPart") then
            pcall(callback, obj)
        end
    end
end

function Utilities.nameContains(part, needle)
    return part.Name:lower():find(needle, 1, true) ~= nil
end

function Utilities.hasBrick(part, name)
    return part.BrickColor.Name:lower() == name:lower()
end

function Utilities.character()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

function Utilities.rootPart()
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

function Utilities.humanoid()
    local char = LocalPlayer.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

function Utilities.teleportTo(x, y, z)
    local root = Utilities.rootPart()
    if root then
        root.CFrame = CFrame.new(x, y, z)
    end
end

--[[ Part 3/10 — Registry & Typefaces ]]

--==================================================
-- UTILITY REGISTRY
--==================================================

local UtilityRegistry = {
    {
        id      = "genesis_sniper",
        name    = "Genesis Sniper",
        source  = "https://raw.githubusercontent.com/GenesisFE/Genesis/main/Obfuscations/Sniper",
        enabled = true,
    },
    {
        id      = "infinite_yield",
        name    = "Infinite Yield",
        source  = "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source",
        enabled = true,
    },
    {
        id      = "energize",
        name    = "Energize",
        source  = "https://pastebin.com/raw/Cfeu2ZPc",
        enabled = true,
    },
}

function Utilities.launchUtility(id)
    for _, entry in ipairs(UtilityRegistry) do
        if entry.id == id and entry.enabled then
            local ok, chunk = pcall(function()
                return game:HttpGet(entry.source, true)
            end)
            if ok and chunk then
                local fn = loadstring(chunk)
                if fn then
                    task.spawn(fn)
                    Utilities.notify("Utility Loaded", entry.name, 3)
                end
            end
            return
        end
    end
end

--==================================================
-- TYPEFACE MANAGER
--==================================================

local TypefaceManager = {}

local TYPEFACE_BLACKLIST = {
    "Chat", "BubbleChat", "ChatChannelParentFrame", "MessageLogDisplay",
    "DevConsoleMaster", "DeveloperConsole", "RobloxGui", "RobloxPromptGui",
    "PlayerList", "StatLabel", "StatusText",
}

local function applyTypefaceToObject(obj, jsonName, attrKey, scale)
    if not (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")) then return end
    if obj:FindFirstAncestorOfClass("CoreGui") or obj:FindFirstAncestor("RobloxGui") then return end
    for _, blocked in ipairs(TYPEFACE_BLACKLIST) do
        if obj.Name == blocked or obj:FindFirstAncestor(blocked) then return end
    end
    obj.FontFace = Font.new(getcustomasset(jsonName))
    if not obj:GetAttribute(attrKey) then
        if obj.TextSize > 0 then
            obj.TextSize = math.clamp(obj.TextSize * scale, 8, 100)
        end
        obj:SetAttribute(attrKey, true)
    end
end

function TypefaceManager.load(id, displayName, ttfFile, jsonFile, source, attrKey)
    local http = game:GetService("HttpService")

    if not isfile(ttfFile) then
        writefile(ttfFile, game:HttpGet(source))
    end

    writefile(jsonFile, http:JSONEncode({
        name  = displayName,
        faces = {{
            name    = "Regular",
            weight  = 400,
            style   = "normal",
            assetId = getcustomasset(ttfFile),
        }},
    }))

    for _, obj in ipairs(game:GetDescendants()) do
        pcall(applyTypefaceToObject, obj, jsonFile, attrKey, 0.6)
    end

    game.DescendantAdded:Connect(function(obj)
        task.wait(0.1)
        pcall(applyTypefaceToObject, obj, jsonFile, attrKey, 0.6)
    end)

    Utilities.notify("Typeface Applied", displayName .. " is now active.", 4)
end

--[[ Part 5/10 — Runtime State, Window, Tabs ]]

--==================================================
-- RUNTIME STATE
--==================================================

local State = {
    voteConn        = nil,
    exposeConn      = nil,
    juryConn        = nil,
    exileConn       = nil,
    printConn       = nil,
    roundConn       = nil,
    swordFightConn  = nil,
    statueConn      = nil,

    autoWinObby     = false,
    autoCollect     = false,
    autoMath        = false,
    mathDelay       = 0,
    dodgeballGuard  = false,
    paintballGuard  = false,

    cliffESP         = false,
    cliffObjects     = {},
    cliffAddedConn   = nil,
    cliffRemovedConn = nil,
    cliffRenderConn  = nil,

    nameplatesEnabled   = false,
    nameplatePlayerConn = nil,
    nameplateCharConns  = {},

    waterWalkEnabled = false,
}

--==================================================
-- WINDOW
--==================================================

local Window = Luna:CreateWindow({
    Name            = "Surreal Hub (Camp)",
    Subtitle        = "Total Roblox Drama",
    LogoID          = "108950683571835",
    LoadingEnabled  = true,
    LoadingTitle    = "Surreal Hub",
    LoadingSubtitle = "Loading interface...",
    ConfigSettings  = {
        RootFolder   = nil,
        ConfigFolder = CONFIG_ROOT,
    },
    KeySystem       = false,
    KeySettings     = {
        Title      = "Surreal Hub",
        Subtitle   = "Key System",
        Note       = "",
        SaveInRoot = false,
        SaveKey    = false,
        Key        = {""},
        SecondAction = { Enabled = false, Type = "Link", Parameter = "" },
    },
})

Window:CreateHomeTab({ SupportedExecutors = {}, DiscordInvite = "", Icon = 2 })

--==================================================
-- TABS
--==================================================

local Main         = Window:CreateTab({ Name = "Main",       Icon = "view_in_ar",        ImageSource = "Material", ShowTitle = true })
local Challenges   = Window:CreateTab({ Name = "Challenges", Icon = "emoji_events",      ImageSource = "Material", ShowTitle = true })
local Morphs       = Window:CreateTab({ Name = "Morphs",     Icon = "accessibility_new", ImageSource = "Material", ShowTitle = true })
local Visuals      = Window:CreateTab({ Name = "Visuals",    Icon = "visibility",        ImageSource = "Material", ShowTitle = true })
local UtilitiesTab = Window:CreateTab({ Name = "Utilities",  Icon = "build",             ImageSource = "Material", ShowTitle = true })

--[[ Part 6/10 — Main Tab ]]

--==================================================
-- MAIN — VOTES
--==================================================

Main:CreateSection("Votes")

Main:CreateToggle({
    Name = "Notify Votes",
    CurrentValue = false,
    Callback = function(enabled)
        if State.voteConn then State.voteConn:Disconnect(); State.voteConn = nil end
        if not enabled then return end

        local season = RS:FindFirstChild("Season")
        local votes = season and season:FindFirstChild("Voting") and season.Voting:FindFirstChild("Votes")
        if not votes then return end

        State.voteConn = votes.ChildAdded:Connect(function(vote)
            local voter = season.Players:FindFirstChild(vote.Value)
            local target = season.Players:FindFirstChild(vote.Name)
            Utilities.notify("Vote Update",
                (voter and voter.Value or vote.Value) .. " voted for " .. (target and target.Value or vote.Name), 3)
        end)
    end,
}, "NotifyVotes")

Main:CreateToggle({
    Name = "Expose Votes",
    CurrentValue = false,
    Callback = function(enabled)
        if State.exposeConn then State.exposeConn:Disconnect(); State.exposeConn = nil end
        if not enabled then return end

        local season = RS:FindFirstChild("Season")
        local votes = season and season:FindFirstChild("Voting") and season.Voting:FindFirstChild("Votes")
        if not votes then return end

        State.exposeConn = votes.ChildAdded:Connect(function(vote)
            local voter = season.Players:FindFirstChild(vote.Value)
            local target = season.Players:FindFirstChild(vote.Name)
            pcall(function()
                TextChatService.TextChannels.RBXGeneral:SendAsync(
                    (voter and voter.Value or vote.Value) .. " voted for " .. (target and target.Value or vote.Name))
            end)
        end)
    end,
}, "ExposeVotes")

Main:CreateToggle({
    Name = "View Jury Votes",
    CurrentValue = false,
    Callback = function(enabled)
        if State.juryConn then
            for _, conn in ipairs(State.juryConn) do conn:Disconnect() end
            State.juryConn = nil
        end
        if not enabled then return end

        local season = RS:FindFirstChild("Season")
        local jury = season and season:FindFirstChild("Jury")
        if not jury then return end

        State.juryConn = {}

        local function watchJuror(juror)
            local list = juror:WaitForChild("List")
            table.insert(State.juryConn, list.ChildAdded:Connect(function(vote)
                local voter = juror.Value
                local target = vote.Value
                if season.Players:FindFirstChild(vote.Name) then
                    target = season.Players[vote.Name].Value
                end
                Utilities.notify("Jury Vote", voter .. " voted for " .. target, 3)
            end))
        end

        for _, juror in ipairs(jury:GetChildren()) do watchJuror(juror) end
        table.insert(State.juryConn, jury.ChildAdded:Connect(watchJuror))
    end,
}, "ViewJuryVotes")

Main:CreateToggle({
    Name = "View Exile Votes",
    CurrentValue = false,
    Callback = function(enabled)
        if State.exileConn then State.exileConn:Disconnect(); State.exileConn = nil end
        if not enabled then return end

        local twists = RS:FindFirstChild("Season") and RS.Season:FindFirstChild("Twists")
        local ev = twists and twists:FindFirstChild("ExileVoting")
        local votes = ev and ev:FindFirstChild("Votes")
        if not votes then return end

        State.exileConn = votes.ChildAdded:Connect(function(vote)
            local voter = RS.Season.Players:FindFirstChild(vote.Value)
            local target = RS.Season.Players:FindFirstChild(vote.Name)
            local message = (voter and voter.Value or vote.Value) .. " voted to exile " .. (target and target.Value or vote.Name)
            Utilities.notify("Exile Vote", message, 3.5)
            print(message)
        end)
    end,
}, "ViewExileVotes")

Main:CreateToggle({
    Name = "Print Votes",
    CurrentValue = false,
    Callback = function(enabled)
        if State.printConn then State.printConn:Disconnect(); State.printConn = nil end
        if not enabled then return end

        local season = RS:FindFirstChild("Season")
        local votes = season and season:FindFirstChild("Voting") and season.Voting:FindFirstChild("Votes")
        if not votes then return end

        State.printConn = votes.ChildAdded:Connect(function(vote)
            local voter = season.Players:FindFirstChild(vote.Value)
            local target = season.Players:FindFirstChild(vote.Name)
            print((voter and voter.Value or vote.Value) .. " voted for " .. (target and target.Value or vote.Name))
        end)
    end,
}, "PrintVotes")

--==================================================
-- MAIN — STATUE
--==================================================

Main:CreateSection("Statue")

Main:CreateButton({
    Name = "Find Statue (60% Spawn)",
    Callback = function()
        for _, obj in ipairs(workspace.Idols:GetDescendants()) do
            if obj.Name == "Bag" or obj.Name == "SafetyStatue" then
                local hit = obj:FindFirstChild("hit")
                if hit then
                    hit.CanCollide = false
                    hit.Transparency = 1
                    task.wait()
                    local torso = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Torso")
                    if torso then hit.Position = torso.Position end
                    task.wait()
                end
            end
        end
    end,
})

Main:CreateButton({
    Name = "Get Statue on Spawn",
    Callback = function()
        local function tryAttach(obj)
            if not obj:IsA("BasePart") or obj.Name ~= "hit" then return end
            local parent = obj.Parent
            if not parent or (parent.Name ~= "Bag" and parent.Name ~= "SafetyStatue") then return end

            task.wait(0.1)
            obj.CanCollide = false
            obj.Transparency = 1

            task.spawn(function()
                while obj and obj.Parent do
                    local root = Utilities.rootPart()
                    if root then obj.CFrame = root.CFrame end
                    task.wait(0.05)
                end
            end)
        end

        if not State.statueConn then
            State.statueConn = workspace.DescendantAdded:Connect(tryAttach)
        end
        for _, obj in ipairs(workspace:GetDescendants()) do tryAttach(obj) end
    end,
})

Main:CreateButton({
    Name = "Detect Who has Statue",
    Callback = function()
        pcall(function()
            local idol = RS.Season.Twists.Idol
            if idol.Value == "" then
                Utilities.notify("Statue Owner", "No one currently holds the statue.", 4)
            else
                local owner = RS.Season.Players:FindFirstChild(idol.Value)
                Utilities.notify("Statue Owner", (owner and owner.Value or idol.Value) .. " has the statue.", 4)
            end
        end)
    end,
})

--==================================================
-- MAIN — EXTRAS
--==================================================

Main:CreateSection("Extras")

Main:CreateToggle({
    Name = "Auto Detect Round",
    CurrentValue = false,
    Callback = function(enabled)
        if State.roundConn then State.roundConn:Disconnect(); State.roundConn = nil end
        if not enabled then return end

        pcall(function()
            local twist = RS.Season.Twists:FindFirstChild("CurrentTwist")
            if not twist then return end

            State.roundConn = twist:GetPropertyChangedSignal("Value"):Connect(function()
                local names = {
                    normal     = "Normal Round",
                    purge      = "Purge Round",
                    ["double"] = "Double Elimination",
                    singleswap = "Sike Round",
                    exile      = "Exile Vote Round",
                    votereveal = "Vote Reveal",
                }
                if names[twist.Value] then
                    Utilities.notify("Round Detected", names[twist.Value], 6)
                end
            end)
        end)
    end,
}, "AutoDetectRound")

Main:CreateButton({
    Name = "Detect Teamers",
    Callback = function()
        local season = RS:FindFirstChild("Season")
        local playersFolder = season and season:FindFirstChild("Players")
        if not playersFolder then return end

        local function gameNameOf(plr)
            local entry = playersFolder:FindFirstChild(plr.Name)
            return (entry and entry.Value ~= "") and entry.Value or plr.Name
        end

        local found = false
        local allPlayers = Players:GetPlayers()
        for i = 1, #allPlayers do
            for j = i + 1, #allPlayers do
                local p1, p2 = allPlayers[i], allPlayers[j]
                local ok, areFriends = pcall(function() return p1:IsFriendsWith(p2.UserId) end)
                if ok and areFriends then
                    found = true
                    Utilities.notify("Teamer Detected!",
                        gameNameOf(p1) .. " is teaming with " .. gameNameOf(p2), 8)
                    task.wait(0.6)
                end
            end
        end

        if not found then
            Utilities.notify("No Teamers Found", "No teamers are detected here.", 5)
        end
    end,
})

Main:CreateButton({
    Name = "Remove Cutscenes",
    Callback = function()
        local events = RS:FindFirstChild("Events")
        local camEvent = events and events:FindFirstChild("Camera")
        if camEvent then camEvent:Destroy() end

        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            Camera.CameraType = Enum.CameraType.Custom
            Camera.CameraSubject = hum
        end
    end,
})

--==================================================
-- MAIN — GLOBAL NAMEPLATES
--==================================================

local NameplateManager = {}

local NAMEPLATE_KEY = "SurrealNameplate"

local NAMEPLATE_GRADIENT = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(235, 235, 235)),
    ColorSequenceKeypoint.new(0.45, Color3.fromRGB(165, 165, 165)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(90, 90, 90)),
})

function NameplateManager.attach(plr)
    local char = plr.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    if head:FindFirstChild(NAMEPLATE_KEY) then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = NAMEPLATE_KEY
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 150, 0, 30)
    billboard.StudsOffset = Vector3.new(0, 3.75, 0)
    billboard.AlwaysOnTop = true
    billboard.LightInfluence = 0
    billboard.MaxDistance = 1500
    billboard.Parent = head

    local label = Instance.new("TextLabel")
    label.Name = "NameLabel"
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = (plr.DisplayName ~= "" and plr.DisplayName) or plr.Name
    label.TextScaled = true
    label.Font = Enum.Font.LuckiestGuy
    label.TextColor3 = Color3.fromRGB(180, 180, 180)
    label.TextStrokeTransparency = 0.35
    label.TextStrokeColor3 = Color3.fromRGB(45, 45, 45)
    label.Parent = billboard

    local gradient = Instance.new("UIGradient")
    gradient.Name = "NameGradient"
    gradient.Color = NAMEPLATE_GRADIENT
    gradient.Rotation = 90
    gradient.Parent = label
end

function NameplateManager.detach(plr)
    local char = plr.Character
    local head = char and char:FindFirstChild("Head")
    local existing = head and head:FindFirstChild(NAMEPLATE_KEY)
    if existing then existing:Destroy() end
end

function NameplateManager.enable()
    for _, plr in ipairs(Players:GetPlayers()) do
        NameplateManager.attach(plr)
    end

    State.nameplateCharConns = {}

    for _, plr in ipairs(Players:GetPlayers()) do
        table.insert(State.nameplateCharConns, plr.CharacterAdded:Connect(function()
            task.wait(0.15)
            if State.nameplatesEnabled then NameplateManager.attach(plr) end
        end))
    end

    State.nameplatePlayerConn = Players.PlayerAdded:Connect(function(plr)
        table.insert(State.nameplateCharConns, plr.CharacterAdded:Connect(function()
            task.wait(0.15)
            if State.nameplatesEnabled then NameplateManager.attach(plr) end
        end))
        if plr.Character then NameplateManager.attach(plr) end
    end)
end

function NameplateManager.disable()
    for _, plr in ipairs(Players:GetPlayers()) do
        NameplateManager.detach(plr)
    end

    if State.nameplatePlayerConn then
        State.nameplatePlayerConn:Disconnect()
        State.nameplatePlayerConn = nil
    end

    for _, conn in ipairs(State.nameplateCharConns) do
        conn:Disconnect()
    end
    State.nameplateCharConns = {}
end

Main:CreateToggle({
    Name = "Global Nameplates",
    CurrentValue = false,
    Callback = function(enabled)
        State.nameplatesEnabled = enabled
        if enabled then
            NameplateManager.enable()
        else
            NameplateManager.disable()
        end
    end,
}, "GlobalNameplates")

--[[ Part 7/10 — Challenges Tab ]]

Challenges:CreateSection("Challenges")

Challenges:CreateButton({
    Name = "Win Obby",
    Callback = function()
        local finish = workspace.Assets:FindFirstChild("Finish", true)
        if not finish then return end
        finish.CanCollide = false
        finish.Transparency = 1
        task.wait()
        local torso = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Torso")
        if torso then finish.Position = torso.Position end
    end,
})

Challenges:CreateToggle({
    Name = "Auto Win Obby",
    CurrentValue = false,
    Callback = function(enabled)
        State.autoWinObby = enabled
        if not enabled then return end

        task.spawn(function()
            while State.autoWinObby do
                local assets = workspace:FindFirstChild("Assets")
                local finish = assets and assets:FindFirstChild("Finish", true)
                local root = Utilities.rootPart()
                if finish and root then
                    finish.CanCollide = false
                    finish.Transparency = 1
                    task.wait()
                    finish.Position = root.Position
                end
                task.wait(0.1)
            end
        end)
    end,
}, "AutoWinObby")

Challenges:CreateButton({
    Name = "Remove all Spleef Studs",
    Callback = function()
        local root = Utilities.rootPart()
        if not root then return end
        for _, obj in ipairs(workspace.Assets:GetDescendants()) do
            if obj.Name == "SpleefPart" then
                firetouchinterest(root, obj, 0)
            end
        end
    end,
})

Challenges:CreateButton({
    Name = "Finish Pancake",
    Callback = function()
        for _, obj in ipairs(workspace.Assets:GetDescendants()) do
            if obj.Name == LocalPlayer.Name and obj:FindFirstChild("ClickDetector") then
                for _ = 1, 80 do fireclickdetector(obj.ClickDetector) end
            end
        end
    end,
})

Challenges:CreateToggle({
    Name = "Cliff Diving ESP",
    CurrentValue = false,
    Callback = function(enabled)
        State.cliffESP = enabled

        if enabled then
            local MAX_DISTANCE = 500

            local function createMarker(part)
                if State.cliffObjects[part] then return end

                if not part:FindFirstChild("CliffHighlight") then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "CliffHighlight"
                    highlight.FillTransparency = 1
                    highlight.OutlineColor = Color3.new(1, 1, 1)
                    highlight.Parent = part
                end

                local billboard = Instance.new("BillboardGui")
                billboard.AlwaysOnTop = true
                billboard.Size = UDim2.new(0, 260, 0, 70)
                billboard.StudsOffset = Vector3.new(0, 4, 0)
                billboard.Adornee = part
                billboard.Parent = part

                local label = Instance.new("TextLabel")
                label.BackgroundTransparency = 1
                label.Size = UDim2.new(1, 0, 1, 0)
                label.TextColor3 = Color3.new(1, 1, 1)
                label.TextStrokeTransparency = 0
                label.TextScaled = true
                label.Font = Enum.Font.GothamBold
                label.Text = "FINISH"
                label.Parent = billboard

                State.cliffObjects[part] = { billboard = billboard, label = label }
            end

            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Name:lower() == "finish" then
                    createMarker(obj)
                end
            end

            State.cliffAddedConn = workspace.DescendantAdded:Connect(function(obj)
                if State.cliffESP and obj:IsA("BasePart") and obj.Name:lower() == "finish" then
                    createMarker(obj)
                end
            end)

            State.cliffRemovedConn = workspace.DescendantRemoving:Connect(function(obj)
                if State.cliffObjects[obj] then
                    pcall(function() State.cliffObjects[obj].billboard:Destroy() end)
                    State.cliffObjects[obj] = nil
                end
            end)

            State.cliffRenderConn = RunService.RenderStepped:Connect(function()
                if not State.cliffESP then return end
                local root = Utilities.rootPart()
                if not root then return end
                for part, marker in pairs(State.cliffObjects) do
                    local distance = (part.Position - root.Position).Magnitude
                    marker.billboard.Enabled = distance <= MAX_DISTANCE
                    if distance <= MAX_DISTANCE then
                        marker.label.Text = string.format("%.1f studs", distance)
                    end
                end
            end)
        else
            for part, marker in pairs(State.cliffObjects) do
                pcall(function() marker.billboard:Destroy() end)
                pcall(function()
                    if part:FindFirstChild("CliffHighlight") then
                        part.CliffHighlight:Destroy()
                    end
                end)
            end
            State.cliffObjects = {}
            if State.cliffAddedConn then State.cliffAddedConn:Disconnect(); State.cliffAddedConn = nil end
            if State.cliffRemovedConn then State.cliffRemovedConn:Disconnect(); State.cliffRemovedConn = nil end
            if State.cliffRenderConn then State.cliffRenderConn:Disconnect(); State.cliffRenderConn = nil end
        end
    end,
}, "CliffDivingESP")

Challenges:CreateToggle({
    Name = "Auto Get All Coins",
    CurrentValue = false,
    Callback = function(enabled)
        State.autoCollect = enabled
        if not enabled then return end

        task.spawn(function()
            while State.autoCollect do
                task.wait(0.5)
                local root = Utilities.rootPart()
                if root then
                    for _, obj in ipairs(workspace.Assets:GetDescendants()) do
                        if (obj.Name == "Coin" or obj.Name == "Gem") and obj:IsA("BasePart") then
                            obj.CanCollide = false
                            obj.Position = root.Position
                        end
                    end
                end
            end
        end)
    end,
}, "AutoGetCoins")

Challenges:CreateToggle({
    Name = "Answer Math Mania",
    CurrentValue = false,
    Callback = function(enabled)
        State.autoMath = enabled
        if not enabled then return end

        task.spawn(function()
            while State.autoMath do
                local mathGui = LocalPlayer.PlayerGui:FindFirstChild("MathMania")
                if mathGui then
                    for index = 1, 10 do
                        if not State.autoMath then break end
                        local question = mathGui:FindFirstChild(tostring(index))
                        if question and question:FindFirstChild("MainText") then
                            local expression = question.MainText.Text:gsub("=", ""):gsub("?", ""):gsub(" ", "")
                            local ok, result = pcall(function()
                                return loadstring("return " .. expression)()
                            end)
                            if ok and result then
                                question.Box.Text = tostring(result)
                                local submit = question:FindFirstChild("Enter")
                                if submit then
                                    for _, eventName in ipairs({"MouseButton1Click", "MouseButton1Down", "Activated"}) do
                                        if submit[eventName] then
                                            for _, conn in pairs(getconnections(submit[eventName])) do
                                                if conn.Function then conn:Fire() end
                                            end
                                        end
                                    end
                                end
                                if State.mathDelay > 0 then task.wait(State.mathDelay) end
                            end
                        end
                    end
                end
                task.wait()
            end
        end)
    end,
}, "AnswerMathMania")

Challenges:CreateSlider({
    Name = "Math Mania Setback",
    Range = {0, 100},
    Increment = 1,
    CurrentValue = 0,
    Callback = function(value)
        State.mathDelay = value / 10
    end,
}, "MathManiaSetback")

Challenges:CreateButton({
    Name = "Win Blockpush",
    Callback = function()
        local root = Utilities.rootPart()
        if not root then return end

        for _, box in ipairs(workspace:GetDescendants()) do
            if box:IsA("Part") and box.Name == "SingularBox" then
                if (box.Position - root.Position).Magnitude <= 100 then
                    for _, target in ipairs(workspace:GetDescendants()) do
                        if target:IsA("Part") and target.Name == "Gold" then
                            box.Position = target.Position + Vector3.new(0, 3, 0)
                            root.CFrame = CFrame.new(box.Position + Vector3.new(0, 3, 0))
                            break
                        end
                    end
                    break
                end
            end
        end
    end,
})

Challenges:CreateToggle({
    Name = "Dodgeball Invincibility",
    CurrentValue = false,
    Callback = function(enabled)
        State.dodgeballGuard = enabled
        if not enabled then return end

        task.spawn(function()
            local triggered = false
            while State.dodgeballGuard do
                local assets = workspace:FindFirstChild("Assets")
                if assets then
                    local giver = assets:FindFirstChild("DodgeballGiver", true)
                    if giver and not triggered then
                        triggered = true
                        local hum = Utilities.humanoid()
                        if hum then hum.Health = 0 end
                    end
                    if not giver then triggered = false end
                end
                task.wait(0.1)
            end
        end)
    end,
}, "DodgeballInvincibility")

Challenges:CreateButton({
    Name = "Get Dodgeballs",
    Callback = function()
        local root = Utilities.rootPart()
        if not root then return end

        local assets = workspace:FindFirstChild("Assets")
        if not assets then return end

        for _, obj in ipairs(assets:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name:lower():find("dodgeball") then
                firetouchinterest(root, obj, 0)
                firetouchinterest(root, obj, 1)
            end
        end
    end,
})

Challenges:CreateToggle({
    Name = "Paintball Invincibility",
    CurrentValue = false,
    Callback = function(enabled)
        State.paintballGuard = enabled
        if not enabled then return end

        task.spawn(function()
            local triggered = false
            while State.paintballGuard do
                local assets = workspace:FindFirstChild("Assets")
                if assets then
                    local arena = assets:FindFirstChild("Paintball", true)
                        or assets:FindFirstChild("PaintballArena", true)
                    if arena and not triggered then
                        triggered = true
                        local hum = Utilities.humanoid()
                        if hum then hum.Health = 0 end
                    end
                    if not arena then triggered = false end
                end
                task.wait(0.1)
            end
        end)
    end,
}, "PaintballInvincibility")

Challenges:CreateButton({
    Name = "Kill Everyone in Swordfight",
    Callback = function()
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        local char = LocalPlayer.Character
        if backpack and char then
            local sword
            for _, tool in ipairs(backpack:GetChildren()) do
                if tool:IsA("Tool") and tool.Name:lower():find("sword") then
                    sword = tool
                    break
                end
            end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if sword and hum then hum:EquipTool(sword) end
        end

        if State.swordFightConn then State.swordFightConn:Disconnect() end

        State.swordFightConn = RunService.RenderStepped:Connect(function()
            local players = Players:GetPlayers()
            for i = 2, #players do
                local target = players[i].Character
                if target and not LocalPlayer:IsFriendsWith(players[i].UserId) then
                    local char = LocalPlayer.Character
                    local tool = char and char:FindFirstChildOfClass("Tool")
                    if tool and tool:FindFirstChild("Handle") then
                        tool:Activate()
                        for _, part in ipairs(target:GetChildren()) do
                            if part:IsA("BasePart") then
                                firetouchinterest(tool.Handle, part, 0)
                                firetouchinterest(tool.Handle, part, 1)
                            end
                        end
                    end
                end
            end
        end)

        task.delay(1, function()
            if State.swordFightConn then
                State.swordFightConn:Disconnect()
                State.swordFightConn = nil
            end
        end)
    end,
})

--[[ Part 8/10 — Morphs Tab ]]

--==================================================
-- MORPHS — COMEBACKS
--==================================================

Morphs:CreateSection("Comebacks")

Morphs:CreateButton({
    Name = "Comeback as Male",
    Callback = function() RS.Events.Buy:FireServer("Gender", "Male") end,
})

Morphs:CreateButton({
    Name = "Comeback as Female",
    Callback = function() RS.Events.Buy:FireServer("Gender", "Female") end,
})

--==================================================
-- MORPHS — PAID
--==================================================

Morphs:CreateSection("Paid")

local characterNameBuffer = ""
local selectedSymbol = ""

local SYMBOL_MAP = {
    ["None"]     = "",
    ["Verified"] = "\u{e000}",
    ["Premium"]  = "\u{e001}",
    ["Robux"]    = "\u{e002}",
}

Morphs:CreateInput({
    Name = "Character Name",
    PlaceholderText = "Enter character name...",
    CurrentValue = "",
    Numeric = false,
    MaxCharacters = nil,
    Enter = false,
    Callback = function(value) characterNameBuffer = value end,
})

Morphs:CreateButton({
    Name = "Buy Character (@60)",
    Callback = function()
        if characterNameBuffer == "" then return end
        RS.Events.Buy:FireServer("Character", characterNameBuffer)
    end,
})

Morphs:CreateDropdown({
    Name = "Select Symbol",
    Options = {"None", "Verified", "Premium", "Robux"},
    CurrentOption = {"None"},
    MultipleOptions = false,
    Callback = function(value)
        local choice = type(value) == "table" and (value[1] or value.Option) or value
        selectedSymbol = SYMBOL_MAP[choice] or ""
    end,
})

Morphs:CreateButton({
    Name = "Buy Symbol (@60)",
    Callback = function()
        if characterNameBuffer == "" then return end
        local final = characterNameBuffer
        if selectedSymbol ~= "" then
            final = characterNameBuffer .. " " .. selectedSymbol
        end
        RS.Events.Buy:FireServer("Character", final)
    end,
})

--[[ Part 9/10 — Visuals Tab ]]

--==================================================
-- VISUALS — TYPEFACES
--==================================================

Visuals:CreateSection("Typefaces")

Visuals:CreateButton({
    Name = "Starborn Typeface",
    Callback = function()
        TypefaceManager.load(
            "starborn", "Starborn", "starborn.ttf", "Starborn.json",
            "https://drive.google.com/uc?export=download&id=1AOv_DKQ0iB55eOvRkQnkq40POxix82dP&confirm=t",
            "SurrealFontStarborn"
        )
    end,
})

Visuals:CreateButton({
    Name = "Minecraft Typeface",
    Callback = function()
        TypefaceManager.load(
            "minecraft", "Minecrafter", "minecrafter.ttf", "Minecrafter.json",
            "https://drive.google.com/uc?export=download&id=1oe66VO8IhLBqDvbgxqer4RHEi7bAO7R2&confirm=t",
            "SurrealFontMinecraft"
        )
    end,
})

Visuals:CreateButton({
    Name = "Matcha Mint Typeface",
    Callback = function()
        TypefaceManager.load(
            "matchamint", "Matcha Mint", "matchamint.ttf", "MatchaMint.json",
            "https://drive.google.com/uc?export=download&id=1cZomyiePFjjNzciPRextxt0puySrmrEX&confirm=t",
            "SurrealFontMatchaMint"
        )
    end,
})

Visuals:CreateButton({
    Name = "OG Roblox Typeface",
    Callback = function()
        TypefaceManager.load(
            "ogroblox", "OG Roblox", "ogroblox.ttf", "OGRoblox.json",
            "https://drive.google.com/uc?export=download&id=1XLBx4U-kkzB3B8v2DaO3AcvtHNlyn3tn&confirm=t",
            "SurrealFontOGRoblox"
        )
    end,
})

--==================================================
-- VISUALS — CUSTOM
--==================================================

Visuals:CreateSection("Custom")

Visuals:CreateInput({
    Name = "Character Name",
    PlaceholderText = "Enter character name...",
    CurrentValue = "",
    Numeric = false,
    MaxCharacters = nil,
    Enter = false,
    Callback = function(value)
        _G.CustomName = value
        _G.UseCustomName = (value ~= "")
    end,
})

Visuals:CreateToggle({
    Name = "Rainbow Name",
    CurrentValue = false,
    Callback = function(enabled)
        _G.RainbowMode = enabled
    end,
}, "RainbowName")

Visuals:CreateSlider({
    Name = "Rainbow Setback",
    Range = {0, 100},
    Increment = 1,
    CurrentValue = 50,
    Callback = function(value)
        _G.RainbowSpeed = value / 100
    end,
}, "RainbowSetback")

Visuals:CreateColorPicker({
    Name = "Name Color",
    Color = Color3.fromRGB(255, 255, 255),
    Callback = function(value)
        _G.StaticColor = value
        _G.StaticColorCustom = true
    end,
})

--==================================================
-- VISUALS — NAME RENDER LOOP
--==================================================

RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    for _, obj in ipairs(char:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") then
            if _G.UseCustomName and _G.CustomName ~= "" then
                obj.Text = _G.CustomName
            end
            if _G.SelectedFont then
                obj.Font = _G.SelectedFont
            end
            obj.TextScaled = true
            if _G.RainbowMode then
                local hue = (tick() * _G.RainbowSpeed) % 1
                obj.TextColor3 = Color3.fromHSV(hue, 0.6, 1)
            elseif _G.StaticColorCustom then
                obj.TextColor3 = _G.StaticColor
            end
            obj.TextStrokeTransparency = 0.5
            obj.BackgroundTransparency = 1
        end
    end
end)

--[[ Part 10/10 — Utilities Tab & Initialize ]]

--==================================================
-- HELPER MODULES
--==================================================

local WaterManager = {}

local function getLakeWater()
    local map = workspace:FindFirstChild("Map")
    local camp = map and map:FindFirstChild("Roblox Drama: Camp")
    local innerMap = camp and camp:FindFirstChild("Map")
    local lake = innerMap and innerMap:FindFirstChild("Lake")
    return lake and lake:FindFirstChild("Water")
end

local function getSandTouch()
    local map = workspace:FindFirstChild("Map")
    local camp = map and map:FindFirstChild("Roblox Drama: Camp")
    local sand = camp and camp:FindFirstChild("Sand")
    return sand and sand:FindFirstChild("TouchInterest")
end

function WaterManager.setEnabled(enabled)
    pcall(function()
        local water = getLakeWater()
        if water then
            water.CanCollide = enabled
        end

        if enabled then
            local touch = getSandTouch()
            if touch then
                touch:Destroy()
            end
        end
    end)
end

local BarrierManager = {}

local BARRIER_TARGETS = {
    ["Glass"]          = true,
    ["ChallengeGlass"] = true,
    ["AwardCeremony"]  = true,
    ["Drop-Off"]       = true,
}

function BarrierManager.clear()
    local removed = 0
    for _, obj in ipairs(workspace:GetDescendants()) do
        if BARRIER_TARGETS[obj.Name] then
            obj:Destroy()
            removed = removed + 1
        end
    end
    Utilities.notify("Barriers Cleared", removed .. " obstacle(s) removed.", 3)
end

--==================================================
-- UTILITIES TAB
--==================================================

UtilitiesTab:CreateSection("Utility")

UtilitiesTab:CreateButton({
    Name = "FE Genesis Sniper",
    Callback = function()
        Utilities.launchUtility("genesis_sniper")
    end,
})

UtilitiesTab:CreateButton({
    Name = "Barrier Cleanup",
    Callback = function()
        BarrierManager.clear()
    end,
})

UtilitiesTab:CreateToggle({
    Name = "Water Walk",
    CurrentValue = false,
    Callback = function(enabled)
        State.waterWalkEnabled = enabled
        WaterManager.setEnabled(enabled)

        if enabled then
            Utilities.notify("Water Walk", "Surface enabled — you will not drown.", 3)
        end
    end,
}, "WaterWalk")

UtilitiesTab:CreateSection("Teleports")

UtilitiesTab:CreateButton({
    Name = "Spectator Island",
    Callback = function() Utilities.teleportTo(33, -16, 31) end,
})

UtilitiesTab:CreateButton({
    Name = "Main Island",
    Callback = function() Utilities.teleportTo(150, -17, -417) end,
})

UtilitiesTab:CreateButton({
    Name = "Exile Island",
    Callback = function() Utilities.teleportTo(-116, -14, -166) end,
})

UtilitiesTab:CreateButton({
    Name = "Voting Area",
    Callback = function() Utilities.teleportTo(-23, 95, -514) end,
})

UtilitiesTab:CreateButton({
    Name = "Boat",
    Callback = function() Utilities.teleportTo(47, -20, -297) end,
})

UtilitiesTab:CreateButton({
    Name = "Bathroom",
    Callback = function() Utilities.teleportTo(302, -15, -325) end,
})

UtilitiesTab:CreateSection("More")

UtilitiesTab:CreateButton({
    Name = "Infinite Yield",
    Callback = function()
        Utilities.launchUtility("infinite_yield")
    end,
})

UtilitiesTab:CreateButton({
    Name = "Energize R6",
    Callback = function()
        Utilities.launchUtility("energize")
    end,
})

--==================================================
-- INITIALIZE
--==================================================

task.spawn(function()
    pcall(function()
        Luna:LoadAutoloadConfig()
    end)
end)