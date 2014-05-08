require "keybindings"

Keys = {}
Keys.activeKeys = {}

function love.keypressed(key)
	Keys.activeKeys[key] = true
    if Game.state.activeKeyBinding then
        if Game.state.activeKeyBinding[key] then
            if Game.state.activeKeyBinding[key].mode == "single" then
                Game.state.activeKeyBinding[key].fun()
            end
        end
    end
end

function love.keyreleased(key)
	Keys.activeKeys[key] = false
end

function love.mousepressed(x, y, button)
    local key = Keys.mouseButtonToKey(button)
	Keys.activeKeys[key] = true
    if Game.state.activeKeyBinding then
        if Game.state.activeKeyBinding[key] then
            if Game.state.activeKeyBinding[key].mode == "single" then
                Game.state.activeKeyBinding[key].fun()
            end
        end
    end
end

function love.mousereleased(x, y, button)
    local key = Keys.mouseButtonToKey(button)
	Keys.activeKeys[key] = false
end

function Keys.isKeyDown(key)
	if Keys.activeKeys[key] then
		return Keys.activeKeys[key]
	else
		return false
	end
end

function Keys.handleKeyBindings(dt)
    if Game.state.activeKeyBinding then
        for key,keyBinding in pairs(Game.state.activeKeyBinding) do
            if Keys.isKeyDown(key) and keyBinding.mode == "repeat" then
                keyBinding.fun(dt)
            end
        end
    end
end

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
