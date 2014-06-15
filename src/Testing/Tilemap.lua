--- Testing of Tilemap
--@author Steve Wolligandt

Testing.Tilemap = {}

--- Game State functions
--@section gamestate

function Testing.Tilemap.init()
    Tilemap.init()
    Tilemap.activeSceneIndex = 1
    for i=1,3 do
        Tilemap.loadedScenes[#Tilemap.loadedScenes + 1] = Tilemap.Scene()
        Tilemap.loadedScenes[i]:createRandomLevel()
    end
end

function Testing.Tilemap.render()
    Tilemap.render()
end

function Testing.Tilemap.update(dt)
    Tilemap.update(dt)
end

--- Testing
--@section keys

--- Tilemap Testing Keybindings
--@field escape return to testing menu
--@field w,a,s,d move current character
--@field up,down change player index of active scene
--@field left,right change active scene
Testing.Tilemap.activeKeyBinding = {}

Testing.Tilemap.activeKeyBinding["w"] = {
	repeated = function(dt)
		Tilemap.getActiveScene().characters[Tilemap.getActiveScene().playerIndex]:moveUp(dt)
	end
}

Testing.Tilemap.activeKeyBinding["a"] = {
	repeated = function(dt)
		Tilemap.getActiveScene().characters[Tilemap.getActiveScene().playerIndex]:moveLeft(dt)
	end
}


Testing.Tilemap.activeKeyBinding["s"] = {
	repeated = function(dt)
		Tilemap.getActiveScene().characters[Tilemap.getActiveScene().playerIndex]:moveDown(dt)
	end
}


Testing.Tilemap.activeKeyBinding["d"] = {
	repeated = function(dt)
		Tilemap.getActiveScene().characters[Tilemap.getActiveScene().playerIndex]:moveRight(dt)
	end
}


Testing.Tilemap.activeKeyBinding["up"] = {
	pressed = function(dt)
		Tilemap.getActiveScene().playerIndex = math.min(#Tilemap.getActiveScene().characters, Tilemap.getActiveScene().playerIndex + 1)
	end
}


Testing.Tilemap.activeKeyBinding["down"] = {
	pressed = function(dt)
		Tilemap.getActiveScene().playerIndex = math.max(1, Tilemap.getActiveScene().playerIndex - 1)
	end
}


Testing.Tilemap.activeKeyBinding["right"] = {
	pressed = function(dt)
		Tilemap.activeSceneIndex = math.min(Tilemap.activeSceneIndex+1, #Tilemap.loadedScenes)
	end
}


Testing.Tilemap.activeKeyBinding["left"] = {
	pressed = function(dt)
		Tilemap.activeSceneIndex = math.max(Tilemap.activeSceneIndex-1, 1)
	end
}


Testing.Tilemap.activeKeyBinding["escape"] = {
	pressed = function(dt)
		Game.changeState(Testing.Menu)
	end
}
