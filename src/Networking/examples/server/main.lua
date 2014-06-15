--- server example from the love wikie

local socket = require "socket"

-- begin
local udp = socket.udp()

-- normally socket reads block until they have data, or a
-- certain amount of time passes.
-- that doesn't suit us, so we tell it not to do that by setting the
-- 'timeout' to zero
udp:settimeout(0)

-- unlike the client, the server has to be specific about where its
-- 'bound', or the poor clients will never find it.
-- thus while we can happily let the client auto-bind to whatever it likes,
-- we have to tell the server to bind to something known.
--
-- the first part is which "interface" we should bind to...a bit beyond this tutorial, but '*' basically means "all of them"
-- port is simpler, the system maintains a list of up to 65535 (!) "ports"
-- ...really just numbers. point is that if you send to a particular port,
-- then only things "listening" to that port will be able to receive it,
-- and likewise you can only read data sent to ports you are listening too.
-- generally speaking, if an address is which machine you want to talk to, then a port is what program on that machine you want to talk to.
--
-- [NOTE: on some operating systems, ports between 0 and 1024 are "reserved for
-- privileged processes". its a security precaution for those system.
-- generally speaking, just not using ports in that range avoids a lot of problems]
udp:setsockname('*', 12345)

local world = {} -- the empty world-state

-- We declare a whole bunch of local variables that we'll be using the in
-- main server loop below. you probably recognise some of them from the
--client example, but you are also probably wondering what's with the fruity
-- names, 'msg_or_ip'? 'port_or_nil'?
--
-- well, we're using a slightly different function this time, you'll see when we get there.
local data, msg_or_ip, port_or_nil
local entity, cmd, parms
-- indefinite loops are probably not something you used to if you only
-- know love, but they are quite common. and in fact love has one at its
-- heart, you just don't see it.
-- regardless, we'll be needing one for our server. and this little
-- variable lets us *stop* it :3
local running = true

-- the beginning of the loop proper...
print "Beginning server loop."
while running do
    -- this line looks familiar, I'm sure, but we're using 'receivefrom'
    -- this time. its similar to receive, but returns the data, sender's
    -- ip address, and the sender's port. (which you'll hopefully recognise
    -- as the two things we need to send messages to someone)
    -- we didn't have to do this in the client example because we just bound
    -- the socket to the server. ...but that also ignores messages from
    -- sources other than what we've bound to, which obviously won't do at
    -- all as a server.
    --
    -- [NOTE: strictly, we could have just used receivefrom (and its
    -- counterpart, sendto) in the client. there's nothing special about the
    -- functions to prevent it, indeed. send/receive are just convenience
    -- functions, sendto/receive from are the real workers.]
    data, msg_or_ip, port_or_nil = udp:receivefrom()
    if data then
        -- more of these funky match paterns!
        entity, cmd, parms = data:match("^(%S*) (%S*) (.*)")
        if cmd == 'move' then
            local x, y = parms:match("^(%-?[%d.e]*) (%-?[%d.e]*)$")
            assert(x and y) -- validation is better, but asserts will serve.
            -- don't forget, even if you matched a "number", the result is still a string!
            -- thankfully conversion is easy in lua.
            x, y = tonumber(x), tonumber(y)
            -- and finally we stash it away
            local ent = world[entity] or {x=0, y=0}
            world[entity] = {x=ent.x+x, y=ent.y+y}
        elseif cmd == 'at' then
            local x, y = parms:match("^(%-?[%d.e]*) (%-?[%d.e]*)$")
            assert(x and y) -- validation is better, but asserts will serve.
            x, y = tonumber(x), tonumber(y)
            world[entity] = {x=x, y=y}
        elseif cmd == 'update' then
            for k, v in pairs(world) do
                udp:sendto(string.format("%s %s %d %d", k, 'at', v.x, v.y), msg_or_ip,  port_or_nil)
            end
        elseif cmd == 'quit' then
            running = false;
        else
            print("unrecognised command:", cmd)
        end
    elseif msg_or_ip ~= 'timeout' then
        error("Unknown network error: "..tostring(msg))
    end

    socket.sleep(0.01)
end

print "Thank you."

-- and that the end of the udp server example.
