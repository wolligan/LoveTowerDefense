require "ingame.character"
require "tables"

Ingame.Scene = {}
Ingame.Scene.tiles = {}
Ingame.Scene.characters = {}
Ingame.Scene.playerIndex = 0
Ingame.Scene.maxTilesOnScreen = {}
Ingame.Scene.maxTilesOnScreen[1] = math.floor(love.graphics.getWidth()  / Ingame.Settings.tileSize)+2
Ingame.Scene.maxTilesOnScreen[2] = math.floor(love.graphics.getHeight() / Ingame.Settings.tileSize)

function Ingame.Scene.createRandomLevel()
	math.randomseed(os.time())
	Ingame.Scene.playerIndex = 1

	Ingame.Scene.tiles = {}
	for x = 1,Ingame.Settings.levelSize do
		Ingame.Scene.tiles[x] = {}
		for y = 1,Ingame.Settings.levelSize do
			Ingame.Scene.tiles[x][y] = math.random(1,4)
		end
	end
	Ingame.Scene.tiles[math.floor(Ingame.Settings.levelSize/2)][math.floor(Ingame.Settings.levelSize/2)] = 1

	Ingame.Scene.characters = {}
	for i = 1,20 do
		Ingame.Scene.characters[#Ingame.Scene.characters+1] = Ingame.Character(  math.random(0,Ingame.Settings.levelSize-1)*Ingame.Settings.tileSize + Ingame.Settings.tileSize*0.5,
                                                            math.random(0,Ingame.Settings.levelSize-1)*Ingame.Settings.tileSize + Ingame.Settings.tileSize*0.5)

		while Ingame.tileDict[Ingame.Scene.characters[#Ingame.Scene.characters]:getTileIndex()][5] do
			Ingame.Scene.characters[#Ingame.Scene.characters].x = math.random(0,Ingame.Settings.levelSize-1)*Ingame.Settings.tileSize + Ingame.Settings.tileSize*0.5
			Ingame.Scene.characters[#Ingame.Scene.characters].y = math.random(0,Ingame.Settings.levelSize-1)*Ingame.Settings.tileSize + Ingame.Settings.tileSize*0.5
			Ingame.Scene.characters[#Ingame.Scene.characters]:AI_calculatePathToGoal()
		end
	end
	--local tileX,tileY = Ingame.Scene.getTileCoordinatesUnderCharacter(Ingame.Scene.characters[2])
	--Ingame.Scene.characters[2].pathToGoal = Ingame.Scene.Route.getRoute(tileX, tileY, Ingame.Scene.characters[2].goalX, Ingame.Scene.characters[2].goalY)
end

function Ingame.Scene.render()
	-- draw level
	--for y = 1,Ingame.Settings.levelSize do
	--	for x = 1,Ingame.Settings.levelSize do
    local beginAtX = math.floor(Ingame.Camera.x/Ingame.Settings.tileSize) - math.floor((love.graphics.getWidth()/2)/Ingame.Settings.tileSize), Ingame.Settings.levelSize
    local beginAtY = math.floor(Ingame.Camera.y/Ingame.Settings.tileSize) - math.floor((love.graphics.getHeight()/2)/Ingame.Settings.tileSize)+1,Ingame.Settings.levelSize
	for y = math.max(1,beginAtY), math.min(#Ingame.Scene.tiles[1], beginAtY+Ingame.Scene.maxTilesOnScreen[2])  do
		for x = math.max(1,beginAtX),math.min(#Ingame.Scene.tiles[1], beginAtX+Ingame.Scene.maxTilesOnScreen[1]) do
			if Ingame.tileDict[Ingame.Scene.tiles[x][y]] then
				love.graphics.push()
				love.graphics.translate((x-1)*Ingame.Settings.tileSize, (y-1)*Ingame.Settings.tileSize)
				if (Ingame.tileDict[Ingame.Scene.tiles[y][x]][3]) then
					love.graphics.setColor(unpack(Ingame.tileDict[Ingame.Scene.tiles[x][y]][3]))
				end

				if (Ingame.tileDict[Ingame.Scene.tiles[x][y]][1] and Ingame.tileDict[Ingame.Scene.tiles[x][y]][2]) then
					Ingame.tileDict[Ingame.Scene.tiles[x][y]][1](unpack(Ingame.tileDict[Ingame.Scene.tiles[x][y]][2]))
				end

				love.graphics.pop()
			end
		end
	end

	-- DEBUG: highlight tile under player
	--[[
	local playerTileX, playerTileY = Ingame.Scene.getTileCoordinatesUnderPlayer()
	love.graphics.setColor(255,255,0)
	love.graphics.push()
	love.graphics.translate((playerTileX-1)*Ingame.Settings.tileSize, (playerTileY-1)*Ingame.Settings.tileSize)
	love.graphics.rectangle("fill", 0,0, Ingame.Settings.tileSize, Ingame.Settings.tileSize)
	love.graphics.pop()
	]]


	-- draw npcs
	for key,value in pairs(Ingame.Scene.characters) do
		if value ~= Ingame.Scene.characters[Ingame.Scene.playerIndex] then
			love.graphics.setColor(0,127,0)
			love.graphics.rectangle("fill", value.x-Ingame.Settings.playerSize*0.5, value.y-Ingame.Settings.playerSize*0.5, Ingame.Settings.playerSize, Ingame.Settings.playerSize)
		end
	end


	-- DEBUG: draw player's path
	for i,v in pairs(Ingame.Scene.characters[Ingame.Scene.playerIndex].pathToGoal) do
		love.graphics.setColor(0,127,0,100)
		love.graphics.rectangle("fill",(v[1]-1)*Ingame.Settings.tileSize, (v[2]-1)*Ingame.Settings.tileSize, Ingame.Settings.tileSize, Ingame.Settings.tileSize)
	end

	-- draw player
	love.graphics.setColor(0,255,0)
	love.graphics.rectangle("fill", Ingame.Scene.characters[Ingame.Scene.playerIndex].x-Ingame.Settings.playerSize*0.5, Ingame.Scene.characters[Ingame.Scene.playerIndex].y-Ingame.Settings.playerSize*0.5, Ingame.Settings.playerSize, Ingame.Settings.playerSize)

end

function Ingame.Scene.getTileCoordinatesUnderPlayer()
	return Ingame.Scene.getTileCoordinatesUnderCharacter(Ingame.Scene.characters[Ingame.Scene.playerIndex])
end

function Ingame.Scene.getTileCoordinatesUnderCharacter(character)
	return Ingame.Scene.getTileCoordinatesAtPosition(character.x, character.y)
end

function Ingame.Scene.getTileCoordinatesAtPosition(x,y)
	local tileX, tileY

	tileX = math.floor(x / Ingame.Settings.tileSize)+1
	tileY = math.floor(y / Ingame.Settings.tileSize)+1

	return tileX, tileY
end

function Ingame.Scene.getLevelWidth()
	return #Ingame.Scene.tiles
end

function Ingame.Scene.getLevelHeight()
	return #Ingame.Scene.tiles[1]
end

Ingame.Scene.Route = {}
function Ingame.Scene.Route.reconstructPath(cameFrom, currentNode)
    if cameFrom[currentNode] then
        local path = Ingame.Scene.Route.reconstructPath(cameFrom, cameFrom[currentNode])
		path[#path+1] = currentNode
        return path
    else
        return {currentNode}
	end
end
function Ingame.Scene.Route.getRoute(startX, startY, goalX, goalY)
	local goal 		= {goalX, goalY}
	local start 	= {startX, startY}
	local closed 	= {}
	local open 		= {}
	local cameFrom 	= {}
	local g_score 	= {}
	local f_score 	= {}
	local neighborTable = {}
	for x = 0,Ingame.Scene.getLevelWidth()+1 do
		neighborTable[x] = {}
	end
	open[start] = true

	g_score[start] = 0
	f_score[start] = g_score[start] + math.sqrt(math.pow(goalX - startX, 2) + math.pow(goalY - startY, 2))

	while not Ingame.Scene.Route.isOpenEmpty(open) do
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
			return Ingame.Scene.Route.reconstructPath(cameFrom, current)
		end

		-- remove current from open
		open[current] = false

		-- insert current in closed
		closed[current] = true

		local neighbors = Ingame.Scene.Route.getNeighbors(current, neighborTable)

		for i,curNeighbor in pairs(neighbors) do
			if closed[curNeighbor] == nil then
				local tentative_g_score = g_score[current] + math.sqrt(math.pow(current[1] - curNeighbor[1], 2) + math.pow(current[2] - curNeighbor[2], 2))
				tentative_g_score = tentative_g_score + math.pow(Ingame.Settings.tileSize/Ingame.tileDict[Ingame.Scene.tiles[current[1]][current[2]]][4],2)
				-- if Ingame.tileDict[Ingame.Scene.tiles[current[1]][current[2]]][5] then
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

function Ingame.Scene.Route.getNeighbors(node, neighborTable)
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
		   neighbors[i-correction][1] > Ingame.Scene.getLevelWidth() or neighbors[i-correction][2] > Ingame.Scene.getLevelHeight() or
		   Ingame.tileDict[Ingame.Scene.tiles[neighbors[i-correction][1]][neighbors[i-correction][2]]][5]
		then
			table.remove(neighbors, i-correction)
			correction = correction + 1
		 end
	end

	return neighbors
end

function Ingame.Scene.Route.isOpenEmpty(open)
	for i,v in pairs(open) do
		if v then
			return false
		end
	end

	return true
end
