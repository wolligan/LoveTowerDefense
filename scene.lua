require "character"
require "tables"

Scene = {}
Scene.tiles = {}
Scene.characters = {}
Scene.playerIndex = 0
Scene.maxTilesOnScreen = {}
Scene.maxTilesOnScreen[1] = math.floor(love.graphics.getWidth()  / tileSize)+2
Scene.maxTilesOnScreen[2] = math.floor(love.graphics.getHeight() / tileSize)

function Scene.createRandomLevel()
	math.randomseed(os.time())
	Scene.playerIndex = 1

	Scene.tiles = {}
	for x = 1,levelSize do
		Scene.tiles[x] = {}
		for y = 1,levelSize do
			Scene.tiles[x][y] = math.random(1,4)
		end
	end
	Scene.tiles[math.floor(levelSize/2)][math.floor(levelSize/2)] = 1
	
	Scene.characters = {}
	for i = 1,20 do
		Scene.characters[#Scene.characters+1] = Character(  math.random(0,levelSize-1)*tileSize + tileSize*0.5, 
                                                            math.random(0,levelSize-1)*tileSize + tileSize*0.5)
		
		while tileDict[Scene.characters[#Scene.characters]:getTileIndex()][5] do
			Scene.characters[#Scene.characters].x = math.random(0,levelSize-1)*tileSize + tileSize*0.5
			Scene.characters[#Scene.characters].y = math.random(0,levelSize-1)*tileSize + tileSize*0.5
			Scene.characters[#Scene.characters]:AI_calculatePathToGoal()
		end
	end
	--local tileX,tileY = Scene.getTileCoordinatesUnderCharacter(Scene.characters[2])
	--Scene.characters[2].pathToGoal = Scene.Route.getRoute(tileX, tileY, Scene.characters[2].goalX, Scene.characters[2].goalY)
end

function Scene.render()
	-- draw level
	--for y = 1,levelSize do
	--	for x = 1,levelSize do
    local beginAtX = math.floor(camera.x/tileSize) - math.floor((love.graphics.getWidth()/2)/tileSize), levelSize
    local beginAtY = math.floor(camera.y/tileSize) - math.floor((love.graphics.getHeight()/2)/tileSize)+1,levelSize
	for y = math.max(1,beginAtY), math.min(#Scene.tiles[1], beginAtY+Scene.maxTilesOnScreen[2])  do
		for x = math.max(1,beginAtX),math.min(#Scene.tiles[1], beginAtX+Scene.maxTilesOnScreen[1]) do
			if tileDict[Scene.tiles[x][y]] then
				love.graphics.push()
				love.graphics.translate((x-1)*tileSize, (y-1)*tileSize)
				if (tileDict[Scene.tiles[y][x]][3]) then
					love.graphics.setColor(unpack(tileDict[Scene.tiles[x][y]][3]))
				end
				
				if (tileDict[Scene.tiles[x][y]][1] and tileDict[Scene.tiles[x][y]][2]) then
					tileDict[Scene.tiles[x][y]][1](unpack(tileDict[Scene.tiles[x][y]][2]))
				end
				
				love.graphics.pop()
			end
		end
	end
	
	-- DEBUG: highlight tile under player
	--[[
	local playerTileX, playerTileY = Scene.getTileCoordinatesUnderPlayer()
	love.graphics.setColor(255,255,0)
	love.graphics.push()
	love.graphics.translate((playerTileX-1)*tileSize, (playerTileY-1)*tileSize)
	love.graphics.rectangle("fill", 0,0, tileSize, tileSize)
	love.graphics.pop()
	]]
	
	
	-- draw npcs
	for key,value in pairs(Scene.characters) do
		if value ~= Scene.characters[Scene.playerIndex] then
			love.graphics.setColor(0,127,0)
			love.graphics.rectangle("fill", value.x-playerSize*0.5, value.y-playerSize*0.5, playerSize, playerSize)
		end
	end
	
	
	-- DEBUG: draw player's path
	for i,v in pairs(Scene.characters[Scene.playerIndex].pathToGoal) do
		love.graphics.setColor(0,127,0,100)
		love.graphics.rectangle("fill",(v[1]-1)*tileSize, (v[2]-1)*tileSize, tileSize, tileSize)
	end
	
	-- draw player
	love.graphics.setColor(0,255,0)
	love.graphics.rectangle("fill", Scene.characters[Scene.playerIndex].x-playerSize*0.5, Scene.characters[Scene.playerIndex].y-playerSize*0.5, playerSize, playerSize)
	
end

function Scene.getTileCoordinatesUnderPlayer()
	return Scene.getTileCoordinatesUnderCharacter(Scene.characters[Scene.playerIndex])
end

function Scene.getTileCoordinatesUnderCharacter(character)
	return Scene.getTileCoordinatesAtPosition(character.x, character.y)
end

function Scene.getTileCoordinatesAtPosition(x,y)
	local tileX, tileY
	
	tileX = math.floor(x / tileSize)+1
	tileY = math.floor(y / tileSize)+1
	
	return tileX, tileY
end

function Scene.getLevelWidth()
	return #Scene.tiles
end

function Scene.getLevelHeight()
	return #Scene.tiles[1]
end

Scene.Route = {}
function Scene.Route.reconstructPath(cameFrom, currentNode)
    if cameFrom[currentNode] then
        local path = Scene.Route.reconstructPath(cameFrom, cameFrom[currentNode])
		path[#path+1] = currentNode
        return path
    else
        return {currentNode}
	end
end
function Scene.Route.getRoute(startX, startY, goalX, goalY)
	local goal 		= {goalX, goalY}
	local start 	= {startX, startY}
	local closed 	= {}
	local open 		= {}
	local cameFrom 	= {}
	local g_score 	= {}
	local f_score 	= {}
	local neighborTable = {}
	for x = 0,Scene.getLevelWidth()+1 do
		neighborTable[x] = {}
	end
	open[start] = true
	
	g_score[start] = 0
	f_score[start] = g_score[start] + math.sqrt(math.pow(goalX - startX, 2) + math.pow(goalY - startY, 2))
	
	while not Scene.Route.isOpenEmpty(open) do
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
			return Scene.Route.reconstructPath(cameFrom, current)
		end
		
		-- remove current from open
		open[current] = false
		
		-- insert current in closed
		closed[current] = true
		
		local neighbors = Scene.Route.getNeighbors(current, neighborTable)
		
		for i,curNeighbor in pairs(neighbors) do
			if closed[curNeighbor] == nil then
				local tentative_g_score = g_score[current] + math.sqrt(math.pow(current[1] - curNeighbor[1], 2) + math.pow(current[2] - curNeighbor[2], 2))
				tentative_g_score = tentative_g_score + math.pow(tileSize/tileDict[Scene.tiles[current[1]][current[2]]][4],2)
				-- if tileDict[Scene.tiles[current[1]][current[2]]][5] then
					-- tentative_g_score = tentative_g_score * tentative_g_score
				-- end
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
	
function Scene.Route.getNeighbors(node, neighborTable)
	local neighbors = {}
	
	-- if not neighborTable[node[1] - 1][node[2] - 1] then neighborTable[node[1] - 1][node[2] - 1] = {node[1] - 1,	node[2] - 1 } end
	if not neighborTable[node[1] - 1][node[2]    ] then neighborTable[node[1] - 1][node[2]    ] = {node[1] - 1,	node[2]     } end
	-- if not neighborTable[node[1] - 1][node[2] + 1] then neighborTable[node[1] - 1][node[2] + 1] = {node[1] - 1,	node[2] + 1	} end
	if not neighborTable[node[1]    ][node[2] - 1] then neighborTable[node[1]    ][node[2] - 1] = {node[1],		node[2] - 1	} end
	if not neighborTable[node[1]    ][node[2] + 1] then neighborTable[node[1]    ][node[2] + 1] = {node[1],		node[2] + 1	} end
	-- if not neighborTable[node[1] + 1][node[2] - 1] then neighborTable[node[1] + 1][node[2] - 1] = {node[1] + 1,	node[2] - 1	} end
	if not neighborTable[node[1] + 1][node[2]    ] then neighborTable[node[1] + 1][node[2]    ] = {node[1] + 1,	node[2]		} end
	-- if not neighborTable[node[1] + 1][node[2] + 1] then neighborTable[node[1] + 1][node[2] + 1] = {node[1] + 1,	node[2] + 1	} end
	
	
	neighbors[#neighbors+1] = neighborTable[node[1] - 1][node[2]    ]
	neighbors[#neighbors+1] = neighborTable[node[1]    ][node[2] - 1]
	neighbors[#neighbors+1] = neighborTable[node[1]    ][node[2] + 1]
	neighbors[#neighbors+1] = neighborTable[node[1] + 1][node[2]    ]
	
	
	local correction = 0
	for i=1,#neighbors do
		if neighbors[i-correction][1] <= 0 or neighbors[i-correction][2] <= 0 or
		   neighbors[i-correction][1] > Scene.getLevelWidth() or neighbors[i-correction][2] > Scene.getLevelHeight() or 
		   tileDict[Scene.tiles[neighbors[i-correction][1]][neighbors[i-correction][2]]][5]
		then
			table.remove(neighbors, i-correction)
			correction = correction + 1
		 end
	end
	
	return neighbors
end

function Scene.Route.isOpenEmpty(open)
	for i,v in pairs(open) do 
		if v then
			return false
		end
	end
	
	return true
end