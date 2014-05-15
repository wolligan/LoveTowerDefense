--- Starting point of love
require "Game"

--- Initializes Game
function love.load()
    Game.init()
end

--- draws game
function love.draw()
    Game.render()
end

--- updates game
-- @param dt delta time
function love.update(dt)
    Game.update(dt)
end
