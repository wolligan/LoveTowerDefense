--- Lets you graphically save, load and create tilemaps
--@author Steve Wolligandt

require "Tilemap"

LevelEditor = {}

--- Game State functions
--@section gamestatfuncs

--- Call this function to initialize the LevelEditor
function LevelEditor.init()
    Ingame.init()
    Tilemap.init()
    Tilemap.addScene(20, 20)
    Tilemap.pause()
    LevelEditor.currentTileIndex = 1
    LevelEditor.createGUI()
end

--- Renders the LevelEditor
function LevelEditor.render()
    Tilemap.render()
end

--- Updates the LevelEditor
--@param dt delta time
function LevelEditor.update(dt)
    Tilemap.update(dt)
end

--- Functions
--@section general

--- Creates the GUI for Level Editor
function LevelEditor.createGUI()
    LevelEditor.GUI = GUI.Container(nil,{255,255,255,200},nil,{200,200,200,200},{255,255,255,200},{50,50,50,255},Utilities.Color.black)

    -- create play, pause and clear button
    local button_pause = GUI.Button("pause", function() Tilemap.pause() end)
    local button_play  = GUI.Button("play", function() Tilemap.resume() end)
    local button_clear = GUI.Button("clear", function()
        Tilemap.getActiveScene().characters = {}
    end)

    button_pause:attachLabelImage(Game.getSprite("LevelEditor/icons/pause.png"))
    button_play:attachLabelImage(Game.getSprite("LevelEditor/icons/play.png"))
    button_clear:attachLabelImage(Game.getSprite("LevelEditor/icons/clear.png"))

    button_pause:setBottomAnchor(GUI.Root, "top")
    button_play:setBottomAnchor(GUI.Root, "top")
    button_clear:setBottomAnchor(GUI.Root, "top")

    button_clear:setLeftAnchor(GUI.Root, "right")

    button_pause:setRightAnchor(button_clear, "left")
    button_pause:setLeftAnchor(button_clear, "left")

    button_play:setRightAnchor(button_pause, "left")
    button_play:setLeftAnchor(button_pause, "left")

    button_pause.topAnchorOffset = 10
    button_play.topAnchorOffset = 10
    button_clear.topAnchorOffset = 10

    button_pause.bottomAnchorOffset = 60
    button_play.bottomAnchorOffset = 60
    button_clear.bottomAnchorOffset = 60

    button_play.rightAnchorOffset = -10
    button_play.leftAnchorOffset = -60

    button_pause.rightAnchorOffset = -10
    button_pause.leftAnchorOffset = -60

    button_clear.rightAnchorOffset = -10
    button_clear.leftAnchorOffset = -60

    -- create a TextEntry
    local te_mapName = GUI.TextEntry("Map Name")
    te_mapName:setLeftAnchor(button_play, "left")
    te_mapName:setTopAnchor(button_play, "bottom")
    te_mapName:setBottomAnchor(button_play, "bottom")

    te_mapName.topAnchorOffset = 10
    te_mapName.bottomAnchorOffset = 40
    te_mapName.rightAnchorOffset = -10

    local button_saveMap = GUI.Button("Save Map", function() Tilemap.getActiveScene():saveMap(te_mapName.text .. ".map") end)
    button_saveMap:setTopAnchor(GUI.Root, "bottom")
    button_saveMap:setRightAnchor(GUI.Root, "center")
    button_saveMap.topAnchorOffset = -50
    button_saveMap.bottomAnchorOffset = -10
    button_saveMap.leftAnchorOffset = 10
    button_saveMap.rightAnchorOffset = -5

    local button_loadMap = GUI.Button("Load Map", function()
            print("loading " .. te_mapName.text .. ".map")
            Tilemap.loadMap(te_mapName.text .. ".map")
            button_clear.onRelease()
        end)
    button_loadMap:setTopAnchor(GUI.Root, "bottom")
    button_loadMap:setLeftAnchor(GUI.Root, "center")
    button_loadMap.topAnchorOffset = -50
    button_loadMap.bottomAnchorOffset = -10
    button_loadMap.leftAnchorOffset = 5
    button_loadMap.rightAnchorOffset = -10

    local widget_selectedTile = GUI.Widget()
    widget_selectedTile:setTopAnchor(button_loadMap, "top")
    widget_selectedTile:setBottomAnchor(button_loadMap, "top")
    widget_selectedTile:setRightAnchor(te_mapName, "right")
    widget_selectedTile:setLeftAnchor(te_mapName, "left")
    widget_selectedTile.topAnchorOffset = -70
    widget_selectedTile.bottomAnchorOffset = -10
    widget_selectedTile.render = LevelEditor.renderSelectedTileWidget

