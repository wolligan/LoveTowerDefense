--- Basic Character that can interact on the tilemap and can also be an AI.
--@author Steve Wolligandt
--@classmod Character

Tilemap.Character = {}
Utilities.OO.createClass(Tilemap.Character)

--- Constructor
--@param apparentScene Scene of the character
--@param x x-coordinate of the character
--@param y y-coordinate of the character
function Tilemap.Character:new(apparentScene,x,y)
	self.x = x
	self.y = y

    self.mesh = Lighting.ShadowCaster.createDiscoCircle(x,y, Tilemap.Settings.playerSize/2, 10, {0,127,0})
    self.mesh.reflectorSides = {}

	self.oldX = x
	self.oldY = y

    self.apparentScene = apparentScene

    self.pathToGoal = {}
end

--- Renders the Character (This should be overwritten in your derived class)
function Tilemap.Character:render()
    self.mesh:render()
end

--- Renders the Character (This should be overwritten in your derived class)
function Tilemap.Character:update(dt)
    self.mesh.position[1] = self.x
    self.mesh.position[2] = self.y
    self:AI_think(dt)
end

--- Character Movement
--@section movement

--- Moves the Character up, also regards the speed under the tile the character is located at
--@param dt delta time
function Tilemap.Character:moveUp(dt)
	self.oldY = self.y

	local tileSpeed = Tilemap.tileDict[self:getTileIndex()].speed
	self.y = self.y - Tilemap.Settings.playerMoveSpeed*dt*tileSpeed
	if self.y < 0 then self.y = 0 end

	self:checkObstacleY()
end

--- Moves the Character left, also regards the speed under the tile the character is located at
--@param dt delta time
function Tilemap.Character:moveLeft(dt)
	self.oldX = self.x

	local tileSpeed = Tilemap.tileDict[self:getTileIndex()].speed
	self.x = self.x - Tilemap.Settings.playerMoveSpeed*dt*tileSpeed
	if self.x < 0 then self.x = 0 end

	self:checkObstacleX()
end

--- Moves the Character down, also regards the speed under the tile the character is located at
--@param dt delta time
function Tilemap.Character:moveDown(dt)
	self.oldY = self.y

	local tileSpeed = Tilemap.tileDict[self:getTileIndex()].speed
	self.y = self.y + Tilemap.Settings.playerMoveSpeed*dt*tileSpeed
	if self.y > #self.apparentScene.tiles[1]*Tilemap.Settings.tileSize-0.1 then self.y = #self.apparentScene.tiles[1]*Tilemap.Settings.tileSize-0.1 end

	self:checkObstacleY()
end

--- Moves the Character right, also regards the speed under the tile the character is located at
--@param dt delta time
function Tilemap.Character:moveRight(dt)
	self.oldX = self.x

	local tileSpeed = Tilemap.tileDict[self:getTileIndex()].speed
	self.x = self.x + Tilemap.Settings.playerMoveSpeed*dt*tileSpeed
	if self.x > #self.apparentScene.tiles*Tilemap.Settings.tileSize-0.1 then self.x = #self.apparentScene.tiles*Tilemap.Settings.tileSize-0.1 end

	self:checkObstacleX()
end

--- Collision Detection
--@section collision

--- checks if the Character is caught in an obstacle in x-coordinate and resets to the old x-coordinate if thats the case
function Tilemap.Character:checkObstacleX()
	local newTileIsObstacle = Tilemap.tileDict[self:getTileIndex()].isObstacle
	if newTileIsObstacle then
		self.x = self.oldX
	end
end

--- checks if the Character is caught in an obstacle in y-coordinate and resets to the old x-coordinate if thats the case
function Tilemap.Character:checkObstacleY()
	local newTileIsObstacle = Tilemap.tileDict[self:getTileIndex()].isObstacle
	if newTileIsObstacle then
		self.y = self.oldY
	end
end

--- returns the tile index the character is standing on
function Tilemap.Character:getTileIndex()
	local tileCoordX, tileCoordY = self.apparentScene:getTileCoordinatesUnderCharacter(self)
	return self.apparentScene.tiles[tileCoordX][tileCoordY]
end

--- returns the tile coordinates the character is standing on
function Tilemap.Character:getTileCoordinate()
	return self.apparentScene:getTileCoordinatesUnderCharacter(self)
end

--- assert that the character stays in range of the map
function Tilemap.Character:keepCharInMap()
	if self.x < 0 then self.x = 0 end
	if self.y < 0 then self.y = 0 end
	if self.x > #self.apparentScene.tiles*Tilemap.Settings.tileSize-0.1 then self.x = #self.apparentScene.tiles*Tilemap.Settings.tileSize-0.1 end
	if self.y > #self.apparentScene.tiles[1]*Tilemap.Settings.tileSize-0.1 then self.y = #self.apparentScene.tiles[1]*Tilemap.Settings.tileSize-0.1 end
end

--- AI functions
--@section ai

--- Think function gets repeatedly called from update. Overwrite this method in your derived class
function Tilemap.Character:AI_think(dt)
	self:AI_walkToGoal(dt)
end

--- Call this in your think method to let the character move to its goal if defined
function Tilemap.Character:AI_walkToGoal(dt)
	if #self.pathToGoal > 0 then
		local tileToGo 		= self.pathToGoal[1]
		local currentTile	= {self:getTileCoordinate()}

		if tileToGo[1] == currentTile[1] and tileToGo[2] == currentTile[2] then
			table.remove(self.pathToGoal,1)
			if #self.pathToGoal > 0 then
				tileToGo = self.pathToGoal[1]
                if Tilemap.tileDict[self.apparentScene.tiles[tileToGo[1]][tileToGo[2]]].isObstacle then
                    print("error")
                    self:AI_calculatePathToGoal()
                    if #self.pathToGoal > 0 then
                        tileToGo = self.pathToGoal[1]
                    else
                        return nil
                    end
                end
			else
				return nil
			end
		end

		local tilePosToGo 	= {	(tileToGo[1]-1)*Tilemap.Settings.tileSize + Tilemap.Settings.tileSize*0.5,
								(tileToGo[2]-1)*Tilemap.Settings.tileSize + Tilemap.Settings.tileSize*0.5}

		local lengthX = tilePosToGo[1] - self.x
		local lengthY = tilePosToGo[2] - self.y

		if math.abs(lengthX) > 2 then
			if lengthX < 0 then
				self:moveLeft(dt)
			else
				self:moveRight(dt)
			end
		end
		if math.abs(lengthY) > 2 then
			if lengthY < 0 then
				self:moveUp(dt)
			else
				self:moveDown(dt)
			end
		end
	end
end

--- calculate a path to a goal
function Tilemap.Character:AI_calculatePathToGoal(goalX, goalY)
    local tileX,tileY = self.apparentScene:getTileCoordinatesUnderCharacter(self)
    self.pathToGoal = self.apparentScene:Route_getRoute(tileX, tileY, goalX, goalY)
end
