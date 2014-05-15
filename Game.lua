--- ADD ME
Game = {}

require "Utilities"
require "Keys"
require "Ingame"
require "MainMenu"
require "Networking"
require "SplashScreen"
require "GUI"
require "Testing"

Game.spritePool = {}
Game.soundPool = {}
Game.fontPool = {}
Game.state = nil

---
function Game.init()
	math.randomseed(os.time())
    Game.changeState(Testing.Menu)
end

---
function Game.render()
    if Game.state.render then
        Game.state.render()
    end
	Utilities.TextOutput.draw()
end

---
function Game.update(dt)
	Keys.handleKeyBindings(dt)
    if Game.state.update then
        Game.state.update(dt)
    end
end

---
function Game.changeState(state)
    Game.state = state
    if not Game.state.inited then
        if Game.state.init then
            Game.state.init()
        end
        Game.state.inited = true
    end
end

---
function Game.getSprite(path)
    if not Game.spritePool[path] then
        Game.spritePool[path] = love.graphics.newImage(path)
    end
    return Game.spritePool[path]
end

---
function Game.getFont(path)
    if not Game.fontPool[path] then
        Game.fontPool[path] = love.graphics.newFont(path)
    end
    return Game.fontPool[path]
end

---
function Game.getSound(path, type)
    if not Game.soundPool[path] then
        Game.soundPool[path] = love.audio.newSource(path, type)
    end
    return Game.soundPool[path]
end

---
function Game.tidyUpSpritePool()
    Game.spritePool = {}
end

---
function Game.tidyUpSoundPool()
    Game.soundPool = {}
end


---
function Game.tidyUpFontPool()
    Game.soundPool = {}
end
