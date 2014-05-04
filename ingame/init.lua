Ingame = {}

require "ingame.settings"
require "ingame.scene"
require "ingame.tileDict"
require "ingame.camera"

Ingame.activeKeyBinding = KeyBindings.ingameKeyBinding
Ingame.activeSceneIndex = 0
Ingame.loadedScenes = {}
Ingame.paused = false

function Ingame.init()
    Ingame.activeSceneIndex = 1
    Ingame.loadedScenes[#Ingame.loadedScenes + 1] = Ingame.Scene()
    Ingame.loadedScenes[#Ingame.loadedScenes + 1] = Ingame.Scene()

    Ingame.loadedScenes[1]:createRandomLevel()
    Ingame.loadedScenes[2]:createRandomLevel()
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
