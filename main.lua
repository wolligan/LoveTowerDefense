--- ADD ME
require "Game"

---
function love.load()
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
