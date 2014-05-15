--- Comes up with some little helpers like a coordinate system, ...
Testing = {}
Testing.CoordinateSystem = {}
Testing.CoordinateSystem.zoom = 30
Testing.CoordinateSystem.translation = {love.graphics.getWidth()/10, love.graphics.getHeight()*9/10}

---
function Testing.CoordinateSystem.beginTransform()
    love.graphics.push()
    love.graphics.translate(unpack(Testing.CoordinateSystem.translation))
    love.graphics.scale(Testing.CoordinateSystem.zoom, -Testing.CoordinateSystem.zoom)
end

---
function Testing.CoordinateSystem.endTransform()
    love.graphics.pop()
end

---
function Testing.CoordinateSystem.render()
    love.graphics.setPointSize(1)
    love.graphics.setColor(255,255,255)
    for x=-100,100 do
        for y=-100,100 do
            love.graphics.point(x,y)
        end
    end

    love.graphics.line(0,0,100,0)
    love.graphics.line(0,0,0,100)

    love.graphics.setPointSize(10)
    love.graphics.point(0,0)
    love.graphics.setLineWidth(1/Testing.CoordinateSystem.zoom)
end


---
function Testing.CoordinateSystem.getMouseCoordinates()
    local x,y = love.mouse.getPosition()

    x = (x - Testing.CoordinateSystem.translation[1]) /  Testing.CoordinateSystem.zoom
    y = (y - Testing.CoordinateSystem.translation[2]) / -Testing.CoordinateSystem.zoom

    return x,y
end


require "Testing.Intersection"
require "Testing.Lighting"
require "Testing.Vector"
require "Testing.GUI"
require "Testing.SlicedSprite"
require "Testing.Menu"
require "Testing.Tilemap"
