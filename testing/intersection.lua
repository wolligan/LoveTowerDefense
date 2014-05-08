require "intersection"
require "textOutput"

Testing.Intersection = {}
Testing.Intersection.activeKeyBinding = {}

Testing.Intersection.activeKeyBinding["escape"] = {
    mode = "single",
    fun = function()
        love.event.push("quit")
    end
}

Testing.Intersection.activeKeyBinding["mouse_left"] = {
    mode = "repeat",
    fun = function()
        Testing.Intersection.line1.point = {Testing.CoordinateSystem.getMouseCoordinates()}
    end
}

Testing.Intersection.activeKeyBinding["mouse_right"] = {
    mode = "repeat",
    fun = function()
        Testing.Intersection.lineseg1.point1 = {Testing.CoordinateSystem.getMouseCoordinates()}
    end
}


Testing.Intersection.activeKeyBinding["mouse_middle"] = {
    mode = "repeat",
    fun = function()
        Testing.Intersection.lineseg1.point2 = {Testing.CoordinateSystem.getMouseCoordinates()}
    end
}

function Testing.Intersection.init()
    Testing.CoordinateSystem.translation = {love.graphics.getWidth()/10, love.graphics.getHeight()*9/10}

    Testing.Intersection.line1 = {direction = {1,1}, point = {1,2}}
    Testing.Intersection.line2 = {direction = {1,-1}, point = {3,2}}
    Testing.Intersection.lineseg1 = {point1 = {1,0}, point2 = {2,1}}
    Testing.Intersection.intersection = {}
    Testing.Intersection.update()
end

function Testing.Intersection.render()
    Testing.CoordinateSystem.beginTransform()
    Testing.CoordinateSystem.render()

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

    Testing.CoordinateSystem.endTransform()
end

function Testing.Intersection.update(dt)

    Testing.Intersection.intersection =  Intersection.LineLineseg(  Testing.Intersection.line1.point[1], Testing.Intersection.line1.point[2], Testing.Intersection.line1.direction[1], Testing.Intersection.line1.direction[2],
                                                                    Testing.Intersection.lineseg1.point1[1], Testing.Intersection.lineseg1.point1[2], Testing.Intersection.lineseg1.point2[1], Testing.Intersection.lineseg1.point2[2])
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
