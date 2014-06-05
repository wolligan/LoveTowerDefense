---
Tilemap.Camera = {}
Utilities.OO.createClass(Tilemap.Camera)

function Tilemap.Camera:new(scene,x,y)
    self.appropriateScene = scene
    self.x = x or love.graphics.getWidth()*0.5
    self.y = y or love.graphics.getHeight()*0.5
    self.rotation = 0
    self.target = nil
end

---
function Tilemap.Camera:update()
	--[[if self.target then
        if not (love.graphics.getWidth() > self.appropriateScene:getLevelWidth()*Tilemap.Settings.tileSize) then
            self.x = math.min(math.max(love.graphics.getWidth() * 0.5, self.target.x),
                                #self.appropriateScene.tiles    *Tilemap.Settings.tileSize - love.graphics.getWidth() * 0.5 )
        else
            self.x = self.appropriateScene:getLevelWidth()*Tilemap.Settings.tileSize/2
        end

        if not (love.graphics.getHeight() > self.appropriateScene:getLevelHeight()*Tilemap.Settings.tileSize) then
            self.y = math.min(math.max(love.graphics.getHeight()* 0.5, self.target.y),
                               #self.appropriateScene.tiles[1] *Tilemap.Settings.tileSize - love.graphics.getHeight()* 0.5 )
        else
            self.y = self.appropriateScene:getLevelHeight()*Tilemap.Settings.tileSize/2
        end
		--camera.x = getActiveScene().characters[getActiveScene().playerIndex].x
		--camera.y = getActiveScene().characters[getActiveScene().playerIndex].y
	end]]
end

---
function Tilemap.Camera:begin()
	love.graphics.push()

	-- rotate around player
	love.graphics.translate(love.graphics.getWidth()*0.5, love.graphics.getHeight()*0.5)
	love.graphics.rotate(self.rotation)
	love.graphics.translate(-love.graphics.getWidth()*0.5, -love.graphics.getHeight()*0.5)

	-- translate to player
	love.graphics.translate(	math.floor(love.graphics.getWidth() *0.5-self.x),
								math.floor(love.graphics.getHeight()*0.5-self.y))
	--love.graphics.scale(1,0.2)
	love.graphics.shear(0,0)
end

---
function Tilemap.Camera:stop()
	love.graphics.pop()
end
