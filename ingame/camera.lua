
Ingame.Camera = {}

Ingame.Camera.x = love.graphics.getWidth()*0.5
Ingame.Camera.y = love.graphics.getHeight()*0.5
Ingame.Camera.rotation = 0

function Ingame.Camera.update()
	if #Ingame.Scene.characters > 0 then
		Ingame.Camera.x = math.min(math.max(love.graphics.getWidth() * 0.5, Ingame.Scene.characters[Ingame.Scene.playerIndex].x),
                            #Ingame.Scene.tiles    *Ingame.Settings.tileSize - love.graphics.getWidth() * 0.5 )
		Ingame.Camera.y = math.min(math.max(love.graphics.getHeight()* 0.5, Ingame.Scene.characters[Ingame.Scene.playerIndex].y),
                            #Ingame.Scene.tiles[1] *Ingame.Settings.tileSize - love.graphics.getHeight()* 0.5 )
		--camera.x = Scene.characters[Scene.playerIndex].x
		--camera.y = Scene.characters[Scene.playerIndex].y
	end
end

function Ingame.Camera.begin()
	love.graphics.push()

	-- rotate around player
	love.graphics.translate(love.graphics.getWidth()*0.5, love.graphics.getHeight()*0.5)
	love.graphics.rotate(Ingame.Camera.rotation)
	love.graphics.translate(-love.graphics.getWidth()*0.5, -love.graphics.getHeight()*0.5)

	-- translate to player
	love.graphics.translate(	math.floor(love.graphics.getWidth() *0.5-Ingame.Camera.x),
								math.floor(love.graphics.getHeight()*0.5-Ingame.Camera.y))
	--love.graphics.scale(1,0.2)
	love.graphics.shear(0,0)
end

function Ingame.Camera.stop()
	love.graphics.pop()
end
