--- ADD ME

Tilemap.Character = {}
Utilities.OO.createClass(Tilemap.Character)

---
function Tilemap.Character:new(appropriateScene,x,y)
	self.x = x
	self.y = y

	self.oldX = x
	self.oldY = y

    self.appropriateScene = appropriateScene

	self.goalX = math.floor(Tilemap.Settings.levelSize/2)
	self.goalY = math.floor(Tilemap.Settings.levelSize/2)

	self:AI_calculatePathToGoal()
end

---
function Tilemap.Character:moveUp(dt)
	self.oldY = self.y

	local tileSpeed = Tilemap.tileDict[self:getTileIndex()][4]
	self.y = self.y - Tilemap.Settings.playerMoveSpeed*dt*tileSpeed
	if self.y < 0 then self.y = 0 end

	self:checkObstacleY()
end

---
function Tilemap.Character:moveLeft(dt)
	self.oldX = self.x

	local tileSpeed = Tilemap.tileDict[self:getTileIndex()][4]
	self.x = self.x - Tilemap.Settings.playerMoveSpeed*dt*tileSpeed
	if self.x < 0 then self.x = 0 end

	self:checkObstacleX()
end

---
function Tilemap.Character:moveDown(dt)
	self.oldY = self.y

	local tileSpeed = Tilemap.tileDict[self:getTileIndex()][4]
	self.y = self.y + Tilemap.Settings.playerMoveSpeed*dt*tileSpeed
	if self.y > #self.appropriateScene.tiles[1]*Tilemap.Settings.tileSize-0.1 then self.y = #self.appropriateScene.tiles[1]*Tilemap.Settings.tileSize-0.1 end

	self:checkObstacleY()
end

---
function Tilemap.Character:moveRight(dt)
	self.oldX = self.x

	local tileSpeed = Tilemap.tileDict[self:getTileIndex()][4]
	self.x = self.x + Tilemap.Settings.playerMoveSpeed*dt*tileSpeed
	if self.x > #self.appropriateScene.tiles*Tilemap.Settings.tileSize-0.1 then self.x = #self.appropriateScene.tiles*Tilemap.Settings.tileSize-0.1 end

	self:checkObstacleX()
end

---
function Tilemap.Character:checkObstacleX()
	local newTileIsObstacle = Tilemap.tileDict[self:getTileIndex()][5]
	if newTileIsObstacle then
		self.x = self.oldX
	end
end

---
function Tilemap.Character:checkObstacleY()
	local newTileIsObstacle = Tilemap.tileDict[self:getTileIndex()][5]
	if newTileIsObstacle then
		self.y = self.oldY
	end
end

---
function Tilemap.Character:getTileIndex()
	local tileCoordX, tileCoordY = self.appropriateScene:getTileCoordinatesUnderCharacter(self)
	return self.appropriateScene.tiles[tileCoordX][tileCoordY]
end

---
function Tilemap.Character:getTileCoordinate()
	return self.appropriateScene:getTileCoordinatesUnderCharacter(self)
end

---
function Tilemap.Character:keepCharInMap()
	if self.x < 0 then self.x = 0 end
	if self.y < 0 then self.y = 0 end
	if self.x > #self.appropriateScene.tiles*Tilemap.Settings.tileSize-0.1 then self.x = #self.appropriateScene.tiles*Tilemap.Settings.tileSize-0.1 end
	if self.y > #self.appropriateScene.tiles[1]*Tilemap.Settings.tileSize-0.1 then self.y = #self.appropriateScene.tiles[1]*Tilemap.Settings.tileSize-0.1 end
end

---
function Tilemap.Character:AI_think(dt)
	self:AI_walkToGoal(dt)
end

---
function Tilemap.Character:AI_walkToGoal(dt)
	if #self.pathToGoal > 0 then
		local tileToGo 		= self.pathToGoal[1]
		local currentTile	= {self:getTileCoordinate()}

		if tileToGo[1] == currentTile[1] and tileToGo[2] == currentTile[2] then
			table.remove(self.pathToGoal,1)
			if #self.pathToGoal > 0 then
				tileToGo = self.pathToGoal[1]
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

---
function Tilemap.Character:AI_calculatePathToGoal()
	local tileX,tileY = self.appropriateScene:getTileCoordinatesUnderCharacter(self)
	self.pathToGoal = self.appropriateScene:Route_getRoute(tileX, tileY, self.goalX, self.goalY)
end
