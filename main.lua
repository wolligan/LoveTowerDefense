require "settings"
require "scene"
require "tileDict"
require "keys"
require "camera"
require "textOutput"

function love.load()
	success = love.window.setMode( 800, 600, {fullscreen=false} )
	Scene.createRandomLevel()
end

function love.draw()
	camera.begin()
	Scene.render()
	camera.stop()
	textOutput.draw()
end

function love.update(dt)
	for i,curChar in pairs(Scene.characters) do
		-- if i ~= Scene.playerIndex then
			curChar:AI_think(dt)
		-- end
	end
	keys.handleKeyBindings(dt)
	camera.update()
end