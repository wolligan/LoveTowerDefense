--- Game represents the main engine that handles GUI, key presses and releases and game states.
-- Game states are something like scenes with their own render, update, init, onActivate and onDeactivate functions and their own GUI Containers.
-- When there is a state change, Game changes the GUI to the one of the state.
-- Also Game has some containers that hold sprites, sounds and fonts, so that you will not have the same asset multiple times in memory.
--@author Steve Wolligandt

Game = {}

require "Utilities"
require "Keys"
require "GUI"

Game.spritePool = {}
Game.soundPool = {}
Game.fontPool = {}
Game.state = nil
Game.coroutines = {}

--- State managing
--@section manage

--- initializes the engine
--@param initialState Game State Manager will start this state at first
function Game.init(initialState)
	love.window.setMode( 1366, 768, { fullscreen = true } )
	math.randomseed(os.time())
    Game.changeState(initialState)
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
--@param dt delta time
function Game.update(dt)
    Game.state.GUI = GUI.activeContainer
	Keys.handleKeyBindings(dt)
    GUI.update(dt)
    if Game.state.update then
        Game.state.update(dt)
    end

    Game.handleCoroutines()
end

--- changes current game state and calls some callbacks
--@param state Changes to this state
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

--- Coroutine Management
--@section coroutine

--- adds a coroutine to couroutine list
-- @param coroutine coroutine to add
function Game.startCoroutine(coroutine)
    Game.coroutines[#Game.coroutines+1] = coroutine
end

--- Handles active coroutines
function Game.handleCoroutines()
   for i=#Game.coroutines,1,-1 do
        if coroutine.status(Game.coroutines[i]) == "dead" then
            table.remove(Game.coroutines, i)
        else
            coroutine.resume(Game.coroutines[i])
        end
    end
end

--- Memory Management
--@section memory

--- loads sprites, if sprite is already loaded it returns a reference to this
--@param path path to sprite
function Game.getSprite(path)
    if not Game.spritePool[path] then
        Game.spritePool[path] = love.graphics.newImage(path)
    end
    return Game.spritePool[path]
end

--- loads fonts, if font is already loaded it returns a reference to this
--@param path path to font
--@param size size of the font in pt
function Game.getFont(path, size)
    if not Game.fontPool[path.."_"..(size or 12)] then
        Game.fontPool[path.."_"..(size or 12)] = love.graphics.newFont(path, (size or 12))
    end
    return Game.fontPool[path.."_"..(size or 12)]
end

--- loads sounds, if sound is already loaded it returns a reference to this
--@param path path to sound
--@param type type of the sound [see löve wiki](http://love2d.org/wiki/SourceType)
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
