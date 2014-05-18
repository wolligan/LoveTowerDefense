require "Utilities.init"
Thread= {}
function Thread.run()
    Thread.init()
    while Thread.isRunning do
        Thread.handleMessages()
        Thread.update()
    end
end

function Thread.init()
    Thread.isRunning = true
    Thread.channel = love.thread.getChannel("Thread1")
end

function Thread.handleMessages()
    local curMessage = Thread.channel:pop()
    if curMessage then
        print("Current Message: " .. tostring(curMessage))
    end
end

function Thread.update()
    if Thread.Utilities then
        Thread.Utilities.TextOutput.print("ich komme von Thread1")
    end
end

Thread.run()
