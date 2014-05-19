Testing.ServerClient = {}

Testing.ServerClient.activeKeyBinding = {}
Testing.ServerClient.activeKeyBinding["escape"] = {
    pressed = function()
        Game.changeState(Testing.Menu)
    end
}

function Testing.ServerClient.init()
    Testing.ServerClient.createGUI()
end

-- love.update, hopefully you are familiar with it from the callbacks tutorial
function Testing.ServerClient.update(deltatime)
    if Testing.ServerClient.clientStarted then
        Testing.ServerClient.t = Testing.ServerClient.t + deltatime -- increase t by the deltatime

        -- its *very easy* to completely saturate a network connection if you
        -- aren't careful with the packets we send (or request!), we hedge
        -- our chances by limiting how often we send (and request) updates.
        --
        -- for the record, ten times a second is considered good for most normal
        -- games (including many MMOs), and you shouldn't ever really need more
        -- than 30 updates a second, even for fast-paced games.
        if Testing.ServerClient.t > Testing.ServerClient.updaterate then
            -- we could send updates for every little move, but we consolidate
            -- the last update-worth here into a single packet, drastically reducing
            -- our bandwidth use.
            local x, y = 0, 0
            if love.keyboard.isDown('up') then      y=y-(20*Testing.ServerClient.t) end
            if love.keyboard.isDown('down') then    y=y+(20*Testing.ServerClient.t) end
            if love.keyboard.isDown('left') then    x=x-(20*Testing.ServerClient.t) end
            if love.keyboard.isDown('right') then   x=x+(20*Testing.ServerClient.t) end


            -- again, we prepare a packet *payload* using string.format,
            -- then send it on its way with udp:send
            -- this one is the move update mentioned above
            local dg = string.format("%s %s %f %f", Testing.ServerClient.entity, 'move', x, y)
            Testing.ServerClient.udp:send(dg)

            -- and again! this is a require that the server send us an update for
            --  the world state
            --
            -- [NOTE: in most designs you don't request world-state updates, you
            -- just get them sent to you periodically. theres various reasons for
            -- this, but theres one *BIG* one you will have to solemnly take note
            -- of: 'anti-griefing'. World-updates are probably one of biggest things
            -- the average game-server will pump out on a regular basis, and greifing
            -- with forged update requests would be simple effective. so they just
            -- don't support update requests, instead giving them out when they feel
            -- its appropriate]
            local dg = string.format("%s %s $", entity, 'update')
            Testing.ServerClient.udp:send(dg)

            Testing.ServerClient.t=Testing.ServerClient.t-Testing.ServerClient.updaterate -- set t for the next round
        end


        -- there could well be more than one message waiting for us, so we'll
        -- loop until we run out!
        repeat
            -- and here is something new, the much anticipated other end of udp:send!
            -- receive return a waiting packet (or nil, and an error message).
            -- data is a string, the payload of the far-end's send. we can deal with it
            -- the same ways we could deal with any other string in lua (needless to
            -- say, getting familiar with lua's string handling functions is a must.
            data, msg = Testing.ServerClient.udp:receive()

            if data then -- you remember, right? that all values in lua evaluate as true, save nil and false?

                -- match is our freind here, its part of string.*, and data is
                -- (or should be!) a string. that funky set of characters bares some
                -- explanation, though.
                -- (need summary of patterns, and link to section 5.4.1)
                ent, cmd, parms = data:match("^(%S*) (%S*) (.*)")
                if cmd == 'at' then
                    -- more patterns, this time with sets, and more length selectors!
                    local x, y = parms:match("^(%-?[%d.e]*) (%-?[%d.e]*)$")
                    assert(x and y) -- validation is better, but asserts will serve.

                    -- don't forget, even if you matched a "number", the result is still a string!
                    -- thankfully conversion is easy in lua.
                    x, y = tonumber(x), tonumber(y)
                    -- and finally we stash it away
                    Testing.ServerClient.world[ent] = {x=x, y=y}
                else
                    -- this case shouldn't trigger often, but its always a good idea
                    -- to check (and log!) any unexpected messages and events.
                    -- it can help you find bugs in your code...or people trying to hack the server.
                    -- never forget, you can not trust the client!
                    print("unrecognised command:", cmd)
                end

            -- if data was nil, then msg will contain a short description of the
            -- problem (which are also error id...).
            -- the most common will be 'timeout', since we settimeout() to zero,
            -- anytime there isn't data *waiting* for us, it'll timeout.
            --
            -- but we should check to see if its a *different* error, and act accordingly.
            -- in this case we don't even try to save ourselves, we just error out.
            elseif msg ~= 'timeout' then
                error("Network error: "..tostring(msg))
            end
        until not data
    end
end

-- love.draw, hopefully you are familiar with it from the callbacks tutorial
function Testing.ServerClient.render()
    if Testing.ServerClient.clientStarted then
        -- pretty simple, we just loop over the world table, and print the
        -- name (key) of everything in their, at its own stored co-ords.
        for k, v in pairs(Testing.ServerClient.world) do
            love.graphics.print(k, v.x, v.y)
        end
    end
end

function Testing.ServerClient.startClient()
    -- to start with, we need to require the 'socket' lib (which is compiled
    -- into love). socket provides low-level networking features.
    Testing.ServerClient.socket = require "socket"

    -- the address and port of the server
    Testing.ServerClient.address = "localhost"
    Testing.ServerClient.port = 12345

    Testing.ServerClient.entity = nil -- entity is what we'll be controlling
    Testing.ServerClient.updaterate = 0.1 -- how long to wait, in seconds, before requesting an update

    Testing.ServerClient.world = {} -- the empty world-state

    -- t is just a variable we use to help us with the update rate in love.update.
    Testing.ServerClient.t = 0



    -- first up, we need a udp socket, from which we'll do all
    -- out networking.
    Testing.ServerClient.udp = Testing.ServerClient.socket.udp()

    -- normally socket reads block until they have data, or a
    -- certain amout of time passes.
    -- that doesn't suit us, so we tell it not to do that by setting the
    -- 'timeout' to zero
    Testing.ServerClient.udp:settimeout(0)

    -- unlike the server, we'll just be talking to the one machine,
    -- so we'll "connect" this socket to the server's address and port
    -- using setpeername.
    --
    -- [NOTE: UDP is actually connectionless, this is purely a convenience
    -- provided by the socket library, it doesn't actually change the
    --'bits on the wire', and in-fact we can change / remove this at any time.]
    Testing.ServerClient.udp:setpeername(Testing.ServerClient.address, Testing.ServerClient.port)

    -- entity will be what we'll be controlling, for the sake of this
    -- tutorial its just a number, but it'll do.
    -- we'll just use random to give us a reasonably unique identity for little effort.
    --
    -- [NOTE: random isn't actually a very good way of doing this, but the
    -- "correct" ways are beyond the scope of this article. the *simplest*
    -- is just an auto-count, they get a *lot* more fancy from there on in]

    Testing.ServerClient.entity = tostring(math.random(99999))

    -- Here we do our first bit of actual networking:
    -- we set up a string containing the data we want to send (using 'string.format')
    -- and then send it using 'udp.send'. since we used 'setpeername' earlier
    -- we don't even have to specify where to send it.
    --
    -- thats...it, really. the rest of this is just putting this context and practical use.
    Testing.ServerClient.dg = string.format("%s %s %d %d", Testing.ServerClient.entity, 'at', 320, 240)
    Testing.ServerClient.udp:send(Testing.ServerClient.dg) -- the magic line in question.

    Testing.ServerClient.clientStarted = true
end

-- And thats the end of the udp client example.

function Testing.ServerClient.createGUI()

    Testing.ServerClient.GUI = GUI.Container(nil,Utilities.Color.white,nil,{255,255,255,200},{255,255,255,200},nil,Utilities.Color.black)
-- create a label
    local label = GUI.Label("ServerClient Test")
-- set anchors
    label:setBottomAnchor(GUI.Root, "top")
-- set offsets
    label.leftAnchorOffset   = 20
    label.rightAnchorOffset  = -20
    label.topAnchorOffset    = 20
    label.bottomAnchorOffset = 60


-- create a button to start thread1
    local button_startServer = GUI.Button("Start Server", function()
        Testing.ServerClient.serverThread = love.thread.newThread("Networking/examples/server/main.lua")
        Testing.ServerClient.serverThread:start()
    end)
-- set anchors
    button_startServer:setTopAnchor(GUI.Root, "bottom")
    button_startServer:setRightAnchor(GUI.Root, "center")
-- set offsets
    button_startServer.leftAnchorOffset   = 20
    button_startServer.rightAnchorOffset  = -20
    button_startServer.topAnchorOffset    = -60
    button_startServer.bottomAnchorOffset = -20


-- create a button to start thread2
    local button_startClient = GUI.Button("Start Client", function()
        Testing.ServerClient.startClient()
    end)
-- set anchors
    button_startClient:setTopAnchor(GUI.Root, "bottom")
    button_startClient:setLeftAnchor(GUI.Root, "center")
-- set offsets
    button_startClient.leftAnchorOffset   = 20
    button_startClient.rightAnchorOffset  = -20
    button_startClient.topAnchorOffset    = -60
    button_startClient.bottomAnchorOffset = -20

    Testing.ServerClient.GUI:addWidget(button_startServer)
    Testing.ServerClient.GUI:addWidget(button_startClient)
end
