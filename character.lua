require "OO"

Character = {}
OO.createClass(Character)
Character.AI = {}

function Character:new(x,y)
	self.x = x
	self.y = y
	
	self.oldX = x
	self.oldY = y
	
	self.goalX = math.floor(levelSize/2)
	self.goalY = math.floor(levelSize/2)
	
	self:AI_calculatePathToGoal()
end

-- Movement
function Character:moveUp(dt)
	self.oldY = self.y
	
	local tileSpeed = tileDict[self:getTileIndex()][4]
	self.y = self.y - playerMoveSpeed*dt*tileSpeed
	if self.y < 0 then self.y = 0 end
	
	self:checkObstacleY()
end

function Character:moveLeft(dt)
	self.oldX = self.x
	
	local tileSpeed = tileDict[self:getTileIndex()][4]
	self.x = self.x - playerMoveSpeed*dt*tileSpeed
	if self.x < 0 then self.x = 0 end
	
	self:checkObstacleX()
end

function Character:moveDown(dt)
	self.oldY = self.y
	
	local tileSpeed = tileDict[self:getTileIndex()][4]
	self.y = self.y + playerMoveSpeed*dt*tileSpeed
	if self.y > #Scene.tiles[1]*tileSize-0.1 then self.y = #Scene.tiles[1]*tileSize-0.1 end
	
	self:checkObstacleY()
end

function Character:moveRight(dt)
	self.oldX = self.x
	
	local tileSpeed = tileDict[self:getTileIndex()][4]
	self.x = self.x + playerMoveSpeed*dt*tileSpeed
	if self.x > #Scene.tiles*tileSize-0.1 then self.x = #Scene.tiles*tileSize-0.1 end
	
	self:checkObstacleX()
end

function Character:checkObstacleX()
	local newTileIsObstacle = tileDict[self:getTileIndex()][5]
	if newTileIsObstacle then
		self.x = self.oldX
	end
end

function Character:checkObstacleY()
	local newTileIsObstacle = tileDict[self:getTileIndex()][5]
	if newTileIsObstacle then
		self.y = self.oldY
	end
end

function Character:getTileIndex()
	local tileCoordX, tileCoordY = Scene.getTileCoordinatesUnderCharacter(self)
	return Scene.tiles[tileCoordX][tileCoordY]
end

function Character:getTileCoordinate()
	return Scene.getTileCoordinatesUnderCharacter(self)
end

function Character:keepCharInMap()
	if self.x < 0 then self.x = 0 end
	if self.y < 0 then self.y = 0 end
	if self.x > #Scene.tiles*tileSize-0.1 then self.x = #Scene.tiles*tileSize-0.1 end
	if self.y > #Scene.tiles[1]*tileSize-0.1 then self.y = #Scene.tiles[1]*tileSize-0.1 end
end

--Character.AI = {}
function Character:AI_think(dt)
	self:AI_walkToGoal(dt)
end

function Character:AI_walkToGoal(dt)
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
		
		local tilePosToGo 	= {	(tileToGo[1]-1)*tileSize + tileSize*0.5,
								(tileToGo[2]-1)*tileSize + tileSize*0.5}
			
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

function Character:AI_calculatePathToGoal()
	local tileX,tileY = Scene.getTileCoordinatesUnderCharacter(self)
	self.pathToGoal = Scene.Route.getRoute(tileX, tileY, self.goalX, self.goalY)
end