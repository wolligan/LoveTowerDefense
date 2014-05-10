Game = {}

require "keys"
require "textOutput"
require "ingame"
require "mainmenu"
require "networking"
require "splashscreen"
require "gui"
require "tables"
require "testing"

Game.spritePool = {}
Game.soundPool = {}
Game.state = nil

function Game.init()
	math.randomseed(os.time())
	success = love.window.setMode( 800, 600, { fullscreen = false } )
    Game.changeState(Testing.Lighting)
end

function Game.render()
    if Game.state.render then
        Game.state.render()
    end
	textOutput.draw()
end

function Game.update(dt)
	Keys.handleKeyBindings(dt)
    if Game.state.update then
        Game.state.update(dt)
    end
end

function Game.changeState(state)
    Game.state = state
    if not Game.state.inited then
        if Game.state.init then
            Game.state.init()
        end
        Game.state.inited = true
    end
end

function Game.getSprite(path)
    if not Game.spritePool[path] then
        Game.spritePool[path] = love.graphics.newImage(path)
    end
    return Game.spritePool[path]
end

function Game.getSound(path, type)
    if not Game.soundPool[path] then
        Game.soundPool[path] = love.audio.newSource(path, type)
    end
    return Game.soundPool[path]
end

function Game.tidyUpSpritePool()
    Game.spritePool = {}
end

function Game.tidyUpSoundPool()
    Game.soundPool = {}
end
