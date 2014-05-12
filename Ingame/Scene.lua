--- ADD ME
Ingame.Scene = {}

require "OO"
require "Ingame.Character"

OO.createClass(Ingame.Scene)

---
function Ingame.Scene:new()
    self.tiles = {}
    for x = 1,Ingame.Settings.levelSize do
		self.tiles[x] = {}
		for y = 1,Ingame.Settings.levelSize do
			self.tiles[x][y] = 1
		end
	end

    self.characters = {}
    self.playerIndex = 0

    self.lightSources = {}
    self.meshes = {}

    self.maxTilesOnScreen = {}
    self.maxTilesOnScreen[1] = math.floor(love.graphics.getWidth()  / Ingame.Settings.tileSize)+2
    self.maxTilesOnScreen[2] = math.floor(love.graphics.getHeight() / Ingame.Settings.tileSize)
end

---
function Ingame.Scene:createRandomLevel()
	self.playerIndex = 1

	for x = 1,Ingame.Settings.levelSize do
		for y = 1,Ingame.Settings.levelSize do
			self.tiles[x][y] = math.random(1,4)
		end
	end

	self.tiles[math.floor(Ingame.Settings.levelSize/2)][math.floor(Ingame.Settings.levelSize/2)] = 1

	self.characters = {}
	for i = 1,20 do
		self.characters[#self.characters+1] = Ingame.Character(self,
                                                               math.random(0,Ingame.Settings.levelSize-1)*Ingame.Settings.tileSize + Ingame.Settings.tileSize*0.5,
                                                               math.random(0,Ingame.Settings.levelSize-1)*Ingame.Settings.tileSize + Ingame.Settings.tileSize*0.5)

		while Ingame.tileDict[self.characters[#self.characters]:getTileIndex()][5] do
			self.characters[#self.characters].x = math.random(0,Ingame.Settings.levelSize-1)*Ingame.Settings.tileSize + Ingame.Settings.tileSize*0.5
			self.characters[#self.characters].y = math.random(0,Ingame.Settings.levelSize-1)*Ingame.Settings.tileSize + Ingame.Settings.tileSize*0.5
			self.characters[#self.characters]:AI_calculatePathToGoal()
		end
	end
end

---
function Ingame.Scene:render()
	-- draw level
	--for y = 1,Ingame.Settings.levelSize do
	--	for x = 1,Ingame.Settings.levelSize do
    local beginAtX = math.floor(Ingame.Camera.x/Ingame.Settings.tileSize) - math.floor((love.graphics.getWidth()/2)/Ingame.Settings.tileSize), Ingame.Settings.levelSize
    local beginAtY = math.floor(Ingame.Camera.y/Ingame.Settings.tileSize) - math.floor((love.graphics.getHeight()/2)/Ingame.Settings.tileSize)+1,Ingame.Settings.levelSize
	for y = math.max(1,beginAtY), math.min(self:getLevelHeight(), beginAtY+self.maxTilesOnScreen[2])  do
		for x = math.max(1,beginAtX),math.min(self:getLevelWidth(), beginAtX+self.maxTilesOnScreen[1]) do
			if Ingame.tileDict[self.tiles[x][y]] then
				love.graphics.push()
				love.graphics.translate((x-1)*Ingame.Settings.tileSize, (y-1)*Ingame.Settings.tileSize)
				if (Ingame.tileDict[self.tiles[y][x]][3]) then
					love.graphics.setColor(unpack(Ingame.tileDict[self.tiles[x][y]][3]))
				end

				if (Ingame.tileDict[self.tiles[x][y]][1] and Ingame.tileDict[self.tiles[x][y]][2]) then
					Ingame.tileDict[self.tiles[x][y]][1](unpack(Ingame.tileDict[self.tiles[x][y]][2]))
				end

				love.graphics.pop()
			end
		end
	end

	-- DEBUG: highlight tile under player
	--[[
	local playerTileX, playerTileY = self:getTileCoordinatesUnderPlayer()
	love.graphics.setColor(255,255,0)
	love.graphics.push()
	love.graphics.translate((playerTileX-1)*Ingame.Settings.tileSize, (playerTileY-1)*Ingame.Settings.tileSize)
	love.graphics.rectangle("fill", 0,0, Ingame.Settings.tileSize, Ingame.Settings.tileSize)
	love.graphics.pop()
	]]


	-- draw npcs
	for key,value in pairs(self.characters) do
		if value ~= self.characters[self.playerIndex] then
			love.graphics.setColor(0,127,0)
			love.graphics.rectangle("fill", value.x-Ingame.Settings.playerSize*0.5, value.y-Ingame.Settings.playerSize*0.5, Ingame.Settings.playerSize, Ingame.Settings.playerSize)
		end
	end


	-- DEBUG: draw player's path
    if #self.characters > 0 then
        for i,v in pairs(self.characters[self.playerIndex].pathToGoal) do
            love.graphics.setColor(0,127,0,100)
            love.graphics.rectangle("fill",(v[1]-1)*Ingame.Settings.tileSize, (v[2]-1)*Ingame.Settings.tileSize, Ingame.Settings.tileSize, Ingame.Settings.tileSize)
        end
    end

	-- draw player
    if #self.characters > 0 then
        love.graphics.setColor(0,255,0)
        love.graphics.rectangle("fill", self.characters[self.playerIndex].x-Ingame.Settings.playerSize*0.5, self.characters[self.playerIndex].y-Ingame.Settings.playerSize*0.5,
                                        Ingame.Settings.playerSize, Ingame.Settings.playerSize)
    end
end

---
function Ingame.Scene:getTileCoordinatesUnderPlayer()
	return self:getTileCoordinatesUnderCharacter(self.characters[self.playerIndex])
end

---
function Ingame.Scene:getTileCoordinatesUnderCharacter(character)
	return self:getTileCoordinatesAtPosition(character.x, character.y)
end

---
function Ingame.Scene:getTileCoordinatesAtPosition(x,y)
	local tileX, tileY

	tileX = math.floor(x / Ingame.Settings.tileSize)+1
	tileY = math.floor(y / Ingame.Settings.tileSize)+1

	return tileX, tileY
end

---
function Ingame.Scene:getLevelWidth()
	return #self.tiles
end

---
function Ingame.Scene:getLevelHeight()
	return #self.tiles[1]
end

---
function Ingame.Scene:Route_reconstructPath(cameFrom, currentNode)
    if cameFrom[currentNode] then
        local path = self:Route_reconstructPath(cameFrom, cameFrom[currentNode])
		path[#path+1] = currentNode
        return path
    else
        return {currentNode}
	end
end

---
function Ingame.Scene:Route_getRoute(startX, startY, goalX, goalY)
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
				tentative_g_score = tentative_g_score + math.pow(Ingame.Settings.tileSize/Ingame.tileDict[self.tiles[current[1]][current[2]]][4],2)
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
function Ingame.Scene:Route_getNeighbors(node, neighborTable)
	local neighbors = {}

	if not neighborTable[node[1] - 1][node[2]    ] then neighborTable[node[1] - 1][node[2]    ] = {node[1] - 1,	node[2]     } end
	if not neighborTable[node[1]    ][node[2] - 1] then neighborTable[node[1]    ][node[2] - 1] = {node[1],		node[2] - 1	} end
	if not neighborTable[node[1]    ][node[2] + 1] then neighborTable[node[1]    ][node[2] + 1] = {node[1],		node[2] + 1	} end
	if not neighborTable[node[1] + 1][node[2]    ] then neighborTable[node[1] + 1][node[2]    ] = {node[1] + 1,	node[2]		} end

--	if not neighborTable[node[1] + 1][node[2] + 1] then neighborTable[node[1] + 1][node[2] + 1] = {node[1] + 1,	node[2] + 1	} end
--	if not neighborTable[node[1] - 1][node[2] + 1] then neighborTable[node[1] - 1][node[2] + 1] = {node[1] - 1,	node[2] + 1	} end
--	if not neighborTable[node[1] + 1][node[2] - 1] then neighborTable[node[1] + 1][node[2] - 1] = {node[1] + 1,	node[2] - 1	} end
--	if not neighborTable[node[1] - 1][node[2] - 1] then neighborTable[node[1] - 1][node[2] - 1] = {node[1] - 1,	node[2] - 1 } end


	neighbors[#neighbors+1] = neighborTable[node[1] - 1][node[2]    ]
	neighbors[#neighbors+1] = neighborTable[node[1]    ][node[2] - 1]
	neighbors[#neighbors+1] = neighborTable[node[1]    ][node[2] + 1]
	neighbors[#neighbors+1] = neighborTable[node[1] + 1][node[2]    ]


	local correction = 0
	for i=1,#neighbors do
		if neighbors[i-correction][1] <= 0 or neighbors[i-correction][2] <= 0 or
		   neighbors[i-correction][1] > self:getLevelWidth() or neighbors[i-correction][2] > self:getLevelHeight() or
		   Ingame.tileDict[self.tiles[neighbors[i-correction][1]][neighbors[i-correction][2]]][5]
		then
			table.remove(neighbors, i-correction)
			correction = correction + 1
		 end
	end

	return neighbors
end

---
function Ingame.Scene:Route_isOpenEmpty(open)
	for i,v in pairs(open) do
		if v then
			return false
		end
	end

	return true
end
