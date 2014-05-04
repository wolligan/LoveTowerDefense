KeyBindings.IngameKeyBinding = {}

KeyBindings.IngameKeyBinding["w"] = {
	mode = "repeat",
	fun = function(dt)
        print("loofn")
		Ingame.getActiveScene().characters[Ingame.getActiveScene().playerIndex]:moveUp(dt)
	end
}

KeyBindings.IngameKeyBinding["a"] = {
	mode = "repeat",
	fun = function(dt)
		Ingame.getActiveScene().characters[Ingame.getActiveScene().playerIndex]:moveLeft(dt)
	end
}


KeyBindings.IngameKeyBinding["s"] = {
	mode = "repeat",
	fun = function(dt)
		Ingame.getActiveScene().characters[Ingame.getActiveScene().playerIndex]:moveDown(dt)
	end
}


KeyBindings.IngameKeyBinding["d"] = {
	mode = "repeat",
	fun = function(dt)
		Ingame.getActiveScene().characters[Ingame.getActiveScene().playerIndex]:moveRight(dt)
	end
}


KeyBindings.IngameKeyBinding["up"] = {
	mode = "single",
	fun = function(dt)
		Ingame.getActiveScene().playerIndex = math.min(#Ingame.getActiveScene().characters, Ingame.getActiveScene().playerIndex + 1)
		--camera.rotation = camera.rotation + 10*dt
	end
}


KeyBindings.IngameKeyBinding["down"] = {
	mode = "single",
	fun = function(dt)
		Ingame.getActiveScene().playerIndex = math.max(1, Ingame.getActiveScene().playerIndex - 1)
		--camera.rotation = camera.rotation - 10*dt
	end
}


KeyBindings.IngameKeyBinding["right"] = {
	mode = "single",
	fun = function(dt)
		Ingame.activeSceneIndex = math.min(Ingame.activeSceneIndex+1, #Ingame.loadedScenes)
	end
}


KeyBindings.IngameKeyBinding["left"] = {
	mode = "single",
	fun = function(dt)
		Ingame.activeSceneIndex = math.max(Ingame.activeSceneIndex-1, 1)
	end
}


KeyBindings.IngameKeyBinding["escape"] = {
	mode = "single",
	fun = function(dt)
		love.event.push("quit")
	end
}
