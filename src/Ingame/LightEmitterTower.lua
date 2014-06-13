---
--@classmod LightEmitterTower
--@author Steve Wolligandt

require "Ingame.Tower"

Ingame.LightEmitterTower = {}
Utilities.OO.createDerivedClass(Ingame.LightEmitterTower, Tilemap.Tower)

function Ingame.LightEmitterTower:new(apparentScene,x,y)
    Ingame.Tower.new(self,apparentScene,x,y)
    self.lightSource = Lighting.LightSource(self.x, self.y, math.random(1,5)*10,math.random(1,5)*10,math.random(1,5)*10, 100)
    Lighting.lights[#Lighting.lights+1] = self.lightSource

    self.maxShakiness = 0.5
    self.shakiness = {0,0}
    self.shakinessFactor = 40
    Ingame.lightEmitterTowers[#Ingame.lightEmitterTowers+1] = self
end

function Ingame.LightEmitterTower:shake(dt)
    self.shakiness[1] = self.shakiness[1] + math.random(-self.shakinessFactor,self.shakinessFactor)*dt
    self.shakiness[2] = self.shakiness[2] + math.random(-self.shakinessFactor,self.shakinessFactor)*dt

    if Utilities.Vector.length(self.shakiness[1], self.shakiness[2]) > self.maxShakiness then
        self.shakiness[1], self.shakiness[2] = Utilities.Vector.normalize(self.shakiness[1],self.shakiness[2])
        self.shakiness[1] = self.shakiness[1] * self.maxShakiness
        self.shakiness[2] = self.shakiness[2] * self.maxShakiness
    end

    self.lightSource.position[1] = self.x + self.shakiness[1]
    self.lightSource.position[2] = self.y + self.shakiness[2]
end

function Ingame.LightEmitterTower:update(dt)
    self.mesh.position[1] = self.x
    self.mesh.position[2] = self.y

    --self:shake(dt)
end

function Ingame.LightEmitterTower:render()
    love.graphics.setColor(0,0,0)
    --love.graphics.rectangle("fill", self.x - Tilemap.Settings.tileSize*3/4, self.y - Tilemap.Settings.tileSize*3/4, Tilemap.Settings.tileSize*3/2, Tilemap.Settings.tileSize*3/2)
    --self.mesh:render()
    local size =  Tilemap.Settings.tileSize*3/2 + 2
    love.graphics.draw( Game.getSprite("assets/sprites/Ingame/lightemittertower.png"),
                        self.x-size/2,
                        self.y-size/2,0,
                        (size)/Game.getSprite("assets/sprites/Ingame/lightemittertower.png"):getWidth(),
                        (size)/Game.getSprite("assets/sprites/Ingame/lightemittertower.png"):getHeight())

    love.graphics.setColor( self.lightSource.color[1]*3,
                            self.lightSource.color[2]*3,
                            self.lightSource.color[3]*3)

    love.graphics.draw( Game.getSprite("assets/sprites/Ingame/circle.png"), self.x - (Tilemap.Settings.tileSize)/2, self.y - (Tilemap.Settings.tileSize)/2, 0,
                        (Tilemap.Settings.tileSize)/Game.getSprite("assets/sprites/Ingame/circle.png"):getWidth(),
                        (Tilemap.Settings.tileSize)/Game.getSprite("assets/sprites/Ingame/circle.png"):getHeight())
end
