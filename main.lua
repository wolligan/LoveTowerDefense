--- ADD ME
require "Game"

---
function love.load()
	love.window.setMode( 1920, 1080, { fullscreen = true } )
    Game.init()
end

---
function love.draw()
    Game.render()
end

---
function love.update(dt)
    Game.update(dt)
end
