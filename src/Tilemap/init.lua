--- ADD ME
Tilemap = {}
Tilemap.activeSceneIndex = 0
Tilemap.loadedScenes = {}
Tilemap.paused = false


---
function Tilemap.init()
end

---
function Tilemap.render()
	Tilemap.Camera.begin()
	Tilemap.getActiveScene():render()
	Tilemap.Camera.stop()
end

---
function Tilemap.update(dt)
    if (not Tilemap.paused) then
        for i,curChar in pairs(Tilemap.getActiveScene().characters) do
            if i ~= Tilemap.getActiveScene().playerIndex then
                curChar:AI_think(dt)
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

require "Tilemap.Camera"
require "Tilemap.Character"
require "Tilemap.Scene"
require "Tilemap.Settings"
require "Tilemap.TileDict"
