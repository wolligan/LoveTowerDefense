--- Renders and updates lighted tilemaps
--@author Steve Wolligandt
--@module Tilemap

Tilemap = {}

require "Tilemap.Camera"
require "Tilemap.Character"
require "Tilemap.Scene"
require "Tilemap.Settings"
require "Tilemap.TileDict"
require "Lighting"

Tilemap.activeSceneIndex = 1
Tilemap.loadedScenes = {}
Tilemap.tickTime = 1
Tilemap.curTickTime = 0
Tilemap.paused = false


--- initializes the Tilemap Engine
function Tilemap.init()
    Tilemap.lastTime = love.timer.getTime()
    Lighting.init()
    Lighting.ambient = Lighting.AmbientLight(255,255,255)

    Lighting.drawUnlitBackground = function() Tilemap.getActiveScene():renderTiles() end
end

--- renders the Tilemap Engine
function Tilemap.render()
    Lighting.renderShadedScene(love.graphics.getWidth()/2-Tilemap.getActiveScene().camera.x, love.graphics.getHeight()/2 - Tilemap.getActiveScene().camera.y)
    Tilemap.getActiveScene():renderObstacleTiles()
    Tilemap.getActiveScene():renderShading()
    Tilemap.getActiveScene():renderCharacters()
    --Tilemap.renderActiveSceneTiles()
end

--- updates the Tilemap Engine
--@param dt delta time
function Tilemap.update(dt)
    if #Tilemap.loadedScenes > 0 then
        Tilemap.getActiveScene().camera:update(dt)
        if (not Tilemap.paused) then
            Tilemap.curTickTime = Tilemap.curTickTime + dt
            local sendTick = Tilemap.curTickTime >= Tilemap.tickTime
            if sendTick then
                Tilemap.curTickTime = Tilemap.tickTime - Tilemap.curTickTime
            end

            for x = 1,Tilemap:getActiveScene():getLevelWidth() do
                for y = 1,Tilemap:getActiveScene():getLevelHeight() do
                    if Tilemap.tileDict[Tilemap:getActiveScene().tiles[x][y]].update then
                        Tilemap.tileDict[Tilemap:getActiveScene().tiles[x][y]].update(Tilemap:getActiveScene(),x,y, sendTick)
                    end
                end
            end
           Tilemap.getActiveScene():update(dt)
        end
    end

    local shadowCasters = {}
    for i,curChar in pairs(Tilemap.getActiveScene().characters) do
        shadowCasters[#shadowCasters+1] = curChar.mesh
    end
    local obstacleMeshes = Tilemap.getActiveScene():getObstacleMeshes()
    for i,curObstacle in pairs(obstacleMeshes) do
        shadowCasters[#shadowCasters+1] = curObstacle
    end
    Lighting.update(dt, shadowCasters)
end

--- Returns the active Scene
function Tilemap.getActiveScene()
    return Tilemap.loadedScenes[Tilemap.activeSceneIndex]
end

--- pauses the game
function Tilemap.pause()
    Tilemap.paused = true
end

--- resumes the game
function Tilemap.resume()
    Tilemap.paused = false
end

--- toggle between paused and unpaused
function Tilemap.togglePause()
    Tilemap.paused = not Tilemap.paused
end

--- loads a map from file
--@param filepath path to the map you want to load
function Tilemap.loadMap(filepath)
    Tilemap.getActiveScene():loadMap(filepath)
    return Tilemap.loadedScenes[#Tilemap.loadedScenes]
end

--- adds a scene to the scene list
--@param sceneWidth Width of the scene to be created
--@param sceneHeight Height of the scene to be created
function Tilemap.addScene(sceneWidth, sceneHeight)
    Tilemap.loadedScenes[#Tilemap.loadedScenes+1] = Tilemap.Scene()
    Tilemap.activeSceneIndex = #Tilemap.loadedScenes
    return Tilemap:getActiveScene()
end
