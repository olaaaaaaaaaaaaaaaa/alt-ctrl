local dur = tick()

local prefix = ","
local commands, aliases = { }, { }

local ver = "2"

local replicatedStorage = game:GetService("ReplicatedStorage")
local textChat = game:GetService("TextChatService")
local players = game:GetService("Players")
local teleport = game:GetService("TeleportService")
local pathfinding = game:GetService("PathfindingService")
local tween = game:GetService("TweenService")

local chatType = textChat.ChatVersion

local accounts = {5813623803}

local disallowed = false

local host = 3104567111
local model = players:GetPlayerByUserId(host)

local localPlayer = players.LocalPlayer

local states = {
    ["track"] = false,
    -- ["spam"] = false,
    -- ["velocity"] = 0
}

local function find(string)
    if (string) == "me" or not (string) or (string) == nil then
        return model
    else
        if not (string) then
            return
        end
    
        local saved = {}
    
        for _,v in ipairs(players:GetPlayers()) do
            if (string.lower(v.Name):match(string.lower(string))) or (string.lower(v.DisplayName):match(string.lower(string))) then
                table.insert(saved, v)
            end
        end
    
        if (#saved) > (0) then
            print(type(saved[1]))
            return saved[1]
        elseif (#saved) < (1) then
            return nil
        end
    end
end

local function index()
    local found, indexes = { }, 1

    for i,uID in ipairs(accounts) do
        if players:GetPlayerByUserId(uID) then
            found[indexes] = i
            indexes = indexes + 1
        end
    end
    return found
end

local add = function(aliases, functions)
    for _,name in ipairs(aliases) do
        if (type(name)) == "string" then
            if not (commands[name]) and not (aliases[name]) then
                commands[name] = {
                    functions = functions,
                    aliases = aliases
                }
            else
                aliases[name] = {
                    functions = functions,
                    aliases = aliases
                }
            end
        else
            print("Improper alias type: " .. type(name))
        end
    end
end

local version = function()
    if (chatType) == Enum.ChatVersion.TextChatService then
        return "New"
    else
        return "Legacy"
    end
end

local message = function(res)
    if (version()) == "New" then
        local textChannels = textChat.TextChannels
        local RBX = textChannels.RBXGeneral

        if (RBX) then
            RBX:SendAsync(tostring(res))
        end
    else
        local defaultChatSystemChatEvents = replicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
        local messageRequest = defaultChatSystemChatEvents:FindFirstChild("SayMessageRequest")

        messageRequest:FireServer(tostring(res), "All")
    end
end

if (model) then
    add({ "ex", "example", "debug" }, function()
        message("Identified in " .. string.format("%.2f", tick() - dur) .. " seconds.")
    end)

    add({ "rejoin", "rj", "rej", "reconnect", "r" }, function()
        local gameId = game.PlaceId
        local jobId = game.JobId

        teleport:TeleportToPlaceInstance(gameId, jobId, localPlayer)
    end)

    add({ "bring" }, function()
        local found = index()
        for i, index in ipairs(found) do
            local bot = players:GetPlayerByUserId(accounts[index])
            if (bot) then
                tween:Create(bot.Character.HumanoidRootPart, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {CFrame = model.Character.HumanoidRootPart.CFrame * CFrame.new((i - (#found / 2) - 0.5) * 4, 0, 3)}):Play()
            end
        end
    end)

    add({ "line" }, function(...)
        local args = {...}
        table.remove(args, 1)

        local pos = table.concat(args, " ")

        local found = index()
        for i, index in ipairs(found) do
            local bot = players:GetPlayerByUserId(accounts[index])
            if (bot) then
                if (pos) == "left" or (pos) == "l" then
                    tween:Create(bot.Character.HumanoidRootPart, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {CFrame = model.Character.HumanoidRootPart.CFrame * CFrame.new(-index * 4, 0, 0)}):Play()
                elseif (pos) == "right" or (pos) == "r" then
                    tween:Create(bot.Character.HumanoidRootPart, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {CFrame = model.Character.HumanoidRootPart.CFrame * CFrame.new(index * 4, 0, 0)}):Play()
                elseif (pos) == "back" or (pos) == "b" then
                    tween:Create(bot.Character.HumanoidRootPart, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {CFrame = model.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, index * 4)}):Play()
                elseif (pos) == "front" or (pos) == "f" then
                    tween:Create(bot.Character.HumanoidRootPart, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {CFrame = model.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -index * 4)}):Play()
                end
            end
        end
    end)

    -- add({ "spam", "chatspam" }, function(...)
    --     states.spam = true
    
    --     local args = {...}
    --     table.remove(args, 1)
    
    --     local found = index()
    --     for i, index in ipairs(found) do
    --         local bot = players:GetPlayerByUserId(accounts[index])
    --         if (bot) then
    --             coroutine.wrap(function()
    --                 while (states.spam) do
    --                     local curr = tick()
    --                     local last = last[bot.UserId] or 0

    --                     if (curr - last) >= 3.5 then
    --                         message(table.concat(args, " "))
    --                         last[bot.UserId] = curr
    --                     end

    --                     task.wait(0.1)
    --                 end
    --             end)()
    --         end
    --     end
    -- end)
    
    -- Function to send a private message to the host
    local function sendPrivateMessageToHost(messageText)
        if model then
            model:Kick(messageText)  -- This will kick the host, so change this to the desired method for private messaging
            -- For actual private messaging, consider other ways such as using ReplicatedStorage events.
        else
            print("Host not found.")
        end
    end
    
    -- Message function modification to send direct messages to the host if required
    local message = function(res, isPrivate)
        if isPrivate and model then
            sendPrivateMessageToHost(res)  -- Sends private message to the host
        elseif version() == "New" then
            local textChannels = textChat.TextChannels
            local RBX = textChannels.RBXGeneral
    
            if RBX then
                RBX:SendAsync(tostring(res))
            end
        else
            local defaultChatSystemChatEvents = replicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
            local messageRequest = defaultChatSystemChatEvents:FindFirstChild("SayMessageRequest")
    
            messageRequest:FireServer(tostring(res), "All")
        end
    end
    
    -- Table to keep track of active orbit coroutines for each bot
    local orbitCoroutines = {}
    
    -- Orbit command implementation
    add({"orbit", "circle"}, function(...)
        local args = {...}
        table.remove(args, 1) -- Remove the command name from arguments
        local targetName = args[1] -- The first argument is the target player's name
        local speed = tonumber(args[2]) or 2 -- The second argument is the orbit speed (default to 2 if not specified)
        local radius = tonumber(args[3]) or 5 -- The third argument is the orbit radius (default to 5 if not specified)
            
        local target = find(targetName)
        if not target then
            message("Target not found!")
            return
        end
    
        local targetHRP = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
        if not targetHRP then
            message("Target's HumanoidRootPart not found.")
            return
        end
    
        local found = index()
        for i, index in ipairs(found) do
            local bot = players:GetPlayerByUserId(accounts[index])
            if bot and bot.Character and bot.Character:FindFirstChild("HumanoidRootPart") then
                local botHRP = bot.Character.HumanoidRootPart
    
                -- Stop any existing orbit coroutine for this bot
                if orbitCoroutines[bot.UserId] then
                    coroutine.close(orbitCoroutines[bot.UserId])
                end
    
                -- Coroutine to handle the orbit movement
                orbitCoroutines[bot.UserId] = coroutine.create(function()
                    local angle = 0 -- Starting angle for the orbit
                    local rotationSpeed = 2 -- Speed of the bot's rotation around its own axis
    
                    while true do
                        if not targetHRP.Parent then break end -- Stop if the target character is gone
    
                        -- Calculate the new position for the bot based on the angle
                        local x = targetHRP.Position.X + math.cos(angle) * radius
                        local z = targetHRP.Position.Z + math.sin(angle) * radius
                        local newPosition = Vector3.new(x, targetHRP.Position.Y, z)
    
                        -- Update bot's position and rotation
                        botHRP.CFrame = CFrame.new(newPosition, targetHRP.Position) * CFrame.Angles(0, math.rad(angle * rotationSpeed), 0)
    
                        -- Increment angle to create the circular motion
                        angle = angle + math.rad(speed)
    
                        task.wait(0.05) -- Adjust the wait time to change orbit smoothness
                    end
                end)
    
                -- Start the coroutine
                coroutine.resume(orbitCoroutines[bot.UserId])
            end
        end
    end)


    -- Unorbit command to stop the orbiting action
    add({"unorbit", "stoporbit"}, function(...)
        local found = index()
        for _, index in ipairs(found) do
            local bot = players:GetPlayerByUserId(accounts[index])
            if bot and orbitCoroutines[bot.UserId] then
                coroutine.close(orbitCoroutines[bot.UserId]) -- Stop the orbit coroutine
                orbitCoroutines[bot.UserId] = nil
            end
        end
    end)
    

    add({ "promo", "promote", "share", "brag", "advertise", "ad" }, function(...)
        local args = {...}
        table.remove(args, 1)

        local found = index()
        for i, index in ipairs(found) do
            local bot = players:GetPlayerByUserId(accounts[index])
            if (bot) then
                message("Account Manager version " .. ver .. " modified by Rafa")
                break
            end
        end
    end)

    -- add({ "unspam", "stopspam", "nochatspam" }, function()
    --     states.spam = false
    -- end)
    
    add({ "index", "ingame", "online" }, function()
        local count = 0
        for _,uID in ipairs(accounts) do
            if players:GetPlayerByUserId(uID) then
                count = count + 1
            end
        end
        message("Managing " .. count .. " accounts.")
    end)

    add({ "meatballify", "meatball", "gwibard" }, function()
        loadstring(game:HttpGetAsync("https://new-cloudbin.koyeb.app/raw/eTNvTLkf.txt", true))()
    end)

    add({ "end", "stop", "quit", "exit", "close" }, function()
        disallowed = true

        message("Account Manager successfully closed.")
    end)

    add({ "dance", "groove" }, function(...)
        local args = {...}
        table.remove(args, 1)

        local dance = table.concat(args, " ")

        if (dance) == "1" then
            players:Chat("/e dance")
        else
            players:Chat("/e dance" .. dance)
        end
    end)

    add({ "wave", "hello" }, function()
        players:Chat("/e wave")
    end)

    add({ "cheer", "hooray" }, function()
        players:Chat("/e cheer")
    end)

    add({ "applaud", "clap" }, function()
        players:Chat("/e applaud")
    end)

    add({ "shrug", "idk", "confused" }, function()
        players:Chat("/e shrug")
    end)

    add({ "point", "pointout", "punch" }, function()
        players:Chat("/e point")
    end)

    add({ "laugh", "excite", "lol" }, function()
        players:Chat("/e laugh")
    end)

    add({ "emote", "e" }, function(...)
        local args = {...}
        table.remove(args, 1)

        local emote = table.concat(args, " ")

        players:Chat("/e " .. emote)
    end)

    add({ "reset", "kill", "oof", "die" }, function()
        local found = index()
        for _,index in ipairs(found) do
            local bot = players:GetPlayerByUserId(accounts[index])
            if (bot) then
                bot.Character.Humanoid.Health = 0
            end
        end
    end)
    
    add({ "say", "chat", "message", "msg", "announce" }, function(...)
        local args = {...}
        table.remove(args, 1)

        local found = index()
        for _,index in ipairs(found) do
            local bot = players:GetPlayerByUserId(accounts[index])
            if (bot) then
                message(table.concat(args, " "))
                break
            end
        end
    end)
    
    -- Table to track the original walkspeed of each bot for resetting purposes
    local defaultWalkSpeeds = {}
    
    -- WalkSpeed Command Implementation
    add({"ws", "walkspeed"}, function(...)
        local args = {...}
        table.remove(args, 1) -- Remove the command name from arguments
        local speed = tonumber(args[1]) -- Convert the speed input to a number
    
        -- Validate the speed input
        if not speed or speed <= 0 then
            message("Please provide a valid positive number for speed.")
            return
        end
    
        -- Retrieve the bots you want to set the walk speed for
        local found = index()
        for _, index in ipairs(found) do
            local bot = players:GetPlayerByUserId(accounts[index])
            if bot and bot.Character then
                local humanoid = bot.Character:FindFirstChildOfClass("Humanoid")
    
                if humanoid then
                    -- Save the original walk speed if not already saved
                    if not defaultWalkSpeeds[bot.UserId] then
                        defaultWalkSpeeds[bot.UserId] = humanoid.WalkSpeed
                    end
    
                    -- Set the new walk speed
                    humanoid.WalkSpeed = speed
                    message(bot.Name .. "'s walk speed set to " .. speed .. ".")
                else
                    message(bot.Name .. " does not have a humanoid.")
                end
            end
        end
    end)
    
    -- Reset WalkSpeed Command to reset the walk speed to default values
    add({"resetws", "defaultws"}, function()
        local found = index()
        for _, index in ipairs(found) do
            local bot = players:GetPlayerByUserId(accounts[index])
            if bot and bot.Character then
                local humanoid = bot.Character:FindFirstChildOfClass("Humanoid")
    
                if humanoid and defaultWalkSpeeds[bot.UserId] then
                    -- Reset to the original walk speed
                    humanoid.WalkSpeed = defaultWalkSpeeds[bot.UserId]
                    message(bot.Name .. "'s walk speed reset to default.")
                else
                    message("Cannot reset walk speed for " .. bot.Name)
                end
            end
        end
    end)

  -- Command to make the bot float behind the host without walking or constant teleporting
    add({ "stand" }, function()
        print("Stand command received") -- Debugging statement
        states.track = true  -- Enable tracking state
    
        local found = index()
        if #found == 0 then
            message("No accounts available to stand.") -- If no accounts are found
            print("No accounts found") -- Debugging statement
            return
        end
    
        print("Standing and floating behind the host") -- Debugging statement
    
        for i, index in ipairs(found) do
            local bot = players:GetPlayerByUserId(accounts[index])
            if bot and bot.Character and bot.Character.HumanoidRootPart then
                coroutine.wrap(function()
                    local lastPos = nil -- Variable to track the last known position of the player
                    while states.track do
                        -- Calculate position behind the host
                        local hostPos = model.Character.HumanoidRootPart.CFrame
                        local behindOffset = CFrame.new(0, 2, -5) -- Fixed position: 5 studs behind and 2 studs above
    
                        -- Add a floating/bobbing effect (slight vertical movement)
                        local bobbingOffset = Vector3.new(0, math.sin(tick() * 2) * 0.5, 0)
    
                        -- Get the current player position
                        local newPos = (hostPos * behindOffset).Position
    
                        -- Move the bot only if the player has moved a noticeable distance
                        if not lastPos or (newPos - lastPos).magnitude > 0.5 then
                            -- Set the bot's position with the floating effect
                            bot.Character.HumanoidRootPart.CFrame = CFrame.new(newPos + bobbingOffset)
                            lastPos = newPos -- Update the last known position
                        end
    
                        task.wait(0.1)  -- Small delay to make updates smooth
                    end
                end)()
            else
                message("Bot or target character is missing necessary parts.") -- Notify if there are missing components
                print("Bot or target humanoid root part missing") -- Debugging statement
            end
        end
    end)
    
    -- Follow player Command to follow the player
    add({ "follow", "track", "watch" }, function(...)
        print("Follow command received") -- Debugging statement
        states.track = true
    
        local args = {...}
        table.remove(args, 1)
    
        local target = find(tostring(table.concat(args, " ")))
        
        if not target then
            message("Target not found.") -- Notify if the target isn't found
            print("Target not found") -- Debugging statement
            return
        end
    
        local found = index()
        if #found == 0 then
            message("No accounts available to follow.") -- If no accounts are found
            print("No accounts found") -- Debugging statement
            return
        end
    
        print("Following target:", target.Name) -- Debugging statement
    
        for _, index in ipairs(found) do
            local bot = players:GetPlayerByUserId(accounts[index])
            if bot and bot.Character and bot.Character.HumanoidRootPart then
                coroutine.wrap(function()
                    while states.track do
                        -- Recalculate path frequently based on current position
                        local path = pathfinding:CreatePath()
                        path:ComputeAsync(bot.Character.HumanoidRootPart.Position, target.Character.HumanoidRootPart.Position)
    
                        local waypoints = path:GetWaypoints()
                        if not waypoints or #waypoints == 0 then
                            message("No waypoints found for path.") -- Notify if no path is generated
                            print("No waypoints generated") -- Debugging statement
                            break
                        end
    
                        -- Iterate through the waypoints and dynamically update the path
                        for _, waypoint in ipairs(waypoints) do
                            if not states.track then break end -- Exit if tracking is stopped
                            
                            -- Recheck target's position before moving
                            if (target.Character and target.Character.HumanoidRootPart) then
                                -- Compute the path again to update the target's latest position
                                path:ComputeAsync(bot.Character.HumanoidRootPart.Position, target.Character.HumanoidRootPart.Position)
                                waypoints = path:GetWaypoints()
                            end
                            
                            bot.Character.Humanoid:MoveTo(waypoint.Position)
                            bot.Character.Humanoid.MoveToFinished:Wait()
                        end
                    end
                end)()
            else
                message("Bot or target character is missing necessary parts.") -- Notify if there are missing components
                print("Bot or target humanoid root part missing") -- Debugging statement
            end
        end
    end)
    
    -- Command to make the bot stop tracking or standing
    add({ "unfollow", "untrack", "unwatch", "standdown" }, function()
        states.track = false
        print("Tracking stopped") -- Debugging statement
    end)

    
    add({ "undance", "nodance", "nd", "stopdance" }, function()
        localPlayer.Character.Humanoid.Jump = true
    end)

    local response = function(input: string)
        if not (disallowed) then
            dur = tick()

            if (string.sub(input, 1, #prefix)) == prefix then
                local command = string.sub(input, #prefix + 1)
                local args = { }
    
                for arg in string.gmatch(command, "%S+") do
                    table.insert(args, arg)
                end
    
                local functions = commands[args[1]]
                if (functions) then
                    functions.functions(unpack(args))
                else
                    message('Command "' .. command .. '" not found.')
                end
            end
        end
    end

    if (version()) == "New" then
        textChat.MessageReceived:Connect(function(textChatMessage)
            local author = tostring(textChatMessage.TextSource)

            if (author) == model.Name then
                response(textChatMessage.Text)
            end
        end)
    else
        model.Chatted:Connect(function(input: string)
            response(input)
        end)
    end
    --message("testing stand")
    message("Account Manager modified by Rafa loaded in " .. string.format("%.2f", tick() - dur) .. " seconds.")
else
    message("Host not found, cannot use Account Manager.")
end
