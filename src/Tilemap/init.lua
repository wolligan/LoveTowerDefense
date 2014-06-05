--- Renders and updates lighted tilemaps
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


---
function Tilemap.init()
    Tilemap.lastTime = love.timer.getTime()
    Lighting.init()
    Lighting.ambient = Lighting.AmbientLight(255,255,255)

    Lighting.drawUnlitBackground = function() Tilemap.getActiveScene():renderTiles() end
end

---
function Tilemap.render()
    Lighting.renderShadedScene()
    Tilemap.getActiveScene():renderCharacters()
    --Tilemap.renderActiveSceneTiles()
end

---
function Tilemap.update(dt)
    if #Tilemap.loadedScenes > 0 then
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

---
function Tilemap.getActiveScene()
    return Tilemap.loadedScenes[Tilemap.activeSceneIndex]
end

---
function Tilemap.pause()
    Tilemap.paused = true
end

---
function Tilemap.resume()
    Tilemap.paused = false
end

---
function Tilemap.togglePause()
    Tilemap.paused = not Tilemap.paused
end

function Tilemap.loadMap(filepath)
    Tilemap.getActiveScene():loadMap(filepath)
    return Tilemap.loadedScenes[#Tilemap.loadedScenes]
end

function Tilemap.addScene(sceneWidth, sceneHeight)
    Tilemap.loadedScenes[#Tilemap.loadedScenes+1] = Tilemap.Scene()
    Tilemap.activeSceneIndex = #Tilemap.loadedScenes
    return Tilemap:getActiveScene()
end
