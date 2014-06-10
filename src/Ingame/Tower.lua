require "Tilemap"

Ingame.Tower = {}
Utilities.OO.createDerivedClass(Ingame.Tower, Tilemap.Character)

function Ingame.Tower:new(apparentScene,x,y)
    Tilemap.Character.new(self,apparentScene,x,y)
    --self.mesh = Geometry.Mesh.createRectangle(x,y, Tilemap.Settings.tileSize*3/4, {0,0,0})
    self.mesh = Geometry.Mesh.createDiscoCircle(x,y, Tilemap.Settings.tileSize*3/4, 6, {0,0,0})
    self.mesh.reflectorSides = {}
end

function Ingame.Tower:update(dt)
    self.mesh.position[1] = self.x
    self.mesh.position[2] = self.y
end

function Ingame.Tower:render()
   self.mesh:render()
end
