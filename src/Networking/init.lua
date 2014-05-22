--- ADD ME
Networking = {}

function Networking.spawnServer() -- TODO make port as user input
    Networking.Server = love.thread.newThread("Networking/server.lua")
    Networking.Server:start()
    print "Starting Server ... "
end
