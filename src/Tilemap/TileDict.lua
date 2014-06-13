--- TileDict saves visual representation of tiles and mechanics of tiles.
-- Members of a tile:
--
-- name - string with the name of the tile.
--
-- draw - function that gets called for rendering the tile.
--
-- drawParams - parameters of the draw function.
--
-- color - color of the tile as {r,g,b}.
--
-- speed - multiplicator of the speed, 1 changes nothing.
--
-- isObstacle - a character cannot walk of an obstacle.
--
-- update - function that gets called before rendering
--@author Steve Wolligandt

--- Tile Dictionary for LightedTowerDefense
--@field air1 White standard tile being no obstacle and white and having no speed change
--@field air2 Light grey standard tile being no obstacle and white and having no speed change
--@field sand sand lets characters walk slowlier than on air tiles
--@field obstacle characters cannot walk over this kind of tile
--@field spawner dark mobs spawn here when a tick is sent to the update function
--@field towerBuildPoint obstacle where a tower can be built
--@field waypointForLighting waypoint for light mobs
--@field waypointForDarkness waypoint for dark mobs
Tilemap.tileDict = {}

Tilemap.tileDict[#Tilemap.tileDict+1] = {
    name = "air1",
    draw = love.graphics.rectangle,
    drawParams = {"fill", 0, 0, Tilemap.Settings.tileSize, Tilemap.Settings.tileSize},
    color = {255,255,255},
    speed = 1,
    isObstacle = false,
    update = nil
}

--2
Tilemap.tileDict[#Tilemap.tileDict+1] = {
    name = "air2",
    draw = love.graphics.rectangle,
    drawParams = {"fill", 0, 0, Tilemap.Settings.tileSize, Tilemap.Settings.tileSize},
    color = {240,240,240},
    speed = 1,
    isObstacle = false,
    update = nil
}

--3
Tilemap.tileDict[#Tilemap.tileDict+1] = {
    name = "sand",
    draw = love.graphics.rectangle,
    drawParams = {"fill", 0, 0, Tilemap.Settings.tileSize, Tilemap.Settings.tileSize},
    color = {255,243,191},
    speed = 0.4,
    isObstacle = false,
    update = nil
}

--4
Tilemap.tileDict[#Tilemap.tileDict+1] = {
    name = "obstacle",
    draw = love.graphics.rectangle,
    drawParams = {"fill", 0, 0, Tilemap.Settings.tileSize, Tilemap.Settings.tileSize},
    color = {20,20,20},
    speed = 1,
    isObstacle = true,
    update = nil
}

--5
Tilemap.tileDict[#Tilemap.tileDict+1] = {
    name = "spawner",
    draw = love.graphics.rectangle,
    drawParams = {"fill", 0, 0, Tilemap.Settings.tileSize, Tilemap.Settings.tileSize},
    color = {120,37,98},
    speed = 1,
    isObstacle = false,
    update = function(apparentScene, posX, posY, tick)
        if tick then
            local randomRange = 3
            apparentScene.characters[#apparentScene.characters+1] = Ingame.TempCharacter(   apparentScene,
                                                                                        posX*Tilemap.Settings.tileSize - Tilemap.Settings.tileSize/2,
                                                                                        posY*Tilemap.Settings.tileSize - Tilemap.Settings.tileSize/2,
                                                                                        {math.random(0,randomRange)/randomRange*2,55,math.random(0,randomRange)/randomRange*255, math.random(0,randomRange)/randomRange*255, })
            Ingame.SpawnPhase.spawnedMobs = Ingame.SpawnPhase.spawnedMobs + 1
        end
    end
}

--6
Tilemap.tileDict[#Tilemap.tileDict+1] = {
    name = "tower build point",
    draw = function()
        love.graphics.setColor(70,70,70)
        love.graphics.rectangle("fill", 0, 0, Tilemap.Settings.tileSize, Tilemap.Settings.tileSize)
        love.graphics.setColor(200,0,0)
        love.graphics.draw( Game.getSprite("assets/sprites/Ingame/circle.png"), 2,2, 0,
                            (Tilemap.Settings.tileSize-4)/Game.getSprite("assets/sprites/Ingame/circle.png"):getWidth(),
                            (Tilemap.Settings.tileSize-4)/Game.getSprite("assets/sprites/Ingame/circle.png"):getHeight())
        --love.graphics.circle("fill", Tilemap.Settings.tileSize/2, Tilemap.Settings.tileSize/2, Tilemap.Settings.tileSize/2-3)
    end,
    drawParams = {},
    color = {255,0,0},
    speed = 1,
    isObstacle = true,
    update = nil
}

--7
Tilemap.tileDict[#Tilemap.tileDict+1] = {
    name = "waypoint for lighting",
    draw = love.graphics.rectangle,
    drawParams = {"fill", 0, 0, Tilemap.Settings.tileSize, Tilemap.Settings.tileSize},
    color = {0,255,255},
    speed = 1,
    isObstacle = false,
    update = nil
}

--8
Tilemap.tileDict[#Tilemap.tileDict+1] = {
    name = "waypoint for darkness",
    draw = love.graphics.rectangle,
    drawParams = {"fill", 0, 0, Tilemap.Settings.tileSize, Tilemap.Settings.tileSize},
    color = {255,0,255},
    speed = 1,
    isObstacle = false,
    update = nil
}
