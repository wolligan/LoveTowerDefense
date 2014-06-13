--- Testing intersection
--@author Steve Wolligandt

require "Geometry"

Testing.Intersection = {}
Testing.Intersection.activeKeyBinding = {}
Testing.Intersection.activeKeyBinding["escape"] = {
    pressed = function()
        Game.changeState(Testing.Menu)
    end
}

Testing.Intersection.activeKeyBinding["mouse_left"] = {
    repeated = function()
        --Testing.Intersection.line1.point = {Testing.CoordinateSystem.getMouseCoordinates()}
        local mx,my = Testing.CoordinateSystem.getMouseCoordinates()
        Testing.Intersection.rect1 = {mx, mx+3, my, my+3}
    end
}

Testing.Intersection.activeKeyBinding["mouse_right"] = {
    repeated = function()
        --Testing.Intersection.lineseg1.point1 = {Testing.CoordinateSystem.getMouseCoordinates()}
        local mx,my = Testing.CoordinateSystem.getMouseCoordinates()
        Testing.Intersection.rect2 = {mx, mx+2, my, my+2}
    end
}


Testing.Intersection.activeKeyBinding["mouse_middle"] = {
    repeated = function()
        Testing.Intersection.lineseg1.point2 = {Testing.CoordinateSystem.getMouseCoordinates()}
    end
}

function Testing.Intersection.init()
    Testing.CoordinateSystem.translation = {love.graphics.getWidth()/10, love.graphics.getHeight()*9/10}
    local disco = Geometry.Mesh.createDiscoCircle(3,3, 1, 6)
    Testing.Intersection.line1 = {direction = {1,1}, point = {1,2}}
    Testing.Intersection.line2 = {direction = {1,-1}, point = {3,2}}
    Testing.Intersection.lineseg1 = {point1 = {1,0}, point2 = {2,1}}
    Testing.Intersection.rect1 = {2,5,2,5}
    Testing.Intersection.rect2 = {6,8,6,8}
    Testing.Intersection.polygon = disco:getWorldVertices()
    --Testing.Intersection.polygon = {2,2, 3,2, 3,3}
    Testing.Intersection.intersection = {}
    Testing.Intersection.update()
end

function Testing.Intersection.render()
    Testing.CoordinateSystem.beginTransform()
    Testing.CoordinateSystem.render()

    love.graphics.setColor(255,0,0)
    Testing.Intersection.drawPolygon(Testing.Intersection.polygon)
--[[
    -- draw line1
    love.graphics.setColor(255,0,0)
    Testing.Intersection.drawLine(Testing.Intersection.line1)

    love.graphics.setColor(0,0,255)
    -- draw line 2
    --Testing.Intersection.drawLine(Testing.Intersection.line2)

    -- draw lineseg1
    Testing.Intersection.drawLineseg(Testing.Intersection.lineseg1)

    -- draw intersection point
    love.graphics.setColor(0,255,0)

    if Testing.Intersection.intersection then
        love.graphics.point(Testing.Intersection.intersection[1], Testing.Intersection.intersection[2])
    end

    love.graphics.setColor(0,255,0)
    Testing.Intersection.drawRectangle(unpack(Testing.Intersection.rect1))
    Testing.Intersection.drawRectangle(unpack(Testing.Intersection.rect2))
    ]]

    Testing.CoordinateSystem.endTransform()
end

function Testing.Intersection.update(dt)

    local mx, my = Testing.CoordinateSystem.getMouseCoordinates()
    Testing.Intersection.intersection =  Utilities.Intersection.LineLineseg(    Testing.Intersection.line1.point[1], Testing.Intersection.line1.point[2], Testing.Intersection.line1.direction[1], Testing.Intersection.line1.direction[2],
                                                                                Testing.Intersection.lineseg1.point1[1], Testing.Intersection.lineseg1.point1[2], Testing.Intersection.lineseg1.point2[1], Testing.Intersection.lineseg1.point2[2])

    --Utilities.TextOutput.print(Utilities.Intersection.checkRectangleRectangle(  Testing.Intersection.rect1[1], Testing.Intersection.rect1[2], Testing.Intersection.rect1[3], Testing.Intersection.rect1[4],
    --                                                                            Testing.Intersection.rect2[1], Testing.Intersection.rect2[2], Testing.Intersection.rect2[3], Testing.Intersection.rect2[4]))
    Utilities.TextOutput.print(Utilities.Intersection.checkPointPolygon(mx, my, Testing.Intersection.polygon))
end

function Testing.Intersection.drawLine(line)
    love.graphics.line( line.point[1], line.point[2], line.point[1] + line.direction[1]*1000,  line.point[2] + line.direction[2]*1000)
    love.graphics.line( line.point[1], line.point[2], line.point[1] + line.direction[1]*-1000, line.point[2] + line.direction[2]*-1000)
    love.graphics.point(line.point[1], line.point[2])
end

function Testing.Intersection.drawLineseg(lineseg)
    love.graphics.line( lineseg.point1[1], lineseg.point1[2], lineseg.point2[1],  lineseg.point2[2])
    love.graphics.point(lineseg.point1[1], lineseg.point1[2])
    love.graphics.point(lineseg.point2[1], lineseg.point2[2])
end

function Testing.Intersection.drawRectangle(left, right, top, bottom)
    love.graphics.rectangle("fill", left, top, right-left, bottom-top)
end

function Testing.Intersection.drawPolygon(polygon)
    love.graphics.polygon("fill", polygon)
end
