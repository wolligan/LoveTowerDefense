--- ADD ME
KeyBindings.TilemapTestKeyBinding = {}

---
KeyBindings.TilemapTestKeyBinding["w"] = {
	mode = "repeat",
	fun = function(dt)
        print("loofn")
		Tilemap.getActiveScene().characters[Tilemap.getActiveScene().playerIndex]:moveUp(dt)
	end
}

KeyBindings.TilemapTestKeyBinding["a"] = {
	mode = "repeat",
	fun = function(dt)
		Tilemap.getActiveScene().characters[Tilemap.getActiveScene().playerIndex]:moveLeft(dt)
	end
}


KeyBindings.TilemapTestKeyBinding["s"] = {
	mode = "repeat",
	fun = function(dt)
		Tilemap.getActiveScene().characters[Tilemap.getActiveScene().playerIndex]:moveDown(dt)
	end
}


KeyBindings.TilemapTestKeyBinding["d"] = {
	mode = "repeat",
	fun = function(dt)
		Tilemap.getActiveScene().characters[Tilemap.getActiveScene().playerIndex]:moveRight(dt)
	end
}


KeyBindings.TilemapTestKeyBinding["up"] = {
	mode = "single",
	fun = function(dt)
		Tilemap.getActiveScene().playerIndex = math.min(#Tilemap.getActiveScene().characters, Tilemap.getActiveScene().playerIndex + 1)
		--camera.rotation = camera.rotation + 10*dt
	end
}


KeyBindings.TilemapTestKeyBinding["down"] = {
	mode = "single",
	fun = function(dt)
		Tilemap.getActiveScene().playerIndex = math.max(1, Tilemap.getActiveScene().playerIndex - 1)
		--camera.rotation = camera.rotation - 10*dt
	end
}


KeyBindings.TilemapTestKeyBinding["right"] = {
	mode = "single",
	fun = function(dt)
		Tilemap.activeSceneIndex = math.min(Tilemap.activeSceneIndex+1, #Tilemap.loadedScenes)
	end
}


KeyBindings.TilemapTestKeyBinding["left"] = {
	mode = "single",
	fun = function(dt)
		Tilemap.activeSceneIndex = math.max(Tilemap.activeSceneIndex-1, 1)
	end
}


KeyBindings.TilemapTestKeyBinding["escape"] = {
	mode = "single",
	fun = function(dt)
		Game.changeState(Testing.Menu)
	end
}
