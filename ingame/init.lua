Ingame = {}

require "ingame.settings"
require "ingame.scene"
require "ingame.tileDict"
require "ingame.camera"

Ingame.activeKeyBinding = KeyBindings.ingameKeyBinding

function Ingame.init()
    if not inited then
       Ingame.Scene.createRandomLevel()
    end
    Ingame.inited = true
end

function Ingame.render()
	Ingame.Camera.begin()
	Ingame.Scene.render()
	Ingame.Camera.stop()
end

function Ingame.update(dt)
	for i,curChar in pairs(Ingame.Scene.characters) do
        if i ~= Ingame.Scene.playerIndex then
			curChar:AI_think(dt)
        end
	end
	Ingame.Camera.update()
end
