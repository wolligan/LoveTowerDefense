--- Implementation of a simple thread example
--@author Steve Wolligandt

require "love.filesystem"
require "love.timer"
require "Utilities"

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
    Thread.channel = love.thread.getChannel("Thread1")
    Thread.lastTime = love.timer.getTime()
end

function Thread.getDeltaTime()
    local dt = love.timer.getTime() - Thread.lastTime
    Thread.lastTime = love.timer.getTime()
    return dt
end

function Thread.handleMessages()
    local curMessage = Thread.channel:pop()
    if curMessage then
        print("Current Message: " .. tostring(curMessage))
    end
end

function Thread.update(dt)
    --print(dt)
end

Thread.run()
