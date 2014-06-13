--- Implementation of a simple thread example
--@author Steve Wolligandt

require "love.filesystem"
require "love.timer"

Thread = {}
function Thread.run()
    Thread.init()
    while Thread.isRunning do
        Thread.handleMessages()
        Thread.update(Thread.getDeltaTime())
    end
end

function Thread.init()
    Thread.isRunning = true
    Thread.channel = love.thread.getChannel("Thread2")
    Thread.lastTime = love.timer.getTime()
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
    print("ich komme von Thread2 - dt = " .. dt)
end




function Thread.getDeltaTime()
    local dt = love.timer.getTime() - Thread.lastTime
    Thread.lastTime = love.timer.getTime()
    return dt
end

Thread.run()
