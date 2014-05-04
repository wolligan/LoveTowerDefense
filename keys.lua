require "keybindings"

Keys = {}
Keys.activeKeys = {}

function love.keypressed(key)
	Keys.activeKeys[key] = true
	if Game.state.activeKeyBinding[key] then
		if Game.state.activeKeyBinding[key].mode == "single" then
			Game.state.activeKeyBinding[key].fun()
		end
	end
end

function love.keyreleased(key)
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
	for key,keyBinding in pairs(Game.state.activeKeyBinding) do
		if Keys.isKeyDown(key) and keyBinding.mode == "repeat" then
			keyBinding.fun(dt)
		end
	end
end
