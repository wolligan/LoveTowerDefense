--- TileDict saves visual representation of tiles and mechanics of tiles.
-- Members of a tile:
-- name - string with the name of the tile.
-- draw - function that gets called for rendering the tile.
-- drawParams - parameters of the draw function.
-- color - color of the tile as {r,g,b}.
-- speed - multiplicator of the speed, 1 changes nothing.
-- isObstacle - a character cannot walk of an obstacle.
-- update - function that gets called before rendering

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

Tilemap.tileDict[#Tilemap.tileDict+1] = {
    name = "air2",
    draw = love.graphics.rectangle,
    drawParams = {"fill", 0, 0, Tilemap.Settings.tileSize, Tilemap.Settings.tileSize},
    color = {240,240,240},
    speed = 1,
    isObstacle = false,
    update = nil
}

Tilemap.tileDict[#Tilemap.tileDict+1] = {
    name = "sand",
    draw = love.graphics.rectangle,
    drawParams = {"fill", 0, 0, Tilemap.Settings.tileSize, Tilemap.Settings.tileSize},
    color = {255,243,191},
    speed = 0.4,
    isObstacle = false,
    update = nil
}

Tilemap.tileDict[#Tilemap.tileDict+1] = {
    name = "obstacle",
    draw = love.graphics.rectangle,
    drawParams = {"fill", 0, 0, Tilemap.Settings.tileSize, Tilemap.Settings.tileSize},
    color = {0,0,0},
    speed = 1,
    isObstacle = true,
    update = nil
}

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

Tilemap.tileDict[#Tilemap.tileDict+1] = {
    name = "waypoint for light",
    draw = love.graphics.rectangle,
    drawParams = {"fill", 0, 0, Tilemap.Settings.tileSize, Tilemap.Settings.tileSize},
    color = {255,0,0},
    speed = 1,
    isObstacle = false,
    update = nil
}

Tilemap.tileDict[#Tilemap.tileDict+1] = {
    name = "waypoint for darkness",
    draw = love.graphics.rectangle,
    drawParams = {"fill", 0, 0, Tilemap.Settings.tileSize, Tilemap.Settings.tileSize},
    color = {0,255,255},
    speed = 1,
    isObstacle = false,
    update = nil
}
