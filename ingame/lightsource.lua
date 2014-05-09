require "OO"

Ingame.LightSource = {}
OO.createClass(Ingame.LightSource)

function Ingame.LightSource:new(x,y, r,g,b)
    self.position = {}
    self.position[1] = x or 0
    self.position[2] = y or 0

    self.shadows = {}
    self.reflections = {}

    self.enabled = true

    self.color = {r or 255, g or 255, b or 255}
end

--- renders light without shadows and reflections
function Ingame.LightSource:render()
    self:drawLight()

    self:drawReflections()
end

function Ingame.LightSource:renderCircle()
    love.graphics.setColor(unpack(self.color))
    love.graphics.circle( "fill", self.position[1], self.position[2], 10 )

    love.graphics.setColor(0,0,0)
    love.graphics.setLineWidth(1)
    love.graphics.circle( "line", self.position[1], self.position[2], 10 )
end

--- renders a fullscreen quad with inverted stencil with shadows
function Ingame.LightSource:drawLight()
    love.graphics.setInvertedStencil(function() self:drawShadows() end)

    love.graphics.setColor(unpack(self.color))
    love.graphics.rectangle("fill", 0,0,love.graphics.getWidth(), love.graphics.getHeight())

    love.graphics.setInvertedStencil(nil)
end

--- draws all shadow polygons of lightsource
function Ingame.LightSource:drawShadows()
    for i,curShadow in pairs(self.shadows) do
        love.graphics.polygon("fill", unpack(curShadow))
    end
end

function Ingame.LightSource:drawReflections()
    for i,curMeshReflections in pairs(self.reflections) do
        for j,curReflection in pairs(curMeshReflections) do
            curReflection:render()
        end
    end
end

function Ingame.LightSource:update(scene)
    self:updateShadows(scene)
    self:updateReflections(scene)
end

function Ingame.LightSource:updateShadows(scene)
    self.shadows = Ingame.Lighting.getShadowPolygonsOfScene(self, scene)
end

function Ingame.LightSource:updateReflections(scene)
    self.reflections = Ingame.Lighting.getReflectionPolygonsOfScene(self, scene)
    for i,curMeshReflections in pairs(self.reflections) do
        for j,curReflection in pairs(curMeshReflections) do
            curReflection:update(scene)
        end
    end
end
