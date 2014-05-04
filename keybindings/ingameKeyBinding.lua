KeyBindings.ingameKeyBinding = {}

KeyBindings.ingameKeyBinding["w"] = {
	mode = "repeat",
	fun = function(dt)
        print("loofn")
		Ingame.getActiveScene().characters[Ingame.getActiveScene().playerIndex]:moveUp(dt)
	end
}

KeyBindings.ingameKeyBinding["a"] = {
	mode = "repeat",
	fun = function(dt)
		Ingame.getActiveScene().characters[Ingame.getActiveScene().playerIndex]:moveLeft(dt)
	end
}


KeyBindings.ingameKeyBinding["s"] = {
	mode = "repeat",
	fun = function(dt)
		Ingame.getActiveScene().characters[Ingame.getActiveScene().playerIndex]:moveDown(dt)
	end
}


KeyBindings.ingameKeyBinding["d"] = {
	mode = "repeat",
	fun = function(dt)
		Ingame.getActiveScene().characters[Ingame.getActiveScene().playerIndex]:moveRight(dt)
	end
}


KeyBindings.ingameKeyBinding["up"] = {
	mode = "single",
	fun = function(dt)
		Ingame.getActiveScene().playerIndex = math.min(#Ingame.getActiveScene().characters, Ingame.getActiveScene().playerIndex + 1)
		--camera.rotation = camera.rotation + 10*dt
	end
}


KeyBindings.ingameKeyBinding["down"] = {
	mode = "single",
	fun = function(dt)
		Ingame.getActiveScene().playerIndex = math.max(1, Ingame.getActiveScene().playerIndex - 1)
		--camera.rotation = camera.rotation - 10*dt
	end
}


KeyBindings.ingameKeyBinding["right"] = {
	mode = "single",
	fun = function(dt)
		Ingame.activeSceneIndex = math.min(Ingame.activeSceneIndex+1, #Ingame.loadedScenes)
	end
}


KeyBindings.ingameKeyBinding["left"] = {
	mode = "single",
	fun = function(dt)
		Ingame.activeSceneIndex = math.max(Ingame.activeSceneIndex-1, 1)
	end
}


KeyBindings.ingameKeyBinding["escape"] = {
	mode = "single",
	fun = function(dt)
		love.event.push("quit")
	end
}
