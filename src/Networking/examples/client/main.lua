-- to start with, we need to require the 'socket' lib (which is compiled
-- into love). socket provides low-level networking features.
local socket = require "socket"

-- the address and port of the server
local address, port = "localhost", 12345

local entity -- entity is what we'll be controlling
local updaterate = 0.1 -- how long to wait, in seconds, before requesting an update

local world = {} -- the empty world-state
local t

-- love.load, hopefully you are familiar with it from the callbacks tutorial
function love.load()

    -- first up, we need a udp socket, from which we'll do all
    -- out networking.
    udp = socket.udp()

    -- normally socket reads block until they have data, or a
    -- certain amout of time passes.
    -- that doesn't suit us, so we tell it not to do that by setting the
    -- 'timeout' to zero
    udp:settimeout(0)

    -- unlike the server, we'll just be talking to the one machine,
    -- so we'll "connect" this socket to the server's address and port
    -- using setpeername.
    --
    -- [NOTE: UDP is actually connectionless, this is purely a convenience
    -- provided by the socket library, it doesn't actually change the
    --'bits on the wire', and in-fact we can change / remove this at any time.]
    udp:setpeername(address, port)

    -- seed the random number generator, so we don't just get the
    -- same numbers each time.
    math.randomseed(os.time())

    -- entity will be what we'll be controlling, for the sake of this
    -- tutorial its just a number, but it'll do.
    -- we'll just use random to give us a reasonably unique identity for little effort.
    --
    -- [NOTE: random isn't actually a very good way of doing this, but the
    -- "correct" ways are beyond the scope of this article. the *simplest*
    -- is just an auto-count, they get a *lot* more fancy from there on in]

    entity = tostring(math.random(99999))

    -- Here we do our first bit of actual networking:
    -- we set up a string containing the data we want to send (using 'string.format')
    -- and then send it using 'udp.send'. since we used 'setpeername' earlier
    -- we don't even have to specify where to send it.
    --
    -- thats...it, really. the rest of this is just putting this context and practical use.
    local dg = string.format("%s %s %d %d", entity, 'at', 320, 240)
    udp:send(dg) -- the magic line in question.

    -- t is just a variable we use to help us with the update rate in love.update.
    t = 0 -- (re)set t to 0
end

-- love.update, hopefully you are familiar with it from the callbacks tutorial
function love.update(deltatime)

    t = t + deltatime -- increase t by the deltatime

    -- its *very easy* to completely saturate a network connection if you
    -- aren't careful with the packets we send (or request!), we hedge
    -- our chances by limiting how often we send (and request) updates.
    --
    -- for the record, ten times a second is considered good for most normal
    -- games (including many MMOs), and you shouldn't ever really need more
    -- than 30 updates a second, even for fast-paced games.
    if t > updaterate then
        -- we could send updates for every little move, but we consolidate
        -- the last update-worth here into a single packet, drastically reducing
        -- our bandwidth use.
        local x, y = 0, 0
        if love.keyboard.isDown('up') then  y=y-(20*t) end
        if love.keyboard.isDown('down') then    y=y+(20*t) end
        if love.keyboard.isDown('left') then    x=x-(20*t) end
        if love.keyboard.isDown('right') then   x=x+(20*t) end


        -- again, we prepare a packet *payload* using string.format,
        -- then send it on its way with udp:send
        -- this one is the move update mentioned above
        local dg = string.format("%s %s %f %f", entity, 'move', x, y)
        udp:send(dg)

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
        udp:send(dg)

        t=t-updaterate -- set t for the next round
    end


    -- there could well be more than one message waiting for us, so we'll
    -- loop until we run out!
    repeat
        -- and here is something new, the much anticipated other end of udp:send!
        -- receive return a waiting packet (or nil, and an error message).
        -- data is a string, the payload of the far-end's send. we can deal with it
        -- the same ways we could deal with any other string in lua (needless to
        -- say, getting familiar with lua's string handling functions is a must.
        data, msg = udp:receive()

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
                world[ent] = {x=x, y=y}
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

-- love.draw, hopefully you are familiar with it from the callbacks tutorial
function love.draw()
    -- pretty simple, we just loop over the world table, and print the
    -- name (key) of everything in their, at its own stored co-ords.
    for k, v in pairs(world) do
        love.graphics.print(k, v.x, v.y)
    end
end

-- And thats the end of the udp client example.