-- create tile button list
    local list_tiles = GUI.List("horizontal", 30, 1)
    list_tiles:setLeftAnchor(te_mapName, "left")
    list_tiles:setRightAnchor(te_mapName, "right")
    list_tiles:setBottomAnchor(widget_selectedTile, "top")
    list_tiles:setTopAnchor(te_mapName, "bottom")
    list_tiles.topAnchorOffset = 10

    for i,curTile in pairs(Tilemap.tileDict) do
        list_tiles:add(GUI.Button(Tilemap.tileDict[i].name, function() LevelEditor.currentTileIndex = i end))
    end

    local emptyField = GUI.Widget()
    emptyField:setRightAnchor(list_tiles, "left")
    emptyField:setBottomAnchor(button_loadMap, "top")
    emptyField.onClick = LevelEditor.changeTile


    list_tiles:addWidgetsToContainer(LevelEditor.GUI)
    LevelEditor.GUI:addWidget(emptyField)
    LevelEditor.GUI:addWidget(widget_selectedTile)
    LevelEditor.GUI:addWidget(button_saveMap)
    LevelEditor.GUI:addWidget(button_loadMap)
    LevelEditor.GUI:addWidget(te_mapName)
    LevelEditor.GUI:addWidget(button_pause)
    LevelEditor.GUI:addWidget(button_play)
    LevelEditor.GUI:addWidget(button_clear)
end

--- Change the tile under the current position of the cursor
function LevelEditor.changeTile()
    local x,y = Tilemap.getActiveScene():getTileCoordinatesByCamera(love.mouse.getX(), love.mouse.getY())
    if x > 0 and y > 0 and x <= Tilemap.getActiveScene():getLevelWidth() and y <= Tilemap.getActiveScene():getLevelHeight() then
        Tilemap.getActiveScene().tiles[x][y] = LevelEditor.currentTileIndex
    end
end

--- Keybindings
--@section keys

--- Keybindings for the level editor
--@field escape Return to Menu.
--@field w,a,s,d Walk with first character in scene.
--@field space Center camera to first character in scene.
--@field up,down,left,right Move the camera in scene.

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
        Tilemap.getActiveScene().camera.target = nil
		Tilemap.getActiveScene().camera.y = Tilemap.getActiveScene().camera.y - 200*dt
	end
}

LevelEditor.activeKeyBinding["left"] = {
	repeated = function(dt)
        Tilemap.getActiveScene().camera.target = nil
		Tilemap.getActiveScene().camera.x = Tilemap.getActiveScene().camera.x - 200*dt
	end
}


LevelEditor.activeKeyBinding["down"] = {
	repeated = function(dt)
        Tilemap.getActiveScene().camera.target = nil
		Tilemap.getActiveScene().camera.y = Tilemap.getActiveScene().camera.y + 200*dt
	end
}


LevelEditor.activeKeyBinding["right"] = {
	repeated = function(dt)
        Tilemap.getActiveScene().camera.target = nil
		Tilemap.getActiveScene().camera.x = Tilemap.getActiveScene().camera.x + 200*dt
	end
}


LevelEditor.activeKeyBinding[" "] = {
	repeated = function(dt)
		Tilemap.getActiveScene().camera.target = Tilemap.getActiveScene().characters[1]
	end
}

--- Custom Widget render functions
--@section widgets

--- Custom render function for widget that draws the currently selected tile
--@param self blub
function LevelEditor.renderSelectedTileWidget(self)
    self:renderBackground()
    love.graphics.setColor(unpack(self.apparentContainer.fontColor))
    love.graphics.print(Tilemap.tileDict[LevelEditor.currentTileIndex].name, self:getLeftAnchor() + 10, self:getTopAnchor()+self:getHeight()/2 - self.apparentContainer.font:getHeight(Tilemap.tileDict[LevelEditor.currentTileIndex].name)/2)

    -- draw background circle
    love.graphics.setColor(0,0,0)
    love.graphics.circle("fill", self:getRightAnchor()-5-Tilemap.Settings.tileSize, self:getTopAnchor() + self:getHeight()/2, Tilemap.Settings.tileSize/2+2)


    love.graphics.setStencil(function() love.graphics.circle("fill", self:getRightAnchor()-5-Tilemap.Settings.tileSize, self:getTopAnchor() + self:getHeight()/2, Tilemap.Settings.tileSize/2) end)
    love.graphics.push()
    love.graphics.setColor(unpack(Tilemap.tileDict[LevelEditor.currentTileIndex].color))
    love.graphics.translate(self:getRightAnchor()-5-Tilemap.Settings.tileSize -Tilemap.Settings.tileSize/2, self:getTopAnchor() + self:getHeight()/2-Tilemap.Settings.tileSize/2)
    Tilemap.tileDict[LevelEditor.currentTileIndex].draw(unpack(Tilemap.tileDict[LevelEditor.currentTileIndex].drawParams))
    love.graphics.pop()
    love.graphics.setStencil()
end
