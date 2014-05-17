--- ADD ME
Testing.Vector = {}

Testing.Vector.activeKeyBinding = {}
Testing.Vector.activeKeyBinding["escape"] = {
    pressed = function()
        Game.changeState(Testing.Menu)
    end
}

Testing.Vector.activeKeyBinding["mouse_left"] = {
    repeated = function()
        local mX, mY = Testing.CoordinateSystem.getMouseCoordinates()
        Testing.Vector.vec1 = {mX, mY}
    end
}

Testing.Vector.activeKeyBinding["mouse_right"] = {
    repeated = function()
        local mX, mY = Testing.CoordinateSystem.getMouseCoordinates()
        Testing.Vector.vec2 = {mX, mY}
    end
}

function Testing.Vector.init()
    Testing.CoordinateSystem.translation = {love.graphics.getWidth()/10, love.graphics.getHeight()*9/10}
    Testing.Vector.vec1 = {10,10}
    Testing.Vector.vec2 = {10,10}
end

function Testing.Vector.render()
    Testing.CoordinateSystem.beginTransform()
    Testing.CoordinateSystem.render()

    love.graphics.setColor(255,0,0)
    love.graphics.line(0,0, Testing.Vector.vec1[1], Testing.Vector.vec1[2])

    love.graphics.setColor(0,0,255)
    love.graphics.line(0,0, Testing.Vector.vec2[1], Testing.Vector.vec2[2])

    Testing.CoordinateSystem.endTransform()
end

function Testing.Vector.update(dt)
    Utilities.TextOutput.print(Utilities.Vector.getTurn(    Testing.Vector.vec1[1],
                                                            Testing.Vector.vec1[2],
                                                            Testing.Vector.vec2[1],
                                                            Testing.Vector.vec2[2]))
end
