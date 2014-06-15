--- Server example from love wiki as thread
require "love.filesystem"
require "love.timer"
require "Utilities"

local socket = require "socket"

print("Thread started")

local udp = socket.udp()
local port = 2033
udp:settimeout(0)
udp:setsockname('*', port)

local data, msg, port
local cmd, parms
local running = true

print(string.format("Server initiliazed, port: %d", port))
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
    data, msg, port = udp:receivefrom()
    if data then
        cmd, parms = data:match("^(%S*) (.*)")
        print string.format("Received Message: %s", data)
        print string.format("Command: %s with parameters %s", cmd, parms)
        if cmd == "kill" then
            running = false
            print "Server was killed." -- TODO only originating game client can kill the server
        end
    elseif msg ~= 'timeout' then
        error("Unknown network error: "..tostring(msg))
    end

    socket.sleep(0.01)
end

print "Thank you."

-- and that the end of the udp server example.
