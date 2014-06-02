--- ADD ME
Tilemap.Camera = {}

Tilemap.Camera.x = love.graphics.getWidth()*0.5
Tilemap.Camera.y = love.graphics.getHeight()*0.5
Tilemap.Camera.rotation = 0
Tilemap.Camera.target = nil

---
function Tilemap.Camera.update()
	if Tilemap.Camera.target then
        if not (love.graphics.getWidth() > Tilemap.getActiveScene():getLevelWidth()*Tilemap.Settings.tileSize) then
            Tilemap.Camera.x = math.min(math.max(love.graphics.getWidth() * 0.5, Tilemap.Camera.target.x),
                                #Tilemap.getActiveScene().tiles    *Tilemap.Settings.tileSize - love.graphics.getWidth() * 0.5 )
        else
            Tilemap.Camera.x = Tilemap.getActiveScene():getLevelWidth()*Tilemap.Settings.tileSize/2
        end
        if not (love.graphics.getHeight() > Tilemap.getActiveScene():getLevelHeight()*Tilemap.Settings.tileSize) then
            Tilemap.Camera.y = math.min(math.max(love.graphics.getHeight()* 0.5, Tilemap.Camera.target.y),
                               #Tilemap.getActiveScene().tiles[1] *Tilemap.Settings.tileSize - love.graphics.getHeight()* 0.5 )
        else
            Tilemap.Camera.y = Tilemap.getActiveScene():getLevelHeight()*Tilemap.Settings.tileSize/2
        end
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
