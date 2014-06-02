--- ADD ME
Tilemap = {}

require "Tilemap.Camera"
require "Tilemap.Character"
require "Tilemap.Scene"
require "Tilemap.Settings"
require "Tilemap.TileDict"

Tilemap.activeSceneIndex = 1
Tilemap.loadedScenes = {}
Tilemap.tickTime = 1
Tilemap.curTickTime = 0
Tilemap.paused = false


---
function Tilemap.init()
    Tilemap.loadedScenes[#Tilemap.loadedScenes + 1] = Tilemap.Scene()
    Tilemap.lastTime = love.timer.getTime()
end

---
function Tilemap.render()
	Tilemap.Camera.begin()
	Tilemap.getActiveScene():render()
	Tilemap.Camera.stop()
end

---
function Tilemap.update(dt)
    Tilemap.curTickTime = Tilemap.curTickTime + dt
    local sendTick = Tilemap.curTickTime >= Tilemap.tickTime
    if sendTick then
        Tilemap.curTickTime = Tilemap.tickTime - Tilemap.curTickTime
    end
    if (not Tilemap.paused) then
        for i,curChar in pairs(Tilemap.getActiveScene().characters) do
            if i ~= Tilemap.getActiveScene().playerIndex then
                curChar:AI_think(dt)
            end
        end

        for x = 1,Tilemap:getActiveScene():getLevelWidth() do
            for y = 1,Tilemap:getActiveScene():getLevelHeight() do
                if Tilemap.tileDict[Tilemap:getActiveScene().tiles[x][y]][6] then
                    Tilemap.tileDict[Tilemap:getActiveScene().tiles[x][y]][6](Tilemap:getActiveScene(),x,y, sendTick)
                end
            end
        end

	   Tilemap.Camera.update()
    end
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
