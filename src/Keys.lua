--- Handles key and mouse
require "Keybindings"

Keys = {}
Keys.activeKeys = {}

--- love callback - updates keymap and calls function of single button setting (keyboard)
-- @param key key that is currently pressed
function love.keypressed(key)
	Keys.activeKeys[key] = true
    if GUI.activeContainer then
        if not GUI.activeContainer.stealKeys then
            if Game.state.activeKeyBinding then
                if Game.state.activeKeyBinding[key] then
                    if Game.state.activeKeyBinding[key].pressed then
                        Game.state.activeKeyBinding[key].pressed()
                    end
                end
            end
        end
    else
        if Game.state.activeKeyBinding then
            if Game.state.activeKeyBinding[key] then
                if Game.state.activeKeyBinding[key].pressed then
                    Game.state.activeKeyBinding[key].pressed()
                end
            end
        end
    end
    GUI.notifyKey(key)
end

--- love callback - updates keymap
-- @param key key that is currently released
function love.keyreleased(key)
	Keys.activeKeys[key] = false
    if GUI.activeContainer then
        if not GUI.activeContainer.stealKeys then
            if Game.state.activeKeyBinding then
                if Game.state.activeKeyBinding[key] then
                    if Game.state.activeKeyBinding[key].released then
                        Game.state.activeKeyBinding[key].released()
                    end
                end
            end
        end
    else
        if Game.state.activeKeyBinding then
            if Game.state.activeKeyBinding[key] then
                if Game.state.activeKeyBinding[key].released then
                    Game.state.activeKeyBinding[key].released()
                end
            end
        end
    end
end

--- love callback - updates keymap and calls function of single button setting (mouse)
-- @param x x-coordinate of mouse
-- @param y y-coordinate of mouse
-- @param button mouse button that is currently pressed
function love.mousepressed(x, y, button)
    local key = Keys.mouseButtonToKey(button)
	Keys.activeKeys[key] = true
    if GUI.activeContainer then
        if not GUI.activeContainer.stealKeys then
            if Game.state.activeKeyBinding then
                if Game.state.activeKeyBinding[key] then
                    if Game.state.activeKeyBinding[key].pressed then
                        Game.state.activeKeyBinding[key].pressed()
                    end
                end
            end
        end
    else
        if Game.state.activeKeyBinding then
            if Game.state.activeKeyBinding[key] then
                if Game.state.activeKeyBinding[key].pressed then
                    Game.state.activeKeyBinding[key].pressed()
                end
            end
        end
    end

    if button == "l" then
        GUI.notifyClick()
    end
end

--- love callback - updates keymap
-- @param x x-coordinate of mouse
-- @param y y-coordinate of mouse
-- @param button mouse button that is currently released
function love.mousereleased(x, y, button)
    local key = Keys.mouseButtonToKey(button)
	Keys.activeKeys[key] = false
    if GUI.activeContainer then
        if not GUI.activeContainer.stealKeys then
            if Game.state.activeKeyBinding then
                if Game.state.activeKeyBinding[key] then
                    if Game.state.activeKeyBinding[key].released then
                        Game.state.activeKeyBinding[key].released()
                    end
                end
            end
        end
    else
         if Game.state.activeKeyBinding then
            if Game.state.activeKeyBinding[key] then
                if Game.state.activeKeyBinding[key].released then
                    Game.state.activeKeyBinding[key].released()
                end
            end
        end
    end
    GUI.notifyRelease()
end

--- returns wheither a key is currently pressed or not
-- @param key key to check
function Keys.isKeyDown(key)
	if Keys.activeKeys[key] then
		return Keys.activeKeys[key]
	else
		return false
	end
end

--- calls function of repeat button setting
-- @param dt delta time
function Keys.handleKeyBindings(dt)
    if GUI.activeContainer then
        if not GUI.activeContainer.stealKeys then
            if Game.state.activeKeyBinding then
                for key,keyBinding in pairs(Game.state.activeKeyBinding) do
                    if Keys.isKeyDown(key) and keyBinding.repeated then
                        keyBinding.repeated(dt)
                    end
                end
            end
        end
    else
        if Game.state.activeKeyBinding then
            for key,keyBinding in pairs(Game.state.activeKeyBinding) do
                if Keys.isKeyDown(key) and keyBinding.repeated then
                    keyBinding.repeated(dt)
                end
            end
        end
    end
end

--- converts love mouse button namings
-- @param button mouse button name that shall be transformed
function Keys.mouseButtonToKey(button)

    local key
    if button == "l" then
        key = "mouse_left"
    elseif button == "r" then
        key = "mouse_right"
    elseif button == "m" then
        key = "mouse_middle"
    elseif button == "wd" then
        key = "mouse_wd"
    elseif button == "wu" then
        key = "mouse_wu"
    elseif button == "x1" then
        key = "mouse_x1"
    elseif button == "x2" then
        key = "mouse_x2"
    end

    return key
end
