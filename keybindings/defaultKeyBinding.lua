keyBindings.defaultKeyBinding = {}

keyBindings.defaultKeyBinding["w"] = {
	mode = "repeat",
	fun = function(dt)
		Scene.characters[Scene.playerIndex]:moveUp(dt)
	end
}

keyBindings.defaultKeyBinding["a"] = {
	mode = "repeat",
	fun = function(dt)
		Scene.characters[Scene.playerIndex]:moveLeft(dt)
	end
}


keyBindings.defaultKeyBinding["s"] = {
	mode = "repeat",
	fun = function(dt)
		Scene.characters[Scene.playerIndex]:moveDown(dt)
	end
}


keyBindings.defaultKeyBinding["d"] = {
	mode = "repeat",
	fun = function(dt)
		Scene.characters[Scene.playerIndex]:moveRight(dt)
	end
}


keyBindings.defaultKeyBinding["up"] = {
	mode = "single",
	fun = function(dt)
		Scene.playerIndex = math.min(#Scene.characters, Scene.playerIndex + 1)
		--camera.rotation = camera.rotation + 10*dt
	end
}


keyBindings.defaultKeyBinding["down"] = {
	mode = "single",
	fun = function(dt)
		Scene.playerIndex = math.max(1, Scene.playerIndex - 1)
		--camera.rotation = camera.rotation - 10*dt
	end
}


keyBindings.defaultKeyBinding["escape"] = {
	mode = "single",
	fun = function(dt)
		love.event.push("quit")
	end
}