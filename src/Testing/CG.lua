--- ADD ME

require "Geometry"

Testing.CG = {}
Testing.CG.activeKeyBinding = {}
Testing.CG.activeKeyBinding["escape"] = {
    pressed = function()
        Game.changeState(Testing.Menu)
    end
}

Testing.CG.activeKeyBinding["mouse_left"] = {
    repeated = function()
        --Testing.CG.line1.point = {Testing.CoordinateSystem.getMouseCoordinates()}
        local mx,my = Testing.CoordinateSystem.getMouseCoordinates()
        Testing.CG.rect1 = {mx, mx+3, my, my+3}
    end
}

Testing.CG.activeKeyBinding["mouse_right"] = {
    repeated = function()
        --Testing.CG.lineseg1.point1 = {Testing.CoordinateSystem.getMouseCoordinates()}
        local mx,my = Testing.CoordinateSystem.getMouseCoordinates()
        Testing.CG.rect2 = {mx, mx+2, my, my+2}
    end
}


Testing.CG.activeKeyBinding["mouse_middle"] = {
    repeated = function()
        Testing.CG.lineseg1.point2 = {Testing.CoordinateSystem.getMouseCoordinates()}
    end
}

function Testing.CG.init()
    Testing.CoordinateSystem.translation = {love.graphics.getWidth()/10, love.graphics.getHeight()*9/10}
end

function Testing.CG.render()
    Testing.CoordinateSystem.beginTransform()
    Testing.CoordinateSystem.render()
    love.graphics.push()

    love.graphics.setColor(255,0,0)
    love.graphics.translate(10,7)
    love.graphics.scale(4,4)
    love.graphics.rotate(45*math.pi/180)
    love.graphics.rectangle("fill", 0,0,1,1)

    love.graphics.pop()
    Testing.CoordinateSystem.endTransform()
end

function Testing.CG.update(dt)

end
