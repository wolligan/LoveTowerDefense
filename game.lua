Game = {}

require "keys"
require "textOutput"
require "ingame"
require "mainmenu"
require "networking"
require "splashscreen"
require "gui"
require "tables"
require "lighttest"

Game.spritePool = {}
Game.soundPool = {}
Game.state = nil

function Game.init()
	math.randomseed(os.time())
	success = love.window.setMode( 1920, 1080, {fullscreen=true} )
    Game.changeState(LightTest)
end

function Game.render()
    Game.state.render()
	textOutput.draw()
end

function Game.update(dt)
	Keys.handleKeyBindings(dt)
    Game.state.update(dt)
end

function Game.changeState(state)
    Game.state = state
    if not Game.state.inited then
        Game.state.init()
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
