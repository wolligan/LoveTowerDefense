--- Blub
--@classmod Scene
--@author Steve Wolligandt

Tilemap.Scene = {}

require "Tilemap.Character"
require "Tilemap.Camera"

Utilities.OO.createClass(Tilemap.Scene)

--- Constructor creates an empty Scene with size of the described in [Tilemap.Settings](../modules/Settings.html)
function Tilemap.Scene:new()
    self.tiles = {}

    self.characters = {}
    self.playerIndex = 0

    self.maxTilesOnScreen = {}
    self.maxTilesOnScreen[1] = math.floor(love.graphics.getWidth()  / Tilemap.Settings.tileSize)+2
    self.maxTilesOnScreen[2] = math.floor(love.graphics.getHeight() / Tilemap.Settings.tileSize)+2

    self:createEmptyLevel(Tilemap.Settings.levelSize, Tilemap.Settings.levelSize)
    self.camera = Tilemap.Camera(self)
end

--- updates the tilemap engine
--@param dt delta time
function Tilemap.Scene:update(dt)
    --self.camera:update(dt)
    for i,curChar in pairs(self.characters) do
        --if i ~= Tilemap.getActiveScene().playerIndex then
            curChar:update(dt)
        --end
    end
end

--- Scene creation
--@section scenecreation

