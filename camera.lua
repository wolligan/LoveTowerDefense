camera = {}

camera.x = love.graphics.getWidth()*0.5
camera.y = love.graphics.getHeight()*0.5
camera.rotation = 0

function camera.update()
	if #Scene.characters > 0 then
		camera.x = math.min(math.max(love.graphics.getWidth() * 0.5, Scene.characters[Scene.playerIndex].x), 
                            #Scene.tiles    *tileSize - love.graphics.getWidth() * 0.5 )
		camera.y = math.min(math.max(love.graphics.getHeight()* 0.5, Scene.characters[Scene.playerIndex].y),
                            #Scene.tiles[1] *tileSize - love.graphics.getHeight()* 0.5 )
		--camera.x = Scene.characters[Scene.playerIndex].x
		--camera.y = Scene.characters[Scene.playerIndex].y
	end
end

function camera.begin()
	love.graphics.push()
	
	-- rotate around player
	love.graphics.translate(love.graphics.getWidth()*0.5, love.graphics.getHeight()*0.5)
	love.graphics.rotate(camera.rotation)
	love.graphics.translate(-love.graphics.getWidth()*0.5, -love.graphics.getHeight()*0.5)
	
	-- translate to player
	love.graphics.translate(	math.floor(love.graphics.getWidth() *0.5-camera.x), 
								math.floor(love.graphics.getHeight()*0.5-camera.y))
	--love.graphics.scale(1,0.2)
	love.graphics.shear(0,0)
end

function camera.stop()
	love.graphics.pop()
end