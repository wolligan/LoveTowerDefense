Ingame = {}

require "ingame.settings"
require "ingame.scene"
require "ingame.tileDict"
require "ingame.camera"
require "ingame.lighting"

Ingame.activeKeyBinding = KeyBindings.IngameKeyBinding
Ingame.activeSceneIndex = 0
Ingame.loadedScenes = {}
Ingame.paused = false

function Ingame.init()
    Ingame.activeSceneIndex = 1
    for i=1,3 do
        Ingame.loadedScenes[#Ingame.loadedScenes + 1] = Ingame.Scene()
        Ingame.loadedScenes[i]:createRandomLevel()
    end
end

function Ingame.render()
	Ingame.Camera.begin()
	Ingame.getActiveScene():render()
	Ingame.Camera.stop()
end

function Ingame.update(dt)
    if (not Ingame.paused) then
        for i,curChar in pairs(Ingame.getActiveScene().characters) do
            if i ~= Ingame.getActiveScene().playerIndex then
                curChar:AI_think(dt)
            end
        end
	   Ingame.Camera.update()
    end
end

function Ingame.getActiveScene()
    return Ingame.loadedScenes[Ingame.activeSceneIndex]
end

function Ingame.pause()
    Ingame.paused = true
end

function Ingame.resume()
    Ingame.paused = false
end

function Ingame.togglePause()
    Ingame.paused = not Ingame.paused
end
