require "keys"
require "textOutput"
require "ingame"
require "mainmenu"
require "networking"
require "splashscreen"
require "gui"
require "tables"

Game = {}
Game.state = Ingame

function Game.init()
	success = love.window.setMode( 800, 600, {fullscreen=false} )

    if not Game.state.inited then
        Game.state.init()
        Game.state.inited = true
    end
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
