require "OO"

Lighting.AmbientLight = {}
OO.createClass(Lighting.AmbientLight)

function Lighting.AmbientLight:new(r,g,b)
    self.color = {r or 255, g or 255, b or 255}
end

function Lighting.AmbientLight:render()
    love.graphics.setColor(self.color[1], self.color[2], self.color[3])
    love.graphics.draw(Lighting.unlitSceneCanvas)
end

function Lighting.AmbientLight:update(dt)

end
