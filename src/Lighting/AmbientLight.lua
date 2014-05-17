--- ADD ME

Lighting.AmbientLight = {}
Utilities.OO.createClass(Lighting.AmbientLight)

---
function Lighting.AmbientLight:new(r,g,b)
    self.color = {r or 255, g or 255, b or 255}
end

---
function Lighting.AmbientLight:render()
    love.graphics.setColor(self.color[1], self.color[2], self.color[3])
    love.graphics.draw(Lighting.unlitBackground)
    --love.graphics.rectangle("fill", 0,0,love.graphics.getWidth(),love.graphics.getHeight())
end

---
function Lighting.AmbientLight:update(dt)

end
