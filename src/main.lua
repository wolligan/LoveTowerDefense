--- Starting point of love
--@author Steve Wolligandt
require "Game"
require "Ingame"

--- Initializes Game
function love.load()
    Game.init(SplashScreen)
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
