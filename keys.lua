require "keybindings"

keys = {}
keys.activeKeys = {}
keys.activeKeyBinding = keyBindings.defaultKeyBinding

function love.keypressed(key)
	keys.activeKeys[key] = true
	if keys.activeKeyBinding[key] then
		if keys.activeKeyBinding[key].mode == "single" then
			keys.activeKeyBinding[key].fun()
		end
	end
end

function love.keyreleased(key)
	keys.activeKeys[key] = false
end

function keys.isKeyDown(key)
	if keys.activeKeys[key] then
		return keys.activeKeys[key]
	else
		return false
	end
end

function keys.handleKeyBindings(dt)
	for key,keyBinding in pairs(keys.activeKeyBinding) do
		if keys.isKeyDown(key) and keyBinding.mode == "repeat" then
			keyBinding.fun(dt)
		end
	end
end