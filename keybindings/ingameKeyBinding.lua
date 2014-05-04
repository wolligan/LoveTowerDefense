KeyBindings.ingameKeyBinding = {}

KeyBindings.ingameKeyBinding["w"] = {
	mode = "repeat",
	fun = function(dt)
        print("loofn")
		Ingame.Scene.characters[Ingame.Scene.playerIndex]:moveUp(dt)
	end
}

KeyBindings.ingameKeyBinding["a"] = {
	mode = "repeat",
	fun = function(dt)
		Ingame.Scene.characters[Ingame.Scene.playerIndex]:moveLeft(dt)
	end
}


KeyBindings.ingameKeyBinding["s"] = {
	mode = "repeat",
	fun = function(dt)
		Ingame.Scene.characters[Ingame.Scene.playerIndex]:moveDown(dt)
	end
}


KeyBindings.ingameKeyBinding["d"] = {
	mode = "repeat",
	fun = function(dt)
		Ingame.Scene.characters[Ingame.Scene.playerIndex]:moveRight(dt)
	end
}


KeyBindings.ingameKeyBinding["up"] = {
	mode = "single",
	fun = function(dt)
		Ingame.Scene.playerIndex = math.min(#Ingame.Scene.characters, Ingame.Scene.playerIndex + 1)
		--camera.rotation = camera.rotation + 10*dt
	end
}


KeyBindings.ingameKeyBinding["down"] = {
	mode = "single",
	fun = function(dt)
		Ingame.Scene.playerIndex = math.max(1, Ingame.Scene.playerIndex - 1)
		--camera.rotation = camera.rotation - 10*dt
	end
}


KeyBindings.ingameKeyBinding["escape"] = {
	mode = "single",
	fun = function(dt)
		love.event.push("quit")
	end
}
