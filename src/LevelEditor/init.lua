require "Tilemap"

LevelEditor = {}

function LevelEditor.init()
    Tilemap.init()
    LevelEditor.currentTileIndex = 1
    LevelEditor.createGUI()
end

function LevelEditor.render()
    Tilemap.render()
end

function LevelEditor.update(dt)
    Tilemap.update(dt)
end

function LevelEditor.createGUI()
    LevelEditor.GUI = GUI.Container(nil,{255,255,255,200},nil,{200,200,200,200},{255,255,255,200},{50,50,50,255},Utilities.Color.black)


    -- create a textfield
    local tf_mapName = GUI.Textfield("Map Name")
    tf_mapName:setLeftAnchor(GUI.Root, "right")
    tf_mapName:setBottomAnchor(GUI.Root, "top")

    tf_mapName.topAnchorOffset = 10
    tf_mapName.bottomAnchorOffset = 40
    tf_mapName.leftAnchorOffset = -150
    tf_mapName.rightAnchorOffset = -10


    local button_saveMap = GUI.Button("Save Map", function() Tilemap.getActiveScene():saveMap(tf_mapName.text .. ".map") end)
    button_saveMap:setTopAnchor(GUI.Root, "bottom")
    button_saveMap:setRightAnchor(GUI.Root, "center")
    button_saveMap.topAnchorOffset = -50
    button_saveMap.bottomAnchorOffset = -10
    button_saveMap.leftAnchorOffset = 10
    button_saveMap.rightAnchorOffset = -5

    local button_loadMap = GUI.Button("Load Map", function() Tilemap.getActiveScene():loadMap(tf_mapName.text .. ".map") end)
    button_loadMap:setTopAnchor(GUI.Root, "bottom")
    button_loadMap:setLeftAnchor(GUI.Root, "center")
    button_loadMap.topAnchorOffset = -50
    button_loadMap.bottomAnchorOffset = -10
    button_loadMap.leftAnchorOffset = 5
    button_loadMap.rightAnchorOffset = -10

-- create tile button list
    local list_tiles = GUI.List("horizontal", 40, 1)
    list_tiles:setLeftAnchor(tf_mapName, "left")
    list_tiles:setRightAnchor(tf_mapName, "right")
    list_tiles:setBottomAnchor(button_loadMap, "top")
    list_tiles:setTopAnchor(tf_mapName, "bottom")
    list_tiles.topAnchorOffset = 10

    for i,curTile in pairs(Tilemap.tileDict) do
        list_tiles:add(GUI.Button(Tilemap.tileNames[i], function() LevelEditor.currentTileIndex = i end))
    end

    local emptyField = GUI.Widget()
    emptyField:setRightAnchor(list_tiles, "left")
    emptyField:setBottomAnchor(button_loadMap, "top")
    emptyField.onClick = LevelEditor.changeTile


    list_tiles:addWidgetsToContainer(LevelEditor.GUI)
    LevelEditor.GUI:addWidget(emptyField)
    LevelEditor.GUI:addWidget(button_saveMap)
    LevelEditor.GUI:addWidget(button_loadMap)
    LevelEditor.GUI:addWidget(tf_mapName)
end

function LevelEditor.changeTile()
    local x,y = Tilemap.getActiveScene():getTileCoordinatesByCamera(love.mouse.getX(), love.mouse.getY())
    if x > 0 and y > 0 and x <= Tilemap.getActiveScene():getLevelWidth() and y <= Tilemap.getActiveScene():getLevelHeight() then
        Tilemap.getActiveScene().tiles[x][y] = LevelEditor.currentTileIndex
    end
end

LevelEditor.activeKeyBinding = {}
LevelEditor.activeKeyBinding["escape"] = {
    pressed = function()
        Game.changeState(Testing.Menu)
    end
}

LevelEditor.activeKeyBinding["w"] = {
	repeated = function(dt)
		Tilemap.getActiveScene().characters[Tilemap.getActiveScene().playerIndex]:moveUp(dt)
	end
}

LevelEditor.activeKeyBinding["a"] = {
	repeated = function(dt)
		Tilemap.getActiveScene().characters[Tilemap.getActiveScene().playerIndex]:moveLeft(dt)
	end
}


LevelEditor.activeKeyBinding["s"] = {
	repeated = function(dt)
		Tilemap.getActiveScene().characters[Tilemap.getActiveScene().playerIndex]:moveDown(dt)
	end
}


LevelEditor.activeKeyBinding["d"] = {
	repeated = function(dt)
		Tilemap.getActiveScene().characters[Tilemap.getActiveScene().playerIndex]:moveRight(dt)
	end
}

LevelEditor.activeKeyBinding["up"] = {
	repeated = function(dt)
        Tilemap.Camera.target = nil
		Tilemap.Camera.y = Tilemap.Camera.y - 200*dt
	end
}

LevelEditor.activeKeyBinding["left"] = {
	repeated = function(dt)
        Tilemap.Camera.target = nil
		Tilemap.Camera.x = Tilemap.Camera.x - 200*dt
	end
}


LevelEditor.activeKeyBinding["down"] = {
	repeated = function(dt)
        Tilemap.Camera.target = nil
		Tilemap.Camera.y = Tilemap.Camera.y + 200*dt
	end
}


LevelEditor.activeKeyBinding["right"] = {
	repeated = function(dt)
        Tilemap.Camera.target = nil
		Tilemap.Camera.x = Tilemap.Camera.x + 200*dt
	end
}


LevelEditor.activeKeyBinding[" "] = {
	repeated = function(dt)
		Tilemap.Camera.target = Tilemap.getActiveScene().characters[1]
	end
}
