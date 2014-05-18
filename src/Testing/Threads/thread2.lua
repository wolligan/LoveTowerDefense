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
    Thread.channel = love.thread.getChannel("Thread2")
end

function Thread.handleMessages()
    local message = Thread.channel:pop()
    if message then
        print("Current Message: " .. tostring(message))

        if message == "kill" then
            Thread.isRunning = false
        end
    end
end

function Thread.update(dt)
    print("ich komme von Thread2")
end

Thread.run()