--- Creates a random level with the size specified in the Tilemap Settings. All Tiles have the same weight in random factor.
function Tilemap.Scene:createRandomLevel()
	self.playerIndex = 1

	for x = 1,Tilemap.Settings.levelSize do
		for y = 1,Tilemap.Settings.levelSize do
			self.tiles[x][y] = math.random(1,4)
		end
	end

	self.tiles[math.floor(Tilemap.Settings.levelSize/2)][math.floor(Tilemap.Settings.levelSize/2)] = 1

	self.characters = {}
	for i = 1,20 do
		self.characters[#self.characters+1] = Tilemap.Character(self,
                                                               math.random(0,Tilemap.Settings.levelSize-1)*Tilemap.Settings.tileSize + Tilemap.Settings.tileSize*0.5,
                                                               math.random(0,Tilemap.Settings.levelSize-1)*Tilemap.Settings.tileSize + Tilemap.Settings.tileSize*0.5)

		while Tilemap.tileDict[self.characters[#self.characters]:getTileIndex()].isObstacle do
			self.characters[#self.characters].x = math.random(0,Tilemap.Settings.levelSize-1)*Tilemap.Settings.tileSize + Tilemap.Settings.tileSize*0.5
			self.characters[#self.characters].y = math.random(0,Tilemap.Settings.levelSize-1)*Tilemap.Settings.tileSize + Tilemap.Settings.tileSize*0.5
		end

        local goalX, goalY = math.random(1,Tilemap.Settings.levelSize), math.random(1,Tilemap.Settings.levelSize)

        while Tilemap.tileDict[self.tiles[goalX][goalY]].isObstacle do
			goalX, goalY = math.random(1,Tilemap.Settings.levelSize), math.random(1,Tilemap.Settings.levelSize)
		end

        self.characters[#self.characters]:AI_calculatePathToGoal(goalX, goalY)

	end
    self.camera.target = self.characters[1]
end

--- creates an level filled with Tile Index 1
--@param levelWidth width of level
--@param levelHeight height of level
function Tilemap.Scene:createEmptyLevel(levelWidth, levelHeight)
	self.playerIndex = 1
    self.tiles = {}

	for x = 1,levelWidth do
		self.tiles[x] = {}
		for y = 1,levelWidth do
			self.tiles[x][y] = 1
		end
	end

	self.characters = {}
    --self.characters[#self.characters+1] = Tilemap.Character(self, Tilemap.Settings.tileSize/2, Tilemap.Settings.tileSize/2)
    --self.camera.target = self.characters[1]
end

--- Render Methods
--@section render

--- renders all tiles that are on screen, not the ones that are outside of the screen
function Tilemap.Scene:renderTiles()
    self.camera:begin()
	-- draw level
	--for y = 1,Tilemap.Settings.levelSize do
	--	for x = 1,Tilemap.Settings.levelSize do
    local beginAtX = math.floor(self.camera.x/Tilemap.Settings.tileSize) - math.floor((love.graphics.getWidth()/2)/Tilemap.Settings.tileSize)
    local beginAtY = math.floor(self.camera.y/Tilemap.Settings.tileSize) - math.floor((love.graphics.getHeight()/2)/Tilemap.Settings.tileSize)
	for y = math.max(1,beginAtY), math.min(self:getLevelHeight(), beginAtY+self.maxTilesOnScreen[2])  do
		for x = math.max(1,beginAtX),math.min(self:getLevelWidth(), beginAtX+self.maxTilesOnScreen[1]) do
			if Tilemap.tileDict[self.tiles[x][y]] then
				love.graphics.push()
				love.graphics.translate((x-1)*Tilemap.Settings.tileSize, (y-1)*Tilemap.Settings.tileSize)
				if (Tilemap.tileDict[self.tiles[x][y]].color) then
					love.graphics.setColor(unpack(Tilemap.tileDict[self.tiles[x][y]].color))
				end

				if (Tilemap.tileDict[self.tiles[x][y]].draw and Tilemap.tileDict[self.tiles[x][y]].drawParams) then
					Tilemap.tileDict[self.tiles[x][y]].draw(unpack(Tilemap.tileDict[self.tiles[x][y]].drawParams))
				end

				love.graphics.pop()
			end
		end
	end

    self.camera:stop()
end

--- renders all obstacle tiles (the engine calls this after drawing shadows
function Tilemap.Scene:renderObstacleTiles()
    self.camera:begin()
	-- draw level
	--for y = 1,Tilemap.Settings.levelSize do
	--	for x = 1,Tilemap.Settings.levelSize do
    local beginAtX = math.floor(self.camera.x/Tilemap.Settings.tileSize) - math.floor((love.graphics.getWidth()/2)/Tilemap.Settings.tileSize)
    local beginAtY = math.floor(self.camera.y/Tilemap.Settings.tileSize) - math.floor((love.graphics.getHeight()/2)/Tilemap.Settings.tileSize)
	for y = math.max(1,beginAtY), math.min(self:getLevelHeight(), beginAtY+self.maxTilesOnScreen[2])  do
		for x = math.max(1,beginAtX),math.min(self:getLevelWidth(), beginAtX+self.maxTilesOnScreen[1]) do
			if Tilemap.tileDict[self.tiles[x][y]].isObstacle then
				love.graphics.push()
				love.graphics.translate((x-1)*Tilemap.Settings.tileSize, (y-1)*Tilemap.Settings.tileSize)
				if (Tilemap.tileDict[self.tiles[x][y]].color) then
					love.graphics.setColor(unpack(Tilemap.tileDict[self.tiles[x][y]].color))
				end

				if (Tilemap.tileDict[self.tiles[x][y]].draw and Tilemap.tileDict[self.tiles[x][y]].drawParams) then
					Tilemap.tileDict[self.tiles[x][y]].draw(unpack(Tilemap.tileDict[self.tiles[x][y]].drawParams))
				end

				love.graphics.pop()
			end
		end
	end

    self.camera:stop()
end

--- renders lighted tiles with shadows and reflections
function Tilemap.Scene:renderShading()
    self.camera:begin()
    love.graphics.setColor(255,255,255)
    love.graphics.push()
    love.graphics.scale((self:getLevelWidth()*Tilemap.Settings.tileSize)  / Game.getSprite("assets/sprites/Tilemap/shading.png"):getWidth(),
                        (self:getLevelHeight()*Tilemap.Settings.tileSize) / Game.getSprite("assets/sprites/Tilemap/shading.png"):getHeight())
    love.graphics.setBlendMode("multiplicative")
    love.graphics.draw(Game.getSprite("assets/sprites/Tilemap/shading.png"))
    love.graphics.setBlendMode("alpha")
    love.graphics.pop()
    self.camera:stop()
end

--- Returns a list of shadowcasters that will be created from obstacle tiles
function Tilemap.Scene:getObstacleMeshes()
    local meshes = {}
    --for y = math.max(1,beginAtY), math.min(self:getLevelHeight(), beginAtY+self.maxTilesOnScreen[2])  do
	--	for x = math.max(1,beginAtX),math.min(self:getLevelWidth(), beginAtX+self.maxTilesOnScreen[1]) do
    for y = 1, self:getLevelHeight()  do
		for x = 1,self:getLevelHeight() do
			if Tilemap.tileDict[self.tiles[x][y]].isObstacle then
				meshes[#meshes+1] = Lighting.ShadowCaster.createRectangle((x-1)*Tilemap.Settings.tileSize + Tilemap.Settings.tileSize/2, (y-1)*Tilemap.Settings.tileSize + Tilemap.Settings.tileSize/2, Tilemap.Settings.tileSize/2, Tilemap.tileDict[self.tiles[x][y]].color, {})
			end
		end
	end
    return meshes
end

--- renders all characters from active scene
function Tilemap.Scene:renderCharacters()
    self.camera:begin()

	-- draw npcs
	for key,value in pairs(self.characters) do
		if value ~= self.characters[self.playerIndex] then
            value:render()
		end
	end

	-- draw player
    if #self.characters > 0 then
        self.characters[self.playerIndex]:render()
    end

    self.camera:stop()
end

--- Tile coordinate calculations
--@section tileco

--- Returns tile coordinates under screen coordinates (camera won't be recognized)
--@param x x-coordinate to check
--@param y y-coordinate to check
function Tilemap.Scene:getTileCoordinatesAtPosition(x,y)
	local tileX, tileY

	tileX = math.floor(x / Tilemap.Settings.tileSize)+1
	tileY = math.floor(y / Tilemap.Settings.tileSize)+1

	return tileX, tileY
end

--- Returns tile coordinates under screen coordinates with camera recognition
--@param mx x-cursor-coordinate to check
--@param my y-cursor-coordinate to check
function Tilemap.Scene:getTileCoordinatesByCamera(mx, my)
	return self:getTileCoordinatesAtPosition(self.camera.x + mx - love.graphics.getWidth() * 0.5, self.camera.y + my - love.graphics.getHeight() * 0.5)
end

--- Returns the tile coordinates under character with player index
function Tilemap.Scene:getTileCoordinatesUnderPlayer()
	return self:getTileCoordinatesUnderCharacter(self.characters[self.playerIndex])
end

--- Returns tile coordinates under a character
function Tilemap.Scene:getTileCoordinatesUnderCharacter(character)
	return self:getTileCoordinatesAtPosition(character.x, character.y)
end

--- Returns level width
function Tilemap.Scene:getLevelWidth()
	return #self.tiles
end

--- Returns level height
function Tilemap.Scene:getLevelHeight()
	return #self.tiles[1]
end

--- Pathfinding
--@section pathf

--- Returns the shortest path from start to goal as a list of tile coordinates
--@param startX x-coordinate of start point
--@param startY y-coordinate of start point
--@param goalX x-coordinate of goal point
--@param goalY Y-coordinate of goal point
--@return {{startX, startY}, {nextTileX, nextTileY}, ..., {goalX, goalY}}
function Tilemap.Scene:Route_getRoute(startX, startY, goalX, goalY)
	local goal 		= {goalX, goalY}
	local start 	= {startX, startY}
	local closed 	= {}
	local open 		= {}
	local cameFrom 	= {}
	local g_score 	= {}
	local f_score 	= {}
	local neighborTable = {}
	for x = 0,self:getLevelWidth()+1 do
		neighborTable[x] = {}
	end
	open[start] = true

	g_score[start] = 0
	f_score[start] = g_score[start] + math.sqrt(math.pow(goalX - startX, 2) + math.pow(goalY - startY, 2))

	while not self:Route_isOpenEmpty(open) do
		local current

		-- get node with lowest f_score
		for node,isOpen in pairs(open) do
			if isOpen then
				if current then
					if f_score[node] < f_score[current] then
						current = node
					end
				else
					current = node
				end
			end
		end

		-- goal found
		if current[1] == goalX and current[2] == goalY then
			return self:Route_reconstructPath(cameFrom, current)
		end

		-- remove current from open
		open[current] = false

		-- insert current in closed
		closed[current] = true

		local neighbors = self:Route_getNeighbors(current, neighborTable)

		for i,curNeighbor in pairs(neighbors) do
			if closed[curNeighbor] == nil then
				local tentative_g_score = g_score[current] + math.sqrt(math.pow(current[1] - curNeighbor[1], 2) + math.pow(current[2] - curNeighbor[2], 2))
				tentative_g_score = tentative_g_score + math.pow(Tilemap.Settings.tileSize/Tilemap.tileDict[self.tiles[current[1]][current[2]]].speed, 2)
				if not open[curNeighbor] or tentative_g_score < g_score[curNeighbor] then
					cameFrom[curNeighbor] = current
					g_score[curNeighbor] = tentative_g_score
					f_score[curNeighbor] = g_score[curNeighbor] + math.sqrt(math.pow(goal[1] - curNeighbor[1], 2) + math.pow(goal[2] - curNeighbor[2], 2))
					open[curNeighbor] = true
				end
			end
		end
	end

	return {}
end

---
function Tilemap.Scene:Route_reconstructPath(cameFrom, currentNode)
    if cameFrom[currentNode] then
        local path = self:Route_reconstructPath(cameFrom, cameFrom[currentNode])
		path[#path+1] = currentNode
        return path
    else
        return {currentNode}
	end
end

---
function Tilemap.Scene:Route_getNeighbors(node, neighborTable)
	local neighbors = {}

    -- 4-neighborhood
	if not neighborTable[node[1] - 1][node[2]    ] then neighborTable[node[1] - 1][node[2]    ] = {node[1] - 1,	node[2]     } end
	if not neighborTable[node[1]    ][node[2] - 1] then neighborTable[node[1]    ][node[2] - 1] = {node[1],		node[2] - 1	} end
	if not neighborTable[node[1]    ][node[2] + 1] then neighborTable[node[1]    ][node[2] + 1] = {node[1],		node[2] + 1	} end
	if not neighborTable[node[1] + 1][node[2]    ] then neighborTable[node[1] + 1][node[2]    ] = {node[1] + 1,	node[2]		} end

	neighbors[#neighbors+1] = neighborTable[node[1] - 1][node[2]    ]
	neighbors[#neighbors+1] = neighborTable[node[1]    ][node[2] - 1]
	neighbors[#neighbors+1] = neighborTable[node[1]    ][node[2] + 1]
	neighbors[#neighbors+1] = neighborTable[node[1] + 1][node[2]    ]

    -- 8-neighborhood
	if not neighborTable[node[1] + 1][node[2] + 1] and self.tiles[node[1] + 1] then
        if self.tiles[node[1] + 1][node[2] + 1] then
            if not Tilemap.tileDict[self.tiles[node[1] + 1][node[2]]].isObstacle and not Tilemap.tileDict[self.tiles[node[1]][node[2]+1]].isObstacle then
                neighborTable[node[1] + 1][node[2] + 1] = {node[1] + 1,	node[2] + 1	}
            end
        end
    end

    if not neighborTable[node[1] - 1][node[2] + 1] and self.tiles[node[1] - 1] then
        if self.tiles[node[1] - 1][node[2] + 1] then
            if not Tilemap.tileDict[self.tiles[node[1] - 1][node[2]]].isObstacle and not Tilemap.tileDict[self.tiles[node[1]][node[2]+1]].isObstacle then
                neighborTable[node[1] - 1][node[2] + 1] = {node[1] - 1,	node[2] + 1	}
            end
        end
    end

    if not neighborTable[node[1] + 1][node[2] - 1] and self.tiles[node[1] + 1]then
        if self.tiles[node[1] + 1][node[2] - 1] then
            if not Tilemap.tileDict[self.tiles[node[1] + 1][node[2]]].isObstacle and not Tilemap.tileDict[self.tiles[node[1]][node[2]-1]].isObstacle then
                neighborTable[node[1] + 1][node[2] - 1] = {node[1] + 1,	node[2] - 1	}
            end
        end
    end

    if not neighborTable[node[1] - 1][node[2] - 1] and self.tiles[node[1] - 1] then
        if self.tiles[node[1] - 1][node[2] - 1] then
            if not Tilemap.tileDict[self.tiles[node[1] - 1][node[2]]].isObstacle and not Tilemap.tileDict[self.tiles[node[1]][node[2] - 1]].isObstacle then
                neighborTable[node[1] - 1][node[2] - 1] = {node[1] - 1,	node[2] - 1	}
            end
        end
    end

	neighbors[#neighbors+1] = neighborTable[node[1] + 1][node[2] + 1]
	neighbors[#neighbors+1] = neighborTable[node[1] - 1][node[2] + 1]
	neighbors[#neighbors+1] = neighborTable[node[1] + 1][node[2] - 1]
	neighbors[#neighbors+1] = neighborTable[node[1] - 1][node[2] + 1]



	local correction = 0
	for i=1,#neighbors do
		if neighbors[i-correction][1] <= 0 or neighbors[i-correction][2] <= 0 or
		   neighbors[i-correction][1] > self:getLevelWidth() or neighbors[i-correction][2] > self:getLevelHeight() or
		   Tilemap.tileDict[self.tiles[neighbors[i-correction][1]][neighbors[i-correction][2]]].isObstacle
		then
			table.remove(neighbors, i-correction)
			correction = correction + 1
		 end
	end

	return neighbors
end

---
function Tilemap.Scene:Route_isOpenEmpty(open)
	for i,v in pairs(open) do
		if v then
			return false
		end
	end

	return true
end

function Tilemap.Scene:saveMap(filePath)
    local file = ""
    for y = 1,self:getLevelHeight() do
        for x = 1,self:getLevelWidth() do
            file = file .. self.tiles[x][y]
            if x < self:getLevelWidth() then file = file .. "," end
        end
        file = file .. ";"
    end

    love.filesystem.write   (filePath, file)
end

function Tilemap.Scene:loadMap(filePath)
    local file = love.filesystem.read(filePath)
    local tiles = {{}}
    local yIndex = 1
    local xIndex = 1
    local curTileIndexString = ""

    for i = 1, #file do
        local c = file:sub(i,i)
        if c == ";" then
            tiles[xIndex][yIndex] = tonumber(curTileIndexString)
            curTileIndexString = ""

            xIndex = 1
            yIndex = yIndex + 1


        elseif c == "," then
            tiles[xIndex][yIndex] = tonumber(curTileIndexString)
            curTileIndexString = ""
            xIndex = xIndex + 1
            if not tiles[xIndex] then tiles[xIndex] = {} end

        else
            curTileIndexString = curTileIndexString .. c
        end
    end

    Tilemap.getActiveScene().tiles = tiles
end
