---
--@classmod ReflectorTower
--@author Steve Wolligandt

require "Ingame.Tower"

Ingame.ReflectorTower = {}
Utilities.OO.createDerivedClass(Ingame.ReflectorTower, Tilemap.Tower)

function Ingame.ReflectorTower:new(apparentScene,x,y)
    Ingame.Tower.new(self,apparentScene,x,y)
    self.mesh = Geometry.Mesh.createDiscoCircle(x,y, Tilemap.Settings.playerSize*1.5, 8, {127,127,127})

    Ingame.ReflectorTowers[#Ingame.ReflectorTowers+1] = self
end

function Ingame.ReflectorTower:update(dt)
    self.mesh.position[1] = self.x
    self.mesh.position[2] = self.y

    --self:shake(dt)
end

function Ingame.ReflectorTower:render()
    self.mesh:render()
end
