--- Each Scene holds a camera that transforms the scene.
--@author Steve Wolligandt
--@classmod Camera

Tilemap.Camera = {}
Utilities.OO.createClass(Tilemap.Camera)

--- Constructor
--@param scene Scene that the camera shall transform
function Tilemap.Camera:new(scene)
    self.appropriateScene = scene
    self.rotation = 0
    self.target = nil
    self.x = self.appropriateScene:getLevelWidth()*Tilemap.Settings.tileSize/2
    self.y = self.appropriateScene:getLevelHeight()*Tilemap.Settings.tileSize/2
end

--- follow a character if specified or just show the centered map
function Tilemap.Camera:update()
	if self.target then
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
		self.x = Tilemap.getActiveScene().characters[Tilemap.getActiveScene().playerIndex].x
		self.y = Tilemap.getActiveScene().characters[Tilemap.getActiveScene().playerIndex].y
	end
end

--- call this before rendering the tilemap
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

--- call this after rendering the tilemap
function Tilemap.Camera:stop()
	love.graphics.pop()
end
