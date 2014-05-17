--- ADD ME
KeyBindings.TilemapTestKeyBinding = {}

---
KeyBindings.TilemapTestKeyBinding["w"] = {
	repeated = function(dt)
		Tilemap.getActiveScene().characters[Tilemap.getActiveScene().playerIndex]:moveUp(dt)
	end
}

KeyBindings.TilemapTestKeyBinding["a"] = {
	repeated = function(dt)
		Tilemap.getActiveScene().characters[Tilemap.getActiveScene().playerIndex]:moveLeft(dt)
	end
}


KeyBindings.TilemapTestKeyBinding["s"] = {
	repeated = function(dt)
		Tilemap.getActiveScene().characters[Tilemap.getActiveScene().playerIndex]:moveDown(dt)
	end
}


KeyBindings.TilemapTestKeyBinding["d"] = {
	repeated = function(dt)
		Tilemap.getActiveScene().characters[Tilemap.getActiveScene().playerIndex]:moveRight(dt)
	end
}


KeyBindings.TilemapTestKeyBinding["up"] = {
	pressed = function(dt)
		Tilemap.getActiveScene().playerIndex = math.min(#Tilemap.getActiveScene().characters, Tilemap.getActiveScene().playerIndex + 1)
		--camera.rotation = camera.rotation + 10*dt
	end
}


KeyBindings.TilemapTestKeyBinding["down"] = {
	pressed = function(dt)
		Tilemap.getActiveScene().playerIndex = math.max(1, Tilemap.getActiveScene().playerIndex - 1)
		--camera.rotation = camera.rotation - 10*dt
	end
}


KeyBindings.TilemapTestKeyBinding["right"] = {
	pressed = function(dt)
		Tilemap.activeSceneIndex = math.min(Tilemap.activeSceneIndex+1, #Tilemap.loadedScenes)
	end
}


KeyBindings.TilemapTestKeyBinding["left"] = {
	pressed = function(dt)
		Tilemap.activeSceneIndex = math.max(Tilemap.activeSceneIndex-1, 1)
	end
}


KeyBindings.TilemapTestKeyBinding["escape"] = {
	pressed = function(dt)
		Game.changeState(Testing.Menu)
	end
}
