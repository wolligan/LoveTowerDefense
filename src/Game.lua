--- Game represents kind of an engine that handles GUI, key presses and releases and game states. Game states are something like scenes with their own render, update, init, onActivate and onDeactivate functions.
Game = {}

require "Utilities"
require "Keys"
require "Ingame"
require "Tilemap"
require "MainMenu"
require "Networking"
require "SplashScreen"
require "GUI"
require "Testing"
require "LevelEditor"

Game.spritePool = {}
Game.soundPool = {}
Game.fontPool = {}
Game.state = nil
Game.coroutines = {}

--- initializes the engine
function Game.init()
	love.window.setMode( 1000, 600, { fullscreen = false } )
	math.randomseed(os.time())
    Game.changeState(Testing.Menu)
    --Game.changeState(Ingame)
end

--- renders current game state, gui and textoutput
function Game.render()
    if Game.state.render then
        Game.state.render()
    end
    GUI.render()
	Utilities.TextOutput.draw()
end

--- updates current game state, gui and keyhandling
function Game.update(dt)
    Game.state.GUI = GUI.activeContainer
	Keys.handleKeyBindings(dt)
    GUI.update(dt)
    if Game.state.update then
        Game.state.update(dt)
    end

    for i=#Game.coroutines,1,-1 do
        if coroutine.status(Game.coroutines[i]) == "dead" then
            table.remove(Game.coroutines, i)
        else
            coroutine.resume(Game.coroutines[i])
        end
    end
end

--- changes current game state and calls some callbacks
function Game.changeState(state)
    if state ~= Game.state then

        -- call onDeactivate of old state
        if Game.state then
            if Game.state.onDeactivate then
                Game.state.onDeactivate()
            end
        end

        -- reassign
        Game.state = state

        -- init new game state if not already done
        if not Game.state.inited then
            if Game.state.init then
                GUI.activeContainer = nil
                Game.state.init()
                Game.state.GUI = GUI.activeContainer
            end
            Game.state.inited = true
        end

        -- call onActivate of new state
        if Game.state.onActivate then
            Game.state.onActivate()
        end

        -- set GUI container to GUI container of new state
        GUI.activeContainer = Game.state.GUI
    end
end

--- adds a coroutine to couroutine list
-- @param coroutine coroutine to add
function Game.startCoroutine(coroutine)
    Game.coroutines[#Game.coroutines+1] = coroutine
end

--- loads sprites, if sprite is already loaded it returns a reference to this
function Game.getSprite(path)
    if not Game.spritePool[path] then
        Game.spritePool[path] = love.graphics.newImage(path)
    end
    return Game.spritePool[path]
end

--- loads fonts, if font is already loaded it returns a reference to this
function Game.getFont(path)
    if not Game.fontPool[path] then
        Game.fontPool[path] = love.graphics.newFont(path)
    end
    return Game.fontPool[path]
end

--- loads sounds, if sound is already loaded it returns a reference to this
function Game.getSound(path, type)
    if not Game.soundPool[path] then
        Game.soundPool[path] = love.audio.newSource(path, type)
    end
    return Game.soundPool[path]
end

--- clears the sprite pool
function Game.tidyUpSpritePool()
    Game.spritePool = {}
end

--- clears the sound pool
function Game.tidyUpSoundPool()
    Game.soundPool = {}
end

--- clears the font pool
function Game.tidyUpFontPool()
    Game.soundPool = {}
end
