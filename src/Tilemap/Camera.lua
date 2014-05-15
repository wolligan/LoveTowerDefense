--- ADD ME
Tilemap.Camera = {}

Tilemap.Camera.x = love.graphics.getWidth()*0.5
Tilemap.Camera.y = love.graphics.getHeight()*0.5
Tilemap.Camera.rotation = 0

---
function Tilemap.Camera.update()
	if #Tilemap.getActiveScene().characters > 0 then
		Tilemap.Camera.x = math.min(math.max(love.graphics.getWidth() * 0.5, Tilemap.getActiveScene().characters[Tilemap.getActiveScene().playerIndex].x),
                            #Tilemap.getActiveScene().tiles    *Tilemap.Settings.tileSize - love.graphics.getWidth() * 0.5 )
		Tilemap.Camera.y = math.min(math.max(love.graphics.getHeight()* 0.5, Tilemap.getActiveScene().characters[Tilemap.getActiveScene().playerIndex].y),
                            #Tilemap.getActiveScene().tiles[1] *Tilemap.Settings.tileSize - love.graphics.getHeight()* 0.5 )
		--camera.x = getActiveScene().characters[getActiveScene().playerIndex].x
		--camera.y = getActiveScene().characters[getActiveScene().playerIndex].y
	end
end

---
function Tilemap.Camera.begin()
	love.graphics.push()

	-- rotate around player
	love.graphics.translate(love.graphics.getWidth()*0.5, love.graphics.getHeight()*0.5)
	love.graphics.rotate(Tilemap.Camera.rotation)
	love.graphics.translate(-love.graphics.getWidth()*0.5, -love.graphics.getHeight()*0.5)

	-- translate to player
	love.graphics.translate(	math.floor(love.graphics.getWidth() *0.5-Tilemap.Camera.x),
								math.floor(love.graphics.getHeight()*0.5-Tilemap.Camera.y))
	--love.graphics.scale(1,0.2)
	love.graphics.shear(0,0)
end

---
function Tilemap.Camera.stop()
	love.graphics.pop()
end
