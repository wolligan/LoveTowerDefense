--- ADD ME
require "Game"

---
function love.load()
	love.window.setMode( 800, 600, { fullscreen = false } )
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
